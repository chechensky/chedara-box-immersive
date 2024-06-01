hg = hg or {}

include("homigrad_scr/loader.lua")
-- if SERVER then include("homigrad_scr/run_serverside.lua") end
include("homigrad_scr/run.lua")

if SERVER then
    resource.AddWorkshop("3004847067")
end

resource.AddSingleFile("resource/fonts/homicidefont.ttf")

hook.Add("Initialize", "Optimizon", function()
	hook.Remove( "PlayerTick", "TickWidgets" )

	if SERVER then
		if timer.Exists( "CheckHookTimes" ) then
			timer.Remove( "CheckHookTimes" )
		end
	end

	hook.Remove( "PlayerTick", "TickWidgets" )
	hook.Remove(  "Think", "CheckSchedules" )
	timer.Remove( "HostnameThink" )
	hook.Remove( "LoadGModSave", "LoadGModSave" )

	if CLIENT then
		RunConsoleCommand( "cl_threaded_client_leaf_system", "1" )
		RunConsoleCommand( "cl_smooth", "0" )
		RunConsoleCommand( "mat_queue_mode", "2" )
		RunConsoleCommand( "cl_threaded_bone_setup", "1" )
		RunConsoleCommand( "gmod_mcore_test", "1" )
		RunConsoleCommand( "r_threaded_client_shadow_manager", "1" )
		RunConsoleCommand( "r_queued_post_processing", "1" )
		RunConsoleCommand( "r_threaded_renderables", "1" )
		RunConsoleCommand( "r_threaded_particles", "1" )
		RunConsoleCommand( "r_queued_ropes", "1" )
		RunConsoleCommand( "studio_queue_mode", "1" )
		RunConsoleCommand( "r_decals", "9999" )
		RunConsoleCommand( "mp_decals", "9999" )
		RunConsoleCommand( "r_queued_decals", "1" )
		RunConsoleCommand( "gm_demo_icon", "0" )
		RunConsoleCommand( "r_radiosity", "4" )
		RunConsoleCommand( "cl_cmdrate", "101" )
		RunConsoleCommand( "cl_updaterate", "101" )
		RunConsoleCommand( "cl_interp", "0.07" )
		RunConsoleCommand( "cl_interp_npcs", "0.08" )
		RunConsoleCommand( "cl_timeout", "2400" )
		RunConsoleCommand( "r_flashlightdepthres", "512" )

		if GetConVar( "mat_picmip" ):GetInt() < 0 then
			RunConsoleCommand( "mat_picmip", "0" )
		end
	end
end)

hook.Add("InitPostEntity","RemoveShittyHooks",function()
	local phys_settings = physenv.GetPerformanceSettings()

	phys_settings.LookAheadTimeObjectsVsObject = 0 -- 0.5
	phys_settings.LookAheadTimeObjectsVsWorld = 0.1 -- 1
	phys_settings.MaxAngularVelocity = 3600 -- 7272.7275390625
	phys_settings.MaxCollisionChecksPerTimestep = 100 -- 50000
	phys_settings.MaxCollisionsPerObjectPerTimestep = 1 -- 10
	phys_settings.MaxFrictionMass = 2500 -- 2500
	phys_settings.MaxVelocity = 768 -- 4000
	phys_settings.MinFrictionMass = 100 -- 10

	physenv.SetPerformanceSettings(phys_settings)
end)