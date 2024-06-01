
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "FN P90"
SWEP.Author 				= "FN Herstal"
SWEP.Instructions			= "The FN P90 is a submachine gun chambered for the 5.7x28mm cartridge, also classified as a personal defense weapon, designed and manufactured by FN Herstal in Belgium.[9][10][11] Created in response to NATO requests for a replacement for 9x19mm Parabellum firearms, the P90 was designed as a compact but powerful firearm for vehicle crews, operators of crew-served weapons, support personnel, special forces, and counter-terrorist groups."
SWEP.Category 				= "Chedara Box - Пистолеты-пулемёты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.7x28 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/p90/fire01.wav"
SWEP.Primary.FarSound = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 60
SWEP.ReloadTime = 2.2
SWEP.ShootWait = 0.05
SWEP.ReloadSounds = {
    [0.1] = {"weapons/p90/clipout.wav"},
    [0.7] = {"weapons/p90/clipin.wav"},
    [1] = {"weapons/p90/cliphit.wav"},
    [1.6] = {"weapons/p90/boltback.wav"},
    [1.8] = {"weapons/p90/boltforward.wav"}
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_57"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/district/w_smg_p90.mdl"
SWEP.WorldModel				= "models/district/w_smg_p90.mdl"

SWEP.addAng = Angle(-1.2,1.87,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-8,1,7) -- Sight pos
SWEP.SightAng = Angle(-10,2,0) -- Sight ang

SWEP.Mobility = 1.3

SWEP.PremiumSkin = {
    [3] = "null",
    [4] = "null",
}

function SWEP:DrawWorldModel()
    self:DrawModel()

    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
        for k,v in pairs(self.PremiumSkin) do
            self:SetSubMaterial( k, v )
        end
        self:DrawModel()
    end
end