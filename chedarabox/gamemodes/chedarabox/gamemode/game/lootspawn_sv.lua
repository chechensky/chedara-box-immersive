KOROBKA_HUYNYI={
	"models/props_junk/cardboard_box001a.mdl",
	"models/props_junk/cardboard_box001b.mdl",
	"models/props_junk/cardboard_box002a.mdl",
	"models/props_junk/cardboard_box002b.mdl",
	"models/props_junk/cardboard_box003a.mdl",
	"models/props_junk/cardboard_box003b.mdl",
	"models/props_junk/wood_crate001a.mdl",
	"models/props_junk/wood_crate001a_damaged.mdl",
	"models/props_junk/wood_crate001a_damagedmax.mdl",
	"models/props_junk/wood_crate002a.mdl",
	"models/props_c17/furnituredrawer001a.mdl",
	"models/props_c17/furnituredrawer003a.mdl",
	"models/props_c17/furnituredresser001a.mdl",
	"models/props_c17/woodbarrel001.mdl",
	"models/props_lab/dogobject_wood_crate001a_damagedmax.mdl",
	"models/items/item_item_crate.mdl",
	"models/props/de_inferno/claypot02.mdl",
	"models/props/de_inferno/claypot01.mdl",
	"models/props_junk/wood_crate001a_half.mdl",
	"models/props_junk/wood_crate002a_half.mdl",
	"models/props_junk/wood_crate003a.mdl",
	"models/props_c17/furnituredrawer001c.mdl",
	"models/props_wasteland/controlroom_filecabinet002a.mdl",
	"models/props_wasteland/controlroom_storagecloset001a.mdl",
	"models/props_c17/oildrum001.mdl",
	"models/props_interiors/Furniture_chair03a.mdl",
	"models/props_wasteland/controlroom_chair001a.mdl",
	"models/props_junk/gascan001a.mdl",
	"models/props_junk/MetalBucket02a.mdl",
	"models/props_c17/furnituredrawer002a.mdl",
	"models/props_interiors/furniture_cabinetdrawer02a.mdl",
	"models/props_c17/furniturecupboard001a.mdl",
	"models/props_interiors/furniture_desk01a.mdl",
	"models/props_interiors/furniture_vanity01a.mdl"
}

local newTbl = {}
for i,mdl in pairs(KOROBKA_HUYNYI) do newTbl[mdl] = true end

weaponscommon = {
	"item_food_water",
	"item_food_pepsicola",
	"item_food_meatstake",
	"item_food_sandwick",
	"adrenaline",
	"item_food_burger",
	"item_food_bigburger",
	"weapon_sogknife",
	"weapon_knife",
	"med_band_small",
	"medkit",
	"med_band_big",
	"tourniquet",
	"tire",
	"attachment_suppressor_9x19",
	"attachment_suppressor_ak",
	"attachment_suppressor_12",
	"attachment_sight_okp7",
	"attachment_sight_eotech553",
	"attachment_sight_leupoldmark4",
	"attachment_sight_pso1m2",
}

weaponsuncommon = {
	"medkit",
	"weapon_molotok",
	"painkiller",
	"weapon_trap",
	"antidot"
}

weaponsrare = {
	"weapon_sib_glock",
	"weapon_sib_mr8013t",
	"weapon_gurkha",
	"weapon_t",
	"*ammo*"
}

weaponsveryrare = {
	"weapon_sib_mosin"
}

weaponslegendary = {
	"weapon_sib_asval",
	"weapon_sib_xm1014",
	"weapon_sib_remington870",
	"weapon_sib_m4a1",
	"weapon_sib_rpk",
	"weapon_sib_akm"
}

local sndsDrop = {
	common = "homigrad/vgui/item_drop1_common.wav",
	uncommon = "homigrad/vgui/item_drop2_uncommon.wav",
	rare = "homigrad/vgui/item_drop3_rare.wav",
	veryrare = "homigrad/vgui/item_drop4_mythical.wav",
	legend = "homigrad/vgui/item_drop6_ancient.wav"
}

local ammos = {
	"ent_ammo_.44magnum",
	"ent_ammo_12/70gauge",
	"ent_ammo_762x39mm",
	"ent_ammo_556x45mm",
	"ent_ammo_9х19mm"
}

