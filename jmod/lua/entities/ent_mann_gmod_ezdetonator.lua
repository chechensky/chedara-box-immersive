AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "Mannytko"
ENT.PrintName = "EZ Detonator"
ENT.Spawnable = false
ENT.NoSitAllowed = true
ENT.JModPreferredCarryAngles = Angle(0, 180, 0)
ENT.JModEZstorable = false
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Fired")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_models/w_jda_engineer.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		self.DieTime = nil
		self:SetFired(false)
		self:SetModelScale(.6)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		if self:GetPhysicsObject():IsValid() then
			self:GetPhysicsObject():SetMass(10)
			self:GetPhysicsObject():Wake()
		end

		if istable(WireLib) then
			self.Outputs = WireLib.CreateOutputs(self, {"State"}, {"Fired or not"})
		end
	end

	function ENT:TriggerInput(iname, value)
	end

	function ENT:Use(activator, caller, typ, val)
		if not IsValid(activator) then return end
		if IsValid(self:GetParent()) then
			self:GetParent():Use(activator, caller, typ, val)

			return
		end

		self.EZowner = activator
		if activator:KeyDown(JMod.Config.General.AltFunctionKey) then
			self:EmitSound("snd_jack_hmcd_detonator.wav")
			self:SetFired(true)
			self.Satchel:EmitSound("snd_jack_hmcd_beep.wav", 100)
			timer.Simple(
				.5,
				function()
					if IsValid(self.Satchel) then
						self.Satchel:Detonate()
					end
				end
			)

			self.DieTime = CurTime() + 10
		else
			activator:PickupObject(self)
		end
	end

	function ENT:Think()
		if istable(WireLib) then
			WireLib.TriggerOutput(self, "State", self:GetFired())
		end

		if not IsValid(self.Satchel) and self.DieTime == nil then
			self:Remove()
		elseif self.DieTime ~= nil and self.DieTime < CurTime() then
			self:Remove()
		end
	end

	function ENT:OnRemove()
		if IsValid(self.Satchel) then
			SafeRemoveEntity(self.Satchel)
		end
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_gmod_ezdetonator", "EZ Detonator")
end