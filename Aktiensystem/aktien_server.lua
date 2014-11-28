-- Aktiensystem[Server] --

Aktien = {
	{ GoogleAktien   = { searchname = "Google" } },
	{ FacebookAktien = { searchname = "Facebook" } }
}

AktienVars = {}
AktienVars["Google"]   = {}
AktienVars["Facebook"] = {}

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
									AktienChangeProzent = json_data["Change"],
									LastTradeDate       = json_data["LastTradeDate"],
									
								}
								
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


function refreshAktien(searchname)

	local Symbol 			  = AktienVars[searchname].Symbol;
	local Name   			  = AktienVars[searchname].Name;
	local LastTradePriceOnly  = getAktienData(Symbol, "LastTradePriceOnly");
	local AktienChangeProzent = getAktienData(Symbol, "AktienChangeProzent");
	local LastTradeDate 	  = getAktienData(Symbol, "LastTradeDate");
	
	if(LastTradePriceOnly ~= nil and AktienChangeProzent ~= nil and LastTradeDate ~= nil)then 
		
		outputDebugString("@function refreshAktien(...): by "..Symbol.." dont found aktien variables!");
		
		if(isTimer(AktienVars[searchname].RefreshTimer))then
			killTimer(AktienVars[searchname].RefreshTimer);
		end
		return;
	end
	
	AktienVars[searchname] = {
	
		Name  			    = Name,
		Symbol			    = Symbol,
		LastTradePriceOnly  = LastTradePriceOnly,
		AktienChangeProzent = AktienChangeProzent,
		LastTradeDate  		= LastTradeDate,	
	}
	outputDebugString("Aktien-Unternehmen: "..Name.." Tabelle wurde Aktuallisiert."); -- Lediglich eine Debug-Ausgabe.
end

function getAktienData(symbol, variable)
	
	assert(symbol,   "@function getAktienData(...): Symbol is not a string!");
	assert(variable, "@function getAktienData(...): variable is not a string!");
	
	local dataurl   = "http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22"..(symbol).."%22%29&format=json&env=store://datatables.org/alltableswithkeys"
			
	fetchRemote(dataurl, function(data, errno)
		
		if(errno == 0)then
			local json  = fromJSON(data);
			json_object = json["query"]["results"]["quote"];
			
			if(json_object[variable])then
				return json_object[variable];
			end
		end
	end, "", false, getRootElement());
	return nil;
end
