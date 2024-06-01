SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "P226"
SWEP.Author 				= "SIG Sauer"
SWEP.Instructions			= "The SIG Sauer P226 is a full-sized service pistol made by SIG Sauer. The 9x19mm Parabellum pistol. It has the same mechanism of operation as the SIG Sauer P220, but is developed to use higher capacity, double stack magazines in place of the single stack magazines of the P220."
SWEP.Category 				= "Chedara Box - Пистолеты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 18
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/p250/fire.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Suppsound = "homigrad/weapons/pistols/sil2.wav"
SWEP.Primary.Force = 40
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.1] = {"weapons/p250/clipout.wav"},
    [0.8] = {"weapons/p250/clipin.wav"},
    [1.2] = {"weapons/p250/slideback.wav"},
    [1.4] = {"weapons/p250/slideforward.wav"},
}


------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 1
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/district/w_pist_p228.mdl"
SWEP.WorldModel				= "models/district/w_pist_p228.mdl"

SWEP.addAng = Angle(0.8,-0.1,0) -- Barrel ang adjust
SWEP.addPos = Vector(0,0,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-14,1.5,4.05) -- Sight pos
SWEP.SightAng = Angle(0,8,0) -- Sight ang

function SWEP:Think()
    
    if self.holdnow == "pistol" then self:SetHoldType("pistol") end
    if self.holdnow == "revolver" then return end
end