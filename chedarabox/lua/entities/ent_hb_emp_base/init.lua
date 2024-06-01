AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
ENT.Recoil = 0 
function ENT:Initialize()
    self.sightAng = Angle(0,0,0)
    --Init base
    self.IsInitializing = true
	self:SetUseType( SIMPLE_USE )

    self:SetModel(self.BaseModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    --Create Gun

    self.GunEnt = ents.Create( "prop_physics" )
    self.GunEnt:SetModel( self.GunModel )
    self.GunEnt:SetPos( self:GetPos() )
    self.GunEnt:SetAngles( self:GetAngles()+Angle(0,180,0) )

    self.GunEnt:Spawn()
    self.GunEnt:SetMoveType( MOVETYPE_NONE )
    self.GunEnt:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    local phys = self.GunEnt:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion( false )
        phys:EnableCollisions( false )
    end

    --ending
    local phys = self:GetPhysicsObject()

	if(IsValid(phys))then
		phys:Wake()
        --phys:EnableMotion( false )
		--phys:SetMass(150)
        self.IsInitializing = false
	end

    timer.Simple(.1,function() self.IsInitializing = false end)
end

function ENT:Use(taker)
    if self.User == taker then self.User = nil return end
    self.User = taker
end

function ENT:ReloadSound()
    for k,v in pairs(self.ReloadSounds) do
        if istable(k) then return end
        timer.Create(k.."snd"..self:EntIndex(),tonumber( k, 10 ) or 0.1,1,function()
            if self:IsValid() then
                if v[1] then
                    self:EmitSound(v[1], 55, 100, 1, CHAN_AUTO)
                end
            end
        end)
    end
end

function ENT:Reload()
	if !timer.Exists("reload"..self:EntIndex()) and self.Clip ~= self.MaxClip then
		self:ReloadSound()
		timer.Create("reload"..self:EntIndex(), 5, 1, function()
			if IsValid(self) then
                local oldclip = self.Clip
				self.Clip = math.Clamp(self.Clip + 9999, 0, self.MaxClip)
				local needed = self.Clip - oldclip
			end
		end)
	end
end

function ENT:GunShoot(wep)
    local damage = self.Damage
    local force = self.Force
    function wep:BulletCallbackFunc(dmgAmt,ply,tr,dmg,tracer,hard,multi)
		if(tr.MatType==MAT_FLESH)then
			util.Decal("Blood",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
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
			local MaxDist,SearchPos,SearchDist,Penetrated=(damage/SMul)*.15,IPos,5,false
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
					Damage=damage*.65,
					Force=force/40,
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
				Damage=damage*.85,
				Force=force/40,
				Num=1,
				Tracer=0,
				TracerName="",
				Dir=-NewVec,
				Spread=Vector(0,0,0),
				Src=IPos+TNorm
			})
		end
	end

    local Attachment = wep:GetAttachment(wep:LookupAttachment("muzzle"))

	local shootOrigin = Attachment.Pos
	local shootAngles = Attachment.Ang--wep:GetAngles()
	local shootDir = shootAngles:Forward()
	--local damage = 5
	local ply = wep:GetOwner()
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootDir
		bullet.Spread 		= Vector( 0,cir[wep.curweapon]or 0,0)
		bullet.Tracer		= 1
		bullet.TracerName 	= "Tracer"
		bullet.Force		= force / 5
		bullet.Damage		= damage
		bullet.Attacker 	= ply
		bullet.Callback=function(ply,tr)
			wep:BulletCallbackFunc(damage,ply,tr,damage,false,true,false)
			net.Start("shoot_huy")
				net.WriteTable(tr)
			net.Broadcast()
		end

        			
		local ef = EffectData()
		ef:SetEntity( wep )
		ef:SetAttachment( 1 ) -- self:LookupAttachment( "muzzle" )
		ef:SetScale(0.1)
		ef:SetFlags( 1 ) -- Sets the Combine AR2 Muzzle flash
		
		util.Effect( "MuzzleFlash", ef )
        wep:FireBullets( bullet )

        if SERVER then
            net.Start("huysound")
            net.WriteVector(wep:GetPos())
            net.WriteString(self.ShootSound)
            net.WriteString(self.ShootSoundFar)
            net.WriteEntity(wep)
            net.Broadcast()
        end
        
        local obj = wep:LookupAttachment("shell")
        local Attachment = wep:GetAttachment(obj)
        if Attachment then
            local Angles = Attachment.Ang
            local ef = EffectData()
            ef:SetOrigin(Attachment.Pos)
            ef:SetAngles(Angles)
            ef:SetFlags( 140 ) -- Sets the Combine AR2 Muzzle flash

            util.Effect( "EjectBrass_762Nato", ef )
        end

        self.Recoil = (self.Recoil or 0) + 1.5
        self.NextShoot = CurTime() + self.Delay
        self.Clip = self.Clip - 1
end

local function easedBackLerp(fraction, from, to)
	return Lerp(math.ease.OutBack(fraction), from, to)
end

local function easedLerpAng(fraction, from, to)
	return LerpAngle(math.ease.OutExpo(fraction), from, to)
end

function ENT:Think()
    if self.IsInitializing then return end
    if not IsValid(self.GunEnt) then self:Remove() return end
    if self.Recoil != 0 then self.Recoil = easedBackLerp(.09,self.Recoil or 0, 0) end
    if IsValid(self.GunEnt) then
        self.GunEnt:SetPos( self:GetPos()+self:GetAngles():Up()*2.5 )
        self.GunEnt:SetAngles( self:GetAngles()+Angle(-self.Recoil,0,0)-self.sightAng )
        self.GunEnt:SetParent(self)
    end
    self:NextThink( CurTime() + .05 )

    if IsValid(self.User) then
        if self.User:KeyDown(IN_ATTACK) and (CurTime()>=self.NextShoot) and self.Clip > 0 and !timer.Exists("reload"..self:EntIndex()) then
            self:GunShoot(self.GunEnt)
        end
        self.sightAng = easedLerpAng(.05, self.sightAng or Angle(0,0,0), self:GetAngles() - self.User:EyeAngles())
        if self.User:KeyPressed(IN_RELOAD) then
            self:Reload()
        end
    end

    if IsValid(self.User) and self.User:GetPos():Distance(self:GetPos()) > 160 then self.User=nil end

    return true
end

function ENT:OnRemove()
    if IsValid(self.GunEnt) then self.GunEnt:Remove() end
end