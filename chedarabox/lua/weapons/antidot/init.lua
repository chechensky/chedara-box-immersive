include("shared.lua")

local healsound = Sound("usable_items/item_injector_02_injection.wav")
function SWEP:Heal(ply)
    if not ply or not ply:IsPlayer() then sound.Play(healsound,ply:GetPos(),75,100,1) return true end

    ply.otravlen2 = false
    timer.Remove("Cyanid"..ply:EntIndex().."12")
    timer.Remove("Cyanid"..ply:EntIndex().."22")
    timer.Remove("Cyanid"..ply:EntIndex().."32")

    timer.Remove("Kurare"..ply:EntIndex().."12")
    timer.Remove("Kurare"..ply:EntIndex().."22")
    timer.Remove("Kurare"..ply:EntIndex().."32")
    ply:EmitSound(healsound)

    return true
end