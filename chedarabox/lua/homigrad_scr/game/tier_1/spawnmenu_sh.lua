local validUserGroup = {
	--meagsponsor = true,
	megapenis = true
}

if SERVER then
    COMMANDS.accessspawn = {function(ply,args)
        SetGlobalBool("AccessSpawn",tonumber(args[1]) > 0)

        PrintMessage(3,"Разрешение на взаимодействие Q меню : " .. tostring(GetGlobalBool("AccessSpawn")))
    end}

    local function CanUseSpawnMenu(ply,class)
        return true
    end

    hook.Add("PlayerSpawnVehicle","Cantspawnbullshit",function(ply) end)
    hook.Add("PlayerSpawnRagdoll","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"ragdoll") end)
    hook.Add("PlayerSpawnEffect","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"effect") end)
    hook.Add("PlayerSpawnProp","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"prop") end)
    hook.Add("PlayerSpawnSENT","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"sent") end)
    hook.Add("PlayerSpawnNPC","Cantspawnbullshit",function(ply) return ply:IsSuperAdmin() end)

    hook.Add("PlayerSpawnSWEP","SpawnBlockSWEP",function(ply) return CanUseSpawnMenu(ply,"swep") end)
    hook.Add("PlayerGiveSWEP","SpawnBlockSWEP",function(ply) return CanUseSpawnMenu(ply,"swep") end)

    local function spawn(ply,class,ent)
        return true
    end

    hook.Add("PlayerSpawnedVehicle","sv_round",function(ply,model,ent) end)
    hook.Add("PlayerSpawnedRagdoll","sv_round",function(ply,model,ent) spawn(ply,"ragdoll",ent) end)
    hook.Add("PlayerSpawnedEffect","sv_round",function(ply,model,ent) spawn(ply,"effect",ent) end)
    hook.Add("PlayerSpawnedProp","sv_round",function(ply,model,ent) spawn(ply,"prop",ent) end)
    hook.Add("PlayerSpawnedSENT","sv_round",function(ply,model,ent) spawn(ply,"sent",ent) end)
    hook.Add("PlayerSpawnedNPC","sv_round",function(ply,model,ent) return ply:IsSuperAdmin() end)

    --hook.Add("PlayerSpawnObject","dontspawn!!!",cant)--salat eblan
else
    local admin_menu = CreateClientConVar("hg_admin_menu","1",true,false,"enable admin menu",0,1)
    local function CanUseSpawnMenu(ply,class)
        return true
     end

    hook.Add("ContextMenuOpen", "hide_spawnmenu",CanUseSpawnMenu)
    hook.Add("SpawnMenuOpen", "hide_spawnmenu",CanUseSpawnMenu)
end
