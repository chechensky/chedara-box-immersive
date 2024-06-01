SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Draco"
SWEP.Author 				= "Kalashnikov"
SWEP.Instructions			= "Драко, популярный пистолет банд Америки, как бы укороченный калаш."
SWEP.Category 				= "Chedara Box - Пистолеты"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_ins2_draco") SWEP.IconOverride="vgui/hud/tfa_ins2_draco" end
------------------------------------------

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 39
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "homigrad/weapons/rifle/galil-1.wav"
SWEP.Primary.FarSound = "pwb/weapons/aks74u/shoot.wav"
SWEP.Primary.Force = 32
SWEP.ReloadTime = 2.8
SWEP.ShootWait = 0.07
SWEP.ReloadSounds = {
    [0.3] = {"pwb/weapons/aks74u/clipout.wav"},
    [1.3] = {"pwb/weapons/aks74u/clipin.wav"},
    [1.8] = {"pwb/weapons/aks74u/boltpull.wav"},
}
SWEP.TwoHands = true
SWEP.Shell = "EjectBrass_762Nato"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_akm.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_akm.mdl"

SWEP.addAng = Angle(10.1,-0.6,0) -- Barrel pos adjust
SWEP.addPos = Vector(0,0,0) -- Barrel ang adjust
SWEP.SightPos = Vector(-10,0.73,6.2) -- Sight pos
SWEP.SightAng = Angle(0,0,0) -- Sight ang

SWEP.Mobility = 3

if (CLIENT) then
	function SWEP:DrawWorldModel()
		if (self.DatWorldModel) then
		    local Pos,Ang = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand"))
			if ((Pos) and (Ang) and !self.ShowWorldModel) then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*3+Ang:Right()*1-Ang:Up()*2)
				Ang:RotateAroundAxis(Ang:Up(),180)
				Ang:RotateAroundAxis(Ang:Right(),180)
				Ang:RotateAroundAxis(Ang:Forward(),0)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel = ClientsideModel("models/draco/w_draco_chechkin.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end