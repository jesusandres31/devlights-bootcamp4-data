# Semana 8 · Clase 16 · Solución — Gráficos y dashboard en Metabase

> 📝 **Consigna:** [Tarea Clase 16](../../tasks/semana_8/clase_16.md)
>
> El SQL de cada question está en la [Clase 15](../../notes/semana_8/clase_15.md#-6-consultas-analíticas) (Parte 1) y en la [Clase 16](../../notes/semana_8/clase_16.md) (Parte 2). Acá queda el armado esperado.

---

## 📝 Parte 1: Primeros gráficos

| #  | Consulta de la Clase 15       | Visualización        | Eje X / dimensión   | Eje Y / métrica |
| -- | ----------------------------- | -------------------- | ------------------- | --------------- |
| a) | Ventas totales por producto   | Row (barras horiz.)  | `product_name`      | `total_sales`   |
| b) | Ventas por país del cliente   | Map (Region map → World) o Bar | `country` | `total_sales`   |
| c) | Ventas por empleado           | Bar                  | `employee_name`     | `total_sales`   |
| d) | Ventas mensuales              | Line                 | `year` + `month`    | `total_sales`   |
| e) | Top 10 clientes               | Row                  | `customer`          | `total_sales`   |
| f) | Ventas por empresa de envío   | Pie o Bar            | `shipper_name`      | `total_sales`   |

> 💡 Para el mapa, Metabase espera nombres de país en inglés completo: `USA` y `UK` no se pintan. Se resuelve con un `CASE` (ver [Clase 16 → Preparar datos para un mapa](../../notes/semana_8/clase_16.md#-preparar-datos-para-un-mapa)).

## 📝 Parte 2: Dashboard

| Tab          | Question                          | Visualización             | Filtros conectados          |
| ------------ | --------------------------------- | ------------------------- | --------------------------- |
| KPIs         | A) Ventas totales                 | Number                    | `start_date`, `end_date`    |
| KPIs         | B) Cantidad de órdenes            | Number                    | `start_date`, `end_date`    |
| KPIs         | C) Ticket promedio                | Number (formato moneda)   | `start_date`, `end_date`    |
| Tendencias   | A) Ventas anuales                 | Bar o Line                | `category`                  |
| Tendencias   | B) Órdenes anuales                | Bar o Line                | `category`                  |
| Tendencias   | C) Ventas por mes de un año       | Line                      | `category`, `year`          |
| Ranking      | A) Top 10 clientes                | Row                       | —                           |
| Ranking      | B) Ranking de vendedores          | Bar o Table               | —                           |
| Ranking      | C) Top 10 productos               | Row                       | —                           |
| Segmentación | A) Ventas por país                | Map → Region map → World  | —                           |

## ✔️ Checklist de corrección

- [ ] Metabase conectado a `northwind` con host `postgres-db`.
- [ ] Están los 6 gráficos de la Parte 1 con la visualización adecuada.
- [ ] Están las 4 pestañas con sus questions.
- [ ] Los filtros del dashboard cambian los KPIs y las tendencias.
- [ ] Sin filtro de categoría/año, las tendencias muestran el total (filtros opcionales con `[[ ... ]]`).
- [ ] El mapa pinta Estados Unidos y Reino Unido (uso del `CASE`).
- [ ] Cada gráfico tiene título descriptivo y ejes legibles.
