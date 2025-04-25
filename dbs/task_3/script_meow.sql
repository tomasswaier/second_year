INSERT INTO class ( "name", health, action_points, strength, dexterity, constitution, intelligence, armor_class, inventory_size)
VALUES ( 'Warrior', 90, 4, 16, 12, 14, 10, 16, 20),
VALUES ( 'Mage', 70, 6, 10, 14, 12, 18, 12, 15);
INSERT INTO class ( "name", health, action_points, strength, dexterity, constitution, intelligence, armor_class, inventory_size)
--VALUES ( 'Assassin', 80, 5, 13, 18, 12, 11, 15, 18);
--INSERT INTO class ( "name", health, action_points, strength, dexterity, constitution, intelligence, armor_class, inventory_size)
--VALUES ( 'LootGoblin', 85, 4, 1, 1, 1, 1, 17, 125);
--INSERT INTO class ( "name", health, action_points, strength, dexterity, constitution, intelligence, armor_class, inventory_size)
--VALUES ( 'Tank', 100, 3, 15, 13, 17, 12, 18, 22);
--select * from "class" c where id = 1;
--select * from "character" c ;
;
insert into character("name",class_id,health,action_points,strength,dexterity,constitution,intelligence,in_combat)
values ('Joe',1,80,60,12,8,10,7,false),
('Mark',2,70,132,7,8,10,14,false);
select * from character;

INSERT INTO action_category (id, name, cost) VALUES
(1, 'Physical Attack', 6),
(2, 'Fire Magic', 14),
(4, 'Healing Magic', 6),
(7, 'Out Of Combat Action', 0),
(8, 'System', 0),
(9, 'Default', 0);
select * from action_category ac ;

select * from action_type at2 ;

INSERT INTO action_type (id, name, action_category, item_id, description, effect, cost, effect_value) VALUES
(1, 'FIREBALL', 2, NULL, 'big ball of fire that deals massive amount of damage', 'damage', 40, 40),
(2, 'Stab', 1, 1, 'FIERCE ATTACK WITH LONG STICK', 'damage', 20, 20),
(3, 'Heal Wounds', 4, NULL, 'Healig spell', 'heal', 10, 10),
(7, 'Rest', 7, NULL, 'Rest instantly', 'heal', 0, 300000),
(9, 'Enter Combat', 8, NULL, 'System announcment for entering combat', 'damage', 0, 0),
(11, 'Die', 8, NULL, 'System announcment for dying in combat', 'damage', 0, 0),
(12, 'Pick Up Item', 9, NULL, 'Pick Up Item from the playground', 'damage', 0, 0),
(13, 'Leave Combat', 9, NULL, 'Removes your character from combat', 'damage', 0, 0),
(14, 'Join Game', 8, NULL, 'Character Joined Game', 'damage', 0, 0),
(15, 'Restore Action Points', 9, NULL, 'Restores action points of your character to max', 'damage', 0, 1);

select * from action_type;
INSERT INTO item (id, name, description, base_damage, weight) VALUES
(1, 'spear', 'Kind of a very long sword', 10, 4),
(2, 'sword', 'Kind of a very normal length sword', 7, 2),
(3, 'spear', 'Kind of a very long sword', 10, 4);
select * from public.item_attribute_modifier iam ;

select * from class_attribute_modifier cam ;
INSERT INTO class_attribute_modifier (action_category_id, class_id, attribute, value) VALUES
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
select * from item_attribute_modifier iam ;
INSERT INTO item_attribute_modifier (item_id, class_id, attribute, value) VALUES
(1, 1, 'strength', 7),
(1, 2, 'strength', 13),
(2, 1, 'strength', 14),
(3, 1, 'strength', 9),
(2, 2, 'strength', 2),
(3, 2, 'dexterity', 6);
insert into character_actions(character_id,action_type_id ) values
(1,2),(1,3),(1,7),(1,9),(1,11),(1,12),(1,13),(1,14),(1,15),
(2,1),(2,7),(2,9),(2,11),(2,12),(2,13),(2,14),(2,15);
--SELECT enumlabel
--FROM pg_enum
--JOIN pg_type ON pg_enum.enumtypid = pg_type.oid
--WHERE pg_type.typname = 'attributes';

