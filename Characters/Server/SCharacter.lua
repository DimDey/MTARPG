Character = {
    isCharacter = true;
    addExp = function( self, nCount )
        local nExp = self.exp or 5
        self.exp = nExp + nCount;
        self:checkNeedExp();
        return true;
    end;

    setExp = function( self, nExperience )
        self.exp = nExperience;
        self:checkNeedExp();
        return true;
    end;

    checkNeedExp = function( self )
        local nLevel = self.nLevel or 1
        local nMaxExp = nLevel * 2 * 10
        if self.exp > nMaxExp then
            self.level = self.level + 1;
            self.exp = self.exp - nMaxExp;
        end
        return true;
    end;

    __index = function( self, index )
        return rawget( Character, index )
    end;
    

    __newindex = function( self, index, value )
        rawset( self, index, value )
        Database:exec('UPDATE `characters` SET `'..index..'` = '..value..' WHERE `characters`.`id` = 1')
    end;
    
}