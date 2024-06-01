

SWEP.PrintName = "Складной Ножик"
SWEP.Instructions = "Маленький ножик складного типа, который удобно носить в кармане. Хорошее средство для самообороны, которое никто не сможет увидеть, пока вы не достанете его из кармана."
SWEP.Category = "Chedara Box - Ближний Бой"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/knife") SWEP.IconOverride="vgui/knife" end
SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/pwb/weapons/w_knife.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_knife.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"

SWEP.Primary.Sound = Sound( "Weapon_Crowbar.Single" )
SWEP.Primary.Damage = 4
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.4
SWEP.Primary.Force = 150

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Lezvie = 1.7

function Circle( x, y, radius, seg )
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end

local tr = {}
local vecHull = Vector(10,10,10)
function EyeTrace(ply)
	tr.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tr.endpos = tr.start + ply:GetAngles():Forward() * 80
	tr.filter = ply
	--tr.mins = -vecHull
	--tr.maxs = vecHull
	return util.TraceLine(tr)
end

function SWEP:DrawHUD()
		if not (GetViewEntity() == LocalPlayer()) then return end
		if LocalPlayer():InVehicle() then return end
			local ply = self:GetOwner()
			local t = {}
			t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
			t.endpos = t.start + ply:GetAngles():Forward() * 80
			t.filter = self:GetOwner()
			local Tr = util.TraceLine(t)

			if Tr.Hit then

		local Size = math.Clamp(1 - ((Tr.HitPos - self:GetOwner():GetShootPos()):Length() / 80) ^ 2, .1, .3)
		surface.SetDrawColor(Color(200, 200, 200, 200))
		draw.NoTexture()
		Circle(Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y, 55 * Size, 32)

		surface.SetDrawColor(Color(255, 255, 255, 200))
		draw.NoTexture()
		Circle(Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y, 40 * Size, 32)
	end
end

function SWEP:KurareYes()
	wep.kurare = true
end

function SWEP:Initialize()
	self.type_attack = 2
	self.kurare = false
	self:SetHoldType("melee")
end


function SWEP:Deploy()
self:SetHoldType( "melee" )
end

function SWEP:Holster()
	local ply = self:GetOwner()
	timer.Simple(0.1,function()
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(0,0,0),true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),Angle(0,0,0),true)
	end)
	return true
end

function SWEP:PrimaryAttack()
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay/((self:GetOwner().stamina or 100)/100)-(self:GetOwner():GetNWInt("Adrenaline")/5) )

	if SERVER then
		self:GetOwner():EmitSound( "weapons/slam/throw.wav",50 )
		self:GetOwner().stamina = math.max(self:GetOwner().stamina - 0.5,0)
	end
	self:GetOwner():LagCompensation( true )
	local ply = self:GetOwner()

	local tra = {}
	tra.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tra.endpos = tra.start + ply:GetAngles():Forward() * 80
	tra.filter = self:GetOwner()
	local Tr = util.TraceLine(tra)
	local t = {}
	local pos1, pos2
	local tr
	if not Tr.Hit then
		t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
		t.endpos = t.start + ply:GetAngles():Forward() * 80
		t.filter = function(ent) return ent ~= self:GetOwner() and (ent:IsPlayer() or ent:IsRagdoll()) end
		t.mins = -Vector(10,10,10)
		t.maxs = Vector(10,10,10)
		tr = util.TraceHull(t)
	else
		tr = util.TraceLine(tra)
	end

	pos1 = tr.HitPos + tr.HitNormal
	pos2 = tr.HitPos - tr.HitNormal
	if true then
		if SERVER and tr.HitWorld then
			self:GetOwner():EmitSound(  "snd_jack_hmcd_knifehit.wav",50  )
		end

		if IsValid( tr.Entity ) and SERVER then
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamagePosition( tr.HitPos )
			dmginfo:SetDamageForce( self:GetOwner():GetForward() * self.Primary.Force )
			local angle = self:GetOwner():GetAngles().y - tr.Entity:GetAngles().y
			if angle < -180 then angle = 360 + angle end

			dmginfo:SetDamage( self.Primary.Damage / 1.5 )

			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
				self:GetOwner():EmitSound( "snd_jack_hmcd_slash.wav",50 )
			else

				if tr.Entity:GetClass() == "prop_ragdoll" then
					self:GetOwner():EmitSound(  "snd_jack_hmcd_slash.wav",50  )
				else
					self:GetOwner():EmitSound(  "snd_jack_hmcd_knifehit.wav",50  )
				end

			end
			tr.Entity:TakeDamageInfo( dmginfo )
		end
	end

	if SERVER and Tr.Hit then
		if IsValid(Tr.Entity) and Tr.Entity:GetClass()=="prop_ragdoll" then
			util.Decal("Impact.Flesh",pos1,pos2)
		else
			util.Decal("ManhackCut",pos1,pos2)
		end
	end

	self:GetOwner():LagCompensation( false )
