-- Indexes for core tables
CREATE INDEX IF NOT EXISTS idx_character_id ON character(id);
CREATE INDEX IF NOT EXISTS idx_character_in_combat ON character(in_combat);
CREATE INDEX IF NOT EXISTS idx_character_class_id ON character(class_id);

-- Combat indexes
CREATE INDEX IF NOT EXISTS idx_combat_id ON combat(id);
CREATE INDEX IF NOT EXISTS idx_combat_num_round ON combat(combat_num, round DESC);
CREATE INDEX IF NOT EXISTS idx_combat_status ON combat(status) WHERE status = 'on-going';

-- Action indexes
CREATE INDEX IF NOT EXISTS idx_action_combat_id ON action(combat_id);
CREATE INDEX IF NOT EXISTS idx_action_character_id ON action(character_id);
CREATE INDEX IF NOT EXISTS idx_action_type_id ON action(action_type);

-- Special function indexes
CREATE INDEX IF NOT EXISTS idx_character_actions ON character_actions(character_id, action_type_id);
CREATE INDEX IF NOT EXISTS idx_character_combat_num ON character(in_combat) WHERE in_combat IS NOT NULL;
CREATE INDEX idx_item_modifier_composite ON item_attribute_modifier(item_id, class_id);