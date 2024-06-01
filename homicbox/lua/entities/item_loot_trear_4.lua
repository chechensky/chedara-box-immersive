AddCSLuaFile()

ENT.Base = "item_loot_base"

ENT.PrintName = "Ящик Четвертого Тира"
ENT.Category = "Looting"

ENT.Spawnable = true

ENT.Model = "models/kali/props/cases/hard case c.mdl"
ENT.ModelMaterial = "models/jmod_block/metal"
ENT.ModelScale = 1

ENT.LootTable = {
    ["weapon_sib_remington870"] = {"weapon"},
    ["med_band_big"] = {"weapon"},
    ["ent_jack_gmod_ezarmor_arsarmaa18"] = {"ent"},
    ["ent_jack_gmod_ezarmor_ssh68"] = {"ent"},
    ["ent_ammo_12/70gauge"] = {"ent"}
}

ENT.RandomLoot = {
    [1] = {
        ["weapon_sib_akm"] = {"weapon"},
        ["morphine"] = {"weapon"},
        ["weapon_radio"] = {"ent"},
        ["ent_jack_gmod_ezarmor_paratus"] = {"ent"},
        ["ent_ammo_9х19mm"] = {"ent"}
    },
    [2] = {
        ["med_band_big"] = {"weapon"},
        ["medkit"] = {"weapon"},
        ["weapon_sib_m4a1"] = {"weapon"},
        ["morphine"] = {"weapon"},
        ["weapon_radio"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_slickblack"] = {"ent"},
        ["ent_jack_gmod_ezarmor_altyn"] = {"ent"},
        ["ent_ammo_762x39mm"] = {"ent"}
    },
    [3] = {
        ["ent_hb_emp_pkm"] = {"ent"},
        ["ent_jack_gmod_ezammo"] = {"ent"},
        ["ent_jack_gmod_ezmedsupplies"] = {"ent"}
    },
    [4] = {
        ["med_band_big"] = {"weapon"},
        ["medkit"] = {"weapon"},
        ["weapon_sib_hk416"] = {"weapon"},
        ["morphine"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_ulachcoyote"] = {"ent"},
        ["ent_jack_gmod_ezammo"] = {"ent"},
    },
}

ENT.UpdateTime = CurTime()