end

function SWEP:SecondaryAttack()
if self.heavy_fight then return end
	self:GetOwner():LagCompensation( true )
	local ply = self:GetOwner()

	local tra = {}
	tra.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tra.endpos = tra.start + ply:GetAngles():Forward() * 80
	tra.filter = self:GetOwner()
	local Tr = util.TraceLine(tra)
	local t = {}
	local pos1, pos2
	local tr
	if not Tr.Hit then
		t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
		t.endpos = t.start + ply:GetAngles():Forward() * 80
		t.filter = function(ent) return ent ~= self:GetOwner() and (ent:IsPlayer() or ent:IsRagdoll()) end
		t.mins = -Vector(6,6,6)
		t.maxs = Vector(6,6,6)
		tr = util.TraceHull(t)
	else
		tr = util.TraceLine(tra)
	end

	pos1 = tr.HitPos + tr.HitNormal
	pos2 = tr.HitPos - tr.HitNormal
self.heavy_fight = true
timer.Simple(self.Primary.Delay*1.4, function()
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
	if SERVER then
		self:GetOwner():EmitSound("weapons/slam/throw.wav", 60)
		self:GetOwner().stamina = math.max(self:GetOwner().stamina - 0.5,0)
	end
	if true then
		if SERVER and tr.HitWorld then
			self:GetOwner():EmitSound("snd_jack_hmcd_knifehit.wav", 60)
		end

		if IsValid( tr.Entity ) and SERVER then
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamagePosition( tr.HitPos )
			dmginfo:SetDamageForce( self:GetOwner():GetForward() * self.Primary.Force )
			local angle = self:GetOwner():GetAngles().y - tr.Entity:GetAngles().y
			if angle < -180 then angle = 360 + angle end

			if angle <= 90 and angle >= -90 then
				print("angle <= 90, angle >= -90")
				dmginfo:SetDamage( self.Primary.Damage * 7 )
			else
				print("no angle <= 90, angle >= -90")
				dmginfo:SetDamage( self.Primary.Damage * 4 )
			end

			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
				self:GetOwner():EmitSound( "snd_jack_hmcd_knifestab.wav",60 )
			else
				if tr.Entity:GetClass() == "prop_ragdoll" then
					self:GetOwner():EmitSound(  "snd_jack_hmcd_knifestab.wav",60  )
				else
					self:GetOwner():EmitSound(  "snd_jack_hmcd_knifehit.wav",60  )
				end
			end
			tr.Entity:TakeDamageInfo( dmginfo )
		end
		-- self:GetOwner():EmitSound(Sound("Weapon_Knife.Single"), 60) -- CSoundEmitterSystemBase::GetParametersForSound:  No such sound Weapon_Crowbar.Single
	end

	if SERVER and Tr.Hit then
		if IsValid(Tr.Entity) and Tr.Entity:GetClass()=="prop_ragdoll" then
			util.Decal("Impact.Flesh",pos1,pos2)
		else
			util.Decal("ManhackCut",pos1,pos2)
		end
	end
	self.heavy_fight = false
	self:GetOwner():LagCompensation( false )
end)

end

function SWEP:Reload()
end

function SWEP:Think()
	if self.type_attack == 1 then
		self.Primary.Damage = 10
		self.Primary.Delay = 0.5
		self.Primary.Force = 200
		self:SetHoldType("knife")
		self.Anim = Lerp(0.1, self.Anim or 0, 1)
	end
	if self.type_attack == 2 then
		self.Anim = Lerp(0.2, self.Anim or 0, 1)
		self.Primary.Damage = 4
		self.Primary.Delay = 0.4
		self.Primary.Force = 150
	end
	if !self.heavy_fight then
		self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(35, 30, 50) * self.Anim, true)
	else
		self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(35,5,50) * self.Anim, true)
	end
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 5, -35) * self.Anim, true)
end