Camera = {
    nZoom = 1.0;
    nMinZoom = 0.5;
    nMaxZoom = 1.5;

    vPosition = Vector3(0,0,0);
    nRotation = 0;
    nLastCursorX = 0;
    bRender = true;

    cursor = {
        nWorldX = 0,
        nWorldY = 0,
        nWorldZ = 0,
        nCursorX, nCursorY = 0;
    };

    onStart = function()
        addEventHandler('onClientPreRender', root, Camera.onPreRender)
        addEventHandler('onClientRender', root, Camera.onRender)
        showCursor( true )
    end;

    onStop = function( )
        removeEventHandler('onClientPreRender', root, Camera.onPreRender)
        removeEventHandler('onClientRender', root, Camera.onRender)

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
            vCamPos.z = nHitZ+7+(self.nZoom*2) 
        else
            vCamPos.z = vCamPos.z+7+(self.nZoom*2) 
        end

        setCameraMatrix( vCamPos.x, vCamPos.y, vCamPos.z, playerPos.x, playerPos.y, playerPos.z )
        self.vPosition = vCamPos
    end;

    onCursorMove = function( cursorX, cursorY, absoluteX, absoluteY, worldX, worldY, worldZ)
        self = Camera;
        self.cursor.nCursorX, self.cursor.nCursorY = cursorX, cursorY;
        self.cursor.nWorldX = worldX
        self.cursor.nWorldY = worldY
        self.cursor.nWorldZ = worldZ

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
