
--first

WITH sorted AS (
SELECT
	pr.*,
	p.first_name,
	p.last_name
FROM
	play_records pr
JOIN players p ON
	pr.player1_id = p.id
WHERE
	pr.game_id = '{{game_id}}'
	AND pr.event_msg_type != 'INSTANT_REPLAY'
ORDER BY
	pr.game_id,
	pr.event_number)
SELECT
	player1_id AS player_id,
	first_name,
	last_name,
	period,
	pctimestring AS period_time
FROM
	(
	SELECT
		*,
		LAG(event_msg_type) OVER (
PARTITION BY game_id
	ORDER BY
		event_number) AS prev_event_type,
		LAG(player1_id) OVER (PARTITION BY game_id
	ORDER BY
		event_number) AS prev_player_id
	FROM
		sorted) subquery
WHERE
	prev_event_type = 'REBOUND'
	AND event_msg_type = 'FIELD_GOAL_MADE'
	AND player1_id = prev_player_id
ORDER BY
	period ASC,
	period_time DESC,
	player_id ASC;

