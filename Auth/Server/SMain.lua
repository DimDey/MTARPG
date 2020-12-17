PASSWORDHESHKEY = 'FpgN2';
SAuth = {

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
addEventHandler('onResourceStart', resourceRoot, SAuth.onInit)

function devAuth( pPlayer, commandName, sLogin, sPassword )
    if commandName == 'reg' then
        SAuth.Register:onCreateCharacter( pPlayer, sLogin, sPassword)
    else
        SAuth.Login:onCharacterAuth( pPlayer, sLogin, sPassword)
    end
end

addCommandHandler('reg', devAuth);
addCommandHandler('log', devAuth);