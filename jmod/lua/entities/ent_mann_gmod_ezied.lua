AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Mannytko"
ENT.Category = "JMod - EZ Homicide"
ENT.PrintName = "EZ Ammonal Explosive Kit"
ENT.Spawnable = true
ENT.Model = "models/props_junk/cardboard_jox004a.mdl"
ENT.SpoonEnt = nil
--ENT.ModelScale=2.5
ENT.Mass = 20
ENT.HardThrowStr = 250
ENT.SoftThrowStr = 125
ENT.Hints = {"arm"}
ENT.ImpactSound = "physics/cardboard/cardboard_box_impact_soft" .. math.random(1, 6) .. ".wav"
DEFINE_BASECLASS(ENT.Base)
if SERVER then
	function ENT:Initialize()
		BaseClass.Initialize(self)
		local plunger = ents.Create("ent_mann_gmod_ezdetonator")
		plunger:SetPos(self:GetPos() + self:GetForward() * 5)
		plunger:SetAngles(self:GetAngles())
		plunger:Spawn()
		plunger.Satchel = self
		plunger.EZowner = self.EZowner
		self.Plunger = plunger
		self.NextStick = 0
		timer.Simple(
			0,
			function()
				plunger:SetParent(self)
			end
		)

		if istable(WireLib) then
			self.Inputs = WireLib.CreateInputs(self, {"Detonate"}, {"This will directly detonate the bomb"})
			self.Outputs = WireLib.CreateOutputs(self, {"State"}, {"Off \n Primed \n Armed"})
		end
	end

	function ENT:TriggerInput(iname, value)
		if iname == "Detonate" and value > 0 then
			self:Detonate()
		elseif iname == "Prime" and value > 0 then
			self:SetState(JMod.EZ_STATE_PRIMED)
		end
	end

	function ENT:Prime()
		self:EmitSound("snd_jack_hmcd_bombrig.wav", 80, math.random(90, 110))
		self:SetState(JMod.EZ_STATE_PRIMED)
		self.Plunger:SetParent(nil)
		constraint.NoCollide(self, self.Plunger, 0, 0)
		--constraint.Rope(self, self.Plunger, 0, 0, vector_origin, vector_origin, 2000, 0, 0, .5, "cable/cable", false)
		timer.Simple(
			0,
			function()
				self.Plunger:SetPos(self:GetPos() + Vector(0, 0, 20))
			end
		)
	end

	function ENT:Arm()
		self:SetState(JMod.EZ_STATE_ARMED)
	end

	function ENT:Use(activator, activatorAgain, onOff)
		local Dude = activator or activatorAgain
		local Time = CurTime()
		JMod.SetEZowner(self, Dude)
		local State = self:GetState()
		if tobool(onOff) then
			if State < 0 then return end
			local Alt = Dude:KeyDown(JMod.Config.General.AltFunctionKey)
			if State == JMod.EZ_STATE_OFF and Alt then
				self:Prime()
				activator:PickupObject(self.Plunger)
				JMod.Hint(Dude, "arm satchelcharge", self.Plunger)
			else
				self.StuckStick = nil
				self.StuckTo = nil
				Dude:PickupObject(self)
				self.NextStick = Time + .5
				JMod.Hint(Dude, "arm")
				JMod.Hint(Dude, "sticky")
			end
		else
			if self:IsPlayerHolding() and (self.NextStick < Time) and State > 0 then
				local Tr = util.QuickTrace(Dude:GetShootPos(), Dude:GetAimVector() * 80, {self, Dude})
				if Tr.Hit then
					if IsValid(Tr.Entity:GetPhysicsObject()) and not Tr.Entity:IsNPC() and not Tr.Entity:IsPlayer() then
						self.NextStick = Time + .5
						local Ang = Tr.HitNormal:Angle()
						Ang:RotateAroundAxis(Ang:Right(), -90)
						Ang:RotateAroundAxis(Ang:Up(), 180)
						self:SetAngles(Ang)
						self:SetPos(Tr.HitPos)
						-- crash prevention
						if Tr.Entity:GetClass() == "func_breakable" then
							timer.Simple(
								0,
								function()
									self:GetPhysicsObject():Sleep()
								end
							)
						else
							local Weld = constraint.Weld(self, Tr.Entity, 0, Tr.PhysicsBone, 3000, false, false)
							self.StuckTo = Tr.Entity
							self.StuckStick = Weld
						end

						self.Entity:EmitSound("snd_jack_claythunk.wav", 65, math.random(80, 120))
						Dude:DropObject()
					end
				end
			end
		end
	end

	-- funni hmcd code
	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		if IsValid(self.Plunger) then
			JMod.SetEZowner(self, self.Plunger.EZowner)
		end

		if IsValid(self) then
			local SelfPos, PowerMult = self:GetPos(), 3.5
			local Blam = EffectData()
			Blam:SetOrigin(SelfPos)
			Blam:SetScale(PowerMult / 2.6)
			util.Effect("eff_jack_plastisplosion", Blam, true, true)
			util.ScreenShake(SelfPos, 99999, 99999, 1, 600 * PowerMult)
			for i = 1, PowerMult do
				sound.Play("BaseExplosionEffect.Sound", SelfPos, 120, math.random(90, 110))
			end

			self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 100)
			-- timer.Simple go brrrrrrrrrrrrrrrr
			timer.Simple(
				.1,
				function()
					for i = 1, 5 do
						local Tr = util.QuickTrace(SelfPos, VectorRand() * 20)
						if Tr.Hit then
							util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
						end
					end
				end
			)

			JMod.WreckBuildings(self, SelfPos, PowerMult)
			JMod.BlastDoors(self, SelfPos, PowerMult)
			local Nab = game.GetWorld()
			local Infl, Att = (IsValid(self) and self) or Nab, (IsValid(self) and IsValid(self.EZowner) and self.EZowner) or (IsValid(self) and self) or ZaWarudo
			util.BlastDamage(Infl, Att, SelfPos, 160 * PowerMult, 50 * PowerMult)
		end

		local Pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 5)
		local Foom = EffectData()
		Foom:SetOrigin(Pos)
		util.Effect("explosion", Foom, true, true)
		timer.Simple(
			.01,
			function()
				if not IsValid(self) then return end
				-- Failed to load sound "snd_jack_hmcd_explosion_debris.wav", file probably missing from disk/repository ???
				-- Failed to load sound "snd_jack_hmcd_debris.wav", file probably missing from disk/repository ???
				sound.Play("snd_jack_hmcd_explosion_debris.wav", Pos, 85, math.random(90, 110))
				sound.Play("snd_jack_hmcd_explosion_far.wav", Pos - vector_up, 140, 100)
				sound.Play("snd_jack_hmcd_debris.wav", Pos + vector_up, 85, math.random(90, 110))
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

		timer.Simple(
			.1,
			function()
				if not IsValid(self) then return end
				self:Remove()
			end
		)
	end

	function ENT:OnRemove()
		if IsValid(self.Plunger) then
			SafeRemoveEntityDelayed(self.Plunger, 3)
		end
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_gmod_ezied", "EZ Ammonal Explosive Kit")
end