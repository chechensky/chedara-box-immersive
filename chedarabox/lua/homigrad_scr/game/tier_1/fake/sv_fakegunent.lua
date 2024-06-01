game.AddDecal("ChBlood1", "decals/checha/ch_blood1")
game.AddDecal("ChBlood2", "decals/checha/ch_blood2")
game.AddDecal("ChBlood3", "decals/checha/ch_blood3")
game.AddDecal("ChBlood4", "decals/checha/ch_blood4")

game.AddDecal("ArBlood1", "decals/checha/ar_blood1")
game.AddDecal("ArBlood2", "decals/checha/ar_blood2")
game.AddDecal("ArBlood3", "decals/checha/ar_blood3")
game.AddDecal("ArBlood4", "decals/checha/ar_blood4")
game.AddDecal("ArBlood5", "decals/checha/ar_blood5")

local bloodpaint = {
	"ChBlood1",
	"ChBlood2",
	"ChBlood3",
	"ChBlood4"
}

Guns = {

	-- melee cool
	"weapon_bat",
	"weapon_hg_sleagehammer",
	"weapon_gurkha",
	"weapon_hg_kitknife",
	"weapon_hg_crowbar",
	"weapon_hg_metalbat",
	"weapon_hg_shovel",
	"weapon_hg_fireaxe",
	"weapon_police_bat",
	"weapon_hg_hatchet",
	"weapon_pipe",
	"weapon_hg_fubar",
	"weapon_hg_stunstick",

	-- grenades
	
	"weapon_hg_type59",
	"weapon_hg_f1",
	"weapon_hg_rgd5",

	-- medicines

	"tourniquet",
	"morphine",
	"painkiller",
	"adrenaline",
	"med_band_small",
	"med_band_big",
	"weapon_sib_smg1",
	"tire",

	-- guns

	"weapon_sib_doublebarrel",
	"weapon_kabar",
	"weapon_hg_hatchet",
	"weapon_sogknife",
	"weapon_sib_fiveseven",
	"weapon_sib_pl14",
	"weapon_sib_m60",
	"weapon_sib_mosin",
	"weapon_sib_pkm",
	"weapon_sib_m3super90",
	"weapon_sib_deagle",
	"weapon_knife",
	"weapon_sib_draco",
	"weapon_sib_glock",
	"weapon_sib_usp",
	"weapon_sib_usp-s",
	"weapon_sib_pm",
	"weapon_sib_p226",
	"weapon_sib_asval",
	"weapon_sib_fal",
	"weapon_sib_hk416",
	"weapon_sib_m4a1",
	"weapon_sib_rpk",
	"weapon_sib_aks74u",
	"weapon_sib_akm",
	"weapon_sib_mp5",
	"weapon_sib_xm1014",
	"weapon_sib_remington870",
	"weapon_sib_scout",
	"weapon_sib_g3sg1",
	"weapon_sib_sr25",
	"weapon_sib_m14",
	"weapon_sib_galil",
	"weapon_sib_p90"
}
bullets = {
	["weapon_sib_m3super90"] = 12,
	["weapon_sib_xm1014"] = 12,
	["weapon_sib_remington870"] = 12
}
cir = {
	["weapon_sib_m3super90"] = 0.02,
	["weapon_sib_xm1014"] = 0.04,
	["weapon_sib_remington870"] = 0.025
}
TwoHandedOrNo = {
	["weapon_sib_draco"] = false,
    ["weapon_bat"] = false,
    ["weapon_hg_sleagehammer"] = false,
    ["weapon_gurkha"] = false,
    ["weapon_hg_kitknife"] = false,
    ["weapon_hg_crowbar"] = false,
    ["weapon_hg_metalbat"] = false,
    ["weapon_hg_shovel"] = false,
    ["weapon_hg_fireaxe"] = false,
    ["weapon_police_bat"] = false,
    ["weapon_hg_hatchet"] = false,
    ["weapon_pipe"] = false,
    ["weapon_hg_fubar"] = false,
    ["weapon_hg_stunstick"] = false,
	["weapon_sib_doublebarrel"]=true,
	["weapon_hg_hatchet"]=false,
	["weapon_sogknife"]=false,
	["weapon_sib_fiveseven"]=false,
	["weapon_sib_pl14"]=false,
	["weapon_sib_m60"]=true,
	["weapon_hg_f1"]=false,
	["weapon_hg_rgd5"]=false,
	["tourniquet"]=false,
	["weapon_knife"] = false,
	["weapon_sib_mosin"] = true,
	["painkiller"] = false,
	["morphine"] = false,
	["adrenaline"] = false,
	["med_band_small"] = false,
	["med_band_big"] = false,
	["tire"] = false,
	["weapon_sib_smg1"] = true,
	["weapon_sib_m3super90"] = true,
	["weapon_sib_deagle"] = false,
	["weapon_sib_glock"] = false,
	["weapon_sib_usp"] = false,
	["weapon_sib_usp-s"] = false,
	["weapon_sib_pm"] = false,
	["weapon_sib_p226"] = false,
	["weapon_sib_asval"] = true,
	["weapon_sib_fal"] = true,
	["weapon_sib_hk416"] = true,
	["weapon_sib_m4a1"] = true,
	["weapon_sib_rpk"] = true,
	["weapon_sib_aks74u"] = true,
	["weapon_sib_akm"] = true,
	["weapon_sib_mp5"] = true,
	["weapon_sib_pkm"] = true,
	["weapon_sib_xm1014"] = true,
	["weapon_sib_remington870"] = true,
	["weapon_sib_scout"] = true,
	["weapon_sib_g3sg1"] = true,
	["weapon_sib_sr25"] = true,
	["weapon_sib_m14"] = true,
	["weapon_sib_galil"] = true,
	["weapon_sib_p90"] = true
}