select * from action_type;
select * from action_category;
insert into character_actions (character_id,action_type_id) values (2,7);
select * from character_actions;

select * from combat;
insert into combat (combat_num,round,status) values (1,1,'on-going');
//ako moc obsiahle by mali byt priklady (show him my thing)
//ako vela prikladov by malo byt
//ci to ma byt vsetko v jednej dbs alebo ako mame ukladat tie priklady
//co je modifier v speloch


-- This function divides table1.value by table2.value
CREATE OR REPLACE FUNCTION calculate_cost(
    player_id INTEGER,
    action_type_id INTEGER,
    used_item_id INTEGER
) RETURNS NUMERIC AS $$
DECLARE
    action_category_cost NUMERIC;
    class_attribute_modifier_value NUMERIC;
    item_attribute_modifier_value NUMERIC;
	found_action_category_id NUMERIC;
	character_class_id NUMERIC;
	v_result NUMERIC;
	
BEGIN
    -- Get the action category ID from action_type
    SELECT action_category 
    INTO found_action_category_id 
    FROM action_type 
    WHERE id = action_type_id;

    -- Get the character class ID
    SELECT class_id 
    INTO character_class_id 
    FROM character 
    WHERE id = player_id;

    -- Get the base cost of the action category
    SELECT cost 
    INTO action_category_cost 
    FROM action_category 
    WHERE id = found_action_category_id;

    -- Sum all values from class_attribute_modifier that match the criteria
    SELECT COALESCE(SUM(value), 0) 
    INTO class_attribute_modifier_value 
    FROM class_attribute_modifier 
    WHERE action_category_id = found_action_category_id 
      AND class_id = character_class_id;

    -- Sum all values from item_attribute_modifier that match the criteria
    SELECT COALESCE(SUM(value), 0) 
    INTO item_attribute_modifier_value 
    FROM item_attribute_modifier 
    WHERE item_id = used_item_id 
      AND class_id = character_class_id;

    -- Return the sum of both modifiers
    v_result :=action_category_cost-(1- (class_attribute_modifier_value/100))*(1-(item_attribute_modifier_value/100));

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_damage(
    player_id INTEGER,
    action_type_id INTEGER
) RETURNS NUMERIC AS $$
DECLARE
    class_attribute_modifier_value NUMERIC;
	found_action_category_id NUMERIC;
	character_class_id NUMERIC;
	v_result NUMERIC;
	action_type_value NUMERIC;
	
BEGIN
    -- Get the action category ID from action_type
    SELECT action_category 
    INTO found_action_category_id 
    FROM action_type 
    WHERE id = action_type_id;

    -- Get the character class ID
    SELECT class_id 
    INTO character_class_id 
    FROM character 
    WHERE id = player_id;


    -- Sum all values from class_attribute_modifier that match the criteria
    SELECT COALESCE(SUM(value), 0) 
    INTO class_attribute_modifier_value 
    FROM class_attribute_modifier 
    WHERE action_category_id = found_action_category_id 
      AND class_id = character_class_id;
	
	select effect_value into action_type_value from action_type where id=action_type_id;


    -- Return the sum of both modifiers
    v_result :=action_type_value +(1+ (class_attribute_modifier_value/20));

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_max_health(
    player_id INTEGER
) RETURNS NUMERIC AS $$
DECLARE
	character_constitution NUMERIC;
	character_class_id NUMERIC;
	class_constitution NUMERIC;
	v_result NUMERIC;
