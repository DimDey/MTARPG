local aPlayerControls = {
    ['mouse1'] = 'forwards',
    ['lshift'] = 'sprint',
    ['rshift'] = 'sprint',
    ['lalt'] = 'walk';
}

Camera.nPlayerRotation = 0;

Camera.onRender = function()
    self = Camera

        if getKeyState('mouse1') then
            local sX, sY, wX, wY, wZ = getCursorPosition()
            local hit, x, y, z, elementHit = processLineOfSight ( self.vPosition.x, self.vPosition.y, self.vPosition.z, wX, wY, wZ, true, false, false, false )
            if x and y then 
                local px, py = getElementPosition( localPlayer )
                self.nPlayerRotation = ( 360 - math.deg ( math.atan2 ( ( x - px ), ( y - py ) ) ) ) % 360
                setElementRotation(localPlayer, 0, 0, self.nPlayerRotation, "default", true)
            end
        else
            setElementRotation(localPlayer, 0, 0, self.nPlayerRotation, "default", true)
        end


        for key, controlState in pairs(aPlayerControls) do
            local controlEnabled = getPedControlState( localPlayer, controlState )
            local keyState = getKeyState(key)
            if controlEnabled ~= keyState then
                setPedControlState(localPlayer, controlState, keyState)
            end
        end
end;

Camera.stopControls = function( self )
    for key, controlState in pairs(aPlayerControls) do
        setPedControlState(localPlayer, controlState, false)
    end
end;