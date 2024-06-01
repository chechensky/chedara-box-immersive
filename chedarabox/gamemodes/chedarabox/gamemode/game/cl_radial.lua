local ments
local radialOpen = false
local prevSelected, prevSelectedVertex
function GM:OpenRadialMenu(elements)
	if not LocalPlayer():Alive() then return end
	radialOpen = true
	LocalPlayer():SetNWBool("radialopen", true)
	gui.EnableScreenClicker(true)
	ments = elements or {}
	prevSelected = nil
end

local pistol = {
	"9х19 mm Parabellum",
	"9х18 mm",
	".45 Rubber",
	"4.6x30 mm",
	"5.7x28 mm",
	".44 Remington Magnum",
	".50 AE Magnum",
	".45 acp"
}

local shotgun = {
   	"12/70 gauge",
   	"12/70 beanbag"
}

local rifle = {
   	"5.56x45 mm",
   	"7.62x51 NATO",
   	"7.62x54 mm",
   	".308 Winchester",
   	".408 Cheyenne Tactical",
   	"12.7x99 mm",
   	"7.62x39 mm",
   	"5.45x39 mm",
	"9x39 mm"
}

local other = {
   	"nails"
}

function GM:CloseRadialMenu()
	radialOpen = false
	LocalPlayer():SetNWBool("radialopen", false)
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw, sh = ScrW(), ScrH()
	local total = #ments
	local w = math.min(sw * 0.45, sh * 0.33)
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

function GM:RadialMousePressed(code, vec)
	if radialOpen then
		local selected = getSelected()
		if selected and selected > 0 and code == MOUSE_LEFT then
			if selected and ments[selected] then
				if ments[selected].Code == "changeposition" then
					RunConsoleCommand("+changeposition")
				elseif ments[selected].Code == "changeattack" then
					RunConsoleCommand("+changeattack")
				elseif ments[selected].Code == "menuammo" then
					RunConsoleCommand("hg_ammomenu")
				elseif ments[selected].Code == "menuarmor" then
					RunConsoleCommand("jmod_ez_inv")
				elseif ments[selected].Code == "modweapon" then
					RunConsoleCommand("checha_modifyweapon")
				elseif ments[selected].Code == "kurare" then
					local lply = LocalPlayer()
        			local wep = lply:GetActiveWeapon()
					net.Start("Kurare")
                	net.SendToServer()
				elseif ments[selected].Code == "unloadwep" then
					local lply = LocalPlayer()
        			local wep = lply:GetActiveWeapon()
                	net.Start("Unload")
                	net.WriteEntity(wep)
                	net.SendToServer()
				elseif ments[selected].Code == "holdbreath" then
					local lply = LocalPlayer()
					lply:ConCommand("hold_breath")
				elseif ments[selected].Code == "drop" then
					local lply = LocalPlayer()
					lply:ConCommand("say *drop")
				elseif ments[selected].Code == "medmenu" then
					local lply = LocalPlayer()
					lply:ConCommand("+medkit")
				elseif ments[selected].Code == "phrase" then
					local lply = LocalPlayer()
					lply:ConCommand("random_phrase")
				end
			end
		end

		self:CloseRadialMenu()
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
	"+menu_context",
	function(client, com, args, full)
		if client:GetNWBool("medmenu", false) == true then return end
		if client:Alive() then
			local Wep = client:GetActiveWeapon()
			elements = {}
			addElement("HoldBreath", "holdbreath")
			addElement("Ammo Menu","menuammo")
			addElement("RandomPhrase","phrase")
			addElement("Armor Menu","menuarmor")
			if IsValid(Wep) then
				if Wep:GetClass() ~= "weapon_hands" then addElement("Drop", "drop") end
				if Wep.Base == "salat_base" then
					addElement("ChangePosition","changeposition")
					addElement("Modifywep","modweapon")
				end
				if Wep:GetClass() == "weapon_kabar" or Wep:GetClass() == "weapon_knife" or Wep:GetClass() == "weapon_sogknife" then
					if hasWeapon(client, "weapon_hg_t_kurarepoison") == true then
						addElement("Kurare2", "kurare")
					end
				end
				if Wep:GetClass() == "weapon_kabar" or Wep:GetClass() == "weapon_knife" or Wep:GetClass() == "weapon_sogknife" then
					addElement("Changeattack", "changeattack")
				end
				if Wep:GetClass() == "medkit" then
					addElement("Medkit Menu", "medmenu")
				end
        		if Wep:Clip1() > 0 then
					addElement("UnloadWep", "unloadwep")
				end
			end
			GAMEMODE:OpenRadialMenu(elements)
		end
	end
)

concommand.Add(
	"-menu_context",
	function(client, com, args, full)
		GAMEMODE:RadialMousePressed(MOUSE_LEFT)
	end
)

local tex = surface.GetTextureID("VGUI/white.vmt")
local function drawShadow(n, f, x, y, color, pos)
	draw.DrawText(n, f, x + 1, y + 1, color_black, pos)
	draw.DrawText(n, f, x, y, color, pos)
end

