util.AddNetworkString("round")
util.AddNetworkString("round_next")

function RoundActiveSync(ply)
    net.Start("round")
    net.WriteString(roundActiveName)
    if ply then net.Send(ply) else net.Broadcast() end
end

function RoundActiveNextSync(ply)
    net.Start("round_next")
    net.WriteString(roundActiveNameNext)
    if ply then net.Send(ply) else net.Broadcast() end
end

function SetActiveRound(name)
    if not _G[name] then return false end
    roundActiveName = name

    RoundActiveSync()

    return true
end

function SetActiveNextRound(name)
    if not _G[name] then return false end
    roundActiveNameNext = name

    RoundActiveNextSync()

    return true
end

LevelList = {}

function TableRound(name) return _G[name or roundActiveName] end

hook.Add("Think", "kek", function()
    if roundActiveNameNext == "homicide" or roundActiveNameNext == "tdm" or roundActiveNameNext == "schoolshoot" or roundActiveNameNext == "construct" or roundActiveNameNext == "gangwars" or roundActiveNameNext == "survival" then return end

    if roundActiveNameNext != "homicide" or roundActiveNameNext != "tdm" or roundActiveNameNext != "schoolshoot" or roundActiveNameNext != "construct" or roundActiveNameNext != "gangwars" or roundActiveNameNext != "survival" then
        SetActiveNextRound("homicide")
        PrintMessage(3, "Sorry, only Homicide or TDM or Shooting or Sandbox or Gang Wars or Survival.")
    end
end)

concommand.Add("tdm_gamemode", function(ply)
    if ply:IsAdmin() then
        SetActiveNextRound("tdm")
    else
    end
end)

concommand.Add("hmcd_gamemode", function(ply)
    if ply:IsAdmin() then
        SetActiveNextRound("homicide")
    else
    end
end)

concommand.Add("survival_gamemode", function(ply)
    if ply:IsAdmin() then
        SetActiveNextRound("survival")
    else
    end
end)

concommand.Add("gw_gamemode", function(ply)
    if ply:IsAdmin() then
        SetActiveNextRound("gangwars")
    else
    end
end)

concommand.Add("sandbox_gamemode", function(ply)
    if ply:IsAdmin() then
        SetActiveNextRound("construct")
    else
    end
end)

concommand.Add("mosque_gamemode", function(ply)
    if ply:IsAdmin() then
        --if game.GetMap() == "masjid_mosque" then
            SetActiveNextRound("schoolshoot")
        --else
            print("Map is not Mosque.")
        --end
    else
    end
end)

hook.Add("Think", "MosqueShooting", function()
    if game.GetMap() != "masjid_mosque" then return end
    if game.GetMap() == "masjid_mosque" and roundActiveNameNext != "schoolshoot" then
        SetActiveNextRound("schoolshoot")
    end
end)