SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "FN FAL"
SWEP.Author 				= "FN Herstal"
SWEP.Instructions			= "During the Cold War the FAL was adopted by many countries of the North Atlantic Treaty Organization (NATO), with the notable exception of the United States. It is one of the most widely used rifles in history, having been used by more than 90 countries. It received the title the 'right arm of the free world' from its adoption by many countries of self-proclaimed free world countries. It is chambered in 7.62x51mm NATO, although originally designed for the intermediate .280 British. The British Commonwealth variant of the FAL was redesigned from FN's metric FAL into British imperial units and was produced under license as the L1A1 Self-Loading Rifle."
SWEP.Category 				= "Chedara Box - Винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.vbwPos = Vector(3,-5,0)
------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ".308 Winchester"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 65
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/sg553/fire01.wav"
SWEP.Primary.FarSound = "weapons/sg553/distant.wav"
SWEP.Primary.Force = 40
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.3] = {"weapons/m4a1s/clipout.wav"},
    [1.3] = {"weapons/m4a1s/clipin.wav"},
    [1.8] = {"weapons/ak47/bolt.wav"},
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

SWEP.ViewModel				= "models/district/w_rif_fal.mdl"
SWEP.WorldModel				= "models/district/w_rif_fal.mdl"

SWEP.addAng = Angle(-0.02,-0.08,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-7.3,0.78,3.65) -- Sight pos
SWEP.SightAng = Angle(-10,0,0) -- Sight ang

SWEP.Mobility = 1.6