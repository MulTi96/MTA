-- Auflösung: 1280x720

local x, y	 = guiGetScreenSize();
local sx, sy = x/1280, y/720;

function _dxDrawRectangle(x, y, w, h, color, postgui)

	local x = x*sx;
	local y = y*sy;
	local w = w*sx;
	local h = h*sy;
	
	dxDrawRectangle(x, y, w, h, color, postgui);
end
function _dxDrawLine(x, y, w, h, color, width, postgui)

	local x = x*sx;
	local y = y*sy;
	local w = w*sx;
	local h = h*sy;
	
	dxDrawLine(x, y, w, h, color, width, postgui);
end
function _dxDrawImage(x, y, w, h, path, arg1, arg2, arg3, color, postgui)
	
	
	local x = x*sx;
	local y = y*sy;
	local w = w*sx;
	local h = h*sy;
	
	dxDrawImage(x, y, w, h, path, arg1, arg2, arg3, color, postgui);
end
function _dxDrawText(text, x, y, w, h, color, fsize, ffont, cx, cy, arg1, arg2, arg3, arg4, arg5)
	
	local x = x*sx;
	local y = y*sy;
	local w = w*sx;
	local h = h*sy;
	
	dxDrawText(text, x, y, w, h, color, fsize, ffont, cx, cy, arg1, arg2, arg3, arg4, arg5);
end


function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if 
		type( sEventName ) == 'string' and 
		isElement( pElementAttachedTo ) and 
		type( func ) == 'function' 
	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end
 
	return false
end

local clickedElement = false
local clickedX = 0
local clickedY = 0
local clickedW = 0
local clickedH = 0

local x, y = guiGetScreenSize();
function isCursorOnElement(x,y,w,h)
	if isCursorShowing() then
		local mx,my = getCursorPosition ()
		local fullx,fully = guiGetScreenSize()
		cursorx,cursory = mx*fullx,my*fully
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		else
			return false
		end
	end
end

local aktienData = {}	
local Scrollposition 	= 0;
local MaxScrollposition = 5;


