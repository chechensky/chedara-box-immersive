SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Mosin Nagant"
SWEP.Author 				= "Mosin"
SWEP.Instructions			= "Винтовка Мосина - помещается 5 патрон, снаряжен боеприпасами 7.62x54мм образец 1891г."
SWEP.Category 				= "Chedara Box - Марксманские винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_ins2_mosin") SWEP.IconOverride="vgui/hud/tfa_ins2_mosin" end

------------------------------------------
SWEP.vbwPos = Vector(0,-3,6)
SWEP.vbwAng = Angle(180,0,0)
SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x54 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 210
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "mosin/mosin_fp.wav"
SWEP.Primary.FarSound = "mosin/mosin_dist.wav"
SWEP.Primary.Suppsound = "mosin/mosin_suppressed_fp.wav"
SWEP.Primary.Force = 90
SWEP.ReloadTime = 2.3
SWEP.ShootWait = 1.6
SWEP.ReloadSounds = {
    [0.5] = {"weapons/tfa_ins2/mosin/mosin_boltforward.wav"},
    [0.2] = {"weapons/tfa_ins2/mosin/mosin_bulletin_2.wav"},
    [0.8] = {"weapons/tfa_ins2/mosin/mosin_bulletin_2.wav"},
    [1.5] = {"weapons/tfa_ins2/mosin/mosin_bulletin_2.wav"},
    [1.8] = {"weapons/tfa_ins2/mosin/mosin_bulletin_2.wav"},
    [2.1] = {"weapons/tfa_ins2/mosin/mosin_bulletin_2.wav"},
    [2.7] = {"weapons/tfa_ins2/mosin/mosin_boltrelease.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_556"
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

SWEP.ViewModel				= "models/weapons/w_grub_mosin_checha.mdl"
SWEP.WorldModel				= "models/weapons/w_grub_mosin_checha.mdl"

SWEP.addAng = Angle(-1,0.1,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-4,0.3,5.2) -- Sight pos
SWEP.SightAng = Angle(-10,0,7) -- Sight ang

SWEP.Mobility = 0.7

function SWEP:Think()
    if self:GetNWBool("WEP_Supressor", false) == true then
        self.Primary.Force = 70
        self.Primary.Damage = 160
        self.Weight = 5.5
        self.Mobility = 0.5
    end
end

if CLIENT then
    function SWEP:Think()
        sib_wep[self] = true
        kek = self:GetNWEntity("SightOBJ")
        if self:GetNWBool("WEP_PSO1M2",false) == true then 
            self.DrawScope = true
            self.ScopeAdjust=Angle(0,0,90)
            self.ScopePos=Vector(0,0,0)
            self.ScopeFov=5
            self.ScopeSize=2
            self.ScopeMat = Material("vgui/arc9_eft_shared/reticles/scope_dovetail_belomo_pso_1_4x24_marks_1.png")

            self.rtmat = GetRenderTarget("huy-glass", 512, 512, false)  
            self.mat = Material("effects/arc9/rt")
            self.mat:SetTexture("$basetexture",self.rtmat)

            local texture_matrix = self.mat:GetMatrix("$basetexturetransform")
            texture_matrix:SetAngles( Angle(0,0,0) )
            self.mat:SetMatrix("$basetexturetransform",texture_matrix)
        end
    end
end