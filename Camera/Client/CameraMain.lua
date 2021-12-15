Camera = {
    nZoom = 1.0;
    nMinZoom = 0.5;
    nMaxZoom = 1.5;

    vPosition = Vector3(0,0,0);
    nRotation = 0;
    nLastCursorX = 0;
    bRender = true;

    onStart = function()
        addEventHandler('onClientPreRender', root, Camera.onPreRender)
        addEventHandler('onClientKey', root, Camera.onClientKey)
        showCursor( true )
    end;

    onStop = function( )
        removeEventHandler('onClientPreRender', root, Camera.onPreRender)
        removeEventHandler('onClientKey', root, Camera.onClientKey)
        Camera:stopControls( );
    end;

    setZoom = function( self, nDelta )
        local nNewZoom = self.nZoom + nDelta
        self.nZoom = math.clamp( nNewZoom, self.nMinZoom, self.nMaxZoom )
    end;

    onPreRender = function()
        local self = Camera
        local playerPos = localPlayer.position;
        local vCamPos
        local vPointTo = Vector3( 0, 0, 0 )

        vPointTo.x, vPointTo.y = getPointFromDistanceRotation( playerPos.x, playerPos.y, 10*self.nZoom, self.nRotation )
        vPointTo.z = playerPos.z

        vCamPos = vPointTo - playerPos
        vCamPos:normalize()
        local nLength = 10*self.nZoom
        vCamPos = playerPos + vCamPos * nLength
        local nGroundHit, nHitX, nHitY, nHitZ = processLineOfSight( playerPos.x, playerPos.y, playerPos.z, vCamPos.x, vCamPos.y, vCamPos.z+7+(self.nZoom*2) , true, false, false, false, false, true, true, true, nil )
        if nGroundHit then
            vCamPos.x = nHitX;
            vCamPos.y = nHitY;
        end
        vCamPos.z = vCamPos.z+7+(self.nZoom*2) 

        setCameraMatrix( vCamPos.x, vCamPos.y, vCamPos.z, playerPos.x, playerPos.y, playerPos.z )
        self.vPosition = vCamPos
        self:onUpdateControls()
    end;

    onCursorMove = function( cursorX, cursorY, absoluteX, absoluteY, worldX, worldY, worldZ)
        self = Camera;

        if getKeyState('mouse2') then
            if math.abs(absoluteX - self.nLastCursorX) < 0.1 then return end

            if absoluteX < self.nLastCursorX then
                self.nRotation = self.nRotation - 0.5
            else
                self.nRotation = self.nRotation + 0.5
            end
        end

        self.nLastCursorX = absoluteX;
    end;

    onClientKey = function( button, press )
        if button == 'mouse_wheel_up' then
            Camera:setZoom( -0.1 )
        elseif button == 'mouse_wheel_down' then
            Camera:setZoom( 0.1 )
        end
    end;
}
addEventHandler('onCameraInit', root, Camera.onStart)
addEventHandler('onClientResourceStart', resourceRoot, Camera.onStart)
addEventHandler('onClientCursorMove', root, Camera.onCursorMove )
addEventHandler('onClientKey', root, Camera.onClientKey )

addEvent('onServerStopCamera', true )
addEventHandler('onServerStopCamera', root, Camera.onStop )

bindKey('[', 'down', function()
    Camera:onStop();
end);
bindKey(']', 'down', function()
    Camera:onStart();
end);
