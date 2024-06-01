function addDamageLog(ply, hit, typedmg)
    local currentTime = os.date("%H:%M:%S")
    local log = currentTime .. " - " .. hit .. " - " .. typedmg
    table.insert(ply.logs_damage, log)
end

function resetDamageLog(ply)
    ply.logs_damage = {}
end

hook.Add("PlayerSpawn", "varslolsyncmdksf", function(ply)
    resetDamageLog(ply)
    ply:SetNWInt("bullethit", 0)
    ply:SetNWInt("knifehit", 0)
end)

hook.Add("PlayerPostThink", "ichonasdnj", function(ply)
    local jsonLogs = util.TableToJSON(ply.logs_damage)
    ply:SetNWString("dmglogs", jsonLogs)
end)

concommand.Add("checha_logsdamage", function(ply)
    print(table.ToString(ply.logs_damage))
    print(ply:GetNWString("dmglogs"))
end)

hook.Add("EntityTakeDamage", "rega", function(ply,dmg)
    if dmg:IsDamageType(DMG_SLASH) then
        ply:SetNWInt("knifehit", ply:GetNWInt("knifehit", 0) + 1)
    elseif dmg:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_SNIPER) then
        ply:SetNWInt("bullethit", ply:GetNWInt("bullethit", 0) + 1)
    end
end)

hook.Add("PostPlayerDeath", "showmenusdfsdf", function(ply)
    timer.Simple(.2,function() ply:ConCommand("checha_damage_logs") end)
end)