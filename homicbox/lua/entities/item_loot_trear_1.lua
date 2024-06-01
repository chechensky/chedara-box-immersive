AddCSLuaFile()

ENT.Base = "item_loot_base"

ENT.PrintName = "Ящик Первого Тира"
ENT.Category = "Looting"

ENT.Spawnable = true

ENT.Model = "models/props/cs_militia/footlocker01_closed.mdl"
ENT.ModelMaterial = ""
ENT.ModelScale = 1.3

ENT.LootTable = {
    ["weapon_molotok"] = {"weapon"},
    ["weapon_radio"] = {"weapon"},
    ["item_food_pear"] = {"weapon"},
    ["ent_jack_gmod_ezarmor_doorkicker"] = {"ent"},
    ["ent_jack_gmod_ezarmor_catphonewhite"] = {"ent"}
}

ENT.RandomLoot = {
    [1] = {
        ["weapon_molotok"] = {"weapon"},
        ["weapon_radio"] = {"weapon"},
        ["item_food_pear"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_doorkicker"] = {"ent"},
        ["ent_jack_gmod_ezarmor_catphonewhite"] = {"ent"}
    },
    [2] = {
        ["weapon_sib_glock"] = {"weapon"},
        ["med_band_big"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_pipe"] = {"ent"},
        ["ent_ammo_9х19mm"] = {"ent"}
    },
    [3] = {
        ["ent_jack_gmod_ezarmor_aviators"] = {"ent"},
        ["ent_jack_gmod_ezarmor_paca"] = {"ent"},
        ["item_food_monster"] = {"weapon"},
        ["ent_ammo_nail"] = {"ent"}
    },
    [4] = {
        ["ent_jack_gmod_ezbasicparts"] = {"ent"},
        ["weapon_molotok"] = {"weapon"},
        ["ent_ammo_nail"] = {"ent"}
    },
    [5] = {
        ["item_food_cola"] = {"weapon"},
        ["item_food_burger"] = {"weapon"},
        ["ent_ammo_nail"] = {"ent"}
    }
}

ENT.UpdateTime = CurTime()