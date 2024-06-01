local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")

Organs = {
	['brain']=5,
	['lungs']=40,
	['liver']=10,
	['stomach']=30,
	['intestines']=30,
	['heart']=20,
	['artery']=1,
	['spine']=10
}

RagdollDamageBoneMul={ -- Умножения урона при попадании по регдоллу
	[HITGROUP_LEFTLEG]=0.3,
	[HITGROUP_RIGHTLEG]=0.3,

	[HITGROUP_GENERIC]=0.7,

	[HITGROUP_LEFTARM]=0.4,
	[HITGROUP_RIGHTARM]=0.4,

	[HITGROUP_CHEST]=0.8,
	[HITGROUP_STOMACH]=0.7,

	[HITGROUP_HEAD]=5,
}

bonetohitgroup={ --Хитгруппы костей
    ["ValveBiped.Bip01_Head1"]=1,
    ["ValveBiped.Bip01_R_UpperArm"]=5,
    ["ValveBiped.Bip01_R_Forearm"]=5,
    ["ValveBiped.Bip01_R_Hand"]=5,
    ["ValveBiped.Bip01_L_UpperArm"]=4,
    ["ValveBiped.Bip01_L_Forearm"]=4,
    ["ValveBiped.Bip01_L_Hand"]=4,
    ["ValveBiped.Bip01_Pelvis"]=3,
    ["ValveBiped.Bip01_Spine2"]=2,
    ["ValveBiped.Bip01_L_Thigh"]=6,
    ["ValveBiped.Bip01_L_Calf"]=6,
    ["ValveBiped.Bip01_L_Foot"]=6,
    ["ValveBiped.Bip01_R_Thigh"]=7,
    ["ValveBiped.Bip01_R_Calf"]=7,
    ["ValveBiped.Bip01_R_Foot"]=7
}

function GetFakeWeapon(ply)
    ply.curweapon = ply.Info.ActiveWeapon
end

function SavePlyInfo(ply) -- Сохранение игрока перед его падением в фейк
    ply.Info = {}
    local info = ply.Info
    info.HasSuit = ply:IsSuitEquipped()
    info.SuitPower = ply:GetSuitPower()
    info.Ammo = ply:GetAmmo()
    info.ActiveWeapon = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or nil
    info.ActiveWeapon2 = ply:GetActiveWeapon()
    GetFakeWeapon(ply)
    info.Weapons={}
    for i,wep in pairs(ply:GetWeapons())do
        info.Weapons[wep:GetClass()]={
            Clip1=wep:Clip1(),
            Clip2=wep:Clip2(),
            AmmoType=wep:GetPrimaryAmmoType()
        }
    end
    info.Weapons2={}
    for i,wep in ipairs(ply:GetWeapons())do
        info.Weapons2[i-1]=wep:GetClass()
    end
    info.AllAmmo={}
    local i
    for ammo, amt in pairs(ply:GetAmmo())do
        i = i or 0
        i = i + 1
        info.AllAmmo[ammo]={i,amt}
    end
    --PrintTable(info.AllAmmo)
    return info
end

function GetFakeWeapon(ply)
	ply.curweapon = ply.Info.ActiveWeapon
end

function ClearFakeWeapon(ply)
	if ply.FakeShooting then DespawnWeapon(ply) end
end

function SavePlyInfoPreSpawn(ply) -- Сохранение игрока перед вставанием
	ply.Info = ply.Info or {}
	local info = ply.Info
	info.Hp = ply:Health()
	info.Armor = ply:Armor()
	return info
end

function ReturnPlyInfo(ply) -- возвращение информации игроку по его вставанию
    ClearFakeWeapon(ply)
	ply:SetSuppressPickupNotices(true)
    local info = ply.Info
    if(!info)then return end

    ply:StripWeapons()
    ply:StripAmmo()
	
	ply.slots = {}

    for name, wepinfo in pairs(info.Weapons or {}) do
        local weapon = ply:Give(name, true)
        if IsValid(weapon) and wepinfo.Clip1~=nil and wepinfo.Clip2~=nil then
            weapon:SetClip1(wepinfo.Clip1)
            weapon:SetClip2(wepinfo.Clip2)
        end
    end
    for ammo, amt in pairs(info.Ammo or {}) do
        ply:GiveAmmo(amt,ammo)
    end
    if info.ActiveWeapon then
        ply:SelectWeapon(info.ActiveWeapon)
    end
    if info.HasSuit then
        ply:EquipSuit()
        ply:SetSuitPower(info.SuitPower or 0)
    else
        ply:RemoveSuit()
    end
    ply:SetHealth(info.Hp)
    ply:SetArmor(info.Armor)

end

function Faking(ply) -- функция падения
	if not ply:Alive() then return end
	if ply:GetModel() == "models/player/brenton/ron_fbi/models/brenton.mdl" then return end
	if not ply.fake then
		if hook.Run("Fake",ply) ~= nil then return end
		
		ply.fake = true
		--ply.curweapon = ply:GetActiveWeapon():GetClass() or "" 
		ply:SetNWBool("fake",ply.fake)
		ply:SetSuppressPickupNotices(true)
		SavePlyInfo(ply)
		ply:DrawViewModel(false)
		if (SERVER) then
		ply:DrawWorldModel(false)
		end
		local veh
		if ply:InVehicle() then
			veh = ply:GetVehicle()
			ply:ExitVehicle()
		end

		local rag = ply:CreateRagdoll()

		if IsValid(veh) then
			rag:GetPhysicsObject():SetVelocity(veh:GetPhysicsObject():GetVelocity() * 5)
		end
		if IsValid(ply:GetNWEntity("Ragdoll")) then
			ply.fakeragdoll=ply:GetNWEntity("Ragdoll")
			ply.fake = true
			local wep = ply:GetActiveWeapon()

			if IsValid(wep) and table.HasValue(Guns,wep:GetClass())then
				SpawnWeapon(ply)
			end

			ply.walktime = CurTime()
			
			rag.bull = ents.Create("npc_bullseye")
			rag:SetNWEntity("RagdollController",ply)
			local bull = rag.bull
			local bodyphy = rag:GetPhysicsObjectNum(10)
			bull:SetPos(bodyphy:GetPos()+bodyphy:GetAngles():Right()*7)
			bull:SetMoveType( MOVETYPE_OBSERVER )
			bull:SetParent(rag,rag:LookupAttachment("eyes"))
			bull:SetHealth(1000)
			bull:Spawn()
			bull:Activate()
			bull:SetNotSolid(true)
			FakeBullseyeTrigger(rag,ply)
			ply:HuySpectate(OBS_MODE_CHASE)
			ply:SpectateEntity(ply:GetNWEntity("Ragdoll"))
			ply:SetActiveWeapon(nil)
			ply:DropObject()

			timer.Create("faketimer"..ply:EntIndex(), 2, 1, function() end)

			if table.HasValue(Guns,ply.curweapon) then
				ply.FakeShooting=true
				ply:SetNWInt("FakeShooting",true)
			else
				ply.FakeShooting=false
				ply:SetNWInt("FakeShooting",false)
			end
		end
	else
		if ply.dushat == true then
			ply:ChatPrint("Вас душат, вы не можете встать, для блокировки кликайте по кнопке прыжка.")
		return false end

		if ply.LeftLegbroke == true and ply.RightLegbroke == true then
			ply:ChatPrint("Обе ваши ноги сломаны, встать нельзя.")
		return false end

		if ply.pain > 700 then 
			
			ply:ChatPrint("Тебе слишком больно, чтобы встать.")
			
			return false
		end

		local rag = ply:GetNWEntity("Ragdoll")
		if IsValid(rag) then
			if IsValid(rag.bull) then
				rag.bull:Remove()
			end
			ply.GotUp = CurTime()
			if hook.Run("Fake Up",ply,rag) ~= nil then return end

			ply.fake = false
			ply:SetNWBool("fake",ply.fake)

			ply.fakeragdoll=nil
			SavePlyInfoPreSpawn(ply)
			local pos=rag:GetPos()
			local vel=rag:GetVelocity()
			--ply:UnSpectate()
			PLYSPAWN_OVERRIDE = true
			ply:SetNWBool("unfaked",PLYSPAWN_OVERRIDE)
			local eyepos=ply:EyeAngles()
			local health = ply:Health()
			JMod.Иди_Нахуй = true
			ply:Spawn()
			JMod.Иди_Нахуй = nil
			ReturnPlyInfo(ply)
			ply:SetHealth(health)
			ply.FakeShooting=false
			ply:SetNWInt("FakeShooting",false)
			ply:SetVelocity(vel)
			ply:SetEyeAngles(eyepos)
			PLYSPAWN_OVERRIDE = nil
			ply:SetNWBool("unfaked",PLYSPAWN_OVERRIDE)

			local trace = {start = pos,endpos = pos - Vector(0,0,64),filter = {ply,rag}}
			local tracea = util.TraceLine(trace)
			if tracea.Hit then
				--ply:ChatPrint(tostring(tracea.Fraction).." 1")
				pos:Add(Vector(0,0,64) * (tracea.Fraction))
			end

			local trace = {start = pos,endpos = pos + Vector(0,0,64),filter = {ply,rag}}
			local tracea = util.TraceLine(trace)
			if tracea.Hit then
				--ply:ChatPrint(tostring(1 - tracea.Fraction).." 2")
				pos:Add(-Vector(0,0,64) * (1 - tracea.Fraction))
			end
			
			ply:SetPos(pos)

			ply:DrawViewModel(true)
			ply:DrawWorldModel(true)
			ply:SetModel(ply:GetNWEntity("Ragdoll"):GetModel())
			ply:GetNWEntity("Ragdoll").huychlen = true
			ply:GetNWEntity("Ragdoll"):Remove()
			ply:SetNWEntity("Ragdoll",nil)

			if ply.wep_attach_supak then
				ply.wep_attach_supak = false
				ply.have_aksuppressor = true
    			ply:SetNWBool("PLY_Supressor762", true)
				ply:ChatPrint("Глушитель ПБС1 убран в инвентарь.")
			end

			if ply.wep_attach_supshotgun then
				ply.wep_attach_supshotgun = false
    			ply.have_12suppressor = true
    			ply:SetNWBool("PLY_Supressor12Gauge", true)
				ply:ChatPrint("Глушитель Ротор43 убран в инвентарь.")
			end

			if ply.wep_attach_sup9x19 then
				ply.wep_attach_sup9x19 = false
    			ply.have_9x19suppressor = true
    			ply:SetNWBool("PLY_Supressor9x19", true)
				ply:ChatPrint("Глушитель Оспрей9 убран в инвентарь.")
			end

			if ply.wep_sight_okp7 then
				ply.wep_sight_okp7 = false
    			ply.have_okp7sight = true
    			ply:SetNWBool("PLY_OKPSight7", true)
				ply:ChatPrint("Прицел ОКП7 убран в инвентарь.")
			end
			if ply.wep_sight_eotech553 then
				ply.wep_sight_eotech553 = false
    			ply.have_eotech553 = true
    			ply:SetNWBool("PLY_EOTech553", true)
				ply:ChatPrint("Прицел EOTech 553 убран в инвентарь.")
			end
			if ply.wep_sight_leupoldmark4 then
				ply.wep_sight_leupoldmark4 = false
    			ply.have_leupoldmark4 = true
    			ply:SetNWBool("PLY_Mark4Leupold", true)
				ply:ChatPrint("Прицел Leupold Mark4 убран в инвентарь.")
			end
		end
	end
