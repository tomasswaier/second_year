with games as (
select
	*
from
	games
where
	season_id = '{{season_id}}'
),
single_player_records as (
select
	p.id,
	g.season_id,
	p.game_id,
	player_id,
	team_id,
	role,
	p.event_msg_type,
	p.score_margin
from
	play_records p
join games g on
	p.game_id = g.id,
	unnest(
        array[player1_id,
	player2_id],
	array[player1_team_id,
	player2_team_id],
	array[0,
	1] 
    ) as t(player_id,
	team_id,
	role)
where
	event_msg_type in ('FIELD_GOAL_MADE', 'FREE_THROW', 'REBOUND')
		and player_id is not null
		and team_id is not null
),
player_stats as (
select
	spr.game_id,
	spr.player_id,
	SUM(case 
            when spr.event_msg_type = 'FIELD_GOAL_MADE' and spr.role = 0 then 2
            when spr.event_msg_type = 'FREE_THROW' and spr.role = 0 and spr.score_margin is not null then 1
            else 0
        end) as point_count,
	COUNT(*) filter (
	where spr.event_msg_type = 'FIELD_GOAL_MADE'
	and spr.role = 1) as assist_count,
	COUNT(*) filter (
	where spr.event_msg_type = 'REBOUND'
	and spr.role = 0) as rebound_count
from
	single_player_records spr
group by
	spr.game_id,
	spr.player_id
),
triple_doubles as (
select
	g.game_date,
	ps.player_id,
	(ps.point_count >= 10
		and ps.assist_count >= 10
		and ps.rebound_count >= 10) as is_td
from
	player_stats ps
join games g on
	ps.game_id = g.id
),
streak_groups as (
select
	player_id,
	game_date,
	is_td,
	SUM(case when not is_td then 1 else 0 end) 
            over (partition by player_id
order by
	game_date) as streak_id
from
	triple_doubles
),
streak_lengths as (
select
	player_id,
	streak_id,
	COUNT(*) as streak_length
from
	streak_groups
where
	is_td
group by
	player_id,
	streak_id
)
select
	player_id,
	coalesce(MAX(streak_length),
	0) as longest_streak
from
	streak_lengths
group by
	player_id
order by
	longest_streak desc,
	player_id asc;

