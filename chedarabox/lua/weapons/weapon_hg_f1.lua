SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "F1"
--
SWEP.Instructions = "Ручная граната дистанционного действия, предназначена для поражения живой силы противника в оборонительном бою."
SWEP.Category = "Chedara Box - Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Granade = "ent_hgjack_f1nade"
SWEP.Trap = true

local zeroang = Angle(0,0,0)

local clavicler = Angle(30, 0, 60)

function SWEP:Initialize()
    self:SetHoldType("slam")
end

function SWEP:Deploy()
    self:SetHoldType("slam")
end

function SWEP:Holster()
	local ply = self:GetOwner()
	timer.Simple(0.1,function()
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"), zeroang, true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger0"),zeroang,true)
	end)
	return true
end

function SWEP:Think()
    self.Anim = Lerp(.1, self.Anim or 0, 1)
    local ply = self:GetOwner()
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), clavicler * self.Anim, true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(10,30,0) * self.Anim,true)
end