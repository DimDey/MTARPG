Database.execController = function( resourceName, ... )
    local sTimestamp = getTimestamp()
    local pLogFile = fileOpen('Server/Database/resourcesExec.log')

    if pLogFile then
        fileSetPos( pLogFile, fileGetSize( pLogFile ) )
        fileWrite( pLogFile, '['..sTimestamp..']: '..resourceName..' request exec('..inspect(...)..')\n' )
        fileFlush( pLogFile )
        fileClose( pLogFile )
    end
    local aResult = Database:exec( ... );
    local aReturnData = {
        aQuery = { ... };
        aResult = aResult;
    }
    triggerEvent('onDatabasePoll', source, aReturnData )
    return true;
end;
addEvent('callExec')
addEventHandler('callExec', root, Database.execController)

function exportDB() --export database controller to the other resource
    if not Database.bConnected then return false end
    return [[
        Database = {
            connected = true;
            exec = function( self, ... )
                triggerEvent('callExec', getResourceRootElement(), getResourceName( getThisResource() ), ... );
            end;
        }
        addEvent('onDatabasePoll')
    ]]
end;
