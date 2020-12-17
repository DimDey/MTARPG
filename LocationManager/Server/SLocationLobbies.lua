aActiveLobbies = {};
aActiveDimensions = {};

LocationLobbyManager = {
    createLobby = function( self, pLocation, pConnectPlayer )
        local nLocationId = pLocation.nLocationId

        if not aActiveLobbies[nLocationId] then
            aActiveLobbies[nLocationId] = {};
        end

        local nLobbyId = #aActiveLobbies[nLocationId] + 1 or 1;
        local nLobbyDim = math.random(1, 30000)
        local aLobbyData = {
            nLobbyDim = nLobbyDim;
            nLobbyId = nLobbyId;
            nLocationId = nLocationId;
            pLocation = pLocation;
            nCurrentPlayers = 0;
            aPlayers = {};
        };

        table.insert(aActiveLobbies[nLocationId], nLobbyId, aLobbyData );
        if pConnectPlayer then
            self:connectLobby( pConnectPlayer, aActiveLobbies[nLocationId][nLobbyId] );
        end
        return;
    end;

    removeLobby = function( self, aLocationId, aLobbyId )
        outputDebugString('remove lobby')
    end;

    connectLobby = function( self, pPlayer, aLobby )
        local aOldLobby = pPlayer:getData('rpg-activeLobby')
        if aOldLobby then
            self:disconnectLobby( pPlayer, aOldLobby);
        end
        local nSpawnX, nSpawnY, nSpawnZ = aLobby.pLocation:getSpawnPosition();

        setElementDimension( pPlayer, aLobby.nLobbyDim );
        setElementPosition( pPlayer, nSpawnX, nSpawnY, nSpawnZ );

        pPlayer:setData('rpg-activeLobby', aLobby );
        aLobby.nCurrentPlayers = aLobby.nCurrentPlayers + 1;
        aLobby.aPlayers[pPlayer] = true; 
        return;
    end;

    disconnectLobby = function( self, pPlayer, aLobbyData )
        local nLocationId = aLobbyData.nLocationId
        local nLobbyId = aLobbyData.nLobbyId;

        local aLobby = aActiveLobbies[nLocationId][nLobbyId]
        if aLobby then
            aLobby.nCurrentPlayers = aLobby.nCurrentPlayers - 1;
            aLobby.aPlayers[pPlayer] = nil;
            if aLobby.nCurrentPlayers == 0 then
                self:removeLobby( nLocationId, nLobbyId );
            end
            return;
        end
    end;

    connectFreeLobby = function( self, pLocation, pPlayer )
        local nLocationId = pLocation.nLocationId
        if aActiveLobbies[nLocationId] then
            for index, aData in ipairs( aActiveLobbies[nLocationId] ) do
                if aData.nCurrentPlayers < pLocation.nMaxPlayers then
                    return aActiveLobbies[index];
                end
            end
            
        else
            aActiveLobbies[nLocationId] = {};
        end
        return self:createLobby( pLocation, pPlayer );
    end;
}