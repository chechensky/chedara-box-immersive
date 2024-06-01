SWEP.Base = 'weapon_base' -- base

SWEP.PrintName 				= "weapon_sib_base"
SWEP.Author 				= "sadsalat"
SWEP.Instructions			= "Salatis Imersive Base"
SWEP.Purpose 				= "Raise weapon - Hold RMB\nOn Rised: Rise sight - MWUP, Down sight - MWDOWN\nShoot - LMB"
SWEP.Category 				= "SIB"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.HoldType  =  "revolver"

SWEP.OverridePaintIcon = OverridePaintIcon

------------------------------------------

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/fiveseven/fiveseven-1.wav"
SWEP.Primary.FarSound = ""
SWEP.Primary.Force = 0
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.072
SWEP.NextShot = 0
SWEP.Sight = false
SWEP.Shell = "EjectBrass_9mm"
SWEP.ShellRotate = true
SWEP.ShellRotateUp = false

SWEP.ReloadSounds = {                                   -- [0.1] = {""}
}           											-- playtime soundpatch
SWEP.TwoHands = false

SWEP.vbw = true
SWEP.vbwPos = false
SWEP.vbwAng = false

SWEP.CSMuzzleFlashes = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.addAng = zeroAng -- Barrel ang adjust
SWEP.addPos = zeroVec -- Barrel pos adjust
SWEP.SightPos = zeroVec
SWEP.SightAng = zeroAng -- Sight ang

SWEP.DoFlash = true

SWEP.Mobility = 0.2

SWEP.setAng = zeroAng -- dont change
SWEP.Sightded = false --dont change

local zeroAng = Angle(0,0,0) or zeroAng
local zeroVec = Vector(0,0,0) or zeroVec

sib_wep = sib_wep or {}
SWEP.WElements = {}
function SWEP:Initialize()
    sib_wep[self] = true
   -- PrintTable(sib_wep)
	self.magazines = 0
	self:SetNWBool("WEP_SupressorAK", false)
    self:SetNWBool("WEP_Supressor", false)
	self:SetNWBool("Sight", false)
	self.emptyclicked_uzhe = false
	if CLIENT then
		self:SetPredictable(true)
	end

    self:SetHoldType(self.HoldType)
	if CLIENT then
		self.WElements = table.FullCopy( self.WElements )
		self:CreateModels(self.WElements) -- create worldmodels
	end
end

if CLIENT then
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = zeroVec, zeroAng
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) --// recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:Reload()
    local ply = self:GetOwner()
	if timer.Exists("reload"..self:EntIndex())  or self:Clip1()>=self:GetMaxClip1() or self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )<=0 then return nil end
	if ply:IsSprinting() then return nil end
	if ( self.NextShot > CurTime() ) then return end
	timer.Simple(.1,function() ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroAng) ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),zeroAng) ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroVec) end)
	self:SetNWBool("Reloading",true)
	if self.Category == "Chedara Box - Дробовики" then
		self:SetHoldType("shotgun")
		timer.Simple(.8,function()
			self:SetHoldType(self.HoldType)
		end)
	end
	if self.HoldType == "revolver" then
		self:SetHoldType("pistol")
		timer.Simple(.8,function()
			self:SetHoldType(self.HoldType)
		end)
	end
	if self:GetHoldType() == "rpg" then
		self:SetHoldType("ar2")
		timer.Simple(.8,function()
			self:SetHoldType(self.HoldType)
		end)
	end
	timer.Simple(.1,function()
		ply:SetAnimation(PLAYER_RELOAD)
	end)
	if SERVER then
		if self:Clip1()<1 then
			if self:GetClass() == "weapon_sib_akm" or self:GetClass() == "weapon_sib_aks74u" then
        		local pos = ply:GetPos() + Vector(0, 0, 120)
        		local ent = ents.Create("prop_physics")
        		if IsValid(ent) then
        	    	ent:SetModel("models/btk/nam_akmmag.mdl")
        	    	ent:SetPos(pos)
        	    	ent:SetAngles(ply:EyeAngles())
        	    	ent:Spawn()
					ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        		end
			elseif self:GetClass() == "weapon_sib_glock" or self:GetClass() == "weapon_sib_usp" or self:GetClass() == "weapon_sib_usp-s" then
        		local pos = ply:GetPos() + Vector(0, 0, 120)
        		local ent = ents.Create("prop_physics")
        		if IsValid(ent) then
        	    	ent:SetModel("models/weapons/arc9/darsu_eft/mods/mag_glock_std_17.mdl")
        	    	ent:SetPos(pos)
        	    	ent:SetAngles(ply:EyeAngles())
        	    	ent:Spawn()
					ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        		end
			end
		end
	end
	self.emptyclicked_uzhe = false
	timer.Create( "reload"..self:EntIndex(), self.ReloadTime, 1, function()
			if IsValid(self) and IsValid(ply) and ply:GetActiveWeapon()==self and self:GetNWBool("Reloading") then
			local oldclip = self:Clip1()
			self:SetClip1(math.Clamp(self:Clip1()+self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() ),0,self:GetMaxClip1()))
			local needed = self:Clip1()-oldclip
			ply:SetAmmo(self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )-needed, self:GetPrimaryAmmoType())
			self:SetNWBool("Reloading",false)
		end
	end)
	if SERVER then
    	self:ReloadSound()
	end
