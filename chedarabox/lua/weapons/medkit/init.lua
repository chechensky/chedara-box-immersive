include("shared.lua")

SWEP.Dealy = 0.25
SWEP.Healsound = "usable_items/item_medkit_grizzly_01_open.wav"
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Dealy)
	self:SetNextSecondaryFire(CurTime() + self.Dealy)
	local owner = self:GetOwner()
	if self:Heal(owner) then owner:SetAnimation(PLAYER_ATTACK1) self:Remove() self:GetOwner():SelectWeapon("weapon_hands") end
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Dealy)
	self:SetNextSecondaryFire(CurTime() + self.Dealy)

	local owner = self:GetOwner()
	local ent = owner:GetEyeTrace().Entity --!! СДЕЛАТЬ ПРОВЕРКУ НА ДИСТАНЦИЮ!!!
	ent = (ent:IsPlayer() and ent) or (RagdollOwner(ent)) or (ent:GetClass() == "prop_ragdoll" and ent)
	if not ent then return end

	if self:Heal(ent) then
		if ent:IsPlayer() then
			local dmg = DamageInfo()
			dmg:SetDamage(-5)
			dmg:SetAttacker(self)

		end
		owner:SetAnimation(PLAYER_ATTACK1)
		self:Remove()
		self:GetOwner():SelectWeapon("weapon_hands")
	end
end

local healsound = Sound("usable_items/item_bandage_03_use.wav")

function SWEP:Heal(ent)
	if not ent or not ent:IsPlayer() then return end
	ent:ConCommand("+medkit")
end

function SWEP:Holster()
	local ply = self:GetOwner()
	timer.Simple(0.1,function()
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(0,0,0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),Angle(0,0,0))
	end)
	return true
end

function SWEP:Think()
	self.Anim = Lerp(0.1, self.Anim or 0, 1)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(20, 30, 50) * self.Anim, true)
	self:GetOwner():ManipulateBoneAngles(self:GetOwner():LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 0, 0) * self.Anim, true)
end