Vectors = {
["weapon_bat"] = Vector(4, -1, 2),
["weapon_hg_sleagehammer"] = Vector(4, -1, 2),
["weapon_gurkha"] = Vector(4, -1, 2),
["weapon_hg_kitknife"] = Vector(4, -1, 2),
["weapon_hg_crowbar"] = Vector(4, -1, 2),
["weapon_hg_metalbat"] = Vector(4, -1, 2),
["weapon_hg_shovel"] = Vector(4, -1, 2),
["weapon_hg_fireaxe"] = Vector(4, -1, 2),
["weapon_police_bat"] = Vector(4, -1, 2),
["weapon_hg_hatchet"] = Vector(4, -1, 2),
["weapon_pipe"] = Vector(4, -1, 2),
["weapon_hg_fubar"] = Vector(4, -1, 2),
["weapon_hg_stunstick"] = Vector(4, -1, 2),
["weapon_hg_hatchet"] = Vector(13,-1.2,2.4),
["weapon_knife"] = Vector(13,-1.2,2.4),

["weapon_sogknife"]= Vector(0,-1.2,2.4),
["weapon_hg_f1"] = Vector(4,-1,2),
["weapon_hg_rgd5"] = Vector(4,-1,2),
["weapon_hg_type59"]=Vector(4,-1,2),

["tourniquet"] = Vector(4,-1.2,2.2),
["morphine"] = Vector(4,-1.2,2.2),
["painkiller"] = Vector(4,-1.2,2.2),
["adrenaline"] = Vector(4,-1.2,2.2),
["med_band_small"] = Vector(4,-1.2,2.2),
["med_band_big"] = Vector(4,-1.2,2.2),
["tire"] = Vector(4,-1.2,2.2),

["weapon_sib_m3super90"]=Vector(13,-1,2.5),
["weapon_sib_deagle"] = Vector(4,-1,2),
["weapon_sib_draco"] = Vector(12,-1,2),
["weapon_sib_glock"] = Vector(11,-0.4,2.4),
["weapon_sib_usp"] = Vector(4,-1.2,2.2),
["weapon_sib_usp-s"] = Vector(4,-1.2,2.2),
["weapon_sib_pl14"]= Vector(1,-1,1),
["weapon_sib_fiveseven"]=Vector(-2,-1,2.2),
["weapon_sib_pm"] = Vector(4,-1,2.2),
["weapon_sib_p226"] = Vector(4,-1,2.2),
["weapon_sib_asval"] = Vector(2,-1,2),
["weapon_sib_mosin"] = Vector(9,-1,-2),
["weapon_sib_fal"] = Vector(12,-2,2),
["weapon_sib_hk416"] = Vector(4,-2,2),
["weapon_sib_m4a1"] = Vector(12,-2,2),
["weapon_sib_aks74u"] = Vector(12,-2,2),
["weapon_sib_akm"] = Vector(12,-1,2),
["weapon_sib_rpk"]= Vector(2,-3,-2),
["weapon_sib_smg1"]= Vector(12,0,-2),
["weapon_sib_mp5"] = Vector(5,-2,2),
["weapon_sib_pkm"] = Vector(12,0,2),
["weapon_sib_m60"] = Vector(7,0,2),
["weapon_sib_xm1014"] = Vector(14,-2,3),
["weapon_sib_remington870"] = Vector(0,-2,0),
["weapon_sib_doublebarrel"] = Vector(0,-2,0),
["weapon_sib_scout"] = Vector(12,-2,3),
["weapon_sib_g3sg1"] = Vector(12,-2,2),
["weapon_sib_sr25"] = Vector(12,-2,3),
["weapon_sib_m14"] = Vector(-2,-2,1),
["weapon_sib_galil"] = Vector(12,-2,1),
["weapon_sib_p90"] = Vector(2,-1,3)
}

