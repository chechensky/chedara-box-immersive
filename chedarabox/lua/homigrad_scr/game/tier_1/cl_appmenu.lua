local faded_black = Color(0, 0, 0, 200)
local AppearanceMenuOpen, Frame = false, nil
local function OpenMenu(ply)
	if AppearanceMenuOpen then return end
	AppearanceMenuOpen = true
	local ply = LocalPlayer()
	Frame = vgui.Create("DFrame")
	Frame:SetSize(500, 400)
	Frame:Center()
	Frame:SetTitle("")
	Frame:SetDraggable(false)
	Frame:ShowCloseButton(true)
	Frame:MakePopup()
	Frame.Paint = function(self, w, h)
	    draw.RoundedBox(2, 0, 0, w, h, faded_black)
	    draw.SimpleText("Appearance Menu", "HomigradFontBig", 250, 5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	Frame.OnClose = function()
		AppearanceMenuOpen = false
	end
	local MdlSelect = vgui.Create("DComboBox", Frame)
	MdlSelect:SetPos(10, 50)
	MdlSelect:SetSize(150, 20)
	MdlSelect:SetValue("Model")
	for k, v in pairs(ModelsAppearance) do
		MdlSelect:AddChoice(v)
	end
	MdlSelect.OnSelect = function(panel, index, value) end
	local CSelect = vgui.Create("DComboBox", Frame)
	CSelect:SetPos(10, 80)
	CSelect:SetSize(150, 20)
	CSelect:SetValue("Style Clothes")
	for k, v in pairs(ClothesAPP) do
		CSelect:AddChoice(v)
	end
	local Mixer = vgui.Create("DColorMixer", Frame)
	Mixer:SetPos(10, 160)
	Mixer:SetSize(200, 100)
	Mixer:SetPalette(false)
	Mixer:SetAlphaBar(false)
	Mixer:SetWangs(false)
	Mixer:SetColor(Color(128, 128, 128))
	local CLabel = vgui.Create("DLabel", Frame)
	CLabel:SetPos(10, 130)
	CLabel:SetSize(100, 40)
	CLabel:SetColor(Color(Mixer:GetColor().r, Mixer:GetColor().g, Mixer:GetColor().b, 254))
	CLabel:SetText("Color Clothes")
	local ASelect = vgui.Create("DComboBox", Frame)
	ASelect:SetPos(10, 110)
	ASelect:SetSize(150, 20)
	ASelect:SetValue("Accessories - Don't Work")
	local DermaButton = vgui.Create("DButton", Frame)
	DermaButton:SetText("Change model")
	DermaButton:SetPos(5, 320)
	DermaButton:SetSize(200, 40)
	if file.Exists("chedarabox_identity.txt", "DATA") then
		local vartxt = string.Split(file.Read("chedarabox_identity.txt", "DATA"), "\n")
		MdlSelect:SetValue(tostring(vartxt[1]))
		Mixer:SetColor({r = tostring(vartxt[2] * 255), g = tostring(vartxt[3] * 255), b = tostring(vartxt[4] * 255), a = 255})
		CSelect:SetValue(tostring(vartxt[5]))
	end
	local ClothesW = {"normal", "normal", "normal", "striped", "plaid", "casual", "formal", "young", "cold"}
	local Type = table.Random(ClothesW)
	local Maudel, R, G, B, Clothes = MdlSelect:GetValue(), Mixer:GetColor().r / 255, Mixer:GetColor().g / 255, Mixer:GetColor().b / 255, CSelect:GetValue()
	local value = Maudel
	value = value:gsub("(%a)(%d)", "%1_%2")
	local kek = Maudel
	local kek2 = player_manager.TranslatePlayerModel(kek)
	util.PrecacheModel(kek2)
	local playerModelPanel = vgui.Create("DModelPanel", Frame)
	playerModelPanel:SetSize(370, 370)
	playerModelPanel:SetPos(200, 25)
	playerModelPanel:SetModel(kek2)
	function MdlSelect:OnSelect(index, text, data)
		local playerModel = text
		local modelname = player_manager.TranslatePlayerModel(playerModel)
		util.PrecacheModel(modelname)
		playerModelPanel:SetModel(modelname)
	end
	function playerModelPanel:PostDrawModel(ent)
		if Maudel == "male01" or Maudel == "male02" or Maudel == "male03" or Maudel == "male04" or Maudel == "male05" or Maudel == "male06" or Maudel == "male07" or Maudel == "male08" or Maudel == "male09"  then
			if Maudel == "male03" or Maudel == "male04" or Maudel == "male05" or Maudel == "male07" then
				ent:SetSubMaterial(4, "models/humans/male/group01/"..CSelect:GetValue())
			end
			if Maudel == "male01" then
				ent:SetSubMaterial(3, "models/humans/male/group01/"..CSelect:GetValue())
			end
			if Maudel == "male06" or Maudel == "male08" then
				ent:SetSubMaterial(0, "models/humans/male/group01/"..CSelect:GetValue())
			end
			if Maudel == "male09" or Maudel == "male02" then
				ent:SetSubMaterial(4, "models/humans/male/group01/"..CSelect:GetValue())
			end
		end

		if Maudel == "female01" or Maudel == "female02" or Maudel == "female03" or Maudel == "female04" or Maudel == "female05" then
			if  Maudel == "female02" or Maudel == "female03" then
				ent:SetSubMaterial(3, "models/humans/female/group01/"..CSelect:GetValue())
			end
			if Maudel == "female01" or Maudel == "female05" then
				ent:SetSubMaterial(2, "models/humans/female/group01/"..CSelect:GetValue())
			end
			if Maudel == "female04" then
				ent:SetSubMaterial(1, "models/humans/female/group01/"..CSelect:GetValue())
			end
		end
	end
	function playerModelPanel:LayoutEntity(ent)
    	ent:SetAngles(Angle(0, RealTime() * 150, 0))
	end
	DermaButton.DoClick = function()
		local Maudel, R, G, B, Clothes = MdlSelect:GetValue(), Mixer:GetColor().r / 255, Mixer:GetColor().g / 255, Mixer:GetColor().b / 255, CSelect:GetValue()
		RunConsoleCommand("checha_appearancemanual", Maudel, R, G, B, Clothes, Accessory)
		local RawData = tostring(Maudel) .. "\n" .. tostring(R) .. "\n" .. tostring(G) .. "\n" .. tostring(B) .. "\n" .. tostring(Clothes) .. "\n" .. tostring(Accessory)
		file.Write("chedarabox_identity.txt", RawData)
		Frame:Close()
		AppearanceMenuOpen = false
	end
end
net.Receive("lutiiikol",function()
	local ply = net.ReadEntity()
	ply.ModelSex = net.ReadString()
	ply.Accessory = net.ReadString()
	ply.AccessoryModel = nil 
end)

net.Receive("open_appmenu",function()
	OpenMenu(ply)
end)