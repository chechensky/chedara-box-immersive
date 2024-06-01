-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezweapon"
ENT.PrintName = "EZ Flintlock Blunderbuss"
ENT.Spawnable = false
ENT.Category = "JMod - EZ Weapons"
ENT.WeaponName = "Flintlock Blunderbuss"

---
if SERVER then
elseif CLIENT then
	--
	language.Add(ENT.ClassName, ENT.PrintName)
end
