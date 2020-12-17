sX, sY = guiGetScreenSize()
rX, rY = 1440, 900;
aX, aY = sX / 1440, sY / 900;

GUI = {
    aComponents = {
        ['Health'] = CHealth;
    };

    showComponents = function( self, state )
        for index, component in pairs( self.aComponents ) do
            if component.show then
                component:show( state )
            end
        end
    end;

    onClientAuth = function( )
        self = GUI;
        self:showComponents( true )
        addEventHandler('onClientRender', root, GUI.onClientRender )
    end;

    onClientRender = function( )
        for index, component in pairs( self.aComponents ) do
            if component.onRender then
                component:onRender( );
            end
        end
    end;
}
addEventHandler('onClientLogged', root, GUI.onClientAuth)