end

hook.Add("CanExitVehicle","fakefastcar",function(veh,ply)
    --if veh:GetPhysicsObject():GetVelocity():Length() > 100 then Faking(ply) return false end
end)

function FakeBullseyeTrigger(rag,owner)
	if not IsValid(rag.bull) then return end
	for i,ent in pairs(ents.FindByClass("npc_*"))do
		if(ent:IsNPC() and ent:Disposition(owner)==D_HT)then
			ent:AddEntityRelationship(rag.bull,D_HT,0)
		end
	end
end

hook.Add("OnEntityCreated","hg-bullseye",function(ent)
	ent:SetShouldPlayPickupSound(false)
	if ent:IsNPC() then
		for i,rag in pairs(ents.FindByClass("prop_ragdoll"))do
			if IsValid(rag.bull) then
				ent:AddEntityRelationship(rag.bull,D_HT,0)
			end
		end
	end
end)

hook.Add("Think","FakedShoot",function() --функция стрельбы лежа
for i,ply in pairs(player.GetAll()) do
	if IsValid(ply:GetNWEntity("Ragdoll")) and ply.FakeShooting and ply:Alive() then
		SpawnWeapon(ply)
	else
		if IsValid(ply.wep) then
			DespawnWeapon(ply)
		end
	end
end
end)

hook.Add("PlayerSay","huyasds",function(ply,text)
	if ply:IsAdmin() and string.lower(text)=="!hostageply" then
		local hostagemodels = {
			"models/player/hostage/hostage_01.mdl",
			"models/player/hostage/hostage_02.mdl",
			"models/player/hostage/hostage_03.mdl",
			"models/player/hostage/hostage_04.mdl"
		}
		local ent = ply:GetEyeTrace().Entity
		if ent:IsPlayer() then
			ply:ChatPrint(ent:Nick(),ent:EntIndex())
			print(tostring(ply:Name()).." связал "..tostring(ent:Name()))
			ent:StripWeapons()
			ent:Give("weapon_hands")
			ent:SetModel(table.Random(hostagemodels))
			Faking(ent)
			timer.Simple(0,function()
				local enta = ent:GetNWEntity("Ragdoll")
				enta:GetPhysicsObjectNum(5):SetPos(enta:GetPhysicsObjectNum(7):GetPos())
				for i=1,3 do
					constraint.Rope(enta,enta,5,7,Vector(0,0,0),Vector(0,0,0),-2,2,0,4,"cable/rope.vmt",false,Color(255,255,255))
				end
			end)
			ent.Hostage = true
		elseif ent:IsRagdoll() then
			ply:ChatPrint(IsValid(RagdollOwner(ent)) and RagdollOwner(ent):Name())
			--ent:StripWeapons()
			--ent:Give("weapon_hands")
			--Faking(ent)
			timer.Simple(0,function()
				local enta = ent
				enta:GetPhysicsObjectNum(5):SetPos(enta:GetPhysicsObjectNum(7):GetPos())
				for i=1,3 do
					constraint.Rope(enta,enta,5,7,Vector(0,0,0),Vector(0,0,0),-2,2,0,4,"cable/rope.vmt",false,Color(255,255,255))
				end
			end)
		end
		return ""
	end
end)

function RagdollOwner(rag) --функция, определяет хозяина регдолла
	if not IsValid(rag) then return end

	local ent = rag:GetNWEntity("RagdollController")
	return IsValid(ent) and ent
end

function PlayerMeta:DropWeapon1(wep)
    local ply = self
	wep = wep or ply:GetActiveWeapon()
    if !IsValid(wep) then return end

	if wep:GetClass() == "weapon_hands" then return end
	if wep.Base == "salat_base" then
		if wep.TwoHands then
			ply.slots[3] = nil
		else
			ply.slots[2] = nil
		end
	end
	print(wep:GetModel())
	ply:DropWeapon(wep)
	wep.Spawned = true
	ply:SelectWeapon("weapon_hands")
	
end

util.AddNetworkString("pophead")

function PlayerMeta:PickupEnt()
local ply = self
local rag = ply:GetNWEntity("Ragdoll")
local phys = rag:GetPhysicsObjectNum(7)
local offset = phys:GetAngles():Right()*5
local traceinfo={
start=phys:GetPos(),
endpos=phys:GetPos()+offset,
filter=rag,
output=trace,
}
local trace = util.TraceLine(traceinfo)
if trace.Entity == Entity(0) or trace.Entity == NULL or !trace.Entity.canpickup then return end
if trace.Entity:GetClass()=="wep" then
    ply:Give(trace.Entity.curweapon,true):SetClip1(trace.Entity.Clip)
    --SavePlyInfo(ply)
    ply.wepClip=trace.Entity.Clip
    trace.Entity:Remove()
end
end


hook.Add("DoPlayerDeath","blad",function(ply,att,dmginfo)
	SavePlyInfo(ply)

	local rag = ply:GetNWEntity("Ragdoll")
	
	if not IsValid(rag) then
		rag = ply:CreateRagdoll(att,dmginfo)
		ply:SetNWEntity("Ragdoll",rag)
	end
	rag=ply:GetNWEntity("Ragdoll")
	rag:SetEyeTarget(Vector(0,0,0))
	local phys = rag:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(5)
	end
	rag:SetNWEntity("RagdollController",Entity(0))

	net.Start("pophead")
	net.WriteEntity(rag)
	net.Send(ply)

	if IsValid(rag.bull) then rag.bull:Remove() end
	rag.deadbody = true

	if ply.IsBleeding or ply.Bloodlosing > 0 then
		rag.IsBleeding=true
		rag.bloodNext = CurTime()
		rag.Blood = ply.Blood
		table.insert(BleedingEntities,rag)
	end

	rag.Info = ply.Info
	rag.deadbody = true
	rag.curweapon=ply.curweapon
	if(IsValid(rag.ZacConsLH))then
		rag.ZacConsLH:Remove()
		rag.ZacConsLH=nil
	end

	if(IsValid(rag.ZacConsRH))then
		rag.ZacConsRH:Remove()
		rag.ZacConsRH=nil
	end

	local ent = ply:GetNWEntity("Ragdoll")
	if IsValid(ent) then ent:SetNWEntity("RagdollOwner",Entity(-1)) end

	ply:SetDSP(0)
	ply.fakeragdoll = nil
	ply.fake = nil
	ply.FakeShooting = false
	PLYSPAWN_OVERRIDE = nil
	ply.FakeShooting=false
	ply:SetNWInt("FakeShooting",false)

	timer.Create("stopbleed"..rag:EntIndex(),30,1,function()
		if IsValid(ent) then ent.IsBleeding = false end
	end)
	timer.Create("delete"..ent:EntIndex(),300,1,function()
		if IsValid(ent) then ent:Remove() end
	end)
end)

