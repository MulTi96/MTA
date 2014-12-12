function dxSetVisible( element, state ) 
	if ( element ) then
		element.activ = state; 
	else
		return outputDebugString("Failed setVisible dxElement!");
	end
end

function dxGetVisible( element )
	if ( element ) then
		return(element.activ);
	else
		return outputDebugString("Failed getVisible dxElement!");
	end
end

function dxGetText( element )
	if ( element ) then
		return tostring(element.text);
	else
		return outputDebugString("Failed getText dxElement!");
	end
end	

function dxSetText( element, text )
	if ( element ) then
		element.text = tostring(text)
	else
		return outputDebugString("Failed setText dxElement!");
	end
end
