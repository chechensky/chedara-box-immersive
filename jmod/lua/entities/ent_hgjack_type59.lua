AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, TheOnly8Z"
ENT.PrintName = "EZHG Type59 Granade"
ENT.Category = "JModHomigrad"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.JModPreferredCarryAngles = Angle(0, -140, 0)
ENT.Model = "models/weapons/w_jj_fraggrenade_thrown.mdl"
ENT.SpoonScale = 2

if SERVER then
	function ENT:Arm()
		self:SetBodygroup(2, 1)
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()

		
		local time = math.random(3.2,4.2)

		timer.Simple(time, function()
			if IsValid(self) then
				self:Detonate()
			end
		end)
	end

	function ENT:Detonate()
		if(self.Exploded)then return end
		self.Exploded=true
		local Pos,Ground,Attacker=self:LocalToWorld(self:OBBCenter())+Vector(0,0,5),self:NearGround(),self.Owner
		if(Ground)then
			ParticleEffect("pcf_jack_groundsplode_small3",Pos,vector_up:Angle())
		else
			ParticleEffect("pcf_jack_airsplode_small3",Pos,VectorRand():Angle())
		end
		local Foom=EffectData()
		Foom:SetOrigin(Pos)
		util.Effect("explosion",Foom,true,true)
		local Flash=EffectData()
		Flash:SetOrigin(Pos)
		Flash:SetScale(2)
		util.Effect("eff_jack_hmcd_dlight",Flash,true,true)
		timer.Simple(.01,function()
			sound.Play("snd_jack_hmcd_explosion_debris.mp3",Pos,85,math.random(90,110))
			sound.Play("ied/ied_detonate_dist_01.wav",Pos-vector_up,140,100)
			sound.Play("snd_jack_hmcd_debris.mp3",Pos+vector_up,85,math.random(90,110))
			for i=0,10 do
				local Tr=util.QuickTrace(Pos,VectorRand()*math.random(10,150),{self})
				if(Tr.Hit)then util.Decal("Scorch",Tr.HitPos+Tr.HitNormal,Tr.HitPos-Tr.HitNormal) end
			end
		end)
		timer.Simple(.02,function()
			sound.Play("ied/ied_detonate_01.wav",Pos,80,100)
			sound.Play("ied/ied_detonate_01.wav",Pos+vector_up,80,100)
			sound.Play("ied/ied_detonate_01.wav",Pos-vector_up,80,100)
		end)
		timer.Simple(.03,function()
			local Poof=EffectData()
			Poof:SetOrigin(Pos)
			Poof:SetScale(1)
			util.Effect("eff_jack_hmcd_shrapnel",Poof,true,true)
		end)
		timer.Simple(.04,function()
			local shake=ents.Create("env_shake")
			shake.HmcdSpawned=self.HmcdSpawned
			shake:SetPos(Pos)
			shake:SetKeyValue("amplitude",tostring(100))
			shake:SetKeyValue("radius",tostring(200))
			shake:SetKeyValue("duration",tostring(1))
			shake:SetKeyValue("frequency",tostring(200))
			shake:SetKeyValue("spawnflags",bit.bor(4,8,16))
			shake:Spawn()
			shake:Activate()
			shake:Fire("StartShake","",0)
			SafeRemoveEntityDelayed(shake,2) -- don't clutter up the world
			local shake2=ents.Create("env_shake")
			shake2.HmcdSpawned=self.HmcdSpawned
			shake2:SetPos(Pos)
			shake2:SetKeyValue("amplitude",tostring(100))
			shake2:SetKeyValue("radius",tostring(400))
			shake2:SetKeyValue("duration",tostring(1))
			shake2:SetKeyValue("frequency",tostring(200))
			shake2:SetKeyValue("spawnflags",bit.bor(4))
			shake2:Spawn()
			shake2:Activate()
			shake2:Fire("StartShake","",0)
			SafeRemoveEntityDelayed(shake2,2) -- don't clutter up the world
			util.BlastDamage(self,Attacker,Pos,150,50)
		end)
		timer.Simple(.05,function()
			local Shrap=DamageInfo()
			Shrap:SetAttacker(Attacker)
			if(IsValid(self))then
				Shrap:SetInflictor(self)
			else
				Shrap:SetInflictor(game.GetWorld())
			end
			Shrap:SetDamageType(DMG_BUCKSHOT)
			Shrap:SetDamage(400)
			util.BlastDamageInfo(Shrap,Pos,600)
			SafeRemoveEntity(self)
		end)
		timer.Simple(.1,function()
			for key,rag in pairs(ents.FindInSphere(Pos,750))do
				if((rag:GetClass()=="prop_ragdoll")or(rag:IsPlayer()))then
					for i=1,20 do
						local Tr=util.TraceLine({start=Pos,endpos=rag:GetPos()+VectorRand()*50})
						if((Tr.Hit)and(Tr.Entity==rag))then util.Decal("Blood",Tr.HitPos+Tr.HitNormal,Tr.HitPos-Tr.HitNormal) end
					end
				end
			end
		end)
	end
elseif CLIENT then
	local GlowSprite = Material("sprites/mat_jack_circle")

	function ENT:Draw()
		self:DrawModel()
		-- sprites for calibrating the lethality/casualty radius
		
		--[[local State,Vary=self:GetState(),math.sin(CurTime()*50)/2+.5
		
			render.SetMaterial(GlowSprite)
			render.DrawSprite(self:GetPos()+Vector(0,0,4),15*52*2,15*52*2,Color(255,0,0,128))
			render.DrawSprite(self:GetPos()+Vector(0,0,4),5*52*2,5*52*2,Color(255,255,255,128))
		]]--
		
	end

	language.Add("ent_jack_gmod_ezfragnade", "EZ Frag Grenade")
end
