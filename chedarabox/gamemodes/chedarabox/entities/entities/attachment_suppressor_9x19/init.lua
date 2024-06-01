include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/weapons/tfa_ins2/upgrades/usp_match/w_suppressor_pistol.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	local Phys = self.Entity:GetPhysicsObject()

	if IsValid(Phys) then
		Phys:Wake()
		Phys:EnableDrag(true)
		Phys:SetMaterial("metal")
	end
end

function ENT:Use(ply)
    ply.have_9x19suppressor = true
    ply:SetNWBool("PLY_Supressor9x19", true)
    self:Remove()
end