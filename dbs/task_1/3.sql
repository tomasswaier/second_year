--please no steal this is what imma be putting into the tester
with play_records as (
select
	*
from
	play_records
where
	game_id = '{{game_id}}'
),
goal_stats as(
select
			prs.player1_id ,
			count(case when event_msg_type = 'FIELD_GOAL_MISSED' then 1 end) as goals_missed_count,
			count(case when event_msg_type = 'FIELD_GOAL_MADE' then 1 end) as goals_made_count,
			count(case when event_msg_type = 'FIELD_GOAL_MISSED' or event_msg_type = 'FIELD_GOAL_MADE' then 1 end) as goals_made_and_missed_count
from
			play_records as prs
group by
			prs.player1_id
),
points_scored as(
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
),
player_stats as (
-- format data 
select
	        pl.id as player_id,
	        pl.first_name,
	        pl.last_name,
	        (COUNT(case when ABS(ps.s_margin - ps.prev_margin) = 2 then 1 end) * 2) +
	        (COUNT(case when ABS(ps.s_margin - ps.prev_margin) = 3 then 1 end) * 3) +
	        coalesce(fts.FTM,
	0) as points,
	        COUNT(case when ABS(ps.s_margin - ps.prev_margin) = 2 then 1 end) as "2PM",
	        COUNT(case when ABS(ps.s_margin - ps.prev_margin) = 3 then 1 end) as "3PM",
	        ROUND(
	            case
		when sh.goals_made_and_missed_count = 0 then 0
		else (sh.goals_made_count * 1.0 / sh.goals_made_and_missed_count) * 100
	end,
	2
	        ) as shooting_percentage,
	        ROUND(
	            case
		when fts.free_throw_count > 0 then (fts.FTM * 1.0 / fts.free_throw_count) * 100
		else 0
	end,
	2
	        ) as FT_percentage,
	        sh.goals_missed_count,
	        fts.FTM,
	        fts.free_throw_missed_count
from
	players pl
left join points_scored ps on
	pl.id = ps.player1_id
join freethrows fts on
	pl.id = fts.player1_id
join goal_stats sh on
	pl.id = sh.player1_id
group by
	        pl.id,
	        pl.first_name,
	        pl.last_name,
	        sh.goals_made_count,
	        sh.goals_made_and_missed_count,
	        sh.goals_missed_count,
	        fts.FTM,
	        fts.free_throw_missed_count,
	        fts.free_throw_count
)select
	-- print
	player_id,
	first_name,
	last_name,
	points,
	"2PM",
	"3PM",
	goals_missed_count as missed_shots,
	shooting_percentage as shooting_percentage,
	FTM as "FTM",
	free_throw_missed_count as missed_free_throws,
	FT_percentage as "FT_percentage"
from
	player_stats
order by
	points desc,
	shooting_percentage desc,
	FT_percentage desc,
	player_id;

