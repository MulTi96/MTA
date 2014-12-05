Editbox = {}
Editbox.__index = Editbox

local fontsize = 1.0
local fonttype = "default-bold"

function Editbox:New( x, y, w, h )
	local data = {};
	data.x = x;
	data.y = y;
	data.w = w;
	data.h = h;
	data.activ = true;
	data.r = 70; 
	data.g = 70;
	data.b = 70;
	data.alpha = 255;
	
	data.text = "";
	data.textactiv = false;
	data.shift = false;
	
	data.clickFunc = function(_, state ) data:onClick( _, state) end;
	data.renderFunc = function() data:onRender() end;
	data.shiftFunc = function( key, state ) data:onShift( key, state ) end;
	data.characterFunc = function( character, press ) data:onCharacter( character, press ) end;
	
	bindKey("lshift", "both", data.shiftFunc);
	addEventHandler("onClientKey", root, data.characterFunc);
	addEventHandler("onClientClick", root, data.clickFunc);
	addEventHandler("onClientRender", root, data.renderFunc);
	setmetatable( data, self );
	return data;
end

function Editbox:onClick( _, state )
	if not( self.activ ) then
		return;
	end
	if ( state == "down" ) then
		if isCursorOnElement( self.x, self.y, self.w, self.h ) then
			self.textactiv = true
		else
			self.textactiv = false
		end
	end
end

-- Diese Buchstaben sind zurzeit aktiviert du kannst selber noch welche hinzufuegen --
enableKeys = {
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9',
	'0',
	'backspace',
}


function Editbox:onShift( key, state )
	if ( state == "down" ) then
		self.shift = true;
	elseif ( state == "up" ) then
		self.shift = false;
	end
end

function isEnableKey( character ) 
	local value = false;
	for index, key in ipairs( enableKeys ) do 
		if ( string.upper(character) == string.upper(key) ) then
			value = true;
		end
	end
	return value;
end


function Editbox:onCharacter( character, press )
	if not ( self.textactiv ) then
		return;
	end
	if ( press ) then
		if isEnableKey( character ) and not isChatBoxInputActive() and not isConsoleActive() and not isMainMenuActive() then
			if ( character == "space" ) and ( dxGetTextWidth( self.text, fontsize, fonttype ) <= (self.w-7) ) then
				self.text = self.text.." "
				return;
			end
		
				if not( character == "backspace" ) and ( dxGetTextWidth( self.text, fontsize, fonttype ) <= (self.w-7) ) then
					if self.shift == true then
						character = string.upper( character );
					end
					self.text = self.text..character
				else
				if ( #self.text > 0 ) and not isChatBoxInputActive() and not isConsoleActive() and not isMainMenuActive() then
					sub = string.sub(self.text, 1, #self.text - 1)
					self.text = sub
				end
			end
		end
	end
end


local value = 0
function Editbox:onRender()
	if not ( self.activ ) then
		return;
	end
	dxDrawRectangle(self.x, self.y, self.w, self.h, tocolor(self.r, self.g, self.b, self.alpha), false)
	local X = self.x+1
	local Y = self.y
	value = value + 10
	if dxGetTextWidth( self.text, 1 ) <= self.w then
		dxDrawRectangle(X+dxGetTextWidth( self.text, fontsize, fonttype ), Y+1, 1, self.h-2, tocolor(255, 255, 255, value), true)
	end
	if (#self.text) > 0 then
		dxDrawText( self.text, X, self.y+(self.h/2)-5, self.w, self.y+(self.h/2)-5, tocolor ( 255, 255, 255, self.alpha ), 1, "default-bold", "left", "top", false, false, true, false, false)
	end
end