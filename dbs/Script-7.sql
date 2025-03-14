select * from play_records pr order by id;
select * from players pr limit 100;
select * from games g  order by id limit 100;
select * from teams t limit 100;


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
WITH player_teams AS (
    SELECT UNNEST(ARRAY[player1_id, player2_id]) AS player_id,UNNEST(ARRAY[player1_team_id, player2_team_id]) AS team_id, -- put two meows into one for ez pz uwu
	game_id,event_msg_type,p.id
    FROM play_records p 
    JOIN games g ON p.game_id = g.id 
    WHERE event_msg_type IN ('FREE_THROW', 'FIELD_GOAL_MADE', 'FIELD_GOAL_MISSED', 'REBOUND')AND g.season_id = '22017'
),
team_changes AS ( -- count num of meow changes
    SELECT player_id,team_id,
	COUNT(DISTINCT game_id) AS games_played FROM player_teams 
    WHERE player_id IS NOT NULL AND team_id IS NOT NULL 
    GROUP BY player_id, team_id
),
player_change_counts AS ( -- select only those meowzers who changed more than once
    SELECT player_id,COUNT(team_id) AS team_change_count
    FROM team_changes GROUP BY player_id HAVING COUNT(team_id) > 2
),
ppg_tab AS ( -- errro r somewhere in here idk where
    SELECT player_id,team_id,
	ROUND(COUNT(*) FILTER (WHERE pt.event_msg_type = 'FIELD_GOAL_MADE' and pt.player_id=pr.player1_id) * 2.0 / 
	COUNT(DISTINCT pt.game_id), 2) AS ppg
    FROM player_teams pt join play_records as pr on pt.id=pr.id
    WHERE pt.event_msg_type = 'FIELD_GOAL_MADE'GROUP BY pt.player_id, team_id
),
apg_tab AS ( -- errro r somewhere in here idk where
    SELECT player_id,team_id,
	ROUND(COUNT(*) FILTER (WHERE pt.event_msg_type = 'FIELD_GOAL_MADE' and pt.player_id=pr.player2_id) * 2.0 / 
	COUNT(DISTINCT pt.game_id), 2) AS apg
    FROM player_teams pt join play_records as pr on pt.id=pr.id
    WHERE pt.event_msg_type = 'FIELD_GOAL_MADE'GROUP BY pt.player_id, team_id
)
SELECT pcc.player_id,p.first_name,p.last_name,tc.team_id,t.full_name,ppg.ppg,apg.apg,tc.games_played
FROM player_change_counts pcc
JOIN team_changes tc ON pcc.player_id = tc.player_id
JOIN players p ON tc.player_id = p.id
JOIN teams t ON tc.team_id = t.id
LEFT JOIN ppg_tab ppg ON tc.player_id = ppg.player_id AND tc.team_id = ppg.team_id
LEFT JOIN apg_tab apg ON tc.player_id = apg.player_id AND tc.team_id = apg.team_id
ORDER BY tc.player_id ASC, tc.team_id ASC;