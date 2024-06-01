COMMANDS = COMMANDS or {}

local syncpenis = CreateConVar("sync_death", "0", FCVAR_ARCHIVE, "Sync death. Death = Spectator.")
local spalka_func = CreateConVar("spalka", "0", FCVAR_ARCHIVE, "Enable or Disable func Spalka.")

vzdoh_female = {}
vzdoh_male = {}

vidoh_female = {}
vidoh_male = {}
krehtit = {}
for i = 1,5 do table.insert(vzdoh_female,"breathing/inhale/female/inhale_0" .. i .. ".wav") end
for i = 1,4 do table.insert(vzdoh_male,"breathing/inhale/male/inhale_0" .. i .. ".wav") end
for i = 1,13 do table.insert(krehtit,"breathing/agonalbreathing_" .. i .. ".wav") end

for i = 1,5 do table.insert(vidoh_female,"breathing/exhale/female/exhale_0" .. i .. ".wav") end
for i = 1,5 do table.insert(vidoh_male,"breathing/exhale/male/exhale_0" .. i .. ".wav") end

local explosions = {
    ["models/props_junk/gascan001a.mdl"] = true,
	["models/props_junk/propane_tank001a.mdl"] = true,
	["models/props_junk/PropaneCanister001a.mdl"] = true,
    ["models/props_c17/oildrum001_explosive.mdl"] = true,
    ["models/props_junk/metalgascan.mdl"] = true,
    ["models/props_c17/canister02a.mdl"] = true,
    ["models/props_c17/canister01a.mdl"] = true,
    ["models/props_c17/oildrum001.mdl"] = true
}
dev = GetConVar("developer")

concommand.Add("checha_getskill", function(ply)
    print("Var default: ", ply.skill)
    print("Var network: ", ply:GetNWFloat("Skill"))
end)

concommand.Add("checha_downskill", function(ply)
    if ply.skill >= 1 then
        ply.skill = ply.skill - 1
    end
end)

concommand.Add("checha_upskill", function(ply)
    if ply.skill <= 10 then
        ply.skill = ply.skill + 1
    end
end)

hook.Add("PlayerDeath", "SkillUp_Kill", function(vic, inf, attacker)
    if attacker != vic and attacker:IsPlayer() and vic:IsPlayer() and IsValid(attacker) then
        local skillup = math.Rand(0.1,1)
        local skilldown = math.Rand(0.1,0.4)
        if attacker.skill <= 10 then
            attacker.skill = attacker.skill + skillup
            if attacker.skill >= 10 then
                attacker.skill = 10
            end
        end
        if vic.skill >= 0.4 then
            vic.skill = vic.skill - skilldown
        end
        if dev:GetInt() == 1 then
            print(skillup)
        end
    end
end)

hook.Add("PlayerInitialSpawn", "SkillSpawn", function(ply)
    local skilladd = math.Rand(1, 10)
    ply.skill = skilladd
    print("initial")
    if dev:GetInt() == 1 then
        print(ply.skill)
    end
end)

hook.Add("PlayerPostThink", "SkillLOL", function(ply)
    ply:SetNWFloat("Skill", ply.skill)
end)

