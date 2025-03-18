--3 
select r.game_id , r.player1_id ,count(r.event_msg_type ) as point_count
from play_records r where r.event_msg_type ='FIELD_GOAL_MADE' group by r.game_id,r.player1_id order by player1_id ;
select * from play_records pr where score_margin is not null order by pr.game_id ,pr.wctimestring;


select * from team;
select * from play_records pr where pr.game_id = '21701185' order by game_id,pr.wctimestring ;

WITH game_events AS (
    SELECT
        player1_id,
        player1_team_id,
        event_msg_type,
        event_number,
        CASE
            WHEN score_margin = 'TIE' THEN 0
            WHEN score_margin ~ '^-?\d+$' THEN score_margin::INTEGER
            ELSE 0
        END AS current_margin,
        LAG(
            CASE
                WHEN score_margin = 'TIE' THEN 0
                WHEN score_margin ~ '^-?\d+$' THEN score_margin::INTEGER
                ELSE 0
            END
        ) OVER (ORDER BY event_number) AS prev_margin
    FROM play_records
    WHERE game_id = '21701185'
      AND event_msg_type IN ('FIELD_GOAL_MADE', 'FREE_THROW')
      AND player1_id IS NOT NULL
)	,
scoring_events AS (
    SELECT
        player1_id,
        event_msg_type,
        CASE
            -- Points for FIELD_GOAL_MADE (assume 2 points)
            WHEN event_msg_type = 'FIELD_GOAL_MADE' THEN 2
            -- Points for FREE_THROW
            WHEN event_msg_type = 'FREE_THROW' THEN 1
            ELSE 0
        END AS points_scored
    FROM game_events
)
SELECT
    player1_id AS player_id,
    SUM(points_scored) AS points,
    COUNT(*) FILTER (WHERE event_msg_type = 'FIELD_GOAL_MADE') AS "2PM",
    0 AS "3PM"  -- Placeholder if 3PM data is unavailable
FROM scoring_events
GROUP BY player1_id
ORDER BY player1_id;


with found_values as (
select
	*
from
	play_records pr
where
	pr.game_id = '21701185' and score_margin is not null
order by
	game_id,
	pr.wctimestring
)select
	*
from
	found_values ;