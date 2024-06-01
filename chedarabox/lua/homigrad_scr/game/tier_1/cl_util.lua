local function hasWeapon(ply, weaponName)
    if not IsValid(ply) or not ply:IsPlayer() then return false end -- Проверяем, является ли объект игроком и существует ли он
    
    for _, weapon in pairs(ply:GetWeapons()) do -- Перебираем все оружия игрока
        if IsValid(weapon) and weapon:GetClass() == weaponName then -- Проверяем, является ли оружие действительным и совпадает ли его класс с заданным названием
            return true -- Если нашли оружие, возвращаем true
        end
    end
    
    return false 
end

--[[
local function ToggleMenu(toggle)
    if toggle then
        local w,h = ScrW(), ScrH()
        if IsValid(wepMenu) then wepMenu:Remove() end
        local lply = LocalPlayer()
        local wep = lply:GetActiveWeapon()
        if IsValid(wep) then
        wepMenu = vgui.Create("DMenu")
        wepMenu:SetPos(w/3,h/2)
        wepMenu:MakePopup()
        wepMenu:SetKeyboardInputEnabled(false)
		if wep:GetClass() ~= "weapon_hands" then
			local option = wepMenu:AddOption("Выкинуть",function()
				LocalPlayer():ConCommand("say *drop")
			end)
			option:SetIcon("icon16/gun.png")
		end
		if wep:GetClass() == "weapon_kabar" or wep:GetClass() == "weapon_knife" or wep:GetClass() == "weapon_sogknife" then
			local option = wepMenu:AddOption("Сменить тип атаки",function()
				LocalPlayer():ConCommand("+changeattack")
			end)
			option:SetIcon("icon16/attach.png")
		end
		if wep:GetClass() == "weapon_kabar" or wep:GetClass() == "weapon_knife" or wep:GetClass() == "weapon_sogknife" then
			if hasWeapon(lply, "weapon_hg_t_kurarepoison") == true then
				local option = wepMenu:AddOption("Отравить лезвие ядом",function()
					net.Start("Kurare")
                	net.SendToServer()
				end)
				option:SetIcon("icon16/package.png")
			end
		end
        if wep:Clip1() > 0 then
            local option = wepMenu:AddOption("Разрядить",function()
                net.Start("Unload")
                net.WriteEntity(wep)
                net.SendToServer()
            end)
			option:SetIcon("icon16/arrow_redo.png")
		end
		if wep:Clip1() > -1 then
            local option = wepMenu:AddOption("Проверить кол-во патрон",function()
                ply:ChatPrint("В магазине: "..wep:Clip1().."/"..wep:GetMaxClip1().." - "..game.GetAmmoData(wep:GetPrimaryAmmoType()).name)
				ply:EmitSound("snd_jack_hmcd_ammobox.wav")
            end)
			option:SetIcon("icon16/magnifier.png")
		end
        end

		plyMenu = vgui.Create("DMenu")
        plyMenu:SetPos(w/1.8,h/2)
        plyMenu:MakePopup()
        plyMenu:SetKeyboardInputEnabled(false)

        local submenu, parentmenu = plyMenu:AddSubMenu("Броня")
        parentmenu:SetIcon("icon16/user_green.png")
			local option = submenu:AddOption("Меню Брони",function()
	            LocalPlayer():ConCommand("jmod_ez_inv")
	        end)
	        option:SetIcon("icon16/table_gear.png")
	        
		local option = plyMenu:AddOption("Меню Патрон",function()
			LocalPlayer():ConCommand("hg_ammomenu")
		end)
		option:SetIcon("icon16/box.png")
		local option = plyMenu:AddOption("Настройка внешности",function()
			LocalPlayer():ConCommand("appearance_menu")
		end)
		option:SetIcon("icon16/book_addresses.png")
		local option = plyMenu:AddOption("Вызвать рвоту",function()
			LocalPlayer():ConCommand("hg_blevota")
		end)
		option:SetIcon("icon16/bug.png")
		local option = plyMenu:AddOption("Встать/Упасть",function()
			LocalPlayer():ConCommand("fake")
		end)
		option:SetIcon("icon16/bullet_green.png")
		local EZarmor = LocalPlayer().EZarmor
		if JMod.GetItemInSlot(EZarmor, "eyes") then
			local option = plyMenu:AddOption("Активировать Маску/Забрало",function()
				LocalPlayer():ConCommand("jmod_ez_toggleeyes")
			end)
			option:SetIcon("icon16/arrow_up.png")
		end
    else
		if IsValid(wepMenu) then
        	wepMenu:Remove()
		end
		if IsValid(plyMenu) then
        	plyMenu:Remove()
		end
    end
end--]]

