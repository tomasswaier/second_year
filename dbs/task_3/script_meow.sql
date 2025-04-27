CREATE OR REPLACE FUNCTION public.define_environment()
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Clear existing data first
    PERFORM delete_all_data();
    
    -- Insert classes
    INSERT INTO class (id,"name", health, action_points, strength, dexterity, constitution, intelligence, armor_class, inventory_size)
    VALUES 
        (1,'Warrior', 90, 4, 16, 12, 14, 10, 16, 20),
        (2,'Mage', 70, 6, 10, 14, 12, 18, 12, 15);
    
    -- Insert characters
    INSERT INTO character (id,"name", class_id, health, action_points, strength, dexterity, constitution, intelligence, in_combat)
    VALUES 
        (1,'Musketeer Athos', 1, 80, 60, 12, 8, 10, 7, NULL),
        (2,'Musketeer Porthos', 2, 70, 132, 7, 8, 10, 14, NULL),
		(3,'Musketeer Aramis', 1, 75, 95, 14, 9, 11, 14, NULL);
    
    -- Insert action categories
    INSERT INTO action_category (id, name, cost)
    VALUES
        (1, 'Physical Attack', 6),
        (2, 'Fire Magic', 14),
        (4, 'Healing Magic', 6),
        (7, 'Out Of Combat Action', 0),
        (8, 'System', 0),
        (9, 'Default', 0);
        -- Insert items
    INSERT INTO item (id, name, description, base_damage, weight)
    VALUES
        (1, 'spear', 'Kind of a very long sword', 10, 4),
        (2, 'sword', 'Kind of a very normal length sword', 7, 2),
        (3, 'spear', 'Kind of a very long sword', 10, 4);
    -- Insert action types
    INSERT INTO action_type (id, name, action_category, item_id, description, effect, cost, effect_value)
    VALUES
        (1, 'FIREBALL', 2, NULL, 'big ball of fire that deals massive amount of damage', 'damage', 40, 40),
        (2, 'Stab', 1, 1, 'FIERCE ATTACK WITH LONG STICK', 'damage', 20, 20),
        (3, 'Heal Wounds', 4, NULL, 'Healing spell', 'heal', 10, 10),
		(4, 'Punch', 1, NULL, 'Punches Opponent', 'damage', 10, 10),
        (6, 'PASS', 9, NULL, 'Pass to the next round', 'damage', 0, 0),
        (7, 'Rest', 7, NULL, 'Rest instantly', 'heal', 0, 300000),
        (9, 'Enter Combat', 8, NULL, 'System announcement for entering combat', 'damage', 0, 0),
        (11, 'Die', 8, NULL, 'System announcement for dying in combat', 'damage', 0, 0),
        (12, 'Pick Up Item', 9, NULL, 'Pick Up Item from the playground', 'damage', 0, 0),
        (13, 'Leave Combat', 9, NULL, 'Removes your character from combat', 'damage', 0, 0),
        (14, 'Join Game', 8, NULL, 'Character Joined Game', 'damage', 0, 0),
        (15, 'Restore Action Points', 9, NULL, 'Restores action points of your character to max', 'damage', 0, 1);

    -- Insert class attribute modifiers
    INSERT INTO class_attribute_modifier (action_category_id, class_id, attribute, value)
    VALUES
        (1, 1, 'strength', 10),
        (1, 1, 'dexterity', 3),
        (2, 1, 'dexterity', 2),
        (2, 1, 'intelligence', 3),
        (4, 1, 'strength', 13),
        (7, 1, 'intelligence', 1),
        (1, 2, 'constitution', 7),
        (2, 2, 'intelligence', 10),
        (2, 2, 'constitution', 5),
        (4, 2, 'strength', 4),
        (7, 2, 'intelligence', 1);
    
    -- Insert item attribute modifiers
    INSERT INTO item_attribute_modifier (item_id, class_id, attribute, value)
    VALUES
        (1, 1, 'strength', 7),
        (1, 2, 'strength', 13),
        (2, 1, 'strength', 14),
        (3, 1, 'strength', 9),
        (2, 2, 'strength', 2),
        (3, 2, 'dexterity', 6);
    
    -- Insert character actions // we assume that while creating the characters players chose their own actions + the base actions are being added bcs why na
    INSERT INTO character_actions (character_id, action_type_id)
    VALUES
        (1, 2), (1, 3),(1, 4), (1, 6),(1, 7), (1, 9), (1, 11), (1, 12), (1, 13), (1, 14), (1, 15),
        (2, 1),(2, 6), (2, 7), (2, 9), (2, 11), (2, 12), (2, 13), (2, 14), (2, 15),
		(3, 2), (3, 3),(3, 4), (3, 6),(3, 7), (3, 9), (3, 11), (3, 12), (3, 13), (3, 14), (3, 15);
    RAISE NOTICE 'Environment successfully defined with all initial data';
