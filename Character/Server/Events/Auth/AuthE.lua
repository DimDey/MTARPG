Character.onCharacterLogged = function( sLogin, nCharacterId )
    outputDebugString('[JR-CH]: '..sLogin..' select a character('..nCharacterId..')!');
    spawnPlayer( source, 0, 0, 0, 90, 98, 0, 0 )
    setCameraTarget( source, source )

    local characterColShape = createColSphere( 0, 0, 0, 20 )
    attachElements( characterColShape, source )

    local pElement, nId = Character:initialize{
        sName = sLogin,
        pPlayer = source,
        pCol = characterColShape,
        nHealth = source.health
    };
    source:setData( 'charTableId', nId );
end;
addEvent('onCharacterLogged', true)
addEventHandler('onCharacterLogged', root, Character.onCharacterLogged)