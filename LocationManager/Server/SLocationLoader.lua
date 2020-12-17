aLocations = {};
aLocationsCount = 0;

LocationManager = {

    load = function( self, pLocation )
        if not pLocation.sLocationName then 
            pLocation.sLocationName = 'UNDEFINED';
        end;
        if not pLocation.spawn.x or not pLocation.spawn.y or not pLocation.spawn.z then
            outputDebugString('Locations: undefined spawn location('..pLocation.sLocationName..') coordinate!')
            return false;
        end

        if not pLocation.pMapFile then
            outputDebugString('Locations: a map location('..pLocation.sLocationName..') is undefined.');
            return false;
        end;

        outputDebugString(loadMapData(pLocation.pMapFile, root))

        if not pLocation.bSinglePlayer then 
            pLocation.bSinglePlayer = false 
        else
            pLocation.nMaxPlayers = 1;
        end;

        aLocationsCount = aLocationsCount + 1;

        pLocation.nLocationId = aLocationsCount;
        pLocation = setmetatable(pLocation, self);

        aLocations[pLocation.sLocationName] = pLocation;
        return pLocation;
    end;

    getLocationFromName = function( self, sLocationName )
        return aLocations[sLocationName] or false;
    end;

    getSpawnPosition = function( self )
        return self.spawn.x, self.spawn.y, self.spawn.z
    end;

    loadPlayerToLocation = function( self, pPlayer, sLocationName )
        if pPlayer.type ~= 'player' then return end; 
        local pLocation = self:getLocationFromName(sLocationName);
        if pLocation then
            if pLocation.bSinglePlayer then
                LocationLobbyManager:createLobby( pLocation, pPlayer );
            else
                LocationLobbyManager:connectFreeLobby( pLocation, pPlayer )
            end
        end
    end;

    onInit = function( self )
        for i, pPlayer in ipairs(getElementsByType('player')) do
            pPlayer:setData('rpg-activeLobby', aLobby );
        end
        
    end;

    __index = function( self, key )
        if key == 'load' then return end;
        local get = rawget(LocationManager, key)
        if get then
            return get
        else
            return rawget( self, key )
        end
    end;
}
addEventHandler('onResourceStart', resourceRoot, LocationManager.onInit)