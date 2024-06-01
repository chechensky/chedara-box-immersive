AddCSLuaFile()

ENT.Base = "ent_hb_emp_base"

ENT.PrintName = "PKM"
ENT.Category = "Bipod Guns"

ENT.Spawnable = false
ENT.BaseModel = "models/hunter/blocks/cube025x025x025.mdl" 

ENT.GunModel = "models/pwb2/weapons/w_pkm.mdl"
ENT.NextShoot = 0

ENT.Damage = 160
ENT.Force = 45

ENT.MaxClip = 100
ENT.Clip = 100
ENT.Delay = 0.08

ENT.ReloadSounds = {
    [0.1] = {"pwb/weapons/pkm/boxout.wav"},
    [1] = {"pwb/weapons/pkm/boxin.wav"},
    [1.5] = {"pwb/weapons/pkm/coverdown.wav"},
}

ENT.ShootSound = "pwb/weapons/pkm/shoot.wav"
ENT.ShootSoundFar = "snd_jack_hmcd_snp_far.wav"
