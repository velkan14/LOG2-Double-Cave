for i=0,2 do
	local str = function(str) return (string.gsub(str, "?", iff(i > 0, i, ""))) end
	defineObject{
		name = str("skeleton_trooper?"),
		baseObject = "base_monster",
		components = {
			{
				class = "Model",
				model = "assets/models/monsters/skeleton_knight_trooper.fbx",
				storeSourceData = true, -- must be enabled for mesh particles to work
			},
			{
				class = "Animation",
				animations = {
					idle = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_idle.fbx"),
					moveForward = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_walk.fbx"),
					turnLeft = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_turn_left.fbx"),
					turnRight = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_turn_right.fbx"),
					turnLeftNormal = "assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper_turn_left.fbx",
					turnRightNormal = "assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper_turn_right.fbx",
					attack = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_attack.fbx"),
					--attack2 = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_power_attack.fbx"),
					--attack3 = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_swing_attack.fbx"),
					turnAttackLeft = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper_turn_attack_left.fbx"),
					turnAttackRight = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper_turn_attack_right.fbx"),
					getHitFrontLeft = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_get_hit_front_left.fbx"),
					getHitFrontRight = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_get_hit_front_right.fbx"),
					getHitBack = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_get_hit_back.fbx"),
					getHitLeft = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_get_hit_left.fbx"),
					getHitRight = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_get_hit_right.fbx"),
					fall = str("assets/animations/monsters/skeleton_knight_trooper/skeleton_knight_trooper?_get_hit_front_left.fbx"),
				},
				currentLevelOnly = true,
			},
			{
				class = "Monster",
				meshName = "skeleton_knight_trooper_mesh",
				footstepSound = "skeleton_footstep",
				hitSound = "skeleton_hit",
				dieSound = "skeleton_die",
				hitEffect = "hit_dust",
				capsuleHeight = 0.7,
				capsuleRadius = 0.25,
				collisionRadius = 0.6,
				health = 150,
				immunities = { "sleep", "blinded" },
				resistances = {
					["poison"] = "immune",
					["shock"] = "weak",
				},
				traits = { "undead" },
				evasion = 0,
				protection = 5,
				exp = 0,
				lootDrop = { 100, "skeleton_knight_shield" },
				onUnlinkMonsterGroup = function(self)
					self.go.turn:setTurnLeftAnimation("turnLeftNormal")
					self.go.turn:setTurnRightAnimation("turnRightNormal")
				end,
			},
			{
				class = "MeleeBrain",
				name = "brain",
				sight = 4,
				morale = 100,	-- fearless
			},
			{
				class = "MonsterMove",
				name = "move",
				sound = "skeleton_walk",
				cooldown = 6,
			},
			{
				class = "MonsterTurn",
				name = "turn",
				sound = "skeleton_walk",
			},
			{
				class = "MonsterAttack",
				name = "basicAttack",
				attackPower = 20,
				cooldown = 4,
				sound = "skeleton_trooper_attack",
				onBeginAction = function(self)
					-- randomize animation
					local r = math.random()
					--if r < 0.33 then
						self:setAnimation("attack")
					--elseif r < 0.66 then
					--	self:setAnimation("attack2")
					--else
					--	self:setAnimation("attack3")
					--end
				end,
			},
			{
				class = "MonsterAttack",
				name = "turnAttack",
				attackPower = 20,
				cooldown = 4,
				sound = "skeleton_trooper_attack",
				turnToAttackDirection = true,
			},
		},
	}
end
