
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "HK-MP5"
SWEP.Author 				= "Heckler & Koch"
SWEP.Instructions			= "The Heckler & Koch MP5 is a submachine gun which fires 9x19mm Parabellum cartridges, developed in the 1960s by Heckler & Koch. There are over 100 variants and clones of the MP5, including some semi-automatic versions."
SWEP.Category 				= "Chedara Box - Пистолеты-пулемёты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/mp9/fire01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.2
SWEP.ShootWait = 0.08
SWEP.ReloadSounds = {
    [0.1] = {"weapons/mp5sd/boltback.wav"},
    [0.5] = {"weapons/mp5sd/clipout.wav"},
    [1.3] = {"weapons/mp5sd/clipin.wav"},
    [2] = {"weapons/mp5sd/boltforward.wav"},
}
SWEP.TwoHands = true
SWEP.ShellRotate = false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/district/w_smg_mp5.mdl"
SWEP.WorldModel				= "models/district/w_smg_mp5.mdl"

SWEP.addAng = Angle(-0.1,1.5,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-8,1.135,5.8) -- Sight pos
SWEP.SightAng = Angle(-10,0,0) -- Sight ang

SWEP.Mobility = 1.3
