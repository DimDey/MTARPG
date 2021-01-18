Characters.onElementStreamedIn = function( )
    if not localPlayer:getData('bLoggedIn') then return end
    if source.type == 'player' then
        triggerServerEvent('onPlayerStreamAnothers', localPlayer, source )
        return
    end
end;

Characters.onSendCharacter = function( aData )
    if type(aData) == 'table' then
        for index, data in ipairs(aData) do
            Characters:init( data );
        end
    else
        Characters:init( aData );
    end
end;
addEventHandler('onClientElementStreamIn', root, Characters.onElementStreamedIn )
addEvent('onSendCharacterData', true)
addEventHandler('onSendCharacterData', root, Characters.onSendCharacter)