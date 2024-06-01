if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_poisonpowder") SWEP.IconOverride="vgui/wep_jack_hmcd_poisonpowder" end
SWEP.Base = "medkit"

SWEP.PrintName = "Капсула Цианида"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Используй это на еде, что бы отравить того, кто ее съест."

SWEP.Spawnable = true
SWEP.Category = "Chedara Box - Вещи предателя"

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/Items/Flare.mdl"
SWEP.WorldModel = "models/Items/Flare.mdl"
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

local function eyeTrace(ply)
    local att1 = ply:LookupAttachment("eyes")

    if not att1 then return end

    local att = ply:GetAttachment(att1)

    if not att then return end

    local tr = {}
    tr.start = att.Pos
    tr.endpos = tr.start + ply:EyeAngles():Forward() * 50
    tr.filter = ply

    return util.TraceLine(tr)
end

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local ent = eyeTrace(self:GetOwner()).Entity

    if not IsValid(ent) or ent:IsWorld() or ent:IsPlayer() or ent.Base != "weapon_food_base" then return end

    self:Poison(ent)
end

function SWEP:SecondaryAttack() end

if SERVER then

    function SWEP:Poison(ent)
        ent.cianid = true
        self:GetOwner():EmitSound("snd_jack_hmcd_needleprick.wav",30)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
        
        return false
    end

    function SWEP:Think()
        
    end

else

    function SWEP:DrawHUD()
        local owner = self:GetOwner()
        local traceResult = eyeTrace(owner)
        local ent = traceResult.Entity
        if not traceResult.Hit or not IsValid(ent) or ent:IsWorld() or ent:IsPlayer() or ent.Base != "weapon_food_base" then return end
        
        local frac = traceResult.Fraction

        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.SetMaterial(Material("vgui/wep_jack_hmcd_poisonpowder"))
        surface.DrawTexturedRect( traceResult.HitPos:ToScreen().x*0.91, traceResult.HitPos:ToScreen().y*0.78, 150,100)
        draw.NoTexture()
        Circle(traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y, 5 / frac, 32)
        draw.DrawText("Отравить еду","TargetID",traceResult.HitPos:ToScreen().x,traceResult.HitPos:ToScreen().y - 40,color_white,TEXT_ALIGN_CENTER)
    end
end