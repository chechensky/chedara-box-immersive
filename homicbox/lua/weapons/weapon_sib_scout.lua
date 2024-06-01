SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Steyr Scout"
SWEP.Author 				= "Steyr Arms"
SWEP.Instructions			= "The Steyr Scout is an Austrian bolt-action rifle manufactured by Steyr Mannlicher, and chambered primarily for 7.62 NATO (.308 Winchester), although other caliber options in 5.56x45mm NATO (.223 Remington), .243 Winchester, 6.5 Creedmoor, .376 Steyr and 7mm-08 Remington are also offered commercially. It is intended to fill the role of a versatile, lightweight all-around rifle as specified in Jeff Cooper's scout rifle concept. Apart from the barrel and action, the gun is made primarily of polymers and is designed to be accurate to at least 800 m (870 yd)."
SWEP.Category 				= "Chedara Box - Снайперские винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".308 Winchester"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/ssg08/fire.wav"
SWEP.Primary.FarSound = "weapons/ssg08/distant.wav"
SWEP.Primary.Force = 35
SWEP.ReloadTime = 2.5
SWEP.ShootWait = 0.6
SWEP.ReloadSounds = {
    [0.1] = {"weapons/ssg08/clipout.wav"},
    [1.3] = {"weapons/ssg08/clipin.wav"},
    [1.35] = {"weapons/ssg08/cliphit.wav"},
    [2] = {"weapons/ssg08/boltforward.wav"},
    [2.4] = {"weapons/ssg08/boltforward.wav"}
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

SWEP.ViewModel				= "models/district/w_snip_scout.mdl"
SWEP.WorldModel				= "models/district/w_snip_scout.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-1.7,1,5.7) -- Sight pos
SWEP.SightAng = Angle(-10,0,7) -- Sight ang

SWEP.Mobility = 1.3

SWEP.DrawScope = true 
SWEP.ScopePos = Vector(0,0,0)
SWEP.ScopeSize = 0.5
SWEP.ScopeAdjust = Angle(0,0,90)
SWEP.ScopeFov = 2
SWEP.ScopeMat = Material("decals/perekrestie3.png")

if CLIENT then
    function SWEP:Initialize()
        sib_wep[self] = true
        self.maxzoom = 10
        self.minzoom = 2
        PrintTable(sib_wep)
        self.rtmat = GetRenderTarget("huy-glass", 512, 512, false)  
        self.mat = Material("models/weapons/w_models/w_snip_scout/wpn_attach_reflex_lens")
        self.mat:SetTexture("$basetexture",self.rtmat)

        local texture_matrix = self.mat:GetMatrix("$basetexturetransform")
        texture_matrix:SetAngles( Angle(0,0,0) )
        self.mat:SetMatrix("$basetexturetransform",texture_matrix)
    end 

    function SWEP:AdjustMouseSensitivity()
        return (self:GetOwner():KeyDown(IN_ATTACK2) and 0.3) or 1
    end
end