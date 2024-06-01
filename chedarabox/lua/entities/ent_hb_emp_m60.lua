AddCSLuaFile()

ENT.Base = "ent_hb_emp_base"

ENT.PrintName = "M60"
ENT.Category = "Bipod Guns"

ENT.Spawnable = false
ENT.BaseModel = "models/hunter/blocks/cube025x025x025.mdl" 

ENT.GunModel = "models/pwb2/weapons/w_m60.mdl"
ENT.NextShoot = 0

ENT.Damage = 90
ENT.Force = 40

ENT.MaxClip = 100
ENT.Clip = 100
ENT.Delay = 0.08

ENT.ReloadSounds = {
    [0.1] = {"pwb2/weapons/m60/boxout.wav"},
    [1] = {"pwb2/weapons/m60/boxin.wav"},
    [1.5] = {"pwb2/weapons/m60/coverdown.wav"},
}

ENT.ShootSound = "pwb2/weapons/m60/shoot.wav"
ENT.ShootSoundFar = "snd_jack_hmcd_snp_far.wav"
