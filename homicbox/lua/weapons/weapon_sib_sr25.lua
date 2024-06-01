SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "SR-25"
SWEP.Author 				= "Eugene Morrison Stoner / Knight's Armament Company"
SWEP.Instructions			= "SR-25 — самозарядная снайперская винтовка, разработанная Юджином Стоунером в 1990-е годы на основе конструкции винтовки AR-15."
SWEP.Category 				= "Chedara Box - Снайперские винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_ins2_sr25_eft") SWEP.IconOverride="vgui/hud/tfa_ins2_sr25_eft" end

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x51 NATO"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/tfa_inss/asval/fire.wav"
SWEP.Primary.FarSound = "weapons/tfa_inss/asval/val_loop_tail.wav"
SWEP.Primary.Force = 80
SWEP.ReloadTime = 0.7
SWEP.ShootWait = 0.3
SWEP.ReloadSounds = {
    [0.1] = {"pwb/weapons/sr25/clipout.wav"},
    [1.3] = {"pwb/weapons/sr25/clipin.wav"},
    [1.35] = {"pwb/weapons/sr25/cliptap.wav"},
    [2.4] = {"pwb/weapons/sr25/boltrelease.wav"}
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_338Mag"
SWEP.ShellRotate = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/w_sr25/w_sr25.mdl"
SWEP.WorldModel				= "models/pwb/w_sr25/w_sr25.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-8,0.8,6.6) -- Sight pos
SWEP.SightAng = Angle(0,0,0) -- Sight ang

SWEP.Mobility = 1

SWEP.DrawScope = true 
SWEP.ScopePos = Vector(0,0,0)
SWEP.ScopeSize = 1
SWEP.ScopeAdjust = Angle(0,0,-55)
SWEP.ScopeFov = 5
SWEP.ScopeMat = Material("decals/bravo4x.png")
SWEP.ScopeRot = 217

if CLIENT then
    function SWEP:Think()
        sib_wep[self] = true
        self.rtmat = GetRenderTarget("huy-glass", 512, 512, false)  
        self.mat = Material("models/pwb/models/weapons/v_sr25/attachment lens")

        self.mat:SetTexture("$basetexture",self.rtmat)

        local texture_matrix = self.mat:GetMatrix("$basetexturetransform")
        texture_matrix:SetAngles( Angle(0,0,0) )
        self.mat:SetMatrix("$basetexturetransform",texture_matrix)
    end
    
    function SWEP:AdjustMouseSensitivity()
        return (self:GetOwner():KeyDown(IN_ATTACK2) and 0.5) or 1
    end
end