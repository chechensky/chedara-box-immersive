AddCSLuaFile()

ENT.Base = "ent_hb_emp_base"

ENT.PrintName = "M249"
ENT.Category = "Bipod Guns"

ENT.Spawnable = false
ENT.BaseModel = "models/hunter/blocks/cube025x025x025.mdl" 

ENT.GunModel = "models/district/w_mach_m249para.mdl"
ENT.NextShoot = 0

ENT.Damage = 35
ENT.Force = 42

ENT.MaxClip = 150
ENT.Clip = 150
ENT.Delay = 0.08

ENT.ReloadSounds = {
    [0.1] = {"weapons/m249/boxout.wav"},
    [1] = {"weapons/m249/boxin.wav"},
    [1.5] = {"weapons/m249/coverdown.wav"},
}

ENT.ShootSound = "weapons/m249/fire.wav"
ENT.ShootSoundFar = "weapons/m249/distant.wav"
