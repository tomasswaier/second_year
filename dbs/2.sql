

--emow
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
      (
        COUNT(*) FILTER (WHERE spr.event_msg_type = 'FIELD_GOAL_MADE' AND spr.role = 0) * 2.0
        + COUNT(*) FILTER (WHERE spr.event_msg_type = 'FREE_THROW' AND spr.role = 0)
      ) / MAX(prwgc.games_played_count),
      2
    ) AS ppg
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
),apg_tab as (
	select
		spr.player_id,
		spr.team_id,
		ROUND(
      (
        COUNT(*) FILTER (WHERE spr.event_msg_type = 'FIELD_GOAL_MADE' AND spr.role = 1)
      ) / MAX(prwgc.games_played_count),
      2
    ) AS apg
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
)select
		ppg.player_id,
		p.first_name,
		p.last_name,
		ppg.team_id,
		t.full_name,
		ppg.ppg,
		apg.apg,
		prwgc.games_played_count
	from
		distinct_teams_count dtc join ppg_tab ppg on
		ppg.player_id = dtc.player_id
	join players p on
		ppg.player_id = p.id join apg_tab  apg on apg.player_id = ppg.player_id and apg.team_id= ppg.team_id
	join teams t on
		ppg.team_id = t.id 
	join player_records_with_games_count prwgc
  on
		ppg.player_id = prwgc.player_id
		and ppg.team_id = prwgc.team_id
	order by
		ppg.player_id,
		ppg.team_id;