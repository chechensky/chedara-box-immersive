local models = {
	["models/player/combine_soldier_prisonguard.mdl"] = true,
	["models/player/police.mdl"] = true,
	["models/player/police_fem.mdl"] = true,
	["models/player/combine_super_soldier.mdl"] = true,
	["models/player/zombie_fast.mdl"] = true,
	["models/player/skeleton.mdl"] = true,
	["models/player/soldier_stripped.mdl"] = true,
	["models/player/zombie_fast.mdl"] = true,
	["models/player/zombie_soldier.mdl"] = true,
	["models/player/combine_soldier.mdl"] = true,
	["models/bloocobalt/splinter cell/chemsuit_cod.mdl"] = true,
}

BleedingEntities = BleedingEntities or {}

hook.Add("HomigradDamage","phildcorn",function(ply,hitGroup,dmginfo,rag,armorMul)
	if armorMul <= 0.75 or not dmginfo:IsDamageType(DMG_BULLET+DMG_SLASH+DMG_BLAST+DMG_ENERGYBEAM+DMG_NEVERGIB+DMG_ALWAYSGIB+DMG_PLASMA+DMG_AIRBOAT+DMG_SNIPER+DMG_BUCKSHOT) then return end
	
	local dmg
	if dmginfo:IsDamageType(DMG_BUCKSHOT+DMG_SLASH) then dmg = dmginfo:GetDamage() * 2 else dmg = dmginfo:GetDamage() * 0.8 end

	ply.Bloodlosing = ply.Bloodlosing + dmg
end)

hook.Add("PlayerPostThink", "goarmslegs", function(ply)
	ply:SetNWBool("LeftLeg", ply.LeftLegbroke)
	ply:SetNWBool("RightLeg", ply.RightLegbroke)
	ply:SetNWBool("RightArm", ply.RightArmbroke)
	ply:SetNWBool("LeftArm", ply.LeftArmbroke)
end)

hook.Add("EntityTakeDamage","asdsdads",function(ent,dmginfo)
	--[[if ent and not ent.IsBleeding and dmginfo:IsDamageType(DMG_BULLET+DMG_SLASH+DMG_BLAST+DMG_ENERGYBEAM+DMG_NEVERGIB+DMG_ALWAYSGIB+DMG_PLASMA+DMG_AIRBOAT+DMG_SNIPER) then
		table.insert(BleedingEntities,ent)
		ent.bloodNext = CurTime()
		ent.Blood = ent.Blood or 5000--wtf
	end]]--
end)

local tr = {filter = {}}
local math_Clamp = math.Clamp

local util_TraceHull = util.TraceHull
local math_Rand = math.Rand
local util_Decal = util.Decal

util.AddNetworkString("info_blood")

function homigradPulse(ply)
	local heartstop = (ply.Blood + (ply.CPR or 0) + (math.min(ply.adrenaline * 500,1000) or 0)) < 2000
	heartstop = ply.Organs["heart"] == 0 or heartstop
	heartstop = ply.o2 <= 0 and true or heartstop
	local pulse = math.min(5000 / ply.Blood,5) - math.min(ply.adrenaline / 5,0.6) - math.min(100 / ply.stamina - 1,0.5)

	return pulse,heartstop
end

