nodraw_players = nodraw_players or {}

hook.Add("Think","ShouldDrawNoclipe",function()
	local lply = LocalPlayer()

	for i,ply in pairs(player.GetAll()) do
		if ply == lply then continue end

		if ply:GetNWBool("scared") or (ply:Alive() and not ply:InVehicle() and ply:GetMoveType() == MOVETYPE_NOCLIP) then
			ply:SetNoDraw(true)
			for i,wep in pairs(ply:GetWeapons()) do wep:SetNoDraw(true) end
			nodraw_players[ply] = true
		elseif nodraw_players[ply] then
			ply:SetNoDraw(false)
			for i,wep in pairs(ply:GetWeapons()) do wep:SetNoDraw(false) end
			nodraw_players[ply] = nil
		end
	end
end)

hook.Add("DrawPhysgunBeam","gg",function(ply)
	if nodraw_players[ply] then return false end
end)

local red = Color(125,0,0)

local hg_customname = CreateClientConVar("hg_customname","",true)

cvars.AddChangeCallback("hg_customname",function(_,_,value)
    net.Start("custom name")
	net.WriteString(value)
	net.SendToServer()
end)

net.Start("custom name")
net.WriteString(hg_customname:GetString())
net.SendToServer()

hook.Add("HUDPaint","homigrad-huynyui",function()
	local lply = LocalPlayer()

	if not lply:Alive() then return end

	if IsValid(lply:GetActiveWeapon()) and lply:GetActiveWeapon():GetClass() ~= "weapon_hands" then
		local ply = lply
		local t = {}
		local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
		
		t.start = eye and eye.Pos or ply:EyePos()
		t.endpos = t.start + ply:GetAngles():Forward() * 60
		t.filter = lply
		local Tr = util.TraceLine(t)

		local Size = math.Clamp(1 - ((Tr.HitPos -lply:GetShootPos()):Length() / 60) ^ 2, .1, .3)

		local ent = Tr.Entity

		local col
		if ent:IsPlayer() then
			col = ent:GetPlayerColor():ToColor()
		elseif ent.GetPlayerColor ~= nil then
			col = ent.playerColor:ToColor()
		else
			return
		end

		if nodraw_players[Tr.Entity] then
			if math.random(1,25) == 25 then
				draw.DrawText(string.rep("?",math.random(1,4)) .. "you scared me" .. string.rep("?",math.random(1,4)),"DefaultFixedDropShadow",Tr.HitPos:ToScreen().x + math.random(-125,125),Tr.HitPos:ToScreen().y + math.random(-125,125), red, TEXT_ALIGN_CENTER )

				local head = Tr.Entity:GetBonePosition(Tr.Entity:LookupBone("ValveBiped.Bip01_Head1"))
				head = head:ToScreen()

				draw.DrawText(string.rep("c",math.random(1,12)) .. ":","DefaultFixedDropShadow",head.x + math.random(-25,25),head.y + math.random(-25,25), red, TEXT_ALIGN_CENTER )
			end

			return
		end

		col.a = 255 * Size * 2
		draw.DrawText(ent:GetNWString("Nickname",false) or (ent:IsPlayer() and ent:Name()) or "", "HomigradFontLarge", Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y + 30, col, TEXT_ALIGN_CENTER )
	end
end)


dev = GetConVar( "developer" )

hook.Add("PostDrawTranslucentRenderables","hitboxs",function()
	if dev:GetInt() == 1 then
		for _, ent in ipairs(player.GetAll()) do
			local cho = IsValid(ent:GetNWEntity("Ragdoll")) and ent:GetNWEntity("Ragdoll") or ent
        	local pos,ang = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Spine2'))
       		render.DrawWireframeBox( pos, ang, Vector(-1,0,-6),Vector(10,6,6), Color(200,200,200) )

			local pos,ang = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Head1'))
        	render.DrawWireframeBox( pos, ang, Vector(2,-5,-3),Vector(8,3,3), Color(206,199,199) )
        	render.DrawWireframeBox( pos, ang, Vector(3,-3,-2),Vector(6,1,2), Color(228,25,221) )
        	render.DrawWireframeBox( pos, ang, Vector(-1,-5,-3),Vector(2,1,3), Color(9,0,255) )
			
			render.DrawWireframeBox( pos, ang, Vector(-3,-2,-2),Vector(0,-1,-1), Color(206,199,199) )
       		render.DrawWireframeBox( pos, ang, Vector(-3,-2,1),Vector(0,-1,2), Color(206,199,199) )

			local pos,ang = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Spine1'))
       		render.DrawWireframeBox( pos, ang, Vector(-4,-1,-6),Vector(2,5,-1), Color(206,199,199) )
		
			local pos,ang = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Spine1'))
       		render.DrawWireframeBox( pos, ang, Vector(-4,-1,-1),Vector(2,5,6), Color(206,199,199) )
		
			local pos,ang = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Spine'))
       		render.DrawWireframeBox( pos, ang, Vector(-4,-1,-6),Vector(1,5,6), Color(206,199,199) )
		
			local pos,ang = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Spine2'))
		    render.DrawWireframeBox( pos, ang, Vector(1,0,-1),Vector(5,4,3), Color(206,199,199) )
		
			local pos = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Spine4'))
		    render.DrawWireframeBox( pos, ang, Vector(-8,-1,-1),Vector(2,0,1), Color(206,199,199) )

			local pos = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_Spine1'))
		    render.DrawWireframeBox( pos, ang, Vector(-8,-3,-1),Vector(2,-2,1), Color(206,199,199) )

			local pos = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_L_Forearm'))
		    render.DrawWireframeBox( pos, ang, Vector(-5,-1,-2),Vector(10,0,-1), Color(206,199,199) )

			local pos = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_R_Forearm'))
		    render.DrawWireframeBox( pos, ang, Vector(-5,-2,1),Vector(10,0,2), Color(206,199,199) )

			local pos = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_L_Calf'))
		    render.DrawWireframeBox( pos, ang, Vector(-5,-1,-2),Vector(10,0,-1), Color(206,199,199) )

			local pos = cho:GetBonePosition(cho:LookupBone('ValveBiped.Bip01_R_Calf'))
		    render.DrawWireframeBox( pos, ang, Vector(-5,-2,1),Vector(10,0,2), Color(206,199,199) )
		end
	end
end )