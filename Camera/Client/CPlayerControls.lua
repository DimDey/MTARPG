local aPlayerControls = {
    ['mouse1'] = 'forwards',
    ['lshift'] = 'sprint',
    ['rshift'] = 'sprint',
    ['space']  = 'jump'
}


Camera.onRender = function()
    self = Camera
        if not self.bRender then
            self.bRender = true;
            return 
        end
        self.bRender = false

        if getKeyState('mouse1') then
            local sX, sY, wX, wY, wZ = getCursorPosition()
            local hit, x, y, z, elementHit = processLineOfSight ( self.vPosition.x, self.vPosition.y, self.vPosition.z, wX, wY, wZ, true, false, false, false )
            if x and y then 
                local px, py = getElementPosition( localPlayer )
                angle = ( 360 - math.deg ( math.atan2 ( ( x - px ), ( y - py ) ) ) ) % 360
                setElementRotation(localPlayer, 0, 0, angle, "default", true)
            end
        end


        for key, controlState in pairs(aPlayerControls) do
            if getKeyState(key) then
                setPedControlState(localPlayer, controlState, true)
            else
                setPedControlState(localPlayer, controlState, false)
            end
        end
end;