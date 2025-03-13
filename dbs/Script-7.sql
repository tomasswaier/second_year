select * from play_records pr limit 100;
select * from players pr limit 100;



--first
WITH sorted AS (SELECT pr.*, p.first_name, p.last_name FROM play_records pr
JOIN players p ON pr.player1_id = p.id
WHERE pr.game_id = '22000529'
ORDER BY pr.game_id, pr.event_number)
SELECT player1_id AS player_id,first_name,last_name,period,pctimestring AS period_time
FROM (SELECT *,LAG(event_msg_type) OVER (
PARTITION BY game_id ORDER BY event_number) AS prev_event_type,
LAG(player1_id) OVER (PARTITION BY game_id ORDER BY event_number) AS prev_player_id
FROM sorted) subquery
WHERE prev_event_type = 'REBOUND' AND event_msg_type = 'FIELD_GOAL_MADE'AND player1_id = prev_player_id
ORDER BY period ASC,period_time DESC,player_id ASC;

--two -- in progress

WITH newTable AS (
    SELECT UNNEST(ARRAY[player1_id, player2_id]) AS player_id,unnest(ARRAY[player1_team_id, player2_team_id]) as team_id,
           game_id, event_number, event_msg_type,event_msg_action_type, period, wctimestring,pctimestring,score,score_margin
    FROM play_records
    WHERE event_msg_type IN ('FREE_THROW', 'FIELD_GOAL_MADE', 'FIELD_GOAL_MISSED', 'REBOUND')
) select 
distinct player_id,count(distinct team_id ) as team_count
from(
SELECT * FROM newTable 
where player_id is not null and team_id is not null)group by player_id
;
