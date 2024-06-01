AddCSLuaFile()

ENT.Base = "item_loot_base"

ENT.PrintName = "Строительный Ящик"
ENT.Category = "Looting"

ENT.Spawnable = true

ENT.Model = "models/props_junk/wood_crate001a.mdl"
ENT.ModelMaterial = ""
ENT.ModelScale = 1.3

ENT.LootTable = {
    ["weapon_molotok"] = {"weapon"},
    ["weapon_radio"] = {"weapon"},
    ["item_food_pear"] = {"weapon"},
}

ENT.RandomLoot = {
    [1] = {
        ["weapon_molotok"] = {"weapon"},
        ["ent_ammo_nail"] = {"ent"},
        ["ent_jack_gmod_ezarmor_shemaghtan"] = {"ent"},
        ["ent_jack_gmod_ezarmor_catphonewhite"] = {"ent"}
    },
    [2] = {
        ["med_band_big"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_police"] = {"ent"},
        ["ent_ammo_nail"] = {"ent"}
    },
    [3] = {
        ["med_band_big"] = {"weapon"},
        ["ent_ammo_nail"] = {"ent"},
        ["ent_jack_gmod_ezwood"] = {"ent"}
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