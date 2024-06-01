function survival.SpawnsTwoCommand()
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

function survival.SpawnCommand(tbl,aviable,func,funcShould)
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

function survival.DirectOtherTeam(start,min,max)
	if not max then max = min end

	for i = start,team.MaxTeams do
		for i,ply in pairs(team.GetPlayers(i)) do
			ply:SetTeam(math.random(min,max))
		end
	end
end

function survival.GetListMul(list,mul,func,max)
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

function survival.RemoveItems()
	for i,ent in pairs(ents.GetAll()) do
		if ent:GetName() == "biboran" then
			ent:Remove()
		end
	end
end

function survival.StartRoundSV()
    survival.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 180 * (2 + math.min(#player.GetAll() / 8,2))

	for i,ply in pairs(team.GetPlayers(3)) do ply:SetTeam(math.random(1,2)) end

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT,spawnsCT = survival.SpawnsTwoCommand()
	survival.SpawnCommand(team.GetPlayers(1),spawnsT)
	survival.SpawnCommand(team.GetPlayers(2),spawnsCT)

	survival.CenterInit()
end

function survival.GetCountLive(list,func)
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

function survival.RoundEndCheck()
	survival.Center()

	local TAlive = survival.GetCountLive(team.GetPlayers(1))
	local CTAlive = survival.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 0 then EndRound() return end

	if TAlive == 0 then EndRound(2) end
	if CTAlive == 0 then EndRound(1) end
end

function survival.EndRoundMessage(winner,textNobody)
	local tbl = TableRound()
	PrintMessage(3,"Win - " .. ((winner == 1 and tbl.red[1]) or (winner == 2 and tbl.blue[1]) or (textNobody or "Friends")) .. ".")
end

function survival.EndRound(winner) survival.EndRoundMessage(winner) end

--

function survival.GiveSwep(ply,list,mulClip1)
	if not list then return end

	local wep = ply:Give(type(list) == "table" and list[math.random(#list)] or list)

	mulClip1 = mulClip1 or 3

    if IsValid(wep) then
        wep:SetClip1(wep:GetMaxClip1())
	    ply:GiveAmmo(wep:GetMaxClip1() * mulClip1,wep:GetPrimaryAmmoType())
    end
end


local common = {"item_food_water","item_food_pepsicola","item_food_meatstake","item_food_sandwick","adrenaline","item_food_burger","item_food_bigburger","weapon_sogknife","weapon_knife","med_band_small","medkit","med_band_big","tourniquet","tire","attachment_suppressor_9x19",
	"attachment_suppressor_ak",
	"attachment_suppressor_12",
	"attachment_sight_okp7",
	"attachment_sight_eotech553",
	"attachment_sight_leupoldmark4",
	"attachment_sight_pso1m2",}
local uncommon = {"medkit","weapon_molotok","painkiller"}
local rare = {"weapon_sib_glock","weapon_sib_mr8013t","weapon_sib_mosin","weapon_gurkha","weapon_t","*ammo*"}

function survival.ShouldSpawnLoot()
    if roundTimeStart + roundTimeLoot - CurTime() > 0 then return false end
    local chance = math.random(100)
    if chance < 2 then
        return true,rare[math.random(#rare)],"legend"
    elseif chance < 40 then
        return true,uncommon[math.random(#uncommon)],"veryrare"
    elseif chance < 60 then
        return true,common[math.random(#common)],"common"
    else
        return false
    end
end

function survival.PlayerSpawn(ply,teamID)
	local teamTbl = survival[survival.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models)
    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	survival.GiveSwep(ply,teamTbl.main_weapon)
	survival.GiveSwep(ply,teamTbl.secondary_weapon)
end

function survival.PlayerInitialSpawn(ply) ply:SetTeam(math.random(2)) end

function survival.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("зачем") return false end
end

function survival.PlayerDeath(ply,inf,att) return false end