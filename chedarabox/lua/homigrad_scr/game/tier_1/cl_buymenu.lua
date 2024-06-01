local faded_black = Color(0, 0, 0, 200)
local AppearanceMenuOpen, Frame = false, nil
local function OpenBuyMenu(ply)
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
	    draw.SimpleText("Buy Menu", "HomigradFontBig", 250, 5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	Frame.OnClose = function()
		AppearanceMenuOpen = false
	end
	local DermaButton = vgui.Create("DButton", Frame)
	DermaButton:SetText("Change model")
	DermaButton:SetPos(5, 320)
	DermaButton:SetSize(200, 40)
	DermaButton.DoClick = function()
		local Maudel, R, G, B, Clothes = MdlSelect:GetValue(), Mixer:GetColor().r / 255, Mixer:GetColor().g / 255, Mixer:GetColor().b / 255, CSelect:GetValue()
		RunConsoleCommand("checha_appearancemanual", Maudel, R, G, B, Clothes, Accessory)
		local RawData = tostring(Maudel) .. "\n" .. tostring(R) .. "\n" .. tostring(G) .. "\n" .. tostring(B) .. "\n" .. tostring(Clothes) .. "\n" .. tostring(Accessory)
		file.Write("chedarabox_identity.txt", RawData)
		Frame:Close()
		AppearanceMenuOpen = false
	end
end

concommand.Add("buymenu", function(ply)
	if roundActiveName != nil and roundActiveName != "tdm" then print("ТОКА В ТДМ" ) return end
	OpenBuyMenu(ply)
end)