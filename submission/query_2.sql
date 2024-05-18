INSERT INTO
  aleemrahil84520.actors
  --data for last year
WITH
  last_year AS (
    SELECT
      actor,
      actor_id,
      films,
      quality_class,
      is_active,
      current_year
    FROM
      aleemrahil84520.actors
    WHERE
      current_year = 2002
  ),
  --data for current year
  this_year AS (
    SELECT
      actor,
      actor_id,
      ARRAY_AGG(ROW(film, votes, rating, film_id)) AS films,
      CASE
        WHEN AVG(rating) > 8 THEN 'star'
        WHEN AVG(rating) > 7 THEN 'good'
        WHEN AVG(rating) > 6 THEN 'average'
        ELSE 'bad'
      END AS quality_class,
      TRUE AS is_active,
      YEAR AS current_year
    FROM
      bootcamp.actor_films
    WHERE
      YEAR = 2003
    GROUP BY
      actor,
      actor_id,
      YEAR
  )
SELECT
  -- coalesce SCD 0 type columns
  COALESCE(ty.actor, ly.actor) AS actor,
  COALESCE(ty.actor_id, ly.actor_id) AS actor_id, 
  -- 3 cases (both ts, ls exist, only ts exist, only ls exist)
  CASE
    WHEN ty.is_active
    AND ly.is_active THEN ly.films || ty.films
    WHEN ty.is_active
    AND NOT ly.is_active THEN ty.films
    WHEN NOT ty.is_active
    AND ly.is_active THEN ly.films
    WHEN ty.is_active
    AND ly.is_active IS NULL THEN ty.films
  END AS films,
  COALESCE(ty.quality_class, ly.quality_class) AS quality_class,
  CASE
    WHEN ty.is_active IS NULL THEN FALSE
    WHEN ty.current_year IS NOT NULL THEN TRUE
  END AS is_active,
  ty.current_year
FROM
  this_year ty
  FULL OUTER JOIN last_year ly ON ty.actor_id = ly.actor_id
