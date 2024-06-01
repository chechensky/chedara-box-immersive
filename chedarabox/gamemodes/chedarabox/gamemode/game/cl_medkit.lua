local ments
local medkitOpen = false
local prevSelected, prevSelectedVertex
function GM:OpenMedKitMenu(elements)
	if not LocalPlayer():Alive() then return end
	medkitOpen = true
	LocalPlayer():SetNWBool("medmenu", true)
	gui.EnableScreenClicker(true)
	ments = elements or {}
	prevSelected = nil
end

function GM:CloseMedKitMenu()
	medkitOpen = false
	LocalPlayer():SetNWBool("medmenu", false)
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw, sh = ScrW(), ScrH()
	local total = #ments
	local w = math.min(sw * 0.45, sh * 0.45)
	local sx, sy = sw / 2, sh / 2
	local x2, y2 = mx - sx, my - sy
	local ang = 0
	local dis = math.sqrt(x2 ^ 2 + y2 ^ 2)
	if dis / w <= 1 then
		if y2 <= 0 and x2 <= 0 then
			ang = math.acos(x2 / dis)
		elseif x2 > 0 and y2 <= 0 then
			ang = -math.asin(y2 / dis)
		elseif x2 <= 0 and y2 > 0 then
			ang = math.asin(y2 / dis) + math.pi
		else
			ang = math.pi * 2 - math.acos(x2 / dis)
		end

		return math.floor((1 - (ang - math.pi / 2 - math.pi / total) / (math.pi * 2) % 1) * total) + 1
	end
end

local function hasWeapon(ply, weaponName)
    if not IsValid(ply) or not ply:IsPlayer() then return false end
    
    for _, weapon in pairs(ply:GetWeapons()) do
        if IsValid(weapon) and weapon:GetClass() == weaponName then
            return true
        end
    end
    
    return false 
end

function GM:MedKitMousePressed(code, vec)
	if medkitOpen then
		local selected = getSelected()
		if selected and selected > 0 and code == MOUSE_LEFT then
			if selected and ments[selected] then
				if ments[selected].Code == "tourniquet" then
					local lply = LocalPlayer()
					local wep = lply:GetActiveWeapon()
					net.Start("TourniquetMedKit")
					net.SendToServer()
				elseif ments[selected].Code == "bandage" then
					local lply = LocalPlayer()
					local wep = lply:GetActiveWeapon()
					net.Start("BMK")
					net.SendToServer()
				elseif ments[selected].Code == "painkill" then
					local lply = LocalPlayer()
					local wep = lply:GetActiveWeapon()
					net.Start("PMK")
					net.SendToServer()
				elseif ments[selected].Code == "morphine" then
					local lply = LocalPlayer()
					local wep = lply:GetActiveWeapon()
					net.Start("MMK")
					net.SendToServer()
				elseif ments[selected].Code == "splint" then
					local lply = LocalPlayer()
					local wep = lply:GetActiveWeapon()
					net.Start("SMK")
					net.SendToServer()
				elseif ments[selected].Code == "nomed" then
					local lply = LocalPlayer()
					lply:ChatPrint("pepsi?")
				end
			end
		end

		self:CloseMedKitMenu()
	end
end

local elements
local function addElement(transCode, code)
	local t = {}
	t.TransCode = transCode
	t.Code = code
	table.insert(elements, t)
end

concommand.Add(
	"+medkit",
	function(client, com, args, full)
		if client:GetNWBool("radialopen", false) == true then return end
		if !IsValid(client:GetActiveWeapon()) then return end
		if client:GetActiveWeapon():GetClass() != "medkit" then return end
		if client:Alive() then
			local Wep = client:GetActiveWeapon()
			elements = {}
			if Wep:GetNWInt("tourniquet", 3) != 0 then addElement("Tourniquet", "tourniquet") end
			if Wep:GetNWInt("bandage", 2) != 0 then addElement("Bandage", "bandage") end
			if Wep:GetNWInt("painkill", 2) != 0 then addElement("Painkill", "painkill") end
			if Wep:GetNWInt("morphine", 2) != 0 then addElement("Morphine", "morphine") end
			if Wep:GetNWInt("splint", 2) != 0 then addElement("Splint", "splint") end

			if Wep:GetNWInt("tourniquet", 3) == 0 and Wep:GetNWInt("bandage", 2) == 0 and Wep:GetNWInt("painkill", 2) == 0 and Wep:GetNWInt("morphine", 2) == 0 and Wep:GetNWInt("splint", 2) == 0 then
				addElement("Nomed", "nomed")
			end
			GAMEMODE:OpenMedKitMenu(elements)
		end
	end
)

