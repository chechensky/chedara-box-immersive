local function GetFriends(play)
    
    local huy = ""

    for i, ply in pairs(homicide.t) do
        if play == ply then continue end
        huy = huy .. ply:Name() .. ", "
    end

    return huy
end

COMMANDS.homicide_get = {function(ply,args)
    if not ply:IsAdmin() then return end

    local role = {{},{}}

    for i,ply in pairs(team.GetPlayers(1)) do
        if ply.roleT then table.insert(role[1],ply) end
        if ply.roleCT then table.insert(role[2],ply) end
    end

    net.Start("homicide_roleget")
    net.WriteTable(role)
    net.Send(ply)
end}

local function makeT(ply)
    ply.roleT = true
    table.insert(homicide.t,ply)

    if homicide.roundType == 1 then
        ply:Give("weapon_kabar")
        local wep = ply:Give("weapon_sib_usp-s")

        ply:Give("weapon_hg_t_vxpoison")
        ply:Give("weapon_hidebomb")
        ply:Give("weapon_hg_type59")
        ply:Give("weapon_jam")
    elseif homicide.roundType == 2 then
        ply:Give("weapon_kabar")

        ply:Give("weapon_hg_t_kurarepoison")
        ply:Give("weapon_hg_t_syringepoison")
        ply:Give("weapon_hg_t_vxpoison")
        ply:Give("weapon_jam")
        ply:Give("weapon_trap")

        ply:Give("weapon_hidebomb")
        ply:Give("weapon_hg_type59")
    elseif homicide.roundType == 3 then
        ply:Give("weapon_kabar")

        ply:Give("weapon_hg_t_kurarepoison")
        ply:Give("weapon_hg_t_syringepoison")
        ply:Give("weapon_hg_t_vxpoison")
        ply:Give("weapon_hg_t_capsulecianid")
        
        ply:Give("weapon_hg_rgd5")
    elseif homicide.roundType == 5 then
        ply:Give("weapon_hidebomb")
        ply:Give("weapon_jahidka")
        ply:Give("weapon_hg_molotov")
        ply:Give("weapon_kabar")
        
        ply:Give("weapon_hg_rgd5")
        ply:Give("weapon_hg_type59")
        ply:Give("weapon_hg_f1")
        local skinpri = math.random(1, 5)
        print(skinpri)
        if skinpri == 2 then ply:SetModel("models/player/phoenix.mdl") end
    else
        ply:Give("weapon_kabar")

        ply:Give("weapon_hidebomb")
        ply:Give("weapon_hg_rgd5")
        ply:GiveAmmo(12,5)
    end

    timer.Simple(5,function() ply.allowFlashlights = true end)

    AddNotificate( ply,"You traitor.")

    if #GetFriends(ply) >= 1 then
        timer.Simple(1,function() AddNotificate( ply,"Your teammate: " .. GetFriends(ply)) end)
    end
end

local function makeCT(ply)
    ply.roleCT = true
    table.insert(homicide.ct,ply)
    if homicide.roundType == 1 then
        local wep = ply:Give("weapon_sib_remington870")
        AddNotificate( ply,"You are an innocent man with an oversized firearm.")
    elseif homicide.roundType == 2 then
        local wep = ply:Give("weapon_sib_glock")
        AddNotificate( ply,"You are an innocent man with a concealed firearm.")
    elseif homicide.roundType == 5 then
        local wep = ply:Give("weapon_sib_asval")
        local wep2 = ply:Give("weapon_sib_pl14")
        ply:GiveAmmo(40, wep:GetPrimaryAmmoType(), false)
        ply:GiveAmmo(28, wep2:GetPrimaryAmmoType(), false)
        JMod.EZ_Equip_Armor(ply,"Level-IIIA",Color(37,19,195))
        AddNotificate( ply,"You are an innocent man with a big firearm, kill jihader.")
    else

    end

end