end

function SWEP:PrimaryAttack()
	self.ShootNext = self.NextShot or NextShot
	if not IsFirstTimePredicted() then return end
	if self.NextShot > CurTime() then return end
	if timer.Exists("reload"..self:EntIndex()) then return end
	if self.Owner:IsSprinting() then return end
    if !self.Sightded then return end
	if self:Clip1()<1 then 
		if !self.emptyclicked_uzhe then 
			self:EmitSound("snd_jack_hmcd_click.wav",55,100,1,CHAN_ITEM,0,0) 
			self.emptyclicked_uzhe = true
			timer.Simple(1.1, function() 
				if self.emptyclicked_uzhe then 
					self.emptyclicked_uzhe = false 
				end 
			end) 
		end
		self.NextShot = CurTime() + self.ShootWait return end

	local ply = self:GetOwner() 
	self.NextShot = CurTime() + self.ShootWait*1.2
	if self:GetClass() == "weapon_sib_mosin" then
		timer.Simple(.1, function() ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),zeroAng,true) end)
		self:EmitSound("snd_jack_hmcd_boltcycle.wav",55,100,1,CHAN_ITEM,0,0)
		if self:GetHoldType() != "ar2" then self:SetHoldType("ar2") end
		timer.Simple(.1, function()
			ply:SetAnimation(PLAYER_RELOAD)
		end)
	end
	if self.Category == "Chedara Box - Дробовики" and self:GetClass() != "weapon_sib_xm1014" then
		self:EmitSound("weapons/tfa_ins2/nova/nova_pumpback.wav",55,100,1,CHAN_ITEM,0,0)
		timer.Simple(.2, function() self:EmitSound("weapons/tfa_ins2/nova/nova_pumpforward.wav",55,100,1,CHAN_ITEM,0,0) end)
	end
	if ply:GetNWFloat("Skill") >= 0.1 and ply:GetNWFloat("Skill") <= 3 and math.random(1,10) == 6 then
		sound.Play("snd_jack_hmcd_fart.wav", ply:GetPos(), 75, 100)
	end
	if SERVER then
		net.Start("huysound")
			net.WriteVector(self:GetPos())
			net.WriteString(self.Primary.Sound)
			net.WriteString(self.Primary.FarSound)
			net.WriteEntity(ply)
		net.Broadcast()
	else
		if self:GetNWBool("WEP_Supressor", false) == false then self:EmitSound(self.Primary.Sound,100,math.random(100,120),1,CHAN_WEAPON,0,0) else self:EmitSound(self.Primary.Suppsound,100,math.random(100,120),1,CHAN_WEAPON,0,0) end
	end
	--self.Forearm = self.Forearm + Angle(self.Primary.Force/10,-self.Primary.Force/10,0)--RotateAroundAxis(ply:EyeAngles():Right()*1,self.Primary.Force/5)
	--self.Forearm:RotateAroundAxis(ply:EyeAngles():Up()*-1,self.Primary.Force/10) --+ Angle(1,-0.5,-2)*self.Primary.Force/30

	local dmg = self.Primary.Damage--self.TwoHands and self.Primary.Damage * 2 or self.Primary.Damage
    self:FireBullet(dmg, 1, 5)
    if CLIENT and ply == LocalPlayer() then
        self:ShootPunch(self.Primary.Force)
		lastShootSib = CurTime() + 0.25*self.Primary.Force/50
	end
	self:SetNWFloat("VisualRecoil", self:GetNWFloat("VisualRecoil")+3.5)
