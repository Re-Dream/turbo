-- vars

local ENT   = FindMetaTable( "Entity" )
local PLY   = FindMetaTable( "Player" )
local WEP   = FindMetaTable( "Weapon" )

local ENT_GetTable = ENT.GetTable
local ENT_GetOwner = ENT.GetOwner

local oldENTIndex  = function( self, key )local val = ENT[ key ]if ( val ~= nil ) then return val end local tab = self:GetTable()if ( tab ) then local val = tab[ key ]if ( val ~= nil ) then return val end end if ( key == "Owner" ) then return ENT.GetOwner( self ) end return nil end
local oldPLYIndex  = function( self, key )local val = PLY[ key ] or ENT[ key ]if ( val ~= nil ) then return val end local tab = self:GetTable()if ( tab ) then local val = tab[ key ]if ( val ~= nil ) then return val end end return nil end
local oldWEPIndex  = function( self, key )local val = WEP[ key ] or ENT[ key ]if ( val ~= nil ) then return val end local tab = self:GetTable()if ( tab ) then local val = tab[ key ]if ( val ~= nil ) then return val end end if ( key == "Owner" ) then return ENT.GetOwner( self ) end return nil end


-- functions

function turbo.PatchMeta()
	-- meta __index optimization
    function ENT:__index( key )
        if key == "Owner" then return ENT_GetOwner( self ) end 
        return ( ENT[ key ] or ( ENT_GetTable( self ) or {} )[ key ] )
    end

    function PLY:__index( key )
        if key == "Owner" then return ENT_GetOwner( self ) end 
        return ( PLY[ key ] or ( ENT[ key ] or ( ENT_GetTable( self ) or {} )[ key ] ) )
    end

    function WEP:__index( key )
        if key == "Owner" then return ENT_GetOwner( self ) end
        return ( WEP[ key ] or ( ENT[ key ] or ( ENT_GetTable( self ) or {} )[ key ] ) )
	end
	
	-- IsValid optimization
	IsValid_ = IsValid_ or IsValid
    function IsValid( obj )
        if not obj then return end
        if not obj.IsValid then return end

        return obj:IsValid()
    end
end


-- hooks

hook.Add( "TurboPostEntity", "Turbo Meta TurboPostEntity", function()
	turbo.PatchMeta()
end )

hook.Add( "TurboUnload", "Turbo Meta TurboUnload", function()
	ENT.__index = oldENTIndex
	PLY.__index = oldPLYIndex
	WEP.__index = oldWEPIndex

	IsValid = IsValid_
end )