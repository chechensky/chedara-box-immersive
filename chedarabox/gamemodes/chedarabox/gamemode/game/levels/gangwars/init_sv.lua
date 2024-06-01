function gangwars.SpawnsTwoCommand()
	local spawnsT = ReadDataMap("spawnpointst")
	local spawnsCT = ReadDataMap("spawnpointsct")

	if #spawnsT == 0 then
		for i, ent in RandomPairs(ents.FindByClass("info_player_terrorist")) do
			table.insert(spawnsT,ent:GetPos())
		end
	end

	if #spawnsCT == 0 then
		for i, ent in RandomPairs(ents.FindByClass("info_player_counterterrorist")) do
			table.insert(spawnsCT,ent:GetPos())
		end
	end

	return spawnsT,spawnsCT
end

function gangwars.SpawnCommand(tbl,aviable,func,funcShould)
	for i,ply in RandomPairs(tbl) do
		if funcShould and funcShould(ply) ~= nil then continue end

		if ply:Alive() then ply:KillSilent() end

		if func then func(ply) end

		ply:Spawn()
		ply.allowFlashlights = true

		local point,key = table.Random(aviable)
		point = ReadPoint(point)
		if not point then continue end

		ply:SetPos(point[1])
		if #aviable > 1 then table.remove(aviable,key) end
	end
end

function gangwars.DirectOtherTeam(start,min,max)
	if not max then max = min end

	for i = start,team.MaxTeams do
		for i,ply in pairs(team.GetPlayers(i)) do
			ply:SetTeam(math.random(min,max))
		end
	end
end

function gangwars.GetListMul(list,mul,func,max)
	local newList = {}
	mul = math.Round(#list * mul)
	if max then mul = math.max(mul,max) end

	for i = 1,mul do
		local ply,key = table.Random(list)
		list[key] = nil

		if func and func(ply) ~= true then continue end

		newList[#newList + 1] = ply
	end

	return newList
end

changeClass = {
	["prop_vehicle_jeep"]="vehicle_van",
	["prop_vehcle_jeep_old"]="vehicle_van",
	["prop_vehicle_airboat"]="vehicle_van",
	["weapon_crowbar"]="weapon_bat",
	["weapon_stunstick"]="weapon_knife",
	["weapon_pistol"]="weapon_glock",
	["weapon_357"]="weapon_deagle",
	["weapon_shotgun"]="weapon_remington870",
	--["weapon_crossbow"]="weapon_kar98k",
	["weapon_ar2"]="weapon_ar15",
	["weapon_smg1"]="weapon_ar15",
	["weapon_frag"]="weapon_hg_f1",
	["weapon_slam"]="weapon_hg_molotov",

	["weapon_rpg"]="ent_ammo_46x30mm",
	["item_ammo_ar2_altfire"]="ent_ammo_762x39mm",
	["item_ammo_357"]="ent_ammo_.44magnum",
	["item_ammo_357_large"]="ent_ammo_.44magnum",
	["item_ammo_pistol"]="ent_ammo_9х19mm",
	["item_ammo_pistol_large"]="ent_ammo_9х19mm",
	["item_ammo_ar2"]="ent_ammo_556x45mm",
	["item_ammo_ar2_large"]="ent_ammo_556x45mm",
	["item_ammo_ar2_smg1"]="ent_ammo_545x39mm",
	["item_ammo_ar2_large"]="ent_ammo_556x45mm",
	["item_ammo_smg1"]="ent_ammo_545x39mm",
	["item_ammo_smg1_large"]="ent_ammo_762x39mm",
	["item_box_buckshot"]="ent_ammo_12/70gauge",
	["item_box_buckshot_large"]="ent_ammo_12/70gauge",
	["item_rpg_round"]="ent_ammo_57x28mm",
	["item_ammo_crate"]="ent_ammo_9x39mm",

	["item_healthvial"]="med_band_small",
	["item_healthkit"]="med_band_big",
	["item_healthcharger"]="medkit",
	["item_suitcharger"]="painkiller",
	["item_battery"]="blood_bag",
	["weapon_alyxgun"]={"food_fishcan","food_lays","food_monster","food_spongebob_home"}
}

function gangwars.RemoveItems()
	for i,ent in pairs(ents.GetAll()) do
		if ent:GetName() == "biboran" then
			ent:Remove()
		end
	end
end

function gangwars.StartRoundSV()
    gangwars.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 60 * (2 + math.min(#player.GetAll() / 8,2))

	for i,ply in pairs(team.GetPlayers(3)) do ply:SetTeam(math.random(1,2)) end

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT,spawnsCT = gangwars.SpawnsTwoCommand()
	gangwars.SpawnCommand(team.GetPlayers(1),spawnsT)
	gangwars.SpawnCommand(team.GetPlayers(2),spawnsCT)

	gangwars.CenterInit()
end

function gangwars.GetCountLive(list,func)
	local count = 0
	local result

	for i,ply in pairs(list) do
		if not IsValid(ply) then continue end

		result = func and func(ply)
		if result == true then count = count + 1 continue elseif result == false then continue end
		if not PlayerIsCuffs(ply) and ply:Alive() then count = count + 1 end
	end

	return count
end

function gangwars.RoundEndCheck()
	gangwars.Center()

	local TAlive = gangwars.GetCountLive(team.GetPlayers(1))
	local CTAlive = gangwars.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 0 then EndRound() return end

	if TAlive == 0 then EndRound(2) end
	if CTAlive == 0 then EndRound(1) end
end

function gangwars.EndRoundMessage(winner,textNobody)
	local tbl = TableRound()
	PrintMessage(3,"Win - " .. ((winner == 1 and tbl.red[1]) or (winner == 2 and tbl.blue[1]) or (textNobody or "Friends")) .. ".")
end

function gangwars.EndRound(winner) gangwars.EndRoundMessage(winner) end

--

function gangwars.GiveSwep(ply,list,mulClip1)
	if not list then return end

	local wep = ply:Give(type(list) == "table" and list[math.random(#list)] or list)

	mulClip1 = mulClip1 or 3

    if IsValid(wep) then
        wep:SetClip1(wep:GetMaxClip1())
	    ply:GiveAmmo(wep:GetMaxClip1() * mulClip1,wep:GetPrimaryAmmoType())
    end
end

function gangwars.PlayerSpawn(ply,teamID)
	local teamTbl = gangwars[gangwars.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    if ply:Team() == 2 then ply:SetPlayerColor(color:ToVector()) end

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	gangwars.GiveSwep(ply,teamTbl.main_weapon)
	gangwars.GiveSwep(ply,teamTbl.secondary_weapon)

	if math.random(1,4) == 4 then ply:Give("adrenaline") end

	if math.random(1,4) == 4 then ply:Give("morphine") end


	--local r = math.random(1,3)
	--ply:Give(r == 1 and "food_fishcan" or r == 2 and "food_spongebob_home" or r == 3 and "food_lays")

	if ply:Team() == 2 then
		JMod.EZ_Equip_Armor(ply,"Level-IIIA")
	end
end

function gangwars.PlayerInitialSpawn(ply) ply:SetTeam(math.random(2)) end

function gangwars.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("зачем") return false end
end

function gangwars.PlayerDeath(ply,inf,att) return false end