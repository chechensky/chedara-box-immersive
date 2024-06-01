AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_bullet.lua" )
AddCSLuaFile( "sh_util.lua" )
AddCSLuaFile( "shared.lua" )

include( "sh_bullet.lua" )
include( "sh_util.lua" )
include( "shared.lua" )

util.AddNetworkString("huysound")
