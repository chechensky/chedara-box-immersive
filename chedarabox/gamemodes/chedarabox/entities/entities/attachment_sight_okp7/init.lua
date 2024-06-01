include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box004a.mdl")
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
    ply.have_okp7sight = true
    ply:SetNWBool("PLY_OKPSight7", true)
    self:Remove()
end