function homicide.Spawns()
    local aviable = {}

    for i,ent in pairs(ents.FindByClass("info_player*")) do
        table.insert(aviable,ent:GetPos())
    end

    for i,ent in pairs(ents.FindByClass("info_node*")) do
        table.insert(aviable,ent:GetPos())
    end

    for i,point in pairs(ReadDataMap("spawnpointst")) do
        table.insert(aviable,point)
    end

    for i,point in pairs(ReadDataMap("spawnpointsct")) do
        table.insert(aviable,point)
    end

    return aviable
end

sound.Add({
	name = "police_arrive",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = "snd_jack_hmcd_policesiren.wav"
})

concommand.Add("checha_model", function(ply)
    ply:SetModel("models/player/hostage/hostage_01.mdl")
end)

concommand.Add("checha_getmodel", function(ply)
    print(ply:GetModel())
    print(ply.ModelSex)
end)

function homicide.StartRoundSV()
    tdm.RemoveItems()
    tdm.DirectOtherTeam(2,1,1)

    homicide.police = false
	roundTimeStart = CurTime()
	roundTime = math.max(math.ceil(#player.GetAll() / 2.5),1) * 60

    if homicide.roundType == 3 then
        roundTime = roundTime / 2
    end

    roundTimeLoot = 5

    for i,ply in pairs(team.GetPlayers(2)) do ply:SetTeam(1) end
    --for i,ply in pairs(team.GetPlayers(2)) do ply:SetTeam(1) end

    homicide.ct = {}
    homicide.t = {}

    local countT = 0
    local countCT = 0

    local aviable = homicide.Spawns()
    tdm.SpawnCommand(PlayersInGame(),aviable,function(ply)
        ply.roleT = false
        ply.roleCT = false
        if not (ply.CustomModel and ply.CustomColor and ply.CustomClothes) then
		    umsg.Start("SyncIdent", ply)
		    umsg.End()
	    end
        if homicide.roundType == 4 then
            timer.Simple(0,function()
                ply:Give("weapon_sib_deagle")
            end)
        end

        if ply.forceT then
            ply.forceT = nil
            countT = countT + 1

            makeT(ply)
        end

        if ply.forceCT then
            ply.forceCT = nil
            countCT = countCT + 1

            makeCT(ply)
        end
    end)

    local players = PlayersInGame()
    local count = math.max(math.random(1,math.ceil(#players / 16)),1) - countT
    for i = 1,count do
        local ply = table.Random(players)
        table.RemoveByValue(players,ply)

        makeT(ply)
    end

    local count = math.max(math.random(1,math.ceil(#players / 16)),1) - countCT

    for i = 1,count do
        local ply = table.Random(players)
        table.RemoveByValue(players,ply)

        if homicide.roundType <= 2 or homicide.roundType == 5 then
            makeCT(ply)
        end
    end

    timer.Simple(0,function()
        for i,ply in pairs(homicide.t) do
            if not IsValid(ply) then table.remove(homicide.t,i) continue end

            homicide.SyncRole(ply,1)
        end

        for i,ply in pairs(homicide.ct) do
            if not IsValid(ply) then table.remove(homicide.ct,i) continue end

            homicide.SyncRole(ply,2)
        end
    end)

    tdm.CenterInit()

    return {roundTimeLoot = roundTimeLoot}
end

local aviable = ReadDataMap("spawnpointsct")

function homicide.RoundEndCheck()
    tdm.Center()

	local TAlive = tdm.GetCountLive(homicide.t)
	local Alive = tdm.GetCountLive(team.GetPlayers(1),function(ply) if ply.roleT or ply.isContr then return false end end)

    if roundTimeStart + roundTime < CurTime() then
		if not homicide.police then
			homicide.police = true
            if homicide.roundType == 1 then
                PrintMessage(3,"SWAT coming..")
            else
                PrintMessage(3,"Police coming..")
            end

			local aviable = ReadDataMap("spawnpointsct")
            local ctPlayers = tdm.GetListMul(player.GetAll(),1,function(ply) return not ply:Alive() and not ply.roleT and ply:Team() ~= 1002 end)
			
            local playsound = true
            tdm.SpawnCommand(ctPlayers,aviable,function(ply)
                timer.Simple(0,function()
                    if homicide.roundType == 1 or homicide.roundType == 5 then
                        ply:SetPlayerClass("contr")
                    else
                        ply:SetPlayerClass("police")
                    end
                    if playsound then
                        ply:EmitSound("police_arrive")
                        playsound = false
                    end
                end)
            end)
			
		end
	end

	if TAlive == 0 and Alive == 0 then EndRound(1) return end

	if TAlive == 0 then EndRound(2) end
	if Alive == 0 then EndRound(1) end
end

function homicide.EndRound(winner)
    PrintMessage(3,(winner == 1 and "Win traitors." or winner == 2 and "Win innocent." or "Tie"))
    if homicide.t and #homicide.t > 0 then
        PrintMessage(3,#homicide.t > 1 and ("Traitors: " .. homicide.t[1]:Name() .. ", " .. GetFriends(homicide.t[1])) or ("Traitor: " .. homicide.t[1]:Name()))
    end
end

local empty = {}

local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")
function EntityMeta:IsUsingValidModel()
	local Mod = string.lower(self:GetModel())
	for key, maud in pairs(ModelsAppearance) do
		local ValidModel = string.lower(player_manager.TranslatePlayerModel(maud))
		if ValidModel == Mod then return true end
	end

	return false
end
function EntityMeta:SetAccessory(acc)
	if not acc then return end
	self.Accessory = acc
	local ent, sex = self, self.ModelSex -- delay to ensure the entity exists on the client
	timer.Simple(
		.1,
		function()
			net.Start("lutiiikol")
			net.WriteEntity(ent)
			net.WriteString(sex)
			net.WriteString(acc)
			net.Send(player.GetAll())
		end
	)
end

function EntityMeta:SetClothing(outfit)
	self:SetMaterial() -- reset
	self:SetSubMaterial() -- reset
	if not outfit then return end
	if not self:IsUsingValidModel() then return end
	self:SetSubMaterial(self.ClothingMatIndex, "models/humans/" .. self.ModelSex .. "/group01/" .. outfit)
	self.ClothingType = outfit
end

local Clothes = {"normal", "normal", "normal", "striped", "plaid", "casual", "formal", "young", "cold"} -- some styles are more common
function EntityMeta:GenerateClothes()
	local Type = table.Random(Clothes)
	if self.CustomClothes then
		Type = self.CustomClothes
	end

	self:SetSubMaterial() -- reset
	timer.Simple(
		.2,
		function()
			if IsValid(self) then
				self:SetClothing(Type)
			end
		end
	)
end

function EntityMeta:GenerateColor()
	local vec = Vector(math.Rand(0, 1), math.Rand(0, 1), math.Rand(0, 1))
	local Avg = (vec.x + vec.y + vec.z) / 3
	vec.x = Lerp(.2, vec.x, Avg) -- muted colors more common
	vec.y = Lerp(.2, vec.y, Avg)
	vec.z = Lerp(.2, vec.z, Avg)
	if self.CustomColor then
		vec = self.CustomColor
	end

	self:SetPlayerColor(vec)
end

function EntityMeta:GenerateAccessories()
	local AccTable = table.GetKeys(Acs)
	table.insert(AccTable, "eyeglasses") -- eyeglasses are the most common accessory
	table.insert(AccTable, "eyeglasses")
	table.insert(AccTable, "nerd glasses")
	local AccessoryName = table.Random(AccTable)
	if math.random(1, 3) == 2 then
		AccessoryName = "none"
	end

	if self.CustomAccessory then
		AccessoryName = self.CustomAccessory
	end

	self:SetAccessory(AccessoryName)
end

function GM:PlayerConnect(name, ip)
	timer.Simple(
		.1,
		function()
			for key, found in pairs(player.GetAll()) do
				if found:Nick() == name then
					umsg.Start("SyncIdent", found)
					umsg.End()
				end
			end
		end
	)
end

function GM:PlayerInitialSpawn(ply)
	if not (ply and IsValid(ply)) then return end
	timer.Simple(
		.1,
		function()
			if ply and IsValid(ply) then
				umsg.Start("SyncIdent", ply)
				umsg.End()
			end
		end
	)
end

function homicide.PlayerSpawn(ply,teamID)
    local teamTbl = homicide[homicide.teamEncoder[teamID]]
    local color = teamID == 1 and Color(math.random(55,165),math.random(55,165),math.random(55,165)) or teamTbl[2]
	ply:Give("weapon_hands")
    timer.Simple(0,function() ply.allowFlashlights = false end)
    
	local cl_playermodel, playerModel = ply:GetInfo("cl_playermodel"), table.Random(PlayerModelInfoTable)
	cl_playermodel = playerModel.model
	local modelname = player_manager.TranslatePlayerModel(cl_playermodel)

	if ply.CustomModel then
		for key, maudhayle in pairs(PlayerModelInfoTable) do
			if maudhayle.model == ply.CustomModel then
				playerModel = maudhayle
				break
			end
		end
	end

	cl_playermodel = playerModel.model
	local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
	util.PrecacheModel(modelname)
	ply:SetModel(modelname)
    print(table.ToString(playerModel))
	ply.ModelSex = playerModel.sex
	ply.ClothingMatIndex = playerModel.clothes
	ply:SetClothing("none")
	ply:SetBodygroup(1, 1)
	ply:SetBodygroup(2, math.random(0, 1))
	ply:SetBodygroup(3, math.random(0, 1))
	ply:SetBodygroup(4, math.random(0, 1))
	ply:SetBodygroup(5, math.random(0, 1))
    ply:GenerateClothes()
	ply:GenerateColor()
end

function homicide.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function homicide.PlayerCanJoinTeam(ply,teamID)
    if teamID == 2 or teamID == 3 then ply:ChatPrint("зачем") return false end
    return true
end

util.AddNetworkString("homicide_roleget")

function homicide.SyncRole(ply,teamID)
    local role = {{},{}}

    for i,ply in pairs(team.GetPlayers(1)) do
        if teamID ~= 2 and ply.roleT then table.insert(role[1],ply) end
        if teamID ~= 1 and ply.roleCT then table.insert(role[2],ply) end
    end

    net.Start("homicide_roleget")
    net.WriteTable(role)
    net.Send(ply)
end

function homicide.PlayerDeath(ply,inf,att) return false end

local common = {"item_food_water","attachment_suppressor_12","attachment_suppressor_9x19","item_food_pepsicola","item_food_meatstake","item_food_sandwick","adrenaline","item_food_burger","item_food_bigburger","weapon_sogknife","weapon_knife","med_band_small","medkit","med_band_big","tourniquet","tire"}
local uncommon = {"medkit","weapon_molotok","attachment_suppressor_ak","painkiller"}
local rare = {"weapon_sib_glock","weapon_sib_mr8013t","weapon_sib_mosin","weapon_gurkha","weapon_t","*ammo*"}

function homicide.ShouldSpawnLoot()
    if roundTimeStart + roundTimeLoot - CurTime() > 0 then return false end

    if homicide.roundType != 1 then
        local chance = math.random(100)
        if chance < 3 then
            return true,rare[math.random(#rare)],"legend"
        elseif chance < 20 then
            return true,uncommon[math.random(#uncommon)],"veryrare"
        elseif chance < 60 then
            return true,common[math.random(#common)],"common"
        else
            return false
        end
    else
        return true
    end
end

function homicide.ShouldDiscordOutput(ply,text)
    if ply:Team() ~= 1002 and ply:Alive() then return false end
end

function homicide.ShouldDiscordInput(ply,text)
    if not ply:IsAdmin() then return false end
end

function homicide.GuiltLogic(ply,att,dmgInfo)
    return ply.roleT == att.roleT
end