end

hook.Add("PlayerSwitchWeapon", "DrawSounds", function(ply, old, new)
	print(new.Category)
	if new.Category == "Chedara Box - Пистолеты" then
		sound.Play("pwb/weapons/glock17/cloth.wav",  ply:GetPos(), 75, 100)
	end
	if string.find(new:GetClass(), "knife") or new:GetClass() == "weapon_kabar" or new:GetClass() == "weapon_hg_hatchet" or new:GetClass() == "weapon_gurkha" then
		sound.Play("snd_jack_hmcd_knifedraw.wav",  ply:GetPos(), 75, 100)
	end
	if new.Category == "Chedara Box - Винтовки" then
		sound.Play("weapons/tfa_inss/asval/draw.wav",  ply:GetPos(), 75, 100)
	end
end)

function easedLerpAng1(fraction, from, to)
	return LerpAngle(math.ease.OutBack(fraction), from, to)
end

-- Custom Think
hook.Add("Think","fwep-customThinker",function()
	for wep in pairs(sib_wep) do
		if not IsValid(wep) then sib_wep[wep] = nil continue end

		local owner = wep:GetOwner()
		if not IsValid(owner) or (owner:IsPlayer() and not owner:Alive()) or owner:GetActiveWeapon() ~= wep then continue end--wtf i dont know

		if wep.Step then wep:Step() end
	end
end)

function SWEP:HUDShouldDraw( hud )
	if hud == "CHudWeaponSelection" then
		return not self:GetNWBool("Sighted")
	end
end
-- Think Function

local revolver_clavicle1 = Angle(5,20,-5)
local ar2_clavicle1_up_idle = Angle(10,-15,25)
local ar2_clavicle1_down_idle = Angle(5,15,5)
local other_clavicle1_down_idle = Angle(-4,25,0)
local other_clavicle1_up_idle = Angle(5,-15,10)

local revolver_head2 = Angle(-15,-10,15)
local other_head2 = Angle(0,0,-5)

local uuu = Angle(0, -25, 15)

if SERVER then
	concommand.Add("suicide",function(ply)
		if not ply:Alive() then return end
		ply.suiciding = not ply.suiciding
		ply:SetNWBool("Suiciding",ply.suiciding)
	end)
end

local angZero = Angle(0,0,0)
local angSuicide = Angle(160,30,90)
local angSuicide2 = Angle(160,30,90)
local angSuicide3 = Angle(60,-30,90)
local forearm = Angle(0,0,0)