Vectors2 = {
["weapon_sib_m3super90"]=Vector(12,-3,-2),
["weapon_sib_asval"] = Vector(10,-4,-4),
["weapon_sib_mosin"] = Vector(8,-3,-2),
["weapon_sib_fal"] = Vector(10,-4,-4),
["weapon_sib_hk416"] = Vector(10,-4,-3),
["weapon_sib_m4a1"] = Vector(10,-4,-4),
["weapon_sib_aks74u"] = Vector(10,-4,-4),
["weapon_sib_akm"] = Vector(10,-4,-4),
["weapon_sib_rpk"] = Vector(10,-4,-4),
["weapon_sib_smg1"] = Vector(10,-4,-4),
["weapon_sib_mp5"] = Vector(10,-4,-4),
["weapon_sib_pkm"] = Vector(8.1,-3.19999,-8),
["weapon_sib_m60"]= Vector(12,-3,0),
["weapon_sib_xm1014"] = Vector(12,-4,-3),
["weapon_sib_doublebarrel"]= Vector(12,-4,-3),
["weapon_sib_remington870"] = Vector(12,-4,-3),
["weapon_sib_scout"] = Vector(12,-2,-3),
["weapon_sib_g3sg1"] = Vector(12,-4,-5),
["weapon_sib_sr25"] = Vector(8,-4,-4),
["weapon_sib_m14"] = Vector(12,-4,-2),
["weapon_sib_galil"] = Vector(12,-4,-4),
["weapon_sib_p90"] = Vector(5,-3,-2)
}

vecZero = Vector(0,0,0)
function SpawnWeapon(ply,clip1)
	--local guninfo = ply.GunInfo
	--local guninfo = ply.GunInfo луа очень легкий

	if !IsValid(ply.wep) and table.HasValue(Guns,ply.curweapon) then
		local rag = ply:GetNWEntity("Ragdoll")

		if IsValid(rag) then
			ply.FakeShooting=true
			ply.wep=ents.Create("wep")
			if ply.curweapon == "weapon_sib_mosin" then
				ply.wep:SetModel("models/weapons/tfa_ins2/w_mosin.mdl")
			elseif ply.curweapon == "weapon_sib_draco" then
				ply.wep:SetModel("models/draco/w_draco_chechkin.mdl")
			else
				ply.wep:SetModel(weapons.Get(ply.curweapon).WorldModel or nil)
			end
			ply.wep:SetOwner(ply)
			local vec1=rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetPos()
			local vec2 = vecZero
			vec2:Set((Vectors[ply.curweapon] or Vector(0,0,0)))

			vec2:Rotate(rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetAngles())
			ply.wep:SetPos(vec1+vec2)

			ply.wep:SetAngles(rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetAngles()-Angle(0,0,190))
			
			if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().Category == "Chedara Box - Ближний Бой" then
				ply.wepmelee = true
			end

			if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().Category == "Chedara Box - Гранаты" then
				ply.wepgrenade = true
			end
			--[[local hand = rag:GetBoneMatrix(rag:LookupBone("ValveBiped.Bip01_R_Hand"))
			local handPos,handAng = hand:GetTranslation(),hand:GetAngles()

			ply.wep:SetPos(handPos)
			ply.wep:SetAngles(handAng)

			local handWep = ply.wep:GetBoneMatrix(0)
			local wepPos,wepAng = handWep:GetTranslation(),handWep:GetAngles()
			
			local lpos = ply.wep:GetPos() - wepPos

			ply.wep:SetPos(wepPos + lpos)
			ply.wep:SetAngles(handAng - Angle(20,0,180))
--]]
			ply.wep:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			ply.wep:Spawn()
			ply:SetNWEntity("wep",ply.wep)
			--ply.wep:GetPhysicsObject():SetMass(0)
			--ply.wep.GunInfo = guninfo
			CheckAmmo(ply, ply.wep)
			if !IsValid(ply.WepCons) then
				local cons = constraint.Weld(ply.wep,rag,0,rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )),0,true)
				if IsValid(cons) then
					ply.WepCons=cons
				end
			end
			ply.wep.curweapon = ply.curweapon
			net.Start("ebal_chellele")
			net.WriteEntity(ply)
			net.WriteString(ply.curweapon)
			net.Broadcast()
			rag.wep = ply.wep
			rag.wep:CallOnRemove("inv",remove,rag)
			ply.wep.rag = rag
			ply.wepClip = ply.Info.Weapons[ply.curweapon].Clip1
			ply.wep.AmmoType = ply.Info.Weapons[ply.curweapon].AmmoType
			if ply.wep.curweapon == "weapon_knife" or ply.wep.curweapon == "weapon_sogknife" or ply.wep.curweapon == "weapon_hg_hatchet" then 
				ply.wep.knife = true
				ply.attacking_knife = false
			end

			ply:SetNWString("curweapon",ply.wep.curweapon)
			if (TwoHandedOrNo[ply.curweapon]) then
				ply.wep:GetPhysicsObject():SetMass(1)
				local vec1=rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetPos()
				local vec22 = vecZero
				vec22:Set(Vectors2[ply.curweapon])
				vec22:Rotate(rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetAngles())
				rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) ):SetPos(vec1+vec22)
				local modelhuy = ply:GetModel() == "models/knyaje pack/dibil/sso_politepeople.mdl"
				rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )) ):SetAngles(ply:GetNWEntity("Ragdoll"):GetPhysicsObjectNum( 7 ):GetAngles()-Angle(0,0,modelhuy and 90 or 180))
				if !IsValid(ply.WepCons2) then
					local cons2 = constraint.Weld(ply.wep,rag,0,rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_L_Hand" )),0,true)			--2hand constraint
					if IsValid(cons2) then
						ply.WepCons2=cons2
					end
				end
			end
		end
	end
end

function DespawnWeapon(ply)
	if not ply.Info then return end

	if not ply.Info.Weapons[ply.Info.ActiveWeapon] then return end
	ply.Info.Weapons[ply.Info.ActiveWeapon].Clip1 = ply.wepClip
	ply.Info.ActiveWeapon2=ply.curweapon
	--if ply:Alive() and !ply.wep.pickable then
		if IsValid(ply.wep) and ply:Alive() then
			ply.wep:Remove()
			ply.wep=nil
			ply.wepmelee = nil
			ply.wepgrenade = nil
		elseif IsValid(ply.wep) and !ply:Alive() then
            ply.wep.canpickup=true
            ply.wep:SetOwner(nil)
            ply.wep.curweapon=ply.curweapon
            ply.wep=nil
			ply.wepmelee = nil
			ply.wepgrenade = nil
        end

		if IsValid(ply.WepCons) and ply:Alive() then
			ply.WepCons:Remove()
			ply.WepCons=nil
		elseif IsValid(ply.WepCons) then
			ply.WepCons=nil
		end

		if IsValid(ply.WepCons2) and ply:Alive() then
			ply.WepCons2:Remove()
			ply.WepCons2=nil
		elseif IsValid(ply.WepCons2) then
			ply.WepCons2=nil
		end
		ply.FakeShooting=false
	--[[else
		ply.wep.pickable=true
		ply.wep=nil
		ply.FakeShooting=false
	end--]]
end
Items = {
	['bandage']=1
}
function CheckAmmo(ply, wep)
	--print(ply.Info.ActiveWeapon)
	--print(ply.Info.Weapons[ply.Info.ActiveWeapon].Clip1)
	--print(ply.Info.ActiveWeapon2:GetMaxClip1())
	--if Items[wep] then return end
	--if ply.curweapon=="bandage" then wep:SetModelScale(0.4) end
	if ply:Alive() then
		wep.Clip = ply.Info.Weapons[ply.Info.ActiveWeapon].Clip1 or 0
		wep.MaxClip = ply.Info.ActiveWeapon2:GetMaxClip1() or 0
		--print(ply:GetAmmoCount(ply.Info.ActiveWeapon2:GetPrimaryAmmoType()))
		wep.Amt=ply:GetAmmoCount(ply.Info.ActiveWeapon2:GetPrimaryAmmoType()) or 0
		wep.AmmoType=ply.Info.ActiveWeapon2:GetPrimaryAmmoType() or 0
	else
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) then return end

		wep.Clip = wep:Clip1()
		wep.AmmoType=wep:GetPrimaryAmmoType()
		--print(wep.Clip, wep.AmmoType)
	end
