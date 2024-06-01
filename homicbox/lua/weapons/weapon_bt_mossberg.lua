SWEP.Base = 'salat_base' -- base
if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_assaultrifle", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_assaultrifle")
end
SWEP.PrintName 				= "Mossberg 930"
SWEP.Author 				= "HM?"
SWEP.Instructions			= "MOSSBERG 930... Hm-m?"
SWEP.Category 				= "Chedara Box - Дробовики"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------


SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 70
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb2/weapons/m4super90/xm1014-1.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Force = 130
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.3
SWEP.NumBullet = 12
SWEP.ReloadSounds = {
    [0.2] = {"snd_jack_shotguninsert.wav"},
    [0.8] = {"snd_jack_shotguninsert.wav"},
    [1.5] = {"snd_jack_shotguninsert.wav"},
    [1.8] = {"snd_jack_shotguninsert.wav"},
    [2.1] = {"snd_jack_shotguninsert.wav"},
    [2.6] = {"snd_jack_shotguninsert.wav"},
    [2.7] = {"snd_jack_hmcd_shotpump.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_12Gauge"
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

SWEP.Slot					= 4
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/w_mossberg_590kruto.mdl"
SWEP.WorldModel				= "models/weapons/w_mossberg_590kruto.mdl"

SWEP.addAng = Angle(1,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-5,1.9,5.3) -- Sight pos
SWEP.SightAng = Angle(-8,0,0) -- Sight ang

SWEP.Mobility = 1.3