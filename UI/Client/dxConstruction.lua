dxConstruction = dxGUI.baseClass:subclass{ 
    type = 'construction';

    create = function( self )
        if self.plane then
			outputDebugString( 'dxConstruction:create: construction is init', 2 )
			return false
		end
        self.plane = {}
        
        if not self.objects then
			self.objects = {}
		end

		local objects = {}
		for guiID, data in pairs( self.objects ) do
			if data.p then
                objects[ data.p ] = guiID
            else
                table.insert( objects, guiID )
			end
        end
        
        for plane = 1, #objects do
			local guiID = objects[plane]
			local object = self:initObject( self.objects[guiID], guiID )
			if object then
				self:addObject( object )
			end
		end
    end;

    initObject = function( self, data, guiID )
        
    end;
}