end

function SpawnWeaponEnt(weapon, pos, ply)
    local wep = ents.Create("wep")
    wep:SetModel(GunsModel[weapon])
    wep:SetPos(pos)
    wep:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    wep:Spawn()
    wep:SetAngles(ply:EyeAngles() or Angle(0,0,0))
    wep:GetPhysicsObject():ApplyForceOffset(VectorRand(-2,2),wep:GetPos())
	--wep:GetPhysicsObject():SetMass(500)
    wep.curweapon = ply.curweapon
    wep.Clip = ply.Clip
    wep.AmmoType = ply.AmmoType
    wep.canpickup=true
    return wep
end

function ReloadSound(wep)
    local ply = wep:GetOwner()
	local weptable = weapons.Get(wep.curweapon)
    for k,v in pairs(weptable.ReloadSounds) do
        if istable(k) then return end
        timer.Create(k.."snd"..wep:EntIndex(),tonumber( k, 10 ) or 0.1,1,function()
            if wep:IsValid() then
				wep:GetPhysicsObject():ApplyForceCenter(wep:GetAngles():Up()*100+wep:GetAngles():Forward()*-200)
                if v[1] then
                    wep:EmitSound(v[1], 55, 100, 1, CHAN_AUTO)
                end
            end
        end)
    end
end

function Reload(wep)
	if not wep then return end
	local weptable = weapons.Get(wep.curweapon)
	if !IsValid(wep) then return nil end
	local ply = wep:GetOwner()
	if !timer.Exists("reload"..wep:EntIndex()) and wep.Clip ~= wep.MaxClip and wep.Amt > 0 then
		ReloadSound(wep)
		timer.Create("reload"..wep:EntIndex(), weptable.ReloadTime, 1, function()
			if IsValid(wep) then
				local oldclip = wep.Clip
				wep.Clip = math.Clamp(wep.Clip + wep.Amt, 0, wep.MaxClip)
				local needed = wep.Clip - oldclip
				wep.Amt=wep.Amt-needed
				ply.Info.Ammo[wep.AmmoType]=wep.Amt
			end
		end)
	end
end

NextShot = 2
local lastAttackTime = 0
local attackDelay = 0.4

HMCD_SurfaceHardness={
    [MAT_METAL]=.95,[MAT_COMPUTER]=.95,[MAT_VENT]=.95,[MAT_GRATE]=.95,[MAT_FLESH]=.3,[MAT_ALIENFLESH]=.3,
    [MAT_SAND]=.1,[MAT_DIRT]=.3,[74]=.1,[85]=.2,[MAT_WOOD]=.5,[MAT_FOLIAGE]=.5,
    [MAT_CONCRETE]=.9,[MAT_TILE]=.8,[MAT_SLOSH]=.05,[MAT_PLASTIC]=.3,[MAT_GLASS]=.6
}

