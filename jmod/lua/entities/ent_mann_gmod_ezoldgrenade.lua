AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Mannytko"
ENT.PrintName = "EZ Type 59 Grenade"
ENT.Category = "JMod - EZ Homicide"
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(0, -140, 0)
ENT.Model = "models/weapons/w_jj_fraggrenade.mdl"
ENT.SpoonScale = 1
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 20
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(angle_zero)
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		ent:Spawn()
		ent:Activate()
		-- pashalka
		if GetConVar("developer"):GetInt() >= 1 and math.random(1, 850) > 800 then
			local nab = ents.Create("npc_pigeon")
			nab:SetAngles(angle_zero)
			nab:SetPos(SpawnPos)
			JMod.SetEZowner(nab, ply)
			nab:Spawn()
			nab:Activate()
		end

		return ent
	end

	function ENT:Arm()
		self:SetModel("models/weapons/w_jj_fraggrenade_thrown.mdl")
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()
		timer.Simple(
			self.FuzeTimeOverride or 4,
			function()
				if IsValid(self) then
					self:Detonate()
				end
			end
		)
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos = self:GetPos()
		JMod.Sploom(self.EZowner, self:GetPos(), math.random(10, 20), 254)
		self:EmitSound("snd_jack_hmcd_explosion_debris.mp3", 85, math.random(90, 110))
		self:EmitSound("snd_jack_hmcd_debris.mp3", 85, math.random(90, 110))
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(.5)
		plooie:SetRadius(1)
		plooie:SetNormal(vector_up)
		util.Effect("eff_jack_minesplode", plooie, true, true)
		util.ScreenShake(SelfPos, 20, 20, 1, 1000)
		JMod.FragSplosion(self, SelfPos + Vector(0, 0, 10), 3000, 80, 2500, JMod.GetEZowner(self))
		self:Remove()
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_gmod_ezoldgrenade", "EZ Type 59 Grenade")
end