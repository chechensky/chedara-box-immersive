if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_poisongoo") SWEP.IconOverride="vgui/wep_jack_hmcd_poisongoo" end

SWEP.Base = "medkit"

SWEP.PrintName = "Яд Кураре"
--
SWEP.Instructions = "Возьми в руки оружие ближнего боя с лезвием и в C меню выбери - Отравить лезвие ядом кураре, только будь быстр! Яд может стечь по лезвию и эффект пропадет!"

SWEP.Spawnable = true
SWEP.Category = "Chedara Box - Вещи предателя"

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/props_lab/jar01b.mdl"
SWEP.WorldModel = "models/props_lab/jar01b.mdl"
SWEP.HoldType = "normal"

SWEP.dwsPos = Vector(35,35,15)
SWEP.dwsItemPos = Vector(2,0,2)

SWEP.dwmModeScale = 0.4
SWEP.dwmForward = 4
SWEP.dwmRight = 2
SWEP.dwmUp = 0.5

SWEP.dwmAUp = 0
SWEP.dwmARight = 180
SWEP.dwmAForward = 0

function SWEP:Initialize()
	self:SetHoldType("normal")
end
