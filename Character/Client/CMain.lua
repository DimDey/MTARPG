aCharData = {};
aPlayerIds = {};

Characters = {
    start = function()
        outputConsole('Start characters...');
    end;

    onClientAuth = function()
        local aPlayers = getElementsByType('player', root, true)
        triggerServerEvent('onPlayerStreamAnothers', localPlayer, aPlayers )
    end;
    
    init = function( self, aData )
        local nId = #aCharData
        table.insert(aCharData, nId, aData )

        aPlayerIds[aData.pPlayer] = nId;
        return aCharData[nId], nId
    end;

    getData = function( self, pPlayer )
        local nId = aPlayerIds[pPlayer]
        return aCharData[nId]
    end;
}
addEventHandler('onClientResourceStart', resourceRoot, Characters.start)
addEventHandler('onClientLogged', localPlayer, Characters.onClientAuth)