DO $$
DECLARE
    v_result NUMERIC;
    v_expected NUMERIC := 60;
BEGIN

    -- Execution
    v_result := calculate_max_action_points(1);
    
    -- Verification
    IF v_result != v_expected THEN
        RAISE EXCEPTION 'Test failed: Expected %, got %', v_expected, v_result;
    END IF;
    
    -- Teardown (optional)
    
    RAISE NOTICE 'Test passed!';
END $$;
-- Test: AP restoration
DO $$
BEGIN
	perform define_environment();
    
    INSERT INTO combat(id,combat_num, round,status) VALUES (1,1, 1,'on-going');
    perform enter_combat(1,1);
	perform enter_combat(1,2);
    PERFORM reset_round(1);
    
    ASSERT (SELECT SUM(action_points) FROM character WHERE in_combat = 1) = 
           (SELECT SUM(calculate_max_action_points(id)) FROM character WHERE in_combat = 1),
           'AP not reset properly';
	RAISE NOTICE 'Test passed!';
END $$;

-- Test: Weight limit enforcement
DO $$
DECLARE
    v_max_weight NUMERIC;
BEGIN
    PERFORM define_environment();
    
    -- Setup combat
    INSERT INTO combat(id, combat_num, round, status) 
    VALUES (3, 1, 1, 'on-going');
    
    -- Create character with KNOWN weight limit
    INSERT INTO character (id, name, class_id, health, action_points, 
                          strength, dexterity, constitution, intelligence, in_combat)
    VALUES (123, 'Test Dummy', 1, 100, 10, 10, 10, 10, 10, 1);  -- Warrior class
    
    -- Calculate exact max weight for this character
    SELECT (strength + constitution) * (SELECT inventory_size FROM class WHERE id = 1)
    INTO v_max_weight
    FROM character WHERE id = 123;
    
    RAISE NOTICE 'Max weight: %', v_max_weight;
    
    -- Create item that JUST exceeds capacity
    INSERT INTO item (id, name,description,base_damage, weight)
    VALUES (123, 'Overweight Spear', 'dummy desc',10,v_max_weight +1);
    
    INSERT INTO playground(combat_id, item_id) VALUES (3, 123);
    
    BEGIN
        PERFORM loot_item(123, 123);  -- Try to loot
        	RAISE NOTICE 'Test failed - should have blocked overweight item';
    EXCEPTION WHEN others THEN
        IF SQLERRM LIKE 'Cannot pick up item: Inventory capacity exceeded%' THEN
            RAISE NOTICE 'PASSED: Correctly blocked overweight item';
        ELSE
            RAISE NOTICE 'Wrong error: %', SQLERRM;
        END IF;
    END;
END $$;

-- Test v_most_damage view
DO $$
BEGIN
    -- Clear existing data
    PERFORM define_environment();
    
    -- Setup combat
    INSERT INTO combat(id, combat_num, round, status) 
    VALUES (1, 1, 1, 'on-going');
    
    INSERT INTO action (id, action_type, target, character_id, combat_id, item_id, effect_value, hit)
    VALUES 
        (1, 2, 2, 1, 1, NULL, 50, true),
        (2, 2, 2, 1, 1, NULL, 30, true),
        (3, 2, 1, 2, 1, NULL, 10, true);
    

    IF (SELECT total_damage_dealt FROM v_most_damage WHERE character_id = 1) != 80 THEN
        RAISE EXCEPTION 'Damage aggregation failed: Expected 80, got %', 
                        (SELECT total_damage_dealt FROM v_most_damage WHERE character_id = 1);
    END IF;
    
    IF (SELECT total_damage_dealt FROM v_most_damage WHERE character_id = 2) != 10 THEN
        RAISE EXCEPTION 'Secondary damage aggregation failed';
    END IF;
    
    RAISE NOTICE '
Test passed successfully';
END $$;

select * from inventory;
select * from playground;