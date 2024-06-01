SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "Type 59 Grenade"
--
SWEP.Instructions = "Это дешевый китайский клон старой советской наступательной ручной гранаты РГД-5. Он имеет поражения 9 метров.\n\nЛКМ , чтобы снять чеку и бросить."
SWEP.Category = "Chedara Box - Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_oldgrenade") SWEP.IconOverride="vgui/wep_jack_hmcd_oldgrenade" end

SWEP.ViewModel = "models/weapons/w_jj_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_jj_fraggrenade.mdl"

SWEP.Granade = "ent_hgjack_type59"
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
	end)
	return true
end

function SWEP:Think()
    self.Anim = Lerp(.1, self.Anim or 0, 1)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), clavicler * self.Anim, true)
end