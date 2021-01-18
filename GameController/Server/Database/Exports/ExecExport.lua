Database.execController = function( sResourceName, fCallbackFunction, aCallbackArgs,  sQuery )   
    local aResult, nResultRows, nLastId = Database:exec( sQuery );
    local aReturnData = {
        aQuery = { sQuery };
        aData = {
            aResult = aResult, 
            nRows = nResultRows, 
            nLastId = nLastId
        };
        fFunction = fCallbackFunction;
        aFunctionArgs = aCallbackArgs;
    }
    triggerEvent('onDatabasePoll', source, aReturnData )
    return true;
end;
addEvent('callExec')
addEventHandler('callExec', root, Database.execController)

Database.requestConnection = function( )
    local pConnection = Database.pDatabase
    if pConnection then
        outputDebugString('request')
        triggerEvent('onDatabaseConnection', source, pConnection)
    end
end;
addEvent('onResourceRequestConnection')
addEventHandler('onResourceRequestConnection', root, Database.requestConnection)

function exportDB() --export database controller to the other resource
    if not Database.bConnected then return false end
    return [[
        Database = {
            pConnection = false;
            exec = function( self, aCallbackFunction, aCallbackArgs, sQuery )
                if not _G[aCallbackFunction] and type(aCallbackFunction) == 'string' then
                    if not self.pConnection then return end

                    sQuery = aCallbackFunction
                    local queryHandle = dbQuery( self.pConnection, sQuery )
                    local aResult, nResultRows, nLastId = dbPoll(queryHandle, -1)

                    return aResult, nResultRows, nLastId;
                end

                if not sQuery and type(aCallbackArgs) == 'string' then
                    sQuery = aCallbackArgs;
                    aCallbackArgs = {}
                end
                triggerEvent('callExec', getResourceRootElement(), getResourceName( getThisResource() ), aCallbackFunction, aCallbackArgs, sQuery );
                
            end;
            poll = function( aReturnData )
                if type(_G[aReturnData.fFunction]) == 'function' then
                    return _G[aReturnData.fFunction]( aReturnData.aFunctionArgs, aReturnData.aResult );
                else
                    local fFunction = Database:getFunction( aReturnData.fFunction );
                    return fFunction( aReturnData.aFunctionArgs, aReturnData.aData );
                end
            end;

            prepareString = function( self, sQuery, ... )
                if not self.pConnection then return end
                local sPrepareString = dbPrepareString( self.pConnection, sQuery, ... )
                return sPrepareString
            end;

            getFunction = function( self, aData, prevTree, nIndex )
                nIndex = nIndex or 2
                prevTree = prevTree or _G[ aData[1] ]
                local nextElement = prevTree[ aData[nIndex] ]

                if type(nextElement) == 'function' then
                    return nextElement
                elseif not nextElement then
                    return outputDebugString('Not found next elementtable!', 1)
                else
                    return self:getFunction( aData, nextElement, nIndex + 1 )
                end
            end;

            onDatabaseConnection = function( pConnection )
                Database.pConnection = pConnection;
                return
            end;

        }
        addEvent('onDatabasePoll')
        addEventHandler('onDatabasePoll', getResourceRootElement(), Database.poll)
        addEvent('onDatabaseConnection')
        addEventHandler('onDatabaseConnection', resourceRoot, Database.onDatabaseConnection)

        triggerEvent('onResourceRequestConnection', resourceRoot )
    ]]
end;
