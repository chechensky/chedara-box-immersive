SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "RGD-5"
--
SWEP.Instructions = "Наступательная ручная граната, относится к противопехотным осколочным ручным гранатам дистанционного действия наступательного типа."
SWEP.Category = "Chedara Box - Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.ViewModel = "models/pwb/weapons/w_rgd5.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_rgd5.mdl"
SWEP.Trap = true
SWEP.Granade = "ent_hgjack_rgd5nade"

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
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"), zeroang)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger0"), zeroang)
	end)
	return true
end

function SWEP:Think()
    self.Anim = Lerp(.1, self.Anim or 0, 1)
    local ply = self:GetOwner()
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"), clavicler * self.Anim, true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger0"),Angle(10,30,0) * self.Anim,true)
end