local function BoomSmall(ent)
    local SelfPos,PowerMult = ent:LocalToWorld(ent:OBBCenter()),2

    timer.Simple(math.Rand(0,.1),function()
        ParticleEffect("pcf_jack_groundsplode_small",SelfPos,vector_up:Angle())
        util.ScreenShake(SelfPos,99999,99999,1,3000)
        sound.Play("BaseExplosionEffect.Sound", SelfPos,120,math.random(130,160))

        for i = 1,4 do
            sound.Play("explosions/doi_ty_01_close.wav",SelfPos,140,math.random(140,160))
        end

        timer.Simple(.1,function()
            for i = 1, 5 do
                local Tr = util.QuickTrace(SelfPos, VectorRand() * 20)

                if Tr.Hit then
                    util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
                end
            end
        end)

        JMod.WreckBuildings(ent, SelfPos, PowerMult/2)
        JMod.BlastDoors(ent, SelfPos, PowerMult)

		for i = 1, 3 do
			local FireVec = ( VectorRand() * .3 + Vector(0, 0, .3)):GetNormalized()
			FireVec.z = FireVec.z / 2
			local Flame = ents.Create("ent_jack_gmod_eznapalm")
			Flame:SetPos(SelfPos + Vector(0, 0, 50))
			Flame:SetAngles(FireVec:Angle())
			Flame:SetOwner(game.GetWorld())
			JMod.SetOwner(Flame, game.GetWorld())
			Flame.SpeedMul = 0.25
			Flame.Creator = game.GetWorld()
			Flame.HighVisuals = true
			Flame:Spawn()
			Flame:Activate()
		end

        timer.Simple(0,function()
            local ZaWarudo = game.GetWorld()
            local Infl, Att = (IsValid(ent) and ent) or ZaWarudo, (IsValid(ent) and IsValid(ent.Owner) and ent.Owner) or (IsValid(ent) and ent) or ZaWarudo
            util.BlastDamage(Infl,Att,SelfPos,120 * PowerMult,120 * PowerMult)

            util.BlastDamage(Infl,Att,SelfPos,20 * PowerMult,1000 * PowerMult)
        end)
    end)
end

concommand.Add("+changeattack", function(ply)
    local wep = ply:GetActiveWeapon()
    if wep.type_attack == 1 or wep.type_attack == 2 then
    	if wep.type_attack == 1 then
		    ply:ChatPrint("Вы изменили тип атаки на - резать.")
		    wep.type_attack = 2
            wep:SetHoldType("melee")
	    return end
	    if wep.type_attack == 2 then
		    ply:ChatPrint("Вы изменили тип атаки на - тыкать.")
		    wep.type_attack = 1
            wep:SetHoldType("knife")
	    end
    end
end)

hook.Add("PlayerSpawn","kekcheko",function(ply)
    ply.idleanim = false
    ply.poisoneda = false
    ply:SetNWBool("IdleAnimation", false)
end)

concommand.Add("+changeposition", function(ply)
    if ply.fake then return end
    local wep = ply:GetActiveWeapon()
    local gunInfo = weapons.Get(ply:GetActiveWeapon():GetClass())
    wep.Sightded = wep:GetNWBool("Sighted")
    if wep.Base == "salat_base" then
        if !wep.Sightded then
            print(ply.idleanim)
            if ply.idleanim or ply:GetNWBool("IdleAnimation", false) then
                ply.idleanim = false
                ply:SetNWBool("IdleAnimation", false)
            return end
            if !ply.idleanim or !ply:GetNWBool("IdleAnimation", false) then
                ply.idleanim = true
                ply:SetNWBool("IdleAnimation", true)
            return end
        return end
        if wep.Category == "Chedara Box - Пулемёты" then
            ply:ChatPrint("У пулеметов нельзя менять позицию.")
        return end
        if wep.Category == "Chedara Box - Пистолеты" then
            if wep:GetHoldType() == "revolver" then
                wep:SetHoldType("pistol")
                wep.holdnow = "pistol"
                gunInfo.Primary.Spread = gunInfo.Primary.Spread + 5
            return end
            if wep:GetHoldType() == "pistol" then
                wep:SetHoldType("revolver")
                wep.holdnow = "revolver"
                gunInfo.Primary.Spread = 0
            return end
        return end
        if wep.Category == "Chedara Box - Марксманские винтовки" or wep.Category == "Chedara Box - Винтовки" or wep.Category == "Chedara Box - Пистолеты-пулемёты" or wep.Category == "Chedara Box - Дробовики" then
            if wep:GetHoldType() == "ar2" then
                wep:SetHoldType("smg")
            return end
            if wep:GetHoldType() == "smg" then
                wep:SetHoldType("revolver")
            return end
            if wep:GetHoldType() == "revolver" then
                wep:SetHoldType("rpg")
            return end
            if wep:GetHoldType() == "rpg" then
                wep:SetHoldType("ar2")
            return end
        return end
    end
end)

