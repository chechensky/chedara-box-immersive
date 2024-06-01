AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Mannytko"
ENT.Category = "JMod - EZ Homicide"
ENT.PrintName = "EZ Molotov Cocktail"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.JModPreferredCarryAngles = angle_zero
ENT.JModEZstorable = true
ENT.JModHighlyFlammableFunc = "Arm"
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "State")
end

if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 15
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(angle_zero)
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/w_models/weapons/w_eq_molotov.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(ONOFF_USE)
		if self:GetPhysicsObject():IsValid() then
			self:GetPhysicsObject():SetMass(35)
			self:GetPhysicsObject():Wake()
		end

		self.Fuze = 100
		self:SetState(JMod.EZ_STATE_OFF)
		if istable(WireLib) then
			self.Inputs = WireLib.CreateInputs(self, {"Detonate", "Arm"}, {"Directly detonates the molotov", "Arms molotov when > 0"})
			self.Outputs = WireLib.CreateOutputs(self, {"State", "Fuse"}, {"-1 broken \n 0 off \n 1 armed", "How much time is left"})
		end
	end

	function ENT:TriggerInput(iname, value)
		if (iname == "Detonate") and (value > 0) then
			self:Detonate()
		elseif iname == "Arm" and value > 0 then
			self:Arm()
		end
	end

	function ENT:Break()
		local Eff = EffectData()
		Eff:SetOrigin(self:GetPos())
		Eff:SetEntity(self)
		Eff:SetMagnitude(.5)
		Eff:SetScale(30)
		Eff:SetColor(120, 60, 0)
		Eff:SetNormal(VectorRand())
		util.Effect("eff_jack_iceimpact", Eff, true, true)
		self:EmitSound("GlassBottle.Break", 100, math.random(90, 110))
		for i = 0, 10 do
			local Tr = util.QuickTrace(self:GetPos(), VectorRand() * math.random(10, 150), {self})
			if Tr.Hit then
				util.Decal("BeerSplash", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
			end
		end

		local Eff2 = EffectData()
		Eff2:SetOrigin(self:GetPos())
		Eff2:SetStart(self:GetVelocity())
		util.Effect("eff_jack_gmod_blackpowderpour", Eff2, true, true)
		local Tr = util.QuickTrace(self:GetPos(), Vector(0, 0, -200), {self})
		if Tr.Hit then
			for i = 0, math.random(4, 8) do
				local Powder = ents.Create("ent_jack_gmod_ezblackpowderpile")
				Powder:SetPos((Tr.HitPos + Tr.HitNormal * .1) + VectorRand(-10, 10))
				JMod.SetEZowner(Powder, self.EZowner)
				Powder:Spawn()
				Powder:Activate()
				Powder:SetMaterial("decals/extinguish1model")
				constraint.Weld(Powder, Tr.Entity, 0, 0, 0, true)
			end

			JMod.Hint(JMod.GetEZowner(self), "powder", Powder)
		end

		self:Remove()
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .2 and data.Speed > 25 then
			self:EmitSound("GlassBottle.ImpactHard")
			if self:GetState() == JMod.EZ_STATE_ARMED and data.Speed > 350 then
				self:Detonate()
			elseif self:GetState() ~= JMod.EZ_STATE_ARMED and data.Speed > 400 then
				self:Break()
			end
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		if self.Exploded then return end
		self:TakePhysicsDamage(dmginfo)
		local Dmg = dmginfo:GetDamage()
		if Dmg >= 5 or dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_CLUB) then
			self:Break()
		end

		if Dmg >= 1 and dmginfo:IsDamageType(DMG_BURN) then
			for i = 0, math.random(3, 6) do
				local Eff2 = EffectData()
				Eff2:SetOrigin(self:GetPos())
				Eff2:SetStart(self:GetVelocity())
				util.Effect("eff_jack_gmod_blackpowderpour", Eff2, true, true)
				local Tr = util.QuickTrace(self:GetPos(), Vector(0, 0, -200), {self})
				if Tr.Hit then
					local Powder = ents.Create("ent_jack_gmod_ezblackpowderpile")
					Powder:SetPos((Tr.HitPos + Tr.HitNormal * .1) + VectorRand(-10, 10))
					JMod.SetEZowner(Powder, self.EZowner)
					Powder:Spawn()
					Powder:Activate()
					constraint.Weld(Powder, Tr.Entity, 0, 0, 0, true)
					JMod.Hint(JMod.GetEZowner(self), "powder", Powder)
				end
			end

			timer.Simple(
				2,
				function()
					if not IsValid(self) then return end
					self:Detonate()
				end
			)
		end
	end

	function ENT:Arm()
		if self:GetState() == JMod.EZ_STATE_ARMED then return end
		self:EmitSound("snds_jack_gmod/ignite.wav", 60, 100)
		timer.Simple(
			.5,
			function()
				if IsValid(self) then
					self:SetState(JMod.EZ_STATE_ARMED)
				end
			end
		)
	end

	function ENT:Use(activator, activatorAgain, onOff)
		local Dude = activator or activatorAgain
		JMod.SetEZowner(self, Dude)
		if tobool(onOff) then
			local State = self:GetState()
			if State < 0 then return end
			local Alt = Dude:KeyDown(JMod.Config.General.AltFunctionKey)
			if State == JMod.EZ_STATE_OFF and Alt then
				self:Arm()
				JMod.Hint(Dude, "fuse")
			end

			JMod.ThrowablePickup(Dude, self, 500, 250)
			if not Alt then
				JMod.Hint(Dude, "arm")
			end
		end
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Owner = self:LocalToWorld(self:OBBCenter()), self.EZowner or self
		local Boom = ents.Create("env_explosion")
		Boom:SetPos(SelfPos)
		Boom:SetKeyValue("imagnitude", "50")
		Boom:SetOwner(Owner)
		Boom:Spawn()
		Boom:Fire("explode", 0)
		timer.Simple(
			.01,
			function()
				for i = 0, 10 do
					local Tr = util.QuickTrace(SelfPos, VectorRand() * math.random(10, 150), {self})
					if Tr.Hit then
						util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
						util.Decal("BeerSplash", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
					end
				end
			end
		)

		timer.Simple(
			.02,
			function()
				sound.Play("snd_jack_firebomb.wav", SelfPos, 80, 100)
				local Eff = EffectData()
				Eff:SetOrigin(self:GetPos())
				Eff:SetEntity(self)
				Eff:SetMagnitude(.5)
				Eff:SetScale(30)
				Eff:SetColor(120, 60, 0)
				Eff:SetNormal(VectorRand())
				util.Effect("eff_jack_iceimpact", Eff, true, true)
				for i = 1, 10 do
					sound.Play("GlassBottle.Break", SelfPos, 80 + i, 100)
				end

				for i = 1, math.random(8, 16) do
					local Eff2 = EffectData()
					Eff2:SetOrigin(self:GetPos())
					Eff2:SetStart(self:GetVelocity())
					util.Effect("eff_jack_gmod_blackpowderpour", Eff2, true, true)
					local Tr = util.QuickTrace(self:GetPos(), Vector(0, 0, -200), {self})
					if Tr.Hit then
						local Powder = ents.Create("ent_jack_gmod_ezblackpowderpile")
						Powder:SetPos((Tr.HitPos + Tr.HitNormal * .1) + VectorRand(-10, 10))
						JMod.SetEZowner(Powder, self.EZowner)
						Powder:Spawn()
						Powder:Activate()
						constraint.Weld(Powder, Tr.Entity, 0, 0, 0, true)
						JMod.Hint(JMod.GetEZowner(self), "powder", Powder)
					end
				end
			end
		)

		for i = 1, 25 do
			local FireVec = (self:GetVelocity() / 500 + VectorRand() * .3 + Vector(0, 0, .3)):GetNormalized()
			FireVec.z = FireVec.z / 2
			local Flame = ents.Create("ent_jack_gmod_eznapalm")
			Flame:SetPos(SelfPos + Vector(0, 0, 10))
			Flame:SetAngles(FireVec:Angle())
			Flame:SetOwner(JMod.GetEZowner(self))
			JMod.SetEZowner(Flame, self.EZowner or self)
			Flame.SpeedMul = self:GetVelocity():Length() / 1000 + .5
			Flame.Creator = self
			Flame.HighVisuals = true
			Flame:Spawn()
			Flame:Activate()
		end

		timer.Simple(
			.06,
			function()
				self:Remove()
			end
		)
	end

	function ENT:BurnFuze(amt)
		self.Fuze = self.Fuze - amt
		if SERVER and self.Fuze <= 3 then
			self:Ignite(3)

			return
		end
	end

	function ENT:Think()
		if istable(WireLib) then
			WireLib.TriggerOutput(self, "State", self:GetState())
			WireLib.TriggerOutput(self, "Fuse", self.Fuze)
		end

		local Time = CurTime()
		local state = self:GetState()
		if state == JMod.EZ_STATE_ARMED then
			if self.Fuze > 10 then
				local AttNum = self:LookupAttachment("Wick" or 0)
				local Att = self:GetAttachment(AttNum)
				local Fsh = EffectData()
				--Fsh:SetOrigin(self:GetPos() + self:GetUp() * 10 * (self.Fuze / 100))
				Fsh:SetOrigin(Att.Pos)
				Fsh:SetScale(1)
				Fsh:SetNormal(Att.Ang:Right())
				util.Effect("eff_jack_fuzeburn", Fsh, true, true)
				self:EmitSound("snd_jack_hmcd_flare.wav", 65, math.Rand(90, 110))
			end

			JMod.EmitAIsound(self:GetPos(), 500, .5, 8)
			self:BurnFuze(.7)
			self:NextThink(Time + .05)

			return true
		end
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_gmod_ezmolotov", "EZ Molotov Cocktail")
end