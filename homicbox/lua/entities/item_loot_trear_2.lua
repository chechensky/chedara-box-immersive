AddCSLuaFile()

ENT.Base = "item_loot_base"

ENT.PrintName = "Ящик Второго Тира"
ENT.Category = "Looting"

ENT.Spawnable = true

ENT.Model = "models/jmod/resources/jack_crate.mdl"
ENT.ModelMaterial = ""
ENT.ModelScale = 1

ENT.LootTable = {
    ["ent_jack_gmod_ezarmor_paca"] = {"ent"},
    ["ent_jack_gmod_ezarmor_lolkek3f"] = {"ent"},
    ["ent_ammo_9х19mm"] = {"ent"},
    ["item_food_water"] = {"weapon"}
}

ENT.RandomLoot = {
    [1] = {
        ["item_food_shaurma"] = {"weapon"},
        ["weapon_sib_p226"] = {"weapon"},
        ["ent_jack_gmod_ezbasicparts"] = {"ent"},
        ["ent_jack_gmod_ezarmor_shemaghgreen"] = {"ent"},
        ["medkit"] = {"weapon"}
    },
    [2] = {
        ["med_band_big"] = {"weapon"},
        ["medkit"] = {"weapon"},
        ["weapon_sib_usp"] = {"weapon"},
        ["ent_ammo_9х19mm"] = {"ent"},
        ["ent_jack_gmod_ezarmor_ssh68"] = {"ent"}
    },
    [3] = {
        ["ent_jack_gmod_ezarmor_ghostbalacvlava"] = {"ent"},
        ["ent_jack_gmod_ezarmor_flyyembss"] = {"ent"},
        ["ent_ammo_12/70gauge"] = {"ent"},
        ["item_food_apple"] = {"weapon"}
    },
    [4] = {
        ["ent_jack_gmod_ezarmor_paca"] = {"ent"},
        ["ent_jack_gmod_ezarmor_lolkek3f"] = {"ent"},
        ["ent_ammo_9х19mm"] = {"ent"},
        ["item_food_water"] = {"weapon"}
    },
    [5] = {
        ["ent_jack_gmod_ezarmor_securityvest"] = {"ent"},
        ["ent_jack_gmod_ezbattery"] = {"ent"},
        ["ent_ammo_556x45mm"] = {"ent"},
    }
}

ENT.UpdateTime = CurTime()