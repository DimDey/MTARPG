QuestList = {
    list = {};

    ipairs = function( self )
        return ipairs(self.list);
    end;
    pairs = function( self )
        return pairs(self.list)
    end;
};

QuestLoader = {
    --INIT QUESTS ON RESOURCE onResourceStart
    init = function()

        local __QuestMt = {
            __index = function( self, key )
                local get = rawget(self.list, key)
                return get
            end;
        
            __newindex = function( self, key, value )
                local id = key or #self.list+1
                return rawset(self.list, id, value)
            end;
        
            __ipairs = function( self )
                local index = 0;
        
                return function()
                    index = index + 1;
                    return index, rawget(self.list[index])
                end;
            end;
        };

        QuestList = setmetatable(QuestList, __QuestMt)

        local sDatabase = exports.GameController:exportDB()
        if not sDatabase then
            outputDebugString('[JR-AUTH]: Database connection lost.')
            stopResource( getThisResource() )
            return false;
        end
        loadstring(sDatabase)()
        Database:exec({'QuestLoader', 'onQuestsFromDatabase'}, nil, 'SELECT * FROM `quests`')
        
    end;

    onQuestsFromDatabase = function( aData )
        for i, quest in ipairs(aData.aResult) do
            quest.tasks = fromJSON(quest.tasks)
            quest.rewards = fromJSON(quest.rewards)
            QuestList[i] = quest
        end
        Quests.getPlayerData(getRandomPlayer())
    end;
};
addEventHandler('onResourceStart', resourceRoot, QuestLoader.init)