hook.Add("PostPlayerDeath","fuckyou",function(ply)

end)

hook.Add("PhysgunDrop", "DropPlayer", function(ply,ent)
	ent.isheld=false
end)

hook.Add("PlayerDisconnected","saveplyinfo",function(ply)
	--if ply:Alive() then
		--SavePlyInfo(ply)
		--ply:Kill()
	--end
end)

hook.Add("PhysgunPickup", "DropPlayer2", function(ply,ent)

	if ply:IsAdmin()  then

		if ent:IsPlayer() and !ent.fake then
			if hook.Run("Should Fake Physgun",ply,ent) ~= nil then return false end

			ent.isheld=true

			Faking(ent)
			return false
		end
	end
end)

util.AddNetworkString("fuckfake")
hook.Add("PlayerSpawn","resetfakebody",function(ply) --обнуление регдолла после вставания
	ply.fake = false
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

	net.Start("fuckfake")
	net.Send(ply)

	ply:SetNWBool("fake",false)

	if PLYSPAWN_OVERRIDE then return end
	ply.FakeShooting = false

	ply:SetDuckSpeed(0.3)
	ply:SetUnDuckSpeed(0.3)
	
	ply.slots = {}
	if ply.UsersInventory ~= nil then
		for plys,bool in pairs(ply.UsersInventory) do
			ply.UsersInventory[plys] = nil
			send(plys,lootEnt,true)
		end
	end
	ply:SetNWEntity("Ragdoll",nil)
end)

local function hasWeapon(ply, weaponName)
    if not IsValid(ply) or not ply:IsPlayer() then return false end -- Проверяем, является ли объект игроком и существует ли он
    
    for _, weapon in pairs(ply:GetWeapons()) do -- Перебираем все оружия игрока
        if IsValid(weapon) and weapon:GetClass() == weaponName then -- Проверяем, является ли оружие действительным и совпадает ли его класс с заданным названием
            return true -- Если нашли оружие, возвращаем true
        end
    end
    
    return false 
end

util.AddNetworkString("TourniquetMedKit")
net.Receive("TourniquetMedKit",function(len,ply)
    local wep = ply:GetActiveWeapon()
    if wep.tourniquet <= 0 then return end
    if hasWeapon(ply, "tourniquet") then ply:ChatPrint("У вас уже имеется турникет.") return end
    wep.tourniquet = wep.tourniquet - 1
    ply:ChatPrint("Вы достали турникет из аптечки теперь он в вашем инвентаре.")
    ply:Give("tourniquet")
	wep:SetNWInt("tourniquet", wep.tourniquet)
end)

util.AddNetworkString("BMK")
net.Receive("BMK",function(len,ply)
    local wep = ply:GetActiveWeapon()
    if wep.bandage <= 0 then return end
    if hasWeapon(ply, "med_band_small") or hasWeapon(ply, "med_band_big") then ply:ChatPrint("У вас уже имеется бинт.") return end
    ply:ChatPrint("Вы достали бинт из аптечки теперь он в вашем инвентаре.")
    wep.bandage = wep.bandage - 1
    if wep.bandage == 1 then ply:Give("med_band_small") end
	if wep.bandage == 0 then ply:Give("med_band_big") end
	wep:SetNWInt("bandage", wep.bandage)
end)

util.AddNetworkString("PMK")
net.Receive("PMK",function(len,ply)
    local wep = ply:GetActiveWeapon()
    if wep.painkill <= 0 then return end
    if hasWeapon(ply, "painkiller") then ply:ChatPrint("У вас уже имеется обезбол.") return end
    ply:ChatPrint("Вы достали турникет из аптечки теперь он в вашем инвентаре.")
    wep.painkill = wep.painkill - 1
    ply:Give("painkiller")
	wep:SetNWInt("painkill", wep.painkill)
end)

util.AddNetworkString("MMK")
net.Receive("MMK",function(len,ply)
    local wep = ply:GetActiveWeapon()
    if wep.morphine <= 0 then return end
    if hasWeapon(ply, "morphine") then ply:ChatPrint("У вас уже имеется морфин.") return end
    ply:ChatPrint("Вы достали морфин из аптечки теперь он в вашем инвентаре.")
    wep.morphine = wep.morphine - 1
    ply:Give("morphine")
	wep:SetNWInt("morphine", wep.morphine)
end)

util.AddNetworkString("SMK")
net.Receive("SMK",function(len,ply)
    local wep = ply:GetActiveWeapon()
    if wep.splint <= 0 then return end
    if hasWeapon(ply, "tire") then ply:ChatPrint("У вас уже имеется шина.") return end
    ply:ChatPrint("Вы достали шину из аптечки теперь он в вашем инвентаре.")
    wep.splint = wep.splint - 1
    ply:Give("tire")
	wep:SetNWInt("splint", wep.splint)
end)

util.AddNetworkString("Kurare")
net.Receive("Kurare",function(len,ply)
	local wep = ply:GetActiveWeapon()
	ply:StripWeapon("weapon_hg_t_kurarepoison")
	wep.kurare = true
	timer.Simple(15, function()
		if IsValid(wep) then
			wep.kurare = false
		end
	end)
end)

util.AddNetworkString("Unload")
net.Receive("Unload",function(len,ply)
	local wep = net.ReadEntity()
	local oldclip = wep:Clip1()
	local ammo = wep:GetPrimaryAmmoType()
	wep:EmitSound("snd_jack_hmcd_ammotake.wav")
	wep:SetClip1(0)
	ply:GiveAmmo(oldclip,ammo)
end)

function Stun(Entity)
	if Entity:IsPlayer() then
		Faking(Entity)
		timer.Create("StunTime"..Entity:EntIndex(), 8, 1, function() end)
		local fake = Entity:GetNWEntity("Ragdoll")
		timer.Create( "StunEffect"..Entity:EntIndex(), 0.1, 80, function()
			local rand = math.random(1,50)
			if rand == 50 then
				Entity:Say("*drop")
			end
			Entity.pain = Entity.pain + 3
			fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
			fake:EmitSound("ambient/energy/spark2.wav")
		end)
	elseif Entity:IsRagdoll() then
		if RagdollOwner(Entity) then
			RagdollOwner(Entity):Say("*drop")
			timer.Create("StunTime"..RagdollOwner(Entity):EntIndex(), 8, 1, function() end)
			local fake = Entity
			timer.Create( "StunEffect"..RagdollOwner(Entity):EntIndex(), 0.1, 80, function()
				if rand == 50 then
					RagdollOwner(fake):Say("*drop")
				end
				RagdollOwner(fake).pain = RagdollOwner(fake).pain + 3
				fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
				fake:EmitSound("ambient/energy/spark2.wav")
			end)
		else
			local fake = Entity
			timer.Create( "StunEffect"..Entity:EntIndex(), 0.1, 80, function()
				fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
				fake:EmitSound("ambient/energy/spark2.wav")
			end)
		end
	end
end

concommand.Add("checha_addpain",function(ply)
	ply.pain = ply.pain + 10
end)

zeroAng = Angle(0,0,0)
concommand.Add("fake",function(ply)
	if timer.Exists("faketimer"..ply:EntIndex()) then return nil end
	if timer.Exists("StunTime"..ply:EntIndex()) then return nil end
	if ply:GetNWEntity("Ragdoll").isheld==true then return nil end
	if ply.Seizure then return end

	if ply.brokenspine then return nil end
	if ply.broken_uspine then return nil end
	if IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll"):GetVelocity():Length()>300 then return nil end
	if IsValid(ply:GetNWEntity("Ragdoll")) and table.Count(constraint.FindConstraints( ply:GetNWEntity("Ragdoll"), 'Rope' ))>0 then return nil end

	--if IsValid(ply:GetNWEntity("Ragdoll")) and table.Count(constraint.FindConstraints( ply:GetNWEntity("Ragdoll"), 'Weld' ))>0 then return nil end

	timer.Create("faketimer"..ply:EntIndex(), 2, 1, function() end)

	if ply:Alive() then
		Faking(ply)
		ply.fakeragdoll=ply:GetNWEntity("Ragdoll")
	end
end)

hook.Add("PreCleanupMap","cleannoobs",function() --все игроки встают после очистки карты
	for i, v in pairs(player.GetAll()) do
		if v.fake then Faking(v) end
	end

	BleedingEntities = {}

end)

