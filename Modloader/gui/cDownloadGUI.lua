
local screenW, screenH = guiGetScreenSize()



function RenderModlistGUI()




	
	dxDrawRectangle(screenW * 0.381, screenH * 0.333, screenW * 0.227, screenH * 0.448, tocolor(13, 13, 13, 255), false)
	dxDrawText("Modname", screenW * 0.391, screenH * 0.384, screenW * 0.437, screenH * 0.406, tocolor(255, 255, 255, 255), 1.50, "default-bold", "left", "top", false, false, false, false, false)
	dxDrawText("Größe", screenW * 0.473, screenH * 0.385, screenW * 0.505, screenH * 0.406, tocolor(255, 255, 255, 255), 1.50, "default-bold", "left", "top", false, false, false, false, false)
	dxDrawText("Status", screenW * 0.570, screenH * 0.386, screenW * 0.602, screenH * 0.406, tocolor(255, 255, 255, 255), 1.50, "default-bold", "left", "top", false, false, false, false, false)
	dxDrawRectangle(screenW * 0.381, screenH * 0.410, screenW * 0.227, screenH * 0.024, tocolor(28, 28, 28, 255), false)
	dxDrawRectangle(screenW * 0.381, screenH * 0.333, screenW * 0.227, screenH * 0.034, tocolor(101, 52, 0, 255), false)
	dxDrawText("Modloader", screenW * 0.381, screenH * 0.333, screenW * 0.608, screenH * 0.368, tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
	dxDrawRectangle(screenW * 0.381, screenH * 0.628, screenW * 0.227, screenH * 0.009, tocolor(55, 28, 0, 255), false)
	dxDrawRectangle(screenW * 0.384, screenH * 0.644, screenW * 0.080, screenH * 0.048, tocolor(255, 255, 255, 255), false)
	dxDrawRectangle(screenW * 0.384, screenH * 0.716, screenW * 0.080, screenH * 0.048, tocolor(255, 255, 255, 255), false)
	dxDrawRectangle(screenW * 0.524, screenH * 0.645, screenW * 0.080, screenH * 0.048, tocolor(255, 255, 255, 255), false)
	dxDrawRectangle(screenW * 0.524, screenH * 0.717, screenW * 0.080, screenH * 0.048, tocolor(255, 255, 255, 255), false)
	dxDrawText("Download", screenW * 0.384, screenH * 0.643, screenW * 0.464, screenH * 0.691, tocolor(27, 55, 0, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
	dxDrawText("Löschen", screenW * 0.524, screenH * 0.645, screenW * 0.604, screenH * 0.694, tocolor(55, 0, 0, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
	dxDrawText("Aktivieren", screenW * 0.384, screenH * 0.716, screenW * 0.464, screenH * 0.764, tocolor(27, 55, 0, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
	dxDrawText("Deaktivieren", screenW * 0.524, screenH * 0.716, screenW * 0.604, screenH * 0.764, tocolor(55, 0, 0, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
	dxDrawRectangle(screenW * 0.468, screenH * 0.637, screenW * 0.051, screenH * 0.139, tocolor(55, 28, 0, 255), false)
	dxDrawRectangle(screenW * 0.381, screenH * 0.773, screenW * 0.227, screenH * 0.008, tocolor(55, 28, 0, 255), false)
	dxDrawRectangle(screenW * 0.381, screenH * 0.700, screenW * 0.227, screenH * 0.010, tocolor(55, 28, 0, 255), false)
	dxDrawText("Turismo", screenW * 0.391, screenH * 0.415, screenW * 0.415, screenH * 0.428, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)
	dxDrawText("16 MB", screenW * 0.477, screenH * 0.415, screenW * 0.500, screenH * 0.428, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
	dxDrawText("Gedownloaded/Aktiviert", screenW * 0.531, screenH * 0.416, screenW * 0.601, screenH * 0.430, tocolor(255, 255, 255, 255), 1.00, "default", "right", "top", false, false, false, false, false)
	dxDrawRectangle(screenW * 0.381, screenH * 0.438, screenW * 0.227, screenH * 0.024, tocolor(28, 28, 28, 255), false)
	dxDrawText("Turismo 2", screenW * 0.392, screenH * 0.443, screenW * 0.415, screenH * 0.456, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)
	dxDrawText("32 MB", screenW * 0.477, screenH * 0.442, screenW * 0.500, screenH * 0.455, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
	dxDrawText("-/Deaktiviert", screenW * 0.531, screenH * 0.443, screenW * 0.601, screenH * 0.456, tocolor(255, 255, 255, 255), 1.00, "default", "right", "top", false, false, false, false, false)
	
	
	for i = 1, #Modlist do
		
		Templist[i] = {}
		Templist[i]["Name"] = Modlist[i]["Name"];
		Templist[i]["Size"] = Modlist[i]["Size"];
	end
end