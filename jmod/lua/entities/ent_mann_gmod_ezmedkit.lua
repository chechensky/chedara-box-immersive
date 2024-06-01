-- Jackarunda 2023
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Jackarunda"
ENT.Category = "JMod - EZ Homicide"
ENT.PrintName = "EZ First-Aid Kit"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.JModEZstorable = true
ENT.JModPreferredCarryAngles = Angle(0, 0, -90)
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 20
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(angle_zero)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/w_models/weapons/w_eq_medkit.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local Phys = self:GetPhysicsObject()
		if Phys:IsValid() then
			Phys:SetMass(20)
			Phys:Wake()
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .2 and data.Speed > 25 then
			self:EmitSound("Flesh.ImpactSoft")
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
		local Pos = self:GetPos()
		if JMod.LinCh(dmginfo:GetDamage(), 30, 100) then
			sound.Play("Flesh.ImpactSoft", Pos)
			SafeRemoveEntityDelayed(self, 1)
		end
	end

	function ENT:Use(activator)
		local Alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)
		if Alt then
			activator.EZnutrition = activator.EZnutrition or {
				Nutrients = 0
			}

			local Helf, Max = activator:Health(), activator:GetMaxHealth()
			activator.EZhealth = activator.EZhealth or 0
			local Missing = Max - (Helf + activator.EZhealth)
			if Missing > 0 then
				local AddAmt = math.min(Missing, 5 * JMod.Config.Tools.Medkit.HealMult)
				activator:EmitSound("snd_jack_hmcd_bandage.wav", 60, math.random(90, 110))
				if activator.EZnutrition.Nutrients < 30 then
					JMod.ConsumeNutrients(activator, math.random(2, 4)) -- analog of "food boost" from homicide
				end

				activator.EZhealth = activator.EZhealth + AddAmt
				self:Remove()
			end

			if activator.EZbleeding and (activator.EZbleeding > 0) then
				activator:EmitSound("snd_jack_hmcd_bandage.wav", 60, math.random(90, 110))
				activator:PrintMessage(HUD_PRINTCENTER, "stopping bleeding")
				activator.EZbleeding = math.Clamp(activator.EZbleeding - JMod.Config.Tools.Medkit.HealMult * 50, 0, 9e9)
				if activator.EZnutrition.Nutrients < 30 then
					JMod.ConsumeNutrients(activator, math.random(1, 2))
				end

				activator:ViewPunch(Angle(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(-2, 2)))
				self:Remove()
			end
		else
			JMod.Hint(activator, "ifak")
			local Pos = self:GetPos()
			sound.Play("physics/body/body_medium_impact_soft5.wav", Pos)
			activator:PickupObject(self)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_ezmedkit", "EZ First-Aid Kit")
end