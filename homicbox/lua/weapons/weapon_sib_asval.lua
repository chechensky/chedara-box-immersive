SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "AS-Val"
SWEP.Author 				= "Tula Arms Plant"
SWEP.Instructions			= "The ASM (6P30M) and VSSM (6P29M) are modernised variants of the AS and VSS respectively The VSSM is equipped with an aluminium buttstock with an adjustable cheek and butt pad and a new 30-round magazine was introduced to be intended for use with the ASM."
SWEP.Category 				= "Chedara Box - Винтовки"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_inss_asval") SWEP.IconOverride="vgui/hud/tfa_inss_asval" end

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "homigrad/weapons/rifle/val.wav"
SWEP.Primary.FarSound = "weapons/m4a1s/distant.wav"
SWEP.Primary.Force = 20
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.08
SWEP.ReloadSounds = {
    [0.3] = {"weapons/ak47/clipout.wav"},
    [1.3] = {"weapons/ak47/clipin.wav"},
    [1.8] = {"weapons/ak47/bolt.wav"},
}
SWEP.TwoHands = true
SWEP.DoFlash = false

SWEP.vbwPos = Vector(7,8,7)
SWEP.vbwAng = Angle(10,-160,0)

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

SWEP.ViewModel				= "models/pwb2/weapons/w_asval_checha2.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_asval_checha2.mdl"

SWEP.addAng = Angle(0,0,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightAng = Angle(0,0,0) -- Sight ang
SWEP.SightPos = Vector(-5,0.6,4.3)

SWEP.Mobility = 1.5

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