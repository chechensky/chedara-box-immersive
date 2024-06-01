﻿AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Mannytko"
ENT.Category = "JMod - EZ Homicide"
ENT.PrintName = "EZ Pipe Bomb"
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
		--local effectdata=EffectData()
		--effectdata:SetEntity(ent)
		--util.Effect("propspawn",effectdata)

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/w_models/weapons/w_jj_pipebomb.mdl")
		self:SetBodygroup(0, 0)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetUseType(ONOFF_USE)
		if self:GetPhysicsObject():IsValid() then
			self:GetPhysicsObject():SetMass(25)
			self:GetPhysicsObject():Wake()
		end

		self.Fuze = 100
		self:SetState(JMod.EZ_STATE_OFF)
		if istable(WireLib) then
			self.Inputs = WireLib.CreateInputs(self, {"Detonate", "Arm"}, {"Directly detonates the bomb", "Arms bomb when > 0"})
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

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .2 and data.Speed > 25 then
			self:EmitSound("Grenade.ImpactHard")
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		if self.Exploded then return end
		if dmginfo:GetInflictor() == self then return end
		self:TakePhysicsDamage(dmginfo)
		local Dmg = dmginfo:GetDamage()
		if dmginfo:IsDamageType(DMG_BURN) then
			self:Arm()
		end

		if Dmg >= 4 then
			local DetChance = 0
			if dmginfo:IsDamageType(DMG_BLAST) then
				DetChance = DetChance + Dmg / 150
			end

			if math.Rand(0, 1) < DetChance then
				self:Detonate()
			end
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
		local Pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 5)
		local SelfPos = self:GetPos()
		self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 100)
		local Foom = EffectData()
		Foom:SetOrigin(Pos)
		util.Effect("explosion", Foom, true, true)
		JMod.Sploom(JMod.GetEZowner(self), SelfPos, 180)
		timer.Simple(
			.01,
			function()
				if not IsValid(self) then return end
				sound.Play("snd_jack_hmcd_explosion_debris.mp3", Pos, 85, math.random(90, 110))
				sound.Play("snd_jack_hmcd_explosion_far.wav", Pos - vector_up, 140, 100)
				sound.Play("snd_jack_hmcd_debris.mp3", Pos + vector_up, 85, math.random(90, 110))
				for i = 0, 10 do
					local Tr = util.QuickTrace(Pos, VectorRand() * math.random(10, 150), {self})
					if Tr.Hit then
						util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
					end
				end
			end
		)

		timer.Simple(
			.02,
			function()
				if not IsValid(self) then return end
				sound.Play("snd_jack_hmcd_explosion_close.wav", Pos, 80, 100)
				sound.Play("snd_jack_hmcd_explosion_close.wav", Pos + vector_up, 80, 100)
				sound.Play("snd_jack_hmcd_explosion_close.wav", Pos - vector_up, 80, 100)
			end
		)

		local Blam = EffectData()
		Blam:SetOrigin(SelfPos)
		Blam:SetScale(2)
		util.Effect("eff_jack_plastisplosion", Blam, true, true)
		util.ScreenShake(SelfPos, 20, 20, 1, 700)
		self:Remove()
	end

	function ENT:BurnFuze(amt)
		self.Fuze = self.Fuze - amt
		if self.Fuze <= 0 then
			self:Detonate()

			return
		end
		--local BoneIndex = self:LookupBone("Fuze" .. math.Round(self.Fuze / 10))
		--local BoneMatrix = self:GetBoneMatrix(BoneIndex)
		--jprint(BoneIndex)
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
				local AttNum = self:LookupAttachment("fuse")
				local Att = self:GetAttachment(AttNum)
				local Fsh = EffectData()
				--Fsh:SetOrigin(self:GetPos() + self:GetUp() * 10 * (self.Fuze / 100))
				Fsh:SetOrigin(Att.Pos)
				Fsh:SetScale(1)
				Fsh:SetNormal(-Att.Ang:Right())
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

	language.Add("ent_mann_gmod_ezpipebomb", "EZ Pipe Bomb")
end