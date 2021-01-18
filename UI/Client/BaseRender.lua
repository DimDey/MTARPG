aElements = {};

dxGUI = {
    __gc = function( self )
        outputDebugString('destroy table')
        if self.tableId then
            aElements[self.tableId] = nil
        end
    end;

    subclass = function( self, newClass )
        newClass.__index = newClass
        setmetatable( newClass, self )
        if newClass.type then
            dxGUI[ newClass.type ] = newClass
        end
        return newClass
    end;

    init = function( self )
        if self.tableId then
            outputDebugString('Element already initialized!')
            return false;
        end
        local nId = #aElements + 1;
        self.tableId = nId
        table.insert( aElements, nId, self )
        return self;
    end;
}

dxGUIRender = function()
    for index, element in pairs(aElements) do
        if element.draw then
            element:draw();
        end
    end
end;