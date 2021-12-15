Auth.Register = {
    onCreateCharacter = function( self, pPlayer, sLogin, sPassword )
        if pPlayer:getData('bLoggedIn') then return end
        local bIsAccountCreated, nRows = Database:exec('SELECT * FROM `characters` WHERE username="'..sLogin..'"')
        
        if nRows == 0 then
            if not isStrongPassword( sLogin, sPassword ) then
                outputDebugString('easy password')
                return
            end

            local sSerial = getPlayerSerial( pPlayer )
            local nUniqueNumbers = calculateStringNumbers( sSerial );
            
            local sUniqueAuthKey = PASSWORDHESHKEY..nUniqueNumbers..sSerial
            local sPasswordHash = teaEncode( sPassword, sUniqueAuthKey )

            local sQueryInsertString = Database:prepareString('INSERT INTO `characters` (`username`, `password` ) VALUES (?,?);', sLogin, sPasswordHash );

            Database:exec( { 'Auth', 'Register', 'onAccountCreated' }, { pPlayer = pPlayer; sLogin = sLogin; }, sQueryInsertString)
        end
    end;

    onAccountCreated = function( self, aArguments, aResult )
        outputDebugString(inspect(aArguments))
        if aResult.nRows == 1 then
            Auth:onCharacterSuccessAuth( aArguments.pPlayer, aArguments.sLogin, aResult.nLastId );
        end
    end;
}