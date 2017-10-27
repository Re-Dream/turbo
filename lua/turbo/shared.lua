--- module loader, Re-Dream
-- Global
turbo.Version = 201710.0

-- Variables
local pathRoot = "turbo/"
local pathLoad = { "shared/", "server/", "client/" }

-- Helper functions
local function loadFolder( path, realm )
	if realm == 2 and not SERVER then return end

	local files 	 = file.Find( pathRoot .. path .. "*.lua", "LUA" )
	local _, folders = file.Find( pathRoot .. path .. "*", "LUA" )

	for _, v in pairs( files ) do
		local fullPath = pathRoot .. path .. v

		if realm == 1 or realm == 3 then AddCSLuaFile( fullPath ) end
		if realm == 1 or ( realm == 2 and SERVER ) or ( realm == 3 and CLIENT ) then include( fullPath ) end

		impact.Print( fullPath )
	end

	for _, v in pairs( folders ) do if v ~= "disabled" then loadFolder( path .. v .. "/", realm ) end end
end

-- Functions
function turbo.Load()
	hook.Call( "TurboPreLoad" )

	local startTime = SysTime()
	turbo.Print( "Loading modules" )

	for k, v in pairs( pathLoad ) do
		turbo.Print( "Loading realm " .. k .. " '" .. v .. "'" )
		loadFolder( v, k )
	end

	local elapsedUS = math.ceil( ( SysTime() - startTime ) * 1000000 )
	turbo.Print( "Load took " .. elapsedUS .. "us" )

	hook.Call( "TurboPostLoad" )

	hook.Add( "InitPostEntity", "Turbo InitPostEntity", function() TURBO_POST_ENTITY = true hook.Call( "TurboPostEntity" ) end )
	if TURBO_POST_ENTITY then hook.Call( "TurboPostEntity" ) end
end

function turbo.Unload()
	hook.Remove( "InitPostEntity", "Turbo InitPostEntity" )
	hook.Call( "TurboUnload" )
	turbo.Print( "Unloaded" )
end

function turbo.Reload()
	turbo.Unload()
	turbo.Load()
end

-- Initialize
turbo.Load()

