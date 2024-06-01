include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/weapons/tfa_ins2/upgrades/a_suppressor_12ga.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:Use(ply)
    ply.have_12suppressor = true
    ply:SetNWBool("PLY_Supressor12Gauge", true)
    self:Remove()
end