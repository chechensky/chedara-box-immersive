AddCSLuaFile()

ENT.Base = "item_loot_base"

ENT.PrintName = "Ящик Третьего Тира"
ENT.Category = "Looting"

ENT.Spawnable = true

ENT.Model = "models/jmod/resources/hard_case_b.mdl"
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
        ["weapon_sib_mp5"] = {"weapon"},
        ["painkiller"] = {"weapon"},
        ["weapon_hg_hatchet"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_piligrim"] = {"ent"}
    },
    [2] = {
        ["weapon_hidebomb"] = {"weapon"},
        ["ent_ammo_.50ae"] ={"ent"},
        ["ent_jack_gmod_ezarmor_halfmask"] = {"ent"},
        ["ent_jack_gmod_ezarmor_thorcrv"] = {"ent"}
    },
    [3] = {
        ["weapon_sib_deagle"] = {"weapon"},
        ["med_band_big"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_6b34"] = {"ent"},
        ["ent_jack_gmod_ezarmor_untar"] = {"ent"},
        ["ent_ammo_556x45mm"] ={"ent"}
    },
    [4] = {
        ["weapon_sib_remington870"] = {"weapon"},
        ["med_band_big"] = {"weapon"},
        ["ent_jack_gmod_ezarmor_arsarmaa18"] = {"ent"},
        ["ent_jack_gmod_ezarmor_ssh68"] = {"ent"},
        ["ent_ammo_12/70gauge"] = {"ent"}
    }
}

ENT.UpdateTime = CurTime()