hook.Add("HUDPaint", "DrawChedaraBox", function()
	local ply = LocalPlayer()
    local boxch = "Chedara Box"
	local verch = "Version 0.1.2"
	local authors = "Server by checha, Bara, quezkaly, Mannytko"
	local colortext = Color(127,129,129,255)
    local posX, posY = 1783, 5 -- координаты, где вы хотите отобразить текст
	draw.SimpleTextOutlined(boxch, "HomigradFontBig", posX, posY, colortext, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ))
	draw.SimpleTextOutlined(verch, "HomigradFontBig", posX, posY + 20, colortext, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ))
	draw.SimpleTextOutlined(authors, "HomigradFontBig", posX - 290, posY + 40, colortext, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ))
	draw.SimpleTextOutlined("HomicBox by sadsalat", "HomigradFontBig", posX - 80, posY + 60, colortext, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ))
end)
--[[
local active,oldValue
hook.Add("Think","Thinkhuyhuy",function()
	active = input.IsKeyDown(KEY_C)
	if oldValue ~= active then
		oldValue = active
		
		if active then
			ToggleMenu(true)
		else
			ToggleMenu(false)
		end
	end
end)--]]


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
--[[
surface.CreateFont( "Pornograpy", {
	font = "Coolvetica Rg", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 55,
	weight = 1500,
	blursize = 1,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

hook.Add( "HUDPaint", "Pornograpy", function()
	draw.DrawText( "Pornograpy", "Pornograpy", ScrW() * 0.5, ScrH() * 0.35, color_white, TEXT_ALIGN_CENTER )
end )

local g_station = nil
sound.PlayURL ( "https://cdn.discordapp.com/attachments/1154042672554725426/1159907648993497179/pornography.mp3?ex=6532bb2d&is=6520462d&hm=c494b690757c362f7d4a9dac6117f1502382d27972c44b54b485d70ef0696c91&", "mono", function( station )
	if ( IsValid( station ) ) then

		station:SetPos( LocalPlayer():GetPos() )
	
		station:Play()

		-- Keep a reference to the audio object, so it doesn't get garbage collected which will stop the sound
		g_station = station
	
	else

		LocalPlayer():ChatPrint( "Invalid URL!" )

	end
end )

timer.Simple(5,function()
	hook.Remove("HUDPaint", "Pornograpy") 
end)]]--

surface.CreateFont("Respawn_Text", {
    font = "Coolvetica Rg",
    size = 32,
    weight = 500,
    antialias = true
})


net.Receive("removeDhud", HideHUD)

concommand.Add("lungshit", function(ply)
	ply:SetNWBool("LeftLeg_HitShow", true)
	ply:SetNWBool("RightLeg_HitShow", true)
end)

hook.Add("HUDPaint", "DrawBlackSquare", function()
	local ply = LocalPlayer()
    if ply:GetNWBool("CloseEye", false) == true then
        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    else
        surface.SetDrawColor(0, 0, 0, 0)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end
end)

if CLIENT then
    local blurMat = Material("pp/blurscreen")
    local Dynamic = 0 
    local function BlurBackground(panel)
        if not((IsValid(panel))and(panel:IsVisible()))then return end
        local layers,density,alpha=1,1,255
        local x,y=panel:LocalToScreen(0,0)
        surface.SetDrawColor(255,255,255,alpha)
        surface.SetMaterial(blurMat)
        local FrameRate,Num,Dark=1/FrameTime(),5,150
        for i=1,Num do
            blurMat:SetFloat("$blur",(i/layers)*density*Dynamic)
            blurMat:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
        end
        surface.SetDrawColor(0,0,0,Dark*Dynamic)
        surface.DrawRect(0,0,panel:GetWide(),panel:GetTall())
        Dynamic=math.Clamp(Dynamic+(1/FrameRate)*7,0,1)
    end

    function ModifyWepMenu(ply)
        local ammodrop = 0
        if !ply:Alive() then return end
        local Frame = vgui.Create( "DFrame" )
        Frame:SetTitle( "Attachments" )
        Frame:SetSize( 250,320 )
        Frame:Center()			
        Frame:MakePopup()
        Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
            --draw.RoundedBox( 5, 0, 0, w, h, Color( 5, 5, 5, 225 ) ) -- Draw a red box instead of the frame
            BlurBackground(Frame)
        end
        local DPanel = vgui.Create( "DScrollPanel", Frame )
        DPanel:SetPos( 5, 40 ) -- Set the position of the panel
        DPanel:SetSize( 240, 220 ) -- Set the size of the panel
        DPanel.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
            BlurBackground(DPanel)
        end

        local sbar = DPanel:GetVBar()
        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(115, 115, 115))
        end
        function sbar.btnUp:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(155, 145, 145))
        end
        function sbar.btnDown:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(145, 145, 145))
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(195, 195, 195))
        end
		if ply:GetNWBool("PLY_Supressor762", false) == true or ply:GetActiveWeapon():GetNWBool("WEP_SupressorAK", false) == true then

        	local DermaButton = vgui.Create( "DButton", DPanel ) 
        	DermaButton:SetText("PBS-1 - 7.62" .. (ply:GetActiveWeapon():GetNWBool("WEP_SupressorAK", false) == true and " - on weapon" or ""))
        	DermaButton:SetTextColor( Color(255,255,255) )				
        	DermaButton:SetPos( 0, 0 )	
        	DermaButton:Dock( TOP )
        	DermaButton:DockMargin( 5, 5, 5, 0 )			
        	DermaButton:SetSize( 120, 20 )	
        	DermaButton.Paint = function( self, w, h )
            	draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 155) )
        	end

			if ply:GetActiveWeapon():GetNWBool("Suppressor",false) == false and ply:GetActiveWeapon():GetNWBool("WEP_SupressorAK", false) == false and ply:GetActiveWeapon():GetPrimaryAmmoType() == 54 or ply:GetActiveWeapon():GetPrimaryAmmoType() == 52 then
        		DermaButton.DoClick = function()
					ply:ConCommand("attachment_put 762suppressor")
					DermaButton:Remove()
        		end
			end

			if ply:GetActiveWeapon():GetNWBool("WEP_SupressorAK", false) == true then
        		DermaButton.DoRightClick = function()
					ply:ConCommand("attachment_remove 762suppressor")
					DermaButton:Remove()
        		end
			end

			DermaButton.DoMiddleClick = function()
				ply:ConCommand("attachment_drop 762suppressor")
				DermaButton:Remove()
			end

		end

		if ply:GetNWBool("PLY_Supressor12Gauge", false) == true or ply:GetActiveWeapon():GetNWBool("WEP_SupressorShotgun", false) == true then

        	local DermaButton = vgui.Create( "DButton", DPanel ) 
        	DermaButton:SetText("Rotor 43 - 12/70 Gauge" .. (ply:GetActiveWeapon():GetNWBool("WEP_SupressorShotgun", false) == true and " - on weapon" or ""))
        	DermaButton:SetTextColor( Color(255,255,255) )				
        	DermaButton:SetPos( 0, 0 )	
        	DermaButton:Dock( TOP )
        	DermaButton:DockMargin( 5, 5, 5, 0 )			
        	DermaButton:SetSize( 120, 20 )	
        	DermaButton.Paint = function( self, w, h )
            	draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 155) )
        	end

			if ply:GetActiveWeapon():GetNWBool("Suppressor",false) == false and ply:GetActiveWeapon():GetNWBool("WEP_SupressorShotgun", false) == false and ply:GetActiveWeapon():GetPrimaryAmmoType() == 46 then
        		DermaButton.DoClick = function()
					ply:ConCommand("attachment_put 12suppressor")
					DermaButton:Remove()
        		end
			end

			if ply:GetActiveWeapon():GetNWBool("WEP_SupressorShotgun", false) == true then
        		DermaButton.DoRightClick = function()
					ply:ConCommand("attachment_remove 12suppressor")
					DermaButton:Remove()
        		end
			end

			DermaButton.DoMiddleClick = function()
				ply:ConCommand("attachment_drop 12suppressor")
				DermaButton:Remove()
			end

		end

		if ply:GetNWBool("PLY_Supressor9x19", false) == true or ply:GetActiveWeapon():GetNWBool("WEP_Supressor919", false) == true then

        	local DermaButton = vgui.Create( "DButton", DPanel ) 
        	DermaButton:SetText("Osprey 9 - 9x19" .. (ply:GetActiveWeapon():GetNWBool("WEP_Supressor919", false) == true and " - on weapon" or ""))
        	DermaButton:SetTextColor( Color(255,255,255) )				
        	DermaButton:SetPos( 0, 0 )	
        	DermaButton:Dock( TOP )
        	DermaButton:DockMargin( 5, 5, 5, 0 )			
        	DermaButton:SetSize( 120, 20 )	
        	DermaButton.Paint = function( self, w, h )
            	draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 155) )
        	end

			if ply:GetActiveWeapon():GetNWBool("Suppressor",false) == false and ply:GetActiveWeapon():GetNWBool("WEP_Supressor919", false) == false and ply:GetActiveWeapon():GetPrimaryAmmoType() == 57 then
        		DermaButton.DoClick = function()
					ply:ConCommand("attachment_put 9x19suppressor")
					DermaButton:Remove()
        		end
			end

			if ply:GetActiveWeapon():GetNWBool("WEP_Supressor919", false) == true then
        		DermaButton.DoRightClick = function()
					ply:ConCommand("attachment_remove 9x19suppressor")
					DermaButton:Remove()
        		end
			end

			DermaButton.DoMiddleClick = function()
				ply:ConCommand("attachment_drop 9x19suppressor")
				DermaButton:Remove()
			end

		end

		if ply:GetNWBool("PLY_OKPSight7", false) == true or ply:GetActiveWeapon():GetNWBool("WEP_OKP7Sight", false) == true then

        	local DermaButton = vgui.Create( "DButton", DPanel ) 
        	DermaButton:SetText("Dovetail OKP7 - Family AK" .. (ply:GetActiveWeapon():GetNWBool("WEP_OKP7Sight", false) == true and " - on weapon" or ""))
        	DermaButton:SetTextColor( Color(255,255,255) )				
        	DermaButton:SetPos( 0, 0 )	
        	DermaButton:Dock( TOP )
        	DermaButton:DockMargin( 5, 5, 5, 0 )			
        	DermaButton:SetSize( 120, 20 )	
        	DermaButton.Paint = function( self, w, h )
            	draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 155) )
        	end

			if ply:GetActiveWeapon():GetNWBool("Sight",false) == false and ply:GetActiveWeapon():GetNWBool("WEP_OKP7Sight", false) == false and ply:GetActiveWeapon():GetClass() == "weapon_sib_asval" or ply:GetActiveWeapon():GetClass() == "weapon_sib_akm" or ply:GetActiveWeapon():GetClass() == "weapon_sib_rpk" then
        		DermaButton.DoClick = function()
					ply:ConCommand("attachment_put okp7sight")
					DermaButton:Remove()
        		end
			end

			if ply:GetActiveWeapon():GetNWBool("WEP_OKP7Sight", false) == true then
        		DermaButton.DoRightClick = function()
					ply:ConCommand("attachment_remove okp7sight")
					DermaButton:Remove()
        		end
			end

			DermaButton.DoMiddleClick = function()
				ply:ConCommand("attachment_drop okp7sight")
				DermaButton:Remove()
			end

		end

		if ply:GetNWBool("PLY_EOTech553", false) == true or ply:GetActiveWeapon():GetNWBool("WEP_Eotech553", false) == true then

        	local DermaButton = vgui.Create( "DButton", DPanel ) 
        	DermaButton:SetText("EOTech 553 - Family AR" .. (ply:GetActiveWeapon():GetNWBool("WEP_Eotech553", false) == true and " - on weapon" or ""))
        	DermaButton:SetTextColor( Color(255,255,255) )				
        	DermaButton:SetPos( 0, 0 )	
        	DermaButton:Dock( TOP )
        	DermaButton:DockMargin( 5, 5, 5, 0 )			
        	DermaButton:SetSize( 120, 20 )	
        	DermaButton.Paint = function( self, w, h )
            	draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 155) )
        	end

			if ply:GetActiveWeapon():GetNWBool("Sight",false) == false and ply:GetActiveWeapon():GetNWBool("WEP_Eotech553", false) == false and ply:GetActiveWeapon():GetClass() == "weapon_sib_hk416" then
        		DermaButton.DoClick = function()
					ply:ConCommand("attachment_put eotech553")
					DermaButton:Remove()
        		end
			end

			if ply:GetActiveWeapon():GetNWBool("WEP_Eotech553", false) == true then
        		DermaButton.DoRightClick = function()
					ply:ConCommand("attachment_remove eotech553")
					DermaButton:Remove()
        		end
			end

			DermaButton.DoMiddleClick = function()
				ply:ConCommand("attachment_drop eotech553")
				DermaButton:Remove()
			end

		end
		if ply:GetNWBool("PLY_Mark4Leupold", false) == true or ply:GetActiveWeapon():GetNWBool("WEP_LeupoldMark4Hamr", false) == true then

        	local DermaButton = vgui.Create( "DButton", DPanel ) 
        	DermaButton:SetText("Leupold Mark4 Hamr - Family AK" .. (ply:GetActiveWeapon():GetNWBool("WEP_LeupoldMark4Hamr", false) == true and " - on weapon" or ""))
        	DermaButton:SetTextColor( Color(255,255,255) )				
        	DermaButton:SetPos( 0, 0 )	
        	DermaButton:Dock( TOP )
        	DermaButton:DockMargin( 5, 5, 5, 0 )			
        	DermaButton:SetSize( 120, 20 )	
        	DermaButton.Paint = function( self, w, h )
            	draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 155) )
        	end

			if ply:GetActiveWeapon():GetNWBool("Sight",false) == false and ply:GetActiveWeapon():GetNWBool("WEP_LeupoldMark4Hamr", false) == false and ply:GetActiveWeapon():GetClass() == "weapon_sib_asval" or ply:GetActiveWeapon():GetClass() == "weapon_sib_akm" or ply:GetActiveWeapon():GetClass() == "weapon_sib_rpk" then
        		DermaButton.DoClick = function()
					ply:ConCommand("attachment_put leupoldmark4")
					DermaButton:Remove()
        		end
			end

			if ply:GetActiveWeapon():GetNWBool("WEP_LeupoldMark4Hamr", false) == true then
        		DermaButton.DoRightClick = function()
					ply:ConCommand("attachment_remove leupoldmark4")
					DermaButton:Remove()
        		end
			end

			DermaButton.DoMiddleClick = function()
				ply:ConCommand("attachment_drop leupoldmark4")
				DermaButton:Remove()
			end

		end

		if ply:GetNWBool("PLY_PSO1M2", false) == true or ply:GetActiveWeapon():GetNWBool("WEP_PSO1M2", false) == true then

        	local DermaButton = vgui.Create( "DButton", DPanel ) 
        	DermaButton:SetText("PSO1-M2 - Family AK" .. (ply:GetActiveWeapon():GetNWBool("WEP_PSO1M2", false) == true and " - on weapon" or ""))
        	DermaButton:SetTextColor( Color(255,255,255) )				
        	DermaButton:SetPos( 0, 0 )	
        	DermaButton:Dock( TOP )
        	DermaButton:DockMargin( 5, 5, 5, 0 )			
        	DermaButton:SetSize( 120, 20 )	
        	DermaButton.Paint = function( self, w, h )
            	draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 155) )
        	end

			if ply:GetActiveWeapon():GetNWBool("Sight",false) == false and ply:GetActiveWeapon():GetNWBool("WEP_PSO1M2", false) == false and ply:GetActiveWeapon():GetClass() == "weapon_sib_asval" or ply:GetActiveWeapon():GetClass() == "weapon_sib_akm" or ply:GetActiveWeapon():GetClass() == "weapon_sib_rpk" or ply:GetActiveWeapon():GetClass() == "weapon_sib_mosin" then
        		DermaButton.DoClick = function()
					ply:ConCommand("attachment_put pso1m2")
					DermaButton:Remove()
        		end
			end

			if ply:GetActiveWeapon():GetNWBool("WEP_PSO1M2", false) == true then
        		DermaButton.DoRightClick = function()
					ply:ConCommand("attachment_remove pso1m2")
					DermaButton:Remove()
        		end
			end

			DermaButton.DoMiddleClick = function()
				ply:ConCommand("attachment_drop pso1m2")
				DermaButton:Remove()
			end

		end

        local DLabel = vgui.Create( "DLabel", Frame )
        DLabel:SetPos( 10, 270 )
        DLabel:SetText("LMB - Put Attachment\nRMB - Remove Attachment\nMMB - Drop Attachment")
        DLabel:SetTextColor(Color(255,255,255))
        DLabel:SizeToContents()
    end
    concommand.Add( "checha_modifyweapon", function( ply, cmd, args )
        ModifyWepMenu(ply)
    end )
