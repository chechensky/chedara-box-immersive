AddCSLuaFile()

ENT.Base = "item_loot_base"

ENT.PrintName = "Мед Ящик"
ENT.Category = "Looting"

ENT.Spawnable = true

ENT.Model = "models/jmod/items/medjit_large.mdl"
ENT.ModelMaterial = ""
ENT.ModelScale = 1.3

ENT.LootTable = {
    ["med_band_big"] = {"weapon"},
    ["medkit"] = {"weapon"}
}

ENT.RandomLoot = {
    [1] = {
        ["painkiller"] = {"weapon"},
        ["medkit"] = {"weapon"},
        ["morphine"] = {"weapon"}
    },
    [2] = {
        ["med_band_small"] = {"weapon"},
        ["megamedkit"] = {"weapon"},
        ["blood_bag"] = {"weapon"}
    },
    [3] = {
        ["blood_bag"] = {"weapon"},
        ["medkit"] = {"weapon"},
        ["morphine"] = {"weapon"},
    }
}

ENT.UpdateTime = CurTime()