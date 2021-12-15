Quests = {
    CachedPlayers = {},

}

Quests.cachePlayer = function(player, data)
    if not Quests.CachedPlayers[player] then Quests.CachedPlayers[player] = { active = {}, completed = {} } end

    for i=1, #data.active do
        local nId = data.active[i].nId
        if Quest.CachedPlayers[player].active[nId] then
            Quest.CachedPlayers[player].active[nId] = nil
            --triggertoclient  
        end
        local object = {}
        object.nId = nId
        object.tasks = fromJSON(data.active[i].tasks)
        table.insert(Quests.CachedPlayers[player].active, nId, object)
        
        --[[  
        tasks = {
            [1] = {
                sState = "ACTIVE",
                sType = "KILL",
                aTaskData = { 
                    nCount = 0, 
                    sMobType = "player"
                }
            },
            [2] = {
                sState = "ACTIVE",
                sType = "RESEARCH",
                aTaskData = { 
                    nTimeToResearch = 5000,
                    bResearchLocation = false
                    aZonePos = { X = 0, Y = 0, Z = 0, LOCATION = 0 }
                }
            },
            [3] = {
                sState = "UNAVAIBALE",
                sType = "TALK",
                aTaskData = {
                    nDialogId = 201200,
                    nNPCId = 1
                }
            }
        }--]]
        
    end

    for i=1, #data.completed do
        local nId = data.completed[i].nId
        if not Quests.CachedPlayers[player].completed[nId] then
            Quests.CachedPlayers[player].compelted[nId] = true
        end
    end
end

Quests.addPlayer = function(pPlayer, nQuestId)

end

Quests.getActiveIdById = function(pPlayer, nQuestId)
    local playerData = Quest.CachedPlayers[pPlayer]
    if playerData then 
        for i=1, #playerData.active do
            if playerData.active[i].nId == nQuestId then
                return i
            end
        end
    end
end

Quests.getPlayerData = function(pPlayer)
    local nCharacterId =  pPlayer:getData( 'nCharacterId')
    if not nCharacterId then return end
    local queryString = "SELECT * FROM `characters_quests` WHERE `charid`="..nCharacterId
    Database:exec({'Quests', 'onDatabaseSendData'}, { pPlayer }, queryString)
end

Quests.onDatabaseSendData = function(data, player)
    if player then
        if data.nRows > 0 then
            Quests.cachePlayer(player, data.aResult)
        end
    end
end