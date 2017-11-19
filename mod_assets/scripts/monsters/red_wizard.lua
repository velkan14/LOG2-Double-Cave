defineMaterial{
	name = "red_wizard",
	diffuseMap = "mod_assets/textures/monsters/red_wizard_grey_dif.tga",
	specularMap = "mod_assets/textures/monsters/red_wizard_spec.tga",
	normalMap = "assets/textures/monsters/wizard_normal.tga",
	doubleSided = false,
	lighting = true,
	alphaTest = false,
	blendMode = "Opaque",
	textureAddressMode = "Wrap",
	glossiness = 20,
	depthBias = 0,
}

defineObject{
	name = "red_wizard",
	baseObject = "base_monster",
	components = {
		{
			class = "Model",
			model = "assets/models/monsters/wizard.fbx",
			material = "red_wizard",
			storeSourceData = true,
		},
		{
			class = "Animation",
			animations = {
				idle = "assets/animations/monsters/wizard/wizard_idle.fbx",
				moveForward = "assets/animations/monsters/wizard/wizard_idle.fbx",
				turnLeft = "assets/animations/monsters/wizard/wizard_turn_left.fbx",
				turnRight = "assets/animations/monsters/wizard/wizard_turn_right.fbx",
				warp = "assets/animations/monsters/wizard/wizard_idle.fbx",
				attack = "assets/animations/monsters/wizard/wizard_cast_spell.fbx",
				push = "assets/animations/monsters/wizard/wizard_push.fbx",
				castSpell = "assets/animations/monsters/wizard/wizard_cast_spell.fbx",
				shieldSpell = "assets/animations/monsters/wizard/wizard_shield.fbx",
				mirrorImageSpell = "assets/animations/monsters/wizard/wizard_mirror_image.fbx",
				iceShardsSpell = "assets/animations/monsters/wizard/wizard_ice_shards.fbx",
				teleport = "assets/animations/monsters/wizard/wizard_teleport.fbx",
				getHitFrontLeft = "assets/animations/monsters/wizard/wizard_get_hit_front_left.fbx",
				getHitFrontRight = "assets/animations/monsters/wizard/wizard_get_hit_front_right.fbx",
				getHitBack = "assets/animations/monsters/wizard/wizard_get_hit_back.fbx",
				getHitLeft = "assets/animations/monsters/wizard/wizard_get_hit_left.fbx",
				getHitRight = "assets/animations/monsters/wizard/wizard_get_hit_right.fbx",
				fall = "assets/animations/monsters/wizard/wizard_get_hit.fbx",
				checkDoor = "assets/animations/monsters/wizard/wizard_check_door.fbx",
				neutralPose = "assets/animations/monsters/wizard/wizard_neutral_pose.fbx",
				letter = "assets/animations/monsters/wizard/wizard_letter.fbx",
				crystal = "assets/animations/monsters/wizard/wizard_crystal.fbx",
			},
			currentLevelOnly = true,
		},
		{
			class = "Monster",
			meshName = "wizard_mesh",
			hitSound = "wizard_hit",
			--dieSound = "goromorg_die",
			hitEffect = "hit_dust",
			deathEffect = "wizard_death",
			capsuleHeight = 0.8,
			capsuleRadius = 0.25,
			collisionRadius = 0.8,
			health = 1500,
			protection = 0,
			immunities = { "sleep", "blinded", "frozen", "knockback" },
			-- resistances = {
			-- 	["fire"] = "immune",
			-- 	["cold"] = "immune",
			-- 	["poison"] = "immune",
			-- 	["shock"] = "immune",
			-- },
		},
		{
			class = "MonsterMove",
			name = "move",
			--sound = "goromorg_walk",
			cooldown = 1,
			animationSpeed = 1,
		},
		{
			class = "MonsterWarp",
			name = "warp",
			sound = "wizard_warp",
			cooldown = 3,
			animation = "warp",
			animationSpeed = 1,
		},
		{
			class = "MonsterTurn",
			name = "turn",
			sound = "wizard_turn",
			animationSpeed = 1,
		},
		{
			class = "MonsterAttack",
			name = "basicAttack",
			accuracy = 100,
			attackPower = 40,
			cooldown = 6,
			animation = "push",
			knockback = true,
			screenEffect = "teleport_screen",
			sound = "wizard_push",
			onDealDamage = function(self, target, dmg)
				for i=1,4 do
					local ch = party.party:getChampion(i)
					if ch:isAlive() and ch ~= target then
						local dmg = dmg + math.random(-10, 10)
						if dmg > 0 then
							ch:damage(dmg, "physical")
							ch:playDamageSound()
						end
					end
				end
			end,
		},
		{
			class = "MonsterAttack",
			name = "rangedAttack",
			attackPower = 40,
			cooldown = 6,
			animation = "castSpell",
			sound = "wizard_ranged_attack",
			onAttack = function(self)
				local h = 1.4

				local r = math.random()
				if r < 0.53 then
					-- cast fireball
					self.go.monster:shootProjectile("fireball_large", h, 40)
				elseif r < 0.82 then
					-- cast lightning bolt
					self.go.monster:shootProjectile("lightning_bolt_greater", h, 40)
				else
					-- cast poison bolt
					self.go.monster:shootProjectile("poison_bolt_greater", h, 40)
				end
			end,
		},
		{
			class = "MonsterAttack",
			name = "shootBlob",
			attackType = "projectile",
			cooldown = 6,
			repeatChance = 0,
			projectileHeight = 1.15,
			animation = "castSpell",
			sound = "wizard_ranged_attack",
			shootProjectile = "blob",
		},
		{
			class = "MonsterAttack",
			name = "iceShards",
			cooldown = 13,
			animation = "iceShardsSpell",
			sound = "wizard_ranged_attack",
			onAttack = function(self)
				local dx,dy = getForward(self.go.facing)
				local x = self.go.x + dx
				local y = self.go.y + dy
				local spell = spawn("ice_shards", self.go.level, x, y, self.go.facing, self.go.elevation)
				spell.tiledamager:setAttackPower(40)
			end,
		},
		{
			class = "MonsterAction",
			name = "escape",
			animation = "teleport",
			onEndAction = function(self)
				spawn("teleportation_effect", self.go.level, self.go.x, self.go.y, self.go.facing, self.go.elevation)
				self.go.monster:dropAllItems()
				self.go:destroy()
			end,
		},
		{
			class = "MonsterAction",
			name = "mirrorImage",
			animation = "mirrorImageSpell",
			cooldown = 50,
			onAnimationEvent = function(self, event)
				if event == "attack" then
					local x,y = self.go.x,self.go.y
					local rdx,rdy = getForward((self.go.facing + 1) % 4)

					for i=-1,1,2 do
						local x = x + rdx * i
						local y = y + rdy * i
						
						if not self.go.map:isBlocked(x, y, self.go.elevation) and self.go.elevation == self.go.map:getElevation(x, y) then
							local obj = self.go:spawn("wizard_clone")
							obj.mirrorImage:disable()
							obj.castShield:disable()
							obj.brain:performAction("warp", x, y, i + 2)
						end
					end
				end
			end,
		},
		{
			class = "MonsterAttack",
			name = "castShield",
			animation = "shieldSpell",
			sound = "wizard_shield",
			cooldown = 100,
			repeatChance = 0,
			onAttack = function(self)
				if not self.go.goromorgshield then
					self.go:createComponent("GoromorgShield")
				end
				self.go.goromorgshield:setEnergy(500)
			end,
		},
		{
			class = "MonsterAction",
			name = "checkDoor",
			animation = "checkDoor",
		},
		{
			class = "MonsterAction",
			name = "crystal",
			animation = "crystal",
			onEndAction = function(self)
				spawn("teleportation_effect", self.go.level, self.go.x, self.go.y, self.go.facing, self.go.elevation)
				self.go.monster:dropAllItems()
				self.go:destroy()
			end,
		},
		{
			class = "MonsterAction",
			name = "letter",
			animation = "letter",
			onEndAction = function(self)
				spawn("teleportation_effect", self.go.level, self.go.x, self.go.y, self.go.facing, self.go.elevation)
				self.go.monster:dropAllItems()
				self.go:destroy()
			end,
		},
		{
			class = "Particle",
			parentNode = "light1",
			particleSystem = "red_wizard_lantern",
		},
		{
			class = "Light",
			parentNode = "light1",
			color = vec(2.5, 1.0, 0.5),
			brightness = 1.5,
			range = 3,
			fillLight = true,
		},
		{
			class = "Particle",
			name = "warpParticles",
			particleSystem = "wizard_warp",
			emitterMesh = "assets/models/monsters/wizard_silhouette_edges.fbx",
			enabled = false,
		},
		{
			class = "WizardBrain",
			name = "brain",
			sight = 5,
			seeInvisible = true,
			allAroundSight = true,
			morale = 100,
		},
	},
}

