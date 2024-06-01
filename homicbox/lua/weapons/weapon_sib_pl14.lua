SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "PL14"
SWEP.Author 				= "Дмитрий Лебедев"
SWEP.Instructions			= "Пистолет стоявший на вооружении МВД РФ, снаряжается патронами 9x19мм парабеллум, магазин на 14 патрон."
SWEP.Category 				= "Chedara Box - Пистолеты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/pl14") SWEP.IconOverride="vgui/pl14" end

------------------------------------------

SWEP.Primary.ClipSize		= 14
SWEP.Primary.DefaultClip	= 14
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 70
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb2/weapons/pl14/shot-unsil.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Suppsound = "homigrad/weapons/pistols/sil2.wav"
SWEP.Primary.Force = 15
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.1] = {"pwb2/weapons/pl14/magout.wav"},
    [0.8] = {"pwb2/weapons/pl14/magin.wav"},
    [1.4] = {"pwb2/weapons/pl14/sliderelease.wav"},
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

SWEP.ViewModel				= "models/pwb2/weapons/w_pl14.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_pl14.mdl"

SWEP.addAng = Angle(0,0.4,0) -- Barrel ang adjust
SWEP.addPos = Vector(0,-2,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-14,0.4,1.4) -- Sight pos
SWEP.SightAng = Angle(2,12,0) -- Sight ang