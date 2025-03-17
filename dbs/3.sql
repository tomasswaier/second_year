--3 
select r.game_id , r.player1_id ,count(r.event_msg_type ) as point_count
from play_records r where r.event_msg_type ='FIELD_GOAL_MADE' group by r.game_id,r.player1_id order by player1_id ;