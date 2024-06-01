include("shared.lua")

local healsound1 = Sound("bandageuse.wav")
local healsound2 = Sound("medkituse0.wav")

function SWEP:Heal(ent)
	if not ent or not ent:IsPlayer() then 
		if table.HasValue(BleedingEntities,ent) then
			sound.Play(healsound1,ent:GetPos(),75,100,0.5)
			return true
		else
			return
		end
	end

	if ent.Bloodlosing > 0 then
		ent.Bloodlosing = math.max(ent.Bloodlosing - 25,0)

		if ent.Bloodlosing == 0 then
			ent:EmitSound(healsound1)
		else
			ent:EmitSound(healsound2)
		end

		return true
	end
end