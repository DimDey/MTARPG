Auth = {
    GUI = {
        text = { x = 0; y = 0; w = 100; h = 100; text = 'SERVER'; font = 'default-bold'; }
    };
    bIsLogged = false;

    onInit = function( )
        showCursor( true )
        fadeCamera( true )
        outputChatBox('Добро пожаловать')
        setCameraMatrix( 0, 0, 50, 111, 111, 0, 0, 180 )
        addEventHandler('onClientRender', root, Auth.onRender)
    end;

    onStop = function()
        localPlayer:setData('bLoggedIn', nil)
    end;

    onRender = function( )
        for index, value in pairs( Auth.GUI ) do
            dxDrawText( value.text, value.x, value.y, value.w, value.h, white, 1, value.font )
        end 
    end;

    onClientLogged = function( )
        showCursor( false )
        Auth.bIsLogged = true;
        removeEventHandler('onClientRender', root, Auth.onRender)
    end;
}
addEventHandler('onClientResourceStart', resourceRoot, Auth.onInit)
addEventHandler('onClientResourceStop', resourceRoot, Auth.onStop)
addEvent('onClientLogged', true)
addEventHandler( 'onClientLogged', localPlayer, Auth.onClientLogged )