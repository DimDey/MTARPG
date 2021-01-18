NPC.render = function()
    for index, data in ipairs(NPC.list) do
        local headX, headY, headZ = getPedBonePosition( data.ped, 4)
        local x, y = getScreenFromWorldPosition( math.ceil(headX), math.ceil(headY), math.ceil(headZ) )
        if x and y then
            dxDrawText(data.name, x, y, x, y, white, 1, 'default-bold', 'center', 'center')
            dxDrawBorderedText(1, data.name, x, y, x, y, white, 1, 'default-bold', 'center', 'center')
        end
    end
end;
addEventHandler('onClientRender', root, NPC.render)