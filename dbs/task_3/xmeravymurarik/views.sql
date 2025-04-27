DROP VIEW IF EXISTS public.v_combat_state;
CREATE OR REPLACE VIEW public.v_combat_state AS
SELECT 
    c.id AS combat_id,
    c.combat_num,
    c.round AS current_round,
    c.status AS combat_status,
    ch.name AS character_name,
    ch.action_points AS remaining_ap
FROM 
    combat c
JOIN 
    character ch ON ch.in_combat = c.combat_num
JOIN 
    class cl ON ch.class_id = cl.id
WHERE 
    c.id = (
        SELECT id 
        FROM combat 
        WHERE combat_num = c.combat_num 
        ORDER BY round DESC 
        LIMIT 1
    )
ORDER BY 
    c.combat_num;
    
DROP VIEW IF EXISTS public.v_most_damage;
CREATE OR REPLACE VIEW public.v_most_damage AS
SELECT 
    c.id AS character_id,
    c.name AS character_name,
    cl.name AS class_name,
    SUM(CASE WHEN a.hit THEN a.effect_value ELSE 0 END) AS total_damage_dealt
FROM 
    character c
JOIN 
    action a ON c.id = a.character_id
JOIN 
    class cl ON c.class_id = cl.id
WHERE 
    a.action_type IN (1, 2)  -- Assuming 1=spell, 2=attack
GROUP BY 
    c.id, c.name, cl.name
ORDER BY 
    total_damage_dealt DESC;






CREATE OR REPLACE VIEW public.v_strongest_characters AS
WITH character_stats AS (
    SELECT
        c.id,
        c.name,
        cl.name AS class_name,
        MAX(c.health) AS max_health,
        SUM(CASE WHEN a.hit THEN a.effect_value ELSE 0 END) AS total_damage,
        COUNT(DISTINCT a.combat_id) AS combats_participated,
        COUNT(CASE WHEN a.action_type = 3 THEN 1 END) AS heals_performed  -- Assuming 3=heal
    FROM
        character c
    JOIN 
        class cl ON c.class_id = cl.id
    LEFT JOIN 
        action a ON c.id = a.character_id
    GROUP BY
        c.id, c.name, cl.name
)
SELECT
    id,
    name,
    class_name,
    max_health,
    total_damage,
    combats_participated,
    heals_performed,
    total_damage / NULLIF(combats_participated, 0) AS avg_damage_per_combat,
    RANK() OVER (ORDER BY total_damage DESC) AS damage_rank,
    RANK() OVER (ORDER BY max_health DESC) AS toughness_rank
FROM
    character_stats
ORDER BY
    (total_damage * 0.8 + max_health * 0.2) DESC;  -- I've received a hint that this stuff is cool
    
    
    
    
    
        
DROP VIEW IF EXISTS public.v_combat_damage;
CREATE OR REPLACE VIEW public.v_combat_damage AS
SELECT 
    c.combat_num,
    SUM(CASE WHEN a.hit THEN a.effect_value ELSE 0 END) AS total_damage_inflicted
FROM 
    combat c
LEFT JOIN 
    action a ON c.id = a.combat_id
WHERE 
    a.action_type IN (1, 2,4)
GROUP BY 
    c.combat_num
ORDER BY 
    c.combat_num;



DROP VIEW IF EXISTS public.v_spell_statistics;
CREATE OR REPLACE VIEW public.v_spell_statistics AS
SELECT
    at.id AS action_type_id,
    at.name AS spell_name,
    ac.name AS category,
    COUNT(a.id) AS cast_count,
    COUNT(CASE WHEN a.hit THEN 1 END) AS hit_count,
    SUM(CASE WHEN a.hit THEN a.effect_value ELSE 0 END) AS total_damage
FROM
    action_type at
JOIN
    action_category ac ON at.action_category = ac.id
LEFT JOIN
    action a ON at.id = a.action_type
WHERE
    at.action_category IN (1,2, 4)
GROUP BY
    at.id, at.name, ac.name
ORDER BY
    total_damage DESC;