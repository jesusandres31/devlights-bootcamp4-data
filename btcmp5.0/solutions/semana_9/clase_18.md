# Semana 9 · Clase 18 · Solución — Análisis de Northwind en Colab

> 📝 **Consigna:** [Tarea Clase 18](../../tasks/semana_9/clase_18.md)

---

## Parte 1: Replicar la clase

Es el código de la [Clase 18](../../notes/semana_9/clase_18.md), celda por celda. Control: `ventas.shape` → `(2155, 16)`.

## Parte 2: Análisis nuevos

```python
# 4. Ventas por categoría
por_categoria = (
    ventas.groupby("category_name")["total_amount"].sum()
    .sort_values(ascending=False)
)

por_categoria.plot(kind="bar", figsize=(10, 5), title="Ventas por categoría", ylabel="Ventas ($)", rot=45)
plt.tight_layout()
plt.show()
```

```python
# 5. Cantidad de pedidos por año
#    nunique: un pedido tiene varias líneas, hay que contar order_id distintos
(
    ventas.groupby("year")["order_id"].nunique()
    .plot(kind="bar", figsize=(6, 4), title="Pedidos por año", ylabel="Pedidos", rot=0)
)
plt.tight_layout()
plt.show()
```

Resultado: 1996 → 152, 1997 → 408, 1998 → 270 (1998 está incompleto: llega hasta mayo).

```python
# 6. Ticket promedio de los 10 países que más compran
por_pais = ventas.groupby("country").agg(
    total_sales=("total_amount", "sum"),
    orders=("order_id", "nunique"),
)
por_pais["avg_ticket"] = (por_pais["total_sales"] / por_pais["orders"]).round(2)

por_pais.sort_values("total_sales", ascending=False).head(10)
```

```python
# 7. ⭐ Lo mismo con el esquema estrella
fact_sales = pd.read_csv(RUTA + "fact_sales.csv")
dim_product = pd.read_csv(RUTA + "dim_product.csv")

por_categoria_estrella = (
    fact_sales
    .merge(dim_product, on="product_id")
    .groupby("category_name")["total_amount"].sum()
    .sort_values(ascending=False)
)

# Comparar: True si son iguales (round evita diferencias mínimas de decimales)
por_categoria.round(2).equals(por_categoria_estrella.round(2))
```

## 8. Conclusiones de ejemplo

- **Categorías:** Beverages es la que más vende, seguida de Dairy Products.
- **Pedidos por año:** 1997 es el único año completo; 1996 arranca en julio y 1998 se corta en mayo.
- **Ticket promedio:** Austria tiene el ticket más alto entre los países que más compran.
