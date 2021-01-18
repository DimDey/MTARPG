local gamemodeResources = {
    'Auth';
    'Character';
    'Camera';
    'LocationManager';
    'Notifications';
    'HUD';
    'NPC';
}

Main = {
    onInit = function()
        outputDebugString("[JR-GMC] Starting database...")
        Database:init();
        
        for index, resourceName in pairs(gamemodeResources) do
            if ( resourceName ) then
                local resource = getResourceFromName ( resourceName )
                
                local start = startResource ( resource )
                if ( start ) then
                    outputDebugString ( resourceName .. " was started successfully.")
                else
                    outputDebugString ( "This resource doesn't exist." )
                end
            end
        end
    end;
}
addEventHandler("onResourceStart", resourceRoot, Main.onInit)