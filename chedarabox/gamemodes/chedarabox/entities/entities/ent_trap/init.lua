AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include( 'shared.lua' ) 
ENT.SWEP="weapon_trap"

function ENT:Initialize() 
	self:SetUseType( SIMPLE_USE ) 
	self:SetModel( "models/trap/trap.mdl" ) 
	self:SetColor(Color(155,155,155,255))
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType(MOVETYPE_VPHYSICS) 
	self:SetSolid( SOLID_VPHYSICS ) 
	self:GetPhysicsObject():Wake()
	self:DrawShadow(true)

	--[[timer.Simple(5, function
		self:SetMoveType(MOVETYPE_NONE) 
	end)]]
end
 
function ENT:Use(ply)
	if self:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then 
		self:SetModel( "models/trap/trap.mdl" ) 
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		
		if IsValid(self.Traped) and self.Traped.IsWeld >= 1 then
			self.Traped.IsWeld = math.max(self.Traped.IsWeld - 1, 0)
			print(self.Traped.IsWeld)
		end

		if IsValid(self.Traped) then
			for weldEntity,self in pairs(self.Traped.weld) do
				self.Traped.weld[weldEntity] = nil

				weldEntity:Remove()
			end
		end
	else
		self:PickUp(ply)
	end
end
 
function ENT:PickUp(ply)
	local wep = self.SWEP

	if ply.roleT and not ply:HasWeapon(wep) then
		ply:Give(wep)
		ply:SelectWeapon(wep)
		self:Remove()
	end
end
 
function ENT:Touch( entity ) 
	if entity:IsPlayer() and IsValid(entity) then 

		if self:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then return false end 

		local ply = entity

		Faking(ply)
		
		self:SetModel("models/trap/trap_close.mdl") 
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) 
		ply:EmitSound( "trap/trap.mp3" ) 

		--[[local dmg = DamageInfo()
		dmg:SetDamage(math.random(15,20))
		dmg:SetDamageType(DMG_SLASH)
		dmg:SetDamagePosition(self:GetPos())
		ply:TakeDamageInfo(dmg)]]

		ply.Bloodlosing = ply.Bloodlosing + 10

		local rag = ply:GetNWEntity("Ragdoll")

		local legbone = {
			"ValveBiped.Bip01_L_Foot",
			"ValveBiped.Bip01_R_Foot",
		}

		rag.IsWeld = (rag.IsWeld or 0) + 1

		local bonerand = table.Random(legbone)

		if bonerand == "ValveBiped.Bip01_L_Foot" then
			entity.LeftLeg = 0
            if entity.msgLeftLeg < CurTime() then
                entity.msgLeftLeg = CurTime() + 1
                entity:ChatPrint("Left Leg is broken.")
                rag:EmitSound("NPC_Barnacle.BreakNeck",70,65,0.4,CHAN_ITEM)
            end
		else
			entity.RightLeg = 0
            if entity.msgRightLeg < CurTime() then
                ply.msgRightLeg = CurTime() + 1
                ply:ChatPrint("Right Leg is broken.")
                rag:EmitSound("NPC_Barnacle.BreakNeck",70,65,0.4,CHAN_ITEM)
            end
		end

		local bone = rag:LookupBone( bonerand )

		local BoneObj = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(bone))

		BoneObj:SetPos(self:GetPos())

		local PhysBone = rag:TranslateBoneToPhysBone(bone)

		local weldEntity = constraint.Weld(rag, self, PhysBone or 0, 0, 120000, 0, false, false)
		
		rag.weld = rag.weld or {}
		rag.weld[weldEntity] = self

		self.Traped = rag
	end 
end 

function ENT:OnTakeDamage(dmg) 
	self:SetModel("models/trap/trap_close.mdl")
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:EmitSound( "trap/trap.mp3" )
end

function ENT:OnRemove()
	if IsValid(self.Traped) then
		for weldEntity,self in pairs(self.Traped.weld) do
			self.Traped.weld[weldEntity] = nil

			weldEntity:Remove()
		end

		self.Traped.IsWeld = self.Traped.IsWeld - 1
	end
end

if(CLIENT)then
	--
end