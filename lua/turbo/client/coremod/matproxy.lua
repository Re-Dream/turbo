-- functions

function turbo.PatchMatproxy()
	-- aggresive optimization
	local emptyCall = { bind = function() end }

	matproxy_Call = matproxy_Call or matproxy.Call
	matproxy.Call = function( name, mat, ent )
		( matproxy.ActiveList[ name ] or emptyCall ):bind( mat, ent )
	end

	--[[ remove SkyPaint overhead
	matproxy.Add( {
		name = "SkyPaint",
		init = function( a, b, c ) end,
		
		bind = function( self, mat, ent )
			if not IsValid( g_SkyPaint ) then return end

			local vars = g_SkyPaint:GetNetworkVars()

			mat:SetVector( "$TOPCOLOR",		vars.TopColor )
			mat:SetVector( "$BOTTOMCOLOR",	vars.BottomColor )
			mat:SetVector( "$SUNNORMAL",	vars.SunNormal )
			mat:SetVector( "$SUNCOLOR",		vars.SunColor )
			mat:SetVector( "$DUSKCOLOR",	vars.DuskColor )
			mat:SetFloat( "$FADEBIAS",		vars.FadeBias )
			mat:SetFloat( "$HDRSCALE",		vars.HDRScale )
			mat:SetFloat( "$DUSKSCALE",		vars.DuskScale )
			mat:SetFloat( "$DUSKINTENSITY",	vars.DuskIntensity )
			mat:SetFloat( "$SUNSIZE",		vars.SunSize )

			if vars.DrawStars then
				mat:SetInt( "$STARLAYERS",		vars.StarLayers )
				mat:SetFloat( "$STARSCALE",		g_SkyPaint:GetStarScale() )
				mat:SetFloat( "$STARFADE",		g_SkyPaint:GetStarFade() )
				mat:SetFloat( "$STARPOS",		RealTime() * g_SkyPaint:GetStarSpeed() )
				mat:SetTexture( "$STARTEXTURE",	vars.StarTexture )
			else
				mat:SetInt( "$STARLAYERS", 0 )
			end
		end
	} )]]
end


-- hooks

hook.Add( "TurboPostEntity", "Turbo Matproxy TurboPostEntity", function()
	turbo.PatchMatproxy()
end )

hook.Add( "TurboUnload", "Turbo Matproxy TurboUnload", function()
	matproxy.Call = matproxy_Call

	--[[ old sky_paint.lua
	matproxy.Add( {
		name = "SkyPaint",
	
		init = function( self, mat, values )
		end,
	
		bind = function( self, mat, ent )
	
			if not IsValid( g_SkyPaint ) then return end
	
			mat:SetVector( "$TOPCOLOR",		g_SkyPaint:GetTopColor() )
			mat:SetVector( "$BOTTOMCOLOR",	g_SkyPaint:GetBottomColor() )
			mat:SetVector( "$SUNNORMAL",	g_SkyPaint:GetSunNormal() )
			mat:SetVector( "$SUNCOLOR",		g_SkyPaint:GetSunColor() )
			mat:SetVector( "$DUSKCOLOR",	g_SkyPaint:GetDuskColor() )
			mat:SetFloat( "$FADEBIAS",		g_SkyPaint:GetFadeBias() )
			mat:SetFloat( "$HDRSCALE",		g_SkyPaint:GetHDRScale() )
			mat:SetFloat( "$DUSKSCALE",		g_SkyPaint:GetDuskScale() )
			mat:SetFloat( "$DUSKINTENSITY",	g_SkyPaint:GetDuskIntensity() )
			mat:SetFloat( "$SUNSIZE",		g_SkyPaint:GetSunSize() )
	
			if g_SkyPaint:GetDrawStars() then
	
				mat:SetInt( "$STARLAYERS",		g_SkyPaint:GetStarLayers() )
				mat:SetFloat( "$STARSCALE",		g_SkyPaint:GetStarScale() )
				mat:SetFloat( "$STARFADE",		g_SkyPaint:GetStarFade() )
				mat:SetFloat( "$STARPOS",		RealTime() * g_SkyPaint:GetStarSpeed() )
				mat:SetTexture( "$STARTEXTURE",	g_SkyPaint:GetStarTexture() )
	
			else
				mat:SetInt( "$STARLAYERS", 0 )
			end
	
		end
	} )]]
end )