hook.Add("PlayerSpawn", "KKPrint", function(ply)
    ply.messagedushit = true
end)

hook.Add( "EntityTakeDamage", "KurareHit", function( ply, dmginfo )
    local attacker = dmginfo:GetAttacker()
    if attacker and IsValid(attacker) and attacker:IsPlayer() then
        local weapon = attacker:GetActiveWeapon()
        if IsValid(weapon) and dmginfo:GetAttacker():GetActiveWeapon().kurare == true then
            ply.otravlen2 = true
            timer.Create("Kurare"..ply:EntIndex().."12", 30, 1, function()
                if ply:Alive() and ply.otravlen2 then
                    ply:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav",60)
                end

                timer.Create( "Kurare"..ply:EntIndex().."22", 10, 1, function()
                    if ply:Alive() and ply.otravlen2 then
                        ply:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav",60)
                    end
                end)

                timer.Create( "Kurare"..ply:EntIndex().."32", 15, 1, function()
                    if ply:Alive() and ply.otravlen2 then
                        ply.KillReason = "poison"
                        ply:Kill()
                    end
                end)
            end)
        end
    end
end )

hook.Add( "EntityTakeDamage", "EntityDamageExample", function( target, dmginfo )
    if explosions[target:GetModel()] then
        local r = math.random(1,55)
        if dmginfo:IsDamageType(DMG_GENERIC+DMG_SLASH+DMG_CLUB+DMG_BULLET+DMG_CRUSH) then
            dmginfo:SetDamage( 0 )
        elseif dmginfo:IsDamageType(DMG_BURN) and r == 55 then
            BoomSmall(target)
            target:Remove()
        elseif dmginfo:IsDamageType(DMG_BLAST) then
            BoomSmall(target)
            target:Remove()
        end
    end 
end )

COMMANDS.arm = {function(ply,args)
	if not ply:IsAdmin() then return end
    ply:GetEyeTrace().Entity:Arm()
    ply:GetEyeTrace().Entity:Activate()
end,1}

hook.Add("PlayerLoadout", "LoadOut", function(ply)
    ply:Give( "weapon_hands" )
    ply:SelectWeapon( "weapon_hands" )
    ply:SetHealth(150)
    return false
end)


hook.Add("PlayerCanPickupWeapon","PlayerManualPickup",function(ply,wep)
	local allow = false
	if wep.Spawned then
		local vec = ply:EyeAngles():Forward()
		local vec2 = (wep:GetPos() - ply:EyePos()):Angle():Forward()
	
		if vec:Dot(vec2) > 0.8 and not ply:HasWeapon(wep:GetClass()) then
			if ply:KeyDown(IN_USE) then
				allow = true
			end
		end
	else
		allow = true
	end
	
	if allow then
		return true
	end

	return false
end)

