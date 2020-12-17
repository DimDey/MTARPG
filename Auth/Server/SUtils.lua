function calculateStringNumbers( sString )
    local nResult = 0;
    for i=1, string.len( sString ) do
        local char = tonumber( string.sub( sString, i, i ) )
        if type(char) == 'number' then
            nResult = nResult + char;
        end
    end
    return nResult;
end;

local aBlockedWords = {
    'qwerty', 'password', '123456', 'ytrewq';
}
local nMinPasswordTypes = 3;
function isStrongPassword( sUsername, sPassword )
    local sLowerPassword = string.lower(sPassword)
    if sLowerPassword == string.lower(sUsername) then
        return false
    end

    for _, sPassword in pairs(aBlockedWords) do
        if sLowerPassword == sPassword then
            return false
        end
    end

    local nHasDigit = 0
    local nhasCaps = 0
    local nhasLower = 0
    local nhasSpecial = 0

    if string.find(sPassword, "%d") then
        nHasDigit = 1
    end
    if string.find(sPassword, "[A-Z]") then
        nhasCaps = 1
    end
    if string.find(sPassword, "[a-z]") then
        nhasLower = 1
    end
    if string.find(sPassword, "[^a-zA-Z0-9]") then
        nhasSpecial = 1
    end
    local nDifferentTypes = nHasDigit + nhasCaps + nhasLower + nhasSpecial
    
    if nDifferentTypes >= nMinPasswordTypes then
        return true
    else
        return false
    end

end;