hook.Add("HomigradDamage","Organs",function(ply,hitgroup,dmginfo,rag,armorMul,armorDur,haveHelmet)
    local ent = rag or ply
    local inf = dmginfo:GetInflictor()
    if ply.fake then print("Damage HitGroup in fake: ", hitgroup) end
    if hitgroup == HITGROUP_HEAD then
        if not haveHelmet and dmginfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then

            dmginfo:ScaleDamage(inf.RubberBullets and 0.1 or 1)
            ply.pain = ply.pain + (ply.nopain and 1 or (inf.RubberBullets and 100 or 350))
            
            ply:SetDSP(37)

        end

        if
            dmginfo:GetDamageType() == DMG_CRUSH and
            dmginfo:GetDamage() >= 6 and
            ent:GetVelocity():Length() > 800
        then
            ply:ChatPrint("Your Neck is broken")
            ent:EmitSound("neck_snap_01",511,100,1,CHAN_ITEM)
            dmginfo:ScaleDamage(2000 * 50)
            ply.pain = ply.pain + 110
            if ply:Alive() then
                Faking(ply)
            end
            addDamageLog(ply, "Neck is broken", "Crush")
            return
        end
    end
    if dmginfo:GetDamage() >= 50 or (dmginfo:GetDamageType() == DMG_CRUSH and dmginfo:GetDamage() >= 6 and ent:GetVelocity():Length() > 700) then
        local brokenLeftLeg = hitgroup == HITGROUP_LEFTLEG
        local brokenRightLeg = hitgroup == HITGROUP_RIGHTLEG
        local brokenLeftArm = hitgroup == HITGROUP_LEFTARM
        local brokenRightArm = hitgroup == HITGROUP_RIGHTARM

        local sub = dmginfo:GetDamage() / 120 * armorMul
        if brokenLeftArm then
            ply.LeftArm = 0
            if ply.msgLeftArm < CurTime() then
                ply.LeftArmbroke = true
                ply.msgLeftArm = CurTime() + 1
                ply:ChatPrint("Your Left Arm is broken")
                ply:SetNWBool("LeftArm", true)
                if ply.ModelSex == "male" then sound.Play("vo/npc/male01/myarm02.wav", ent:GetPos(), 75, 100) else sound.Play("vo/npc/female01/myarm02.wav", ent:GetPos(), 75, 100) end
                ent:EmitSound("neck_snap_01",70,65,0.4,CHAN_ITEM)
                addDamageLog(ply, "Left Arm broken", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
            end
        end

        if brokenRightArm then
            ply.RightArm = 0
            if ply.msgRightArm < CurTime() then
                ply.RightArmbroke = true
                ply.msgRightArm = CurTime() + 1
                ply:ChatPrint("Your Right Arm is broken")
                ply:SetNWBool("RightArm", true)
                if ply.ModelSex == "male" then sound.Play("vo/npc/male01/myarm01.wav", ent:GetPos(), 75, 100) else sound.Play("vo/npc/female01/myarm01.wav", ent:GetPos(), 75, 100) end
                ent:EmitSound("neck_snap_01",70,65,0.4,CHAN_ITEM)
                addDamageLog(ply, "Right Arm broken", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
            end
        end

        if brokenLeftLeg then
            ply.LeftLeg = math.max(0.6,ply.LeftLeg - sub)
            if ply.msgLeftLeg < CurTime() then
                ply.msgLeftLeg = CurTime() + 1
                ply.LeftLegbroke = true
                ply:ChatPrint("Your Left Leg is broken")
                ent:EmitSound("neck_snap_01",70,65,0.4,CHAN_ITEM)
                if ply.ModelSex == "male" then sound.Play("vo/npc/male01/myleg01.wav", ent:GetPos(), 75, 100) else sound.Play("vo/npc/female01/myleg01.wav", ent:GetPos(), 75, 100) end
                if brokenRightLeg and !ply.fake then
                    Faking(ply)
                end
                addDamageLog(ply, "Left Leg broken", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
            end
        end

        if brokenRightLeg then
            ply.RightLeg = math.max(0.6,ply.RightLeg - sub)
            if ply.msgRightLeg < CurTime() then
                ply.msgRightLeg = CurTime() + 1
                ply.RightLegbroke = true
                ply:ChatPrint("Your Right Leg is broken")
                ent:EmitSound("neck_snap_01",70,65,0.4,CHAN_ITEM)
                if ply.ModelSex == "male" then sound.Play("vo/npc/male01/myleg02.wav", ent:GetPos(), 75, 100) else sound.Play("vo/npc/female01/myleg02.wav", ent:GetPos(), 75, 100) end
                if brokenLeftLeg and !ply.fake then
                    Faking(ply)
                end
                addDamageLog(ply, "Right Leg broken", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
            end
        end
    end

    local penetration = dmginfo:GetDamageForce()
    if dmginfo:IsDamageType(DMG_BULLET + DMG_SLASH) then
        penetration:Mul(0.015)
    else
        penetration:Mul(0.004)
    end

    penetration:Mul(armorMul)

    if not rag or (rag and not dmginfo:IsDamageType(DMG_CRUSH)) then
        local dmg = dmginfo:GetDamage() * armorMul

        local dmgpos = dmginfo:GetDamagePosition()

        local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Spine2'))
        local huy = util.IntersectRayWithOBB(dmgpos,penetration,pos,ang,Vector(-1,0,-6),Vector(10,6,6))
        
        if huy then
            if ply.Organs['lungs'] ~= 0 then
                ply.Organs['lungs'] = math.max(ply.Organs['lungs'] - dmg,0)
                if ply.Organs['lungs'] == 0 then
                    sound.Play(table.Random(krehtit), ply:GetPos(), 75, 100) 
                    ply:ChatPrint("Lung is hit")
                    addDamageLog(ply, "Lung hit", (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                end
            end
        end
        local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Head1'))
        local huy = util.IntersectRayWithOBB(dmgpos,penetration,pos,ang,Vector(2,-5,-3),Vector(8,3,3))
        local brainluti = util.IntersectRayWithOBB(dmgpos,penetration,pos,ang,Vector(3,-3,-2),Vector(6,1,2))

        local armors = JMod.LocationalDmgHandling(ply,hitgroup,dmginfo)
        local haveHelmet

	    for armorInfo,armorData in pairs(armors) do
	    	local dur = armorData.dur / armorInfo.dur


	    	local slots = armorInfo.slots
	    	if dmginfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then
	    		if slots.mouthnose or slots.head then
	    			haveHelmet = true
                end
            end
        end
        if huy or brainluti then 
            if haveHelmet then
                dmginfo:GetAttacker():GetActiveWeapon()
                ply.pain = ply.pain + 50
                if ply:Alive() and !ply.fake then Faking(ply) end
            end
        end
        if huy then
            if not haveHelmet and dmginfo:IsDamageType(DMG_BULLET) and not inf.RubberBullets then
                ply.Organs['brain']=ply.Organs['brain']-math.random(3, 5)
                if ply.Organs["brain"] == 0 then
                    addDamageLog(ply, "Skull hit: broke", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                elseif ply.Organs["brain"] != 0 then
                    addDamageLog(ply, "Skull hit: no broke", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                    ply.pain = ply.pain + 300
                    SIB_SurfaceHardness[MAT_FLESH] = 5
                    dmginfo:GetAttacker():GetActiveWeapon().skull_ricochet = true
                return end
            end
        end

        if brainluti then
            if not haveHelmet and dmginfo:IsDamageType(DMG_BULLET) and not inf.RubberBullets then
                if ply.Organs["brain"] == 0 then
                    print("brainluti = brain == 0")
                    ply:Kill()
                    addDamageLog(ply, "Brain hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                end
            end
        end

        local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Head1'))
        local huy = util.IntersectRayWithOBB(dmgpos,penetration,pos,ang,Vector(-1,-5,-3),Vector(2,1,3))

        if huy then
            if not haveHelmet and ply.jaw!=0 and dmginfo:IsDamageType(DMG_BULLET) and not inf.RubberBullets then
                ply.jaw=ply.jaw-math.Rand(0.1,1)
                if ply:Alive() and ply.jaw <= 0.8 then
                    ply:SetFlexWeight(35, -1)
                    ply:SetFlexWeight(31, 3)
                    ply:SetFlexWeight(32, 3)
                    ply:SetFlexWeight(34, -2)
                    ply:SetFlexWeight(38, 7)
                end
                if ply.jaw <= 0.6 then
                    if !ply.fake then
                        Faking(ply)
                    end
                end
                if ply.jaw <= 0.4 then
                    ply.mutejaw = true
                end
            end
        end

        print(dmginfo:GetDamageType())
        --brain
        local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Spine1'))
        local huy = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-4,-1,-6),Vector(2,5,-1))

        if huy then --ply:ChatPrint("You were hit in the liver.")
            if ply.Organs['liver']!=0 and !dmginfo:IsDamageType(DMG_CLUB) then
                ply.Organs['liver']=math.max(ply.Organs['liver']-dmg,0)
                if ply.Organs['liver']==0 then ply:ChatPrint("Liver is hit") addDamageLog(ply, "Liver hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other") end
            end
        end
        --liver

        local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Spine1'))
        local huy = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-4,-1,-1),Vector(2,5,6))
        
        if huy then --ply:ChatPrint("You were hit in the stomach.")
            if ply.Organs['stomach']!=0 and !dmginfo:IsDamageType(DMG_CLUB) then
                ply.Organs['stomach']=math.max(ply.Organs['stomach']-dmg,0)
                if ply.Organs['stomach']==0 then ply:ChatPrint("Stomach is hit") addDamageLog(ply, "Stomach hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other") end
            end
        end
        --stomach

        local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Spine'))
        local huy = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-4,-1,-6),Vector(1,5,6))
        
        if huy then --ply:ChatPrint("You were hit in the intestines.")
            if ply.Organs['intestines']!=0 and !dmginfo:IsDamageType(DMG_CLUB) then
                ply.Organs['intestines']=math.max(ply.Organs['intestines']-dmg,0)
                if ply.Organs['intestines']==0 then addDamageLog(ply, "Intestines hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other") end
            end
        end

        local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Spine2'))
        local huy = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(1,0,-1),Vector(5,4,3))
        
        if huy then --ply:ChatPrint("You were hit in the heart.")
            if ply.Organs['heart']!=0 and !dmginfo:IsDamageType(DMG_CLUB) then
                ply.Organs['heart']=math.max(ply.Organs['heart']-dmg,0)
                if ply.Organs['heart']==0 then ply:ChatPrint("Heart hit") addDamageLog(ply, "Heart hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other") end
            end
        end
        --heart
        if IsValid(dmginfo:GetAttacker():GetActiveWeapon()) and dmginfo:IsDamageType(DMG_BULLET+DMG_SLASH+DMG_BLAST+DMG_ENERGYBEAM+DMG_NEVERGIB+DMG_ALWAYSGIB+DMG_PLASMA+DMG_AIRBOAT+DMG_SNIPER+DMG_BUCKSHOT) then 
            local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Head1'))
            local huy = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-3,-2,-2), Vector(0,-1,-1))
            local huy2 = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-3,-2,1), Vector(0,-1,2))
            if dmginfo:IsDamageType(DMG_SLASH) and dmginfo:GetAttacker():GetActiveWeapon().typeattack == 2 and dmginfo:GetAttacker():GetActiveWeapon().Lezvie == nil then return end
            if huy or huy2 then --ply:ChatPrint("You were hit in the artery.")
                if ply.Organs['artery']!=0 and !dmginfo:IsDamageType(DMG_CLUB) then
                    if dmginfo:GetDamageType(DMG_SLASH) and dmginfo:GetAttacker():GetActiveWeapon().Lezvie != nil and dmginfo:GetAttacker():GetActiveWeapon().Lezvie < 1.5 then return end
                        ply.Organs['artery']=math.max(ply.Organs['artery']-dmg,0)
                        ply:SetNWBool("ArteryHit", true)
                        ply:SetNWBool("NeckArteryHit", true)
                        sound.Play("bleeding/arteryhit.wav",ent:GetPos(),75,100)
                        addDamageLog(ply, "Neck Artery hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                end
            end

            local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_L_Forearm'))
            local handart = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-5,-1,-2), Vector(10,0,-1))
            if handart then
                if !ply.LeftHandArtery and !dmginfo:IsDamageType(DMG_CLUB) then
                    if dmginfo:GetDamageType(DMG_SLASH) and dmginfo:GetAttacker():GetActiveWeapon().Lezvie != nil and dmginfo:GetAttacker():GetActiveWeapon().Lezvie < 2.3 then return end 
                        ply.LeftHandArtery = true
                        ply:SetNWBool("ArteryHit", true)
                        sound.Play("bleeding/arteryhit.wav",ent:GetPos(),75,100)
                        addDamageLog(ply, "Left Hand Artery hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                end
            end

            local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_R_Forearm'))
            local handartr = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-5,-2,1), Vector(10,0,2))
            if handartr then
                 if dmginfo:GetDamageType(DMG_SLASH) and dmginfo:GetAttacker():GetActiveWeapon().Lezvie != nil and dmginfo:GetAttacker():GetActiveWeapon().Lezvie < 2.3 then return end
                    ply.RightHandArtery = true
                    ply:SetNWBool("ArteryHit", true)
                    sound.Play("bleeding/arteryhit.wav",ent:GetPos(),75,100)
                    addDamageLog(ply, "Right Hand Artery hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
            end

            local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_L_Calf'))
            local legcalf = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-5,-1,-2), Vector(10,0,-1))
            if legcalf then
                if dmginfo:GetDamageType(DMG_SLASH) and dmginfo:GetAttacker():GetActiveWeapon().Lezvie != nil and dmginfo:GetAttacker():GetActiveWeapon().Lezvie < 2 then return end
                    ply.LeftLegArtery = true
                    ply:SetNWBool("ArteryHit", true)
                    sound.Play("bleeding/arteryhit.wav",ent:GetPos(),75,100)
                    addDamageLog(ply, "Left Leg Artery hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
            end

            local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_R_Calf'))
            local rightcalf = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-5,-2,1), Vector(10,0,2))
            if rightcalf then
                if dmginfo:GetDamageType(DMG_SLASH) and dmginfo:GetAttacker():GetActiveWeapon().Lezvie != nil and dmginfo:GetAttacker():GetActiveWeapon().Lezvie < 2 then return end
                    ply.RightLegArtery = true
                    ply:SetNWBool("ArteryHit", true)
                    sound.Play("bleeding/arteryhit.wav",ent:GetPos(),75,100)
                    addDamageLog(ply, "Right Leg Artery hit", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
            end
        end
        --coronary artery
        local matrix = ent:GetBoneMatrix(ent:LookupBone('ValveBiped.Bip01_Spine4'))
        local ang = matrix:GetAngles()
        local pos = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Spine4'))
        -- up spine
        local huy = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-8,-1,-1),Vector(2,0,1))
        local matrix = ent:GetBoneMatrix(ent:LookupBone('ValveBiped.Bip01_Spine1'))
        local ang = matrix:GetAngles()
        local pos = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Spine1'))
        -- low spine
        local huy2 = util.IntersectRayWithOBB(dmgpos,penetration, pos, ang, Vector(-8,-3,-1),Vector(2,-2,1))
        -- lower spine
        if (huy2) then --ply:ChatPrint("You were hit in the spine.")
            if ply.Organs['spine']!=0 then
                ply.Organs['spine']=math.Clamp(ply.Organs['spine']-dmg/10,0,1)
                if ply.Organs['spine']==0 then
                    timer.Simple(0.01,function()
                        if !ply.fake then
                            Faking(ply)
                        end
                    end)
                    ply.brokenspine=true 
                    ply:ChatPrint("Low Spine is broken")
                    ent:EmitSound("neck_snap_01",70,125,0.7,CHAN_ITEM)
                    addDamageLog(ply, "Low Spine broke", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                end
            end
        end
        -- upper spine
        if (huy) then
            if ply.upper_spine != 0 then
            ply.upper_spine=math.Clamp(ply.upper_spine-dmg/10,0,1)
            if ply.upper_spine == 0 then
                    timer.Simple(0.01,function()
                        if !ply.fake then
                            Faking(ply)
                        end
                    end)
                    ply.broken_uspine = true
                    ply:ChatPrint("High Spine is broken")
                    ent:EmitSound("neck_snap_01",70,125,0.7,CHAN_ITEM)
                    addDamageLog(ply, "High Spine broke", (dmginfo:IsDamageType(DMG_CRUSH) and "Crush") or (dmginfo:IsDamageType(DMG_BULLET) and "Bullet") or (dmginfo:IsDamageType(DMG_SLASH) and "Stab") or "Other")
                end
            end
        end
    end
end)

hook.Add("HomigradDamage","BurnDamage",function(ply,hitgroup,dmginfo) 
    if dmginfo:IsDamageType( DMG_BURN ) then
        dmginfo:ScaleDamage( 5 )
    end
end)

hook.Add("PlayerSpawn", "LASDAKLSDS", function(ply)
    ply:SetNWBool("ArteryHit", false)
end)

hook.Add("PlayerDeath", "LASDAKLSDS", function(ply)
    ply:SetNWBool("ArteryHit", false)
    ply:SetNWBool("NeckArteryHit", false)
end)