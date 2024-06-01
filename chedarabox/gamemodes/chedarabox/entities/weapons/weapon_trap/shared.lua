if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_mann_hmcd_trap") SWEP.IconOverride="vgui/wep_mann_hmcd_trap" end

AddCSLuaFile()

SWEP.PrintName = "Капкан" 
SWEP.Category = "Chedara Box - Вещи предателя" 
SWEP.Spawnable = true
SWEP.Instructions = ""
SWEP.ViewModel = "models/trap/trap.mdl" 
SWEP.WorldModel = "models/trap/trap.mdl" 

SWEP.Primary.ClipSize = -1 
SWEP.Primary.DefaultClip = 0 
SWEP.Primary.Automatic = false 

SWEP.Weight	= 5

SWEP.Primary.ClipSize = -1 
SWEP.Primary.DefaultClip = 0 
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = "none" 
SWEP.Secondary.ClipSize = -1 
SWEP.Secondary.DefaultClip = 0 
SWEP.Secondary.Automatic = false 
SWEP.Secondary.Ammo = "none" 
SWEP.AutoSwitchTo = false 
SWEP.AutoSwitchFrom = false 
SWEP.Slot = 4
SWEP.SlotPos = 3 
SWEP.DrawAmmo = false 
SWEP.DrawCrosshair = true 

SWEP.OverridePaintIcon = OverridePaintIcon

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	self.DownAmt=8
	self:SetNextPrimaryFire(CurTime()+1)
	return true
end

function SWEP:PrimaryAttack() 

if not(IsFirstTimePredicted())then return end
if(self:GetOwner():KeyDown(IN_SPEED))then return end
if(CLIENT)then return end 

	local Can = ents.Create("ent_trap")

	if IsValid(Can) then
		local tr = util.TraceHull( {
			start = self:GetOwner():EyePos(),
			endpos = self:GetOwner():EyePos() + ( self:GetOwner():EyeAngles():Forward() * 100 ),
			filter = self:GetOwner(),
			mins = Can:OBBMins(),
			maxs = Can:OBBMaxs(),
		} )

		Can:SetPos(tr.HitPos)
		Can.Owner = self:GetOwner()
		Can:Spawn()
		Can:Activate()
		Can:GetPhysicsObject():SetVelocity(self:GetOwner():GetVelocity())
		sound.Play("physics/metal/soda_can_impact_hard2.wav",Can:GetPos(),55,math.random(100,110))
		self:Remove() 
	end

    self:GetOwner():SelectWeapon("weapon_hands")
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:OnRemove()

end

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
	--
end

function SWEP:Reload()
	--
end

function SWEP:OnDrop()
end

function SWEP:Initialize()
self:SetHoldType("slam")
end

if CLIENT then
	local model = GDrawWorldModel or ClientsideModel(SWEP.WorldModel,RENDER_GROUP_OPAQUE_ENTITY)
    GDrawWorldModel = model
    model:SetNoDraw(true)

    SWEP.dwmModeScale = 0.5
    SWEP.dwmForward = 5
    SWEP.dwmRight = 0
    SWEP.dwmUp = 0

    SWEP.dwmAUp = 0
    SWEP.dwmARight = 90
    SWEP.dwmAForward = 0
    function SWEP:DrawWorldModel()
        local owner = self:GetOwner()
        if not IsValid(owner) then
            self:DrawModel()

            return
        end

        local Pos,Ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
        if not Pos then return end

        model:SetModel(self.WorldModel)
        model:SetSkin(not self.bloodinside and 1 or 0)

        Pos:Add(Ang:Forward() * self.dwmForward)
        Pos:Add(Ang:Right() * self.dwmRight)
        Pos:Add(Ang:Up() * self.dwmUp)

        model:SetPos(Pos)

        Ang:RotateAroundAxis(Ang:Up(),self.dwmAUp)
        Ang:RotateAroundAxis(Ang:Right(),self.dwmARight)
        Ang:RotateAroundAxis(Ang:Forward(),self.dwmAForward)
        model:SetAngles(Ang)

        model:SetModelScale(1)

        model:DrawModel()
    end
end