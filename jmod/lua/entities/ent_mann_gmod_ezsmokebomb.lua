AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Mannytko"
ENT.PrintName = "EZ Saltpeter Smoke Bomb"
ENT.Category = "JMod - EZ Homicide"
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(0, 140, 0)
ENT.JModEZstorable = true
ENT.NoSitAllowed = true
ENT.Model = "models/props_junk/jlare.mdl"
ENT.ImpactSound = "physics/cardboard/cardboard_box_impact_soft" .. math.random(1, 6) .. ".wav"
if SERVER then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("snd_jack_hmcd_match.wav", 60, 100)
	end

	function ENT:Arm()
		self:SetState(JMod.EZ_STATE_ARMED)
		self:Detonate()
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		self.FuelLeft = 100
	end

	function ENT:CustomThink()
		if self.Exploded then
			local Foof = EffectData()
			Foof:SetOrigin(self:GetPos())
			Foof:SetNormal(self:GetUp())
			Foof:SetScale(self.FuelLeft / 100)
			Foof:SetStart(self:GetPhysicsObject():GetVelocity())
			util.Effect("eff_jack_gmod_ezsmokescreen", Foof, true, true)
			self:EmitSound("snd_jack_hmcd_flare.wav", 55, 80)
			self.FuelLeft = self.FuelLeft - .5
			if self.FuelLeft <= 0 then
				SafeRemoveEntityDelayed(self, 1)
			end
		end
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_gmod_ezsmokebomb", "EZ Saltpeter Smoke Bomb")
end