BEGIN

    -- Get the character class ID
    SELECT constitution
    INTO character_constitution
    FROM character 
    WHERE id = player_id;
	    -- Get the character class ID
    SELECT class_id
    INTO character_class_id
    FROM character 
    WHERE id = player_id;
    -- Get the character class ID
    SELECT constitution
    INTO class_constitution
    FROM class
    WHERE id = character_class_id;

    -- Return the sum of both modifiers
    v_result :=10 +character_constitution*(class_constitution/2);

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_max_action_points(
    player_id INTEGER
) RETURNS NUMERIC AS $$
DECLARE
	character_dexterity NUMERIC;
	character_intelligence NUMERIC;
	character_class_id NUMERIC;
	class_action_points_modifier NUMERIC;
	v_result NUMERIC; 
BEGIN
    -- Get the character class ID
    SELECT dexterity
    INTO character_dexterity
    FROM character 
    WHERE id = player_id;
    -- Get the character class ID
    SELECT intelligence
    INTO character_intelligence
    FROM character 
    WHERE id = player_id;
	    -- Get the character class ID
    SELECT class_id
    INTO character_class_id
    FROM character 
    WHERE id = player_id;
    -- Get the character class ID
    SELECT action_points
    INTO class_action_points_modifier
    FROM class
    WHERE id = character_class_id;

    -- Return the sum of both modifiers
    v_result :=(character_dexterity+character_intelligence)*class_action_points_modifier;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_max_action_points(
) RETURNS NUMERIC AS $$
DECLARE

BEGIN
	update character set health= calculate_max_health(1) where character.id=1;
	update character set health= calculate_max_health(2) where character.id=2;

END;
$$ LANGUAGE plpgsql;

select * from "character" c ;
select calculate_damage(2,1);
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(1,1,2,1,null,calculate_damage(2,1),true);
update character set health= character.health-calculate_damage(2,1) where character.id=1;
update character set action_points= character.action_points-calculate_cost(2,1,null) where character.id=2;
update character set health= calculate_max_health(1) where character.id=1;
select * from character;
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(15,1,1,1,null,calculate_max_action_points(1),true);
update character set action_points= calculate_max_action_points(1) where character.id=1;
insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(15,2,2,1,null,calculate_max_action_points(2),true);
update character set action_points= calculate_max_action_points(1) where character.id=1;

insert into action(action_type,target,character_id,combat_id,item_id,effect_value,hit)
values(1,1,2,1,null,calculate_damage(2,1),true);


CREATE OR REPLACE FUNCTION run_damage_action(
	action_type_num INT,
	target_num INT,
	character_num INT,
	combat_num INT,
	item_num INT,
	hit_val BOOL
) RETURNS NUMERIC AS $$
DECLARE
	v_damage_calculated NUMERIC;
	v_cost_calculated NUMERIC;
	v_character_action_points NUMERIC;
	v_d20_roll NUMERIC;
BEGIN
	
	
	SELECT calculate_damage(character_num, action_type_num) INTO v_damage_calculated;
	SELECT calculate_cost(character_num, action_type_num, item_num) INTO v_cost_calculated;
	select action_points into v_character_action_points from character where =character_num;
	IF v_character_action_points IS NULL THEN
        RAISE EXCEPTION 'Character is not in combat';
    END IF;
	IF v_character_action_points < v_cost_calculated THEN
        RAISE EXCEPTION 'Not enough action points';
    END IF;

	IF NOT EXISTS (
    	SELECT 1 FROM character_actions 
    	WHERE character_id = character_num 
    	AND action_type_id = action_type_num
	) THEN
    	RAISE EXCEPTION 'Character does not have access to this action';
	END IF;

	SELECT floor(random() * 20 + 1) INTO v_d20_roll;
	
	-- Log the action
	INSERT INTO action(action_type, target, character_id, combat_id, item_id, effect_value, hit)
	VALUES (action_type_num, target_num, character_num, combat_num, item_num, v_damage_calculated, hit_val);

	-- Deduct action points
	UPDATE character 
	SET action_points = action_points - v_cost_calculated
	WHERE id = character_num;

	-- Apply damage to the target
	UPDATE character 
	SET health = health - v_damage_calculated
	WHERE id = target_num;

	-- Return the damage dealt
	RETURN v_damage_calculated;
END;
$$ LANGUAGE plpgsql;

