from __future__ import annotations

import sqlite3

import pytest

from scripts.run_sql import execute_queries, run_queries


def test_all_sql_examples_execute_and_joins_preserve_revenue() -> None:
    results = run_queries()

    assert len(results) == 5
    assert all(
        name.startswith(f"Q{index:02d}") for index, name in enumerate(results, 1)
    )

    top_categories = next(
        rows for name, rows in results.items() if name.startswith("Q01")
    )
    inner_join = next(
        rows for name, rows in results.items() if name.startswith("Q04")
    )
    left_join = next(
        rows for name, rows in results.items() if name.startswith("Q05")
    )

    assert len(top_categories) == 6
    assert len(inner_join) == 6
    assert len(left_join) == 6

    total_revenue = sum(float(row["revenue"]) for row in top_categories)
    inner_join_revenue = sum(float(row["revenue"]) for row in inner_join)
    left_join_revenue = sum(float(row["revenue"]) for row in left_join)
    assert total_revenue == pytest.approx(608810.14, abs=0.01)
    assert inner_join_revenue == pytest.approx(total_revenue, abs=0.01)
    assert left_join_revenue == pytest.approx(total_revenue, abs=0.01)


def test_query_runner_rejects_unnamed_statements() -> None:
    with sqlite3.connect(":memory:") as connection:
        with pytest.raises(ValueError, match="must start with"):
            execute_queries(connection, "SELECT 1;")
