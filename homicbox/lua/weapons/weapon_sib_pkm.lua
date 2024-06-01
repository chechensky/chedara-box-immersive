SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "PKM"
SWEP.Author 				= "Kalashnikov"
SWEP.Instructions			= "Пулемет Калашникова, питается патронами 7.62x54мм, снаряжается коробками с лентами на 100 / 150 / 200 патрон, в этом ПКМ в коробку можно снарядить только 100 патрон."
SWEP.Category 				= "Chedara Box - Пулемёты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x54 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 160
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb/weapons/pkm/shoot.wav"
SWEP.Primary.FarSound = "pwb2/weapons/pkm/pkm3.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.08
SWEP.ReloadSounds = {
    [0.1] = {"pwb/weapons/pkm/boxout.wav"},
    [1] = {"pwb/weapons/pkm/boxin.wav"},
    [1.5] = {"pwb/weapons/pkm/coverdown.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_556"
SWEP.ShellRotate = false
SWEP.vbwPos = Vector(-2,-7,0)
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

SWEP.ViewModel				= "models/pwb/weapons/w_pkm.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_pkm.mdl"

SWEP.addAng = Angle(-0.2,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-5.3,0.83,5.1) -- Sight pos
SWEP.SightAng = Angle(-5,0,0) -- Sight ang

SWEP.Mobility = 4
