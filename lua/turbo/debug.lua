-- Variables
local clrAccent = Color( 244, 172, 24 )
local clrInfo	= Color( 244, 244, 244 )
local clrError	= Color( 244, 88, 88 )

-- Functions
function turbo.Print( message )
	MsgC( clrAccent, "T " )
	MsgC( clrInfo, message )
	MsgC( "\n" )
end

function turbo.Error( message )
	MsgC( clrAccent, "T " )
	MsgC( clrError, message )
	MsgC( clrInfo, "!" )
	MsgC( "\n" )
end