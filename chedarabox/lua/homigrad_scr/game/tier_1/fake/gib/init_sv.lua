local vecZero = Vector(0, 0, 0)
local vecInf = Vector(0, 0, 0)

local function removeBone(rag, bone, phys_bone)
	rag:ManipulateBoneScale(bone, vecZero)

	if rag.gibRemove[phys_bone] then return end

	local phys_obj = rag:GetPhysicsObjectNum(phys_bone)
	phys_obj:EnableCollisions(false)
	phys_obj:SetMass(0.1)

	constraint.RemoveAll(phys_obj)
	rag.gibRemove[phys_bone] = phys_obj
end

local function recursive_bone(rag, bone, list)
	for i, bone in pairs(rag:GetChildBones(bone)) do
		if bone == 0 then continue end

		list[#list + 1] = bone

		recursive_bone(rag, bone, list)
	end
end

function Gib_RemoveBone(rag, bone, phys_bone)
	rag.gibRemove = rag.gibRemove or {}

	removeBone(rag, bone, phys_bone)

	local list = {}
	recursive_bone(rag, bone, list)
	for i, bone in pairs(list) do
		removeBone(rag, bone, rag:TranslateBoneToPhysBone(bone))
	end
end

concommand.Add("removebone", function(ply)
	local trace = ply:GetEyeTrace()
	local ent = trace.Entity
	if not IsValid(ent) then return end

	local phys_bone = trace.PhysicsBone
	if not phys_bone or phys_bone == 0 then return end

	Gib_RemoveBone(ent, ent:TranslatePhysBoneToBone(phys_bone), phys_bone)
end)

gib_ragdols = gib_ragdols or {}
local gib_ragdols = gib_ragdols

local validHitGroup = {
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
}

local Rand = math.Rand

local validBone = {
	["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] = true,
	["ValveBiped.Bip01_R_Hand"] = true,
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] = true,
	["ValveBiped.Bip01_L_Hand"] = true,

	["ValveBiped.Bip01_L_Thigh"] = true,
	["ValveBiped.Bip01_L_Calf"] = true,
	["ValveBiped.Bip01_L_Foot"] = true,
	["ValveBiped.Bip01_R_Thigh"] = true,
	["ValveBiped.Bip01_R_Calf"] = true,
	["ValveBiped.Bip01_R_Foot"] = true
}

local max = math.max
local util_TraceLine = util.TraceLine
local util_Decal = util.Decal

local tr = {}

hook.Add("Think","Gib",function()
	local time = CurTime()

	for ent in pairs(gib_ragdols) do
		if not IsValid(ent) then gib_ragdols[ent] = nil continue end

		if ent.BloodGibs and ent.Blood > 0 then
			local k = ent.Blood / 5000

			if (ent.BloodNext or 0) < time then
				ent.BloodNext = time + Rand(0.25,0.5) / max(k,0.25)
				ent.Blood = max(ent.Blood - 25,0)

				tr.start = ent:GetPos()
				tr.endpos = tr.start + Vector(Rand(-1,1),Rand(-1,1),-Rand(0.25,0.4)) * 125 * Rand(0.8,1.2)
				tr.filter = ent

				local traceResult = util_TraceLine(tr)
				if traceResult.Hit then
					ent:EmitSound("ambient/water/drip" .. math.random(1,4) .. ".wav", 60,math.random(230,240),0.1,CHAN_AUTO)

					util_Decal("Blood",traceResult.HitPos + traceResult.HitNormal,traceResult.HitPos - traceResult.HitNormal,ply)
				else
					BloodParticle(ent:GetPos() + ent:OBBCenter(),ent:GetVelocity() + Vector(math.Rand(-5,5),math.Rand(-5,5),0))
				end
			end

			local BloodGibs = ent.BloodGibs

			for phys_bone,phys_obj in pairs(ent.gibRemove) do
				if (BloodGibs[phys_bone] or 0) < time then
					ent.Blood = max(ent.Blood - 25,0)

					BloodGibs[phys_bone] = time + Rand(0.07,0.1) / max(k,0.25)

					BloodParticle(phys_obj:GetPos(),phys_obj:GetVelocity() + phys_obj:GetAngles():Forward() * Rand(200,250) * k)
				end
			end
		end
	end
end)

concommand.Add("checha_getkek", function(ply)
	local weptable = weapons.Get(ply.curweapon)
	print(ply.curweapon)
	print(ply.wep)
	print(ply.wep.curweapon)
	print(ply.wep.knife)
end)

hook.Add("PlayerSpawn", "ResetFlexWeight", function(ply)
	for i = 0, 53 do
        timer.Simple(i * 0.001, function()
            ply:SetFlexWeight(i, 0)
        end)
    end
end)