hook.Add("Player Think","homigrad-blood",function(ply,time)
	if not ply:Alive() or ply:HasGodMode() then return end
	ply.Organs = ply.Organs or {}

	local nextPulse,heartstop = homigradPulse(ply)

	ply.heartstop = heartstop
	ply.nextPulse = not heartstop and nextPulse or Lerp(0.1,(ply.nextPulse or 0),5)

	if (ply.CPRThink or 0) < time then
		ply.CPRThink = time + 1
		ply.CPR = math.max((ply.CPR or 0) - 5,0)
		ply.o2 = (ply.heartstop) and math.max((ply.o2 or 1) - 0.1,-3) or math.min((ply.o2 or 1) + 0.1,1)
	end

	local ent = IsValid(ply.fakeragdoll) and ply.fakeragdoll or ply

	local neck = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Neck1")):GetTranslation()
	
	if ply.Organs["artery"] == 0 and (ply.arteriaThink or 0) < time and ply.Blood > 0 then
		ply.arteriaThink = time + 0.1
		if not ply.holdingartery then
			ply.Blood = math.max(ply.Blood - 30,0)
			BloodParticleArtery(neck,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * math.Rand(40,110),ply)
		else
			ply.Blood = math.max(ply.Blood - 2,0)
			BloodParticleArtery(neck,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * 50,ply)
		end
	end

	local lhand = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_L_Forearm")):GetTranslation()
	if ply.LeftHandArtery == true and (ply.arteriaThinkLHand or 0) < time and ply.Blood > 0 and ply.LH_Gut == false then
		ply.arteriaThinkLHand = time + 0.15
		if not ply.holdingartery then
			ply.Blood = math.max(ply.Blood - 14,0)
			BloodParticleArtery(lhand,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * math.Rand(20,70),ply)
		else
			ply.Blood = math.max(ply.Blood - 6,0)
			BloodParticleArtery(lhand,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * 50,ply)
		end
	end

	local rhand = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_R_Forearm")):GetTranslation()
	if ply.RightHandArtery == true and (ply.arteriaThinkRHand or 0) < time and ply.Blood > 0 and ply.RH_Gut == false then
		ply.arteriaThinkRHand = time + 0.15
		if not ply.holdingartery then
			ply.Blood = math.max(ply.Blood - 14,0)
			BloodParticleArtery(rhand,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * math.Rand(20,70),ply)
		else
			ply.Blood = math.max(ply.Blood - 6,0)
			BloodParticleArtery(rhand,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * 50,ply)
		end
	end

	local lleg = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_L_Calf")):GetTranslation()
	if ply.LeftLegArtery == true and (ply.arteriaThinkLLeg or 0) < time and ply.Blood > 0 and ply.LL_Gut == false then
		ply.arteriaThinkLLeg = time + 0.15
		if not ply.holdingartery then
			ply.Blood = math.max(ply.Blood - 14,0)
			BloodParticleArtery(lleg,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * math.Rand(20,70),ply)
		else
			ply.Blood = math.max(ply.Blood - 6,0)
			BloodParticleArtery(lleg,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * 50,ply)
		end
	end

	local rleg = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_R_Calf")):GetTranslation()
	if ply.RightLegArtery == true and (ply.arteriaThinkRLeg or 0) < time and ply.Blood > 0 and ply.RL_Gut == false then
		ply.arteriaThinkRLeg = time + 0.12
		if not ply.holdingartery then
			ply.Blood = math.max(ply.Blood - 20,0)
			BloodParticleArtery(rleg,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * math.Rand(20,70),ply)
		else
			ply.Blood = math.max(ply.Blood - 15,0)
			BloodParticleArtery(rleg,ent:GetAttachment(ent:LookupAttachment("eyes")).Ang:Forward() * 50,ply)
		end
	end

	if ply.heartstop and (ply.brainDeathThink or 0) < time then
		ply.Organs["brain"] = math.max(ply.Organs["brain"] - 0.1,0)
		ply.brainDeathThink = time + 1
	end

	if ply.pulseStart + ply.nextPulse/4 > time then return end
	ply.pulseStart = time
	ply:EmitSound("snd_jack_hmcd_heartpound.wav",70,100,0.05 / ply.nextPulse,CHAN_AUTO)
	
	if ply.Bloodlosing > 0 then
		ply.Bloodlosing = ply.Bloodlosing - 0.5
		
		ply.Blood = math.max(ply.Blood - ply.Bloodlosing / 2,0)

		BloodParticle(ent:GetPos() + ent:OBBCenter(),VectorRand(-40,40))
	elseif ply.Blood < 5000 and not ply.heartstop then
		ply.Blood = ply.Blood + math.max(math.ceil(ply.hungryregen),1) * 10 + ply.adrenaline * math.Rand(20,70)
	end

	if ply.bloodNext > time then return end
	ply.bloodNext = time + 0.25

	net.Start("info_blood")
	net.WriteFloat(ply.Blood)
	net.Send(ply)
end)

local math_random = math.random
local CurTime = CurTime
local time

local tr = {}

local randVec = Vector(0,0,-1)

hook.Add("Think","homigrad-bleeding-ents",function()

	time = CurTime()

	for i,ent in pairs(BleedingEntities) do
		if not IsValid(ent) or ent:IsPlayer() or not ent.deadbody then continue end

		ent.bloodNext = ent.bloodNext or time
		if ent.bloodNext > time then continue end
		ent.bloodNext = time + 0.6
		BloodParticle(ent:GetPos() + ent:OBBCenter(),VectorRand(-15,15))

		ent.Blood = ent.Blood - 35
		if ent.Blood <= 0 then BleedingEntities[ent] = nil end
	end
end)

