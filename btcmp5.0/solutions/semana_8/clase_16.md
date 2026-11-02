# Semana 8 · Clase 16 · Solución — Dashboard completo en Metabase

> 📝 **Consigna:** [Tarea Clase 16](../../tasks/semana_8/clase_16.md)
>
> El SQL de cada question está en la [Clase 16](../../notes/semana_8/clase_16.md). Acá queda el armado esperado del dashboard.

---

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

- [ ] Están las 4 pestañas con sus questions.
- [ ] Los filtros del dashboard cambian los KPIs y las tendencias.
- [ ] Sin filtro de categoría/año, las tendencias muestran el total (filtros opcionales con `[[ ... ]]`).
- [ ] El mapa pinta Estados Unidos y Reino Unido (uso del `CASE`).
- [ ] Cada gráfico tiene título descriptivo y ejes legibles.
