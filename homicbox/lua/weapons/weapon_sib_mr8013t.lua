SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "МР-80-13Т"
SWEP.Author 				= "Makarov"
SWEP.Instructions			= "МР-80-13Т - Травматический пистолет макарова на 8 патрон, снаряжается .45 Rubber."
SWEP.Category 				= "Chedara Box - Пистолеты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".45 Rubber"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 10
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/tec9/fire.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 5
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.1] = {"weapons/tec9/clipout.wav"},
    [0.8] = {"weapons/tec9/clipin.wav"},
    [1.2] = {"weapons/tec9/boltback.wav"},
    [1.4] = {"weapons/tec9/boltforward.wav"},
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

SWEP.ViewModel				= "models/district/w_pist_pmt.mdl"
SWEP.WorldModel				= "models/district/w_pist_pmt.mdl"

SWEP.addAng = Angle(0.1,-0.1,0) -- Barrel ang adjust
SWEP.addPos = Vector(0,0,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-14,1.5,3.5) -- Sight pos
SWEP.SightAng = Angle(0,8,0) -- Sight ang

function SWEP:Think()
    
    if self.holdnow == "pistol" then self:SetHoldType("pistol") end
    if self.holdnow == "revolver" then return end
end