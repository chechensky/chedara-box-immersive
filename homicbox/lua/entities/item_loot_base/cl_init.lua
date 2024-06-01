include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

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


function LootGUI(LootTable, Ent)
	local Frame = vgui.Create( "DFrame" )
    Frame:SetTitle( Ent.PrintName )
    Frame:SetSize( 600,400 )
    Frame:Center()			
    Frame:MakePopup()
    Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        --draw.RoundedBox( 5, 0, 0, w, h, Color( 5, 5, 5, 225 ) ) -- Draw a red box instead of the frame
        BlurBackground(Frame)
	end

	local DPanel = vgui.Create( "DScrollPanel", Frame )
    DPanel:SetPos( 15, 30 ) -- Set the position of the panel
    DPanel:SetSize( 570, 335 ) -- Set the size of the panel
    DPanel.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 155) )
        --BlurBackground(DPanel)
    end
	local DLabel = vgui.Create( "DLabel", Frame )
	DLabel:SetPos( 20, 375 )
    DLabel:SetText( "ЛКМ - Взять (при возможности...)    |    ПКМ - Скинуть" )
    DLabel:SizeToContents()

	for k,v in pairs(LootTable) do
		if v[1] == "weapon" then
			local DermaButton = vgui.Create( "DButton", DPanel ) 
			DermaButton:SetText( weapons.Get(k).PrintName )	
			DermaButton:SetTextColor( Color(255,255,255) )				
			DermaButton:SetPos( 0, 0 )	
			DermaButton:Dock( TOP )
			DermaButton:DockMargin( 5, 5, 5, 0 )				
			DermaButton:SetSize( 120, 40 )	
			DermaButton.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
				draw.RoundedBox( 0, 0, 0, w, h, Color( 5, 5, 5, 155) )
				--BlurBackground(DermaButton)
			end
			DermaButton.DoClick = function()
                --print( math.min(ammodrop,v),game.GetAmmoName( k ))				
                net.Start( "give_gun" )
                    net.WriteString(k)
					net.WriteEntity(Ent)
                net.SendToServer()
                Frame:Close()
            end	

			DermaButton.DoRightClick = function()
				net.Start( "drop_ent" )
					net.WriteString(k)
					net.WriteEntity(Ent)
				net.SendToServer()
				Frame:Close()	
			end

		elseif v[1] == "ent" then
			local DermaButton = vgui.Create( "DButton", DPanel ) 
			DermaButton:SetText( scripted_ents.Get(k).PrintName )	
			DermaButton:SetTextColor( Color(255,255,255) )				
			DermaButton:SetPos( 0, 0 )	
			DermaButton:Dock( TOP )
			DermaButton:DockMargin( 5, 5, 5, 0 )				
			DermaButton:SetSize( 120, 40 )	
			DermaButton.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
				draw.RoundedBox( 0, 0, 0, w, h, Color( 5, 5, 5, 155) )
				--BlurBackground(DermaButton)
			end

			DermaButton.DoRightClick = function()
				net.Start( "drop_ent" )
					net.WriteString(k)
					net.WriteEntity(Ent)
				net.SendToServer()
				Frame:Close()	
			end
		end
	end
end

net.Receive( "lootstart", function( len, ply )
	LootGUI(net.ReadTable(),net.ReadEntity())
end)