local function CreateArmor(ragdoll,info)
	local item = JMod.ArmorTable[info.name]
	if not item then return end

	local Index = ragdoll:LookupBone(item.bon)
	if not Index then return end

	local Pos,Ang = (ragdoll):GetBonePosition(Index)
	--print(ragdoll)
	if not Pos then return end

	local ent = ents.Create(item.ent)

	local Right,Forward,Up = Ang:Right(),Ang:Forward(),Ang:Up()
	Pos = Pos + Right * item.pos.x + Forward * item.pos.y + Up * item.pos.z

	Ang:RotateAroundAxis(Right,item.ang.p)
	Ang:RotateAroundAxis(Up,item.ang.y)
	Ang:RotateAroundAxis(Forward,item.ang.r)

	ent.IsArmor = true
	ent:SetPos(Pos)
	ent:SetAngles(Ang)

	local color = info.col

	ent:SetColor(Color(color.r,color.g,color.b,color.a))

	ent:Spawn()
	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	if IsValid(ent:GetPhysicsObject()) then
		ent:GetPhysicsObject():SetMaterial("plastic")
	end
	constraint.Weld(ent,ragdoll,0,ragdoll:TranslateBoneToPhysBone(Index),0,true,false)

	ragdoll:DeleteOnRemove(ent)

	return ent
end

local function Remove(self,ply)
	if self.override then return end

	self.ragdoll.armors[self.armorID] = nil
	JMod.RemoveArmorByID(ply,self.armorID,true)
end

local function RemoveRag(self)
	for id,ent in pairs(self.armors) do
		if not IsValid(ent) then continue end

		ent.override = true
		ent:Remove()
	end
end

local CustomWeight = {
	["models/player/police_fem.mdl"] = 50,
	["models/player/police.mdl"] = 60,
	["models/player/combine_soldier.mdl"] = 70,
	["models/player/combine_super_soldier.mdl"] = 80,
	["models/player/combine_soldier_prisonguard.mdl"] = 70,
	["models/player/azov.mdl"] = 10,
	["models/player/Rusty/NatGuard/male_01.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_02.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_03.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_04.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_05.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_06.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_07.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_08.mdl"] = 90,
	["models/player/Rusty/NatGuard/male_09.mdl"] = 90,
	["models/LeymiRBA/Gyokami/Gyokami.mdl"] = 50,
	["models/player/smoky/Smoky.mdl"] = 65,
	["models/player/smoky/Smokycl.mdl"] = 65,
	["models/knyaje pack/dibil/sso_politepeople.mdl"] = 40
}

for i = 1,6 do
	CustomWeight["models/monolithservers/mpd/female_0"..i..".mdl"] = 20
end

for i = 1,6 do
	CustomWeight["models/monolithservers/mpd/female_0"..i.."_2.mdl"] = 20
end

for i = 1,6 do
	CustomWeight["models/monolithservers/mpd/male_0"..i..".mdl"] = 20
end

for i = 1,6 do
	CustomWeight["models/monolithservers/mpd/male_0"..i.."_2.mdl"] = 20
end


util.AddNetworkString("custom name")

net.Receive("custom name",function(len,ply)
	if not ply:IsAdmin() then return end
	
	local name = net.ReadString()
	if name == "" then return end

	ply:SetNWString("CustomName",name)
end)

function PlayerMeta:CreateRagdoll(attacker,dmginfo) --изменение функции регдолла
	--if not self:Alive() then return end
	local ragd=self:GetNWEntity("Ragdoll")
	ragd.ExplProof = true
	--debug.Trace()
	if IsValid(ragd) then
		if(IsValid(ragd.ZacConsLH))then
			ragd.ZacConsLH:Remove()
			ragd.ZacConsLH=nil
		end
		if(IsValid(ragd.ZacConsRH))then
			ragd.ZacConsRH:Remove()
			ragd.ZacConsRH=nil
		end
		return
	end

	local Data = duplicator.CopyEntTable( self )
	local rag = ents.Create( "prop_ragdoll" )
	duplicator.DoGeneric( rag, Data )
	rag:SetModel(self:GetModel())
	--rag:SetColor(self:GetColor()) --huy sosi garry
	rag:SetNWVector("plycolor",self:GetPlayerColor())
	rag:SetSkin(self:GetSkin())
	rag:Spawn()

	rag:CallOnRemove("huyhjuy",function() self.firstrag = false end)
	rag:CallOnRemove("huy2ss",function()
		if not rag.huychlen and RagdollOwner(rag) then
			rag.huychlen = false
			RagdollOwner(rag):KillSilent()
		end
	end)
	
	rag:AddEFlags(EFL_NO_DAMAGE_FORCES)
	if IsValid(rag:GetPhysicsObject()) then
		rag:GetPhysicsObject():SetMass(CustomWeight[rag:GetModel()] or 20)
	end
	rag:Activate()
	rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	rag:SetNWEntity("RagdollOwner", self)
	local vel = self:GetVelocity()/1
	for i = 0, rag:GetPhysicsObjectCount() - 1 do
		local physobj = rag:GetPhysicsObjectNum( i )
		local ragbonename = rag:GetBoneName(rag:TranslatePhysBoneToBone(i))
		local bone = self:LookupBone(ragbonename)
		if(bone)then
			local bonemat = self:GetBoneMatrix(bone)
			if(bonemat)then
				local bonepos = bonemat:GetTranslation()
				local boneang = bonemat:GetAngles()
				physobj:SetPos( bonepos,true )
				physobj:SetAngles( boneang )
				if !self:Alive() then vel=vel end
				physobj:AddVelocity( vel )
			end
		end
	end

	rag:SetNWString("Nickname",self:GetNWString("CustomName",false) or self:Name())

	local armors = {}

	for id,info in pairs(self.EZarmor.items) do
		local ent = CreateArmor(rag,info)
		ent.armorID = id
		ent.ragdoll = rag
		ent.Owner = self
		armors[id] = ent

		ent:CallOnRemove("Fake",Remove,self)
	end

	if IsValid(self.wep) then
		self.wep.rag = rag
	end
	rag.armors = armors
	rag:CallOnRemove("Armors",RemoveRag)

	self.fakeragdoll = rag
	self:SetNWEntity("Ragdoll", rag )
	if not self:Alive() then
		net.Start("pophead")
		net.WriteEntity(rag)
		net.Send(self)
        rag.Info=self.Info
        if IsValid(self:GetActiveWeapon()) then
            self.curweapon = nil
            if table.HasValue(Guns,self:GetActiveWeapon():GetClass()) then
				self.curweapon = self:GetActiveWeapon():GetClass()
				SpawnWeapon(self,self:GetActiveWeapon():Clip1())
				rag.curweapon = self:GetActiveWeapon():GetClass()
			end
        end
        SavePlyInfo(self)
        rag.Info=self.Info
        rag.curweapon=self.curweapon
        rag:SetEyeTarget(Vector(0,0,0))
        rag:SetFlexWeight(9,0)
        if self.IsBleeding or (self.BloodLosing or 0) > 0 then
			rag.IsBleeding=true
			rag.bloodNext = CurTime()
			rag.Blood = self.Blood
			table.insert(BleedingEntities,rag)
		end
		if IsValid(rag.bull) then
			rag.bull:Remove()
		end
        rag.deadbody = true
		self.fakeragdoll = nil
		--if not self:GetActiveWeapon():IsValid() then return rag end
		net.Start("ebal_chellele")
		net.WriteEntity(rag)
		net.WriteEntity(rag.curweapon)
		net.Broadcast()
    else
		if not self:GetActiveWeapon():IsValid() then return rag end
		net.Start("ebal_chellele")
		net.WriteEntity(self)
		net.WriteString(self:GetActiveWeapon():GetClass())
		net.Broadcast()
	end

	return rag
end

hook.Add("JMod Armor Remove","Fake",function(ply,slot,item,drop)
	local fake = ply:GetNWEntity("Ragdoll")
	if not IsValid(fake) then return end

	local ent = fake.armors[slot.id]
	if not IsValid(ent) then return end

	ent:Remove()
end)

hook.Add("JMod Armor Equip","Fake",function(ply,slot,item,drop)
	local fake = ply:GetNWEntity("Ragdoll")
	if not IsValid(fake) then return end

	local ent = CreateArmor(fake,item)
	ent.armorID = slot.id
	ent.Owner = ply
	fake.armors[slot.id] = ent
	ent:CallOnRemove("Fake",Remove,ent,ply)
end,2)--lol4ik

local gg = CreateConVar("hg_oldcollidefake","0")
COMMANDS.oldcollidefake = {function(ply,args)
	GetConVar("hg_oldcollidefake"):SetBool(tonumber(args[1]) > 0)
	PrintMessage(3,"Старая система collide fake - " .. tostring(gg:GetBool()))
end}

