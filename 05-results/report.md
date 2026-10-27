# Reporte — SQL: SELECT & JOINS

## Pregunta de negocio

¿Cómo se distribuyen los ingresos y el margen estimado por categoría y canal, y cómo se puede enriquecer el análisis con el catálogo sin duplicar ventas?

## KPIs

| KPI | Resultado |
|---|---:|
| Pedidos | 3.500 |
| Productos en catálogo | 500 |
| Clientes únicos | 877 |
| Unidades vendidas | 10.602 |
| Ingresos netos | 608.810,14 |
| Costo estimado | 364.075,27 |
| Margen bruto estimado | 244.734,87 |
| Tasa de margen estimada | 40,20% |
| Ingreso medio por pedido | 173,95 |

## Insights

1. Infantil es la categoría con mayor ingreso (105.711,81; 17,36%), seguida por OTC (104.438,16; 17,16%) y Perfumería (103.784,47; 17,05%). Las tres categorías suman aproximadamente 51,56% de los ingresos.
2. Paid Social lidera los ingresos por canal con 95.217,15, seguido muy de cerca por Email con 94.856,04. La diferencia es pequeña y no debe interpretarse como una ventaja significativa.
3. La tasa de margen estimada global es 40,20%. El cálculo es `net_revenue - cost` y no incluye costos operativos ni de adquisición.
4. El catálogo contiene 500 productos y sus categorías cubren las seis categorías de ventas.

## Ejemplo de JOIN correcto

Las ventas se agregan primero por categoría y el catálogo se agrega por categoría. Después se unen ambos resultados. Así, cada categoría aparece una sola vez y la suma de ingresos después del JOIN coincide con la suma original de ventas: 608.810,14.

Un JOIN directo `sales.category = products.category` a nivel de fila multiplicaría cada venta por la cantidad de productos de su categoría. Eso inflaría las métricas.

## Calidad y validación

- Los cinco queries se ejecutan en SQLite.
- Las consultas Q01, Q04 y Q05 mantienen el total de ingresos esperado.
- El test automatizado comprueba que las consultas de JOIN devuelvan seis categorías y no dupliquen ingresos.
- GitHub Actions ejecuta el runner y las pruebas en cada push y pull request.

## Recomendaciones

- Agregar `product_id` al dataset de ventas para analizar ventas por producto de manera exacta.
- Incorporar una dimensión de pedidos e ítems si un pedido puede contener múltiples productos.
- En un caso real, calcular margen después de costos de marketing y operativos.
- Agregar pruebas para nuevas consultas cuando se modifique el esquema o el dataset.

## Limitaciones

- Dataset sintético; los resultados no describen una empresa real.
- El archivo de ventas no contiene `product_id`, por lo que la relación con el catálogo solo es válida a nivel de categoría.
- El margen es una aproximación y no equivale a beneficio neto.
- Los importes no representan una moneda real.
