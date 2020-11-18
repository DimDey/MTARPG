Characters = {
    aData = {};
    nCharactersCount = 0;

    --[[
        MYSQL CHARACTER TABLE:
        int     id,
        string  username,
        string  password,
        level,      //  Формула экспы: 
        exp,        //  exp = (level * 6) * 10
        money,
        skin,
        fractionid,
        json    inventorydata,
            inventorydata: {
                ...
            }
        
    ]]

    init = function( )
        local sDatabase = exports.GameController:exportDB()
        if not sDatabase then
            outputDebugString('[JR-CH]: Database connection lost.')
            stopResource( getThisResource() )
            return false;
        end
        loadstring(sDatabase)()
        addEventHandler('onDatabasePoll', resourceRoot, Characters.result)
    end;

    result = function( self, aData )
        outputDebugString(inspect(aData))
    end;

    create = function( self, pPlayer, aCharacter )
        if pPlayer.type ~= 'player' then return false end
        self.nCharactersCount = self.nCharactersCount + 1

        local aCharacterElement = setmetatable(aCharacter, Character)

        table.insert( self.aData, self.nCharactersCount, aCharacterElement )
       
        pPlayer:setData('nCharacterId', self.nCharactersCount ); -- просто чтобы не потерять случайно его данные)))

        return self.aData[self.nCharactersCount];
    end;

    getCharacter = function( self, pPlayer )
        local nId = pPlayer:getData('nCharacterId')
        return self.aData[nId];
    end;
}
addEventHandler('onResourceStart', resourceRoot, Characters.init)

addCommandHandler('kek', function( source )
    local player = Characters:create( source, {
        name = 'DimDey',
        somedata = 123;
    } )
    outputDebugString(player.name)
    
end)