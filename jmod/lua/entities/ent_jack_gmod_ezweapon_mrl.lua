﻿-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezweapon"
ENT.PrintName = "EZ Multiple Rocket Launcher"
ENT.Spawnable = false
ENT.Category = "JMod - EZ Weapons"
ENT.WeaponName = "Multiple Rocket Launcher"

---
if SERVER then
elseif CLIENT then
	--
	language.Add(ENT.ClassName, ENT.PrintName)
end
