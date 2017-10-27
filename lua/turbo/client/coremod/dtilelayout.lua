-- vars

local rawget_ 		= rawget
local math_floor 	= math.floor

-- functions
function turbo.PatchDTileLayout()
	-- remove index overhead FitsInTile
	DTileLayout_FitsInTile = DTileLayout_FitsInTile or DTileLayout.FitsInTile
	DTileLayout.FitsInTile = function( self, x, y, w, h )
		local tiles = rawget_( self:GetTable(), "Tiles" )
		local empty = {}

        for a = x, x + ( w - 1 ) do
            for b = y, y + ( h - 1 ) do
                if ( ( tiles[ b ] or empty )[ a ] or 0 ) == 1 then
                    return false
                end
            end
        end

        return true
	end

	-- remove overhead FindFreeTile
	DTileLayout_FindFreeTile = DTileLayout_FindFreeTile or DTileLayout.FindFreeTile
	DTileLayout.FindFreeTile = function( self, x, y, w, h )
		x = x or 1
		y = y or 1

		local span = math_floor( ( self:GetWide() - self:GetBorder() * 2 + self:GetSpaceX() ) / ( self:GetBaseSize() + self:GetSpaceX() ) )
		if span < 1 then span = 1 end

		while true do
			for i = 1, span do
				local fitsInTile = self:FitsInTile( i, y, w, h )

				if ( i + ( w - 1 ) ) > span then
					if i == 1 and fitsInTile then return i, y end
					break
				end
				
				if fitsInTile then return i, y end
			end
		
			y = y + 1
			x = 1
		end
	end
end


-- hooks

hook.Add( "TurboPostEntity", "Turbo DTileLayout TurboPostEntity", function()
	turbo.PatchDTileLayout()
end )

hook.Add( "TurboUnload", "Turbo DTileLayout TurboUnload", function()
	DTileLayout.FitsInTile = DTileLayout_FitsInTile
end )