hook.Add("CanDrive","AntiDriveRewrite",function( p, e )
		p:ChatPrint("Неа...")
		return false
end)
male_playermodels = {
    "models/player/barney.mdl",
    "models/player/breen.mdl",
    "models/player/charple.mdl",
    "models/player/combine_soldier.mdl",
    "models/player/combine_super_soldier.mdl",
    "models/player/combine_soldier_prisonguard.mdl",
    "models/player/corpse1.mdl",
    "models/player/arctic.mdl",
    "models/player/gasmask.mdl",
    "models/player/guerilla.mdl",
    "models/player/leet.mdl",
    "models/player/phoenix.mdl",
    "models/player/riot.mdl",
    "models/player/swat.mdl",
    "models/player/urban.mdl",
    "models/player/dod_american.mdl",
    "models/player/eli.mdl",
    "models/player/gman_high.mdl",
    "models/player/hostage/hostage_01.mdl",
    "models/player/hostage/hostage_02.mdl",
    "models/player/hostage/hostage_03.mdl",
    "models/player/hostage/hostage_04.mdl",
    "models/player/kleiner.mdl",
    "models/player/magnusson.mdl",
    "models/player/Group01/male_01.mdl",
    "models/player/Group01/male_02.mdl",
    "models/player/Group01/male_03.mdl",
    "models/player/Group01/male_04.mdl",
    "models/player/Group01/male_05.mdl",
    "models/player/Group01/male_06.mdl",
    "models/player/Group01/male_07.mdl",
    "models/player/Group01/male_08.mdl",
    "models/player/Group01/male_09.mdl",
    "models/player/Group03m/male_05.mdl",
    "models/player/Group03m/male_06.mdl",
    "models/player/Group03m/male_07.mdl",
    "models/player/Group03m/male_08.mdl",
    "models/player/Group03m/male_09.mdl",
    "models/player/monk.mdl",
    "models/player/odessa.mdl",
    "models/player/police.mdl",
    "models/player/Group02/male_02.mdl",
    "models/player/Group02/male_04.mdl",
    "models/player/Group02/male_06.mdl",
    "models/player/Group02/male_08.mdl",
    "models/player/soldier_stripped.mdl"
}

concommand.Add("hold_breath", function(ply)
    if not ply:Alive() then return end
	ply.fakeragdoll = ply:GetNWEntity("Ragdoll")
	local rag = ply.fakeragdoll
    local breath = ply.holdbreath
    local model = ply:GetModel()

    if !ply.holdbreath and !ply.Otrub then
        ply:ChatPrint("Вы задержали дыхание.")
        ply.holdbreath = true
        ply:SetNWBool("holdbreath", true)
        if ply.ModelSex == "male" then 
            ply:EmitSound(table.Random(vzdoh_male), 75, 100, 5, CHAN_AUTO)
        end
        if ply.ModelSex == "female" then   
            ply:EmitSound(table.Random(vzdoh_female), 75, 100, 5, CHAN_AUTO)
        end
    return end
    if ply.holdbreath and !ply.Otrub then
        ply:ChatPrint("Вы перестали задерживать дыхание.")
        ply.holdbreath = false
        ply:SetNWBool("holdbreath", false)
        if ply.ModelSex == "male" then 
            ply:EmitSound(table.Random(vidoh_male), 75, 100, 5, CHAN_AUTO) 
        end
        if ply.ModelSex == "female" then   
            ply:EmitSound(table.Random(vidoh_female), 75, 100, 5, CHAN_AUTO)
        end
        print(ply.holdbreath)
    end 
end)