hook.Add("Player Collide","homigrad-fake",function(ply,hitEnt,data)
	--if not ply:HasGodMode() and data.Speed >= 250 / hitEnt:GetPhysicsObject():GetMass() * 20 and not ply.fake and not hitEnt:IsPlayerHolding() and hitEnt:GetVelocity():Length() > 80 then
	if
		(gg:GetBool() and not ply:HasGodMode() and data.Speed > 200) or
		(not gg:GetBool() and not ply:HasGodMode() and data.Speed >= 250 / hitEnt:GetPhysicsObject():GetMass() * 20 and not ply.fake and not hitEnt:IsPlayerHolding() and hitEnt:GetVelocity():Length() > 150)
	then
		timer.Simple(0,function()
			if not IsValid(ply) or ply.fake then return end

			if hook.Run("Should Fake Collide",ply,hitEnt,data) == false then return end

			Faking(ply)
		end)
	end
end)

hook.Add("OnPlayerHitGround","GovnoJopa",function(ply,a,b,speed)
	if speed > 200 then
		if hook.Run("Should Fake Ground",ply) ~= nil then return end

		local tr = {}
		tr.start = ply:GetPos()
		tr.endpos = ply:GetPos() - Vector(0,0,10)
		tr.mins = ply:OBBMins()
		tr.maxs = ply:OBBMaxs()
		tr.filter = ply
		local traceResult = util.TraceHull(tr)
		if traceResult.Entity:IsPlayer() and not traceResult.Entity.fake then
			Faking(traceResult.Entity)
		end
	end
end)

hook.Add("Think","VelocityFakeHitPlyCheck",function() --проверка на скорость в фейке (для сбивания с ног других игроков)
	for i,rag in pairs(ents.FindByClass("prop_ragdoll")) do
		if IsValid(rag) then
			if rag:GetVelocity():Length() > 1 then
				rag:SetCollisionGroup(COLLISION_GROUP_NONE)
			else
				rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			end
		end
	end
end)
local CurTime = CurTime
hook.Add("StartCommand","asdfgghh",function(ply,cmd)
	local rag = ply:GetNWEntity("Ragdoll")
	if (ply.GotUp or 0) - CurTime() > -0.1 and not IsValid(rag) then cmd:AddKey(IN_DUCK) end
	if IsValid(rag) then cmd:RemoveKey(IN_DUCK) end
end)

hook.Add( "KeyPress", "Shooting", function( ply, key )
	if !ply:Alive() or ply.Otrub then return end
	if ply.FakeShooting and !weapons.Get(ply.curweapon).Primary.Automatic then
		if( key == IN_ATTACK )then
			if ply.FakeShooting then FireShot(ply.wep) end
		end
	end

	if(key == IN_RELOAD)then
		Reload(ply.wep)
	end
end )

local dvec = Vector(0,0,-64)

hook.Add("Player Think","FakeControl",function(ply,time) --управление в фейке
	ply.holdingartery=false
	if not ply:Alive() then return end
	local rag = ply:GetNWEntity("Ragdoll")

	if not IsValid(rag) or not ply:Alive() then return end
	local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
	if not bone then return end
	if IsValid(ply.bull) then
		ply.bull:SetPos(rag:GetPos())
	end
	local head1 = rag:GetBonePosition(bone) + dvec
	ply:SetPos(head1)
	ply:SetNWBool("fake",ply.fake)
	local deltatime = CurTime()-(rag.ZacLastCallTime or CurTime())
	rag.ZacLastCallTime=CurTime()
	local eyeangs = ply:EyeAngles()
	local head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )

if !ply.Otrub then
	if ply:GetNWBool("CloseEye", false) == false then 
		rag:SetFlexWeight(9,0) 
	else 
		rag:SetFlexWeight(9, 1)
	end
