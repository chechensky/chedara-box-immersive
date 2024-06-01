--

SIB_SurfaceHardness={
    [MAT_METAL]=7,[MAT_COMPUTER]=.95,[MAT_VENT]=.95,[MAT_GRATE]=.95,[MAT_FLESH]=.2,[MAT_ALIENFLESH]=.3,
    [MAT_SAND]=.1,[MAT_DIRT]=.3,[74]=.1,[85]=.2,[MAT_WOOD]=.5,[MAT_FOLIAGE]=.5,
    [MAT_CONCRETE]=.9,[MAT_TILE]=.8,[MAT_SLOSH]=.05,[MAT_PLASTIC]=.3,[MAT_GLASS]=.6
}

function SWEP:BulletCallbackFunc(dmgAmt,ply,tr,dmg,tracer,hard,multi)
	if(tr.MatType==MAT_FLESH)then
		util.Decal("Impact.Flesh",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		local vPoint = tr.HitPos
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		effectdata:SetRadius(2)
		if self.skull_ricochet then SIB_SurfaceHardness[MAT_FLESH] = 5 timer.Simple(1, function() SIB_SurfaceHardness[MAT_FLESH] = .2 end) self:RicochetOrPenetrate(tr) end
	end
	if(self.NumBullet or 1>1)then return end
	if(tr.HitSky)then return end
	if(hard or self.skull_ricochet)then self:RicochetOrPenetrate(tr) end
end

function SWEP:RicochetOrPenetrate(initialTrace)
	local AVec,IPos,TNorm,SMul=initialTrace.Normal,initialTrace.HitPos,initialTrace.HitNormal,SIB_SurfaceHardness[initialTrace.MatType]
	if not(SMul)then SMul=.5 end
	local ApproachAngle=-math.deg(math.asin(TNorm:DotProduct(AVec)))
	local MaxRicAngle=60*SMul
	if(ApproachAngle>(MaxRicAngle*1.25) or self.skull_ricochet)then -- all the way through
		local MaxDist,SearchPos,SearchDist,Penetrated=(self.Primary.Damage/SMul)*.25,IPos,5,false
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
				Attacker=self.Owner,
				Damage=1,
				Force=1,
				Num=1,
				Tracer=0,
				TracerName="LaserTracer",
				Dir=-AVec,
				Spread=Vector(0,0,0),
				Src=SearchPos+AVec
			})
			self:FireBullets({
				Attacker=self.Owner,
				Damage=self.Primary.Damage*.65,
				Force=self.Primary.Damage/15,
				Num=1,
				Tracer=0,
				TracerName="LaserTracer",
				Dir=AVec,
				Spread=Vector(0,0,0),
				Src=SearchPos+AVec
			})
		end
	elseif(ApproachAngle<(MaxRicAngle*.25) or self.skull_ricochet)then -- ping whiiiizzzz
		sound.Play("snd_jack_hmcd_ricochet_"..math.random(1,2)..".wav",IPos,80,130)
		local NewVec=AVec:Angle()
		NewVec:RotateAroundAxis(TNorm,math.random(100,200))
		NewVec=NewVec:Forward()
		self:FireBullets({
			Attacker=self.Owner,
			Damage=self.Primary.Damage*.85,
			Force=self.Primary.Damage/15,
			Num=1,
			Tracer=0,
			TracerName="",
			Dir=-NewVec,
			Spread=Vector(0,0,0),
			Src=IPos+TNorm
		})
		self.skull_ricochet = false
		SIB_SurfaceHardness[MAT_FLESH] = .2
	end
end

local vec = Vector(0,0,0)
local vecZero = Vector(0,0,0)
local angZero = Angle(0,0,0)

local hg_show_hitposmuzzle = CreateClientConVar("hg_show_hitposmuzzle","0",false,false,"huy",0,1)

hook.Add("HUDPaint","admin_hitpos",function()
	if hg_show_hitposmuzzle:GetBool() and LocalPlayer():IsAdmin() then
		local wep = LocalPlayer():GetActiveWeapon()
		if not IsValid(wep) then return end

		local att = wep:LookupAttachment("muzzle")
		if not att then return end

		local att = wep:GetAttachment(att)
		if not att then return end

		local shootOrigin = att.Pos
		local vec = vecZero
		vec:Set(wep.addPos)
		vec:Rotate(att.Ang)
		shootOrigin:Add(vec)
	
		local shootAngles = att.Ang
		local ang = angZero
		ang:Set(wep.addAng)
		shootAngles:Add(ang)

		local tr = util.QuickTrace(shootOrigin,shootAngles:Forward() * 1000,LocalPlayer())
		local hit = tr.HitPos:ToScreen()
		
		surface.SetDrawColor( 255, 255, 100, 255 )
		surface.DrawRect(hit.x - 2.5,hit.y - 2.5,6,6)
	end
end)

