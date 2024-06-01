SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Benelli M3"
SWEP.Author 				= "Benelli"
SWEP.Instructions			= "The Benelli M3 is a shotgun designed and manufactured by Italian firearms manufacturer Benelli Armi SpA, and the third model of the Benelli Super 90 line of semi-automatic shotguns."
SWEP.Category 				= "Chedara Box - Дробовики"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------
SWEP.vbwPos = Vector(0,-5,0)
SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/nova/fire.wav"
SWEP.Primary.FarSound = "weapons/nova/distant.wav"
SWEP.Primary.Suppsound = "toz_shotgun/toz_suppressed_fp.wav"
SWEP.Primary.Force = 250
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.2
SWEP.NumBullet = 12
SWEP.ReloadSounds = {
    [0.3] = {"weapons/nova/insertshell01.wav"},
    [0.6] = {"weapons/nova/insertshell02.wav"},
    [0.9] = {"weapons/nova/insertshell03.wav"},
    [1.2] = {"weapons/nova/insertshell04.wav"},
    [1.5] = {"weapons/nova/insertshell01.wav"},
    [1.8] = {"weapons/nova/insertshell03.wav"},
    [2.1] = {"weapons/nova/insertshell02.wav"},
    [2.4] = {"weapons/nova/insertshell04.wav"},
    [2.7] = {"weapons/nova/pump.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_12Gauge"

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

SWEP.ViewModel				= "models/district/w_shot_m3super90_checha.mdl"
SWEP.WorldModel				= "models/district/w_shot_m3super90_checha.mdl"

SWEP.addAng = Angle(-0.5,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-5,0.97,3.6) -- Sight pos
SWEP.SightAng = Angle(-8,0,0) -- Sight ang


SWEP.Mobility = 1.5

function SWEP:Think()
    if self:GetNWBool("WEP_Supressor", false) == true then
        self.Primary.Force = 250
    else
        self.Primary.Force = 150
    end
end