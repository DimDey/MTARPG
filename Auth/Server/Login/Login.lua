Auth.Login = {
    onCharacterAuth = function( self, pPlayer, sLogin, sPassword )
        local aResult, nRows, nLastId = Database:exec('SELECT * FROM `characters` WHERE username="'..sLogin..'"')
        if nRows == 1 then
            local aAccountData = aResult[1]
            
            local sSerial = getPlayerSerial( pPlayer )
            local nUniqueNumbers = calculateStringNumbers( sSerial );
            
            local sUniqueAuthKey = PASSWORDHESHKEY..nUniqueNumbers..sSerial
            local sPasswordHash = teaEncode( sPassword, sUniqueAuthKey )

            if sPasswordHash == aAccountData.password then
                Auth:onCharacterSuccessAuth( pPlayer, sLogin, aAccountData.id );
            end
        end 
    end;
}