function ScrollDown()
	if(#aktienData - Scrollposition) <= 1 then
		Scrollposition = #aktienData;
	else
		Scrollposition = Scrollposition + 1;
	end
end
function ScrollUp()
	if(Scrollposition >= #aktienData)then
		Scrollposition = #aktienData;
	else
		Scrollposition = Scrollposition - 1;
	end
end

AktienEdit = Editbox:New( 749*sx, 456*sy, 30*sx, 30*sy )
dxSetVisible(AktienEdit, false);

function refreshAktienData(AktienVars)
	local addedpoint = 0; 
	for pos, key in pairs(AktienVars) do 
	
		addedpoint = addedpoint + 1;	
		aktienData[addedpoint] = {}	
		aktienData[addedpoint]["Name"] 			      = key.Name;
		aktienData[addedpoint]["PercentChange"] 	  = key.ChangeAktienProzent;
		aktienData[addedpoint]["LastTradePriceOnly"]  = key.LastTradePriceOnly;
		aktienData[addedpoint]["Symbol"] 			  = key.Symbol;
		aktienData[addedpoint]["DayChange"]           = key.Change_PercentChange;
		aktienData[addedpoint]["SymbolImagePath"]     = "images/"..aktienData[addedpoint]["Symbol"]:lower()..".png"
		
		aktienData[addedpoint]["LastRefresh"]		  = 0;
		
	end
end
addEvent("refreshClientAktienTable", true);
addEventHandler("refreshClientAktienTable", localPlayer, refreshAktienData);


addEvent("loadClientGUIAktien", true)
addEventHandler("loadClientGUIAktien", localPlayer, function(AktienVars)

	local addedpoint = 0; 
	
	for pos, key in pairs(AktienVars) do 
	
		addedpoint = addedpoint + 1;	
		aktienData[addedpoint] = {}	
		aktienData[addedpoint]["Name"] 			      = key.Name;
		aktienData[addedpoint]["PercentChange"] 	  = key.ChangeAktienProzent;
		aktienData[addedpoint]["LastTradePriceOnly"]  = key.LastTradePriceOnly;
		aktienData[addedpoint]["Symbol"] 			  = key.Symbol;
		aktienData[addedpoint]["DayChange"]           = key.Change_PercentChange;
		aktienData[addedpoint]["SymbolImagePath"]     = "images/"..aktienData[addedpoint]["Symbol"]:lower()..".png"
		aktienData[addedpoint]["LastRefresh"]		  = 0;
		
		aktienData[addedpoint]["LastRefreshTimer"]    = setTimer(refreshLastTime, 1000, 0, addedpoint);
		
	end
	
	

	
	if not isEventHandlerAdded("onClientRender", root, renderAktienClientGUI) then
		showCursor(true);
		
		dxSetVisible(AktienEdit, true);
		bindKey("mouse_wheel_up", "down", ScrollUp);
		bindKey("mouse_wheel_up", "down", ScrollDown);
		addEventHandler("onClientRender", root, renderAktienClientGUI);
		
		addEventHandler("onClientClick", root, renderAktienClickGUI);
	else
		showCursor(false);
		dxSetVisible(AktienEdit, false);
		
		for i = 1, #aktienData do 
			if(isTimer(aktienData[i]["LastRefreshTimer"]))then
				killTimer(aktienData[i]["LastRefreshTimer"]);
			end
		end
		unbindKey("mouse_wheel_up", "down", ScrollUp);
		unbindKey("mouse_wheel_up", "down", ScrollDown);
		removeEventHandler("onClientRender", root, renderAktienClientGUI);
		
		removeEventHandler("onClientClick", root, renderAktienClickGUI);
	end
end)

function refreshLastTime(id)
	aktienData[id]["LastRefresh"] = aktienData[id]["LastRefresh"] + 1;
end


function renderAktienClickGUI(_, stn, ax, ay, wx, wy, wz, arg1)
	if(stn == "down")then
		if isCursorOnElement( clickedX, clickedY, clickedW, clickedH ) then
			if clickedElement == clickedIndex then
				outputDebugString("Clicked Frezzed");
				clickedElement      = false;
			else 	
				outputDebugString("Clicked Enfrezzed");
				clickedElement        = clickedIndex;
				clickedElementTitle   = clickedTitel;
				clickedElementPrice   = clickedPrice;
				clickedElementPercent = clickedProzent;
				clickedElementX, clickedElementY, clickedElementW, clickedElementH = clickedX, clickedY, clickedW, clickedH
			end
		end
		if isCursorOnElement(884*sx, 162*sy, 922*sx, 194*sy) then
			showCursor(false);
			dxSetVisible(AktienEdit, false);
			for i = 1, #aktienData do 
				if(isTimer(aktienData[i]["LastRefreshTimer"]))then
					killTimer(aktienData[i]["LastRefreshTimer"]);
				end
			end
			unbindKey("mouse_wheel_up", "down", ScrollUp);
			unbindKey("mouse_wheel_up", "down", ScrollDown);
			removeEventHandler("onClientRender", root, renderAktienClientGUI);
			removeEventHandler("onClientClick", root, renderAktienClickGUI);
		end
		if isCursorOnElement(617*sx, 452*sy, 123*sx, 36*sy) then
			local price = dxGetText(AktienEdit);
			
			if(#price > 0)then
				local price = tonumber(dxGetText(AktienEdit));
				
				if(clickedElement)then
					triggerServerEvent("buyAktie", localPlayer, localPlayer, clickedElementTitle, clickedElementPrice, clickedElementPercent, price);
				else
					outputChatBox("Wähle zuerst ein Unternehmen aus!", 255, 0, 0);
				end
			else
				outputChatBox("Gebe einen Wert an in die Editbox ein!", 255, 0, 0);
			end
		end
		if isCursorOnElement(789*sx, 451*sy, 123*sx, 36*sy) then
		
			local price = dxGetText(AktienEdit);
			if(#price > 0)then
				local price = tonumber(dxGetText(AktienEdit));
				
				if(clickedElement)then
					triggerServerEvent("payAktie", localPlayer, localPlayer, clickedElementTitle, clickedElementPrice, clickedElementPercent, price);
				else
					outputChatBox("Wähle zuerst ein Unternehmen aus!", 255, 0, 0);
				end
			else
				outputChatBox("Gebe einen Wert an in die Editbox ein!", 255, 0, 0);
			end
		end
	end
end



function renderAktienClientGUI()

	aktienSelfData = {}
	for i = 1, #aktienData do 
		aktienSelfData[i] = {}
		aktienSelfData[i].Name 			= aktienData[i]["Name"];
		aktienSelfData[i].PercentChange = aktienData[i]["PercentChange"];
		aktienSelfData[i].Price			= aktienData[i]["LastTradePriceOnly"];
		aktienSelfData[i].Symbol 		= aktienData[i]["Symbol"];
		aktienSelfData[i].ImagePath		= aktienData[i]["SymbolImagePath"];
		aktienSelfData[i].DayChange     = aktienData[i]["DayChange"];
		aktienSelfData[i].LastRefresh   = aktienData[i]["LastRefresh"];
	end
	
	_dxDrawRectangle(360, 196, 563, 306, tocolor(18, 18, 18, 255), false)
	_dxDrawRectangle(366, 203, 193, 291, tocolor(39, 39, 39, 255), false)
	_dxDrawRectangle(368, 206, 188, 46, tocolor(34, 103, 0, 255), false)
	
	_dxDrawRectangle(360, 162, 563, 35, tocolor(9, 9, 9, 255), false)
	_dxDrawText("Aktienmarkt", 360, 162, 922, 194, tocolor(251, 250, 250, 255), 1.50, "default", "center", "center", false, false, true, false, false)
	_dxDrawText("X", 884, 162, 922, 194, tocolor(216, 0, 0, 255), 2.00, "default", "center", "center", false, false, true, false, false)
	_dxDrawLine(603, 304, 920, 304, tocolor(255, 255, 255, 255), 2, false)
	_dxDrawLine(605, 415, 922, 415, tocolor(255, 255, 255, 255), 2, false)
	_dxDrawLine(604, 203, 604, 500, tocolor(255, 255, 255, 255), 2, false)
	

	if(isCursorOnElement(617*sx, 452*sy, 123*sx, 36*sy))then
		_dxDrawRectangle(617, 452, 123, 36, tocolor(0, 0, 0, 255), false)
		_dxDrawText("Kaufen", 617, 451, 739, 488, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)
		
		if(#dxGetText(AktienEdit) > 0)then
		local opr				 = 0;
		local aktienprozentwert	 = 0;
		local aktienprice		 = clickedElementPrice;
			if clickedElement then
				local aktien     = tonumber(dxGetText(AktienEdit));
				opr 		     = clickedElementPercent:sub(2, #clickedElementPercent - 1);
				aktienprozenwert = ((clickedElementPrice*opr)/100);
				aktienprice      = (clickedElementPrice*tonumber(dxGetText(AktienEdit))) + aktienprozenwert;
				_dxDrawText("Preis: "..aktienprice.."$", 618, 424, 768, 444, tocolor(255, 255, 255, 255), 1.20, "default", "left", "top", false, false, true, false, false)
			end
		end
	else
		_dxDrawRectangle(617, 452, 123, 36, tocolor(255, 255, 255, 255), false)
		_dxDrawText("Kaufen", 617, 451, 739, 488, tocolor(0, 0, 0, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false);
	end
	if(isCursorOnElement(789*sx, 451*sy, 123*sx, 36*sy))then
		_dxDrawRectangle(789, 451, 123, 36, tocolor(0, 0, 0, 255), false)
		_dxDrawText("Verkaufen", 788, 450, 910, 487, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)
		
		if(#dxGetText(AktienEdit) > 0)then
			if clickedElement then
			local opr				 = 0;
			local aktienprozentwert	 = 0;
			local aktienprice		 = clickedElementPrice;
				if(clickedElementPercent:find('-'))then
					opr		         = clickedElementPercent:sub(2,  #clickedElementPercent - 1);
					aktienprozenwert = ((clickedElementPrice*opr)/100);
					aktienprice      = (clickedElementPrice*tonumber(dxGetText(AktienEdit))) - aktienprozenwert;
				elseif(clickedElementPercent:find('+'))then
					opr 		     = clickedElementPercent:sub(2, #clickedElementPercent - 1);
					aktienprozenwert = ((clickedElementPrice*opr)/100);
					aktienprice      = (clickedElementPrice*tonumber(dxGetText(AktienEdit))) + aktienprozenwert;
				end 
				_dxDrawText("Verkaufswert: "..aktienprice.."$", 618, 424, 768, 444, tocolor(255, 255, 255, 255), 1.20, "default", "left", "top", false, false, true, false, false)
			end
		end
	else
		_dxDrawRectangle(789, 451, 123, 36, tocolor(255, 255, 255, 255), false)
		_dxDrawText("Verkaufen", 788, 450, 910, 487, tocolor(0, 0, 0, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false);
	end
	
	if not isCursorOnElement(789*sx, 451*sy, 123*sx, 36*sy) and not isCursorOnElement(617*sx, 452*sy, 123*sx, 36*sy) then
		_dxDrawText("[Kaufen][Wert][Verkaufen] - Auswählen..", 618, 424, 768, 444, tocolor(255, 255, 255, 255), 1.20, "default", "left", "top", false, false, true, false, false)
	end
	_dxDrawRectangle(749, 456, 30, 30, tocolor(70, 70, 70, 255), false) -- Editbox Background
	
	_dxDrawText("Waehle dein Unternehmen und\ngebe dann unten ein wie viele\nAktien du von dem Unternehmen\nkaufen oder verkaufen willst.\nAktiensystem(C) MulTi.\n[Unternehmen][Zahl] Letzte Aktualiserung\nin Sekunden.", 617, 314, 897, 408, tocolor(255, 255, 255, 255), 1.00, "clear", "left", "top", false, false, true, false, false)

	if(#dxGetText(AktienEdit) > 0)then
		if(tonumber(dxGetText(AktienEdit)) > 999)then
			dxSetText(AktienEdit, 1000);
		end
	end
	local y_position = 0;
	for i = 0 + Scrollposition, MaxScrollposition + Scrollposition do  
		if(aktienSelfData[i])then
			--[[
		

				_dxDrawText("Your Aktien: 50", 618, 424, 768, 444, tocolor(255, 255, 255, 255), 1.20, "default", "left", "top", false, false, true, false, false)
				_dxDrawRectangle(617, 452, 123, 36, tocolor(255, 255, 255, 255), false)
			--]]
			
		
			_dxDrawText(aktienSelfData[i].Name.." ["..aktienSelfData[i].LastRefresh..']', 375, 208+(y_position*47), 481, 231, tocolor(255, 255, 255, 255), 1.50, "default-bold", "left", "top", false, false, true, false, false) -- 47 Abstand zum nächsten.
			_dxDrawText("Wert: "..aktienSelfData[i].Price.."$ %: "..aktienSelfData[i].PercentChange, 377, 232+(y_position*47), 538, 247, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
			if(aktienSelfData[i].PercentChange:find('-'))then
				if isCursorOnElement(368*sx, (206+(y_position*49))*sy, 188*sx, 46*sy) then
					_dxDrawRectangle(368, 206+(y_position*49), 188, 46, tocolor(155, 0, 0, 255), false)
				else
					_dxDrawRectangle(368, 206+(y_position*49), 188, 46, tocolor(103, 0, 0, 255), false)
				end
			else
				if isCursorOnElement(368*sx, (206+(y_position*49))*sy, 188*sx, 46*sy)then
					_dxDrawRectangle(368, 206+(y_position*49), 188, 46, tocolor(34, 155, 0, 255), false)
				else
					_dxDrawRectangle(368, 206+(y_position*49), 188, 46, tocolor(34, 103, 0, 255), false)
				end
			end
			if(clickedElement == aktienSelfData[i].Symbol)then
				_dxDrawRectangle(368, 206+(y_position*49), 188, 46, tocolor(255, 255, 255, 105), false)
			end
			if not clickedElement then
				if(isCursorOnElement(368*sx, (206+(y_position*49))*sy, 188*sx, 46*sy))then
				
					_dxDrawText(aktienSelfData[i].Name, 713, 204, 864, 234, tocolor(255, 255, 255, 255), 2.00, "default-bold", "left", "top", false, false, true, false, false)
					_dxDrawImage(620, 204, 50, 50, aktienSelfData[i].ImagePath, 0, 0, 0, tocolor(255, 255, 255, 255), true)
					_dxDrawText("Aktienwert: "..aktienSelfData[i].Price.." %:"..aktienSelfData[i].PercentChange, 713, 238, 916, 256, tocolor(255, 255, 255, 255), 1.00, "arial", "left", "top", false, false, true, false, false)
					_dxDrawText("Prozentveränderung: "..aktienSelfData[i].DayChange, 713, 258, 916, 276, tocolor(255, 255, 255, 255), 1.00, "arial", "left", "top", false, false, true, false, false)
					
					local playeraktien = getElementData(localPlayer, aktienSelfData[i].Name);
					if not playeraktien then
						playeraktien = 0;
					end
					_dxDrawText("Deine Aktien: "..playeraktien, 713, 279, 916, 297, tocolor(255, 255, 255, 255), 1.00, "arial", "left", "top", false, false, true, false, false)
			
					clickedX = 368*sx;
					clickedY = (206+(y_position*49))*sy;
					clickedW = 188*sx;
					clickedH = 46*sy;
					
					clickedTitel   = aktienSelfData[i].Name;
					clickedIndex   = aktienSelfData[i].Symbol;
					clickedPrice   = aktienSelfData[i].Price;
					clickedProzent = aktienSelfData[i].PercentChange;
					
				end
			else
				
				if(clickedElement == aktienSelfData[i].Symbol)then
					_dxDrawText(aktienSelfData[i].Name, 713, 204, 864, 234, tocolor(255, 255, 255, 255), 2.00, "default-bold", "left", "top", false, false, true, false, false)
					_dxDrawImage(620, 204, 50, 50, aktienSelfData[i].ImagePath, 0, 0, 0, tocolor(255, 255, 255, 255), true)
					_dxDrawText("Aktienwert: "..aktienSelfData[i].Price.." %:"..aktienSelfData[i].PercentChange, 713, 238, 916, 256, tocolor(255, 255, 255, 255), 1.00, "arial", "left", "top", false, false, true, false, false)
					_dxDrawText("Prozentveränderung: "..aktienSelfData[i].DayChange, 713, 258, 916, 276, tocolor(255, 255, 255, 255), 1.00, "arial", "left", "top", false, false, true, false, false)
					local playeraktien = getElementData(localPlayer, aktienSelfData[i].Name);
					if not playeraktien then
						playeraktien = 0;
					end
					_dxDrawText("Deine Aktien: "..playeraktien, 713, 279, 916, 297, tocolor(255, 255, 255, 255), 1.00, "arial", "left", "top", false, false, true, false, false)
				end
				
				if(isCursorOnElement(368*sx, (206+(y_position*49))*sy, 188*sx, 46*sy))then
					clickedX = 368*sx;
					clickedY = (206+(y_position*49))*sy;
					clickedW = 188*sx;
					clickedH = 46*sy;
					
					clickedTitel   = aktienSelfData[i].Name;
					clickedIndex   = aktienSelfData[i].Symbol;
					clickedPrice   = aktienSelfData[i].Price;
					clickedProzent = aktienSelfData[i].PercentChange;
				end
			end
			y_position = y_position + 1;
		end
	end
end


-- NEW GUI --
