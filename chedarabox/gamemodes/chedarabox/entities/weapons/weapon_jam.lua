if (CLIENT) then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_jam") SWEP.IconOverride="vgui/wep_jack_hmcd_jam" end

AddCSLuaFile()

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Slot = 5
SWEP.SlotPos = 3

function SWEP:Initialize()
	--wat
end


function SWEP:DrawWorldModel()	
	self:DrawModel()
end

SWEP.Base="weapon_base"

SWEP.ViewModel = "models/props_junk/wood_pallet001a_chunka1.mdl"
SWEP.WorldModel = "models/props_junk/wood_pallet001a_chunka1.mdl"

SWEP.PrintName = "Клин двери"
SWEP.Category = "Chedara Box - Вещи предателя" 
SWEP.Instructions	= "Это сверхпрочный коммерческий дверной клин. Его можно задвинуть ногой на место, чтобы остановить движение двери.\n\n Щелкните левой кнопкой мыши, чтобы заклинить дверь.\n Нажмите E, чтобы снова поднять клин."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""

SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.CommandDroppable=false

SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"

SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

SWEP.CommandDroppable=false
SWEP.DeathDroppable=false

SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"

SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

SWEP.ENT = "ent_jam"
SWEP.DownAmt=0

function IsDoor(ent)
	local Class=ent:GetClass()
	return ((Class=="prop_door")or(Class=="prop_door_rotating")or(Class=="func_door")or(Class=="func_door_rotating")or(Class=="func_breakable"))
end

local function eyeTrace(ply)
    local att1 = ply:LookupAttachment("eyes")

    if not att1 then return end

    local att = ply:GetAttachment(att1)

    if not att then return end

    local tr = {}
    tr.start = att.Pos
    tr.endpos = tr.start + ply:EyeAngles():Forward() * 50
    tr.filter = ply

    return util.TraceLine(tr)
end

function SWEP:Initialize()
	self:SetHoldType("slam")
	self.DownAmt=20
end

function SWEP:PrimaryAttack()
	if self:GetOwner():KeyDown(IN_SPEED) and self:GetOwner():KeyDown(IN_FORWARD) then return end

	self:SetNextPrimaryFire( CurTime() + 1 )
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	if SERVER then

		local tr = eyeTrace(self:GetOwner())

		if not IsValid(tr.Entity) then return end

		if IsDoor(tr.Entity) then

			local Doors={tr.Entity}

			for key,other in pairs(ents.FindInSphere(tr.HitPos,65)) do 
				if IsDoor(other) then 
					table.insert(Doors,other) 
				end 
			end

			local Block = ents.Create(self.ENT)
			Block:SetPos(tr.HitPos + tr.HitNormal * 5)
			local Ang = tr.HitNormal:Angle()
			Ang:RotateAroundAxis(Ang:Up(),-90)
			Block:SetAngles(Ang)
			Block:Spawn()
			Block:Activate()
			Block:Block(Doors)
			self:Remove()
			self:GetOwner():SelectWeapon("weapon_hands")
		end
	end
end

function SWEP:Deploy()
	self:SetNextPrimaryFire( CurTime() + 1 )
	return true
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	if SERVER then

		local HoldType="slam"

		if self:GetOwner():KeyDown(IN_SPEED) and self:GetOwner():KeyDown(IN_FORWARD)then
			HoldType="normal"
		end

		self:SetHoldType(HoldType)
	end
end
function SWEP:Reload()
	--
end

if CLIENT then
    local model = GDrawWorldModel or ClientsideModel(SWEP.WorldModel,RENDER_GROUP_OPAQUE_ENTITY)
    GDrawWorldModel = model
    model:SetNoDraw(true)

	SWEP.dwmModeScale = 0.2
	SWEP.dwmForward = 2
	SWEP.dwmRight = 1
	SWEP.dwmUp = -1
	SWEP.dwmAUp = -90
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

        model:SetModelScale(0.3)

        model:DrawModel()
    end
end