local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")

hook.Add("PlayerSpawn","homigrad-blood",function(ply)
	if PLYSPAWN_OVERRIDE then return end
	ply:ConCommand("-closeeye")
	ply.IsBleeding = false
	ply.Blood = 5000
	ply.mutejaw = false
	ply.Bloodlosing=0

	ply.stamina = 100
	ply.LeftLeg = 1
	ply.RightLeg = 1
	ply.RightArm = 1
	ply.LeftArm = 1
	ply.Attacker = nil
	ply.nopain = false
	ply.o2 = 1

	ply.holdbreath = false
	ply:SetNWBool("holdbreath", false)

	ply.broken_uspine = false
	ply.canup_leg = false
	ply.Blood = 5000
	ply.jaw = 1
	ply.heartstop = false
	ply.nextPulse = nil
	ply.Bloodlosing = 0
	ply.bloodtype = math.random(1,8)

	ply.upper_spine = 10
	ply.LeftLegbroke = false
	ply.RightLegbroke = false
	ply.Speed = 0
	ply:SetNWString("ModelSex", "what")
	ply.arterybloodlosing = 0
	ply.LeftHandArtery = false
	ply.RightHandArtery = false

	ply.LH_Gut = false
	ply.RH_Gut = false
	ply.LL_Gut = false
	ply.RL_Gut = false

	ply.pulseStart = 0

	ply:ConCommand("soundfade 0 1")

	ply.bloodNext = 0
end)

hook.Add("PlayerDeath","deathblood",function(ply)
	ply.Blood = 5000
	ply.Bloodlosing = 0
	ply.mutejaw = false
	ply.stamina = 100

	ply.LeftLeg = 1
	ply.RightLeg = 1
	ply.RightArm = 1
	ply.LeftArm = 1
	ply.o2 = 1

	ply.arterybleeding = nil

	ply.holdbreath = false
	ply:SetNWBool("holdbreath", false)

	ply.broken_uspine = false
	ply.upper_spine = 10
	ply.InternalBleeding = nil
	ply.InternalBleeding2 = nil
	ply.InternalBleeding3 = nil
	ply.InternalBleeding4 = nil
	ply.InternalBleeding5 = nil
	ply.brokenspine = false
	ply.canup_leg = false
	ply.LeftLegbroke = false
	ply.RightLegbroke = false
	ply.RightArmbroke = false
	ply.LeftArmbroke = false
	ply.jaw = 1
	ply:SetNWString("ModelSex", "what")

	ply:ConCommand("soundfade 0 1")
	--ply:SetDSP(0)

	net.Start("info_blood")
		net.WriteFloat(ply.Blood)
	net.Send(ply)
end)

hook.Add("PlayerSpawn", "pepsi", function(ply)
	ply.LeftLegbroke = false
	ply.RightLegbroke = false
	ply.RightArmbroke = false
	ply.LeftArmbroke = false
end)

hook.Add("PlayerPostThink", "ModelSexSyncwithNwInt", function(ply)
	if ply:GetNWString("ModelSex") == ply.ModelSex then return end
	
	if ply:GetNWString("ModelSex") != ply.ModelSex then
		ply:SetNWString("ModelSex", ply.ModelSex)
	end
end)

concommand.Add("checha_organisminfo", function(ply)
	print("LeftLeg: ", ply.LeftLeg)
	print("RightLeg: ", ply.RightLeg)
	print("-------------")
	print("RightArm: ", ply.RightArm)
	print("LeftArm: ", ply.LeftArm)
	print("------")
	print("UpperSpine: ", ply.broken_uspine)
end)

concommand.Add("checha_broke_rightarm", function(ply)
	ply.RightArm = 0
	ply.RightArmbroke = true
end)

concommand.Add("checha_broke_leftarm", function(ply)
	ply.LeftArm = 0
	ply.LeftArmbroke = true
end)

concommand.Add("checha_broke_rightleg", function(ply)
	ply.RightLeg = 0
end)

concommand.Add("checha_broke_leftleg", function(ply)
	ply.LeftLeg = 0
end)

