-- Aktien-System[Server] --


Aktien = {
	{ GoogleAktien   = { searchname = "Google" } },
	{ FacebookAktien = { searchname = "Facebook" } }
}

AktienVars = {}
AktienVars["Google"]   = {}
AktienVars["Facebook"] = {}


function loadAktien()
	
	for pos, table in pairs(Aktien) do 
		for table_name, data in pairs(table) do 
			
			fetchRemote("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="..data.searchname.."&callback=YAHOO.Finance.SymbolSuggest.ssCallback", function(vars, errno)
				if(errno == 0)then
				
					local json = vars;
					local json = json:gsub('YAHOO.Finance.SymbolSuggest.ssCallback', '');
					local json = json:sub(2, #json);
					local json = json:sub(0, #json - 1);
					
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
								
							end
						end, "", false, getRootElement());
					end
				end
			end, "", false, getRootElement())
		end
	end
end
loadAktien();


