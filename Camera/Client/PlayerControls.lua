local aPlayerControls = {
    ['mouse1'] = 'forwards',
    ['lshift'] = 'sprint',
    ['rshift'] = 'sprint',
    ['lalt'] = 'walk';
}

local aEnabledControls = {}

Camera.nPlayerRotation = 0;

Camera.onUpdateControls = function( self )
    self = Camera
    if self.bRender then
        self.bRender = false;
        return
    end 

    if getKeyState('mouse1') then
        local sX, sY, wX, wY, wZ = getCursorPosition()
        local pX, pY, pZ = getElementPosition( localPlayer )
        local hit, x, y, z, elementHit = processLineOfSight ( self.vPosition.x, self.vPosition.y, self.vPosition.z, wX, wY, wZ, true, false, true, false )
        
        if elementHit then
            if getElementType(elementHit) == 'player' and elementHit ~= localPlayer then
                return 
            elseif getElementType(elementHit) == 'ped' then
                triggerEvent('onClientClickPed', elementHit)
                return
            end
        end
        if x and y then 
            self.nPlayerRotation = ( 360 - math.deg ( math.atan2 ( ( x - pX ), ( y - pY ) ) ) ) % 360
            setElementRotation(localPlayer, 0, 0, self.nPlayerRotation, "default", true)
        end
    else
        setElementRotation(localPlayer, 0, 0, self.nPlayerRotation, "default", true)
    end
    self.bRender = true;
end;

Camera.onClientKey = function( btn, press )
    if aPlayerControls[btn] then
        if aEnabledControls[btn] ~= press then
            aEnabledControls[btn] = press
            setPedControlState(localPlayer, aPlayerControls[btn], press)
        end
    end
end;

Camera.stopControls = function( self )
    for key, controlState in pairs(aPlayerControls) do
        setPedControlState(localPlayer, controlState, false)
        aEnabledControls[btn] = false
    end
end;