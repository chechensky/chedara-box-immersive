SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Desert Eagle"
SWEP.Author 				= "Israel Military Industries"
SWEP.Instructions			= "The Desert Eagle is a gas-operated, semi-automatic pistol known for chambering the .50 Action Express, the largest centerfire cartridge of any magazine-fed, self-loading pistol."
SWEP.Category 				= "Chedara Box - Пистолеты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/deserteagle") SWEP.IconOverride="vgui/deserteagle" end

------------------------------------------

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 7
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".50 AE Magnum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/deagle/fire01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_sht_far.wav"
SWEP.Primary.Force = 70
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.1] = {"weapons/deagle/clipout.wav"},
    [0.8] = {"weapons/deagle/clipin.wav"},
    [1.2] = {"weapons/deagle/slideback.wav"},
    [1.4] = {"weapons/deagle/slideforward.wav"},
}
SWEP.Shell = "EjectBrass_57"

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

SWEP.ViewModel				= "models/district/w_pist_deagle.mdl"
SWEP.WorldModel				= "models/district/w_pist_deagle.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel ang adjust
SWEP.addPos = Vector(0,0,0) -- Barrel pos adjust
SWEP.SightPos = Vector(-14,1.6,4.05) -- Sight pos
SWEP.SightAng = Angle(0,8,0) -- Sight ang



SWEP.PremiumSkin = {
    [0] = "skins/goldmat/goldmaterial", 
    [1] = "skins/goldmat/goldmaterial",
}
SWEP.vbwPos = Vector(6,0,-3)
function SWEP:Think()
    
    if self.holdnow == "pistol" then self:SetHoldType("pistol") end
    if self.holdnow == "revolver" then return end
end