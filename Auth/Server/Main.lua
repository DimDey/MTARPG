PASSWORDHESHKEY = 'FpgN2';
Auth = {

    onInit = function()
        outputDebugString('[JR-AUTH]: Module init...');
        local sDatabase = exports.GameController:exportDB()
        if not sDatabase then
            outputDebugString('[JR-AUTH]: Database connection lost.')
            stopResource( getThisResource() )
            return false;
        end
        loadstring(sDatabase)()
    end;

    onCharacterSuccessAuth = function( self, pPlayer, sLogin, nCharacterId )
        pPlayer:setData( 'nCharacterId', nCharacterId )
        pPlayer:setData( 'bLoggedIn', true )
        triggerEvent( 'onCharacterLogged', pPlayer, sLogin, nCharacterId  )
        triggerClientEvent( pPlayer, 'onClientLogged', pPlayer )
        return true;
    end;
}
addEventHandler('onResourceStart', resourceRoot, Auth.onInit)

function devAuth( pPlayer, commandName, sLogin, sPassword )
    if commandName == 'reg' then
        Auth.Register:onCreateCharacter( pPlayer, sLogin, sPassword)
    else
        Auth.Login:onCharacterAuth( pPlayer, sLogin, sPassword)
    end
end

addCommandHandler('reg', devAuth);
addCommandHandler('log', devAuth);