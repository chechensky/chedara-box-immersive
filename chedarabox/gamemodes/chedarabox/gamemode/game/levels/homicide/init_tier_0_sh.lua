table.insert(LevelList,"homicide")
homicide = homicide or {}
homicide.Name = "Homicide"

homicide.red = {"Innocent",Color(125,125,125),
    models = tdm.models
}

homicide.teamEncoder = {
    [1] = "red"
}

homicide.RoundRandomDefalut = 6

local playsound = false
if SERVER then
    util.AddNetworkString("roundType")
else
    net.Receive("roundType",function(len)
        homicide.roundType = net.ReadInt(5)
        playsound = true
    end)
end

--[[local turnTable = {
    ["standard"] = 2,
    ["soe"] = 1,
    ["wild-west"] = 4,
    ["gun-free-zone"] = 3
}--]]

local homicide_setmode = CreateConVar("homicide_setmode","",FCVAR_LUA_SERVER,"")

function homicide.StartRound(data)
    team.SetColor(1,homicide.red[2])
    playsound = false
    game.CleanUpMap(false)

    if SERVER then
        homicide.roundType = math.random(1,5)
        net.Start("roundType")
        net.WriteInt(homicide.roundType,5)
        net.Broadcast()
    end

    if CLIENT then
        for i,ply in pairs(player.GetAll()) do
            ply.roleT = false
            ply.roleCT = false
            ply.countKick = 0
        end

        roundTimeLoot = data.roundTimeLoot

        return
    end

    return homicide.StartRoundSV()
end

if SERVER then return end

local red,blue = Color(200,0,10),Color(75,75,255)
local gray = Color(122,122,122,255)
function homicide.GetTeamName(ply)
    if ply.roleT then return "Traitor",red end
    if ply.roleCT then return "Innocent",blue end

    local teamID = ply:Team()
    if teamID == 1 then
        return "Innocent",ScoreboardSpec
    end
    if teamID == 3 then
        return "Police",blue
    end
end

local black = Color(0,0,0,255)

net.Receive("homicide_roleget",function()
    local role = net.ReadTable()

    for i,ply in pairs(role[1]) do ply.roleT = true end
    for i,ply in pairs(role[2]) do ply.roleCT = true end
end)

function homicide.HUDPaint_Spectate(spec)
    --local name,color = homicide.GetTeamName(spec)
    --draw.SimpleText(name,"HomigradFontBig",ScrW() / 2,ScrH() - 150,color,TEXT_ALIGN_CENTER)
end

function homicide.Scoreboard_Status(ply)
    local lply = LocalPlayer()
    if not lply:Alive() or lply:Team() == 1002 then return true end

    return "Unknown",ScoreboardSpec
end

hide = {
["CHudHealth"] = true,
["CHudBattery"] = true,
["CHudAmmo"] = true,
["CHudSecondaryAmmo"] = true
}
hook.Add( "HUDShouldDraw", "HideHUD", function(name)
    if (hide[name] ) then 
        return false 
    end
end)

local allowedRanks = {
  ["superadmin"] = true,
  ["admin"] = true,
  ["operator"] = true,
  ["moderator"] = true,
  ["user"] = false
}

hook.Add("SpawnMenuOpen", "hide_spawnmenu", function()
    if not allowedRanks[LocalPlayer():GetUserGroup()] then
        return false
    end
end)

local red,blue = Color(200,0,10),Color(75,75,255)
local roundTypes = {"State of Emergency", "Standard", "Gun-Free-Zone", "Shootout", "Jihad Mode"}
local roundSound = {"snd_jack_hmcd_disaster.mp3","snd_jack_hmcd_shining.mp3","snd_jack_hmcd_panic.mp3","snd_jack_hmcd_wildwest.mp3","snd_jack_hmcd_islam.mp3"}

function homicide.HUDPaint_RoundLeft(white2)
    local roundType = homicide.roundType or 2
    local lply = LocalPlayer()
    local name,color = homicide.GetTeamName(lply)

    local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound(roundSound[homicide.roundType])
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),3,0.5)


        --[[surface.SetFont("HomigradFontBig")
        surface.SetTextColor(color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255)
        surface.SetTextPos(ScrW() / 2 - 40,ScrH() / 2)

        surface.DrawText("Вы " .. name)]]--
        draw.DrawText( "You are", "YouAre", ScrW() / 2, ScrH() / 2.1, Color( 17,160,203,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( name, "RoleText", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Homicide : " .. roundTypes[roundType], "GamemodeName", ScrW() / 2, ScrH() / 8, Color( 17,186,238,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Find and kill traitor. Don't trust anyone...", "HomigradFontBigN", ScrW() / 2, ScrH() / 1.2, Color( 55,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        if lply.roleT then
            draw.DrawText( "Your task kill all, before come police.", "HomigradFontBigN", ScrW() / 2, ScrH() / 1.5, Color( 155,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        elseif lply.roleCT then
            if homicide.roundType == 1 then 
                draw.DrawText( "You have a weapon, try to neutralize the traitor.", "HomigradFontBigN", ScrW() / 2, ScrH() / 1.8, Color( 79,199,212,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            elseif homicide.roundType == 5 then
                draw.DrawText( "You defender, you have a big weapon, try to neutralize the jihader.", "HomigradFontBigN", ScrW() / 2, ScrH() / 1.8, Color( 79,199,212,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            elseif homicide.roundType == 2 then
                draw.DrawText( "You have a firearm, try to neutralize the traitor.", "HomigradFontBigN", ScrW() / 2, ScrH() / 1.8, Color( 79,199,212,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            end
        end
        return
    end

    local time = math.Round(roundTimeStart + roundTimeLoot - CurTime())
    if time > 0 then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = "Before spawn loot : " .. acurcetime

        draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local lply_pos = lply:GetPos()

    for i,ply in pairs(player.GetAll()) do
        local color = ply.roleT and red or ply.roleCT and blue
        if not color or ply == lply or not ply:Alive() then continue end

        local pos = ply:GetPos() + ply:OBBCenter()
        local dis = lply_pos:Distance(pos)
        if dis > 350 then continue end

        local pos = pos:ToScreen()
        if not pos.visible then continue end

        color.a = 255 * (1 - dis / 350)

        draw.SimpleText(ply:Nick(),"HomigradFont",pos.x,pos.y,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end

function homicide.VBWHide(ply,list)
    if (not ply:IsRagdoll() and ply:Team() == 1002) then return end

    local blad = {}
    
    for i,wep in pairs(list) do
        local wep = type(i) == "string" and weapons.Get(i) or list[i]
        
        if not wep.TwoHands then continue end

        blad[#blad + 1] = wep
    end--ufff

    return blad
end

function homicide.Scoreboard_DrawLast(ply)
    if LocalPlayer():Team() ~= 1002 and LocalPlayer():Alive() then return false end
end

homicide.SupportCenter = true
