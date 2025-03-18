with meowkity as (select count(team_id) as count from team_history group by team_id)select * from meowkity where count>0;
select * from games;


--Warning ! NOT MY CODE this is chatgpt working query that should be later rewritten
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
),expanded_games AS (
  SELECT
    g.id AS game_id,
    g.game_date,
    CASE WHEN r.role = 0 THEN g.home_team_id ELSE g.away_team_id END AS team_id,
    CASE WHEN r.role = 0 THEN 'HOME' ELSE 'AWAY' END AS match_type
  FROM games g
  CROSS JOIN (VALUES (0), (1)) AS r(role)
),valid_team_games AS (
  SELECT
    eg.game_id,
    eg.team_id,
    eg.match_type,
    th.team_name
  FROM expanded_games eg
  JOIN team_names th ON
    eg.team_id = th.team_id
    AND eg.game_date BETWEEN th.valid_from AND th.valid_until
)SELECT
  team_id,
  team_name,
  COUNT(*) FILTER (WHERE match_type = 'AWAY') AS number_away_matches,
  ROUND(
    COUNT(*) FILTER (WHERE match_type = 'AWAY') * 100.0 / 
    NULLIF(COUNT(*), 0), 2
  ) AS percentage_away_matches,
  COUNT(*) FILTER (WHERE match_type = 'HOME') AS number_home_matches,
  ROUND(
    COUNT(*) FILTER (WHERE match_type = 'HOME') * 100.0 / 
    NULLIF(COUNT(*), 0), 2
  ) AS percentage_home_matches,
  COUNT(*) AS total_games
FROM valid_team_games
GROUP BY team_id, team_name
ORDER BY team_id, team_name;