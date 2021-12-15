QuestRender = {
    quests = {};
    iterY = 10;

    onRender = function()
        self = QuestRender
        local nowX = 600;
        local nowY = 600;
        for index, quest in ipairs(QuestRender.quests) do
            nowX = nowX + self.iterY

            dxDrawText(quest.questData.name, nowX, nowY)
        end
    end;

    onServerQuestList = function( quests ) 
        for index, quest in ipairs(quests) do
            table.insert(QuestRender.quests, quest)
        end
    end;
}
addEvent('onServerQuestList', true)
addEventHandler('onServerQuestList', root, QuestRender.onServerQuestList)
addEventHandler('onClientRender', root, QuestRender.onRender)