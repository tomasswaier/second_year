select * from play_records pr order by id;
select * from players pr limit 100;
select * from games g  order by id limit 100;
select * from teams t limit 100;


--first
WITH sorted AS (SELECT pr.*, p.first_name, p.last_name FROM play_records pr
JOIN players p ON pr.player1_id = p.id
--WHERE pr.game_id = '22000529'
ORDER BY pr.game_id, pr.event_number)
SELECT player1_id AS player_id,first_name,last_name,period,pctimestring AS period_time
FROM (SELECT *,LAG(event_msg_type) OVER (
PARTITION BY game_id ORDER BY event_number) AS prev_event_type,
LAG(player1_id) OVER (PARTITION BY game_id ORDER BY event_number) AS prev_player_id
FROM sorted) subquery
WHERE prev_event_type = 'REBOUND' AND event_msg_type = 'FIELD_GOAL_MADE'AND player1_id = prev_player_id
ORDER BY period ASC,period_time DESC,player_id ASC;

--two -- in progress -- should I print everyone who changed or only the top 5 ppl



--3 
select r.game_id , r.player1_id ,count(r.event_msg_type ) as point_count
from play_records r where r.event_msg_type ='FIELD_GOAL_MADE' group by r.game_id,r.player1_id order by player1_id ;

