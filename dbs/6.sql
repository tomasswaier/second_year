
with player_info as (
select
	id as player_id
from
	players
where
	first_name = 'LeBron'
	and last_name = 'James'
),
player_games as (
select
	pr.game_id,
	g.season_id,
	g.game_date,
	SUM(case when pr.event_msg_type = 'FIELD_GOAL_MADE' then 1 else 0 end) as made,
	SUM(case when pr.event_msg_type = 'FIELD_GOAL_MISSED' then 1 else 0 end) as missed
from
	play_records pr
join games g on
	pr.game_id = g.id
join player_info p on
	pr.player1_id = p.player_id
where
	g.season_type = 'Regular Season'
	and pr.event_msg_type in ('FIELD_GOAL_MADE', 'FIELD_GOAL_MISSED')
group by
	pr.game_id,
	g.season_id,
	g.game_date
order by
	g.season_id,
	g.game_date 
),
season_game_counts as (
select
	season_id,
	COUNT(distinct game_id) as total_games
from
	player_games
group by
	season_id
having
	COUNT(distinct game_id) >= 50
),
ordered_games as (
select
	season_id,
	game_id,
	game_date,
	case
		when (made + missed) = 0 then 0
		else made::FLOAT / nullif((made + missed),
		0)
	end as success_rate
from
	player_games
where
	season_id in (
	select
		season_id
	from
		season_game_counts)
),
game_diffs as (
select
	season_id,
	game_id,
	success_rate,
	lag(success_rate,
	1) over (
            partition by season_id
order by
	game_date 
        ) as prev_success_rate
from
	ordered_games
),
differences as (
select
	season_id,
	coalesce(ABS(success_rate - prev_success_rate),
	0.0) as diff
from
	game_diffs
),
season_stability as (
select
	season_id,
	AVG(diff) as stability
from
	differences
group by
	season_id
)
select
	season_id::TEXT,
	ROUND(ROUND(stability::numeric,
	4)* 100,
	2 )as stability
from
	season_stability
order by
	stability asc,
	season_id asc;