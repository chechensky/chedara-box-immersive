SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Glock 18"
SWEP.Author 				= "Glock Ges.m.b.H."
SWEP.Instructions			= "Glock is a brand of polymer-framed, short recoil-operated, locked-breech semi-automatic pistols designed and produced by Austrian manufacturer Glock Ges.m.b.H."
SWEP.Category 				= "Chedara Box - Пистолеты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/tfa_ins2_glock_p80") SWEP.IconOverride="vgui/tfa_ins2_glock_p80" end

------------------------------------------

SWEP.Primary.ClipSize		= 17
SWEP.Primary.DefaultClip	= 17
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 45
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "hndg_beretta92fs/beretta92_fire1.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Suppsound = "homigrad/weapons/pistols/mp5-sil.wav"
SWEP.Primary.Force = 20
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.1] = {"weapons/glock18/clipout.wav"},
    [0.8] = {"weapons/glock18/clipin.wav"},
    [1.2] = {"weapons/glock18/slideback.wav"},
    [1.4] = {"weapons/glock18/slideforward.wav"},
}

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

SWEP.vbwPos = Vector(-6,-8,5.7)
SWEP.vbwAng = Angle(0,-60,-90)

------------------------------------------

SWEP.Slot					= 1
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_glock17_checha17.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_glock17_checha17.mdl"

SWEP.addAng = Angle(0.5,0,0) -- Barrel ang adjust
SWEP.addPos = Vector(0,0,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-14,0,1.6) -- Sight pos
SWEP.SightAng = Angle(-10,0,-5) -- Sight ang

SWEP.Mobility = 2

SWEP.PremiumSkin = {
    [4] = "skins/goldmat/goldmaterial",
}

function SWEP:Think()
    if self:GetNWBool("WEP_Supressor", false) == true then
        self.Primary.Force = 10
    end
end