local function DrawCenteredText(text, font, x, y, color, outlineColor)
    surface.SetFont(font)
    local textWidth, textHeight = surface.GetTextSize(text)
    surface.SetTextColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
    surface.SetTextPos(x - textWidth / 2, y - textHeight / 2)
    surface.SetDrawColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
    surface.DrawText(text)

    surface.SetTextColor(color.r, color.g, color.b, color.a)
    surface.SetTextPos(x - textWidth / 2 + 1, y - textHeight / 2 + 1)
    surface.DrawText(text)
end

local function DrawAmmoIcon(material, x, y, widght, height)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( material )
    surface.DrawTexturedRect( x, y, widght, height)
end

local circleVertex
local fontHeight = draw.GetFontHeight("HomigradFont")
function GM:DrawRadialMenu()
	if radialOpen then
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
				surface.SetDrawColor(129, 129, 129, 120)
				if ment.Code == "happy" then
					surface.SetDrawColor(255, 20, 20, 120)
				elseif ment.Code == "burp" then
					surface.SetDrawColor(195, 167, 30, 120)
				elseif ment.Code == "fart" then
					surface.SetDrawColor(111, 94, 8, 120)
				elseif ment.Code == "kurare" then
					surface.SetDrawColor(192, 23, 23, 120)
				end

				surface.DrawPoly(vertexes)
				textCol = color_white
			end
			local ply = LocalPlayer()
			local Main, Sub

			local weapon = LocalPlayer():GetActiveWeapon()
		if weapon.Base == "salat_base" and weapon.Primary.ClipSize>1 then
    		local ammoCount = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
    		local addedMagazines = math.floor(ammoCount / weapon.Primary.DefaultClip)
    		weapon.magazines = addedMagazines

        	local ammo = weapon:Clip1()
        	local scale = ammo / weapon.Primary.DefaultClip 
        	local scaledSize = 130 * scale
        	surface.SetDrawColor(255, 222, 0, 155)
        	surface.DrawRect(15, 350, 80, scaledSize)
        	surface.SetDrawColor(223, 195, 14, 255)
			
        	surface.DrawRect(6, 344, 6, 139)

			surface.DrawRect(6, 343, 97, 5)

			surface.DrawRect(6, 483, 97, 5)

        	surface.DrawRect(98, 344, 6, 142)
			
			draw.DrawText("Magazines Info", "HomigradFontBigN", 5, 300, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
			draw.DrawText("+ ".. weapon.magazines, "HomigradFontBigN", 110, 395, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)

        	local clip1 = weapon:Clip1()
        	local ammoType = game.GetAmmoData(weapon:GetPrimaryAmmoType()).name
        	local maxAmmo = ply:GetAmmoCount(ammoType)
				
        	local screenCenterX, screenCenterY = ScrW() / 1.1, ScrH() / 1.3
        	local textColor = Color(255, 255, 255, 255)

			DrawCenteredText(ammoType, "HomigradFontSmall", ScrW() / 7.3, ScrH() / 2.1, textColor, Color(0,0,0,255))
			if table.HasValue(rifle, ammoType) then
				DrawAmmoIcon(Material("vgui/hud/hmcd_round_792"), 5, 425, 150, 150)
			end
			if table.HasValue(other, ammoType) then
				DrawAmmoIcon(Material("vgui/hud/hmcd_nail"), -5, 440, 150, 150)
			end
			if table.HasValue(shotgun, ammoType) then
				DrawAmmoIcon(Material("vgui/hud/hmcd_round_12"), -5, 440, 150, 150)
			end
			if table.HasValue(pistol, ammoType) and ammoType != ".45 Rubber" then
				DrawAmmoIcon(Material("vgui/hud/hmcd_round_9"), -5, 440, 150, 150)
			elseif ammoType == ".45 Rubber" then
				DrawAmmoIcon(Material("vgui/hud/hmcd_round_22"), -5, 440, 150, 150)
			end
		end
			if ment.TransCode == "ChangePosition" then
				Main = "Change Position"
				Sub = ""
			elseif ment.TransCode == "Ammo Menu" then
				Main = "Ammo Menu"
				Sub = ""
			elseif ment.TransCode == "Armor Menu" then
				Main = "Armor Menu"
				Sub = ""
			elseif ment.TransCode == "Kurare2" then
				Main = "Poison a knife"
				Sub = ""
			elseif ment.TransCode == "UnloadWep" then
				Main = "Unload Ammo"
				Sub = ""
			elseif ment.TransCode == "Drop" then
				Main = "Drop Weapon"
				Sub = ""
			elseif ment.TransCode == "Medkit Menu" then
				Main = "Medkit Menu"
				Sub = ""
			elseif ment.TransCode == "Changeattack" then
				Main = "Change Attack"
				Sub = ""
			elseif ment.TransCode == "HoldBreath" then
				Main = (ply:GetNWBool("holdbreath", false) == false and "Hold Breath" or "Unhold Breath")
				Sub = ""
			elseif ment.TransCode == "RandomPhrase" then
				Main = "Random Phrase"
				Sub = ""
			elseif ment.TransCode == "Modifywep" then
				Main = "Modify Weapon"
				Sub = ""
			else
    			Main = "?"
    			Sub = "?"
			end

			drawShadow(Main, "RadialFontGG", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight, textCol, 1)
		end
	end
end