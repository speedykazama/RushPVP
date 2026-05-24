-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("notebook",Creative)
vCLIENT = Tunnel.getInterface("notebook")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckPermission()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        for _, perm in ipairs(PermissionsEnableNotebook) do
            if vRP.HasService(Passport, perm) then
                return true
            end
        end
        TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para usar o Notebook.", 5000)
        return false
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVEREMAP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SaveRemap(Remap, Plate) 
    local source = source
    local Passport = vRP.Passport(source)
    local OwnerPassport = vRP.PassportPlate(Plate)

    if not OwnerPassport or not OwnerPassport.Passport then
        TriggerClientEvent("Notify", source, "vermelho", "Veículo não encontrado ou sem proprietário.", 5000)
        return
    end

    if PassaportPlateNotebook and OwnerPassport.Passport ~= Passport then
        TriggerClientEvent("Notify", source, "vermelho", "Você não é o dono deste veículo.", 5000)
        return
    end

    local Tables = json.encode(Remap)
    if Tables ~= "[]" then
        vRP.Query("entitydata/SetData", { dkey = "Remap:"..Plate, dvalue = Tables })
        TriggerClientEvent("Notify", source, "verde", "O <b>Remap</b> foi aplicado.", 5000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADREMAP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.LoadRemap(Plate)
    local Query = vRP.Query("entitydata/GetData", { dkey = "Remap:"..Plate })
    if Query and #Query > 0 and Query[1].dvalue then
        return json.decode(Query[1].dvalue)
    end
    return nil
end