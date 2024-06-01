include("shared.lua")

local healsound = Sound("usable_items/item_injector_02_injection.wav")

function SWEP:Heal(ent)
    if not ent or not ent:IsPlayer() then sound.Play(healsound,ent:GetPos(),75,100,1) return true end
    ent.adrenaline = ent.adrenaline + 2

    if not ent.adrenalineNeed and ent.adrenalineNeed > 4 then ent.adrenalineNeed = ent.adrenalineNeed + 1 end
    ent:EmitSound(healsound)
    return true
end