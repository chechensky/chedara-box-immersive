table.insert(LevelList,"schoolshoot")
schoolshoot = {}
schoolshoot.Name = "Christchurch Shooting"

schoolshoot.red = {"Brenton Tarrant",Color(255,55,55),
    weapons = {"weapon_hands"},
    main_weapon = {"weapon_bt_ar15"},
    secondary_weapon = {"weapon_p220","weapon_deagle","weapon_glock"},
    models = {"models/player/brenton/ron_fbi/models/brenton.mdl"}
}

schoolshoot.green = {"Islamists",Color(55,255,55),
    weapons = {"weapon_hands"},
    models = tdm.models
}

schoolshoot.blue = {"SWATers",Color(55,55,255),
    weapons = {"tourniquet","weapon_police_bat","med_band_big","medkit","painkiller","adrenaline","weapon_handcuffs","weapon_taser","weapon_hg_flashbang"},
    main_weapon = {"weapon_sib_m4a1","weapon_sib_asval"},
    secondary_weapon = {"weapon_sib_glock"},
    models = {"models/player/swat.mdl","models/player/riot.mdl","models/player/urban.mdl","models/player/gasmask.mdl"}
}

schoolshoot.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function schoolshoot.StartRound(data)
	team.SetColor(1,schoolshoot.red[2])
	team.SetColor(2,schoolshoot.green[2])
	team.SetColor(3,schoolshoot.blue[2])

	game.CleanUpMap()
    timer.Simple(.1, function()
        for _, ent in ipairs(ents.GetAll()) do
            if ent:IsNPC() then
                ent:Remove()
            end
        end
    end)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return schoolshoot.StartRoundSV()
end

schoolshoot.SupportCenter = true