end

	local dist = (rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()):Distance(ply:GetAimVector()*10000)
	local distmod = math.Clamp(1-(dist/20000),0.1,1)
	local lookat = LerpVector(distmod,rag:GetAttachment(rag:LookupAttachment( "eyes" )).Ang:Forward()*100000,ply:GetAimVector()*100000)
	local attachment = rag:GetAttachment( rag:LookupAttachment( "eyes" ) )
	local LocalPos, LocalAng = WorldToLocal( lookat, Angle( 0, 60, 0 ), attachment.Pos, attachment.Ang )
	if !ply.Otrub then rag:SetEyeTarget( LocalPos ) else rag:SetEyeTarget( Vector(0,0,0) ) end
	if ply:Alive() then
		--RagdollOwner(rag):SetMoveParent( rag )
		--RagdollOwner(rag):SetParent( rag )
	if !ply.Otrub and !ply.broken_uspine then
		if ply:KeyDown(IN_JUMP) and ply.dushat == true then
			ply:ChatPrint("Блок успешен! Если вас все еще душат, кликайте на кнопку прыжка быстрее и вставайте!")
			ply.dushat = false
		end
		if ply:KeyDown( IN_JUMP ) and (table.Count(constraint.FindConstraints( ply:GetNWEntity("Ragdoll"), 'Rope' ))>0 or ((rag.IsWeld or 0) > 0)) and ply.stamina>45 and (ply.lastuntietry or 0) < CurTime() then
			ply.lastuntietry = CurTime() + 2
			
			rag.IsWeld = math.max((rag.IsWeld or 0) - 0.1,0)

			local RopeCount = table.Count(constraint.FindConstraints( ply:GetNWEntity("Ragdoll"), 'Rope' ))
			Ropes = constraint.FindConstraints( ply:GetNWEntity("Ragdoll"), 'Rope' )
			Try = math.random(1,10*RopeCount)
			ply.stamina=ply.stamina - 5
			local phys = rag:GetPhysicsObjectNum( 1 )
			local speed = 200
			local shadowparams = {
				secondstoarrive=0.5,
				pos=phys:GetPos()+phys:GetAngles():Forward()*20,
				angle=phys:GetAngles(),
				maxangulardamp=30,
				maxspeeddamp=30,
				maxangular=90,
				maxspeed=speed,
				teleportdistance=0,
				deltatime=0.01,
			}
			phys:Wake()
			phys:ComputeShadowControl(shadowparams)
			if Try > (7*RopeCount) or ((rag.IsWeld or 0) > 0) then
				if RopeCount>1 or (rag.IsWeld or 0 > 0) then
					if RopeCount > 1 then
						ply:ChatPrint("Осталось: "..RopeCount - 1)
					end
					if (rag.IsWeld or 0) > 0 then
						ply:ChatPrint("Осталось отбить гвоздей: "..tostring(math.ceil(rag.IsWeld)))
						ply.Bloodlosing = ply.Bloodlosing + 10
						ply.pain = ply.pain + 10
					end
				else
					ply:ChatPrint("Ты развязался")
				end
				Ropes[1].Constraint:Remove()
				rag:EmitSound("snd_jack_hmcd_ducttape.wav",90,50,0.5,CHAN_AUTO)
			end
		end

		if(ply:KeyDown(IN_ATTACK) and !ply.LeftArmbroke)then
			local pos = ply:EyePos()
			pos[3] = head:GetPos()[3]
            if !ply.FakeShooting and !ply.arterybleeding then
				local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) )
				local ang=ply:EyeAngles()
				ang:RotateAroundAxis(eyeangs:Forward(),90)
				ang:RotateAroundAxis(eyeangs:Right(),75)
				local shadowparams = {
					secondstoarrive=0.35,
					pos=head:GetPos()+eyeangs:Forward()*45,
					angle=ang,
					maxangular=670,
					maxangulardamp=600,
					maxspeeddamp=50,
					maxspeed=500,
					teleportdistance=0,
					deltatime=0.01,
				}
				phys:Wake()
				phys:ComputeShadowControl(shadowparams)
			end
		end

		if ply.FakeShooting and weapons.Get(ply.curweapon).Primary.Automatic then
			if(ply:KeyDown(IN_ATTACK))then--KeyDown if an automatic gun
				if ply.FakeShooting then FireShot(ply.wep) end
			end
		else 
		end

		if(ply:KeyDown(IN_ATTACK2) and !ply.RightArmbroke) then
				local physa = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
				local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) ) --rhand
				local ang=ply:EyeAngles() --LerpAngle(0.5,ply:EyeAngles(),ply:GetNWEntity("Ragdoll"):GetAttachment(1).Ang)
				ang:RotateAroundAxis(eyeangs:Forward(),90)
				ang:RotateAroundAxis(eyeangs:Right(),75)
				local pos = ply:EyePos()
				pos[3] = head:GetPos()[3]
				local shadowparams = {
					secondstoarrive=0.35,
					pos=head:GetPos()+eyeangs:Forward()*45,
					angle=ang,
					maxangular=670,
					maxangulardamp=100,
					maxspeeddamp=50,
					maxspeed=500,
					teleportdistance=0,
					deltatime=0.01,
				}--я расстояние выбирал специально чтобы можно было большую скорость ставить, а че вы сделали что бы оно не улетали модельки, типо алянсеров
				physa:Wake()
			if (!ply.suiciding or TwoHandedOrNo[ply.curweapon]) then
				if TwoHandedOrNo[ply.curweapon] and IsValid(ply.wep) then
					local ang = ply:EyeAngles()
					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(ang:Up(),0)
					ang:RotateAroundAxis(ang:Right(),-10)
					shadowparams.angle = ang

						ply.wep:GetPhysicsObject():ComputeShadowControl(shadowparams)

					shadowparams.pos=shadowparams.pos+eyeangs:Right()*5+eyeangs:Forward()*10
					phys:ComputeShadowControl(shadowparams)
					shadowparams.pos=shadowparams.pos+eyeangs:Forward()*-100+eyeangs:Right()*20+eyeangs:Up()*-10
					physa:ComputeShadowControl(shadowparams)
			local phys = head
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),20)
			local shadowparams = {
				secondstoarrive=0.6,
				pos=head:GetPos()+vector_up,
				angle=angs,
				maxangulardamp=10,
				maxspeeddamp=10,
				maxangular=370,
				maxspeed=40,
				teleportdistance=0,
				deltatime=deltatime,
			}
			head:Wake()
			head:ComputeShadowControl(shadowparams)

				elseif IsValid(ply.wep) and IsValid(ply.wep:GetPhysicsObject())then
					
					ang:RotateAroundAxis(ply:EyeAngles():Forward(),150)
					ang:RotateAroundAxis(ply:EyeAngles():Up(),150)
					ang:RotateAroundAxis(eyeangs:Right(),-10)
					--ang:RotateAroundAxis(eyeangs:Up(),60)
					--ang:RotateAroundAxis(eyeangs:Right(),-45)
					--ang:RotateAroundAxis(eyeangs:Up(),-45)
					shadowparams.angle=ang
					shadowparams.pos=shadowparams.pos+eyeangs:Right()*-15+eyeangs:Up()*-5

					ply.wep:GetPhysicsObject():ComputeShadowControl(shadowparams)
					physa:ComputeShadowControl(shadowparams)
			local phys = head
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),20)
			local shadowparams = {
				secondstoarrive=0.6,
				pos=head:GetPos()+vector_up,
				angle=angs,
				maxangulardamp=10,
				maxspeeddamp=10,
				maxangular=370,
				maxspeed=40,
				teleportdistance=0,
				deltatime=deltatime,
			}
			head:Wake()
			head:ComputeShadowControl(shadowparams)
				else
					physa:ComputeShadowControl(shadowparams)
			local phys = head
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),20)
			local shadowparams = {
				secondstoarrive=0.6,
				pos=head:GetPos()+vector_up,
				angle=angs,
				maxangulardamp=10,
				maxspeeddamp=10,
				maxangular=370,
				maxspeed=40,
				teleportdistance=0,
				deltatime=deltatime,
			}
			head:Wake()
			head:ComputeShadowControl(shadowparams)
				end
			else
				if ply.FakeShooting and IsValid(ply.wep) then
					shadowparams.maxspeed=500
					shadowparams.maxangular=500
					shadowparams.pos=head:GetPos()-ply.wep:GetAngles():Forward()*15
					shadowparams.angle=ply.wep:GetPhysicsObject():GetAngles()
					ply.wep:GetPhysicsObject():ComputeShadowControl(shadowparams)
					physa:ComputeShadowControl(shadowparams)
			local phys = head
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),20)
			local shadowparams = {
				secondstoarrive=0.6,
				pos=head:GetPos()+vector_up,
				angle=angs,
				maxangulardamp=10,
				maxspeeddamp=10,
				maxangular=370,
				maxspeed=40,
				teleportdistance=0,
				deltatime=deltatime,
			}
			head:Wake()
			head:ComputeShadowControl(shadowparams)
				end
			end
			--[[physa:ComputeShadowControl(shadowparams)
			if TwoHandedOrNo[ply.curweapon] then
				shadowparams.maxspeed=90
				ply.wep:GetPhysicsObject():ComputeShadowControl(shadowparams)
				shadowparams.maxspeed=20
				shadowparams.angle:RotateAroundAxis(eyeangs:Forward(),90)
				phys:ComputeShadowControl(shadowparams) --if 2handed
			end--]]
		end
		if(ply:KeyDown(IN_USE) and !ply.dushat)then
			local phys = head
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),20)
			local shadowparams = {
				secondstoarrive=0.2,
				pos=head:GetPos()+vector_up*(50),
				angle=angs,
				maxangulardamp=10,
				maxspeeddamp=10,
				maxangular=370,
				maxspeed=40,
				teleportdistance=0,
				deltatime=deltatime,
			}
			head:Wake()
			head:ComputeShadowControl(shadowparams)
		end

		end
		if (ply:KeyDown(IN_SPEED)) and !RagdollOwner(rag).Otrub and !timer.Exists("StunTime"..ply:EntIndex()) then
			local bone = rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" ))
			local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) )
			if ply.Organs["artery"] == 0 and !TwoHandedOrNo[ply.curweapon] then
				local shadowparams = {
				secondstoarrive=0.4,
				pos=head:GetPos()+vector_up*(5),
				angle=angs,
				maxangulardamp=10,
				maxspeeddamp=10,
				maxangular=370,
				maxspeed=1120,
				teleportdistance=0,
				deltatime=deltatime,
				}
				phys:Wake()
				phys:ComputeShadowControl(shadowparams)
				ply.holdingartery=true
				if(IsValid(rag.ZacConsLH))then
					rag.ZacConsLH:Remove()
					rag.ZacConsLH=nil
				end
			end
			if(!IsValid(rag.ZacConsLH) and (!rag.ZacNextGrLH || rag.ZacNextGrLH<=CurTime()))then
				rag.ZacNextGrLH=CurTime()+0.1
				for i=1,3 do
					local offset = phys:GetAngles():Up()*-5
					if(i==2)then
						offset = phys:GetAngles():Right()*5
					end
					if(i==3)then
						offset = phys:GetAngles():Right()*-5
					end
					local traceinfo={
						start=phys:GetPos(),
						endpos=phys:GetPos()+offset,
						filter=rag,
						output=trace,
					}
					local trace = util.TraceLine(traceinfo)
					if(trace.Hit and !trace.HitSky)then
						local cons = constraint.Weld(rag,trace.Entity,bone,trace.PhysicsBone,0,false,false)
						rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger01"), Angle(0,30,0), true )
						rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger11"), Angle(0,-50,0), true )
						rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger21"), Angle(0,-50,0), true )
						rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger31"), Angle(0,-50,0), true )
						rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger41"), Angle(0,-50,0), true )
						if(IsValid(cons))then
							rag.ZacConsLH=cons
						end
						break
					end
				end
			end
		else
			if ply.arterybleeding then ply.holdingartery=false end
			if(IsValid(rag.ZacConsLH))then
				rag.ZacConsLH:Remove()
				rag.ZacConsLH=nil
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger01"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger11"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger21"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger31"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_L_Finger41"), zeroAng, true )
			end
		end
		if(ply:KeyDown(IN_WALK) and !ply.RightArmbroke) and !RagdollOwner(rag).Otrub and !timer.Exists("StunTime"..ply:EntIndex()) then
			local bone = rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" ))
			local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
			if(!IsValid(rag.ZacConsRH) and (!rag.ZacNextGrRH || rag.ZacNextGrRH<=CurTime()))then
				rag.ZacNextGrRH=CurTime()+0.1
				for i=1,3 do
					local offset = phys:GetAngles():Up()*5
					if(i==2)then
						offset = phys:GetAngles():Right()*5
					end
					if(i==3)then
						offset = phys:GetAngles():Right()*-5
					end
					local traceinfo={
						start=phys:GetPos(),
						endpos=phys:GetPos()+offset,
						filter=rag,
						output=trace,
					}
					local trace = util.TraceLine(traceinfo)
					if(trace.Hit and !trace.HitSky)then
						local cons = constraint.Weld(rag,trace.Entity,bone,trace.PhysicsBone,0,false,false)
						if(IsValid(cons))then
							rag.ZacConsRH=cons
							rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger01"), Angle(0,30,0), true )
							rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger11"), Angle(0,-50,0), true )
							rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger21"), Angle(0,-50,0), true )
							rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger31"), Angle(0,-50,0), true )
							rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger41"), Angle(0,-50,0), true )
						end
						break
					end
				end
			end
		else
			if(IsValid(rag.ZacConsRH))then
				rag.ZacConsRH:Remove()
				rag.ZacConsRH=nil
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger01"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger11"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger21"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger31"), zeroAng, true )
				rag:ManipulateBoneAngles( rag:LookupBone("ValveBiped.Bip01_R_Finger41"), zeroAng, true )
			end
		end
		if(ply:KeyDown(IN_FORWARD) and IsValid(rag.ZacConsLH))then
			local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine" )) )
			local lh = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) )
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),90)
			local speed = 45
			
			if(rag.ZacConsLH.Ent2:GetVelocity():LengthSqr()<1000) then
				local shadowparams = {
					secondstoarrive=0.2,
					pos=lh:GetPos(),
					angle=phys:GetAngles(),
					maxangulardamp=10,
					maxspeeddamp=10,
					maxangular=50,
					maxspeed=speed,
					teleportdistance=0,
					deltatime=deltatime,
				}
				phys:Wake()
				phys:ComputeShadowControl(shadowparams)
			end
		end
		if(ply:KeyDown(IN_FORWARD) and IsValid(rag.ZacConsRH))then
			local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Spine" )) )
			local rh = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),90)
			local speed = 15
			
			if(rag.ZacConsRH.Ent2:GetVelocity():LengthSqr()<1000)then
				local shadowparams = {
					secondstoarrive=0.2,
					pos=rh:GetPos(),
					angle=phys:GetAngles(),
					maxangulardamp=10,
					maxspeeddamp=10,
					maxangular=50,
					maxspeed=speed,
					teleportdistance=0,
					deltatime=deltatime,
				}
				phys:Wake()
				phys:ComputeShadowControl(shadowparams)
				--[[
				shadowparams.pos=phys:GetPos()+ply:EyeAngles():Right()*300
				rag:GetPhysicsObjectNum( 9 ):Wake()
				rag:GetPhysicsObjectNum( 9 ):ComputeShadowControl(shadowparams)				-переделывай говно
				shadowparams.pos=phys:GetPos()-ply:EyeAngles():Forward()*300
				rag:GetPhysicsObjectNum( 11 ):Wake()
				rag:GetPhysicsObjectNum( 11 ):ComputeShadowControl(shadowparams)
				shadowparams.pos=rh:GetPos()
				--]]
				--[[local angre2=ply:EyeAngles()
				angre2:RotateAroundAxis(ply:EyeAngles():Forward(),90)
				shadowparams.angle=angre2
				shadowparams.maxangular=100
				shadowparams.pos=rag:GetPhysicsObjectNum( 1 ):GetPos()
				shadowparams.secondstoarrive=1
				rag:GetPhysicsObjectNum( 0 ):Wake()
				rag:GetPhysicsObjectNum( 0 ):ComputeShadowControl(shadowparams)]]--
			end
		end
		if(ply:KeyDown(IN_BACK) and IsValid(rag.ZacConsLH))then
			local phys = rag:GetPhysicsObjectNum( 1 )
			local chst = rag:GetPhysicsObjectNum( 0 )
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),90)
			local speed = 30
			
			if(rag.ZacConsLH.Ent2:GetVelocity():LengthSqr()<1000)then
				local shadowparams = {
					secondstoarrive=0.3,
					pos=chst:GetPos(),
					angle=phys:GetAngles(),
					maxangulardamp=10,
					maxspeeddamp=10,
					maxangular=50,
					maxspeed=speed,
					teleportdistance=0,
					deltatime=deltatime,
				}
				phys:Wake()
				phys:ComputeShadowControl(shadowparams)
			end
		end
		if(ply:KeyDown(IN_BACK) and IsValid(rag.ZacConsRH))then
			local phys = rag:GetPhysicsObjectNum( 1 )
			local chst = rag:GetPhysicsObjectNum( 0 )
			local angs = ply:EyeAngles()
			angs:RotateAroundAxis(angs:Forward(),90)
			angs:RotateAroundAxis(angs:Up(),90)
			local speed = 30
			
			if(rag.ZacConsRH.Ent2:GetVelocity():LengthSqr()<1000)then
				local shadowparams = {
					secondstoarrive=0.5,
					pos=chst:GetPos(),
					angle=phys:GetAngles(),
					maxangulardamp=10,
					maxspeeddamp=10,
					maxangular=50,
					maxspeed=speed,
					teleportdistance=0,
					deltatime=deltatime,
				}
				phys:Wake()
				phys:ComputeShadowControl(shadowparams)
			end
		end
	end