hook.Add("PropBreak","homigrad",function(att,ent)
	if not newTbl[ent:GetModel()] then return end

	local func = TableRound().ShouldSpawnLoot
	if not func then return end
	
	local result,spawnEnt,type1 = TableRound().ShouldSpawnLoot()
	if result == false then return end

	local posSpawn = ent:GetPos() + ent:OBBCenter()

	local huy,type1

	if type(spawnEnt) ~= "string" then
		local gunchance = math.random(0,100)
		local entName

		if gunchance < 2 then
			entName = table.Random(weaponslegendary)
			type1 = "legend"
		elseif gunchance < 5 then
			entName = table.Random(weaponsveryrare)
			type1 = "veryrare"
		elseif gunchance < 15 then
			entName = table.Random(weaponsrare)
			type1 = "rare"
		elseif gunchance < 35 then
			entName = table.Random(weaponsuncommon)
			type1 = "uncommon"
		elseif gunchance < 55 then
			entName = table.Random(weaponscommon)
			type1 = "common"
		end

		if entName then
			if math.random(1,1000) == 1000 then
				for i = 1,math.random(3,4) do
					local huy = ents.Create("ent_jack_gmod_ezcheese")
					huy:SetPos(posSpawn)
					huy:Spawn()
					hut:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				end

				local huy = ents.Create("weapon_physgun")
				huy:SetPos(posSpawn)
				huy:Spawn()

				return
			end

			if entName == "*ammo*" then
				if IsValid(att) then
					for i,wep in RandomPairs(att:GetWeapons()) do
						if wep:GetMaxClip1() > 0 then
							entName = "item_ammo_" .. string.lower(game.GetAmmoName(wep:GetPrimaryAmmoType()))

							break
						end
					end

					huy = ents.Create(entName)
					if not IsValid(huy) then
						entName = table.Random(ammos)
					end
				else
					entName = table.Random(ammos)
					huy = ents.Create(entName)
				end
			else
				huy = ents.Create(entName)
			end

			if not IsValid(huy) then return end

			huy:SetPos(posSpawn)
			huy:Spawn()
			huy.Spawned = true
		end
	else
		huy = ents.Create(spawnEnt)
		if not IsValid(huy) then return end

		huy:SetPos(posSpawn)
		huy:Spawn()
		huy.Spawned = true
	end
end)

local spawns = {}

for i, ent in pairs(ents.FindByClass("info_*")) do
	table.insert(spawns,ent:GetPos())
end

local hook_Run = hook.Run
hook.Add("PostCleanupMap","addboxs",function()
	spawns = {}
	for i, ent in pairs(ents.FindByClass("info_*")) do
		table.insert(spawns,ent:GetPos())
	end
	if timer.Exists("SpawnTheBoxes") then timer.Remove("SpawnTheBoxes") end

	timer.Create("SpawnTheBoxes", 10, 0 ,function()
		hook_Run("Boxes Think")
	end)--lol4ik?
end)--насрал, сожри

if timer.Exists("SpawnTheBoxes") then timer.Remove("SpawnTheBoxes") end
timer.Create("SpawnTheBoxes", 10, 0 ,function()
	hook_Run("Boxes Think")
end)

local function randomLoot()
	local gunchance = math.random(1,100)
	
	local entName = false
	if gunchance < 2 then
		entName = table.Random(weaponslegendary)
	elseif gunchance < 5 then
		entName = table.Random(weaponsveryrare)
	elseif gunchance < 15 then
		entName = table.Random(weaponsrare)
	elseif gunchance < 35 then
		entName = table.Random(weaponsuncommon)
	elseif gunchance < 55 then
		entName = table.Random(weaponscommon)
	end

	local func = TableRound().ShouldSpawnLoot
	local should,entNamer
	if func then
		should, entNamer = func()
	end

	entName = should and entNamer or entName
	return entName
end

local vec = Vector(0,0,32)
hook.Add("Boxes Think", "SpawnBoxes",function()
	if #player.GetAll() == 0 or not roundActive then return end
	
	local func = TableRound().ShouldSpawnLoot
	if func and func() == false then return end


	local randomWep = randomLoot()
	local ent = ents.Create(not randomWep and "prop_physics" or randomWep)

	if not randomWep then
		ent:SetModel(KOROBKA_HUYNYI[math.random(#KOROBKA_HUYNYI)])
	else
		ent.Spawned = true
	end
	if IsValid(ent) then
		ent:SetPos(spawns[math.random(#spawns)] + vec)
		ent:Spawn()
	end
end)