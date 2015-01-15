DownloadManager 		= {};
DownloadManager.__index = DownloadManager;

function DownloadManager:Construct()
	local self 				    = {};
	setmetatable(self, {__index = self});
	
	
	self.Modlist 						  = {};
	
	for index, data in pairs(Modlist) do 
		self.Modlist[index]				  = {};
		self.Modlist[index]["Modname"]    = data.Modname;
		
		if(data.TXDPath and data.TXDID)then
			self.Modlist[index]["ModTXDID"]   = data.TXDID;
			self.Modlist[index]["ModTXDPath"] = data.TXDPath;
		else
			self.Modlist[index]["ModTXDID"]   = 'disable';
			self.Modlist[index]["ModTXDPath"] = 'disable';
		end
		if(data.DFFPath and data.DFFID)then
			self.Modlist[index]["ModDFFID"]   = data.DFFID;
			self.Modlist[index]["ModDFFPath"] = data.DFFPath;
		else
			self.Modlist[index]["ModDFFID"]   = 'disable';
			self.Modlist[index]["ModDFFPath"] = 'disable';
		end
		if(data.COLPath and data.COLID)then
			self.Modlist[index]["ModCOLID"]   = data.COLID;
			self.Modlist[index]["ModCOLPath"] = data.COLPath;
		else
			self.Modlist[index]["ModCOLID"]   = 'disable';
			self.Modlist[index]["ModCOLPath"] = 'disable';
		end
		
	end

	
	
	return self;
end

function DownloadManager:Download(id)
	if(self.Modlist[id])then
		if not self.Download[client] then
			self.Download[client]     = {};
		end
		if not self.Download[client][id] then
			self.Download[client][id] 			= {};
			self.Download[client][id]["Status"] = 0;
		end
		if(isActivate(self.Modlist[id]["ModTXDPath"]))then
			self.Download[client][id]["ModTXDFile"] = File(self.Modlist[id]["ModTXDPath");
			self.Download[client][id]["ModTXDRead"] = self.Download[client][id]["ModTXDFile"]:read(self.Download[client][id]["ModTXDFile"]:getSize());
			
			self.Download[client][id]["ModTXDFile"]:close();
		end
		
		if(isActivate(self.Modlist[id]["ModDFFPath"]))then
			self.Download[client][id]["ModDFFFFile"] = File(self.Modlist[id]["ModDFFPath");
			self.Download[client][id]["ModDFFFRead"] = self.Download[client][id]["ModDFFFFile"]:read(self.Download[client][id]["ModDFFFFile"]:getSize());
			
			self.Download[client][id]["ModDFFFFile"]:close();
		end
		
		if(isActivate(self.Modlist[id]["ModCOLPath"]))then
			self.Download[client][id]["ModCOLFile"] = File(self.Modlist[id]["ModCOLPath");
			self.Download[client][id]["ModCOLRead"] = self.Download[client][id]["ModCOLFile"]:read(self.Download[client][id]["ModCOLFile"]:getSize());
			
			self.Download[client][id]["ModCOLFile"]:close();
		end
		
		triggerLatentClientEvent(
							   client, 'onClientDownloadMod', DownloadSpeed, false, client, 				-- *** DOWNLOAD MIT 1 MB *** --
							   self.Download[client][id]["ModTXDRead"], 
							   self.Download[client][id]["ModDFFFRead"],
							   self.Download[client][id]["ModCOLRead"]
		);
		
		self.Download[client][id]["LatentTimer"] = Timer(self:UpdateDownloadStatus, 50, 0, id, client);
		
	end
end

function DownloadManager:UpdateDownloadStatus(id, client)
	if(self.Download[client][id])then
		self.Download[client][id]["LatentHandler"] = getLatentEventHandles(client)[#getLatentEventHandles(client)];
		
		if(self.Download[client][id]["LatentHandler"])then
			
			self.Download[client][id]["LatentStatus"] = getLatentEventStatus(client, self.Download[client][id]["LatentHandler"]);
			
			if(self.Download[client][id]["LatentStatus"])then
				triggerClientEvent(client, "onClientUpdateStatus", client, self.Download[client][id]["LatentStatus"].percentComplete, self.Download[client][id]["LatentStatus"].totalSize);
			end
		else
			if self.Download[client][id]["LatentTimer"]:isValid() then
				killTimer(self.Download[client][id]["LatentTimer"]:isValid());
			end
		end
	end
end

	
function isActivate(string)
	local str = tostring(string);
	if(str == 'disable')then
		return false;
	else
		return true;
	end
end