defineParticleSystem{
	name = "red_wizard_lantern",
	emitters = {
		-- smoke
		{
			emissionRate = 5,
			emissionTime = 0,
			maxParticles = 50,
			boxMin = {-0.03, 0.0, -0.03},
			boxMax = { 0.03, 0.0,  0.03},
			sprayAngle = {0,30},
			velocity = {0.1,0.5},
			texture = "assets/textures/particles/smoke_01.tga",
			lifetime = {1,1},
			color0 = {0.15, 0.11, 0.08},
			opacity = 0.2,
			fadeIn = 0.5,
			fadeOut = 0.5,
			size = {0.3, 0.3},
			gravity = {0,0,0},
			airResistance = 0.1,
			rotationSpeed = 0.6,
			blendMode = "Translucent",
			objectSpace = false,
		},

		-- flames
		{
			emissionRate = 30,
			emissionTime = 0,
			maxParticles = 100,
			boxMin = {-0.03, -0.07, 0.03},
			boxMax = { 0.03, -0.07,  -0.03},
			sprayAngle = {0,10},
			velocity = {0.1, 0.4},
			texture = "assets/textures/particles/goromorg_lantern.tga",
			frameRate = 45,
			frameSize = 64,
			frameCount = 16,
			lifetime = {0.25, 0.85},
			colorAnimation = false,
			color0 = {2, 0, 0},
			opacity = 1,
			fadeIn = 0.15,
			fadeOut = 0.3,
			size = {0.17, 0.015},
			gravity = {0,0,0},
			airResistance = 1.0,
			rotationSpeed = 1,
			blendMode = "Additive",
			depthBias = 0,
			objectSpace = true,
		},

		-- inner glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {0,0,0},
			boxMax = {0,0,0},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.23, 0.11, 0.07},
			opacity = 1,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {0.5, 0.5},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		},

		-- outer glow
		{
			spawnBurst = true,
			emissionRate = 1,
			emissionTime = 0,
			maxParticles = 1,
			boxMin = {0,0,0},
			boxMax = {0,0,0},
			sprayAngle = {0,30},
			velocity = {0,0},
			texture = "assets/textures/particles/glow.tga",
			lifetime = {1000000, 1000000},
			colorAnimation = false,
			color0 = {0.23, 0.11, 0.07},
			opacity = 0.25,
			fadeIn = 0.1,
			fadeOut = 0.1,
			size = {2, 2},
			gravity = {0,0,0},
			airResistance = 1,
			rotationSpeed = 0,
			blendMode = "Additive",
			depthBias = 0.1,
			objectSpace = true,
		}
	}
}


