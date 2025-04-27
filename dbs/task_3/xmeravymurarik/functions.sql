CREATE FUNCTION public.effective_spell_cost(player_id integer, action_type_id integer, used_item_id integer) RETURNS numeric
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


ALTER FUNCTION public.effective_spell_cost(player_id integer, action_type_id integer, used_item_id integer) OWNER TO postgres;

--
-- Name: effective_action_damage(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.effective_action_damage(player_id integer, action_type_id integer) RETURNS numeric
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


ALTER FUNCTION public.effective_action_damage(player_id integer, action_type_id integer) OWNER TO postgres;

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
    v_player_combat_num INTEGER;
    v_target_combat_num INTEGER;
    v_combat_id INTEGER;
    v_target_health NUMERIC;
BEGIN
    -- Validate both characters are in the same combat
    SELECT in_combat INTO v_player_combat_num FROM character WHERE id = p_player_id;
    SELECT in_combat INTO v_target_combat_num FROM character WHERE id = p_target_id;
    
    IF v_player_combat_num IS NULL OR v_target_combat_num IS NULL THEN
        RAISE EXCEPTION 'Both characters must be in combat';
    END IF;
    
    IF v_player_combat_num != v_target_combat_num THEN
        RAISE EXCEPTION 'Characters must be in the same combat';
    END IF;
    
    -- Get current combat_id (highest round for this combat_num)
    SELECT id INTO v_combat_id
    FROM combat
    WHERE combat_num = v_player_combat_num
    ORDER BY round DESC
    LIMIT 1;
    
    IF v_combat_id IS NULL THEN
        RAISE EXCEPTION 'Combat session not found';
    END IF;

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
    
    -- Get target info and current health
    SELECT c.class_id, c.dexterity, cl.armor_class, c.health
    INTO v_target_class_id, v_target_dexterity, v_class_armor_class, v_target_health
    FROM character c
    JOIN class cl ON c.class_id = cl.id
    WHERE c.id = p_target_id;
    
    -- Calculate target armor class
    v_target_ac := 10 + (v_target_dexterity/2) + v_class_armor_class;

    -- Calculate action cost
    v_cost := effective_spell_cost(p_player_id, p_action_type_id, p_item_id);
    
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
    v_damage := effective_action_damage(p_player_id, p_action_type_id);
    
    -- Log the action
    INSERT INTO action(
        action_type, target, character_id, 
        combat_id, item_id, effect_value, hit
    ) VALUES (
        p_action_type_id, p_target_id, p_player_id,
        v_combat_id, p_item_id, 
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
        WHERE id = p_target_id
        RETURNING health INTO v_target_health;
        
        -- Check if target died (health reached 0)
        IF v_target_health <= 0 THEN
            -- Log death action
            INSERT INTO action(
                action_type, target, character_id, 
                combat_id, item_id, effect_value, hit
            ) VALUES (
                11, -- Die action type
                p_target_id, p_target_id,
                v_combat_id, NULL, 0, true
            );
            
            -- Remove dead character from combat
            UPDATE character
            SET in_combat = NULL
            WHERE id = p_target_id;
        END IF;
    END IF;

    RETURN CASE WHEN v_hit_success THEN v_damage ELSE 0 END;
END;
$$;

ALTER FUNCTION public.run_damage_action(    p_action_type_id INTEGER,
    p_target_id INTEGER,
    p_player_id INTEGER,
    p_item_id INTEGER) OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.loot_item(
    p_player_id INTEGER,
    p_item_id INTEGER
) RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_item_weight NUMERIC;
    v_item_available BOOLEAN;
    v_current_weight NUMERIC;
    v_max_weight NUMERIC;
    v_character_strength NUMERIC;
    v_character_constitution NUMERIC;
    v_class_inventory_size NUMERIC;
    v_item_name TEXT;
    v_character_name TEXT;
    v_player_combat_num INTEGER;
    v_combat_id INTEGER;
BEGIN
    -- Get player's combat_num
    SELECT in_combat INTO v_player_combat_num 
    FROM character 
    WHERE id = p_player_id;
    
    IF v_player_combat_num IS NULL THEN
        RAISE EXCEPTION 'Player is not in combat';
    END IF;
    
    -- Get current combat_id (highest round for this combat_num)
    SELECT id INTO v_combat_id
    FROM combat
    WHERE combat_num = v_player_combat_num
    ORDER BY round DESC
    LIMIT 1;
    
    IF v_combat_id IS NULL THEN
        RAISE EXCEPTION 'Combat session not found';
    END IF;

    -- Check if item exists in the playground (combat area)
    SELECT EXISTS (
        SELECT 1
        FROM playground
        WHERE item_id = p_item_id
        AND combat_id = v_combat_id
    ) INTO v_item_available;
    
    IF NOT v_item_available THEN
        RAISE EXCEPTION 'Item not available in this combat area';
    END IF;

    -- Get character attributes
    SELECT c.strength, c.constitution, cl.inventory_size, c.name
    INTO v_character_strength, v_character_constitution, v_class_inventory_size, v_character_name
    FROM character c
    JOIN class cl ON c.class_id = cl.id
    WHERE c.id = p_player_id;

    -- Get item details
    SELECT weight, name 
    INTO v_item_weight, v_item_name
    FROM item
    WHERE id = p_item_id;

    -- Calculate current inventory weight
    SELECT COALESCE(SUM(i.weight), 0)
    INTO v_current_weight
    FROM inventory inv
    JOIN item i ON inv.item_id = i.id
    WHERE inv.character_id = p_player_id;

    -- Calculate max weight capacity
    v_max_weight := (v_character_strength + v_character_constitution) * v_class_inventory_size;

    -- Validate weight capacity
    IF (v_current_weight + v_item_weight) > v_max_weight THEN
        RAISE EXCEPTION 'Cannot pick up item: Inventory capacity exceeded (Current: %, Max: %)', 
                        v_current_weight + v_item_weight, v_max_weight;
    END IF;

    -- Add to character inventory
    INSERT INTO inventory(character_id, item_id)
    VALUES (p_player_id, p_item_id);

    -- Log the action
    INSERT INTO action(
        action_type, 
        target, 
        character_id, 
        combat_id, 
        item_id, 
        effect_value, 
        hit
    ) VALUES (
        12, -- Pick Up Item action type
        p_player_id, 
        p_player_id,
        v_combat_id, 
        p_item_id, 
        0, 
        true
    );

    RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION public.rest_character(
    p_character_id INTEGER
) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_max_health NUMERIC;
    v_max_action_points NUMERIC;
    v_character_name TEXT;
    v_current_combat_id INTEGER;
BEGIN
    -- Calculate maximum health and action points
    SELECT calculate_max_health(p_character_id),
           calculate_max_action_points(p_character_id),
           name,
           in_combat  -- Now using the numeric combat ID
    INTO v_max_health,
         v_max_action_points,
         v_character_name,
         v_current_combat_id
    FROM character
    WHERE id = p_character_id;

    -- Update character stats
    UPDATE character
    SET 
        health = v_max_health,
        action_points = v_max_action_points
    WHERE id = p_character_id;

    -- Log the rest action if in combat (combat_id is not null)
    IF v_current_combat_id IS NOT NULL THEN
		raise exception 'Cannot rest. Character is in combat';

    END IF;
        INSERT INTO action(
            action_type, 
            target, 
            character_id, 
            combat_id, 
            effect_value, 
            hit
        ) VALUES (
            7, -- Rest action type
            p_character_id, 
            p_character_id,
            v_current_combat_id, 
            v_max_health, 
            true
        );
END;
$$;


CREATE OR REPLACE FUNCTION public.enter_combat(
    p_combat_id INTEGER,
    p_character_id INTEGER
) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_max_ap NUMERIC;
    v_character_name TEXT;
    v_combat_round INTEGER;
    v_combat_num INTEGER; 
BEGIN
    SELECT combat_num, round 
    INTO v_combat_num, v_combat_round
    FROM combat 
    WHERE id = p_combat_id AND status = 'on-going';
    
    IF v_combat_num IS NULL THEN
        RAISE EXCEPTION 'Combat session has ended';
    END IF;

    -- Validate character exists and isn't already in combat
    IF EXISTS (SELECT 1 FROM character WHERE id = p_character_id AND in_combat IS NOT NULL) THEN
        RAISE EXCEPTION 'Character is already in combat';
    END IF;

    -- Get character info and max AP
    SELECT calculate_max_action_points(p_character_id), name
    INTO v_max_ap, v_character_name
    FROM character
    WHERE id = p_character_id;

    -- Register character in combat (using combat_num)
    UPDATE character
    SET 
        in_combat = v_combat_num,
        action_points = v_max_ap    -- Reset to max AP when entering combat
    WHERE id = p_character_id;

    INSERT INTO action(
        action_type, 
        target, 
        character_id, 
        combat_id,
        effect_value, 
        hit
    ) VALUES (
        9,
        p_character_id, 
        p_character_id,
        p_combat_id, 
        0, 
        true
    );
END;
$$;
create or replace function public.reset_character_stats()returns void language plpgsql as $$ begin 
update character set action_points=calculate_max_action_points(character.id),health=calculate_max_health(character.id),in_combat=NULL;

end;
$$;

CREATE OR REPLACE FUNCTION public.reset_round(
    p_combat_id INTEGER
) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_combat_num INTEGER;
    v_current_round INTEGER;
    v_new_round INTEGER;
    v_combat_status TEXT;
    v_participant_count INTEGER;
BEGIN
    -- Get combat_num and validate combat exists
    SELECT combat_num, round, status
    INTO v_combat_num, v_current_round, v_combat_status
    FROM combat
    WHERE id = p_combat_id;
    
    IF v_combat_num IS NULL THEN
        RAISE EXCEPTION 'Combat session does not exist';
    END IF;
    
    IF v_combat_status != 'on-going' THEN
        RAISE EXCEPTION 'Cannot continue. Combat is finished';
    END IF;

    -- Count participants in this combat
    SELECT COUNT(*) 
    INTO v_participant_count
    FROM character
    WHERE in_combat = v_combat_num;

    -- Determine new status based on participant count
    IF v_participant_count < 2 THEN
        -- End combat if not enough participants
        INSERT INTO combat(combat_num, round, status)
        VALUES (v_combat_num, v_current_round, 'finished');
        
        -- Remove all characters from this combat
        UPDATE character
        SET in_combat = NULL
        WHERE in_combat = v_combat_num;
     
        
        RETURN;
    END IF;

    -- Find the highest round number for this combat_num
    SELECT COALESCE(MAX(round), 0)
    INTO v_current_round
    FROM combat
    WHERE combat_num = v_combat_num;
    
    -- Calculate new round number
    v_new_round := v_current_round + 1;

    -- Reset all characters' AP in this combat
    UPDATE character c
    SET action_points = calculate_max_action_points(c.id)
    WHERE c.in_combat = v_combat_num;

    -- Insert new combat record with incremented round
    INSERT INTO combat(combat_num, round, status)
    VALUES (v_combat_num, v_new_round, 'on-going');
END;
$$;


CREATE OR REPLACE FUNCTION public.delete_all_data()
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Disable triggers temporarily to avoid constraint issues
    SET session_replication_role = replica;

    -- Delete data from all tables in proper order to maintain referential integrity
    DELETE FROM action;
    DELETE FROM inventory;
	DELETE FROM playground;
    DELETE FROM character_actions;
    DELETE FROM item_attribute_modifier;
    DELETE FROM class_attribute_modifier;
    DELETE FROM character;
    DELETE FROM combat;
    DELETE FROM action_type;
    DELETE FROM item;
    DELETE FROM action_category;
    DELETE FROM class;

    -- Re-enable triggers
    SET session_replication_role = origin;
    
    RAISE NOTICE 'All data has been deleted from all tables';
END;
$$;