function SWEP:FireBullet(dmg, numbul, spread)
	if self:Clip1() <= 0 or timer.Exists("reload"..self:EntIndex())  then return end
	
	local ply = self:GetOwner()

	ply:LagCompensation(true)

	local obj = self:LookupAttachment("muzzle")
	local Attachment = self.Owner:GetActiveWeapon():GetAttachment(obj)

	local cone = self.Primary.Cone

	local shootOrigin = Attachment.Pos
	local vec = vecZero
	vec:Set(self.addPos)
	vec:Rotate(Attachment.Ang)
	shootOrigin:Add(vec)

	local shootAngles = Attachment.Ang
	local ang = angZero
	ang:Set(self.addAng)
	shootAngles:Add(ang)

	local shootDir = shootAngles:Forward()

	local npc = ply:IsNPC() and ply:GetShootPos() or shootOrigin
	local npcdir = ply:IsNPC() and ply:GetAimVector() or shootDir
	local bullet = {}
	bullet.Num 			= self.NumBullet or 1
	bullet.Src 			= npc
	bullet.Dir 			= npcdir
	bullet.Spread 		= Vector(0,0,0)
	bullet.Force		= self.Primary.Force
	bullet.Damage		= self.Primary.Damage
	bullet.AmmoType     = self.Primary.Ammo
	bullet.Attacker 	= self.Owner
	bullet.Tracer       = 1
	bullet.TracerName   = self.Tracer or "Tracer"
	bullet.IgnoreEntity = not self.Owner:IsNPC()

	bullet.Callback = function(ply,tr,dmgInfo)
		ply:GetActiveWeapon():BulletCallbackFunc(self.Primary.Damage,ply,tr,self.Primary.Damage,false,true,false)

		if self.NumBullet and self.NumBullet > 1 then
			local k = math.max(1 - tr.StartPos:Distance(tr.HitPos) / 750,0)

			dmgInfo:ScaleDamage(k)
		end
		if SERVER then
			net.Start("shoot_huy")
				net.WriteTable(tr)
			net.Broadcast()
		end
	end
	self:FireBullets(bullet)
	ply:LagCompensation(false)
	if SERVER then 
		self:TakePrimaryAmmo(1) 
	end

	-- EFFECTS MANNN!!!
	

	if self.DoFlash and self:GetNWBool("WEP_Supressor", false) == false then
		local ef = EffectData()
		ef:SetEntity( self )
		ef:SetAttachment( 1 ) -- self:LookupAttachment( "muzzle" )
		ef:SetScale(2)
		ef:SetFlags( 1 ) -- Sets the Combine AR2 Muzzle flash

		util.Effect( "MuzzleFlash", ef )
	end

	local ef = EffectData()
	ef:SetEntity( self )

	util.Effect( "sib_muzzleefect", ef )

	if CLIENT then
		SIB_suppress.Shoot = 0.01*(self.Primary.Force/40)
	end
	local obj = self:LookupAttachment("shell") or 1
	local Attachment = self.Owner:GetActiveWeapon():GetAttachment(obj)
	if Attachment then
		local Angles = Attachment.Ang
		if self.ShellRotate then Angles:RotateAroundAxis(vector_up,100)  end
		local ef = EffectData()
		ef:SetOrigin(Attachment.Pos)
		ef:SetAngles(Angles)
		ef:SetFlags( 1 ) -- Sets the Combine AR2 Muzzle flash

		util.Effect( self.Shell, ef )
	end

end

if SERVER then
	util.AddNetworkString("shoot_huy")
else
	net.Receive("shoot_huy",function(len)
		local tr = net.ReadTable()
		--snd_jack_hmcd_bc_1.wav

		local dist,vec,dist2 = util.DistanceToLine(tr.StartPos,tr.HitPos,EyePos())
		if dist < 128 and dist2 > 128 then
			EmitSound("snd_jack_hmcd_bc_"..tostring(math.random(1,7))..".wav", vec, 1, CHAN_AUTO, 1, 95, 0, 100,0)
			Suppress(1.5)
		end
	end)
end


function SWEP:IsReloaded()
	return timer.Exists("reload"..self:EntIndex())
end


function SWEP:IsScope()
	local ply = self:GetOwner()
	if ply:IsNPC() then return end

	if CLIENT or SERVER then
		return not ply:IsSprinting() and ply:KeyDown(IN_ATTACK2) and not self:IsReloaded()
	else
		return self:GetNWBool("IsScope")
	end
end