concommand.Add(
	"-medkit",
	function(client, com, args, full)
		GAMEMODE:MedKitMousePressed(MOUSE_LEFT)
	end
)

local tex = surface.GetTextureID("VGUI/white.vmt")
local function drawShadow(n, f, x, y, color, pos)
	draw.DrawText(n, f, x + 1, y + 1, color_black, pos)
	draw.DrawText(n, f, x, y, color, pos)
end

local circleVertex
local fontHeight = draw.GetFontHeight("HomigradFont")
function GM:DrawMedKitMenu()
	if medkitOpen then
		local sw, sh = ScrW(), ScrH()
		local total = #ments
		local w = math.min(sw * 0.45, sh * 0.33)
		local h = w
		local sx, sy = sw / 2, sh / 2
		local selected = getSelected() or -1
		if not circleVertex then
			circleVertex = {}
			local max = 50
			for i = 0, max do
				local vx, vy = math.cos((math.pi * 2) * i / max), math.sin((math.pi * 2) * i / max)
				table.insert(
					circleVertex,
					{
						x = sx + w * 1 * vx,
						y = sy + h * 1 * vy
					}
				)
			end
		end

		surface.SetTexture(tex)
		local defaultTextCol = color_white
		if selected <= 0 or selected ~= selected then
			surface.SetDrawColor(20, 20, 20, 180)
		else
			surface.SetDrawColor(20, 20, 20, 120)
			defaultTextCol = Color(150, 150, 150)
		end

		surface.DrawPoly(circleVertex)
		local add = math.pi * 1.5 + math.pi / total
		local add2 = math.pi * 1.5 - math.pi / total
		for k, ment in pairs(ments) do
			local x, y = math.cos((k - 1) / total * math.pi * 2 + math.pi * 1.5), math.sin((k - 1) / total * math.pi * 2 + math.pi * 1.5)
			local lx, ly = math.cos((k - 1) / total * math.pi * 2 + add), math.sin((k - 1) / total * math.pi * 2 + add)
			local textCol = defaultTextCol
			if selected == k then
				local vertexes = prevSelectedVertex -- uhh, you mean VERTICES? Dumbass.
				if prevSelected ~= selected then
					prevSelected = selected
					vertexes = {}
					prevSelectedVertex = vertexes
					local lx2, ly2 = math.cos((k - 1) / total * math.pi * 2 + add2), math.sin((k - 1) / total * math.pi * 2 + add2)
					table.insert(
						vertexes,
						{
							x = sx,
							y = sy
						}
					)

					table.insert(
						vertexes,
						{
							x = sx + w * 1 * lx2,
							y = sy + h * 1 * ly2
						}
					)

					local max = math.floor(50 / total)
					for i = 0, max do
						local addv = (add - add2) * i / max + add2
						local vx, vy = math.cos((k - 1) / total * math.pi * 2 + addv), math.sin((k - 1) / total * math.pi * 2 + addv)
						table.insert(
							vertexes,
							{
								x = sx + w * 1 * vx,
								y = sy + h * 1 * vy
							}
						)
					end

					table.insert(
						vertexes,
						{
							x = sx + w * 1 * lx,
							y = sy + h * 1 * ly
						}
					)
				end

				surface.SetTexture(tex)
				surface.SetDrawColor(230, 28, 55, 120)
				surface.DrawPoly(vertexes)
				textCol = color_white
			end
			local lply = LocalPlayer()
			local wep = lply:GetActiveWeapon()
		
			local Main, Sub
			if ment.TransCode == "Tourniquet" then
    			Main = "Tourniquets"
    			Sub = wep:GetNWInt("tourniquet", 3) .. " / " .. wep.def_tour
			elseif ment.TransCode == "Bandage" then
    			Main = "Bandages"
    			Sub = wep:GetNWInt("bandage", 2) .. " / " .. wep.def_bandage
			elseif ment.TransCode == "Painkill" then
				Main = "Painkiller"
				Sub = wep:GetNWInt("painkill", 2) .. " / " .. wep.def_painkill
			elseif ment.TransCode == "Morphine" then
				Main = "Morphines"
				Sub = wep:GetNWInt("morphine", 2) .. " / " .. wep.def_morphine
			elseif ment.TransCode == "Splint" then
				Main = "Splintes"
				Sub = wep:GetNWInt("splint", 2) .. " / " .. wep.def_splint
			elseif ment.TransCode == "Nomed" then
				Main = "No medications available"
				Sub = ""
			else
    			Main = "?"
    			Sub = "?"
			end

			drawShadow(Main, "RadialFontGG", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight / 3, textCol, 1)
			drawShadow(Sub, "RadialFontGG", sx + w * 0.6 * x, sy + h * 0.6 * y + fontHeight * 2, textCol, 1)
		end
	end
end