SWEP.Base = "weapon_hg_granade_base"

SWEP.PrintName = "Коктейль Молотова"
--
SWEP.Instructions = "Стеклянная бутылка, содержащая горючую жидкость и запал"
SWEP.Category = "Chedara Box - Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_molotov") SWEP.IconOverride="vgui/wep_jack_hmcd_molotov" end

SWEP.ViewModel = "models/w_models/weapons/w_eq_molotov.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_eq_molotov.mdl"
SWEP.Granade = "ent_hgjack_molotov"

local zeroang = Angle(0,0,0)
local zerovec = Vector(0,0,0)

local clavicler = Angle(30, 0, 60)
local lClavicle = Angle(-35,-20,-60)
local lclavicle2 = Vector(6,-10,2)

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
	ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"), zeroang, true)
	ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"), zerovec, true)
	end)
	return true
end

function SWEP:Think()
    self.Anim = Lerp(.1, self.Anim or 0, 1)
    self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), clavicler * self.Anim, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), lClavicle * self.Anim, true)
	self:GetOwner():ManipulateBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), lclavicle2 * self.Anim, false)
end

local angBack = Angle(0,0,180)
function SWEP:DrawWorldModel()
    local owner = self:GetOwner()

    if not IsValid(owner) then self:DrawModel() return end
    --if self:GetNWBool("hasbomb") then return end

    self.mdl = self.mdl or false
    if not IsValid(self.mdl) then
        self.mdl = ClientsideModel(self.WorldModel)
        self.mdl:SetNoDraw(true)
        self.mdl:SetModelScale(1)
    end
    self:CallOnRemove("huyhuy",function() self.mdl:Remove() end)
    local matrix = self:GetOwner():GetBoneMatrix(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
    if not matrix then return end

    self.mdl:SetRenderOrigin(matrix:GetTranslation()+matrix:GetAngles():Forward()*3+matrix:GetAngles():Right()*3)
    self.mdl:SetRenderAngles(matrix:GetAngles()+angBack)
    self.mdl:DrawModel()
end