SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "M60"
SWEP.Author 				= "Saco Defense"
SWEP.Instructions			= "USA Machine Gun, M60 - 7.62x51 NATO."
SWEP.Category 				= "Chedara Box - Пулемёты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x51 NATO"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 90
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb2/weapons/m60/shoot.wav"
SWEP.Primary.FarSound = "pwb2/weapons/m60/shoot.wav"
SWEP.Primary.Force = 40
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.08
SWEP.ReloadSounds = {
    [0.1] = {"pwb2/weapons/m60/boxout.wav"},
    [1] = {"pwb2/weapons/m60/boxin.wav"},
    [1.5] = {"pwb2/weapons/m60/coverdown.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_556"
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

SWEP.ViewModel				= "models/pwb2/weapons/w_m60.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_m60.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-2.7,0.93,6.8) -- Sight pos
SWEP.SightAng = Angle(0,0,0) -- Sight ang

SWEP.Mobility = 4
