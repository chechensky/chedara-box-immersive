SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Remington 870"
SWEP.Author 				= "Remington Arms Company"
SWEP.Instructions			= "The Remington Model 870 is a pump-action shotgun manufactured by Remington Arms Company, LLC. It is widely used by the public for shooting sports, hunting and self-defense, as well as by law enforcement and military organizations worldwide."
SWEP.Category 				= "Chedara Box - Дробовики"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_shotgun") SWEP.IconOverride="vgui/wep_jack_hmcd_shotgun" end

------------------------------------------
SWEP.vbwPos = Vector(-8,-4.1,2)
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12/70 gauge"
SWEP.Primary.Cone = 0.05
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 15
SWEP.Primary.Sound = "toz_shotgun/toz_fp.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Suppsound = "toz_shotgun/toz_suppressed_fp.wav"
SWEP.Primary.Force = 150
SWEP.ReloadTime = 2.7
SWEP.ShootWait = 0.5
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
SWEP.ShellRotate = true

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

SWEP.ViewModel				= "models/district/w_shot_r870_checha12.mdl"
SWEP.WorldModel				= "models/district/w_shot_r870_checha12.mdl"

SWEP.addAng = Angle(-0.5,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-6,0.7,3.4) -- Sight pos
SWEP.SightAng = Angle(-11,0,0) -- Sight ang

SWEP.Mobility = 1.5

function SWEP:Think()
    if self:GetNWBool("WEP_Supressor", false) == true then
        self.Primary.Force = 110
        self.Primary.Damage = 28
        self.Weight = 5.5
        self.Mobility = 1.9
    else
        self.Primary.Force = 150
        self.Primary.Damage = 30
        self.Weight = 5
        self.Mobility = 1.5
    end
end