include("shared.lua")
local healsound = Sound("bandageuse.wav")

function SWEP:Heal(ent)
    if not ent or not ent:IsPlayer() then sound.Play(healsound,ent:GetPos(),75,100,1) return true end
    if ent.RightHandArtery == true and ent.RH_Gut == false then
        ent.RH_Gut = true
        ent.RightHandArtery = false
        JMod.EZ_Equip_Armor(ent, "RHandTourniquet")
        ent.pain = ent.pain + 10
        ent:EmitSound(healsound)
        if !ent.RightLegArtery and !ent.LeftLegArtery and !ent.LeftHandArtery and !ent.RightHandArtery then ply:SetNWBool("ArteryHit", false) return true end
    return true end
    if ent.LeftHandArtery == true and ent.LH_Gut == false then
        ent.LH_Gut = true
        ent.LeftHandArtery = false
        JMod.EZ_Equip_Armor(ent, "LHandTourniquet")
        ent.pain = ent.pain + 10
        ent:EmitSound(healsound)
        if !ent.RightLegArtery and !ent.LeftLegArtery and !ent.LeftHandArtery and !ent.RightHandArtery then ply:SetNWBool("ArteryHit", false) return true end
    return true end
    if ent.LeftLegArtery == true and ent.LL_Gut == false then
        JMod.EZ_Equip_Armor(ent, "LLegTourniquet")
        ent.LL_Gut = true
        ent.LeftLegArtery = false
        ent.pain = ent.pain + 10
        ent:EmitSound(healsound)
        if !ent.RightLegArtery and !ent.LeftLegArtery and !ent.LeftHandArtery and !ent.RightHandArtery then ply:SetNWBool("ArteryHit", false) return true end
    return true end
    if ent.RightLegArtery == true and ent.RL_Gut == false then
        JMod.EZ_Equip_Armor(ent, "RLegTourniquet")
        ent.RL_Gut = true
        ent.RightLegArtery = false
        ent.pain = ent.pain + 10
        ent:EmitSound(healsound)
        if !ent.RightLegArtery and !ent.LeftLegArtery and !ent.LeftHandArtery and !ent.RightHandArtery then ent:SetNWBool("ArteryHit", false) return true end
    return true end
end