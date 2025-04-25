CREATE FUNCTION public.calculate_cost(player_id integer, action_type_id integer, used_item_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.calculate_cost(player_id integer, action_type_id integer, used_item_id integer) OWNER TO postgres;

--
-- Name: calculate_damage(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_damage(player_id integer, action_type_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.calculate_damage(player_id integer, action_type_id integer) OWNER TO postgres;

--
-- Name: calculate_max_action_points(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_max_action_points(player_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.calculate_max_action_points(player_id integer) OWNER TO postgres;

--
-- Name: calculate_max_health(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_max_health(player_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.calculate_max_health(player_id integer) OWNER TO postgres;

--
-- Name: run_damage_action(integer, integer, integer, integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--
DROP FUNCTION IF EXISTS public.run_damage_action(p_action_type_id integer, p_target_id integer, p_player_id integer, p_item_id integer);
CREATE OR REPLACE FUNCTION public.run_damage_action(
    p_action_type_id INTEGER,
    p_target_id INTEGER,
    p_player_id INTEGER,
    p_combat_id INTEGER,
    p_item_id INTEGER
) RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_damage NUMERIC;
    v_cost NUMERIC;
    v_has_action BOOLEAN;
    v_d20_roll NUMERIC;
    v_roll_bonus NUMERIC;
    v_target_ac NUMERIC;
    v_current_ap NUMERIC;
    v_hit_success BOOLEAN;
    v_character_class_id INTEGER;
    v_target_class_id INTEGER;
    v_action_category_id INTEGER;
    v_target_dexterity NUMERIC;
    v_class_armor_class NUMERIC;
    v_character_dexterity NUMERIC;
BEGIN
    -- Validate character owns the action
    SELECT EXISTS (
        SELECT 1 FROM character_actions 
        WHERE character_id = p_player_id
        AND action_type_id = p_action_type_id
    ) INTO v_has_action;
    
    IF NOT v_has_action THEN
        RAISE EXCEPTION 'Character does not have access to this action type';
    END IF;

    -- Get action category for modifiers
    SELECT action_category INTO v_action_category_id
    FROM action_type WHERE id = p_action_type_id;

    -- Get character info
    SELECT class_id, action_points, dexterity 
    INTO v_character_class_id, v_current_ap, v_character_dexterity
    FROM character WHERE id = p_player_id;
    
    -- Get target info
    SELECT c.class_id, c.dexterity, cl.armor_class 
    INTO v_target_class_id, v_target_dexterity, v_class_armor_class
    FROM character c
    JOIN class cl ON c.class_id = cl.id
    WHERE c.id = p_target_id;
    
    -- Calculate target armor class
    v_target_ac := 10 + (v_target_dexterity/2) + v_class_armor_class;

    -- Calculate action cost
    v_cost := calculate_cost(p_player_id, p_action_type_id, p_item_id);
    
    -- Validate AP
    IF v_current_ap < v_cost THEN
        RAISE EXCEPTION 'Not enough action points';
    END IF;

    -- Roll for hit (d20)
    v_d20_roll := floor(random() * 20 + 1);
    
    -- Calculate roll bonus (sum of class_attribute_modifier values)
    SELECT COALESCE(SUM(value), 0) 
    INTO v_roll_bonus
    FROM class_attribute_modifier 
    WHERE action_category_id = v_action_category_id 
      AND class_id = v_character_class_id;
    
    -- Determine hit success
    v_hit_success := (v_d20_roll + v_roll_bonus) >= v_target_ac;
    
    -- Calculate damage using your existing function
    v_damage := calculate_damage(p_player_id, p_action_type_id);
    
    -- Log the action
    INSERT INTO action(
        action_type, target, character_id, 
        combat_id, item_id, effect_value, hit
    ) VALUES (
        p_action_type_id, p_target_id, p_player_id,
        p_combat_id, p_item_id, 
        CASE WHEN v_hit_success THEN v_damage ELSE 0 END,
        v_hit_success
    );

    -- Deduct action points
    UPDATE character 
    SET action_points = action_points - v_cost
    WHERE id = p_player_id;

    -- Apply damage if hit
    IF v_hit_success THEN
        UPDATE character 
        SET health = GREATEST(0, health - v_damage)  -- Prevent negative health
        WHERE id = p_target_id;
    END IF;

    RETURN CASE WHEN v_hit_success THEN v_damage ELSE 0 END;
END;
$$;

ALTER FUNCTION public.run_damage_action(action_type_num integer, target_num integer, character_num integer, combat_num integer, item_num integer, hit_val boolean) OWNER TO postgres;

DROP FUNCTION pick_up_item(integer,integer,integer);

create or replace
function public.pick_up_item(
    p_player_id INTEGER,
    p_combat_id INTEGER,
    p_item_id INTEGER
) returns BOOLEAN
language plpgsql
as $$
declare
    v_item_weight numeric;

v_item_available BOOLEAN;

v_current_weight numeric;

v_max_weight numeric;

v_character_strength numeric;

v_character_constitution numeric;

v_class_inventory_size numeric;

v_item_name TEXT;

v_character_name TEXT;

begin
-- Check if item exists in the playground (combat area)
    select
	exists (
	select
		1
	from
		playground_items
	where
		item_id = p_item_id
		and combat_id = p_combat_id
    )
into
	v_item_available;

if not v_item_available then
        raise exception 'Item not available in this combat area';
end if;
-- Get character attributes
    select
	c.strength,
	c.constitution,
	cl.inventory_size,
	c.name
    into
	v_character_strength,
	v_character_constitution,
	v_class_inventory_size,
	v_character_name
from
	character c
join class cl on
	c.class_id = cl.id
where
	c.id = p_player_id;
-- Get item details
    select
	weight,
	name
into
	v_item_weight,
	v_item_name
from
	item
where
	id = p_item_id;
-- Calculate current inventory weight
    select
	coalesce(SUM(i.weight), 0)
    into
	v_current_weight
from
	inventory inv
join item i on
	inv.item_id = i.id
where
	inv.character_id = p_player_id;
-- Calculate max weight capacity
v_max_weight := (v_character_strength + v_character_constitution) * v_class_inventory_size;
-- Validate weight capacity
    if (v_current_weight + v_item_weight) > v_max_weight then
        raise exception 'Cannot pick up item: Inventory capacity exceeded (Current: %, Max: %)', 
                        v_current_weight + v_item_weight,
v_max_weight;
end if;
-- Remove item from playground(Not done because the way I designed my game and so there is no need for removing it)
-- Add to character inventory
    insert
	into
	inventory(character_id, item_id)
values (p_player_id,
p_item_id);
-- Log the action
    insert
	into
	action(
        action_type, 
        target, 
        character_id, 
        combat_id, 
        item_id, 
        effect_value, 
        hit,
        description
    )
values (
        12,
        p_player_id, 
        p_player_id,
        p_combat_id, 
        p_item_id, 
        0, 
        true,
        v_character_name || ' picked up ' || v_item_name
    );

return true;
end;

$$;
