AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Dovetail OKP7"
ENT.Author = "checha"
ENT.Category = "CHBOX - Sight"
ENT.Spawnable = true
ENT.AdminSpawnable = false

if CLIENT then ENT.IconOverride = "materials/entities/eft_attachments/scopes/okp7.png" end

if SERVER then return end

local color_red = Color(140,0,0,100)
local color_white = color_white

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think() end