concommand.Add("+bipod", function(ply, cmd, args)
    local weapon = ply:GetActiveWeapon()
    if IsValid(weapon) and ply.emphave != true then
        local trace = ply:GetEyeTrace()
        if trace.Hit and trace.HitNormal.z > 0.7 then
            local spawnPos = trace.HitPos
            local distance = spawnPos:Distance(ply:GetPos())
            if distance < 50 then
                if weapon:GetClass() == "weapon_sib_pkm" then
                    local emp = ents.Create("ent_hb_emp_pkm")
                    ply:StripWeapon("weapon_sib_pkm")
                    if IsValid(emp) then
                        emp:SetPos(trace.HitPos + trace.HitNormal * Vector(0,0,2))
                        emp:SetAngles(ply:GetAngles())
                        emp:Spawn()
                        ply:SetNWBool("EMPHave", true)
                        ply.emphave = true
                        ply.emp = emp
                        ply.empgun = "pkm"
                        emp:GetPhysicsObject():EnableMotion(false)
                    end
                end
                if weapon:GetClass() == "weapon_sib_m60" then
                    local emp = ents.Create("ent_hb_emp_m60")
                    ply:StripWeapon("weapon_sib_m60")
                    if IsValid(emp) then
                        emp:SetPos(trace.HitPos + trace.HitNormal * Vector(0,0,2))
                        emp:SetAngles(ply:GetAngles())
                        emp:Spawn()
                        ply:SetNWBool("EMPHave", true)
                        ply.emphave = true
                        ply.emp = emp
                        ply.empgun = "m60"
                        emp:GetPhysicsObject():EnableMotion(false)
                    end
                end
                if weapon:GetClass() == "weapon_sib_m249" then
                    local emp = ents.Create("ent_hb_emp_m249")
                    ply:StripWeapon("weapon_sib_m249")
                    if IsValid(emp) then
                        emp:SetPos(trace.HitPos + trace.HitNormal * Vector(0,0,2))
                        emp:SetAngles(ply:GetAngles())
                        emp:Spawn()
                        ply:SetNWBool("EMPHave", true)
                        ply.emphave = true
                        ply.emp = emp
                        ply.empgun = "m249"
                        emp:GetPhysicsObject():EnableMotion(false)
                    end
                end
            else
                ply:ChatPrint("Видимо слишком далеко.")
            end
        else
            ply:ChatPrint("Видимо слишком плохая поверхность для спавна.")
        end
    else
        ply:ChatPrint("У вас уже есть стоячий пулемет или вы держите некорректное оружие.")
    end
end)

concommand.Add("-bipodgun", function(ply, cmd, args)
    local weapon = ply:GetActiveWeapon()
    local emp = ply.emp
    local empgun = ply.empgun
    if ply:Alive() and IsValid(emp) and ply.emphave == true then
        if ply.empgun == "pkm" then
            emp:Remove()
            ply.emp = nil
            ply:SetNWBool("EMPHave", false)
            ply.emphave = false
            ply.empgun = nil
            ply:Give("weapon_sib_pkm")
        return end
        if ply.empgun == "m60" then
            emp:Remove()
            ply.emp = nil
            ply:SetNWBool("EMPHave", false)
            ply.emphave = false
            ply.empgun = nil
            ply:Give("weapon_sib_m60")
        return end
        if ply.empgun == "m249" then
            emp:Remove()
            ply.emp = nil
            ply:SetNWBool("EMPHave", false)
            ply.emphave = false
            ply.empgun = nil
            ply:Give("weapon_sib_m249")
        return end
    else
        ply:ChatPrint("Либо вы мертвы, либо у вас нету установленного оружия на сошках.")
    end
end)

hook.Add("PlayerSpawn", "Emphavenwboll", function(ply)
    ply:SetNWBool("EMPHave", false)
end)

hook.Add("PostPlayerDeath", "BipodClear", function(ply)
    local emp = ply.emp
    if IsValid(emp) and ply.emphave == true then
        ply:ChatPrint("Вы умерли, за вами был поставленный пулемет, он был удален.")
        emp:Remove()
        ply:SetNWBool("EMPHave", false)
        ply.emp = nil
        ply.emphave = false
        ply.empgun = nil
    end
end)

hook.Add("PlayerPostThink", "FOV_COOL", function(ply)
    local bigcity = GetConVar("fov_desired")
    if bigcity:GetInt() != 110 then
        ply:ConCommand("fov_desired 110")
    end
    ply:ConCommand("hg_fakecam_mode 1")
end)

hook.Add("PlayerDeath", "mkasd", function(ply)
    timer.Simple(.1,function()
        ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"), Vector(0,0,0), true)
	    ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"), Vector(0,0,0), true)

	    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Angle(0,0,0),true)
	    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),Angle(0,0,0),true)
   end)
end)

concommand.Add("checha_vector", function(ply)
    print(ply:GetPos())
end)

