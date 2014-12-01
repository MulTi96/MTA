-- Aktiensystem[Server] --

Aktien = {
	{ GoogleAktien   = { searchname = "Google" } },
	{ FacebookAktien = { searchname = "Facebook" } }
}

AktienVars = {}
AktienVars["Google"]   = {}
AktienVars["Facebook"] = {}

local aktienRefreshTable = {}


local refreshCycle = 60000 -- 1 Minute

function loadAktien()
	
	for pos, table in pairs(Aktien) do 
		for table_name, data in pairs(table) do 
			
			fetchRemote("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="..data.searchname.."&callback=YAHOO.Finance.SymbolSuggest.ssCallback", function(vars, errno)
				if(errno == 0)then
				
					local json = vars;
					local json = json:gsub('YAHOO.Finance.SymbolSuggest.ssCallback', '');
					local json = json:sub(2, #json - 1);
					
					local json = fromJSON(json);
					
					for _, variable in pairs(json["ResultSet"]["Result"]) do 
					
						
						if not(variable["exchDisp"] == "NASDAQ" and not(AktienVars[data.searchname].exchDisp == "NASDAQ"))then 
							return
						end
						
						AktienVars[data.searchname] = {
							
								searchname = data.searchname,
								fullname   = variable["name"],
								symbol     = variable["symbol"],
								exchDisp   = variable["exchDisp"]
							
						}
						
						local tableVars = AktienVars[data.searchname];
						
						dataurl   = "http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22"..tableVars.symbol.."%22%29&format=json&env=store://datatables.org/alltableswithkeys"
					

						fetchRemote(dataurl, function(callback_data, callback_errno)
						
							if(callback_errno == 0)then
							
								local json = callback_data;
								local json = fromJSON(json);
								
								json_data = json["query"]["results"]["quote"];
								
								outputChatBox("Aktien Preis von "..tableVars.fullname..": "..json_data["LastTradePriceOnly"]);		
								
								AktienVars[data.searchname] = {
								
									Name     			= tableVars.fullname,
									Symbol       		= json_data["Symbol"],
									LastTradePriceOnly  = json_data["LastTradePriceOnly"],
									ChangeAktienProzent = json_data["PercentChange"],
									
								}
								
								aktienRefreshTable[json_data["Symbol"]] = {}
								aktienRefreshTable[json_data["Symbol"]]["LastTradePriceOnly"] = json_data["LastTradePriceOnly"];
								aktienRefreshTable[json_data["Symbol"]]["PercentChange"] 	  = json_data["PercentChange"];
								
								AktienVars[data.searchname].RefreshTimer = setTimer(refreshAktien, refreshCycle, -1, data.searchname);
								
							end
						end, "", false, getRootElement());
					end
				end
			end, "", false, getRootElement())
		end
	end
end
loadAktien();

function loadServerAktien(player)	
	triggerClientEvent(player, "loadClientAktien", player, AktienVars);
end
addEvent("loadAktienServer", true)	
addEventHandler("loadAktienServer", root, loadServerAktien)

addEvent("buyAktie", true)
addEventHandler("buyAktie", root, function(player, unternehmen, price, prozent)
	
	local opr;
	local aktienprice;
	local aktienprozentwert;
	
	if(prozent:find('+'))then
		opr 			  = prozent:sub(2, #prozent - 1); 
		aktienprozentwert = ((price*opr)/100);
		aktienprice       = price + aktienprozentwert;
	end
	
	if(getPlayerMoney(player) >= aktienprice)then
		if getElementData(player, unternehmen) then
			setElementData(player, unternehmen, getElementData(player, unternehmen) + 1);
		else
			setElementData(player, unternehmen, 1);
		end
		setPlayerMoney(player, getPlayerMoney(player) - aktienprice);
		outputChatBox("Du hast dir 1 Aktie von "..unternehmen.." Gekauft!", player, 0, 125, 0);
	else
		outputChatBox("Du hast nicht genug Geld!", player, 125, 0, 0);
	end
end)


function refreshAktien(searchname)

	local Symbol 			   = AktienVars[searchname].Symbol;
	local Name   			   = AktienVars[searchname].Name;
	
	setAktienData(Symbol, "LastTradePriceOnly");
	setAktienData(Symbol, "PercentChange");
	
	local LastTradePriceOnly  = aktienRefreshTable[Symbol]["LastTradePriceOnly"];
	local ChangeAktienProzent = aktienRefreshTable[Symbol]["PercentChange"];
	
	AktienVars[searchname] = {
	
		Name  			    = Name,
		Symbol			    = Symbol,
		LastTradePriceOnly  = LastTradePriceOnly,
		ChangeAktienProzent = ChangeAktienProzent,
	}
	outputDebugString("Aktien-Unternehmen: "..Name.." Tabelle wurde Aktuallisiert."); -- Lediglich eine Debug-Ausgabe.
end

function setAktienData(symbol, variable)
	
	assert(symbol,   "@function getAktienData(...): Symbol is not a string!");
	assert(variable, "@function getAktienData(...): variable is not a string!");
	
	local dataurl   = "http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22"..(symbol).."%22%29&format=json&env=store://datatables.org/alltableswithkeys"
			
	fetchRemote(dataurl, function(data, errno)
		
		if(errno == 0)then
			local json  = fromJSON(data);
			json_object = json["query"]["results"]["quote"];
			
			aktienRefreshTable[symbol][variable] = json_object[variable];
		end
	end, "", false, getRootElement());
end
