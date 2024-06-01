survival.GetTeamName = survival.GetTeamName

function survival.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = survival.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("checha/survival_start.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)


        --[[surface.SetFont("HomigradFontBig")
        surface.SetTextColor(color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255)
        surface.SetTextPos(ScrW() / 2 - 40,ScrH() / 2)

        surface.DrawText("Вы " .. name)]]--
        local nameWithoutLastS = string.sub(name, 1, -2)
        draw.DrawText( "You are", "YouAre", ScrW() / 2, ScrH() / 2.1, Color( 17,160,203,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( nameWithoutLastS, "RoleText", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Survival", "GamemodeName", ScrW() / 2, ScrH() / 8, Color( 195,82,82,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Looter Shooter", "GamemodeName", ScrW() / 2, ScrH() / 6, Color( 119,128,132,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        --draw.DrawText( roundTypes[roundType], "HomigradFontBig", ScrW() / 2, ScrH() / 5, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )

        draw.DrawText( "Kill all in enemy team...", "HomigradFontBigN", ScrW() / 2, ScrH() / 1.2, Color( 55,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        return
    end
end