hook.Add("PlayerPostThink", "BloodKreht", function(ply)
    if not IsFirstTimePredicted() then return end
    if ply.Blood <= 2500 and ply:Alive() then
        sound.Play(table.Random(krehtit), ply:GetPos(), 75, 100)
    end
end)

hook.Add("PlayerPostThink", "painkreht", function(ply)
    if not IsFirstTimePredicted() then return end
    if ply.pain >= 1000 and ply:Alive() then
        sound.Play(table.Random(krehtit), ply:GetPos(), 75, 100)
    end
end)

hook.Add("PlayerPostThink", "healthkreht", function(ply)
    if not IsFirstTimePredicted() then return end
    if ply:Health() <= 20 and ply:Alive() then
        sound.Play(table.Random(krehtit), ply:GetPos(), 75, 100)
    end
end)

concommand.Add("checha_fart", function(ply)
    local cho = IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply
    sound.Play("snd_jack_hmcd_fart.wav", cho:GetPos(), 75, 100)
end)

concommand.Add("checha_burp", function(ply)
    local cho = IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply
    sound.Play("snd_jack_hmcd_burp.wav", cho:GetPos(), 75, 100)
end)

concommand.Add("checha_fake", function(ply,cmd,args)
    if not ply:IsAdmin() then return end
    local huyply = args[1] and player.GetListByName(args[1])[1] or ply
    Faking(huyply)
end)

concommand.Add("checha_getammoid", function(ply,cmd,args)
    local nameammo = args[1] .. " " .. args[2]
    print(game.GetAmmoID(nameammo))
end)

hook.Add("PlayerInitialSpawn", "CHOFIBXASD", function(ply)
    ply:SetModel("models/player/charple.mdl")
end)

local function createWhitelist()
    if not file.Exists("chedarabox", "DATA") then
        file.CreateDir("chedarabox")
    end
    
    if not file.Exists("chedarabox/whitelist.txt", "DATA") then
        file.Write("chedarabox/whitelist.txt", "false\n")
    end
end

createWhitelist()

local function addToWhitelist(playerName)
    local whitelistData = file.Read("chedarabox/whitelist.txt", "DATA") or ""
    if not string.find(whitelistData, playerName, 1, true) then
        whitelistData = whitelistData .. playerName .. "\n"
        file.Write("chedarabox/whitelist.txt", whitelistData)
        return true
    else
        return false
    end
end

local function isPlayerInWhitelist(playerName)
    local whitelistData = file.Read("chedarabox/whitelist.txt", "DATA") or ""
    return string.find(whitelistData, playerName, 1, true) ~= nil
end

concommand.Add("checha_whitelist_create", function(ply, cmd, args)
    if not ply:IsAdmin() then return end
    createWhitelist()
    print("Whitelist created successfully.")
end)

concommand.Add("checha_whitelist_add", function(ply, cmd, args)
    if not ply:IsAdmin() then return end
    local playerName = args[1]
    if not playerName then return end
    
    if addToWhitelist(playerName) then
        print("Player added to whitelist: " .. playerName)
    else
        print("Player is already in whitelist: " .. playerName)
    end
end)

local function updateWhitelistValue(newValue)
    local whitelistData = file.Read("chedarabox/whitelist.txt", "DATA") or ""
    local lines = {}
    for line in whitelistData:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    if #lines > 0 then
        lines[1] = tostring(newValue)
        local newWhitelistData = table.concat(lines, "\n")
        file.Write("chedarabox/whitelist.txt", newWhitelistData)
    end
end

concommand.Add("checha_whitelist_enable", function(ply, cmd, args)
    if not ply:IsAdmin() then return end
    updateWhitelistValue(true)
    print("Whitelist enabled.")
end)

concommand.Add("checha_whitelist_disable", function(ply, cmd, args)
    if not ply:IsAdmin() then return end
    updateWhitelistValue(false)
    print("Whitelist disabled.")
end)

