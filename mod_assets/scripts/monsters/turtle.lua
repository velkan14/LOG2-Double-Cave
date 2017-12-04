defineObject{
	name = "turtle",
	baseObject = "base_monster",
	components = {
		{
			class = "Model",
			model = "assets/models/monsters/turtle.fbx",
			storeSourceData = true, -- must be enabled for mesh particles to work
		},
		{
			class = "Animation",
			animations = {
				idle = "assets/animations/monsters/turtle/turtle_idle.fbx",
				moveForward = "assets/animations/monsters/turtle/turtle_walk.fbx",
				turnLeft = "assets/animations/monsters/turtle/turtle_turn_left.fbx",
				turnRight = "assets/animations/monsters/turtle/turtle_turn_right.fbx",
				attack = "assets/animations/monsters/turtle/turtle_attack.fbx",
				attack2 = "assets/animations/monsters/turtle/turtle_attack2.fbx",
				moveAttack = "assets/animations/monsters/turtle/turtle_move_attack.fbx",
				getHitFrontLeft = "assets/animations/monsters/turtle/turtle_get_hit_front_left.fbx",
				getHitFrontRight = "assets/animations/monsters/turtle/turtle_get_hit_front_right.fbx",
				getHitBack = "assets/animations/monsters/turtle/turtle_get_hit_back.fbx",
				getHitLeft = "assets/animations/monsters/turtle/turtle_get_hit_left.fbx",
				getHitRight = "assets/animations/monsters/turtle/turtle_get_hit_right.fbx",
				fall = "assets/animations/monsters/turtle/turtle_get_hit_front_left.fbx",
				alert = "assets/animations/monsters/turtle/turtle_alert.fbx",
			},
			currentLevelOnly = true,
		},
		{
			class = "Monster",
			meshName = "turtle_mesh",
			hitSound = "turtle_hit",
			dieSound = "turtle_die",
			footstepSound = "turtle_footstep",
			hitEffect = "hit_blood",
			capsuleHeight = 0.2,
			capsuleRadius = 0.7,
			health = 40,
			evasion = -10,
			exp = 0,
			lootDrop = { 75, "turtle_steak", 75, "turtle_steak" },
			resistances = { ["poison"] = "weak" },
			traits = { "animal" },
			headRotation = vec(90, 0, 0),
		},
		{
			class = "TurtleBrain",
			name = "brain",
			sight = 3,
		},
		{
			class = "MonsterMove",
			name = "move",
			sound = "turtle_walk",
			cooldown = 10,
			dashChance = 50,
		},
		{
			class = "MonsterTurn",
			name = "turn",
			sound = "turtle_walk",
		},
		{
			class = "MonsterAttack",
			name = "basicAttack",
			attackPower = 8,
			cooldown = 5,
			-- sound = "turtle_attack",
			onBeginAction = function(self)
				-- randomize animation
				if math.random() < 0.8 then
					self:setAnimation("attack")
					self.go:playSound("turtle_attack")
				else
					self:setAnimation("attack2")	-- double attack
					self.go:playSound("turtle_double_attack")
				end
			end,
		},
		{
			class = "MonsterMoveAttack",
			name = "moveAttack",
			attackPower = 8,
			cooldown = 30,
			animation = "moveAttack",
			sound = "turtle_move_attack",
		},
		{
			class = "MonsterAction",
			name = "alert",
			cooldown = 100,
			animation = "alert",
		},
	},
}
