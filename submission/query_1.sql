CREATE TABLE aleemrahil84520.actors (
    actor VARCHAR,
    actor_id VARCHAR,
    films ARRAY<STRUCT<
        film: VARCHAR,
        votes: INTEGER,
        rating: INTEGER,
        film_id: VARCHAR
    >>,
    quality_class VARCHAR,
    is_active BOOLEAN,
    current_year INTEGER
)
with (
format = 'parquet',
partitioning = array['current_year'])
