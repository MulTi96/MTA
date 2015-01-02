

AktienWindow = guiCreateWindow(0.28, 0.24, 0.45, 0.41, "Aktiensystem", true)
guiWindowSetMovable(AktienWindow, false)
guiWindowSetSizable(AktienWindow, false)
guiSetVisible(AktienWindow, false);

AktienGridlist = guiCreateGridList(0.02, 0.10, 0.95, 0.62, true, AktienWindow)
AktienUnternehmen = guiGridListAddColumn(AktienGridlist, "Unternehmen", 0.3)
Aktienwert = guiGridListAddColumn(AktienGridlist, "Aktienwert", 0.3)
AktienProzentSatz = guiGridListAddColumn(AktienGridlist, "+-%", 0.3)
AktienBuyButton = guiCreateButton(0.04, 0.78, 0.34, 0.17, "Aktien Kaufen", true, AktienWindow)
AktienPayButton = guiCreateButton(0.60, 0.79, 0.34, 0.17, "Aktien Verkaufen", true, AktienWindow)


bindKey("f5", "down", function(_, stn)
	if(stn == "down")then
		if(guiGetVisible(AktienWindow) == true)then
			showCursor(false);
			guiSetVisible(AktienWindow, false)
		else
			triggerServerEvent("loadAktienServer", localPlayer, localPlayer)
		end
	end
end)

addEventHandler("onClientGUIClick", AktienBuyButton, function()
	local cRow = guiGridListGetItemText(AktienGridlist, guiGridListGetSelectedItem(AktienGridlist), 1);
	if(cRow and cRow ~= -1)then
		local cPrice   = guiGridListGetItemText(AktienGridlist, guiGridListGetSelectedItem(AktienGridlist), 2);
		local cProzent = guiGridListGetItemText(AktienGridlist, guiGridListGetSelectedItem(AktienGridlist), 3);
		
		if(cPrice and cProzent)then
			triggerServerEvent("buyAktie", localPlayer, localPlayer, cRow, cPrice, cProzent);
		end
	end
end,false)


addEventHandler("onClientGUIClick", AktienPayButton, function()
	local cRow = guiGridListGetItemText(AktienGridlist, guiGridListGetSelectedItem(AktienGridlist), 1);
	if(cRow and cRow ~= -1)then
		local cPrice   = guiGridListGetItemText(AktienGridlist, guiGridListGetSelectedItem(AktienGridlist), 2);
		local cProzent = guiGridListGetItemText(AktienGridlist, guiGridListGetSelectedItem(AktienGridlist), 3);
		
		if(cPrice and cProzent)then
			triggerServerEvent("payAktie", localPlayer, localPlayer, cRow, cPrice, cProzent);
		end
	end
end,false)


addEvent("loadClientAktien", true)
addEventHandler("loadClientAktien", localPlayer, function(aktien_table)
	
	guiGridListClear(AktienGridlist);
	
	showCursor(true);
	guiSetVisible(AktienWindow, true);
	for position, data in pairs(aktien_table) do 
		local row = guiGridListAddRow(AktienGridlist);
		guiGridListSetItemText(AktienGridlist, row, AktienUnternehmen, data.Name, false, false)
		guiGridListSetItemText(AktienGridlist, row, Aktienwert, data.LastTradePriceOnly, false, false)
		guiGridListSetItemText(AktienGridlist, row, AktienProzentSatz, data.ChangeAktienProzent, false, false);
	end
end)
