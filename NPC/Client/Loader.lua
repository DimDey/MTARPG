NPC = {
    list = {};
    byServerTempIds = {};

    create = function( self, NPCData )
        local clientId = #self.list + 1
        NPCData.clientId = clientId;

        table.insert( self.list, clientId, NPCData )
        self.byServerTempIds[NPCData.tempId] = clientId

        NPCData.ped = createPed( NPCData.skin, NPCData.x, NPCData.y, NPCData.z )
        local localDimension = getElementDimension( localPlayer )

        setElementDimension( NPCData.ped, localDimension )
    end;

    delete = function( self, id )
        local clientData = self.list[id]
        if clientData then
            destroyElement(clientData.ped)
            self.byServerTempIds[clientData.tempId] = nil
            table.remove(self.list, id)
        end
    end;

    updateData = function( self, clientNPCId, NPCData )
        local clientData = self.list[clientNPCId]
        for index, value in pairs( NPCData ) do
            clientData[index] = value
        end
    end;

    onHit = function( NPCData )
        self = NPC
        if not self.byServerTempIds[NPCData.tempId] then
            self:create( NPCData )
        else
            self:updateData( self.byServerTempIds[NPCData.tempId], NPCData )
        end
    end;

    onLeave = function( NPCData )
        self = NPC
        self:destroy(self.nyServerTempIds[NPCData.tempId])
        return

    end;

    onChangeDimension = function( oldDimension, newDimension )
        if source ~= localPlayer then return end
        for i, clientData in pairs(NPC.list) do
            if clientData.dimension ~= -1 then return end
            if clientData.ped then
                setElementDimension(clientData.ped, newDimension)
            end 
        end
    end;

}
addEvent('onClientHitCollider', true)
addEventHandler('onClientHitCollider', root, NPC.onHit )
addEvent('onClientLeaveCollider', true)
addEventHandler('onClientLeaveCollider', root, NPC.onLeave)
addEventHandler('onClientElementDimensionChange', localPlayer, NPC.onChangeDimension)