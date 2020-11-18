Database = {
    sType        = 'mysql',
    sIp          = '127.0.0.1',
    sUser        = 'root',
    sPassword    = '',
    sBase        =  'myrpg';

    pDatabase = false;
    bConnected = false;

    init = function( self )
        local pConnection = dbConnect( self.sType, "dbname="..self.sBase..";host="..self.sIp..";", self.sUser, self.sPassword )
        if not pConnection then
            outputDebugString("Error: Failed to establish connection to the MySQL database server")
            --stopResource( getThisResource() );
        else
            outputDebugString("Success: Connected to the MySQL database server")
            self.pDatabase = pConnection;
            self.bConnected = true;
        end
        return pConnection
    end;

    exec = function( self, ... )
        local queryHandle = dbQuery( self.pDatabase, ... )
        local aResult = dbPoll(queryHandle, -1)
        return aResult;
    end;
}