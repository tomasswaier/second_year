WITH team_names AS (
  SELECT
    team_id,
    city || ' ' || nickname AS team_name,
    (year_founded || '-07-01')::DATE AS valid_from,
    CASE
      WHEN year_active_till = 2019 THEN 'infinity'::DATE
      ELSE (year_active_till || '-07-01')::DATE
    END AS valid_until
  FROM team_history
), expanded_games AS (
  SELECT
    g.id AS game_id,
    g.game_date,
    UNNEST(ARRAY[g.home_team_id, g.away_team_id]) AS team_id,
    UNNEST(ARRAY[0, 1]) AS match_type
  FROM games g
), valid_team_games AS (
  SELECT
    eg.game_id,
    eg.team_id,
    eg.match_type,
    tn.team_name
  FROM expanded_games eg
  JOIN team_names tn ON
    eg.team_id = tn.team_id
    AND eg.game_date BETWEEN tn.valid_from AND tn.valid_until
)
SELECT
  team_id,
  team_name,
  COUNT(*) FILTER (WHERE match_type = 1) AS number_away_matches,
  ROUND(
    COUNT(*) FILTER (WHERE match_type = 1) * 100.0 / 
    NULLIF(COUNT(*), 0), 2
  ) AS percentage_away_matches,
  COUNT(*) FILTER (WHERE match_type = 0) AS number_home_matches,
  ROUND(
    COUNT(*) FILTER (WHERE match_type = 0) * 100.0 / 
    NULLIF(COUNT(*), 0), 2
  ) AS percentage_home_matches,
  COUNT(*) AS total_games
FROM valid_team_games
GROUP BY team_id, team_name
ORDER BY team_id, team_name;