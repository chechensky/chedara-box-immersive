SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "HK-USP"
SWEP.Author 				= "Heckler & Koch"
SWEP.Instructions			= "The USP is a semi-automatic pistol developed in Germany by Heckler & Koch GmbH (H&K) as a replacement for the P7 series of handguns."
SWEP.Category 				= "Chedara Box - Пистолеты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_ins2_uspt") SWEP.IconOverride="vgui/hud/tfa_ins2_uspt" end
SWEP.vbwPos = Vector(6,0,-3)
------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/usps/us_fire01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 25
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.1] = {"weapons/usps/clipout.wav"},
    [0.8] = {"weapons/usps/clipin.wav"},
    [1.2] = {"weapons/usps/slideback.wav"},
    [1.4] = {"weapons/usps/slideforward.wav"},
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

SWEP.ViewModel				= "models/district/w_pist_usp.mdl"
SWEP.WorldModel				= "models/district/w_pist_usp.mdl"

SWEP.addAng = Angle(0.2,-0.05,0) -- Barrel ang adjust
SWEP.addPos = Vector(0,-2,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-14,1.44,3.7) -- Sight pos
SWEP.SightAng = Angle(2,12,0) -- Sight ang