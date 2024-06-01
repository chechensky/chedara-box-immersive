SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "АКS-74U"
SWEP.Author 				= "Kalashnikov"
SWEP.Instructions			= "АКС-74У - Автомат Калашникова Складной - 74ого года укороченный, укороченная версия автомата калашникова 74ого года выпуска, питается боеприпасами 5,45x39мм."
SWEP.Category 				= "Chedara Box - Винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.vbwPos = Vector(-2,9.5,7)
SWEP.vbwAng = Angle(10,-160,0)
------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.45x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "homigrad/weapons/rifle/galil-1.wav"
SWEP.Primary.FarSound = "pwb/weapons/aks74u/shoot.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.3] = {"pwb/weapons/aks74u/clipout.wav"},
    [1.3] = {"pwb/weapons/aks74u/clipin.wav"},
    [1.8] = {"pwb/weapons/aks74u/boltpull.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_762Nato"

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

SWEP.ViewModel				= "models/pwb/weapons/w_aks74u.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_aks74u.mdl"

SWEP.addAng = Angle(0,-0.08,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-8.2,0.78,4.6) -- Sight pos
SWEP.SightAng = Angle(-8,0,0) -- Sight ang

SWEP.Mobility = 3





