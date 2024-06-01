
util.AddNetworkString("open_appmenu")

function OpenAppMenu(ply, cmd, args)
if roundActiveName != nil and roundActiveName != "homicide" then print("ТОКА В ХОМИСЕ" ) return end
	net.Start("open_appmenu")
	net.Send(ply)
end

concommand.Add("appearance_menu", OpenAppMenu)

local function ManualIdentity(ply, name, args)
	local Maudel, R, G, B, ProperName, Clothes = args[1], tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), "", args[5]
	if not (Maudel and R and B and G and Clothes) then
		ply:PrintMessage(HUD_PRINTTALK, "Wrong file format")
		return
	end
	if not table.HasValue(ModelsAppearance, Maudel) then
		ply:PrintMessage(HUD_PRINTTALK, "Не верная модель персонажа.")
		return
	end
	if not (((R >= 0) and (R <= 1)) and ((G >= 0) and (G <= 1)) and ((B >= 0) and (B <= 1))) then
		ply:PrintMessage(HUD_PRINTTALK, "Установите верный цвет.")

		return
	end
	if not table.HasValue(ClothesAPP, Clothes) then
		ply:PrintMessage(HUD_PRINTTALK, "Не верная одежда.")
		return
	end
	ply.CustomModel = Maudel
	ply.CustomColor = Vector(R, G, B)
	ply.CustomClothes = Clothes
	ply.CustomAccessory = Accessory
	local cl_playermodel, playerModel = ply:GetInfo("cl_playermodel"), table.Random(PlayerModelInfoTable)
	for key, maudhayle in pairs(PlayerModelInfoTable) do
		if maudhayle.model == ply.CustomModel then
			playerModel = maudhayle
			break
		end
	end
end
concommand.Add("checha_appearancemanual", ManualIdentity)