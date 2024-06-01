include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/weapons/upgrades/a_suppressor_ak.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:Use(ply)
    ply.have_aksuppressor = true
    ply:SetNWBool("PLY_Supressor762", true)
    self:Remove()
end