-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSERIAL
-----------------------------------------------------------------------------------------------------------------------------------------   
function vRP.SetSerial(Passport)
    local Identity = vRP.Identity(Passport)
    if Identity and Identity["serial"] == nil then
        local newSerial = vRP.GenerateSerial()
        vRP.Query("characters/setSerial", { Passport = Passport, serial = newSerial })
        Identity["serial"] = newSerial
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERSERIAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserSerial(serialNumber)
    return vRP.Query("characters/getSerial",{ serial = serialNumber })[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESERIAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateSerial()
    local Passport = nil
    local SerialWeapon = ""
    repeat
        Passport = vRP.UserSerial((vRP.GenerateString("LLLDDD")))
        SerialWeapon = vRP.GenerateString("LLLDDD")
    until not Passport
    return SerialWeapon
end