end)

hook.Add("PlayerSpawn", "creeper", function(ply)
	ply:SetNWBool("InSight_RAG", false)
end)

hook.Add("KeyPress", "cock", function(ply,key)
	if ply.fake and ply:GetNWBool("InSight_RAG", false) == false and key == IN_JUMP then
		ply:SetNWBool("InSight_RAG", true)
	return end
	if ply.fake and ply:GetNWBool("InSight_RAG", false) == true and key == IN_JUMP then
		ply:SetNWBool("InSight_RAG", false)
	return end
end)

hook.Add("Player Think","VelocityPlayerFallOnPlayerCheck",function(ply,time)
	local speed = ply:GetVelocity():Length()
	if ply:GetMoveType() != MOVETYPE_NOCLIP and not ply.fake and not ply:HasGodMode() and ply:Alive() then
		if speed < 550 then return end
		if hook.Run("Should Fake Velocity",ply,speed) ~= nil then return end

		Faking(ply)
	end
end)
util.AddNetworkString("ebal_chellele")
hook.Add("PlayerSwitchWeapon","fakewep",function(ply,oldwep,newwep)
	if ply.Otrub then return true end

	if ply.fake then
		if IsValid(ply.Info.ActiveWeapon2) and IsValid(ply.wep) and ply.wepClip~=nil and ply.wep.Amt~=nil and ply.wep.AmmoType~=nil then
			ply.Info.ActiveWeapon2:SetClip1((ply.wepClip or 0))
			ply:SetAmmo((ply.wep.Amt or 0), (ply.wep.AmmoType or 0))
		end

		if table.HasValue(Guns,newwep:GetClass()) then
			if IsValid(ply.wep) then DespawnWeapon(ply) end
			ply:SetActiveWeapon(newwep)
			ply.Info.ActiveWeapon=newwep
			ply.curweapon=newwep:GetClass()
			SavePlyInfo(ply)
			ply:SetActiveWeapon(nil)
			SpawnWeapon(ply)
			ply.FakeShooting=true
		else
			if IsValid(ply.wep) then DespawnWeapon(ply) end
			ply:SetActiveWeapon(nil)
			ply.curweapon=nil
			ply.FakeShooting=false
		end
		net.Start("ebal_chellele")
		net.WriteEntity(ply)
		net.WriteString(ply.curweapon or "")
		net.Broadcast()
		return true
	end
end)

function PlayerMeta:HuySpectate()
	local ply = self
	ply:Spectate(OBS_MODE_CHASE)
	ply:UnSpectate()

	ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	ply:SetMoveType(MOVETYPE_OBSERVER)
end

OrgansNextThink = 0
InternalBleeding = 20
local player_GetAll = player.GetAll

concommand.Add("checha_o2_minus", function(ply)
	ply.o2 = ply.o2 - 0.1
end)

hook.Add("Player Think","InternalBleeding",function(ply,time)
	for i,ply in pairs(player_GetAll()) do
		ply.OrgansNextThink = ply.OrgansNextThink or OrgansNextThink

		if ply.o2 < 0 then
			ply:ChatPrint("Вы задохнулись.")
			ply:Kill()
			ply.o2 = 1
		end
		if not(ply.OrgansNextThink>CurTime())then
			ply.OrgansNextThink=CurTime() + 0.08
			if ply.Organs and ply:Alive() then
				if ply.holdbreath then
					ply.o2 = ply.o2 - math.Rand(0.01,0.02)
				end
				if ply.Organs["brain"]==0 then
					ply.KillReason = "braindeath"
					ply:Kill()
				end
				if ply.Organs["liver"]==0 then
					ply.InternalBleeding=ply.InternalBleeding or InternalBleeding
					ply.InternalBleeding=math.max(ply.InternalBleeding-0.1,0)
					ply.Blood=ply.Blood-ply.InternalBleeding / 10
				end
				if ply.Organs["stomach"]==0 then
					ply.InternalBleeding2=ply.InternalBleeding2 or InternalBleeding
					ply.InternalBleeding2=math.max(ply.InternalBleeding2-0.1,0)
					ply.Blood=ply.Blood-ply.InternalBleeding2 / 10
				end
				if ply.Organs["intestines"]==0 then
					ply.InternalBleeding3=ply.InternalBleeding3 or InternalBleeding
					ply.InternalBleeding3=math.max(ply.InternalBleeding3-0.1,0)
					ply.Blood=ply.Blood-ply.InternalBleeding3 / 10
				end
				if ply.Organs["heart"]==0 then
					ply.InternalBleeding4=ply.InternalBleeding4 or InternalBleeding
					ply.InternalBleeding4=math.max(ply.InternalBleeding4*10-0.1,0)
					ply.Blood=ply.Blood-ply.InternalBleeding4*3 / 10
				end
				if ply.Organs["lungs"]==0 then
					ply.InternalBleeding5=ply.InternalBleeding5 or InternalBleeding
					ply.InternalBleeding5=math.max(ply.InternalBleeding5-0.1,0)
					if ply.o2 > 0 then
						ply.o2 = ply.o2 - math.Rand(0.01,0.03)
					end
					ply.Blood=ply.Blood-ply.InternalBleeding5 / 10
				end
				ply.InternalBleeding6 = ply.InternalBleeding6 or 0
				ply.InternalBleeding6 = math.max(ply.InternalBleeding6-0.1,0)
				ply.Blood = ply.Blood - ply.InternalBleeding6 / 10

				if ply.Organs["spine"]==0 then
					ply.brokenspine=true
					if !ply.fake then Faking(ply) end
				end
			end
		end
	end
end)

