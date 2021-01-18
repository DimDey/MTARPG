NPC = { 
    list = {};
    byDimensionList = {}; -- Приходится осчитывать каждый раз -2 элемента, т.к учитывается -1 дименшн
    create = function( self, data )
        if not data.x or not data.y or not data.z then
            outputDebugString('error');
            return
        end
        data.skin = data.skin or math.random( 0, 299 )
        data.col = createColSphere( data.x, data.y, data.z, 100 )
        data.tempId = #self.list + 1
        data.dimension = data.dimension or -1
        table.insert( self.list, data );

        setElementDimension(data.col, data.dimension + 1)
        setElementData( data.col, 'NPC_tempId', data.tempId, false )

        if not self.byDimensionList[data.dimension + 2] then -- т.к таблицы начинаются с 1, а дименшн может быть -1
            self.byDimensionList[data.dimension + 2] = {}
        end
        table.insert( self.byDimensionList[data.dimension + 2], data.tempId );

        addEventHandler('onColShapeHit', root, NPC.onPlayerHitCollider)

        setTimer( function( data )
            for index, player in ipairs( getElementsWithinColShape(data.col, 'player') ) do
                local matchingDimension = (getElementDimension(player) == data.dimension)
                NPC.onPlayerHitCollider( player, matchingDimension, data.col )
            end
        end, 400, 1, data)

        
        
    end;

    getNPCInDimension = function( self, dimension )
        if dimension > - 1 and dimension < 65535 then
            return self.byDimensionList[dimension] or {}
        end
    end;

    getNPCFromCol = function( self, colshape )
        local tempId = getElementData( colshape, 'NPC_tempId')
        return self.list[tempId]
    end;

    onPlayerHitCollider = function( hitElement, matchingDimension, colShapeFromScript )
        if getElementType(hitElement) ~= 'player' then return end

        if colShapeFromScript then
            source = colShapeFromScript
        end

        local NPCData = NPC:getNPCFromCol( source )
        if not NPCData then return end

        if NPCData.dimension ~= -1 then
            if not matchingDimension then return end
        end

        triggerClientEvent(hitElement, 'onClientHitCollider', hitElement, NPCData )
    end;

    onPlayerLeaveCollider = function( hitElement, matchingDimension )
        if getElementType(hitElement) ~= 'player' then return end
        

        local NPCData = NPC:getNPCFromCol( source )
        if not NPCData then return end

        if NPCData.dimension ~= -1 then
            if not matchingDimension then return end
        end

        triggerClientEvent(hitElement, 'onClientLeaveCollider', hitElement, NPCData )
    end;

}

NPC:create{
    x = 136;
    y = -85;
    z = 1;
    skin = 98;
    dimension = -1;

    name = 'Витька Чеснок';
}
