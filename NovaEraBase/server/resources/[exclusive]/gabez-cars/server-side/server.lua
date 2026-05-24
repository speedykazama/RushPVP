local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
src = {}
Tunnel.bindInterface("gabez-cars", src)
vCLIENT = Tunnel.getInterface("gabez-cars")
function src.checkPermission()
    local Passport = vRP.Passport(source)
    if cfg.permissaoParaInstalar.existePermissao then
        for k, group in pairs(cfg.permissaoParaInstalar.permissoes) do
                if vRP.HasGroup(Passport, group) then
                    return true
            end
        end
    else
        return true
    end
    return false
end
function src.checkPermissionShop(perm)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport, perm) then
        return true
    else
        return false
    end
end
function src.installXenon(car)
    local source = source
    local Passport = vRP.Passport(source)
    if vRP.TakeItem(Passport, "modulexenon", 1) then
        vRPC.playAnim(source, false,{"mini@repair","fixing_a_ped"}, true)
        TriggerClientEvent("Progress", source, "Instalando módulo de Xenon", 30000)
        SetTimeout(31000, function()
            vRPC.Destroy(source)
            vRPC.stopAnim(source,false)
            src.setXenon(car)
        end)
    else
        TriggerClientEvent("Notify",source,"vermelho","Você não possui um módulo Xenon.", 5000)
    end
end


function src.checkXenon()
    local source = source
    local _, _, Plate, vehName = vRPC.VehicleList(source, 5)

    if Plate and vehName then
        local tuning = vRP.GetSrvData("CMods:" .. vehName .. ":" .. Plate) or "{}"

        if tuning ~= "" and tuning ~= "{}" then
            local custom = type(tuning) == "string" and json.decode(tuning) or {}
            return custom.xenonControl == 1
        end
    end

    return false
end

function src.installNeon(car)
    local source = source
    local Passport = vRP.Passport(source)
    if vRP.TakeItem(Passport,"moduleneon", 1) then
        vRPC.playAnim(source, false,{"mini@repair","fixing_a_ped",1}, true)
        TriggerClientEvent("Progress", source, "Instalando módulo de neon", 30000)
        SetTimeout(31000, function()
            vRPC.Destroy(source)
            vRPC.stopAnim(source, false)
            src.setNeon(car)
        end)
    else
        TriggerClientEvent("Notify",source,"vermelho","Você não possui um módulo de Neon.", 5000)
    end
end

function src.setMod(pVehicle, modType, modValue)
    local source = source
    local _, _, Plate, vehName = vRPC.VehicleList(source, 5)

    if Plate and vehName then
        local custom = {}

        local existingData = vRP.GetSrvData("CMods:" .. vehName .. ":" .. Plate)
        existingData = existingData or "{}"
        custom = type(existingData) == "string" and json.decode(existingData) or {}

        custom[modType] = modValue

        vRP.SetSrvData("CMods:" .. vehName .. ":" .. Plate, json.encode(custom))
    end
end

function src.setNeon(pVehicle)
    src.setMod(pVehicle, "neonControl", 1)
end

function src.setXenon(pVehicle)
    src.setMod(pVehicle, "xenonControl", 1)
end

function src.setSuspensao(pVehicle)
    local source = source
    local Passport = vRP.Passport(source)

    if vRP.TakeItem(Passport, "suspensionair",1) then
        src.setMod(pVehicle, "suspeControl", 1)
        TriggerClientEvent("Notify", source, "verde", "Suspensão a ar instalada no veículo", 5000)
    else
        TriggerClientEvent("Notify", source, "vermelho", "Você não possui um Kit de Suspenção a ar para instalar no Veículo", 5000)
    end
end

function src.checkNeon()
    local source = source
    local _, _, Plate, vehName = vRPC.VehicleList(source, 5)

    if Plate and vehName then
        local tuning = vRP.GetSrvData("CMods:" .. vehName .. ":" .. Plate) or "{}"

        if tuning ~= "" and tuning ~= "{}" then
            local custom = type(tuning) == "string" and json.decode(tuning) or {}
            return custom.neonControl == 1
        end
    end

    return false
end

function src.anim()
    local source = source
    local Passport = vRP.Passport(source)
    vRPC.playAnim(source, false, {"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"}, true)
    TriggerClientEvent("Progress", source, "Instalando Suspenção a Ar", 7000)
    SetTimeout(7000, function()
        vRPC.Destroy(source)
        vRPC.stopAnim(source,false)
        vCLIENT.instalando(source, false)
    end)
end


function src.checkSuspension()
    local source = source
    local _, _, Plate, vehName = vRPC.VehicleList(source, 5)

    if Plate and vehName then
        local tuning = vRP.GetSrvData("CMods:" .. vehName .. ":" .. Plate) or "{}"

        if tuning ~= "" and tuning ~= "{}" then
            local custom = type(tuning) == "string" and json.decode(tuning) or {}
            return custom.suspeControl == 1
        end
    end

    return false
end

function src.setPreset(value)
    local source = source
    local _, _, Plate, vehName = vRPC.VehicleList(source, 5)

    if Plate and vehName then
        local custom = { presetSuspe = value }

        vRP.SetSrvData("PMods:" .. vehName .. ":" .. Plate, json.encode(custom))
    end
end

function src.returnPreset()
    local source = source
    local _, _, Plate, vehName = vRPC.VehicleList(source, 5)

    if Plate and vehName then
        local tuning = vRP.GetSrvData("PMods:" .. vehName .. ":" .. Plate) or "{}"

        if tuning ~= "" and tuning ~= "{}" then
            local custom = type(tuning) == "string" and json.decode(tuning) or {}
            return custom.presetSuspe
        end
    end
end

RegisterNetEvent("tryzosuspe")
AddEventHandler('tryzosuspe', function(vehicle, pAlturaAtual, pAlturaAnterior, variacao, type)
    local altura = pAlturaAnterior
    if type == "subir" then
        while altura > pAlturaAtual do
            altura = altura - variacao
            TriggerClientEvent("synczosuspe", -1, vehicle, altura)
            Citizen.Wait(1)
        end
    elseif type == "descer" then
        while altura < pAlturaAtual do
            altura = altura + variacao
            TriggerClientEvent("synczosuspe", -1, vehicle, altura)
            Citizen.Wait(1)
        end
    end
end)
RegisterServerEvent("departamento-comprar")
AddEventHandler("departamento-comprar", function(Item)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        for k, v in pairs(cfg.valores) do
            if Item == v.Item then
                if vRP.InventoryWeight(Passport) + v.quantidade <= vRP.GetWeight(Passport) then
                    local preco = parseInt(v.compra)
                    if preco then
                        if vRP.PaymentFull(Passport, parseInt(preco)) then
                            TriggerClientEvent("Notify", source, "verde","Comprou <b>" ..parseInt(v.quantidade) .."x " .. itemName(Item), 5000)
                            vRP.GenerateItem(Passport, v.Item, parseInt(v.quantidade),true)
                        else
                            TriggerClientEvent("Notify", source, "vermelho", "Dinheiro insuficiente.", 5000)
                        end
                    end
                else
                    TriggerClientEvent("Notify", source, "vermelho", "Espaço insuficiente.", 5000)
                end
            end
        end
    end
end)