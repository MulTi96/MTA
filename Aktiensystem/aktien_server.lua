-- Aktien-System [Server] --


GoogleAktien     = {}
SonyAktien       = {}
FacebookAktien   = {}
YoutubeAktien  	 = {}
VolkswagenAktien = {}


function loadAktien()
	fetchRemote("http://www.google.de/search?q=Google+Aktien&oq=Google+Aktien&aqs=chrome..69i57j0l5.2072j0j7&sourceid=chrome&es_sm=0&ie=UTF-8", function(data, errno)
		if(errno == 0)then
			local googleAktienFile = fileCreate("googleAktien.txt");
			fileWrite(googleAktienFile, tostring(data));
			fileClose(googleAktienFile);
			
			outputChatBox("Google-Aktien Code wurde erfolgreich in die Datei geschrieben!");
		else
			outputChatBox("Google-Aktien Fehler: "..errno)
		end
	end, "", false, getRootElement())
end
loadAktien();
