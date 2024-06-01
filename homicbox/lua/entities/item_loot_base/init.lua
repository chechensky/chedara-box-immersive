AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMaterial( self.ModelMaterial )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_PUSHAWAY )
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(20)
		phys:Wake()
		phys:EnableMotion(true)
	end
end

util.AddNetworkString("lootstart")

function ENT:Use( activator )
    if !activator:IsPlayer() then return end
	net.Start("lootstart")
		net.WriteTable(self.LootTable)
		net.WriteEntity(self)
	net.Send(activator)
	self:EmitSound( "physics/metal/metal_computer_impact_soft"..math.random(1,3)..".wav", 65 )
	PrintTable(self.RandomLoot)
	--snds_jack_gmod/equip1.wav
end

function ENT:Think()
	self.UpdateTime = self.UpdateTime or CurTime()+600
	if self.UpdateTime >= CurTime() then return end
	table.Empty(self.LootTable)
	table.CopyFromTo(self.RandomLoot[math.random(1,#self.RandomLoot)],self.LootTable)
	self.UpdateTime = CurTime()+600
	print("Yes")
end


util.AddNetworkString("give_gun")

net.Receive("give_gun",function(len, ply)
	local gun = net.ReadString()
	local ent = net.ReadEntity()
	if (not ent.LootTable[gun]) or ply:HasWeapon(gun) then return end
		ply:Give(gun)
		ply:ChatPrint("Взял")
		ent.LootTable[gun] = nil
		ent:EmitSound( "snds_jack_gmod/equip"..math.random(1,3)..".wav", 75 )
end)

util.AddNetworkString("drop_ent")

net.Receive("drop_ent",function(len, ply)
	local ent = net.ReadString()
	local lootent = net.ReadEntity()
	if not lootent.LootTable[ent] then return end
		local entity = ents.Create(ent)
		entity:SetPos(lootent:GetPos()+Vector(0,0,30))
		entity.Spawned = true
		entity:Spawn()
		lootent.LootTable[ent] = nil
		lootent:EmitSound( "snds_jack_gmod/equip"..math.random(1,3)..".wav", 75 )
end)

