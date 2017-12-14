for i=0,3 do
	local str = function(str) return (string.gsub(str, "?", iff(i > 0, i, ""))) end
	defineObject{
		name = str("mummy?"),
		baseObject = "base_monster",
		components = {
			{
				class = "Model",
				model = str("assets/models/monsters/mummy?.fbx"),
				storeSourceData = true,
			},
			{
				class = "Animation",
				animations = {
					idle = str("assets/animations/monsters/mummy/mummy?_idle.fbx"),
					moveForward = str("assets/animations/monsters/mummy/mummy?_walk.fbx"),
					turnLeft = str("assets/animations/monsters/mummy/mummy?_turn_left.fbx"),
					turnRight = str("assets/animations/monsters/mummy/mummy?_turn_right.fbx"),
					attack = str("assets/animations/monsters/mummy/mummy?_attack.fbx"),
					getHitFrontLeft = str("assets/animations/monsters/mummy/mummy?_get_hit_front_left.fbx"),
					getHitFrontRight = str("assets/animations/monsters/mummy/mummy?_get_hit_front_right.fbx"),
					getHitBack = str("assets/animations/monsters/mummy/mummy?_get_hit_back.fbx"),
					getHitLeft = str("assets/animations/monsters/mummy/mummy?_get_hit_left.fbx"),
					getHitRight = str("assets/animations/monsters/mummy/mummy?_get_hit_right.fbx"),
					fall = str("assets/animations/monsters/mummy/mummy?_get_hit_front_left.fbx"),
				},
				currentLevelOnly = true,
			},
			{
				class = "Monster",
				meshName = "mummy_mesh",
				hitSound = "mummy_hit",
				dieSound = "mummy_die",
				footstepSound = "mummy_footstep",
				hitEffect = "hit_dust",
				capsuleHeight = 0.2,
				capsuleRadius = 0.7,
				collisionRadius = 0.7,
				health = 120,
				evasion = 0,
				exp = 0,
				immunities = { "sleep", "blinded" },
				resistances = {
					["fire"] = "weak",
					["poison"] = "immune",
				},
				traits = { "undead" },
				headRotation = vec(0, 0, 90),
			},
			{
				class = "MeleeBrain",
				name = "brain",
				sight = 5,
				morale = 100,
			},
			{
				class = "MonsterMove",
				name = "move",
				sound = "mummy_walk",
				cooldown = 5,
				animationSpeed = 0.8,
			},
			{
				class = "MonsterTurn",
				name = "turn",
				sound = "mummy_walk",
			},
			{
				class = "MonsterAttack",
				name = "basicAttack",
				attackPower = 11,
				cooldown = 4,
				-- sound = "mummy_attack",
				animationSpeed = 0.8,
			},
		},
	}
end
