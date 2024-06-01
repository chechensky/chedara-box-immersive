local function AntiCrushStart()
	local tickRate = 1 / FrameTime() 
	if tickRate < 20 then
		PrintMessage(HUD_PRINTTALK, "Тикрейт упал до "..math.Round(tickRate).." фризим все пропы!")
		for k, v in ipairs( ents.FindByClass( "prop_*" ) ) do
			v:GetPhysicsObject():EnableMotion(false)
		end
	end
	timer.Simple(5,function()
		AntiCrushStart()
	end)
end

hook.Add( "Initialize", "AntiCrushStart", function()
	print( "AntiCrush is started!" )
	AntiCrushStart()
end )