concommand.Add("checha_getinternalbleeding", function(ply,cmd,args)

	local huyply = args[1] and player.GetListByName(args[1])[1] or ply

	print("bleed1: ",huyply.InternalBleeding)
	print("bleed2: ",huyply.InternalBleeding2)
	print("bleed3: ",huyply.InternalBleeding3)
	print("bleed4: ",huyply.InternalBleeding4)
	print("bleed5: ",huyply.InternalBleeding5)
	print("bleed6: ", huyply.InternalBleeding6)
	print("----")
	print("bloodlosing: ",huyply.Bloodlosing)
end)

hook.Add("PlayerUse","nouseinfake",function(ply,ent)
	local class = ent:GetClass()

	if class == "prop_physics" or class=="prop_physics_multiplayer" or class == "func_physbox" then
		local PhysObj = ent:GetPhysicsObject()
		if PhysObj and PhysObj.GetMass and PhysObj:GetMass() > 14 then return false end
	end

	if ply.fake then return false end
	--if ent.IsJModArmor then return false end
end)

concommand.Add("+closeeye", function(ply)
	ply.fakeragdoll = ply:GetNWEntity("Ragdoll")
	local rag = ply.fakeragdoll
    if ply:GetNWBool("CloseEye", false) == false and !ply.fake and ply:Alive() then
		ply:SetFlexWeight(9, 10)
		ply:SetNWBool("CloseEye", true)
	end
    if ply:GetNWBool("CloseEye", false) == false and !ply.fake and ply:Alive() then
		ply:SetFlexWeight(9, 10)
		ply:SetNWBool("CloseEye", true)
	end

	if ply:GetNWBool("CloseEye", false) == false and ply.fake and ply:Alive() then
		rag:SetFlexWeight(9, 10)
		ply:SetNWBool("CloseEye", true)
	end
    if ply:GetNWBool("CloseEye", false) == false and ply.fake and ply:Alive() then
		rag:SetFlexWeight(9, 10)
		ply:SetNWBool("CloseEye", true)
	end
end)

concommand.Add("-closeeye", function(ply)
	ply.fakeragdoll = ply:GetNWEntity("Ragdoll")
	local rag = ply.fakeragdoll
	if ply:GetNWBool("CloseEye", false) == true and !ply.fake and ply:Alive() then
		ply:SetNWBool("CloseEye", false)
		ply:SetFlexWeight(9, 0)
	end
	if ply:GetNWBool("CloseEye", false) == true and !ply.fake and ply:Alive() then
		ply:SetNWBool("CloseEye", false)
		ply:SetFlexWeight(9, 0)
	end

	if ply:GetNWBool("CloseEye", false) == true and ply.fake and ply:Alive() then
		ply:SetNWBool("CloseEye", false)
		rag:SetFlexWeight(9, 0)
	end
	if ply:GetNWBool("CloseEye", false) == true and ply.fake and ply:Alive() then
		ply:SetNWBool("CloseEye", false)
		rag:SetFlexWeight(9, 0)
	end
end)

concommand.Add("checha_getotrub",function(ply,cmd,args)
	local huyply = args[1] and player.GetListByName(args[1])[1] or ply
	print(huyply.Otrub)
end)

hook.Add("PlayerSay","dropweaponhuy",function(ply,text)
    if string.lower(text)=="*drop" then
        if !ply.fake then
            ply:DropWeapon1()
            return ""
        else
            if IsValid(ply.wep) then
                if IsValid(ply.WepCons) then
                    ply.WepCons:Remove()
                    ply.WepCons=nil
                end
                if IsValid(ply.WepCons2) then
                    ply.WepCons2:Remove()
                    ply.WepCons2=nil
                end
                ply.wep.canpickup=true
                ply.wep:SetOwner()
                ply.wep.curweapon=ply.curweapon
                ply.Info.Weapons[ply.Info.ActiveWeapon].Clip1 = ply.wepClip
                ply:StripWeapon(ply.Info.ActiveWeapon)
                ply.Info.Weapons[ply.Info.ActiveWeapon]=nil
                ply.wep=nil
                ply.Info.ActiveWeapon=nil
                ply.Info.ActiveWeapon2=nil
                ply:SetActiveWeapon(nil)
                ply.FakeShooting=false
            else
                ply:PickupEnt()
            end
            return ""
        end
    end

	if string.lower(text)=="!viptest" then
		if !ply.fake then
		ply:SetVelocity( Vector(0,0,50000) )
		timer.Simple( 5, function()
			ply:Ban(1,false)
			ply:Kick("Ну как тебе ВИП ТЕСТ!!! минутка бана))))")

		end)
		else
		ply:GetNWEntity("Ragdoll"):GetPhysicsObjectNum(0):SetVelocity( Vector(0,0,50000) )
		timer.Simple( 5, function()
			ply:Ban(1,false)
			ply:Kick("Ну как тебе ВИП ТЕСТ!!! хи фейк не поможет, жди минуту")
		end)
		end
	end
end)

hook.Add("UpdateAnimation","huy",function(ply,event,data)
	ply:RemoveGesture(ACT_GMOD_NOCLIP_LAYER)
end)

hook.Add("Player Think","holdentity",function(ply,time)
	--[[if IsValid(ply.holdEntity) then

	end--]]
end)

concommand.Add("checha_getflexname", function(ply,cmd,args)
	local huyply = args[1] and player.GetListByName(args[1])[1] or ply
	print(huyply:GetFlexName(args[2] or 0))
end)

concommand.Add("checha_getflexid", function(ply,cmd,args)
	local huyply = args[1] and player.GetListByName(args[1])[1] or ply
	print(huyply:GetFlexIDByName(args[2] or 0, args[3] or ""))
end)

concommand.Add("checha_setflexweight", function(ply,cmd,args)
	local huyply = args[1] and player.GetListByName(args[1])[1] or ply
	huyply:SetFlexWeight(args[2] or 0, args[3] or 0)
end)

concommand.Add("checha_setfingerpose3", function(ply,cmd,args)
	local huyply = args[1] and player.GetListByName(args[1])[1] or ply
	huyply:ManipulateBoneAngles( huyply:LookupBone("ValveBiped.Bip01_R_Finger01"), Angle(0,20,0), true )
	huyply:ManipulateBoneAngles( huyply:LookupBone("ValveBiped.Bip01_R_Finger11"), Angle(0,-40,0), true )
	huyply:ManipulateBoneAngles( huyply:LookupBone("ValveBiped.Bip01_R_Finger21"), Angle(0,-40,0), true )
	huyply:ManipulateBoneAngles( huyply:LookupBone("ValveBiped.Bip01_R_Finger31"), Angle(0,-40,0), true )
	huyply:ManipulateBoneAngles( huyply:LookupBone("ValveBiped.Bip01_R_Finger41"), Angle(0,-40,0), true )
end)

concommand.Add("soundplay", function(ply,cmd,args)
	sound.Play(args[1] or "", ply:GetPos(), 75, 100)
end)

concommand.Add("checha_testang", function(ply,cmd,args)
	local huyply = args[1] and player.GetListByName(args[1])[1] or ply
	local pepsi = LerpAngle(0.05,Angle(0,60,0),Angle(60,0,60))
	huyply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),pepsi,false)
end)

hook.Add("PlayerPostThink","blinkkk", function(ply)
	ply.fakeragdoll = ply:GetNWEntity("Ragdoll")
	local rag = ply.fakeragdoll
	if not ply:Alive() then return end
	if !ply.fake then return end
	if ply.fake and ply.Otrub then
		rag:SetFlexWeight(9, 1)
		ply:ConCommand("say *drop")
	end
	if ply.fake and !ply.Otrub then
		rag:SetFlexWeight(9, 0)
	end
end)

hook.Add("PostPlayerDeath","BlinkRag", function(ply)
	if ply:GetNWBool("fake") == true and ply.Organs["brain"]!=0 then
		ply.fakeragdoll = ply:GetNWEntity("Ragdoll")
		local rag = ply.fakeragdoll
		rag:SetFlexWeight(9, 1)
	end
end)

hook.Add("PlayerSay", "unconsay", function(ply,text)
	if not roundActive then return end
	if ply.Otrub and ply:Alive() then return false end
end)

hook.Add("DoPlayerDeath", "lolkekcheburek", function(ply)
	timer.Simple(.1,function() ply:ConCommand("say *drop") end)
end)