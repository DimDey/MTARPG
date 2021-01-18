aCharactersData = {
    nCount = 0;
    aList = {};
};

Character = {
    onInit = function( )
        outputDebugString('[JR-CH]: Module init...')
        local sDatabase = exports.GameController:exportDB()
        if not sDatabase then
            outputDebugString('[JR-CH]: Database connection lost.')
            stopResource( getThisResource() )
            return false;
        end
        loadstring(sDatabase)()
    end;

    initialize = function( self, aData )
        aCharactersData.nCount = aCharactersData.nCount + 1;

        table.insert( aCharactersData.aList, aData );
        return aCharactersData.aList[aCharactersData.nCount], aCharactersData.nCount
    end;

    getData = function( self, player )
        local nCharId = player:getData('charTableId')
        if nCharId then
            return aCharactersData.aList[nCharId]
        end
    end;
}