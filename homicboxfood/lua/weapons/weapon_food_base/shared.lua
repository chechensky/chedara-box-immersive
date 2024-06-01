
SWEP.Base = 'weapon_base'
AddCSLuaFile()

SWEP.PrintName = "База Еды"
SWEP.Author = "Homicbox"
SWEP.Purpose = "База еды, она явна не должна была оказаться в твоих руках..."
SWEP.Category = "Еда"

SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.Spawnable = false

SWEP.ViewModel = "models/jordfood/can.mdl"
SWEP.WorldModel = "models/jordfood/can.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"


SWEP.Healsound = Sound("snd_jack_hmcd_eat"..math.random(1,4)..".wav")
SWEP.Satiety = 0.2
SWEP.EatsCounts = 5

SWEP.DrawWorldModelPos = Vector(0, 0, 0)
SWEP.DrawWorldModelAng = Angle(0, 0, 0)

SWEP.DrawCrosshair = false

sib_food = sib_food or {}
function SWEP:Initialize()
	sib_food[self] = true
	self.cianid = false
	self:SetHoldType( "slam" )
	if CLIENT then
		self.WorldModel = ClientsideModel(self.WorldModel)
		
		self.WorldModel:SetNoDraw(true)
	end
end

if CLIENT then
	
	function SWEP:DrawWorldModel()
		
		local _Owner = self:GetOwner()
	
		if (IsValid(_Owner)) then
			local offsetVec = self.DrawWorldModelPos
			local offsetAng = self.DrawWorldModelAng
				
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end
	
			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end
	
			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
	
			self.WorldModel:SetPos(newPos)
			self.WorldModel:SetAngles(newAng)
	
			self.WorldModel:SetupBones()
		else
			self.WorldModel:SetPos(self:GetPos())
			self.WorldModel:SetAngles(self:GetAngles())
		end
	
		self.WorldModel:DrawModel()
	end
end

hook.Add("Think","HBfood-customThinker",function()
	for wep in pairs(sib_food) do
		if not IsValid(wep) then sib_food[wep] = nil continue end

		local owner = wep:GetOwner()
		if not IsValid(owner) or (owner:IsPlayer() and not owner:Alive()) or owner:GetActiveWeapon() ~= wep then continue end--wtf i dont know

		if wep.Step then wep:Step() end
	end
end)

function SWEP:PrimaryAttack()
	--self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		print(self:GetOwner().poisoneda)
		self:GetOwner().hungryregen = self:GetOwner().hungryregen + self.Satiety
		self.EatsCounts = self.EatsCounts - 1
		sound.Play(self.Healsound, self:GetPos(),75,100,1.5)
        self:SetNextPrimaryFire( CurTime() + 1 )
        if self.EatsCounts <= 0 then
			if self.cianid == true then 
				self:GetOwner().poisoneda = true
				ply4 = self:GetOwner()
				timer.Create("Cianidpalusdr"..ply4:EntIndex().."12", 30, 1, function()
            		if ply4:Alive() and ply4.poisoneda == true then
                		ply4:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav",60)
            		end

            		timer.Create( "Cianidpalusdr"..ply4:EntIndex().."22", 10, 1, function()
                		if ply4:Alive() and ply4.poisoneda == true then
                   			ply4:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav",60)
                		end
            		end)

            		timer.Create( "Cianidpalusdr"..ply4:EntIndex().."32", 15, 1, function()
                		if ply4:Alive() and ply4.poisoneda == true then
                    		ply4.KillReason = "poison"
                    		ply4:Kill()
                		end
            		end)
        		end)			
			end
            self:Remove()
			self:GetOwner():SelectWeapon("weapon_hands")
        end
	end
end

function SWEP:OnRemove()
end

function SWEP:SecondaryAttack()
end

function SWEP:Step()
	local _Owner = self.Owner
	if SERVER then
		if _Owner:KeyDown(IN_ATTACK) then
			self:SetNWBool("Attack",true)
		else
			self:SetNWBool("Attack",false)
		end
	end
	if CLIENT then

		if self:GetNWBool("Attack") then
			self.Anim = Lerp(0.1,self.Anim or 0,1)
		else
			self.Anim = Lerp(0.1,self.Anim or 0,0)
		end

		_Owner:ManipulateBoneAngles(_Owner:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(45,15,65)*self.Anim,false)
	end
end

function SWEP:Holster()
	local owner = self:GetOwner()
	timer.Simple(.1,function()
		owner:ManipulateBoneAngles(owner:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(0,0,0),true)
	end)
	return true
end