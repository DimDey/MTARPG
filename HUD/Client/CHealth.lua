CHealth = {
    components = {
        healthBar = { p = 1; type = 'rectangle'; x = 500; y = 31; w = 431; h = 32; r = 254; g = 80; b = 80; };
        healthCount = { p = 2; type = 'text'; text = '100'; x = 500; y = 31; w = 931; h = 63; r = 255; g =  255; b =  255; font = 'deafult-bold'; alignX = 'center'; alignY = 'center'; };
    };
    bShow = true;
    nInterpolateProgress = 0;
    nAlpha = 255;

    show = function( self, state )
        self.bShow = state;
        return self.bShow
    end;

    updateBar = function( self )
        self = CHealth
        local nHealth = localPlayer.health
        if nHealth > 96 and self.nAlpha > 0 then
            if self.nInterpolateProgress == 0 then self.nInterpolateProgress = getTickCount() end
            local nResult = (getTickCount() - self.nInterpolateProgress) / 5500;
            local nAlpha = interpolateBetween( 100, 0, 0, 0, 0, 0, nResult, 'Linear' )

            self.nAlpha = nAlpha;
        else
            if nHealth < 96 then
                self.nInterpolateProgress = 0;
                self.nAlpha = 255;
            end
        end
        local nColorR, nColorG, nColorb = interpolateBetween( 178, 34, 34, 3, 150, 96, ( nHealth / 100 ), 'Linear' )
        self.components.healthCount.text = math.floor(nHealth);

        self.components.healthBar.w = interpolateBetween( 0, 0, 0, 431, 0, 0, nHealth / 100, 'Linear' );
        self.components.healthBar.r, self.components.healthBar.g, self.components.healthBar.b =  nColorR, nColorG, nColorb
    end;

    onRender = function( self )
        for index, aData in pairs( self.components ) do
            if aData.type == 'rectangle' then
                dxDrawRectangle( aData.x * aX, aData.y * aY, aData.w * aX, aData.h * aY, tocolor( aData.r, aData.g, aData.b, self.nAlpha ) );
            else
                dxDrawText( aData.text, aData.x * aX, aData.y * aY, aData.w * aX, aData.h * aY, tocolor( aData.r, aData.g, aData.b, self.nAlpha ), 1, aData.font, aData.alignX, aData.alignY )
            end
        end;
    end;
}
setTimer( CHealth.updateBar, 20, 0, CHealth );
GUI.aComponents['Health'] = CHealth;