local robotoLight14 = dxCreateFont('Resources/Fonts/RoboLight.ttf', 14, false, 'cleartype');
local robotoBold18 = dxCreateFont('Resources/Fonts/RoboBold.ttf', 18, true, 'cleartype');
local robotoRegular12 = dxCreateFont('Resources/Fonts/RoboReg.ttf', 12, false, 'cleartype');
local ubuntuBold36 = dxCreateFont('Resources/Fonts/UbuntuBold.ttf', 36, false, 'cleartype');

NotificationsController = {
    aActive = nil;

    onChangeActive = function( self, aActive )
        if not aActive then
            self.aActive = nil;
            return
        end
        aActive.nStartTime = getTickCount();
        aActive.nFadeInTime = getTickCount() + aActive.nFadeIn;
        aActive.nFadeOutTime = 0;

        self.aActive = aActive;

    end;

    drawNotification = function( self )
        local aActive = self.aActive
        if not aActive then return end

        local nPlusWeight, nPlusHeight = dxGetTextSize('+', 0, 1, 1, ubuntuBold36)
        nPlusHeight = nPlusHeight / 2
        local _, nTextHeight = dxGetTextSize(aActive.sText, 0, 1, 1, robotoBold18)

        dxDrawBorderedText( 4, { r = 233; g = 233, b = 13, a = self.aActive.nAlpha / 70 }, '+', 10, 424, 19, 427+nPlusHeight, tocolor( 230, 215, 162, self.aActive.nAlpha ), 1, ubuntuBold36, 'left', 'center')
        dxDrawText( '+', 10, 424, 19, 427+nPlusHeight, tocolor( 230, 215, 162, self.aActive.nAlpha ), 1, ubuntuBold36, 'left', 'center' );
        
        dxDrawBorderedText( 4, { r = 233; g = 233, b = 13, a = self.aActive.nAlpha / 70 }, aActive.sType, 47, 427, 47, 427+nPlusHeight+2, tocolor( 255, 255, 255, self.aActive.nAlpha ), 1, robotoLight14, 'left', 'center')
        dxDrawText( aActive.sType, 47, 427, 47, 427+nPlusHeight+2, tocolor( 230, 215, 162, self.aActive.nAlpha ), 1, robotoLight14, 'left', 'center' );
        
        dxDrawBorderedText( 3, { r = 0, g = 0, b = 0, a = self.aActive.nAlpha / 60 }, aActive.sText, 42, 432+( nPlusHeight / 2 )+6, 42, 448+nTextHeight, tocolor( 222, 222, 255, self.aActive.nAlpha ), 1, robotoBold18 );
        dxDrawText( aActive.sText, 42, 432+( nPlusHeight / 2 )+6, 42, 448+nTextHeight, tocolor( 222, 222, 255, self.aActive.nAlpha ), 1, robotoBold18 );
        
        dxDrawBorderedText( 3, { r = 0, g = 0, b = 0, a = self.aActive.nAlpha / 60 }, aActive.sSubText, 42, 448+nTextHeight+4, 42, 470, tocolor( 222, 222, 255, self.aActive.nAlpha ), 1, robotoRegular12 );
        dxDrawText( aActive.sSubText, 42, 448+nTextHeight+4, 42, 470, tocolor( 222, 222, 255, self.aActive.nAlpha  ), 1, robotoRegular12 );
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

        self:drawNotification( );
    end;
}
addEventHandler('onClientRender', root, NotificationsController.onRender )