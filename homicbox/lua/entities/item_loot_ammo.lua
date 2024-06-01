AddCSLuaFile()

ENT.Base = "item_loot_base"

ENT.PrintName = "Патронный Ящик"
ENT.Category = "Looting"

ENT.Spawnable = true

ENT.Model = "models/jmod/items/boxjrounds.mdl"
ENT.ModelMaterial = ""
ENT.ModelScale = 1.3

ENT.LootTable = {
    ["ent_ammo_9х19mm"] = {"ent"},
    ["ent_ammo_12/70gauge"] = {"ent"},
    ["ent_ammo_556x45mm"] = {"ent"},
    ["ent_ammo_.50ae"] = {"ent"}
}

ENT.RandomLoot = {
    [1] = {
        ["ent_ammo_.45acp"] = {"ent"},
        ["ent_ammo_12/70gauge"] = {"ent"},
        ["ent_ammo_762x39mm"] = {"ent"},
        ["ent_ammo_.50ae"] = {"ent"}
    },
    [2] = {
        ["ent_ammo_.45acp"] = {"ent"},
        ["ent_ammo_12/70gauge"] = {"ent"},
        ["ent_ammo_762x39mm"] = {"ent"},
        ["ent_ammo_.50ae"] = {"ent"}
    },
    [3] = {
        ["ent_ammo_.45acp"] = {"ent"},
        ["ent_ammo_12/70gauge"] = {"ent"},
        ["ent_ammo_762x39mm"] = {"ent"},
        ["ent_ammo_.50ae"] = {"ent"}
    },
    [4] = {
        ["ent_ammo_.45acp"] = {"ent"},
        ["ent_ammo_12/70gauge"] = {"ent"},
        ["ent_ammo_762x39mm"] = {"ent"},
        ["ent_ammo_.50ae"] = {"ent"}
    },
    [5] = {
        ["ent_ammo_556x45mm"] = {"ent"},
        ["ent_ammo_12/70gauge"] = {"ent"},
        ["ent_ammo_9x39mm"] = {"ent"},
        ["ent_ammo_.50ae"] = {"ent"}
    }
}

ENT.UpdateTime = CurTime()