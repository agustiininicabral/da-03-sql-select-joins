# SQL: SELECT & JOINS

Proyecto de portfolio para practicar consultas SQL, agregaciones y joins con un dataset sintético de ventas y catálogo de productos.

![SQL CI](https://github.com/agustiininicabral/da-03-sql-select-joins/actions/workflows/ci.yml/badge.svg)

## Dataset

- `02-data/raw/sales.csv`: 3.500 pedidos.
- `02-data/raw/products.csv`: catálogo de 500 productos.
- `02-data/raw/DATA_DICTIONARY.md`: definición de columnas y limitaciones.

Los datos son ficticios. El runner usa SQLite en memoria, así que no instala ni modifica una base de datos persistente.

## Ejecutar en Windows PowerShell

Desde la raíz del repositorio:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements-dev.txt
python scripts/run_sql.py
python -m pytest -q
ruff format --check scripts tests
ruff check scripts tests
```

El runner carga los CSV a tablas temporales `sales` y `products`, ejecuta cada consulta identificada por un comentario `-- QUERY:` y muestra la cantidad de filas devueltas. GitHub Actions ejecuta las mismas pruebas en cada push y pull request.

## Consultas

1. Top categorías por ingresos netos.
2. Margen bruto estimado por canal.
3. Clientes con mayor ingreso acumulado (proxy de LTV).
4. `INNER JOIN` entre ventas agregadas y catálogo agregado por categoría.
5. `LEFT JOIN` entre categorías del catálogo y métricas de ventas.

**Importante:** `sales.csv` no contiene `product_id`; solo comparte `category` con el catálogo. Por eso, las consultas agregan ambas tablas por categoría antes de unirlas. Un join directo entre cada venta y cada producto de la misma categoría multiplicaría las ventas y produciría ingresos incorrectos.

## Resultados del dataset

Ver [05-results/report.md](05-results/report.md) para KPIs, ejemplos de JOIN, validación de resultados y limitaciones. Los importes son unidades monetarias sintéticas, no una moneda real.

## Estructura

- `01-requirements/`: preguntas e hipótesis.
- `02-data/raw/`: CSV originales y diccionario.
- `03-work/sql/`: instrucciones y consultas.
- `scripts/run_sql.py`: carga temporal y ejecución de consultas.
- `tests/test_sql_runner.py`: pruebas de ejecución y prevención de duplicación de ingresos.
- `05-results/report.md`: hallazgos y recomendaciones.

## Licencia

MIT.