function SWEP:Step()

	ply = self:GetOwner()
	ply.idleanim = ply:GetNWBool("IdleAnimation")
	self.Sightded = self:GetNWBool("Sighted")
	-- trDistance for walls
	local tr = util.TraceLine( {
		start = ply:EyePos()+zeroVec,
		endpos = ply:EyePos()+zeroVec + ply:EyeAngles():Forward() * 60,
		filter = ply
	} )
	local trdistance = math.Clamp((tr.HitPos:Distance(tr.StartPos)/40),0,1)
	-- SightUp function

	if SERVER then
		if trdistance > 0.99 and ply:KeyDown(IN_ATTACK2) then
			self:SetNWBool("Sighted", true)
		else
			self:SetNWBool("Sighted", false)
		end
	end
	if (!self.Sightded and !self:GetNWBool("Reloading") or ply:IsSprinting()) and !self.Osmotr then
		self.Clavicle = LerpAngle(0.1-math.Clamp(self.Mobility/70,0,0.035),self.Clavicle or zeroAng,other_clavicle1_down_idle)
		self.Head = LerpAngle(0.1,self.Head or zeroAng,zeroAng)
		ply:SetFlexWeight(5, 0)
	else
		self.Clavicle = LerpAngle(0.1-math.Clamp(self.Mobility/70,0,0.035),self.Clavicle or zeroAng,zeroAng)
		self.Head = LerpAngle(0.05,self.Head or zeroAng,(self.HoldType == "revolver" and revolver_head2) or other_head2)
		ply:SetFlexWeight(5, 5)
	end

	if CLIENT then 
		self.Head = LerpAngle(0.05,self.Head or zeroAng,zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),self.Clavicle,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),self.Head,true)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Neck1"),self.Head,true)
	end
	-- Visual recoil 
	if self:GetNWFloat("VisualRecoil")>0 then
		self:SetNWFloat("VisualRecoil",Lerp(0.1,self:GetNWFloat("VisualRecoil") or 0,0))
	end
	if CLIENT and ply != LocalPlayer() then
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"),Angle(0,self:GetNWFloat("VisualRecoil")*-20,0),false)
		ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),Vector(0,self:GetNWFloat("VisualRecoil")*-0.5,0),false)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),Angle(self:GetNWFloat("VisualRecoil")*1.5,0,0),false)		
	end
	
	if CLIENT then
		if ply:GetActiveWeapon().Category == "Chedara Box - Винтовки" then
			if ply:GetActiveWeapon():GetClass() == "weapon_sib_hk416" then
				ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(30,30,0),false)
			elseif ply:GetActiveWeapon():GetClass() == "weapon_sib_rpk" then
				ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(35,18,0),false)
			elseif ply:GetActiveWeapon():GetClass() == "weapon_sib_aks74u" then
				ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(35,18,0),false)
			else
				ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(35,10,0),false)
			end
		elseif ply:GetActiveWeapon().Category == "Chedara Box - Пистолеты" then
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(0,10,0),false)
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger21"),Angle(0,30,0),false)
		elseif ply:GetActiveWeapon().Category == "Chedara Box - Дробовики" then
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger0"),Angle(0,-5,0),false)
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger1"),Angle(10,-10,0),false)
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger2"),Angle(10,-10,0),false)
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger3"),Angle(10,-10,0),false)
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Finger4"),Angle(10,-10,0),false)
		end
	end

	if ply:KeyDown(IN_ZOOM) then
		self:SetHoldType("slam")
		self.Osmotr = true
	elseif self:GetHoldType() == "slam" then
		self:SetHoldType(self.HoldType)
		self.Osmotr = false
	end
	-- Client recoil 

	if CLIENT and ply == LocalPlayer() then
        viewShootPunch = easedLerpAng1(0.01,viewShootPunch,zeroAng)
		self.eyeSpray = self.eyeSpray or zeroAng
		self.Finger = Lerp(0.25, self.Finger or 0, (( ply:KeyDown(IN_ATTACK) and -1 ) or 0))
		
		ply:SetEyeAngles(ply:EyeAngles() + self.eyeSpray)
		ply:ManipulateBoneAngles( ply:LookupBone("ValveBiped.Bip01_R_Finger11"), Angle(0,self.Finger*40,0), false )
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),(self.Osmotr and (self.HoldType == "revolver" and (Angle(15,0,math.sin(CurTime()*0.5)*55)) or (Angle(15,-25,math.sin(CurTime()*0.5)*55))) )or zeroAng,false)
		
		self.eyeSpray = LerpAngle(0.2,self.eyeSpray,zeroAng)
	end

end
function SWEP:SecondaryAttack()
end

-- Holster bone manipulate remover
function SWEP:Holster()
	local ply = self:GetOwner()
	timer.Simple(0.1,function()
		ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroVec)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),zeroAng)	
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Neck1"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"),zeroAng)
		ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroVec)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),zeroAng)
	end)
	self.Clavicle = zeroAng
	self.Head = zeroAng
	self:SetNWFloat("VisualRecoil",0)
	self:SetNWBool("Reloading",false)
	return true
end

-- Death bone manipulate remover
hook.Add( "PlayerSpawn", "Resetbones", function( ply )
	timer.Simple(0.1,function()
		ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroVec)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),zeroAng)	
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Neck1"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"),zeroAng)
		ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroVec)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),zeroAng)
	end)
	ply.Clavicle = zeroAng
	ply.Head = zeroAng
	ply:SetNWFloat("VisualRecoil",0)
	ply:SetNWBool("Reloading",false)
end )

hook.Add( "PlayerDeath", "Resetbones", function( ply )
	timer.Simple(0.1,function()
		ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroVec)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"),zeroAng)	
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Clavicle"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Neck1"),zeroAng)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"),zeroAng)
		ply:ManipulateBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Clavicle"),zeroVec)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"),zeroAng)
	end)
	ply.Clavicle = zeroAng
	ply.Head = zeroAng
	ply:SetNWFloat("VisualRecoil",0)
	ply:SetNWBool("Reloading",false)
end )