end

concommand.Add("checha_damage_logs", function(ply)
    local logWindow = vgui.Create("DFrame") 
	local faded_black = Color(0, 0, 0, 200)
	logWindow:SetSize(500, 400)
	logWindow:Center()
	logWindow:SetTitle("")
	logWindow:SetDraggable(false)
	logWindow:ShowCloseButton(true)
	logWindow:MakePopup()
	logWindow.Paint = function(self, w, h)
	    draw.RoundedBox(2, 0, 0, w, h, faded_black)
	    draw.SimpleText("Damage Logs", "HomigradFontBig", 250, 5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

    local logPanel = vgui.Create("DPanel", logWindow)
    logPanel:Dock(FILL)
    local logs = string.Explode(",", ply:GetNWString("dmglogs"))

    for _, log in ipairs(logs) do
        log = log:gsub("[\"%[%]]", "")
        log = string.Trim(log)
        local logText = vgui.Create("DLabel", logPanel)
        logText:Dock(TOP)
		logText:SetContentAlignment(2)
        logText:SetFont("DermaDefault")
        logText:SetText(log)
		logText:SetColor(Color(57,57,57,255))
    end
	local kbhit = vgui.Create("DLabel", logPanel)
	kbhit:Dock(RIGHT)
	kbhit:SetFont("HomigradFont")
	kbhit:SetText("Stab hits: " .. ply:GetNWInt("knifehit",0) .. "\n" .. "Bullet hits: " .. ply:GetNWInt("bullethit",0))
	kbhit:SetSize(100,100)
	kbhit:SetColor(Color(57,57,57,255))
end)