LVillage = nil;

LVillageData = {

    sLocationName = 'Village';
    bSinglePlayer = true; 

    spawn = {
        x = 129.09;
        y = -81.44;
        z = 1.43;
    };

    pMapFile = xmlLoadFile('Locations/Village/village.map');
}
addEventHandler('onResourceStart', resourceRoot, function()
    LVillage = LocationManager:load( LVillageData );
end)

addCommandHandler('kek', function( playerSource )
    LocationManager:loadPlayerToLocation( playerSource, 'Village' )
end)