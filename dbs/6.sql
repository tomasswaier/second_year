
with players as (select * from players where first_name = '{{first_ame}}'
	and last_name = '{{last_name}}'),
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
join players p on
	pr.player1_id = p.id
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
ordered_games as (
select
	pg.season_id,
	pg.game_id,
	pg.game_date,
        case
		when (pg.made + pg.missed) = 0 then 0
		else pg.made::FLOAT / nullif((pg.made + pg.missed),
		0)
	end as success_rate,
	gc.total_games
from
	player_games pg
join (
	select
		season_id,
		COUNT(distinct game_id) as total_games
	from
		player_games
	group by
		season_id
	having
		COUNT(distinct game_id) >= 50
    ) gc on
	pg.season_id = gc.season_id
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
