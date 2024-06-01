-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, TheOnly8Z"
ENT.PrintName = "EZHG Flashbang"
ENT.Category = "JModHomigrad"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.JModPreferredCarryAngles = Angle(0, 140, 0)
ENT.Model = "models/jmod/explosives/grenades/flashbang/flashbang.mdl"
ENT.ModelScale=0.8
ENT.SpoonScale = 2

if SERVER then
	function ENT:Arm()
		self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()

		local time = 2.5

		timer.Simple(time, function()
			if IsValid(self) then
				self:Detonate()
			end
		end)
	end

	function ENT:CanSee(ent)
		if not IsValid(ent) then return false end
		local TargPos, SelfPos = ent:LocalToWorld(ent:OBBCenter()), self:LocalToWorld(self:OBBCenter()) + vector_up * 10

		local Tr = util.TraceLine({
			start = SelfPos,
			endpos = TargPos,
			filter = {self, ent},
			mask = MASK_SHOT + MASK_WATER
		})

		return not Tr.Hit
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Time = self:GetPos() + Vector(0, 0, 10), CurTime()
		JMod.Sploom(self.Owner, self:GetPos(), 20)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 511, 140)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 511, 140)
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
		util.ScreenShake(SelfPos, 20, 20, .2, 1000)

		for k, v in pairs(ents.FindInSphere(SelfPos, 200)) do
			if v:IsNPC() then
				v.EZNPCincapacitate = Time + math.Rand(3, 5)
			end
		end

		self:SetColor(Color(0, 0, 0))

		timer.Simple(.1, function()
			if not IsValid(self) then return end
			util.BlastDamage(self, self.Owner or self, SelfPos, 1000, 2)
		end)

		local Pos = self:GetPos()

		for i,ply in pairs(player.GetAll()) do
			local plyPos = ply:GetPos()
			local dis = Pos:Distance(plyPos)

			if dis < 1000 then
				if not util.TraceLine({
					start = Pos,
					endpos = plyPos,
					filter = {self,ply}
				}).Hit then
					player.Event(ply,"flashbang",1 - dis / 1000)
				end
			end
		end

		SafeRemoveEntityDelayed(self, 10)
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_ezflashbang", "EZ Flashbang Grenade")
end
