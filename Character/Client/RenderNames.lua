Characters.onClientRender = function()
    local aPlayers = getElementsByType('player', root, true)
    for index, player in ipairs( aPlayers ) do
        local aData = Characters:getData( player )
        if aData then
            local pX, pY, pZ = getPedBonePosition( player, 6 )
            local sX, sY = getScreenFromWorldPosition( pX, pY, pZ + 0.2 )
            local nHealth = player.health
            local nColorR, nColorG, nColorb = interpolateBetween( 178, 34, 34, 50, 205, 50, ( nHealth / 100 ), 'Linear' )
            if sX and sY then
                dxDrawBorderedText( 1, aData.sName, sX, sY, sX, sY, tocolor( nColorR, nColorG, nColorb, 255 ), 1, 'default-bold', 'center', 'center')
            end
        end
    end
end;
addEventHandler('onClientRender', root, Characters.onClientRender)