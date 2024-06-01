SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "RPK"
SWEP.Author 				= "Kalashnikov"
SWEP.Instructions			= "RPK - Ручной Пулемет Калашникова, питается патронами 7.62x54мм."
SWEP.Category 				= "Chedara Box - Винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------
SWEP.vbwPos = Vector(-7,-3,2)
SWEP.Primary.ClipSize		= 45
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x54 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 80
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/tfa_ins2/akp/ak74/ak74_tp.wav"
SWEP.Primary.FarSound = "weapons/tfa_ins2/akp/ak47/ak47_dist.wav"
SWEP.Primary.Suppsound = "weapons/tfa_ins2/ak103/ak103_suppressed_fp.wav"
SWEP.Primary.Force = 30
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.08
SWEP.ReloadSounds = {
    [0.3] = {"pwb/weapons/akm/clipout.wav"},
    [1.3] = {"pwb/weapons/akm/clipin.wav"},
    [1.8] = {"pwb/weapons/akm/boltpull.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_762Nato"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb2/weapons/w_rpk_checha5.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_rpk_checha5.mdl"

SWEP.addAng = Angle(3,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-7.8,0.78,4.6) -- Sight pos
SWEP.SightAng = Angle(-8,0,0) -- Sight ang

SWEP.Mobility = 2

function SWEP:Think()
    if self:GetNWBool("WEP_Supressor", false) == true then
        self.Primary.Force = 15
    else
        self.Primary.Force = 30
    end
end

if CLIENT then
    function SWEP:Think()
        sib_wep[self] = true
        kek = self:GetNWEntity("SightOBJ")
        if self:GetNWBool("WEP_LeupoldMark4Hamr",false) == true then
            self.rtmat = GetRenderTarget("huy-glass", 512, 512, false)  
            self.mat = Material("effects/arc9/rt")
            self.mat:SetTexture("$basetexture",self.rtmat)

            local texture_matrix = self.mat:GetMatrix("$basetexturetransform")
            texture_matrix:SetAngles( Angle(0,0,0) )
            self.mat:SetMatrix("$basetexturetransform",texture_matrix)

            self.DrawScope = true
            self.ScopeAdjust=Angle(0,0,90)
            self.ScopePos=Vector(0,0,0)
            self.ScopeFov=7
            self.ScopeSize=1.3
            self.ScopeMat = Material("decals/bravo4x.png")
        elseif self:GetNWBool("WEP_PSO1M2",false) == true then 
            self.DrawScope = true
            self.ScopeAdjust=Angle(0,0,90)
            self.ScopePos=Vector(0,0,0)
            self.ScopeFov=7
            self.ScopeSize=1.3
            self.ScopeMat = Material("vgui/arc9_eft_shared/reticles/scope_dovetail_belomo_pso_1_4x24_marks_1.png")

            self.rtmat = GetRenderTarget("huy-glass", 512, 512, false)  
            self.mat = Material("effects/arc9/rt")
            self.mat:SetTexture("$basetexture",self.rtmat)

            local texture_matrix = self.mat:GetMatrix("$basetexturetransform")
            texture_matrix:SetAngles( Angle(0,0,0) )
            self.mat:SetMatrix("$basetexturetransform",texture_matrix)
        elseif self:GetNWBool("WEP_OKP7Sight",false) == true then 
            self.DrawScope = true
            self.ScopeAdjust=Angle(0,0,185)
            self.ScopePos=Vector(0,0,0)
            self.ScopeFov=6
            self.ScopeSize=0.25
            self.ScopeMat = Material("vgui/arc9_eft_shared/reticles/scope_all_ekb_okp7_marks.png")

            self.rtmat = GetRenderTarget("huy-glass", 512, 512, false)  
            self.mat = Material("effects/arc9/rt")
            self.mat:SetTexture("$basetexture",self.rtmat)

            local texture_matrix = self.mat:GetMatrix("$basetexturetransform")
            texture_matrix:SetAngles( Angle(0,0,0) )
            self.mat:SetMatrix("$basetexturetransform",texture_matrix)
        end
    end
end