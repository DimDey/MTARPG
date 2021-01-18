Notifications = {

    aList = {};

    aDefaultData = {
        sType = 'НОВОЕ УВЕДОМЛЕНИЕ';
        sSubText = '';
        nFadeIn = 2000;
        nFadeOut = 2000;
        nAlpha = 0;
        
    };

    add = function( self, aNotification )
        if not aNotification.sText or not type(aNotification) == 'table' then
            return
        end;

        outputDebugString('Notifications: new notification!');

        for index, defaultValue in pairs( self.aDefaultData ) do
            if aNotification[index] == nil then
                aNotification[index] = defaultValue;
            end
        end;

        table.insert( Notifications.aList, aNotification )

        if #Notifications.aList == 1 then
            NotificationsController:onChangeActive( aNotification )
        end
        
        return;
    end;

    getActive = function( self )
        return self.aList[1];
    end;

    remove = function( self )
        table.remove(Notifications.aList, 1)
        outputDebugString('Notifications: delete notification');
        NotificationsController:onChangeActive( Notifications.aList[1] )
    end;
}

Notifications:add{
    sText = 'Это демо-версия ММОРПГ';
};

Notifications:add{
    sType = 'НОВОЕ ДОСТИЖЕНИЕ';
    sText = 'Ещё одно тестовое уведомление';
    sSubText = 'Теперь даже с сабтекстом!'
};