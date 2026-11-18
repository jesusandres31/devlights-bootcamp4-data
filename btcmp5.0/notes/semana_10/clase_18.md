# Semana 9 · Clase 18 — Análisis y gráficos con pandas y matplotlib en Google Colab

> 🎯 **Objetivo:** analizar Northwind con **Python**: leer los CSV que generamos con PySpark en la [Clase 17](clase_17.md), explorarlos con **pandas** y hacer los mismos gráficos que armamos en Metabase, ahora con **matplotlib**.
>
> 📝 **Tarea:** [Tarea Clase 18 — Análisis de Northwind en Colab](../../tasks/semana_9/clase_18.md)

---

## 🧩 1. Google Colab

[Google Colab](https://colab.research.google.com) es un **notebook de Python en el navegador**: no hay que instalar nada y ya trae pandas y matplotlib.

- **Archivo → Nuevo notebook** (se guarda en la carpeta *Colab Notebooks* de tu Drive).
- Un notebook tiene **celdas**:
  - **Código**: se ejecuta con `Shift + Enter` y el resultado aparece debajo.
  - **Texto**: para títulos y explicaciones (Markdown).
- Las variables quedan en memoria entre celdas, **en el orden en que se ejecutaron**. Si algo falla raro: **Entorno de ejecución → Reiniciar y ejecutar todo**.

---

## 🧩 2. Leer los CSV desde Google Drive

Requisito: la carpeta **`northwind_csv`** en **Mi unidad** con los 7 CSV de la Clase 17.

```python
from google.colab import drive
drive.mount("/content/drive")   # pide permiso para acceder a tu Drive
```

```python
import pandas as pd
import matplotlib.pyplot as plt

RUTA = "/content/drive/MyDrive/northwind_csv/"

ventas = pd.read_csv(RUTA + "ventas_flat.csv", parse_dates=["order_date"])
```

> 💡 `parse_dates` le avisa a pandas que esa columna es una fecha (si no, la lee como texto).
>
> 💡 **Alternativa sin Drive:** en el panel izquierdo, ícono de carpeta 📁 → **Subir**, y usar `RUTA = "/content/"`. Ojo: esos archivos se borran al cerrar la sesión.

---

## 🧩 3. Explorar con pandas

Un **DataFrame** de pandas es una tabla en memoria, como el resultado de un `SELECT`.

### 👀 Primer vistazo

```python
ventas.head()        # primeras 5 filas
```

```python
ventas.shape         # (filas, columnas) → (2155, 16)
```

```python
ventas.info()        # columnas, tipos y valores nulos
```

```python
ventas.describe()    # estadísticas de las columnas numéricas
```

### 🔎 Seleccionar, filtrar y ordenar

| SQL                                          | pandas                                                 |
| -------------------------------------------- | ------------------------------------------------------ |
| `SELECT customer, total_amount`              | `ventas[["customer", "total_amount"]]`                 |
| `WHERE country = 'Germany'`                  | `ventas[ventas["country"] == "Germany"]`               |
| `WHERE country = 'Germany' AND total_amount > 1000` | `ventas[(ventas["country"] == "Germany") & (ventas["total_amount"] > 1000)]` |
| `ORDER BY total_amount DESC LIMIT 10`        | `ventas.sort_values("total_amount", ascending=False).head(10)` |
| `SELECT DISTINCT country`                    | `ventas["country"].unique()`                           |
| `GROUP BY a` + `SUM(b)`                      | `ventas.groupby("a")["b"].sum()`                       |
| `JOIN ... USING (id)`                        | `df1.merge(df2, on="id")`                              |

```python
# Ventas a Alemania mayores a 1000
ventas[(ventas["country"] == "Germany") & (ventas["total_amount"] > 1000)]
```

```python
# Las 10 líneas de pedido más grandes
ventas.sort_values("total_amount", ascending=False).head(10)
```

```python
# ¿De cuántos países son los clientes?
ventas["country"].nunique()
```

### 📊 Agrupar

```python
# Ventas por categoría
ventas.groupby("category_name")["total_amount"].sum().sort_values(ascending=False)
```

```python
# Varias métricas a la vez: total vendido y cantidad de pedidos por país
por_pais = ventas.groupby("country").agg(
    total_sales=("total_amount", "sum"),
    orders=("order_id", "nunique"),       # nunique = COUNT(DISTINCT ...)
)
por_pais.sort_values("total_sales", ascending=False).head(10)
```

### ⭐ Lo mismo con el esquema estrella (`merge`)

`ventas_flat` ya tiene todo junto. Con las tablas del esquema estrella hay que unirlas, igual que en SQL:

```python
fact_sales = pd.read_csv(RUTA + "fact_sales.csv")
dim_product = pd.read_csv(RUTA + "dim_product.csv")

(
    fact_sales
    .merge(dim_product, on="product_id")
    .groupby("category_name")["total_amount"].sum()
    .sort_values(ascending=False)
)
```

👉 Mismo resultado que con `ventas_flat`.

---

## 🧩 4. Gráficos con matplotlib

Los mismos 6 gráficos que hicimos en Metabase en la [Clase 16](../semana_8/clase_16.md#-3-primeros-gráficos).

### a) Top 10 productos: matplotlib "a mano"

Primero preparamos los datos, después dibujamos:

```python
top_productos = (
    ventas.groupby("product_name")["total_amount"].sum()
    .sort_values(ascending=False)
    .head(10)
)

plt.figure(figsize=(10, 5))                                # tamaño del gráfico
plt.barh(top_productos.index, top_productos.values)        # barras horizontales
plt.gca().invert_yaxis()                                   # el más vendido arriba
plt.title("Top 10 productos por ventas")
plt.xlabel("Ventas ($)")
plt.tight_layout()
plt.show()
```

### b) Ventas por país: con `.plot()` de pandas

pandas tiene un atajo: `.plot(kind=...)` usa matplotlib por debajo.

```python
(
    ventas.groupby("country")["total_amount"].sum()
    .sort_values(ascending=False)
    .plot(kind="bar", figsize=(12, 5), title="Ventas por país del cliente", ylabel="Ventas ($)")
)
plt.tight_layout()
plt.show()
```

### c) Ventas por empleado

```python
(
    ventas.groupby("employee_name")["total_amount"].sum()
    .sort_values(ascending=False)
    .plot(kind="bar", figsize=(10, 5), title="Ventas por empleado", ylabel="Ventas ($)", rot=45)
)
plt.tight_layout()
plt.show()
```

### d) Ventas mensuales

`resample("MS")` agrupa por mes a partir de una columna de fecha (`MS` = *month start*):

```python
mensual = ventas.resample("MS", on="order_date")["total_amount"].sum()

mensual.plot(kind="line", marker="o", figsize=(12, 5), title="Ventas mensuales", ylabel="Ventas ($)")
plt.tight_layout()
plt.show()
```

> 💡 La caída del final no es real: los datos terminan a principios de mayo de 1998, así que ese mes está incompleto. Para sacarlo: `mensual.iloc[:-1]`.

### e) Top 10 clientes

```python
(
    ventas.groupby("customer")["total_amount"].sum()
    .sort_values()          # de menor a mayor: con barh, el más grande queda arriba
    .tail(10)
    .plot(kind="barh", figsize=(10, 5), title="Top 10 clientes por ventas", xlabel="Ventas ($)")
)
plt.tight_layout()
plt.show()
```

### f) Ventas por empresa de envío

Son solo 3 empresas: una torta se lee bien.

```python
(
    ventas.groupby("shipper_name")["total_amount"].sum()
    .plot(kind="pie", autopct="%1.1f%%", figsize=(6, 6), title="Ventas por empresa de envío", ylabel="")
)
plt.show()
```

> 💡 `autopct="%1.1f%%"` muestra el porcentaje de cada porción con un decimal.

---

## 🧩 5. SQL, Metabase o Python: ¿cuándo uso cada uno?

| Herramienta          | Ventaja                                                      | Ideal para                                     |
| -------------------- | ------------------------------------------------------------ | ---------------------------------------------- |
| **SQL** (Postgres)   | Los datos están ahí, rápido y exacto                         | Consultas, preparar datos, modelos (CTAS)      |
| **Metabase** (BI)    | Dashboards con filtros, sin programar, para compartir        | Que el negocio consulte los datos solo         |
| **Python** (pandas)  | Control total: limpiar, combinar fuentes, estadística, ML    | Análisis a medida, automatizar, ciencia de datos |
| **PySpark**          | Escala a millones de filas en muchas máquinas                | Pipelines ETL con muchos datos                 |
