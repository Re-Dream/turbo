-- vars

local noVC = {
	viewmodel			= true, 
	gmod_hands 			= true, 
	prop_door_rotating 	= true
}

--[[
local dmaxs = Vector( 1, 1, 1 )
local dmins = dmaxs * -1
local dred 	= Color( 255, 0, 0 )
local dblue	= Color( 0, 0, 255 )
]]

local rotAng 	= Angle( 0, 90, 0 )
local hideWait 	= 1
local showWait 	= 0.1
local ply 		= nil
local losClear 	= nil


-- functions

function turbo.RenderOverride( ent )
	if not ply then
		ply = LocalPlayer()
		losClear = ply.IsLineOfSightClear
	end

	local time = CurTime()
	if ( ent.VCShow or time ) > time then return end -- not yet next un-hide check

	local draw = ent.Draw or ent.DrawModel
	if ( ent.VCHide or time ) > time then draw( ent ) return end -- not yet next hide check

	local center 	 = ent:WorldSpaceCenter()
	local mins, maxs = ent:GetModelRenderBounds()

	for i = 1, 4 do
		--debugoverlay.Box( center + mins, dmins, dmaxs, 0.2, dred )
		if losClear( ply, center + mins ) then 
			draw( ent )
			ent.VCHide = time + hideWait
			if ent.VCShadow then ent.VCShadow = nil ent:CreateShadow() end

			return 
		end
		--debugoverlay.Box( center + maxs, dmins, dmaxs, 0.2, dblue )
		if losClear( ply, center + maxs ) then 
			draw( ent )
			ent.VCHide = time + hideWait
			if ent.VCShadow then ent.VCShadow = nil ent:CreateShadow() end

			return 
		end

		mins:Rotate( rotAng )
		maxs:Rotate( rotAng )
	end

	ent.VCShow = time + showWait

	if not ent.VCShadow then
		ent.VCShadow = true
		ent:DestroyShadow()
	end
end

function turbo.SetVCEnabled( enabled )
	if enabled then
		-- add after creation
		hook.Add( "OnEntityCreated", "Turbo VC OnEntityCreated", function( ent )
			timer.Simple( 1, function()
				if IsValid( ent ) and not noVC[ ent:GetClass() ] then 
					ent.RenderOverride = turbo.RenderOverride
				end
			end )
		end )

		-- add already existing
		for _, v in pairs( ents.GetAll() ) do 
			if not noVC[ v:GetClass() ] then 
				v.RenderOverride = turbo.RenderOverride
			end 
		end
	else
		hook.Remove( "OnEntityCreated", "Turbo VC OnEntityCreated" )
		for _, v in pairs( ents.GetAll() ) do if v.RenderOverride == turbo.RenderOverride then v.RenderOverride = nil end end
	end
end

turbo.SetVCEnabled( true )