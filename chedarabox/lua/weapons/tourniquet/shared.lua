if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/zhgut") SWEP.IconOverride="vgui/zhgut" end

AddCSLuaFile()

SWEP.Base = "medkit"

SWEP.PrintName = "Жгут"
--
SWEP.Instructions = "Останавливает артериальное кровотечение"

SWEP.Spawnable = true
SWEP.Category = "Chedara Box - Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.ViewModel = "models/tourniquet/tourniquet.mdl"
SWEP.WorldModel = "models/tourniquet/tourniquet.mdl"

SWEP.dwsPos = Vector(10,10,10)

SWEP.vbwPos = Vector(-5,6,-7)
SWEP.vbwAng = Angle(90,0,0)
SWEP.vbwModelScale = 0.8

SWEP.vbwPos2 = Vector(-2.2,5,-7)
SWEP.vbwAng2 = Angle(90,0,0)

function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end

SWEP.dwmModeScale = 1
SWEP.dwmForward = 4.5
SWEP.dwmRight = 2
SWEP.dwmUp = -1

SWEP.dwmAUp = 0
SWEP.dwmARight = 0
SWEP.dwmAForward = 180