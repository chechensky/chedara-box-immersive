SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "HK-G3"
SWEP.Author 				= "Heckler & Koch"
SWEP.Instructions			= "The Heckler & Koch G3 (Gewehr 3) is a 7.62x51mm NATO, select-fire battle rifle developed in the 1950s by the German armament manufacturer Heckler & Koch (HK) in collaboration with the Spanish state-owned design and development agency Centro de Estudios Técnicos de Materiales Especiales (CETME)."
SWEP.Category 				= "Chedara Box - Снайперские винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".308 Winchester"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/g3sg1/fire01.wav"
SWEP.Primary.FarSound = "weapons/g3sg1/distant01.wav"
SWEP.Primary.Force = 40
SWEP.ReloadTime = 2.5
SWEP.ShootWait = 0.2
SWEP.ReloadSounds = {
    [0.1] = {"weapons/g3sg1/clipout.wav"},
    [1.3] = {"weapons/g3sg1/clipin.wav"},
    [2] = {"weapons/g3sg1/clipin.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_338Mag"
SWEP.ShellRotate = false 

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

SWEP.ViewModel				= "models/district/w_snip_g3sg1.mdl"
SWEP.WorldModel				= "models/district/w_snip_g3sg1.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-7,0.96,6.4) -- Sight pos
SWEP.SightAng = Angle(-10,0,0) -- Sight ang

SWEP.Mobility = 1.3

SWEP.DrawScope = true 
SWEP.ScopePos = Vector(0,0,0)
SWEP.ScopeSize = 0.7
SWEP.ScopeAdjust = Angle(0,0,0)
SWEP.ScopeFov = 2.5
SWEP.ScopeMat = Material("decals/perekrestie3.png")
SWEP.ScopeRot = -3

if CLIENT then
    function SWEP:Initialize()
        sib_wep[self] = true
        self.maxzoom = 10
        self.minzoom = 2.5
        PrintTable(sib_wep)
        self.rtmat = GetRenderTarget("huy-glass", 512, 512, false)  
        self.mat = Material("models/weapons/w_models/w_snip_g3sg1/g3_scope_sg1_lens")
        self.mat:SetTexture("$basetexture",self.rtmat)

        local texture_matrix = self.mat:GetMatrix("$basetexturetransform")
        texture_matrix:SetAngles( Angle(0,180,0) )
        self.mat:SetMatrix("$basetexturetransform",texture_matrix)
    end
    
    function SWEP:AdjustMouseSensitivity()
        return (self:GetOwner():KeyDown(IN_ATTACK2) and 0.3) or 1
    end
end