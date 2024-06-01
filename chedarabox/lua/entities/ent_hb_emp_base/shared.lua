
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "HB EMP Base"

ENT.Spawnable = false

ENT.GunModel = "models/pwb/weapons/w_akm.mdl"
ENT.NextShoot = 0

ENT.Damage = 10
ENT.Force = 5

ENT.MaxClip = 50
ENT.Clip = 50
ENT.Delay = 0.05

ENT.ReloadSounds = {
    [0.1] = {"pwb/weapons/pkm/coverup.wav"},
    [0.5] = {"pwb/weapons/pkm/boxout.wav"},
    [1.5] = {"pwb/weapons/pkm/draw.wav"},
    [2.3] = {"pwb/weapons/pkm/boxin.wav"},
    [3] = {"pwb/weapons/pkm/chain.wav"},
    [3.4] = {"pwb/weapons/pkm/coverdown.wav"},
    [4] = {"pwb/weapons/pkm/coversmack.wav"},
    [5] = {"pwb/weapons/pkm/bolt.wav"}
}

ENT.ShootSound = "pwb/weapons/pkm/shoot.wav"
ENT.ShootSoundFar = "snd_jack_hmcd_snp_far.wav"

DEFINE_BASECLASS( "base_anim" )
