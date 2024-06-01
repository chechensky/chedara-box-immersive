SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "M-14"
SWEP.Author 				= "Springfield Armory"
SWEP.Instructions			= "The M14 rifle, officially the United States Rifle, Caliber 7.62 mm, M14, is an American selective-fire battle rifle chambered for the 7.62x51mm NATO (.308 in) cartridge. It became the standard-issue rifle for the U.S. military in 1957, replacing the M1 Garand rifle in service with the U.S. Army by 1958 and the U.S. Marine Corps by 1965. The M14 was used by the U.S. Army, Navy, and Marine Corps for Basic and Advanced Individual Training from the mid-1960s to the early 1970s."
SWEP.Category 				= "Chedara Box - Марксманские винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".308 Winchester"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/scar20/fire01.wav"
SWEP.Primary.FarSound = "weapons/scar20/distant01.wav"
SWEP.Primary.Force = 35
SWEP.ReloadTime = 2.5
SWEP.ShootWait = 0.075
SWEP.ReloadSounds = {
    [0.1] = {"weapons/ssg08/clipout.wav"},
    [1] = {"weapons/ssg08/clipin.wav"},
    [2] = {"weapons/ssg08/boltforward.wav"},
    [2.4] = {"weapons/ssg08/boltback.wav"},
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

SWEP.ViewModel				= "models/district/w_rif_m14.mdl"
SWEP.WorldModel				= "models/district/w_rif_m14.mdl"

SWEP.addAng = Angle(0,0.25,0) -- Barrel pos adjust
SWEP.addPos = Vector(1,2,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-5,0.9,4.35) -- Sight pos
SWEP.SightAng = Angle(-10,0,0) -- Sight ang

SWEP.Mobility = 1.7
