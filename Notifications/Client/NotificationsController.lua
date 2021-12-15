local robotoLight14 = dxCreateFont('Resources/Fonts/RoboLight.ttf', 14, false, 'antialiased');
local robotoBold18 = dxCreateFont('Resources/Fonts/RoboBold.ttf', 18, true, 'antialiased');
local robotoRegular12 = dxCreateFont('Resources/Fonts/RoboReg.ttf', 12, false, 'antialiased');
local ubuntuBold36 = dxCreateFont('Resources/Fonts/UbuntuBold.ttf', 36, false, 'antialiased');

NotificationsController = {
    aActive = nil;

    nLastUpdateTick = nil;

    onChangeActive = function( self, aActive )
        if not self.pRenderTarget then
            self.pRenderTarget = dxCreateRenderTarget(1440, 900, true);
        end

        if not aActive then
            self.aActive = nil;
            return
        end
        aActive.nStartTime = getTickCount();
        aActive.nFadeInTime = getTickCount() + aActive.nFadeIn;
        aActive.nFadeOutTime = 0;

        self.aActive = aActive;

        self:updateRenderTarget();

    end;

    updateRenderTarget = function(self)
        local aActive = self.aActive
        if not aActive then return end

        dxSetRenderTarget( self.pRenderTarget, true )
        local nPlusWeight, nPlusHeight = dxGetTextSize('+', 0, 1, 1, ubuntuBold36)
        nPlusHeight = nPlusHeight / 2
        local _, nTextHeight = dxGetTextSize(aActive.sText, 0, 1, 1, robotoBold18)

        dxDrawBorderedText( 10, { r = 255; g = 255, b = 0, a = self.aActive.nAlpha }, '+', 10, 424, 19, 427+nPlusHeight, tocolor( 230, 215, 162, self.aActive.nAlpha ), 1, ubuntuBold36, 'left', 'center')
        dxDrawText( '+', 10, 424, 19, 427+nPlusHeight, tocolor( 230, 215, 162, self.aActive.nAlpha ), 1, ubuntuBold36, 'left', 'center' );
        
        dxDrawBorderedText( 10, { r = 255; g = 255, b = 0, a = self.aActive.nAlpha }, aActive.sType, 47, 427, 47, 427+nPlusHeight+2, tocolor( 255, 255, 255, self.aActive.nAlpha ), 1, robotoLight14, 'left', 'center')
        dxDrawText( aActive.sType, 47, 427, 47, 427+nPlusHeight+2, tocolor( 230, 215, 162, self.aActive.nAlpha ), 1, robotoLight14, 'left', 'center' );
        
        dxDrawBorderedText( 10, { r = 0, g = 0, b = 0, a = self.aActive.nAlpha }, aActive.sText, 42, 432+( nPlusHeight / 2 )+6, 42, 448+nTextHeight, tocolor( 222, 222, 255, self.aActive.nAlpha ), 1, robotoBold18 );
        dxDrawText( aActive.sText, 42, 432+( nPlusHeight / 2 )+6, 42, 448+nTextHeight, tocolor( 222, 222, 255, self.aActive.nAlpha ), 1, robotoBold18 );
        
        dxDrawBorderedText( 10, { r = 0, g = 0, b = 0, a = self.aActive.nAlpha }, aActive.sSubText, 42, 448+nTextHeight+4, 42, 470, tocolor( 222, 222, 255, self.aActive.nAlpha ), 1, robotoRegular12 );
        dxDrawText( aActive.sSubText, 42, 448+nTextHeight+4, 42, 470, tocolor( 222, 222, 255, self.aActive.nAlpha  ), 1, robotoRegular12 );
        dxSetRenderTarget( )

        self.nLastUpdateTick = getTickCount()
    end;

    onRender = function( )
        self = NotificationsController
        local aActive = self.aActive
        if not aActive then return end

        local nNowTick = getTickCount()

        local nFadeInProgress = (nNowTick - aActive.nFadeInTime) / self.aActive.nFadeIn;
        if nFadeInProgress < 1 then
            if nFadeInProgress < 0 then return end
            if nFadeInProgress > 0.1 and not self.aActive.bSoundPlayed then
                NotificationsAudio:playSound();
                self.aActive.bSoundPlayed = true;
            end
            aActive.nAlpha = interpolateBetween( aActive.nAlpha, 0, 0, 255, 0, 0, nFadeInProgress, 'Linear' );
        else
            if aActive.nFadeOutTime == 0 then
                aActive.nFadeOutTime = getTickCount();
            end
            local nFadeOutProgress = (nNowTick - aActive.nFadeOutTime ) / aActive.nFadeOut;

            aActive.nAlpha = interpolateBetween( aActive.nAlpha, 0, 0, 0, 0, 0, nFadeOutProgress, 'Linear' );

            if aActive.nAlpha == 0 then
                Notifications:remove();
            end
        end
        
        if nNowTick - self.nLastUpdateTick > 3 then
            self:updateRenderTarget()
        end
        
        dxDrawImage ( 0, 0, 1440, 900, self.pRenderTarget, 0, 0, 0, tocolor(255, 255, 255, aActive.nAlpha) )
    end;
}
addEventHandler('onClientRender', root, NotificationsController.onRender )