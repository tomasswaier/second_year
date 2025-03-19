--please no steal this is what imma be putting into the tester
with play_records as (
	select * from play_records where game_id = '21701185'
),goal_stats as(
		select
			prs.player1_id ,
			count(case when event_msg_type = 'FIELD_GOAL_MISSED' then 1 end) as goals_missed_count,
			count(case when event_msg_type = 'FIELD_GOAL_MADE' then 1 end) as goals_made_count,
			count(case when event_msg_type = 'FIELD_GOAL_MISSED' or event_msg_type = 'FIELD_GOAL_MADE' then 1 end) as goals_made_and_missed_count
		from
			play_records as prs
		group by
			prs.player1_id
),points_scored as(
		select
			prs.player1_id,
			prs.game_id,
			prs.event_msg_type,
			coalesce(nullif(prs.score_margin,
			'TIE')::INTEGER,
			0) as s_margin,
			coalesce(nullif(lag(prs.score_margin) over (
		            partition by prs.game_id
		order by
			prs.event_number
		        ),
			'TIE')::INTEGER,
			0) as prev_margin
		from
			play_records prs
		where
		prs.score is not null
		),
freethrows as(
		select
			prs.player1_id ,
			count(case when event_msg_type = 'FREE_THROW' then 1 end) as free_throw_count,
			count(case when event_msg_type = 'FREE_THROW' and prs.score_margin is null then 1 end) as free_throw_missed_count,
			count(case when event_msg_type = 'FREE_THROW' and prs.score_margin is not null then 1 end) as FTM
		from
			play_records as prs
		group by
			prs.player1_id
),player_stats AS (-- format data 
	    SELECT
	        pl.id AS player_id,
	        pl.first_name,
	        pl.last_name,
	        (COUNT(CASE WHEN ABS(ps.s_margin - ps.prev_margin) = 2 THEN 1 END) * 2) +
	        (COUNT(CASE WHEN ABS(ps.s_margin - ps.prev_margin) = 3 THEN 1 END) * 3) +
	        COALESCE(fts.FTM, 0) AS points,
	        COUNT(CASE WHEN ABS(ps.s_margin - ps.prev_margin) = 2 THEN 1 END) AS "2PM",
	        COUNT(CASE WHEN ABS(ps.s_margin - ps.prev_margin) = 3 THEN 1 END) AS "3PM",
	        ROUND(
	            CASE 
	                WHEN sh.goals_made_and_missed_count = 0 THEN 0
	                ELSE (sh.goals_made_count * 1.0 / sh.goals_made_and_missed_count) * 100
	            END, 2
	        ) AS shooting_percentage,
	        ROUND(
	            CASE 
	                WHEN fts.free_throw_count > 0 THEN (fts.FTM * 1.0 / fts.free_throw_count) * 100
	                ELSE 0
	            END, 2
	        ) AS FT_percentage,
	        sh.goals_missed_count,
	        fts.FTM,
	        fts.free_throw_missed_count
	    FROM players pl
	    LEFT JOIN points_scored ps ON pl.id = ps.player1_id
	    JOIN freethrows fts ON pl.id = fts.player1_id
	    JOIN goal_stats sh ON pl.id = sh.player1_id
	    GROUP BY
	        pl.id,
	        pl.first_name,
	        pl.last_name,
	        sh.goals_made_count,
	        sh.goals_made_and_missed_count,
	        sh.goals_missed_count,
	        fts.FTM,
	        fts.free_throw_missed_count,
	        fts.free_throw_count
)select -- print
    player_id,
    first_name,
    last_name,
    points,
    "2PM",
    "3PM",
    goals_missed_count as missed_shots,
    shooting_percentage as shooting_percentage,
    FTM,
    free_throw_missed_count as missed_free_throws,
    FT_percentage
FROM player_stats
ORDER BY
    points DESC,
    shooting_percentage DESC,
    FT_percentage DESC,
    player_id;

