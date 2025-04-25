-- game start
delete from action;
delete from playground;
delete from combat;
update character set action_points=calculate_max_action_points(character.id);
update character set health=calculate_max_health(character.id);
select * from character;

select * from action;
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(14,1,1,null,null,0,true);
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(14,2,2,null,null,0,true);


--Mark attacks triggering enter combat sequence
select * from combat;
insert into combat(id,combat_num,round,status) values(1,1,1,'on-going');
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(9,2,2,1,null,0,true);
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(9,1,2,1,null,0,true);
-- imaginary dice rolled 18 so one item will be added to playground
insert into playground(combat_id,item_id) values(1,1);
--mark deals damage with fireball
select run_damage_action(1,1,2,1,null,true);
-- Joe picks up an item
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(12,1,1,1,1,0,true);
insert into inventory(character_id,item_id) values(1,1);
update character set action_points=character.action_points-calculate_cost(1,12,1) where character.id=1;
-- Joe stabs Mike
select run_damage_action(2,2,1,1,1);
-- Joe stabs Mike second time 
select run_damage_action(2,2,1,1,1);

--mark deals damage with fireball
select run_damage_action(1,1,2,1,null);

insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(11,1,2,1,null,0,true);
select * from character;
select * from character_actions ca;

select run_damage_action(1, 1, 2,1, null);
select * from action;
select pick_up_item(1,1,1);