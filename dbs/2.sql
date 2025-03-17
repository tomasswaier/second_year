with player_teams as (
select
	unnest(array[player1_id,
	player2_id]) as player_id,
	unnest(array[player1_team_id,
	player2_team_id]) as team_id,
	-- put two meows into one for ez pz uwu
	game_id,
	event_msg_type,
	p.id
from
	play_records p
join games g on
	p.game_id = g.id
where
	event_msg_type in ('FREE_THROW', 'FIELD_GOAL_MADE', 'FIELD_GOAL_MISSED', 'REBOUND')
	--and g.season_id = '22017'
),
team_changes as (
-- count num of meow changes
select
	player_id,
	team_id,
	COUNT(distinct game_id) as games_played
from
	player_teams
where
	player_id is not null
	and team_id is not null
group by
	player_id,
	team_id
),
player_change_counts as (
-- select only those meowzers who changed more than once
select
	player_id,
	COUNT(team_id) as team_change_count,
	row_number() over (
	order by COUNT(team_id) desc) as change_rank
from
	team_changes
group by
	player_id
having
	COUNT(team_id) > 2
),
ppg_tab as (
-- errro r somewhere in here idk where
select
	pt.player_id,
	team_id,
	ROUND(COUNT(*) filter (
	where pt.event_msg_type = 'FIELD_GOAL_MADE'
	and pt.player_id = pr.player1_id) * 2.0 / 
	COUNT(distinct pt.game_id),
	2) as ppg
from
	player_teams pt
join play_records as pr on
	pt.id = pr.id
join player_change_counts as pcc on
	pt.player_id = pcc.player_id
where
	pcc.change_rank <= 5
	and pt.event_msg_type = 'FIELD_GOAL_MADE'
group by
	pt.player_id,
	team_id
),
apg_tab as (
-- errro r somewhere in here idk where
select
	pt.player_id,
	team_id,
	ROUND(COUNT(*) filter (
	where pt.event_msg_type = 'FIELD_GOAL_MADE'
	and pt.player_id = pr.player2_id) * 2.0 / 
	COUNT(distinct pt.game_id),
	2) as apg
from
	player_teams pt
join play_records as pr on
	pt.id = pr.id
join player_change_counts as pcc on
	pt.player_id = pcc.player_id
where
	pcc.change_rank <= 5
	and pt.event_msg_type = 'FIELD_GOAL_MADE'
group by
	pt.player_id,
	team_id
)
select
	pcc.player_id,
	p.first_name,
	p.last_name,
	tc.team_id,
	t.full_name,
	ppg.ppg,
	apg.apg,
	tc.games_played
from
	player_change_counts pcc
join team_changes tc on
	pcc.player_id = tc.player_id
join players p on
	tc.player_id = p.id
join teams t on
	tc.team_id = t.id
left join ppg_tab ppg on
	tc.player_id = ppg.player_id
	and tc.team_id = ppg.team_id
left join apg_tab apg on
	tc.player_id = apg.player_id
	and tc.team_id = apg.team_id
order by
	tc.player_id asc,
	tc.team_id asc;


with single_player_records as (
select
	p.id,
	g.season_id,
	p.game_id,
	player_id,
	team_id,
	role,
	p.event_msg_type
from
	play_records p
left join games g on
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
	event_msg_type in ('FREE_THROW', 'FIELD_GOAL_MADE', 'FIELD_GOAL_MISSED', 'REBOUND')
	and player_id is not null
	and team_id is not null
	and g.season_id = '22017'
),
player_records_with_games_count as (
select
	player_id,
	team_id,
	COUNT(distinct game_id) as games_played_count
from
	single_player_records
group by
	player_id,
	team_id
),
distinct_teams_count as (
select
	*
from
	(
	select
		player_id,
		COUNT(distinct team_id) as number_of_teams_played_for,
		row_number() over (
	order by
		COUNT(team_id) desc) as row_num
	from
		player_records_with_games_count
	group by
		player_id
	having
		COUNT(distinct team_id) > 1
)where row_num <=5),
	ppg_tab as (
	select
		spr.player_id,
		spr.team_id,
		ROUND(
      COUNT(*) filter (
		where spr.event_msg_type = 'FIELD_GOAL_MADE') * 2.0 
      / MAX(prwgc.games_played_count),
		2) as ppg
	from distinct_teams_count dtc join -- this join is here to make it faster by selecting only top5
		single_player_records spr on dtc.player_id = spr.player_id
	join player_records_with_games_count prwgc
    on
		spr.player_id = prwgc.player_id
		and spr.team_id = prwgc.team_id
		-- Only consider scorers (player1_id)
	group by
		spr.player_id,
		spr.team_id
)
	select
		ppg.player_id,
		p.first_name,
		p.last_name,
		ppg.team_id,
		t.full_name,
		ppg.ppg,
		prwgc.games_played_count
	from
		distinct_teams_count dtc join ppg_tab ppg on
		ppg.player_id = dtc.player_id
	join players p on
		ppg.player_id = p.id
	join teams t on
		ppg.team_id = t.id
	join player_records_with_games_count prwgc
  on
		ppg.player_id = prwgc.player_id
		and ppg.team_id = prwgc.team_id
	order by
		ppg.player_id,
		ppg.team_id;