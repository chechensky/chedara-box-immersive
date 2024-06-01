SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "M249"
SWEP.Author 				= "FN Herstal"
SWEP.Instructions			= "The M249 SAW formally written as Light Machine Gun, 5.56 mm, M249, is the US military’s adaptation of the Belgian FN Minimi, a light machine gun manufactured by the Belgian company FN Herstal (FN). "
SWEP.Category 				= "Chedara Box - Пулемёты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 150
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/m249/fire.wav"
SWEP.Primary.FarSound = "weapons/m249/distant.wav"
SWEP.Primary.Force = 42
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.08
SWEP.ReloadSounds = {
    [0.1] = {"weapons/m249/boxout.wav"},
    [1] = {"weapons/m249/boxin.wav"},
    [1.5] = {"weapons/m249/coverdown.wav"},
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

SWEP.ViewModel				= "models/district/w_mach_m249para.mdl"
SWEP.WorldModel				= "models/district/w_mach_m249para.mdl"

SWEP.addAng = Angle(0,-0.5,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-6,0.6,7.5) -- Sight pos
SWEP.SightAng = Angle(0,0,0) -- Sight ang

SWEP.Mobility = 4
