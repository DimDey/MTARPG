Database = {
    sType        = 'mysql',
    sIp          = '127.0.0.1',
    sUser        = 'root',
    sPassword    = '',
    sBase        =  'myrpg';

    pDatabase = false;
    bConnected = false;
    aNeedTables = { "characters" };

    init = function( self )
        local pConnection = dbConnect( self.sType, "dbname="..self.sBase..";host="..self.sIp..";charset=utf8", self.sUser, self.sPassword )
        if not pConnection then
            outputDebugString("Error: Failed to establish connection to the MySQL database server")
            stopResource( getThisResource() );
        else
            outputDebugString("Success: Connected to the MySQL database server")
            self.pDatabase = pConnection;
            self.bConnected = true;
            self:checkMigrations();
        end
        return pConnection
    end;

    exec = function( self, ... )
        local queryHandle = dbQuery( self.pDatabase, ... )
        return dbPoll(queryHandle, -1);
    end;

    checkMigrations = function( self, ...)
        local needMigration = false
        for index, tableName in ipairs(self.aNeedTables) do
            local result = self:exec('SHOW TABLES LIKE "'..tableName..'";')
            if #result == 0 then
                needMigration = true
                break;
            end
        end
        if not needMigration then return false end

        self:exec([[
            CREATE TABLE `characters` ( 
            `id` INT NOT NULL AUTO_INCREMENT , 
            `username` TEXT NOT NULL , 
            `password` INT NOT NULL , 
            `admin` BOOLEAN NOT NULL DEFAULT FALSE , 
            PRIMARY KEY (`id`)) 
            ENGINE = InnoDB;
        ]])
    end;
}