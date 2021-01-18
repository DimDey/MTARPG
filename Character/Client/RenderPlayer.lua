RenderPlayer = {
    pShader = nil;
    onInit = function()
        RenderPlayer.pShader = dxCreateShader( 'Resources/Fx/outline-player.fx', 4, 0, true, "ped" );
        engineApplyShaderToWorldTexture(RenderPlayer.pShader, "*", localPlayer);
    end;
}
addEventHandler('onClientResourceStart', resourceRoot, RenderPlayer.onInit)