hook.Add("PlayerPostThink", "FakingLeg", function(ply)
	if !ply.fake and ply.LeftLegbroke == true and ply.RightLegbroke == true then
		Faking(ply)
	end
end)

hook.Add("PlayerPostThink", "LegBroke", function(ply)
	if ply.LeftLeg <= 0 and ply.LeftLegbroke == false then
		ply.LeftLegbroke = true
	end
	if ply.RightLeg <= 0 and ply.RightLegbroke == false then
		ply.RightLegbroke = true
	end

	if ply.LeftArm <= 0 and ply.LeftArmbroke == false then
		ply.LeftArmbroke = true
	end
	if ply.RightArm <= 0 and ply.RightArmbroke == false then
		ply.RightArmbroke = true
	end
end)

hook.Add("PlayerPostThink", "LegFake", function(ply)
	if ply.canup_leg == false then
		if ply.LeftLegbroke == true and ply.RightLegbroke == true and !ply.fake then
			ply.canup_leg = true
			Faking(ply)
		end
	end
end)

hook.Add("EntityTakeDamage","van",function(ent,dmginfo)
	if ent:GetClass() == "sim_fphys_van" then
		dmginfo:ScaleDamage(0.13)
	end
end)

util.AddNetworkString("organism_info")

concommand.Add("hg_organisminfo",function(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	local huyply = args[1] and player.GetListByName(args[1])[1] or ply

	net.Start("organism_info")
	net.WriteTable(huyply.Organs)
	net.WriteString(
	"Кровь (мл): "..tostring(huyply.Blood).."\n"..
	"Кровотечение (мл/удар): "..tostring(huyply.Bloodlosing).."\n"..
	"СЛР: "..tostring(huyply.CPR).."\n"..
	"Боль: "..tostring(huyply.pain).."\n"..
	"Остановка сердца: "..tostring(huyply.heartstop).."\n"..
	"o2 (1 = полный запас кислорода): "..tostring(huyply.o2).."\n"..
	"Удары в минуту: "..tostring(huyply.heartstop and 0 or 1 / huyply.nextPulse * 60).."\n"..
	"Игрок: "..huyply:Name()
	)
	net.Send(ply)
end)

concommand.Add("hg_organism_setvalue",function(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	local huyply = args[3] and player.GetListByName(args[3])[1] or ply
	
	huyply.Organs[args[1]] = args[2]
end)

body_parts = {
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_L_Clavicle",
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_Neck1",
	"ValveBiped.Bip01_Head1"
}

hook.Add("EntityTakeDamage", "Take_Blood", function(target, dmg)
	local mul_bloodcoord0 = math.random(4,20)
	local mul_bloodcoord2 = math.random(1,30)
	local mul_bloodcoord3 = math.random(5,40)
	local venous_bloodpaint = {
    	"ChBlood1",
    	"ChBlood4"
	}
	local venous2_bloodpaint = {
    	"ChBlood4",
		"ChBlood3"
	}
	if target:IsPlayer() or target:IsNPC() or target:IsRagdoll() and dmg:IsDamageType(DMG_BULLET+DMG_SLASH) then
    	local handPos, handAng = target:GetBonePosition(target:LookupBone(table.Random(body_parts)))
    	local bloodPos = handPos + handAng:Forward() * mul_bloodcoord0
    	local bloodTrace = util.TraceLine({
        	start = bloodPos,
        	endpos = bloodPos - Vector(0, mul_bloodcoord2, mul_bloodcoord3),
        	filter = target
        })
    	if bloodTrace.Hit then
        	util.Decal(table.Random(venous_bloodpaint), bloodTrace.HitPos + bloodTrace.HitNormal, bloodTrace.HitPos - bloodTrace.HitNormal)
        	util.Decal(table.Random(venous2_bloodpaint), bloodTrace.HitPos + bloodTrace.HitNormal, bloodTrace.HitPos - bloodTrace.HitNormal)
        	util.Decal(table.Random(venous_bloodpaint), bloodTrace.HitPos + bloodTrace.HitNormal, bloodTrace.HitPos - bloodTrace.HitNormal)
        	util.Decal(table.Random(venous2_bloodpaint), bloodTrace.HitPos + bloodTrace.HitNormal, bloodTrace.HitPos - bloodTrace.HitNormal)
		end
	end
end)