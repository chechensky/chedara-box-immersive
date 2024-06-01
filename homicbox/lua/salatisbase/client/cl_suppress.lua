SIB_suppress = SIB_suppress or {}
SIB_suppress.Force = 0
SIB_suppress.Ang = Angle(0,0,0)
SIB_suppress.Shoot = 0

function Suppress(force)
    SIB_suppress.Force = math.Clamp(SIB_suppress.Force + force/15,0,50)
    SIB_suppress.Ang = Angle(math.Rand(-1.5,1.5)*force,math.Rand(-1.5,1.5)*force,math.Rand(-1.5,1.5)*force)
end


hook.Add("RenderScreenspaceEffects","SIB_Suppresss",function()
	if not LocalPlayer():Alive() then return end

	local fraction = math.Clamp(SIB_suppress.Force,0,1)
	DrawToyTown(fraction * 4,ScrH() * fraction * 1.5)

	DrawSharpen(8,SIB_suppress.Force / 7)
end)

hook.Add("Think","SIB_Suppresss_Think",function()
    SIB_suppress.Force = Lerp(0.5*FrameTime(),SIB_suppress.Force,0)
    SIB_suppress.Ang = LerpAngle(5*FrameTime(),SIB_suppress.Ang,Angle(0,0,0))
    
    SIB_suppress.Shoot = Lerp(5*FrameTime(),SIB_suppress.Shoot,0)
end)

hook.Add("GetMotionBlurValues", "SIB_ShootEffects", function( x, y, w, z)
    local fraction = math.Clamp(SIB_suppress.Shoot,0,1)
	w = fraction*5

	return x, y, w, z
end)


hook.Add("InitPostEntity", "SIB_ShootEffects_load", function()
	if not GetConVar("mat_motion_blur_enabled"):GetBool() then
		LocalPlayer():ConCommand("mat_motion_blur_enabled 1")
		LocalPlayer():ConCommand("mat_motion_blur_strength 0")
	end
end)