END;
$$;
INSERT INTO action (id, action_type, target, character_id, combat_id, item_id, effect_value, hit)
VALUES
-- First batch
(276, 14, 1, 1, NULL, NULL, 0, true),
(277, 14, 2, 2, NULL, NULL, 0, true),
(278, 9, 1, 1, 1, NULL, 0, true),
(279, 9, 2, 2, 1, NULL, 0, true),
(280, 1, 1, 2, 1, NULL, 0, false),
(281, 12, 1, 1, 1, 1, 0, true),
(282, 2, 2, 1, 1, 1, 22, true),
(283, 1, 1, 2, 1, NULL, 0, false),
(284, 1, 1, 2, 1, NULL, 0, false),
(285, 1, 1, 2, 1, NULL, 42, true),
(286, 2, 2, 1, 1, 1, 0, false),
(287, 2, 2, 1, 1, 1, 0, false),
(288, 2, 2, 1, 1, 1, 22, true),
(289, 6, 1, 1, 1, NULL, 0, true),
(290, 6, 2, 2, 1, NULL, 0, true),
(291, 14, 3, 3, NULL, NULL, 0, true),
(292, 9, 3, 3, 15, NULL, 0, true),
(293, 4, 1, 3, 15, NULL, 0, false),
(294, 2, 2, 1, 15, 1, 0, false),
(295, 1, 3, 2, 15, NULL, 42, true),
(296, 4, 1, 3, 15, NULL, 12, true),
(297, 2, 2, 1, 15, 1, 22, true),
(298, 1, 3, 2, 15, NULL, 0, false),
(299, 4, 1, 3, 15, NULL, 0, false),
(300, 2, 2, 1, 15, 1, 0, false),
(301, 1, 3, 2, 15, NULL, 0, false),
(302, 4, 1, 3, 15, NULL, 12, true),
(303, 2, 2, 1, 15, 1, 0, false),
(304, 1, 3, 2, 15, NULL, 0, false),
(305, 4, 1, 3, 15, NULL, 0, false),
(306, 2, 2, 1, 15, 1, 0, false),
(307, 1, 3, 2, 15, NULL, 0, false),
(308, 4, 1, 3, 15, NULL, 0, false),
(309, 2, 2, 1, 15, 1, 0, false),
(310, 1, 3, 2, 15, NULL, 0, false),
(311, 4, 1, 3, 15, NULL, 0, false),
(312, 2, 2, 1, 15, 1, 0, false),
(313, 1, 3, 2, 15, NULL, 42, true),
(314, 11, 3, 3, 15, NULL, 0, true),
(315, 1, 1, 2, 15, NULL, 0, false),
(316, 2, 2, 1, 15, 1, 0, false),
(317, 1, 1, 2, 15, NULL, 42, true),
(318, 11, 1, 1, 15, NULL, 0, true),
(319, 13, 2, 2, 15, NULL, 0, true);

INSERT INTO combat (id,combat_num,round,status)
values
	(1,1,1,'on-going'),
	(15,1,2,'on-going'),(16,1,3,'finished');
INSERT INTO playground(combat_id ,item_id )
values
	(1,1);

//ako moc obsiahle by mali byt priklady (show him my thing)
//ako vela prikladov by malo byt
//ci to ma byt vsetko v jednej dbs alebo ako mame ukladat tie priklady

select define_environment();
select * from action;
insert into "action"(action_type,target,character_id ,combat_id,item_id,effect_value,hit) values(14,1,1,null,null,0,true);
insert into "action"(action_type,target,character_id ,combat_id,item_id,effect_value,hit) values(14,2,2,null,null,0,true);
-- Porthos casts fireball on Jake so the game automatically assigns them to combat
insert into combat (id,combat_num,round,status) values (1,1,1,'on-going');
select * from playground;
insert into playground  values(1,1);
select enter_combat(1,1);
select enter_combat(1,2);

select run_damage_action(1,1,2,NULL);
select * from action;
select loot_item(1,1);
select run_damage_action(2,2,1,1);
select * from action;
select * from character;
select run_damage_action(1,1,2,NULL);
insert into action(action_type ,target,character_id ,combat_id,item_id,effect_value,hit)
values (6,1,1,1,null,0,true);
insert into action(action_type ,target,character_id ,combat_id,item_id,effect_value,hit)
values (6,2,2,1,null,0,true);
select reset_round(1);
select * from combat;
SELECT * FROM v_combat_state;
select * from v_strongest_characters;
select * from v_most_damage;
select * from v_combat_damage;
select * from v_spell_statistics;
insert into "action"(action_type,target,character_id ,combat_id,item_id,effect_value,hit) values(14,3,3,null,null,0,true);

select enter_combat(17,3);

select run_damage_action(4,1,3,NULL);
select run_damage_action(2,2,1,1);
select run_damage_action(1,1,2,NULL);
select run_damage_action(4,2,3,NULL);
insert into action(action_type ,target,character_id ,combat_id,item_id,effect_value,hit)
values (13,2,2,15,null,0,true);
select reset_round(1);
select * from inventory;
select * from playground;
select define_environment();
    INSERT INTO combat(id,combat_num, round,status) VALUES (3,1, 1,'on-going');
    INSERT INTO character (id,"name", class_id, health, action_points, strength, dexterity, constitution, intelligence, in_combat)
    VALUES (123,'Musketeer Dumbo', 1, 1, 1, 1, 1, 1, 1, 3);
    INSERT INTO item (id, name, description, base_damage, weight)
    VALUES
        (123, 'spear', 'Kind of a very long sword', 10, 40000); -- Very heavy item
	INSERT INTO playground(combat_id ,item_id )
	values(3,123);
    select loot_item(3, 3, 123);
    BEGIN
        select loot_item(3, 3, 123);
        RAISE EXCEPTION 'Should have failed - over weight limit';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'Passed: Correctly blocked overweight loot';
    END;
