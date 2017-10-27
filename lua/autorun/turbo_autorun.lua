AddCSLuaFile()
AddCSLuaFile( "turbo/debug.lua" )
AddCSLuaFile( "turbo/shared.lua" )

if turbo and turbo.Unload then
	turbo.Unload()
end

turbo = {}

include( "turbo/debug.lua" )
include( "turbo/shared.lua" )
