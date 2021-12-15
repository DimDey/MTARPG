local bRender = true
NPC.render = function()
    for index, data in ipairs(NPC.list) do
        local headX, headY, headZ = getPedBonePosition( data.ped, 4)
        local x, y = getScreenFromWorldPosition( headX, headY, headZ )
        if x and y then
            dxDrawText(data.name, x, y, x, y, white, 1, 'default-bold', 'center', 'center')
            dxDrawBorderedText(1, data.name, x, y, x, y, white, 1, 'default-bold', 'center', 'center')
        end
        if bRender then
            bRender = false
            return
        end 

        if not data.animation and #data.animations > 0 then
            if #data.animations > 1  then
                local nAnimId = math.random(1, #data.animations)
                local aAnimation = data.animations[nAnimId]
                setPedAnimation( data.ped, unpack(aAnimation))
                data.animation = nAnimId
            else
                local aAnimation = data.animations[1]
                setPedAnimation( data.ped, unpack(aAnimation))
                data.animation = 1
            end
            data.animationTime = getTickCount()
        else
            if data.animations[data.animation][3] == -1 then return end
            if (getTickCount() - data.animationTime > data.animations[data.animation][3]) then
                data.animation = false
            end
        end
        
        bRender = true
    end
end;
addEventHandler('onClientRender', root, NPC.render)