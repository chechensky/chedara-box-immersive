SIB_Alchogol = SIB_Alchogol or 0

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects","SIB_Alchogol",function()
	if not LocalPlayer():Alive() then return end
    if SIB_Alchogol <= 0.05 then return end
	local fraction = math.Clamp(SIB_Alchogol/5,0,3)
	DrawToyTown(fraction * 20,ScrH() * fraction * 5.5)

    tab["$pp_colour_addr"] = fraction*0.2
    tab["$pp_colour_addg"] = fraction*0.1
	DrawColorModify(tab)

end)

hook.Add("Think","SIB_Alchogol_Think",function()
    SIB_Alchogol = Lerp(0.02*FrameTime(),SIB_Alchogol,0)
    if not LocalPlayer():Alive() then SIB_Alchogol = 0 return end
    if SIB_Alchogol <= 0.05 then return end

    local fraction = math.Clamp(SIB_Alchogol/20,0,50)
	local x = (math.sin(CurTime())*fraction)/1.5
    local y = (math.cos(CurTime())*fraction*2)/1.5

    LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles()+Angle(x,y,0))
    
end)

hook.Add("GetMotionBlurValues", "SIB_Alchogol", function( x, y, w, z)
	if SIB_Alchogol <= 0.05 then return end
    local fraction = math.Clamp(SIB_Alchogol/50,0,50)
	x = (math.sin(CurTime())*fraction)
    y = (-math.cos(CurTime())*fraction)

	return x, y, w, z
end)



