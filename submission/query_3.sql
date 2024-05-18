CREATE OR REPLACE TABLE aleemrahil84520.actors_history_scd (
    actor VARCHAR,
    quality_class VARCHAR,
    is_active BOOLEAN,
    start_date DATE,
    end_date DATE,
    current_year INTEGER
)
with (
format = 'parquet',
partitioning = array['current_year'])
