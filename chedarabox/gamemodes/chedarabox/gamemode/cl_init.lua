include("shared.lua")
resource.AddSingleFile("resource/fonts/homicidefont.ttf")

surface.CreateFont("HomigradFont",{
	font = "Coolvetica Rg",
	size = 18,
	weight = 1100,
	outline = false
})

surface.CreateFont("RoleText",{
	font = "Coolvetica Rg",
	size = 48,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("GamemodeName",{
	font = "Coolvetica Rg",
	size = 64,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("YouAre",{
	font = "Coolvetica Rg",
	size = 30,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontBigN",{
	font = "Coolvetica Rg",
	size = 36,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontBig",{
	font = "Coolvetica Rg",
	size = 25,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("RadialFontGG",{
	font = "Coolvetica Rg",
	size = 26,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("HomigradFontLarge",{
	font = "Coolvetica Rg",
	size = ScreenScale(30),
	weight = 1100,
	outline = false
})

surface.CreateFont("HomigradFontSmall",{
	font = "Coolvetica Rg",
	size = ScreenScale(10),
	weight = 1100,
	outline = false
})

net.Receive("round_active",function(len)
	roundActive = net.ReadBool()
	roundTimeStart = net.ReadFloat()
	roundTime = net.ReadFloat()
end)

local view = {}

local function SendIdentity(data)
	if not LocalPlayer().ConCommand then return end
	if file.Exists("chedarabox_identity.txt", "DATA") then
		local RawData = string.Split(file.Read("chedarabox_identity.txt", "DATA"), "\n")
		local DatAccessory = string.Replace(RawData[6], " ", "_")
		LocalPlayer():ConCommand("checha_appearancemanual " .. RawData[1] .. " " .. RawData[2] .. " " .. RawData[3] .. " " .. RawData[4] .. " " .. RawData[5] .. " " .. DatAccessory)
	end
end
usermessage.Hook("SyncIdent", SendIdentity)

hook.Add("PreCalcView","spectate",function(lply,pos,ang,fov,znear,zfar)
	hook.Remove("CalcViewModelView", "TFALeanCalcVMView")
	lply = LocalPlayer()
	hook.Remove("CalcView", lply)
	if lply:Alive() or GetViewEntity() ~= lply then return end

	view.fov = CameraSetFOV
	direction = direction or 1
	local spec = lply:GetNWEntity("HeSpectateOn")
	if not IsValid(spec) then
		view.origin = lply:EyePos()
		view.angles = ang

		return view
	end
end)

SpectateHideNick = SpectateHideNick or false

local keyOld,keyOld2
local lply
flashlight = flashlight or nil
flashlightOn = flashlightOn or false

local gradient_d = Material("vgui/gradient-d")

hook.Add("HUDPaint","spectate",function()
	local lply = LocalPlayer()
	
	local spec = lply:GetNWEntity("HeSpectateOn")

	if lply:Alive() then
		if IsValid(flashlight) then
			flashlight:Remove()
			flashlight = nil
		end
	end

	local result = lply:PlayerClassEvent("CanUseSpectateHUD")
	if result == false then return end



	if
		(((not lply:Alive() or lply:Team() == 1002 or spec and lply:GetObserverMode() != OBS_MODE_NONE) or lply:GetMoveType() == MOVETYPE_NOCLIP)
		and not lply:InVehicle()) or result or hook.Run("CanUseSpectateHUD")
	then
		local ent = spec

		if IsValid(ent) then
			surface.SetFont("HomigradFont")
			local tw = surface.GetTextSize(ent:GetName())
			draw.SimpleText(ent:GetName(),"HomigradFont",ScrW() / 2 - tw / 2,ScrH() - 100,TEXT_ALING_CENTER,TEXT_ALING_CENTER)
			tw = surface.GetTextSize("HP: " .. ent:Health())
			draw.SimpleText("HP: " .. ent:Health(),"HomigradFont",ScrW() / 2 - tw / 2,ScrH() - 75,TEXT_ALING_CENTER,TEXT_ALING_CENTER)

			local func = TableRound().HUDPaint_Spectate
			if func then func(ent) end
		end

		local key = lply:KeyDown(IN_WALK)
		if keyOld ~= key and key then
			SpectateHideNick = not SpectateHideNick

			--chat.AddText("Ники игроков: " .. tostring(not SpectateHideNick))
		end
		keyOld = key

		draw.SimpleText("Players on / off: Left ALT","HomigradFont",15,ScrH() - 15,showRoundInfoColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

		local key = input.IsButtonDown(KEY_F)
		if not lply:Alive() and keyOld2 ~= key and key then
			flashlightOn = not flashlightOn

			if flashlightOn then
				if not IsValid(flashlight) then
					flashlight = ProjectedTexture()
					flashlight:SetTexture("effects/flashlight001")
					flashlight:SetFarZ(900)
					flashlight:SetFOV(70)
					flashlight:SetEnableShadows( false )
				end
			else
				if IsValid(flashlight) then
					flashlight:Remove()
					flashlight = nil
				end
			end
		end
		keyOld2 = key

		if flashlight then
			flashlight:SetPos(EyePos())
			flashlight:SetAngles(EyeAngles())
			flashlight:Update()
		end

		if not SpectateHideNick then
			local func = TableRound().HUDPaint_ESP
			if func then func() end

			for _, v in ipairs(player.GetAll()) do --ESP
				if !v:Alive() or v == ent then continue end

				local ent = IsValid(v:GetNWEntity("Ragdoll")) and v:GetNWEntity("Ragdoll") or v
				local screenPosition = ent:GetPos():ToScreen()
				local x, y = screenPosition.x, screenPosition.y
				local teamColor = v:GetPlayerColor():ToColor()
				local distance = lply:GetPos():Distance(v:GetPos())
				local factor = 1 - math.Clamp(distance / 1024, 0, 1)
				local size = math.max(10, 32 * factor)
				local alpha = math.max(255 * factor, 80)

				local text = v:Name()
				surface.SetFont("HomigradFont")
				local tw, th = surface.GetTextSize(text)

				surface.SetTextColor(255, 255, 255, alpha)
				surface.SetTextPos(x - tw / 2, y - th / 2)
				surface.DrawText(text)

				local barWidth = math.Clamp((v:Health() / 150) * (size + tw), 0, size + tw)
				local healthcolor = v:Health() / 150 * 255

				surface.SetDrawColor(255, healthcolor, healthcolor, alpha)
				surface.DrawRect(x - barWidth / 2, y + th / 1.5, barWidth, ScreenScale(1))
			end
		end
	end
end)

hook.Add("HUDDrawTargetID","no",function() return false end)
local function hasWeapon(ply, weaponName)
    if not IsValid(ply) or not ply:IsPlayer() then return false end -- Проверяем, является ли объект игроком и существует ли он
    
    for _, weapon in pairs(ply:GetWeapons()) do -- Перебираем все оружия игрока
        if IsValid(weapon) and weapon:GetClass() == weaponName then -- Проверяем, является ли оружие действительным и совпадает ли его класс с заданным названием
            return true -- Если нашли оружие, возвращаем true
        end
    end
    
    return false 
end

net.Receive("lasertgg",function(len)
	local ply = net.ReadEntity()
	local boolen = net.ReadBool()
	if boolen then
		laserplayers[ply:EntIndex()] = ply
	else
		laserplayers[ply:EntIndex()] = nil
	end
	ply.Laser = boolen
end)

hook.Add("OnEntityCreated", "homigrad-colorragdolls", function(ent)
	if ent:IsRagdoll() then
		timer.Create("ragdollcolors-timer" .. tostring(ent), 0.1, 0, function()
			--ent.ply = ent.ply or RagdollOwner(ent)
			--local ply = ent.ply
			--if IsValid(ply) then
			if IsValid(ent) then
				ent.playerColor = ent:GetNWVector("plycolor")
				--print(ent.ply,ent.playerColor)
				ent.GetPlayerColor = function()
					return ent.playerColor
				end
				timer.Remove("ragdollcolors-timer" .. tostring(ent))
			end
		end)
	end
end)

local function GetClipForCurrentWeapon( ply )
	if ( !IsValid( ply ) ) then return -1 end

	local wep = ply:GetActiveWeapon()
	if ( !IsValid( wep ) ) then return -1 end

	return wep:Clip1(), wep:GetMaxClip1(), ply:GetAmmoCount( wep:GetPrimaryAmmoType() )
end

hook.Add("HUDShouldDraw","HideHUD_ammo",function(name)
    if name == "CHudAmmo" then return false end
end)

local clipcolor = color_white
local clipcolorlow = Color(247, 178, 40, 255)
local clipcolorempty = Color(247, 40, 40, 255)
local colorgray = Color(200, 200, 200)
local shadow = color_black

net.Receive("remove_jmod_effects",function(len)
	LocalPlayer().EZvisionBlur = 0
	LocalPlayer().EZflashbanged = 0
end)

local meta = FindMetaTable("Player")

function meta:HasGodMode() return self:GetNWBool("HasGodMode") end

concommand.Add("hg_getentity",function()
	local ent = LocalPlayer():GetEyeTrace().Entity
	print(ent)
	if not IsValid(ent) then return end
	print(ent:GetModel())
	print(ent:GetClass())
end)

gameevent.Listen("player_spawn")
hook.Add("player_spawn","gg",function(data)
	local ply = Player(data.userid)

	if ply.SetHull then
		ply:SetHull(ply:GetNWVector("HullMin"),ply:GetNWVector("Hull"))
		ply:SetHullDuck(ply:GetNWVector("HullMin"),ply:GetNWVector("HullDuck"))
	end

	hook.Run("Player Spawn",ply)
end)

hook.Add("DrawDeathNotice","no",function() return false end)

