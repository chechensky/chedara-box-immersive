include("shared.lua")
local healsound = Sound("bandageuse.wav")

function SWEP:Heal(ent)
    if not ent or not ent:IsPlayer() then sound.Play(healsound,ent:GetPos(),75,100,1) return true end
    ent.RightLegbroke = false
    ent.LeftLegbroke = false

    ent.LeftArmbroke = false
    ent.RightArmbroke = false

    ent.RightArm = 1
    ent.LeftArm = 1

    ent.RightLeg = 0.8
    ent.LeftLeg = 0.8

	ent:SetNWBool("LeftLeg", ent.LeftLegbroke)
	ent:SetNWBool("RightLeg", ent.RightLegbroke)
	ent:SetNWBool("RightArm", ent.RightArmbroke)
	ent:SetNWBool("LeftArm", ent.LeftArmbroke)
    ent:EmitSound(healsound)
    return true
end