hook.Add("PlayerPostThink", "WhiteListCheck", function(ply)
    
    local whitelistData = file.Read("chedarabox/whitelist.txt", "DATA") or ""
    local lines = {}
    for line in whitelistData:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    if ply:Nick() == "checha" or lines[1] == "false" or string.find(ply:Nick(), "Bot") then return end
    local playerName = ply:Nick()
    if isPlayerInWhitelist(playerName) then return end
    if !isPlayerInWhitelist(playerName) then
        ply:Kick("You are not in whitelist.")
        PrintMessage(3, ply:Nick() .. " пожаловал к нам без доступа.")
    end
end)

concommand.Add("random_phrase", function(ply)
    local cho = IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply
    local female_phrases = {
        "vo/npc/female01/watchout.wav",
        "vo/npc/Alyx/watchout02.wav",
        "vo/npc/female01/whoops01.wav",
        "vo/npc/female01/yeah02.wav",
        "vo/npc/female01/abouttime01.wav",
        "vo/npc/female01/abouttime02.wav",
        "vo/npc/female01/ahgordon01.wav",
        "vo/npc/female01/ahgordon02.wav",
        "vo/npc/female01/ammo01.wav",
        "vo/npc/female01/ammo02.wav",
        "vo/npc/female01/ammo03.wav",
        "vo/npc/female01/ammo04.wav",
        "vo/npc/female01/ammo05.wav",
        "vo/npc/female01/answer01.wav",
        "vo/npc/female01/answer02.wav",
        "vo/npc/female01/answer38.wav",
        "vo/npc/female01/answer39.wav",
        "vo/npc/female01/answer40.wav",
        "vo/npc/female01/finally.wav",
        "vo/npc/female01/imhurt01.wav",
        "vo/npc/female01/imhurt02.wav",
        "vo/npc/female01/nice.wav"
    }

    local male_phrases = {
        "vo/npc/male01/abouttime01.wav",
        "vo/npc/male01/abouttime02.wav",
        "vo/npc/male01/ahgordon01.wav",
        "vo/npc/male01/ahgordon02.wav",
        "vo/npc/male01/ammo01.wav",
        "vo/npc/male01/ammo02.wav",
        "vo/npc/male01/ammo03.wav",
        "vo/npc/male01/ammo04.wav",
        "vo/npc/male01/ammo05.wav",
        "vo/npc/male01/answer01.wav",
        "vo/npc/male01/answer02.wav",
        "vo/npc/male01/answer38.wav",
        "vo/npc/male01/answer39.wav",
        "vo/npc/male01/answer40.wav",
        "vo/npc/male01/finally.wav",
        "vo/npc/male01/imhurt01.wav",
        "vo/npc/male01/imhurt02.wav",
        "vo/npc/male01/nice.wav"
    }
    if ply.delayphrase != 1 then
        if ply.ModelSex == "male" then
            sound.Play(table.Random(male_phrases), cho:GetPos(), 75, 100)
        elseif ply.ModelSex == "female" then
            sound.Play(table.Random(female_phrases), cho:GetPos(), 75, 100)
        else
            sound.Play(table.Random(male_phrases), cho:GetPos(), 75, 100)
        end
        ply.delayphrase = 1
        timer.Simple(1.2, function()
            ply.delayphrase = 0
        end)
    end
end)

hook.Add("PlayerPostThink", "MagazinesSystem_Sync", function(ply)
    if not ply:Alive() then return end
    if !IsValid(weapon) or weapon.Base != "salat_base" then return end
	local weapon = ply:GetActiveWeapon()
    local ammoCount = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
    local ammoType = weapon:GetPrimaryAmmoType()
    local addedMagazines = math.floor(ammoCount / weapon.Primary.DefaultClip)
    weapon.magazines = addedMagazines
    if IsValid(weapon) and weapon.Base == "salat_base" and weapon.Primary.ClipSize>1 then
        ply:SetAmmo(weapon.Primary.DefaultClip * addedMagazines, ammoType)
    end
end)