local pos = Vector(0,0,0)

function TrownGranade(ply,force,granade)
    local granade = ents.Create(granade)
    granade:SetPos(ply:GetShootPos() +ply:GetAimVector()*10)
	granade:SetAngles(ply:EyeAngles()+Angle(45,45,0))
	granade:SetOwner(ply)
	granade:SetPhysicsAttacker(ply)
    granade:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	granade:Spawn()       
	granade:Arm()
	local phys = granade:GetPhysicsObject()              
	if not IsValid(phys) then granade:Remove() return end                         
	phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
	phys:AddAngleVelocity(VectorRand() * force/2)
end

function FireShot(wep)
	if not IsValid(wep) then return end
	local ply = wep:GetOwner()
	local info = ply.Info
	-- knife

	if ply.wepmelee == true or string.find(wep.curweapon, "knife") or wep.curweapon == "weapon_kabar" then
		if CurTime() < lastAttackTime + attackDelay then return end
			local tr = util.TraceLine({
				start = wep:GetPos(),
				endpos = wep:GetPos() + wep:GetForward() * 60,
				filter = ply
			})
			if RagdollOwner(tr.Entity) == ply then return end
			if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() or tr.Entity:IsRagdoll() then
			local dmginfo = DamageInfo()
			if string.find(wep.curweapon, "knife") or wep.curweapon == "weapon_kabar" or wep.curweapon == "weapon_hg_hatchet" or wep.curweapon == "weapon_gurkha" then dmginfo:SetDamageType( DMG_SLASH ) else dmginfo:SetDamageType(DMG_CLUB) end
			dmginfo:SetAttacker( ply )
			dmginfo:SetDamagePosition( tr.HitPos )
			dmginfo:SetDamageForce( ply:GetForward() * 40 )
			dmginfo:SetDamage( weapons.Get(wep.curweapon).Primary.Damage )
			print("Tr Entity: ", tr.Entity)
			print("Tr Entity Class: ", tr.Entity:GetClass())
			print("Tr Entity RagdollOwner: ", RagdollOwner(tr.Entity))
			print("Player: ", ply)
			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:IsRagdoll() then
				if string.find(wep.curweapon, "knife") or wep.curweapon == "weapon_kabar" or wep.curweapon == "weapon_hg_hatchet" or wep.curweapon == "weapon_gurkha" then  sound.Play("snd_jack_hmcd_knifestab.wav", tr.HitPos, 75, 100) else sound.Play("Flesh.ImpactHard", tr.HitPos, 75, 100) end
				local rag = ply.fakeragdoll
				local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
				local head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )
				local ang=ply:EyeAngles()
				local eyeangs = ply:EyeAngles()
				ang:RotateAroundAxis(eyeangs:Forward(),90)
				ang:RotateAroundAxis(eyeangs:Right(),75)
				local shadowparams = {
					secondstoarrive=0.01,
					pos=head:GetPos()+eyeangs:Forward()*100+eyeangs:Right()*200,
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
			if RagdollOwner(tr.Entity) != ply then tr.Entity:TakeDamageInfo( dmginfo ) end
			lastAttackTime = CurTime()
		end
	end

	if wep.curweapon == "weapon_knife" then
		if CurTime() < lastAttackTime + attackDelay then return end
		local rag = ply.fakeragdoll
		local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
		local head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )
		local ang=ply:EyeAngles()
		local eyeangs = ply:EyeAngles()
		ang:RotateAroundAxis(eyeangs:Forward(),90)
		ang:RotateAroundAxis(eyeangs:Right(),75)
		local shadowparams = {
			secondstoarrive=0.01,
			pos=head:GetPos()+eyeangs:Forward()*2+eyeangs:Right()*5,
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
		local tr = util.TraceLine({
			start = wep:GetPos(),
			endpos = wep:GetPos() + wep:GetForward() * 20,
			filter = ply
		})
		if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() or tr.Entity:IsRagdoll() then
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetAttacker( ply )
			dmginfo:SetDamagePosition( tr.HitPos )
			dmginfo:SetDamageForce( ply:GetForward() * 40 )

			dmginfo:SetDamage( 20 / 1.5 )

			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:IsRagdoll() then
				sound.Play("snd_jack_hmcd_knifestab.wav", tr.HitPos, 75, 100)
		local rag = ply.fakeragdoll
		local phys = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_R_Hand" )) )
		local head = rag:GetPhysicsObjectNum( rag:TranslateBoneToPhysBone(rag:LookupBone( "ValveBiped.Bip01_Head1" )) )
		local ang=ply:EyeAngles()
		local eyeangs = ply:EyeAngles()
		ang:RotateAroundAxis(eyeangs:Forward(),90)
		ang:RotateAroundAxis(eyeangs:Right(),75)
		local shadowparams = {
			secondstoarrive=0.01,
			pos=head:GetPos()+eyeangs:Forward()*100+eyeangs:Right()*200,
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
			tr.Entity:TakeDamageInfo( dmginfo )
			lastAttackTime = CurTime()
			print("god")
		end
	end

	-- gren
	if wep.curweapon == "weapon_hg_f1" then
		ply:StripWeapon(wep.curweapon)
		info.Weapons["weapon_hg_f1"] = nil
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
     	ply:SelectWeapon("weapon_hands")
		TrownGranade(ply,750,"ent_hgjack_f1nade")
	elseif wep.curweapon == "weapon_hg_type59" then
		ply:StripWeapon(wep.curweapon)
		info.Weapons["weapon_hg_type59"] = nil
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
     	ply:SelectWeapon("weapon_hands")
		TrownGranade(ply,750,"ent_hgjack_type59")
	elseif wep.curweapon == "weapon_hg_rgd5" then
		ply:StripWeapon(wep.curweapon)
		info.Weapons["weapon_hg_rgd5"] = nil
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
     	ply:SelectWeapon("weapon_hands")
		TrownGranade(ply,750,"ent_hgjack_rgd5nade")
	end

	if wep.curweapon == "tire" then
		print("Tire used")
		ply:StripWeapon(wep.curweapon)
		info.Weapons["tire"] = nil
		print(table.ToString(info.Weapons, "WEAPONS INFO RAGDOLL:"))
		ply:SelectWeapon("weapon_physgun")
		local healsound = Sound("bandageuse.wav")
    	ply.RightLegbroke = false
    	ply.LeftLegbroke = false
		ply.RightArmbroke = false
		ply.LeftArmbroke = false
		ply.LeftArm = 1
		ply.RightArm = 1
    	ply.RightLeg = 1
    	ply.LeftLeg = 1
		ply:SetNWBool("LeftLeg", ply.LeftLegbroke)
		ply:SetNWBool("RightLeg", ply.RightLegbroke)
		ply:SetNWBool("RightArm", ply.RightArmbroke)
		ply:SetNWBool("LeftArm", ply.LeftArmbroke)
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
        ply:SelectWeapon("weapon_hands")
        ply:EmitSound(healsound)
	elseif wep.curweapon == "adrenaline" then
		print("Adrenaline used")
		ply:StripWeapon(wep.curweapon)
		info.Weapons["adrenaline"] = nil
		print(table.ToString(info.Weapons, "WEAPONS INFO RAGDOLL:"))
		local healsound = Sound("usable_items/item_injector_02_injection.wav")
    	ply.adrenaline = ply.adrenaline + 2

    	if not ply.adrenalineNeed and ply.adrenalineNeed > 4 then ply.adrenalineNeed = ent.adrenalineNeed + 1 end
    	ply:EmitSound(healsound)
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
     	ply:SelectWeapon("weapon_hands")
	elseif wep.curweapon == "med_band_big" then
		print("med_band_big used")
		ply:StripWeapon(wep.curweapon)
		info.Weapons["med_band_big"] = nil
		print(table.ToString(info.Weapons, "WEAPONS INFO RAGDOLL:"))
		local healsound1 = Sound("bandageuse.wav")
		local healsound2 = Sound("medkituse0.wav")
	
		if ply.Bloodlosing > 0 then
			ply.Bloodlosing = math.max(ply.Bloodlosing - 65,0)
			if ply.Bloodlosing == 0 then
				ply:EmitSound(healsound1)
			else
				ply:EmitSound(healsound2)
			end
		end
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
        ply:SelectWeapon("weapon_hands")
	elseif wep.curweapon == "med_band_small" then
		print("med_band_small used")
		ply:StripWeapon(wep.curweapon)
		info.Weapons["med_band_small"] = nil
		print(table.ToString(info.Weapons, "WEAPONS INFO RAGDOLL:"))
		local healsound1 = Sound("bandageuse.wav")
		local healsound2 = Sound("medkituse0.wav")
	
		if ply.Bloodlosing > 0 then
			ply.Bloodlosing = math.max(ply.Bloodlosing - 25,0)

			if ply.Bloodlosing == 0 then
				ply:EmitSound(healsound1)
			else
				ply:EmitSound(healsound2)
			end
		end
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
        ply:SelectWeapon("weapon_hands")
	elseif wep.curweapon == "tourniquet" then
		print("Tourniquet used")
		ply:StripWeapon(wep.curweapon)
		info.Weapons["tourniquet"] = nil
		print(table.ToString(info.Weapons, "WEAPONS INFO RAGDOLL:"))

		local healsound = Sound("usable_items/item_injector_02_injection.wav")
		if ply.RightHandArtery == true and ply.RH_Gut == false then
        	ply.RH_Gut = true
        	ply.RightHandArtery = false
        	JMod.EZ_Equip_Armor(ply, "RHandTourniquet")
        	ply.pain = ply.pain + 10
        	eplynt:EmitSound(healsound)
    	elseif ply.LeftHandArtery == true and ply.LH_Gut == false then
    	    ply.LH_Gut = true
    	    ply.LeftHandArtery = false
    	    JMod.EZ_Equip_Armor(ply, "LHandTourniquet")
    	    ply.pain = ply.pain + 10
    	    ply:EmitSound(healsound)
		elseif ply.LeftLegArtery == true and ply.LL_Gut == false then
    	    JMod.EZ_Equip_Armor(ply, "LLegTourniquet")
    	    ply.LL_Gut = true
    	    ply.LeftLegArtery = false
    	    ply.pain = ply.pain + 10
    	    ply:EmitSound(healsound)
		elseif ply.RightLegArtery == true and ply.RL_Gut == false then
    	    JMod.EZ_Equip_Armor(ply, "RLegTourniquet")
    	    ply.RL_Gut = true
    	    ply.RightLegArtery = false
    	    ply.pain = ply.pain + 10
    	    ply:EmitSound(healsound)
    	end

	elseif wep.curweapon == "morphine" then
		print("morphine used")
		ply:StripWeapon(wep.curweapon)
		info.Weapons["morphine"] = nil
		print(table.ToString(info.Weapons, "WEAPONS INFO RAGDOLL:"))
		local healsound = Sound("usable_items/item_injector_02_injection.wav")

    	ply.pain = math.max(ply.pain - 400,0)
    	ply.painlosing = ply.painlosing + 3
    	ply:EmitSound(healsound)

		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
        ply:SelectWeapon("weapon_hands")
	elseif wep.curweapon == "painkiller" then
		print("painkiller used")
		ply:StripWeapon(wep.curweapon)
		info.Weapons["painkiller"] = nil
		print(table.ToString(info.Weapons, "WEAPONS INFO RAGDOLL:"))
		local healsound = Sound("pilluse.wav")

    	ply.painlosing = ply.painlosing + 1
    	ply:EmitSound(healsound)
    	ply:EmitSound(healsound)
		
		ply.wep:Remove()
		ply.wep = nil
		ply.wepmelee = nil
		ply.wepgrenade = nil
		ply:SelectWeapon("weapon_hands")
	end

	local weptable = weapons.Get(wep.curweapon)
	function wep:BulletCallbackFunc(dmgAmt,ply,tr,dmg,tracer,hard,multi)
		if(tr.MatType==MAT_FLESH)then
			util.Decal(table.Random(bloodpaint),tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
			local vPoint = tr.HitPos
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			util.Effect( "BloodImpact", effectdata )
		end
		if(self.NumBullet or 1>1)then return end
		if(tr.HitSky)then return end
		if(hard)then self:RicochetOrPenetrate(tr) end
	end
	function wep:RicochetOrPenetrate(initialTrace)
		local AVec,IPos,TNorm,SMul=initialTrace.Normal,initialTrace.HitPos,initialTrace.HitNormal,HMCD_SurfaceHardness[initialTrace.MatType]
		if not(SMul)then SMul=.5 end
		local ApproachAngle=-math.deg(math.asin(TNorm:DotProduct(AVec)))
		local MaxRicAngle=80*SMul
		if(ApproachAngle>(MaxRicAngle*1.25))then -- all the way through
			local MaxDist,SearchPos,SearchDist,Penetrated=(weapons.Get(wep.curweapon).Primary.Damage/SMul)*.15,IPos,5,false
			while((not(Penetrated))and(SearchDist<MaxDist))do
				SearchPos=IPos+AVec*SearchDist
				local PeneTrace=util.QuickTrace(SearchPos,-AVec*SearchDist)
				if((not(PeneTrace.StartSolid))and(PeneTrace.Hit))then
					Penetrated=true
				else
					SearchDist=SearchDist+5
				end
			end
			if(Penetrated)then
				self:FireBullets({
					Attacker=self:GetOwner(),
					Damage=1,
					Force=1,
					Num=1,
					Tracer=0,
					TracerName="",
					Dir=-AVec,
					Spread=Vector(0,0,0),
					Src=SearchPos+AVec
				})
				self:FireBullets({
					Attacker=self:GetOwner(),
					Damage=weapons.Get(wep.curweapon).Primary.Damage*.65,
					Force=weapons.Get(wep.curweapon).Primary.Force/40,
					Num=1,
					Tracer=0,
					TracerName="",
					Dir=AVec,
					Spread=Vector(0,0,0),
					Src=SearchPos+AVec
				})
			end
		elseif(ApproachAngle<(MaxRicAngle*.75))then -- ping whiiiizzzz
			sound.Play("snd_jack_hmcd_ricochet_"..math.random(1,2)..".wav",IPos,70,math.random(90,100))
			local NewVec=AVec:Angle()
			NewVec:RotateAroundAxis(TNorm,180)
			NewVec=NewVec:Forward()
			self:FireBullets({
				Attacker=self:GetOwner(),
				Damage=weapons.Get(wep.curweapon).Primary.Damage*.85,
				Force=weapons.Get(wep.curweapon).Primary.Force/40,
				Num=1,
				Tracer=0,
				TracerName="",
				Dir=-NewVec,
				Spread=Vector(0,0,0),
				Src=IPos+TNorm
			})
		end
	end

	if !IsValid(wep) then return nil end
	if wep.curweapon == "weapon_knife" or wep.curweapon == "weapon_sogknife" or wep.curweapon == "weapon_hg_hatchet" or wep.curweapon == "weapon_kabar" or wep.curweapon == "weapon_hg_f1" or wep.curweapon == "weapon_hg_type59" or ply.wepmelee == true or ply.wepgrenade == true then return end
	if timer.Exists("reload"..wep:EntIndex()) then return nil end
	local guninfo = wep.GunInfo
	
	wep.NextShot=wep.NextShot or NextShot

	if ( wep.NextShot > CurTime() ) then return end
	print(wep.curweapon)
	if wep.Clip<=0 then
		sound.Play("snd_jack_hmcd_click.wav",wep:GetPos(),65,100)
		wep.NextShot = CurTime() + weptable.ShootWait
	return nil end

	wep.NextShot = CurTime() + weptable.ShootWait*1.2
	if wep.curweapon == "weapon_sib_mosin" then ply:EmitSound("snd_jack_hmcd_boltcycle.wav",55,100,1,CHAN_ITEM,0,0) end

	local Attachment = wep:GetAttachment(wep:LookupAttachment("muzzle"))

	local shootOrigin = Attachment.Pos
	local shootAngles = Attachment.Ang
	local shootDir = shootAngles:Forward()
	local damage = weapons.Get(wep.curweapon).Primary.Damage
	local ply = wep:GetOwner()
	local bullet = {}
		bullet.Num 			= (weptable.NumBullet or 1)
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootDir
		bullet.Spread 		= Vector(cir[wep.curweapon] or 0,cir[wep.curweapon]or 0,0)
		bullet.Tracer		= 1
		bullet.TracerName 	= 4
		bullet.Force		= weptable.Primary.Force / 30
		bullet.Damage		= damage
		bullet.Attacker 	= ply
		bullet.Callback=function(ply,tr,dmgInfo)
			wep:BulletCallbackFunc(damage,ply,tr,damage,false,true,false)
			net.Start("shoot_huy")
				net.WriteTable(tr)
			net.Broadcast()

			if weptable.NumBullet and weptable.NumBullet > 1 then
				local k = math.max(1 - tr.StartPos:Distance(tr.HitPos) / 750,0)
	
				dmgInfo:ScaleDamage(k)
			end

				local ef = EffectData()
				ef:SetEntity( wep )
				ef:SetAttachment( 1 ) -- self:LookupAttachment( "muzzle" )
				ef:SetScale(0.1)
				ef:SetFlags( 7 ) -- Sets the Combine AR2 Muzzle flash
		
				util.Effect( "MuzzleFlash", ef )

		end

	--[[local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootDir
		bullet.Spread 		= 0.05
		bullet.Tracer		= guninfo.Trace
		bullet.TracerName 	= nil
		bullet.Force		= 10
		bullet.Damage		= guninfo.Damage
		bullet.Attacker 	= ply
	--]]
	wep:FireBullets( bullet )
	--wep:EmitSound(weptable.Primary.Sound,511,math.random(100,120),1,CHAN_WEAPON,0,0)
	if SERVER then
		net.Start("huysound")
		net.WriteVector(wep:GetPos())
		net.WriteString(weptable.Primary.Sound)
		net.WriteString(weptable.Primary.FarSound)
		net.WriteEntity(wep)
		net.Broadcast()
	end
	local ply = wep:GetOwner()
	local rag = ply:GetNWEntity("Ragdoll")
	rag:GetPhysicsObjectNum(0):ApplyForceCenter(ply:EyeAngles():Forward()*-weapons.Get(wep.curweapon).Primary.Force*0.35)
	wep:GetPhysicsObject():ApplyForceCenter(wep:GetAngles():Forward()*-weapons.Get(wep.curweapon).Primary.Force*5+wep:GetAngles():Right()*VectorRand(-90,90)+wep:GetAngles():Up()*weapons.Get(wep.curweapon).Primary.Force*15)
	ply:SetEyeAngles(ply:EyeAngles()+Angle(-weapons.Get(wep.curweapon).Primary.Force/10,math.random(-weapons.Get(wep.curweapon).Primary.Force,weapons.Get(wep.curweapon).Primary.Force)/5,0))
	wep.Clip=wep.Clip-1
	ply.wepClip = wep.Clip
	-- Make a muzzle flash
	local obj = wep:LookupAttachment("shell")
	local Attachment = wep:GetAttachment(obj)
	if Attachment then
		local Angles = Attachment.Ang
		if weptable.ShellRotate then Angles:RotateAroundAxis(vector_up,180)  end
		local ef = EffectData()
		ef:SetOrigin(Attachment.Pos)
		ef:SetAngles(Angles)
		ef:SetFlags( 140 ) -- Sets the Combine AR2 Muzzle flash

		util.Effect( weptable.Shell, ef )
	end
end

hook.Add("PlayerSpawn", "chenahui", function(ply)
	ply.wep_attach_sup9x19 = false
	ply.wep_attach_supak = false
	ply.wep_attach_supshotgun = false
	ply.wep_sight_okp7 = false
end)

hook.Add("PlayerDeath", "chenahui", function(ply)
	ply.wep_attach_sup9x19 = false
	ply.wep_attach_supak = false
	ply.wep_attach_supshotgun = false
	ply.wep_sight_okp7 = false
end)