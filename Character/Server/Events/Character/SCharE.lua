Character.onPlayerStreamAnothers = function( aPlayer ) 
    if type(aPlayer) == 'table' then
        local aCharacters = {}
        for index, player in ipairs( aPlayer ) do
            local data = Character:getData( player );
            table.insert(aCharacters, data);
        end;
        triggerClientEvent( client, 'onSendCharacterData', client, aCharacters )
    else   
        local aCharacter = Character:getData( aPlayer )
        triggerClientEvent( client, 'onSendCharacterData', client, aCharacter )
    end
    return true;
end
addEvent('onPlayerStreamAnothers', true)
addEventHandler('onPlayerStreamAnothers', root, Character.onPlayerStreamAnothers)