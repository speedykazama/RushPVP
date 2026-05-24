-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("Night_AdminV2",Creative)
vCLIENT = Tunnel.getInterface("Night_AdminV2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("night_adminv2/jesterInstagram", "SELECT * FROM smartphone_instagram WHERE user_id = @user_id")
vRP.Prepare("night_adminv2/infosTeleports", "SELECT * FROM night_teleportes WHERE user_id = @user_id") 
vRP.Prepare("night_adminv2/insertTeleports", "INSERT INTO night_teleportes(user_id,id,nome,coords) VALUES(@user_id,@id,@nome,@coords)") 
vRP.Prepare("night_adminv2/deleteTeleport","DELETE FROM night_teleportes WHERE id = @id")
vRP.Prepare("night_adminv2/infosPunicoes", "SELECT * FROM night_punicoes")
vRP.Prepare("banneds/SelectAllBanned", "SELECT * FROM banneds")
vRP.Prepare("user/getIdentityByLicense", "SELECT id, name, name2 FROM characters WHERE license = @license LIMIT 1")
vRP.Prepare("night_adminv2/selectPunicao", "SELECT * FROM night_punicoes WHERE user_id = @user_id")
vRP.Prepare("night_adminv2/insertPunicao", "INSERT INTO night_punicoes (user_id, staffid, motivo, status, contagem, data, tempo_restante) VALUES (@user_id, @staffid, @motivo, @status, @contagem, @data, @tempo_restante)")
vRP.Prepare("night_adminv2/selectActiveWarnings", "SELECT * FROM night_punicoes WHERE tempo_restante > 0 AND status = 'ADVERTÊNCIA'")
vRP.Prepare("night_adminv2/updateWarningTime", "UPDATE night_punicoes SET tempo_restante = @tempo_restante WHERE user_id = @user_id AND status = @status AND contagem = @contagem")
vRP.Prepare("night_adminv2/deletePunicao", "DELETE FROM night_punicoes WHERE user_id = @user_id AND status = @status AND contagem = @contagem")
vRP.Prepare("characters/getBank", "SELECT bank FROM characters WHERE id = @user_id LIMIT 1")
vRP.Prepare("night_adminv2/AllUsers","SELECT id FROM characters ORDER BY id ASC")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DB
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    vRP.Prepare("night_adminv2/night_teleportes", [[
        CREATE TABLE IF NOT EXISTS night_teleportes(
            user_id INTEGER,
            id longtext,
            nome longtext,
            coords longtext
        )
    ]])
    
    vRP.Prepare("night_adminv2/night_punicoes", [[
        CREATE TABLE IF NOT EXISTS night_punicoes(
            user_id INTEGER,
            staffid LONGTEXT,
            motivo LONGTEXT,
            status LONGTEXT,
            contagem LONGTEXT,
            data LONGTEXT,
            tempo_restante INTEGER
        )
    ]])

    vRP.Query("night_adminv2/night_teleportes")
    vRP.Query("night_adminv2/night_punicoes")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local PainelLogs = {}
local FreezePlayer = {}
local Spectate = {}
ScreenShotInstances = {}
local anunciosLogs = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckPermission()
    local Source = source
    local Passport = vRP.Passport(Source)

    
    local PermissaoAdmin = vRP.HasPermission(Passport, Config["Perms"]["OpenPainel"][1], Config["Perms"]["OpenPainel"][2])

   
    if PermissaoAdmin then
        
   
        if Player(Source).state.StaffTime then
            return true 
        else
            
            TriggerClientEvent("Notify", Source, "vermelho", "Precisas de entrar em modo <b>/staff</b> para abrir o painel!", 5000)
            return false
        end
    end

    return false
end

function Creative.ReturnNames()
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    if Passport then
        local Infos = vRP.Query("night_adminv2/jesterInstagram", {user_id = Passport})
        if Infos[1] then
            return Identity["name"],Identity["name2"],Infos[1]["avatarURL"]
        else
            return Identity["name"],Identity["name2"],"./images/profile.png"
        end
    end
end

function Creative.ReturnServices()
    local Source = source
    local Passport = vRP.Passport(Source)

    local Players = 0
    local Police = 0
    local Ilegal = 0
    local Staff = 0

    Players = GetNumPlayerIndices()
    _,Police = vRP.NumPermission(Config["Perms"]["Policia"])
    _,Staff = vRP.NumPermission(Config["Perms"]["Staff"])

    for index,PermissionName in pairs(Config["Perms"]["Bandits"]) do
        local IService, Iamount = vRP.NumPermission(PermissionName)
        Ilegal = Ilegal + Iamount
    end

    return Players,Police,Ilegal,Staff
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ConsultCoordsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    teleportTables = {}

    if Passport then
        local SelectQuery = vRP.Query("night_adminv2/infosTeleports", {user_id = Passport})
        if SelectQuery[1] then
            for k,v in pairs(SelectQuery) do
                table.insert(teleportTables,{id = v["id"],nome = v["nome"], coord = json.decode(v["coords"]) })
            end
        end
    end

    return teleportTables
end

function Creative.AddTeleport(ReturnName)
    local Source = source
    local Passport = vRP.Passport(Source)
    if Passport then
        if vRP.HasPermission(Passport,Config["Perms"]["AddTeleport"][1],Config["Perms"]["AddTeleport"][2]) then
            if ReturnName ~= "" then 
                local PlayerPed = GetPlayerPed(Source)
                local CoordsPlayer = GetEntityCoords(PlayerPed)
                local RandomIdentification = math.random(1,99999)

                local Identity = vRP.Identity(Passport)
                if Identity then
                    table.insert(PainelLogs,{ user_id = Passport, cor = "azul",nome = Identity["name"].." "..Identity["name2"],motivo = "Adicionou um novo teleport, nome do teleport: "..ReturnName.."." })
                end

                vRP.Query("night_adminv2/insertTeleports", { user_id = Passport, id = RandomIdentification, nome = ReturnName, coords = json.encode(CoordsPlayer)})
                return true
            else
                TriggerClientEvent("Notify",Source,"vermelho","Você precisa inserir um Nome.",10000)
            end
        else
            TriggerClientEvent("Notify",Source,"vermelho","Você não tem Permissão.",10000)
        end
    end
end

function Creative.DeleteTeleport(ReturnIdentification,ReturnName)
    local Source = source
    local Passport = vRP.Passport(Source)

    if Passport and vRP.HasPermission(Passport,Config["Perms"]["AddTeleport"][1],Config["Perms"]["AddTeleport"][2]) then
        local Identity = vRP.Identity(Passport)
        if Identity then
            table.insert(PainelLogs,{ user_id = Passport, cor = "vermelho",nome = Identity["name"].." "..Identity["name2"],motivo = "Deletou um teleport, nome do teleport: "..ReturnName.."." })
        end

        vRP.Query("night_adminv2/deleteTeleport", { id = ReturnIdentification })
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnLogsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local ReturnLogsList = {}

    if Passport then
        for k,v in ipairs(PainelLogs) do
            local ColorLog = "#ff0000"
            if v["cor"] == "vermelho" then
                ColorLog = "#ff0000"
            elseif v["cor"] == "azul" then
                ColorLog = "#00a2ff"
            elseif v["cor"] == "amarelo" then
                ColorLog = "#ffc400"
            end

            table.insert(ReturnLogsList,{ cor = ColorLog,img = "./images/warning.png",nome = v["nome"],user_id = v["user_id"],motivo = v["motivo"] })
        end
    end

    return ReturnLogsList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnPlayerList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local ControleTables = {}

    local AllUsers = vRP.Query("night_adminv2/AllUsers")
    local OnlinePlayers = vRP.Players()

    for _, user in pairs(AllUsers) do
        local SelectedPassport = user.id
        local Identity = vRP.Identity(SelectedPassport)
        local Infos = vRP.Query("night_adminv2/jesterInstagram", {user_id = SelectedPassport})
        local Status = OnlinePlayers[SelectedPassport] and "ONLINE" or "OFFLINE"

        local foto = Infos[1] and Infos[1]["avatarURL"] or "./images/profile.png"

        table.insert(ControleTables, {
            user_id = SelectedPassport,
            nome = Identity["name"].." "..Identity["name2"],
            foto = foto,
            status = Status
        })
    end

    return ControleTables
end

function Creative.SeeInformationsProfile(SelectedPassport)
    local SelectedPassport = tonumber(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)
    if not Identity then return nil end

    local WalletMoney = 0
    if vRP.Source(SelectedPassport) then
        WalletMoney = vRP.ItemAmount(SelectedPassport, "dollars")
    else
        WalletMoney = vRP.ItemAmountOffline(SelectedPassport, "dollars") 
    end

    local BankMoney = 0
    local BankResult = vRP.Query("characters/getBank", { user_id = SelectedPassport })
    if BankResult[1] and BankResult[1].bank then
        BankMoney = tonumber(BankResult[1].bank)
    end

    local SelectedWork = vRP.GetUserType(SelectedPassport, "Work") or "Desempregado"
    local License = Identity.license
    local Vips = {}
    if vRP.LicensePremium(License) then table.insert(Vips, "VIP Platina") end
    if vRP.LicensePremiumPrata(License) then table.insert(Vips, "VIP Prata") end
    if vRP.LicensePremiumOuro(License) then table.insert(Vips, "VIP Ouro") end
    local VipStatus = (#Vips > 0) and table.concat(Vips, ", ") or false
    local VipCoins = vRP.UserGemstone(License) or 0

    local Infos = vRP.Query("night_adminv2/jesterInstagram", {user_id = SelectedPassport})
    local Img = (Infos[1] and Infos[1]["avatarURL"]) or "./images/profile.png"
    local BannerImage = "./images/banner.gif"

    return parseFormat(WalletMoney), parseFormat(BankMoney), Identity.name, Identity.name2, Identity.serial, Identity.phone, Sanguine(Identity.blood), SelectedWork, VipStatus, parseFormat(VipCoins), Img, BannerImage
end

function Creative.GetNameByPassport(passaporte)
	local Identity = vRP.Identity(passaporte)
	if Identity then
		return Identity.name, Identity.name2
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUNIÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SeeInformationsWarnings()
    local Source = source
    local Passport = vRP.Passport(Source)
    local PunicoesList = {}

    if Passport then
        local Punicoes = vRP.Query("night_adminv2/infosPunicoes", {})
        if Punicoes then
            for _, v in pairs(Punicoes) do
                local SelectedPassport = tonumber(v["user_id"])
                local StaffPassport = tonumber(v["staffid"])
                local Identity = vRP.Identity(SelectedPassport)
                local Identity2 = vRP.Identity(StaffPassport)
                local Identity3 = vRP.Identity(Passport)

                local ImageUrl = "./images/profile.png"
                local Infos = vRP.Query("night_adminv2/jesterInstagram", {user_id = SelectedPassport})
                if Infos[1] then ImageUrl = Infos[1]["avatarURL"] end

                local SelectedColor = "#fff"
                local SelectedBackground = "#fff"
                if string.find(v["status"], "ADVERTÊNCIA") then 
                    SelectedBackground = "rgb(255, 102, 0)"
                    SelectedColor = "#fff"
                end
                if string.find(v["status"], "BANIDO") then 
                    SelectedBackground = "rgb(255, 0, 0)"
                    SelectedColor = "#fff"
                end

                if Identity and Identity2 then
                    table.insert(PunicoesList, {
                        user_id = SelectedPassport,
                        myname = Identity3["name"] .. " " .. Identity3["name2"],
                        nome = Identity["name"] .. " " .. Identity["name2"],
                        status = v["status"],
                        contagem = v["contagem"],
                        color = SelectedColor,
                        background = SelectedBackground,
                        motivo = v["motivo"],
                        staff = Identity2["name"] .. " " .. Identity2["name2"] .. " [" .. StaffPassport .. "]",
                        foto = ImageUrl,
                        data = v["data"],
                        duracao = tostring(v["contagem"]) .. " dia(s)"
                    })
                end
            end
        end

        local Banimentos = vRP.Query("banneds/SelectAllBanned", {})
        if Banimentos then
            for _, ban in pairs(Banimentos) do
                local identityQuery = vRP.Query("user/getIdentityByLicense", { license = ban["license"] })
                if identityQuery and identityQuery[1] then
                    local IdentityAffected = identityQuery[1]
                    local Identity3 = vRP.Identity(Passport)

                    table.insert(PunicoesList, {
                        user_id = tonumber(IdentityAffected.id),
                        myname = Identity3["name"] .. " " .. Identity3["name2"],
                        nome = IdentityAffected.name .. " " .. IdentityAffected.name2,
                        status = "BANIDO",
                        contagem = tostring(math.floor(ban["time"])) .. " dias",
                        color = "#fff",
                        background = "rgb(255, 0, 0)",
                        motivo = "Banimento ativo",
                        staff = "Sistema",
                        foto = "./images/profile.png",
                        data = os.date("%d/%m/%Y"),
                        duracao = tostring(math.floor(ban["time"])) .. " dias"
                    })
                end
            end
        end
    end

    return PunicoesList
end

function Creative.DeleteAdv(SelectedPassport, SelectedStatus, SelectedContagem)
    local Source = source
    local Passport = vRP.Passport(Source)

    if Passport then
        if vRP.HasPermission(Passport,Config["Perms"]["AddAdv"][1],Config["Perms"]["AddAdv"][2]) then
            vRP.Query("night_adminv2/deletePunicao", {user_id = SelectedPassport, status = SelectedStatus, contagem = SelectedContagem})

            local Identity = vRP.Identity(SelectedPassport)
            local Punicoes = vRP.Query("night_adminv2/selectPunicao", {user_id = SelectedPassport})
            if #Punicoes <= 0 and Identity then
                vRP.Query("banneds/RemoveBanned",{ license = Identity["license"] })
            end
            if SelectedStatus == "BANIDO" then
                vRP.Query("banneds/RemoveBanned",{ license = Identity["license"] })
            end

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, { user_id = Passport, cor = "vermelho", nome = IdentityLog["name"].." "..IdentityLog["name2"], motivo = "Deletou uma advertência, no id ["..SelectedPassport.."] com status ["..SelectedStatus.." "..SelectedContagem.."]." })
            end

            return true
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem Permissao.", 10000)
        end
    end

    return false
end

function Creative.AddKick(SelectedMotivo, SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["AddKick"][1], Config["Perms"]["AddKick"][2]) then
            local SelectedSource = vRP.Source(SelectedPassport)
            if SelectedSource then
                local IdentityLog = vRP.Identity(Passport)
                local IdentityAffected = vRP.Identity(SelectedPassport)
                if IdentityLog and IdentityAffected then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "amarelo",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Aplicou um kick no id ["..SelectedPassport.."]."
                    })

                    PerformHttpRequest(Config["Webhooks"]["Kick"], function() end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Aplicou um kick**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "👤 No passaporte:", 
                                        value = IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "📌 Motivo:", 
                                        value = SelectedMotivo or "Não informado",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                vRP.Kick(SelectedSource, SelectedMotivo)
                return true
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem Permissão.", 10000)
        end
    end

    return false
end

function Creative.AddBan(SelectedMotivo, SelectedPassport, Days)
    local Source = source
    local Passport = vRP.Passport(Source)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["AddBan"][1], Config["Perms"]["AddBan"][2]) then
            local Identity = vRP.Identity(SelectedPassport)
            if Identity then
                vRP.Query("banneds/InsertBanned", { license = Identity["license"], time = Days })

                TriggerClientEvent("Notify", Source, "verde", "Você baniu o player por " .. Days .. " dia(s) com sucesso!", 10000)

                local SelectedSource = vRP.Source(SelectedPassport)
                if SelectedSource then
                    vRP.Kick(SelectedSource, "Você foi banido por " .. Days .. " dia(s)! Motivo: " .. SelectedMotivo)
                end

                local IdentityLog = vRP.Identity(Passport)
                local IdentityAffected = vRP.Identity(SelectedPassport)
                if IdentityLog and IdentityAffected then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog["name"] .. " " .. IdentityLog["name2"],
                        motivo = "Aplicou um ban no id [" .. SelectedPassport .. "] motivo [" .. SelectedMotivo .. "] por " .. Days .. " dias"
                    })

                    PerformHttpRequest(Config["Webhooks"]["Ban"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {
                                title = "**Aplicou um ban, motivo: " .. SelectedMotivo .. "**",
                                fields = {
                                    {
                                        name = "📝 Autor:",
                                        value = IdentityLog["name"] .. " " .. IdentityLog["name2"] .. " **#" .. Passport .. "**",
                                    },
                                    {
                                        name = "📝 No passporte:",
                                        value = IdentityAffected["name"] .. " " .. IdentityAffected["name2"] .. " **#" .. SelectedPassport .. "**",
                                    },
                                    {
                                        name = "⏳ Duração:",
                                        value = Days .. " dia(s)",
                                    },
                                },
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            else
                TriggerClientEvent("Notify", Source, "vermelho", "Jogador não encontrado.", 10000)
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem Permissão.", 10000)
        end
    end
    return false
end

function Creative.AddWarning(SelectedMotivo, SelectedPassport, TempoDias)
    local Source = source
    local Passport = vRP.Passport(Source)
    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["AddAdv"][1], Config["Perms"]["AddAdv"][2]) then
            local Identity = vRP.Identity(SelectedPassport)
            if Identity then
                local Punicoes = vRP.Query("night_adminv2/selectPunicao", {user_id = SelectedPassport})
                local totalAdv = #Punicoes
                local maxAdv = Config.NumeroDeAdvParaBan
                local tempoBanSegundos = (Config.TempoDeBanMotivoAdv or 7) * 24 * 60 * 60
                local tempoAdvSegundos = (TempoDias and tonumber(TempoDias) or 7) * 24 * 60 * 60
                local dataAtual = os.date("%d/%m/%Y")

                if totalAdv >= (maxAdv - 1) then
                    vRP.Query("night_adminv2/insertPunicao", {
                        user_id = SelectedPassport,
                        staffid = Passport,
                        motivo = SelectedMotivo,
                        status = "ADVERTÊNCIA",
                        contagem = tostring(maxAdv),
                        data = dataAtual,
                        tempo_restante = tempoAdvSegundos
                    })

                    vRP.Query("night_adminv2/insertPunicao", {
                        user_id = SelectedPassport,
                        staffid = Passport,
                        motivo = "Banido por excesso de advertências",
                        status = "BANIDO",
                        contagem = "PERMANENTE",
                        data = dataAtual,
                        tempo_restante = nil
                    })

                    vRP.Query("banneds/InsertBanned", { license = Identity["license"], time = tempoBanSegundos })
                    TriggerClientEvent("Notify", Source, "verde", "Você baniu o player com sucesso!", 10000)

                    local SelectedSource = vRP.Source(SelectedPassport)
                    if SelectedSource then
                        vRP.Kick(SelectedSource, "Você foi banido! Motivo: Banido por excesso de advertências")
                    end
                else
                    vRP.Query("night_adminv2/insertPunicao", {
                        user_id = SelectedPassport,
                        staffid = Passport,
                        motivo = SelectedMotivo,
                        status = "ADVERTÊNCIA",
                        contagem = tostring(totalAdv + 1),
                        data = dataAtual,
                        tempo_restante = tempoAdvSegundos
                    })
                    TriggerClientEvent("Notify", Source, "verde", "Você adverteu o player com sucesso!", 10000)
                end

                return true
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão.", 10000)
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60 * 1000)

        local advs = vRP.Query("night_adminv2/selectActiveWarnings", {})

        for _, adv in pairs(advs) do
            local newTempo = tonumber(adv.tempo_restante) - 60

            if newTempo <= 0 then
                vRP.Query("night_adminv2/deletePunicao", {
                    user_id = adv.user_id,
                    status = adv.status,
                    contagem = adv.contagem
                })
            else
                vRP.Query("night_adminv2/updateWarningTime", {
                    user_id = adv.user_id,
                    status = adv.status,
                    contagem = adv.contagem,
                    tempo_restante = newTempo
                })
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SeeInformationsItemList()
	local Source = source
	local Passport = vRP.Passport(Source)
    local ItemList = {}

	if Passport then
        for Item,ItemTable in pairs(ItemListGlobal()) do
            table.insert(ItemList,{
                item = Item,
                name = ItemTable["Name"],
                index = itemIndex(Item),
                linkinventario = Config["ImagensInventario"]
            })
        end
	end

    return ItemList
end

function Creative.CatchItem(idjogador, ItemAmount, ItemCatch)
    local Source = source
    local ExecutorPassport = vRP.Passport(Source)
    local ExecutorIdentity = vRP.Identity(ExecutorPassport)
    local TargetPassport = tonumber(idjogador)
    local TargetIdentity = vRP.Identity(TargetPassport)
    local TargetSource = vRP.Source(TargetPassport)

    if not TargetSource then
        TriggerClientEvent("Notify", Source, "vermelho", "Jogador Offline.", 10000)
        return false
    end

    if not TargetPassport then
        TriggerClientEvent("Notify", Source, "vermelho", "ID do jogador inválido.", 10000)
        return false
    end

    if vRP.HasPermission(ExecutorPassport, Config["Perms"]["AddItens"][1], Config["Perms"]["AddItens"][2]) then
        if not ItemCatch or ItemCatch == "" then
            TriggerClientEvent("Notify", Source, "vermelho", "Item inválido.", 10000)
            return false
        end

        vRP.GenerateItem(TargetPassport, ItemCatch, ItemAmount, true)

        if TargetPassport == ExecutorPassport then
            TriggerClientEvent("Notify", TargetPassport, "verde", "Você pegou "..ItemAmount.."x "..itemName(ItemCatch)..".", 10000)
        else
            TriggerClientEvent("Notify", TargetPassport, "verde", "Você recebeu "..ItemAmount.."x "..itemName(ItemCatch)..".", 10000)
            TriggerClientEvent("Notify", Source, "verde", "Você deu "..ItemAmount.."x "..itemName(ItemCatch).." para "..TargetIdentity.name.." "..TargetIdentity.name2.." (#"..TargetPassport..").", 10000)
        end

        table.insert(PainelLogs, {
            user_id = ExecutorPassport,
            cor = "azul",
            nome = ExecutorIdentity.name.." "..ExecutorIdentity.name2,
            motivo = "Deu um item ["..ItemCatch.."] "..ItemAmount.."x para "..TargetIdentity.name.." "..TargetIdentity.name2.." (#"..TargetPassport..")."
        })

        PerformHttpRequest(Config["Webhooks"]["Itens"], function(err, text, headers) end, "POST", json.encode({
            embeds = {
                {
                    title = "**Spawn de Item**",
                    fields = {
                        { name = "📝 Author:", value = ExecutorIdentity.name.." "..ExecutorIdentity.name2.." **#"..ExecutorPassport.."**" },
                        { name = "📦 Jogador:", value = TargetIdentity.name.." "..TargetIdentity.name2.." **#"..TargetPassport.."**" },
                        { name = "🎁 Item:", value = ItemAmount.."x "..itemName(ItemCatch) }
                    },
                    footer = { 
                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                    },
                    thumbnail = { 
                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                    },
                    color = 3092790
                }
            }
        }), { ["Content-Type"] = "application/json" })

        return true
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Você não tem Permissão", 10000)
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SeeInformationsAllVeiculos()
	local Source = source
	local Passport = vRP.Passport(Source)
    local GaragemList = {}

	if Passport then
        for NameVehicle,Ignorar in pairs(VehicleGlobal()) do
            table.insert(GaragemList,{ 	
                carro = NameVehicle,
                name = VehicleName(NameVehicle), 
                linkgaragem = Config["ImagensGaragem"]
            })
        end
	end

    return GaragemList
end

function Creative.GiveVehicle(NameVehicle,SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)

    if SelectedPassport then
        local Identity2 = vRP.Identity(SelectedPassport)

        if vRP.HasPermission(Passport, Config["Perms"]["CatchVehicles"][1],Config["Perms"]["CatchVehicles"][2]) then
            vRP.Query("vehicles/addVehicles",{ Passport = SelectedPassport, vehicle = NameVehicle, plate = vRP.GeneratePlate(), work = "false" })

            TriggerClientEvent("Notify", Source, "verde", "Você setou o "..VehicleName(NameVehicle).." no passaporte: "..Identity2["name"].." "..Identity2["name2"].." ["..SelectedPassport.."].", 10000)

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog and IdentityAffected then
                table.insert(PainelLogs, { user_id = Passport, cor = "azul", nome = IdentityLog["name"].." "..IdentityLog["name2"], motivo = "Gerou um veiculo no id ["..SelectedPassport.."] veiculo ["..NameVehicle.."]." })

                local x, y, z = vCLIENT.GetPosition(Source)
                PerformHttpRequest(Config.Webhooks.seeGaragem, function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Setou Carro**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Player:", 
                                    value = "" ..IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."** ",
                                },
    
                                { 
                                    name = "🚗 Carro:", 
                                    value = "" ..VehicleName(NameVehicle).." ",
                                },
    
                                { 
                                    name = "🌐 Coordenada do Staff:", 
                                        value = ""..x..","..y..","..z.." \n \n " 
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = "./images/profile.png"
                            },
                            thumbnail = { 
                                url = "./images/profile.png"
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            return true
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 10000)
        end
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Você precisa colocar um Passaporte!", 10000)
    end
end

function Creative.ServerVehicle2(Model, x, y, z, Heading, Plate, Nitrox, Doors, Body, Fuel)
    local Vehicle = CreateVehicle(Model, x, y, z, Heading, true, true)

    while not DoesEntityExist(Vehicle) do
        Wait(100)
    end

    if DoesEntityExist(Vehicle) then
        if Plate ~= nil then
            SetVehicleNumberPlateText(Vehicle, Plate)
        else
            Plate = vRP.GeneratePlate()
            SetVehicleNumberPlateText(Vehicle, Plate)
        end

        SetVehicleBodyHealth(Vehicle, Body + 0.0)

        if not Fuel then
            TriggerEvent("engine:tryFuel", Plate, 100)
        end

        if Doors then
            local DoorsDecoded = json.decode(Doors)
            if DoorsDecoded ~= nil then
                for Number, Status in pairs(DoorsDecoded) do
                    if Status then
                        SetVehicleDoorBroken(Vehicle, parseInt(Number), true)
                    end
                end
            end
        end

        local Network = NetworkGetNetworkIdFromEntity(Vehicle)

        return true, Network, Vehicle
    end

    return false
end

function Creative.SpawnVehicle(VehicleName)
    local Source = source
    local Passport = vRP.Passport(Source)
    if Passport then 
        if vRP.HasPermission(Passport, Config["Perms"]["CatchVehicles"][1],Config["Perms"]["CatchVehicles"][2]) then
            local Ped = GetPlayerPed(Source)
            local Coords = GetEntityCoords(Ped)
            local Heading = GetEntityHeading(Ped)
            local Plate = "VEH"..(10000 + Passport)
            local Exist, Network, Vehicle = Creative.ServerVehicle2(VehicleName, Coords.x, Coords.y, Coords.z, Heading, Plate, 2000, nil, 1000)

            vCLIENT.CreateVehicle2(-1, VehicleName, Network, 1000, 1000, nil, false, false, Vehicle, Source)
            local Plates = GlobalState["Plates"] or {}
            Plates[Plate] = Passport
            GlobalState:set("Plates", Plates, true)
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 10000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AÇÕES RÁPIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.FastActionsToogle(SelectedPassport,tipo)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedSourcePed = vRP.Source(SelectedPassport)

    if Passport then
        if SelectedSourcePed then
            local Identity2 = vRP.Identity(SelectedPassport)
            local x, y, z = vCLIENT.GetPosition(Source)
            if tipo == "reviver" then
				vRP.Revive(SelectedSourcePed,200)
				vRP.UpgradeThirst(SelectedPassport,100)
				vRP.UpgradeHunger(SelectedPassport,100)
				vRP.DowngradeStress(SelectedPassport,100)
                TriggerClientEvent("Notify", Source, "verde", "Você reviveu o "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    local IdentityTarget = vRP.Identity(SelectedPassport)
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Reviveu o jogador ["..SelectedPassport.."] "..(IdentityTarget and IdentityTarget["name"].." "..IdentityTarget["name2"] or "").."."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["God"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Reviveu**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
           

            elseif tipo == "matar" then
                vRPC.SetHealth(SelectedSourcePed, 0)
                TriggerClientEvent("Notify", Source, "verde", "Você matou o "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    local IdentityTarget = vRP.Identity(SelectedPassport)
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Matou o jogador ["..SelectedPassport.."] "..(IdentityTarget and IdentityTarget["name"].." "..IdentityTarget["name2"] or "").."."
                    })
                end

                local identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Kill"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Matou**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..identity["name"].." "..identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

            elseif tipo == "colete" then
                vRP.SetArmour(SelectedSourcePed, 100)
                TriggerClientEvent("Notify", Source, "verde", "Colete Setado no "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Deu um colete para o passaporte ["..SelectedPassport.."]."
                    })
                end

                local identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Vest"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Deu Colete**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..identity["name"].." "..identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

            elseif tipo == "tpto" then
                local SelectedSourcePlayerPed = GetPlayerPed(SelectedSourcePed)
				local Coords = GetEntityCoords(SelectedSourcePlayerPed)

				vRP.Teleport(Source, Coords["x"],Coords["y"],Coords["z"])
                TriggerClientEvent("Notify", Source,"verde","Você foi até o "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Teleportou até o passaporte ["..SelectedPassport.."]."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Tpto"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Tpto**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

            elseif tipo == "tptome" then
                local MyPed = GetPlayerPed(Source)
				local Coords = GetEntityCoords(MyPed)

				vRP.Teleport(SelectedSourcePed,Coords["x"],Coords["y"],Coords["z"])	
                TriggerClientEvent("Notify", Source, "verde", "Você puxou o "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "azul",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Trouxe o passaporte no tptome ["..SelectedPassport.."] até si mesmo."
                    })
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Tptome"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Trouxe um player até ele**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "fix" then
                    local Vehicle, VehNet, VehPlate = vRPC.VehicleList(SelectedSourcePed, 10)
                    if Vehicle then
                        TriggerClientEvent("Painel:repairAdmin", -1, VehNet, VehPlate)

                        TriggerClientEvent("Notify", Source, "verde", "Você deu fix no carro do " .. Identity2["name"] .. " " .. Identity2["name2"] .. " [" .. SelectedPassport .. "].", 7000)

                        local IdentityLog = vRP.Identity(Passport)
                        if IdentityLog then
                            table.insert(PainelLogs, {
                                user_id = Passport,
                                cor = "azul",
                                nome = IdentityLog["name"] .. " " .. IdentityLog["name2"],
                                motivo = "Reparou o veículo do passaporte [" .. SelectedPassport .. "]."
                            })
                        end

                        local Identity = vRP.Identity(Passport)
                        PerformHttpRequest(Config["Webhooks"]["Fix"], function(err, text, headers) end, "POST", json.encode({
                            embeds = {
                                {     
                                    title = "**Reparou o veículo do jogador**",
                                    fields = {
                                        { 
                                            name = "📝 Autor:", 
                                            value = Identity["name"] .. " " .. Identity["name2"] .. " **#".. Passport .."**",
                                        },
                                        { 
                                            name = "📝 Alvo:", 
                                            value = Identity2["name"] .. " " .. Identity2["name2"] .. " **#".. SelectedPassport .."**",
                                        },
                                    }, 
                                    footer = { 
                                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                    },
                                    thumbnail = { 
                                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                                    },
                                    color = 3092790
                                }
                            }
                        }), { ["Content-Type"] = "application/json" })
                    else
                        TriggerClientEvent("Notify", Source, "vermelho", "O " .. Identity2["name"] .. " " .. Identity2["name2"] .. " [" .. SelectedPassport .. "] não está perto de um veículo.", 7000)
                    end
                    elseif tipo == "reset" then
                        if vRP.Request(Source, "Você deseja resetar o passaporte: "..SelectedPassport.." ?", "Sim", "Não") then
                            -- NationCreato = Tunnel.getInterface("nation_creator")
                            -- NationCreato.startCreator(SelectedSourcePed)
                            vRP.Query("playerdata/SetData", { Passport = SelectedPassport, dkey = "Creator", dvalue = 0 })
                            TriggerClientEvent("Notify", Source, "verde", "Você resetou o personagem "..Identity2["name"].." "..Identity2["name2"].." ["..SelectedPassport.."].")

                            local ExecutorPassport = vRP.Passport(Source)
                            local ExecutorIdentity = vRP.Identity(ExecutorPassport)
                            local TargetIdentity = Identity2

                            table.insert(PainelLogs, {
                                user_id = ExecutorPassport,
                                cor = "azul",
                                nome = ExecutorIdentity.name.." "..ExecutorIdentity.name2,
                                motivo = "Resetou o personagem do passaporte ["..SelectedPassport.."]."
                            })

                            PerformHttpRequest(Config["Webhooks"]["Reset"], function(err, text, headers) end, "POST", json.encode({
                                embeds = {
                                    {
                                        title = "**Reset de Personagem**",
                                        fields = {
                                            {
                                                name = "📝 Author:",
                                                value = ExecutorIdentity.name.." "..ExecutorIdentity.name2.." **#"..ExecutorPassport.."**"
                                            },
                                            {
                                                name = "📝 Jogador:",
                                                value = TargetIdentity.name.." "..TargetIdentity.name2.." **#"..SelectedPassport.."**"
                                            }
                                        },
                                        footer = { 
                                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                        },
                                        thumbnail = { 
                                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                                        },
                                        color = 3092790
                                    }
                                }
                            }), { ["Content-Type"] = "application/json" })
                        end
            elseif tipo == "algema" then
                if Player(SelectedSourcePed)["state"]["Handcuff"] then
					Player(SelectedSourcePed)["state"]["Handcuff"] = false
					Player(SelectedSourcePed)["state"]["Commands"] = false
                    ClearPedTasksImmediately(SelectedSourcePed)
                    vRPC.Destroy(SelectedSourcePed)

                    TriggerClientEvent("sounds:source", Source, "uncuff", 0.5)
                    TriggerClientEvent("sounds:source", SelectedSourcePed, "uncuff", 0.5)
                    TriggerClientEvent("Notify", Source, "verde", "Voce desalgemou o "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "azul",
                            nome = IdentityLog["name"].." "..IdentityLog["name2"],
                            motivo = "Desalgemou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    local identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Algema"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Desalgemou**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..identity.name.." "..identity.name2.." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                else
					Player(SelectedSourcePed)["state"]["Handcuff"] = true
					Player(SelectedSourcePed)["state"]["Commands"] = true
                    ClearPedTasksImmediately(SelectedSourcePed)
                    vRPC.Destroy(SelectedSourcePed)
                    TriggerClientEvent("inventory:Close", SelectedSourcePed)

                    TriggerClientEvent("sounds:source", Source, "cuff", 0.5)
                    TriggerClientEvent("sounds:source", SelectedSourcePed, "cuff", 0.5)
                    TriggerClientEvent("Notify", Source, "verde", "Você algemou o "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "amarelo",
                            nome = IdentityLog["name"].." "..IdentityLog["name2"],
                            motivo = "Algemou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Algema"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Algemou**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end
            elseif tipo == "ragdoll" then
                TriggerClientEvent("TackleAdmin:Start", SelectedSourcePed)

                local IdentityLog = vRP.Identity(Passport)
                local Identity2 = vRP.Identity(SelectedPassport)

                if IdentityLog and Identity2 then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "amarelo",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Derrubou o passaporte ["..SelectedPassport.."]."
                    })

                    TriggerClientEvent("Notify", vRP.Source(Passport), "amarelo", "Você derrubou <b>"..Identity2["name"].." "..Identity2["name2"].."</b> (#"..SelectedPassport..")", 5000)
                end

                local Identity = vRP.Identity(Passport)
                PerformHttpRequest(Config["Webhooks"]["Ragdoll"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Derrubou**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "fogo" then
                    TriggerClientEvent("StartEntity:Fire", SelectedSourcePed)

                    local IdentityLog = vRP.Identity(Passport)
                    local Identity2 = vRP.Identity(SelectedPassport)

                    if IdentityLog and Identity2 then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "amarelo",
                            nome = IdentityLog["name"].." "..IdentityLog["name2"],
                            motivo = "Tacou fogo no passaporte ["..SelectedPassport.."]."
                        })

                        TriggerClientEvent("Notify", vRP.Source(Passport), "amarelo", "Você incendiou <b>"..Identity2["name"].." "..Identity2["name2"].."</b> (#"..SelectedPassport..")", 5000)
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Fire"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Tacou Fogo**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "fome" then
                    vRP.DowngradeThirst(SelectedPassport, 50)
                    vRP.DowngradeHunger(SelectedPassport, 50)
                    vRP.DowngradeStress(SelectedPassport, 50)

                    local IdentityLog = vRP.Identity(Passport)
                    local Identity2 = vRP.Identity(SelectedPassport)

                    if IdentityLog and Identity2 then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "vermelho",
                            nome = IdentityLog["name"].." "..IdentityLog["name2"],
                            motivo = "Alterou a fome/sede do passaporte ["..SelectedPassport.."]."
                        })

                        TriggerClientEvent("Notify", vRP.Source(Passport), "amarelo", "Você alterou a fome/sede de <b>"..Identity2["name"].." "..Identity2["name2"].."</b> (#"..SelectedPassport..")", 5000)
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["HungerThirst"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Fome / Sede**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                }), { ["Content-Type"] = "application/json" })
                elseif tipo == "spec" then
                    if Spectate[Passport] then
                        local ped = GetPlayerPed(Spectate[Passport])
                        if DoesEntityExist(ped) then
                            SetEntityDistanceCullingRadius(ped, 0.0)
                        end

                        TriggerClientEvent("admin:resetSpectate", Source)
                        Spectate[Passport] = nil

                        TriggerClientEvent("Notify", Source, "amarelo", "Modo espião desativado.", 5000)
                    else
                        local SelectedSource = vRP.Source(SelectedPassport)
                        if SelectedSource then
                            local ped = GetPlayerPed(SelectedSource)
                            if DoesEntityExist(ped) then
                                SetEntityDistanceCullingRadius(ped, 999999999.0)
                                Wait(1000)
                                TriggerClientEvent("admin:initSpectate", Source, SelectedSource)
                                Spectate[Passport] = SelectedSource

                                local IdentityLog = vRP.Identity(Passport)
                                if IdentityLog then
                                    table.insert(PainelLogs, {
                                        user_id = Passport,
                                        cor = "amarelo",
                                        nome = IdentityLog["name"] .. " " .. IdentityLog["name2"],
                                        motivo = "Está espectando o passaporte [" .. SelectedPassport .. "]."
                                    })
                                end

                                local Identity = vRP.Identity(Passport)
                                local Identity2 = vRP.Identity(SelectedPassport)
                                PerformHttpRequest(Config["Webhooks"]["Spectate"], function(err, text, headers) end, "POST", json.encode({
                                    embeds = {
                                        {
                                            title = "**Spectando o jogador**",
                                            fields = {
                                                {
                                                    name = "📝 Autor:",
                                                    value = Identity["name"] .. " " .. Identity["name2"] .. " **#" .. Passport .. "**",
                                                },
                                                {
                                                    name = "📝 Alvo:",
                                                    value = Identity2["name"] .. " " .. Identity2["name2"] .. " **#" .. SelectedPassport .. "**",
                                                },
                                            },
                                            footer = { 
                                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                            },
                                            thumbnail = { 
                                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                                            },
                                            color = 3092790
                                        }
                                    }
                                }), { ["Content-Type"] = "application/json" })

                                TriggerClientEvent("Notify", Source, "verde", "Você está espectando <b>" .. Identity2["name"] .. " " .. Identity2["name2"] .. "</b>.", 5000)
                            end
                        else
                            TriggerClientEvent("Notify", Source, "vermelho", "Jogador não encontrado.", 5000)
                        end
                    end
            elseif tipo == "freezar" then
                if FreezePlayer[tostring(SelectedPassport)] then
                    FreezePlayer[tostring(SelectedPassport)] = false
                    FreezeEntityPosition(SelectedSourcePed, false)

                    TriggerClientEvent("Notify", Source, "verde", "Você tirou o freeze do "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "vermelho",
                            nome = IdentityLog["name"].." "..IdentityLog["name2"],
                            motivo = "Descongelou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Freeze"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Descongelou**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                else
                    FreezePlayer[tostring(SelectedPassport)] = true
                    FreezeEntityPosition(SelectedSourcePed, true)

                    TriggerClientEvent("Notify", Source, "verde", "Você freezou o "..Identity2["name"].." ".. Identity2["name2"].." ["..SelectedPassport.."].", 7000)

                    local IdentityLog = vRP.Identity(Passport)
                    if IdentityLog then
                        table.insert(PainelLogs, {
                            user_id = Passport,
                            cor = "vermelho",
                            nome = IdentityLog["name"].." "..IdentityLog["name2"],
                            motivo = "Congelou o passaporte ["..SelectedPassport.."]."
                        })
                    end

                    local Identity = vRP.Identity(Passport)
                    PerformHttpRequest(Config["Webhooks"]["Freeze"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Congelou**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Jogador Offline", 7000)
            return false
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCREENSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TakeScreenshot(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    local SelectedSource = vRP.Source(SelectedPassport)
    if not SelectedSource then
        TriggerClientEvent("Notify", Source, "vermelho", "Jogador offline.")
        return false
    end

    vCLIENT.ScreenShotAction(SelectedSource, Config["Webhooks"]["ScreenShots"], SelectedPassport)

    local time = 0
    while not ScreenShotInstances[SelectedPassport] do
        time = time + 1
        if time >= 5 then
            break
        end
        Wait(1500)
    end

    local screen = ScreenShotInstances[SelectedPassport]
    ScreenShotInstances[SelectedPassport] = nil
    TriggerClientEvent("Notify", Source, "verde", "Você tirou uma screenshot do passaporte: "..SelectedPassport)
    
    return screen, Passport
end

function Creative.AddScreenShot(ScreenShot,ScreenShotID)
    ScreenShotInstances[ScreenShotID] = ScreenShot
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SendMessageStaff(SelectedPassport,SelectedMessage)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        TriggerClientEvent("Notify", Source, "verde", "Você enviou uma mensagem para o passaporte: "..SelectedPassport.."", 7000)
        TriggerClientEvent("Notify", SelectedSource, "verde", "Administração: "..SelectedMessage.."", 20000)

        local IdentityLog = vRP.Identity(Passport)
        if IdentityLog then
            table.insert(PainelLogs, {
                user_id = Passport,
                cor = "amarelo",
                nome = IdentityLog["name"].." "..IdentityLog["name2"],
                motivo = "Enviou a mensagem: \""..SelectedMessage.."\" para o passaporte ["..SelectedPassport.."]."
            })
        end

        local Identity = vRP.Identity(Passport)
        local Identity2 = vRP.Identity(SelectedPassport)
        PerformHttpRequest(Config["Webhooks"]["Message"], function(err, text, headers) end, "POST", json.encode({
            embeds = {
                {     
                    title = "**Enviou Mensagem**",
                    fields = {
                        { 
                            name = "📝 Author:", 
                            value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                        },
                        { 
                            name = "📝 Jogador:", 
                            value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                        },
                        { 
                            name = "📦 Mensagem:", 
                            value = ""..SelectedMessage.." ",
                        },
                    }, 
                    footer = { 
                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                    },
                    thumbnail = { 
                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                    },
                    color = 3092790
                }
            }
        }), { ["Content-Type"] = "application/json" })
        return true
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Esse jogador está offline.")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnSkinsList()
	local Source = source
	local Passport = vRP.Passport(Source)
    local ReturnTable = {}

	if Passport then
        for Ignore,TableSkin in pairs(Config["Skins"]) do
            table.insert(ReturnTable, { nome = TableSkin["Nome"], set = TableSkin["Spawn"], linkskins = Config["ImagensSkins"], sexo = TableSkin["Sex"] })
        end
	end

    return ReturnTable
end

function Creative.SetSkinStaff(SelectedPassport, SelectedSkin)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["AddSkins"][1], Config["Perms"]["AddSkins"][2]) then
            vRPC.Skin(SelectedSource, GetHashKey(SelectedSkin))
            vRP.SkinCharacter(SelectedPassport, SelectedSkin)
            vRP.Query("playerdata/SetData", { Passport = SelectedPassport, dkey = "Skin", dvalue = SelectedSkin })

            local sex = nil
            if SelectedSkin == "mp_m_freemode_01" then
                sex = "M"
            elseif SelectedSkin == "mp_f_freemode_01" then
                sex = "F"
            end

            if sex then
                vRP.Query("characters/SetSex", { Passport = SelectedPassport, sex = sex })
            end

            TriggerClientEvent("Notify", Source, "verde", "Você setou a skin "..SelectedSkin.." no passaporte "..SelectedPassport..".", 7000)

            local Identity2 = vRP.Identity(SelectedPassport)
            local x, y, z = vCLIENT.GetPosition(SelectedSource)

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "azul",
                    nome = IdentityLog.name.." "..IdentityLog.name2,
                    motivo = "Setou a skin **"..SelectedSkin.."** no passaporte ["..SelectedPassport.."] nas coordenadas ("..x..", "..y..", "..z..")."
                })
            end

            PerformHttpRequest(Config["Webhooks"]["Skin"], function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {     
                        title = "*Skin setada: "..SelectedSkin.."",
                        fields = {
                            { 
                                name = "📝 Author:", 
                                value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                            },
                            { 
                                name = "📝 Jogador:", 
                                value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                            },
                            { 
                                name = "🌐 Coordenada do Jogador:", 
                                value = ""..x..","..y..","..z.." \n \n " 
                            },
                        }, 
                        footer = { 
                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                        },
                        thumbnail = { 
                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                        },
                        color = 3092790
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Skin indisponível", 7000)
        end
        return true
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Esse jogador está offline.", 7000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAÚ FAC
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnChestOrganizationsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local Remember = {}
    local BausFaccoes = {}

    local AllGroups = vRP.Groups()
    for OrganizationName,TableOrganization in pairs(AllGroups) do
        if TableOrganization["Type"] == "Work" then
            local Chest = vRP.GetSrvData("Chest:"..OrganizationName,true)
            if Chest then
                local AmountItens = 0
                for x,b in pairs(Chest) do
                    AmountItens = AmountItens + b["amount"]
                end

                table.insert(BausFaccoes,{ 	
                    user_id = Passport,
                    nome = Identity["name"].." ".. Identity["name2"],
                    color = "#fff",
                    background = "#fff",
                    bau = OrganizationName,
                    tipo = AmountItens.."X Itens"
                })
                Remember[OrganizationName] = true
            end
        end
    end
    for OrganizationName,TableOrganization in pairs(AllGroups) do
        if TableOrganization["Type"] == "Work" and not Remember[OrganizationName] then
            table.insert(BausFaccoes,{ 	
                user_id = Passport,
                nome = Identity["name"].." ".. Identity["name2"],
                color = "#fff",
                background = "#fff",
                bau = OrganizationName,
                tipo = "0x Itens"
            })
        end
    end

    return BausFaccoes
end

function Creative.ReturnChestOrganizationSelected(OrganizationName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedBauList = {}

    local Chest = vRP.GetSrvData("Chest:"..OrganizationName,true)
    if Chest then
        for k,v in pairs(Chest) do
            table.insert(SelectedBauList,{ 	
                user_id = Passport,
                nome = Identity["name"].." ".. Identity["name2"],
                slot = k,
                item = v["item"],
                amount = parseInt(v["amount"]), 
                name = itemName(v["item"]), 
                index = itemIndex(v["item"]),
                days = v["days"],
                durability = v["durability"],
                linkinventario = Config["ImagensInventario"]
            })
        end
    end

    return SelectedBauList
end

function Creative.DeleteItemChestOrganization(OrganizationName, ItemName, ItemAmount, ItemSlot)
    local Source = source
    local Passport = vRP.Passport(Source)

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageChests"][1], Config["Perms"]["ManageChests"][2]) then
        vRP.TakeChestRemoveOnly(Passport, "Chest:"..OrganizationName, ItemAmount, ItemSlot)
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRUPOS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnAllGroupsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local AllGroupList = {}

    local AllGroups = vRP.Groups()
    for OrganizationName,Ignore in pairs(AllGroups) do
        local Services, Amount = vRP.NumPermission(OrganizationName)

        table.insert(AllGroupList,{
            user_id = Passport,
            nome = Identity["name"].." ".. Identity["name2"],
            color = "#fff",
            background = "#fff",
            empresa = OrganizationName,
            contador = Amount
        })
    end

    return AllGroupList
end

function Creative.ReturnOrganizationListSelected(GroupName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local MyIdentity = vRP.Identity(Passport)
    local SelectedGroupList = {}

    local AllGroups = vRP.Groups()
    local DataGroup = vRP.DataGroups(GroupName)
    if DataGroup then
        if AllGroups[GroupName] then
            for SelectedPass,SelectedHierarchy in pairs(DataGroup) do
                local SelectedPassport = parseInt(SelectedPass)
                local Identity = vRP.Identity(SelectedPassport)
                if Identity then
                    local InfoImage = vRP.Query("night_adminv2/jesterInstagram", {user_id = SelectedPassport})
                    local SelectedImage = "./images/profile.png"
                    if InfoImage[1] then
                        SelectedImage = InfoImage[1]["avatarURL"]
                    end

                    local ThisGroup = AllGroups[GroupName]
                    local MyHierarchy = ThisGroup["Hierarchy"][SelectedHierarchy]

                    table.insert(SelectedGroupList,{
                        user_id = SelectedPassport,
                        myname = Identity["name"].." "..Identity["name2"],
                        nome = Identity["name"],
                        sobrenome = Identity["name2"],
                        color = "#fff",
                        background = "#fff",
                        emprego = MyHierarchy,
                        img = SelectedImage
                    })
                end
            end
        end
    end

    return SelectedGroupList
end

function Creative.ManageSelectedGroups(SelectedPassport, GroupName, Type)
    local Source = source
    local Passport = vRP.Passport(Source)
    local AllGroups = vRP.Groups()

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageGroups"][1],Config["Perms"]["ManageGroups"][2]) and vRP.HasPermission(SelectedPassport, GroupName) then
        if Type == "upar" then
            local SelectedLevel = 0
            local Datatable = vRP.GetSrvData("Permissions:"..GroupName)
            if Datatable[tostring(SelectedPassport)] then
                if Datatable[tostring(SelectedPassport)] - 1 >= 1 then
                    SelectedLevel = Datatable[tostring(SelectedPassport)] - 1
                else
                    SelectedLevel = Datatable[tostring(SelectedPassport)]
                end
            end

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog then
                table.insert(PainelLogs, { user_id = Passport, cor = "amarelo", nome = IdentityLog["name"].." "..IdentityLog["name2"], motivo = "Realizou um up no id ["..SelectedPassport.."] no grupo ["..GroupName.."]." })

                PerformHttpRequest(Config["Webhooks"]["UpgradeHierarchy"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "*Player upado do grupo: "..GroupName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            vRP.SetPermission(SelectedPassport, GroupName, SelectedLevel, false)
        end
        if Type == "rebaixar" then
            local SelectedLevel = 0
            local Datatable = vRP.GetSrvData("Permissions:"..GroupName)
            if Datatable[tostring(SelectedPassport)] then
                if Datatable[tostring(SelectedPassport)] + 1 <= #AllGroups[GroupName]["Hierarchy"] then
                    SelectedLevel = Datatable[tostring(SelectedPassport)] + 1
                else
                    SelectedLevel = Datatable[tostring(SelectedPassport)]
                end
            end

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog then
                table.insert(PainelLogs, { user_id = Passport, cor = "amarelo", nome = IdentityLog["name"].." "..IdentityLog["name2"], motivo = "Realizou um rebaixar no id ["..SelectedPassport.."] no grupo ["..GroupName.."]." })

                PerformHttpRequest(Config["Webhooks"]["DowngradeHierarchy"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "*Player rebaixado do grupo: "..GroupName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Player:", 
                                    value = "" ..IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            vRP.SetPermission(SelectedPassport, GroupName, SelectedLevel, false)
        end
        if Type == "demitir" then
            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog then
                table.insert(PainelLogs, { user_id = Passport, cor = "amarelo", nome = IdentityLog["name"].." "..IdentityLog["name2"], motivo = "Realizou uma demissão no id ["..SelectedPassport.."] no grupo ["..GroupName.."]." })

                PerformHttpRequest(Config["Webhooks"]["Dismiss"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "Player removido do grupo: "..GroupName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Player:", 
                                    value = "" ..IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            vRP.RemovePermission(SelectedPassport, GroupName)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnInventorySelected(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local ReturnInventoryTable = {}

    local SelectedPassport = parseInt(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)

    local SelectedInventory
    if vRP.Source(SelectedPassport) then
        SelectedInventory = vRP.Inventory(SelectedPassport)
    else
        SelectedInventory = vRP.InventoryOffline(SelectedPassport)
    end

    if SelectedInventory then
        for _,TableInventory in pairs(SelectedInventory) do
            if itemName(TableInventory["item"]) then
                local splitName = splitString(TableInventory["item"], "-")

                if splitName[2] ~= nil then
                    if itemDurability(TableInventory["item"]) then
                        TableInventory["durability"] = parseInt(os.time() - splitName[2])
                        TableInventory["days"] = itemDurability(TableInventory["item"])
                    else
                        TableInventory["durability"] = 0
                        TableInventory["days"] = 1
                    end
                else
                    TableInventory["durability"] = 0
                    TableInventory["days"] = 1
                end

                table.insert(ReturnInventoryTable,{
                    item = TableInventory["item"],
                    amount = parseInt(TableInventory["amount"]),
                    name = itemName(TableInventory["item"]),
                    index = itemIndex(TableInventory["item"]),
                    days = TableInventory["days"],
                    durability = TableInventory["durability"],
                    linkinventario = Config["ImagensInventario"]
                })
            end
        end
    end

    return {
        nome = Identity["name"].." "..Identity["name2"],
        user_id = SelectedPassport,
        inventario = ReturnInventoryTable
    }
end

function Creative.RemoveItemSelectedInventory(SelectedPassport,SelectedItem,SelectedAmount)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedSource = vRP.Source(SelectedPassport)
    
    if not SelectedSource then
        TriggerClientEvent("Notify", Source, "vermelho", "Jogador offline.", 7000)
        return false
    end

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageInventory"][1],Config["Perms"]["ManageInventory"][2]) then
            vRP.TakeItem(SelectedPassport, SelectedItem, SelectedAmount, true)
        
            local Identity2 = vRP.Identity(SelectedPassport)
            TriggerClientEvent("Notify", Source, "verde", "Você retirou "..SelectedAmount.."x "..itemName(SelectedItem).." do "..Identity2["name"].." "..Identity2["name2"].." ["..SelectedPassport.."]", 7000)
            local x, y, z = vCLIENT.GetPosition(SelectedSource)

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = IdentityLog["name"].." "..IdentityLog["name2"],
                    motivo = "Removeu o item **"..parseFormat(SelectedAmount).."x "..itemName(SelectedItem).."** do passaporte ["..SelectedPassport.."]."
                })
            end
        
            PerformHttpRequest(Config["Webhooks"]["RemoveItemInventory"], function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {     
                        title = "**Removeu Item**",
                        fields = {
                            { 
                                name = "📝 Author:", 
                                value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                            },
                            { 
                                name = "📝 Jogador:", 
                                value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                            },
                            { 
                                name = "🎁 Item:", 
                                value = " "..parseFormat(SelectedAmount).."x " ..itemName(SelectedItem).."",
                            },
                            { 
                                name = "🌐 Coordenada do Jogador:", 
                                    value = ""..x..","..y..","..z.." \n \n " 
                            },
                        }, 
                        footer = { 
                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                        },
                        thumbnail = { 
                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                        },
                        color = 3092790
                    }
                }
            }), { ["Content-Type"] = "application/json" })

            return true
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão para executar esta ação.", 7000)
        end
    end
    
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPRIEDADES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnSelectedCasasList(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local CasasTable = {}
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        local Identity = vRP.Identity(SelectedPassport)
        local CasasQuery = vRP.Query("propertys/AllUser", { Passport = SelectedPassport })
        local CasasList = false

        for _, Casa in pairs(CasasQuery) do
            CasasList = true
            table.insert(CasasTable, {
                user_id = SelectedPassport,
                nome = Identity["name"] .. " " .. Identity["name2"],
                home = Casa["Name"]
            })
        end

        if not CasasList then
            table.insert(CasasTable, {
                user_id = SelectedPassport,
                nome = Identity["name"] .. " " .. Identity["name2"],
                home = nil
            })
        end
    end

    return CasasTable
end

function Creative.ReturnChestCasaList(SelectedPassport, SelectedCasa)
    local Source = source
    local Passport = vRP.Passport(Source)
    local CasaChestData = {}
    SelectedPassport = parseInt(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)

    if Passport then
        local Result = vRP.GetSrvData("Vault:"..SelectedCasa)
        if Result then
            for k, v in pairs(Result) do
                local splitName = splitString(v["item"], "-")
                if splitName[2] ~= nil then
                    if itemDurability(v["item"]) then
                        v["durability"] = parseInt(os.time() - splitName[2])
                        v["days"] = itemDurability(v["item"])
                    else
                        v["durability"] = 0
                        v["days"] = 1
                    end
                else
                    v["durability"] = 0
                    v["days"] = 1
                end

                table.insert(CasaChestData, {
                    slot = k,
                    item = v["item"],
                    amount = parseInt(v["amount"]),
                    name = itemName(v["item"]),
                    index = itemIndex(v["item"]),
                    days = v["days"],
                    durability = v["durability"],
                    linkinventario = Config["ImagensInventario"]
                })
            end
        end
    end

    return {
        nome = Identity and (Identity["name"].." "..Identity["name2"]),
        user_id = SelectedPassport,
        casasBau = CasaChestData
    }
end

function Creative.removerCasa(nomeCasa)
    local source = source
    local passport = vRP.Passport(source)
    if passport and nomeCasa then
        vRP.Query("propertys/Sell", { name = nomeCasa })
        return true
    end
    return false
end

function Creative.DeleteSelectedItemChestCasa(SelectedPassport, CasaName, ItemName, ItemAmount, ItemSlot)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageHouses"][1], Config["Perms"]["ManageHouses"][2]) then
        local IdentityLog = vRP.Identity(Passport)
        local IdentityAffected = vRP.Identity(SelectedPassport)
        if IdentityLog and IdentityAffected then
            
            TriggerClientEvent("Notify", Source, "verde", "Você removeu "..ItemAmount.."x "..ItemName.." do "..IdentityAffected["name"].." "..IdentityAffected["name2"].." ["..SelectedPassport.."]", 7000)

            table.insert(PainelLogs, { 
                user_id = Passport, 
                cor = "vermelho", 
                nome = IdentityLog["name"].." "..IdentityLog["name2"], 
                motivo = "Removeu **"..ItemAmount.."x "..ItemName.."** do baú da casa ["..CasaName.."] do passaporte ["..SelectedPassport.."]."
            })

            PerformHttpRequest(Config["Webhooks"]["RemoveItemChestHouse"], function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {     
                        title = "**Removeu um item do baú da casa**",
                        fields = {
                            {
                                name = "📝 Author:", 
                                value = IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."** ",
                            },
                            {
                                name = "🏠 Na casa de:", 
                                value = IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."** ",
                            },
                            {
                                name = "🏠 Casa:", 
                                value = "**"..CasaName.."** ",
                            },
                            {
                                name = "🎁 Item:", 
                                value = " "..ItemAmount.."x "..ItemName,
                            },
                        }, 
                        footer = { 
                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                        },
                        thumbnail = { 
                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                        },
                        color = 3092790
                    }
                }
            }), { ["Content-Type"] = "application/json" })
        end

        vRP.TakeChestRemoveOnly(SelectedPassport, "Vault:"..CasaName, ItemAmount, ItemSlot)
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReturnSelectedGarageList(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local GaragemTables = {}
    local SelectedPassport = parseInt(SelectedPassport)

    local VehicleQuery = vRP.Query("vehicles/UserVehicles", { Passport = SelectedPassport })
    local Identity = vRP.Identity(SelectedPassport)

    if Passport then
        for Index,TableVehicle in pairs(VehicleQuery) do
            if VehicleName(TableVehicle["vehicle"]) then
                table.insert(GaragemTables,{
                    user_id = SelectedPassport,
                    nome = Identity["name"].." ".. Identity["name2"],
                    index = TableVehicle["vehicle"],
                    name = VehicleName(TableVehicle["vehicle"]),
                    linkgaragem = Config["ImagensGaragem"]
                })
            end
        end
    end

    return {
        nome = Identity["name"].." ".. Identity["name2"],
        user_id = SelectedPassport,
        garagem = GaragemTables
    }
end

function Creative.DeleteVehicleSelected(SelectedPassport,NameVehicle)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageVehicles"][1],Config["Perms"]["ManageVehicles"][2]) then
            vRP.Query("vehicles/removeVehicles", { Passport = SelectedPassport, vehicle = NameVehicle }) 

            local Identity2 = vRP.Identity(SelectedPassport)
            TriggerClientEvent("Notify", Source, "verde", "Você retirou o carro "..NameVehicle.." do "..Identity2["name"].." "..Identity2["name2"].." ["..SelectedPassport.."]", 7000)

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = IdentityLog["name"].." "..IdentityLog["name2"],
                    motivo = "Removeu o veículo **"..VehicleName(NameVehicle).."** do passaporte ["..SelectedPassport.."]."
                })
            end

            local x, y, z = vCLIENT.GetPosition(SelectedPassport)
            PerformHttpRequest(Config["Webhooks"]["RemoveVehicle"], function(err, text, headers) end, "POST", json.encode({
                embeds = {
                    {     
                        title = "**Removeu Carro**",
                        fields = {
                            { 
                                name = "📝 Author:", 
                                value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."**",
                            },
                            { 
                                name = "📝 Player:", 
                                value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."**",
                            },
                            { 
                                name = "🚗 Carro:", 
                                value = " "..VehicleName(NameVehicle).." ",
                            },
                            { 
                                name = "🌐 Coordenada do Player:", 
                                value = ""..x..","..y..","..z.." \n \n " 
                            },
                        }, 
                        footer = { 
                            text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                            icon_url = Config["Webhooks"]["DiscordImageFooter"]
                        },
                        thumbnail = { 
                            url = Config["Webhooks"]["DiscordImageThumbanil"]
                        },
                        color = 3092790
                    }
                }
            }), { ["Content-Type"] = "application/json" })

            return true
        end
    end

    return false
end

function Creative.ReturnChestVehicleList(SelectedPassport, SelectedVehicle)
    local Source = source
    local Passport = vRP.Passport(Source)
    local VehicleChestData = {}
    local SelectedPassport = parseInt(SelectedPassport)
    local Identity = vRP.Identity(SelectedPassport)

    if Passport then
        local Result = vRP.GetSrvData("Trunkchest:"..SelectedPassport..":"..SelectedVehicle)
        if Result then
            for k,v in pairs(Result) do
                local splitName = splitString(v["item"], "-")
                if splitName[2] ~= nil then
                    if itemDurability(v["item"]) then
                        v["durability"] = parseInt(os.time() - splitName[2])
                        v["days"] = itemDurability(v["item"])
                    else
                        v["durability"] = 0
                        v["days"] = 1
                    end
                else
                    v["durability"] = 0
                    v["days"] = 1
                end

                table.insert(VehicleChestData,{
                    slot = k,
                    item = v["item"],
                    amount = parseInt(v["amount"]), 
                    name = itemName(v["item"]), 
                    index = itemIndex(v["item"]),
                    days = v["days"],
                    durability = v["durability"],
                    linkinventario = Config["ImagensInventario"]
                })
            end
        end
    end

    return {
        nome = Identity["name"].." ".. Identity["name2"],
        user_id = SelectedPassport,
        carroBau = VehicleChestData
    }
end

function Creative.DeleteSelectedItemChestVehicle(SelectedPassport, VehicleName, ItemName, ItemAmount, ItemSlot)
    local Source = source
    local Passport = vRP.Passport(Source)
    SelectedPassport = parseInt(SelectedPassport)

    if Passport and vRP.HasPermission(Passport, Config["Perms"]["ManageVehicles"][1], Config["Perms"]["ManageVehicles"][2]) then
        local IdentityLog = vRP.Identity(Passport)
        local IdentityAffected = vRP.Identity(SelectedPassport)

        if IdentityLog and IdentityAffected then
            -- Notificação para o admin
            TriggerClientEvent("Notify", Source, "verde", "Você removeu "..ItemAmount.."x "..ItemName.." do veículo "..VehicleName.." do "..IdentityAffected["name"].." "..IdentityAffected["name2"].." ["..SelectedPassport.."]", 7000)

            table.insert(PainelLogs, {
                user_id = Passport,
                cor = "vermelho",
                nome = IdentityLog["name"].." "..IdentityLog["name2"],
                motivo = "Removeu **"..ItemAmount.."x "..ItemName.."** do baú do veículo ["..VehicleName.."] do passaporte ["..SelectedPassport.."]."
            })

            PerformHttpRequest(Config["Webhooks"]["RemoveItemChestVehicle"], function(err, text, headers) end, "POST", json.encode({
                embeds = { {
                    title = "**Removeu um item do baú do veículo**",
                    fields = {
                        { name = "📝 Author:", value = IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."**" },
                        { name = "📝 No passaporte:", value = IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."**" },
                        { name = "🚗 Veículo:", value = "**"..VehicleName.."**" },
                        { name = "🎁 Item:", value = "**"..ItemAmount.."x "..ItemName.."**" }
                    },
                    footer = { 
                        text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                        icon_url = Config["Webhooks"]["DiscordImageFooter"]
                    },
                    thumbnail = { 
                        url = Config["Webhooks"]["DiscordImageThumbanil"]
                    },
                    color = 3092790
                } }
            }), { ["Content-Type"] = "application/json" })
        end

        vRP.TakeChestRemoveOnly(SelectedPassport, "Trunkchest:"..SelectedPassport..":"..VehicleName, ItemAmount, ItemSlot)
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ChangeWalletValues(SelectedPassport,SelectedValue,SelectedType)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedValue = parseInt(SelectedValue)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageMoney"][1],Config["Perms"]["ManageMoney"][2]) then
            if SelectedType == "mais" then
                vRP.GenerateItem(SelectedPassport, "dollars", SelectedValue, true)
    
                TriggerClientEvent("Notify", Source, "verde", "Você adicionou "..parseFormat(SelectedValue).." $ para o passaporte: "..SelectedPassport.."", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.name.." "..IdentityLog.name2,
                        motivo = "Spawnou dinheiro na carteira **"..parseFormat(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    local x, y, z = vCLIENT.GetPosition(SelectedPassport)
                    PerformHttpRequest(Config["Webhooks"]["ChangeWalletMore"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Spawn Dinheiro Carteira**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..parseFormat(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
            if SelectedType == "menos" then
                vRP.TakeItem(SelectedPassport, "dollars", SelectedValue, true)

                TriggerClientEvent("Notify", Source, "verde", "Você retirou "..parseFormat(SelectedValue).." $ do passaporte: "..SelectedPassport.."", 7000)

                local Identity2 = vRP.Identity(SelectedPassport)
                local x,y,z = vCLIENT.GetPosition(Source)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.name.." "..IdentityLog.name2,
                        motivo = "Removeu dinheiro no banco **"..parseFormat(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    local x, y, z = vCLIENT.GetPosition(SelectedPassport)
                    PerformHttpRequest(Config["Webhooks"]["ChangeWalletLess"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Remover Dinheiro Banco**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..parseFormat(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Esse jogador está offline", 7000)
    end

    return false
end

function Creative.ChangeBankValues(SelectedPassport,SelectedValue,SelectedType)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedValue = parseInt(SelectedValue)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageMoney"][1],Config["Perms"]["ManageMoney"][2]) then
            if SelectedType == "mais" then
                vRP.GiveBank(SelectedPassport, SelectedValue)
    
                TriggerClientEvent("Notify", Source, "verde", "Você adicionou "..parseFormat(SelectedValue).." $ para o passaporte: "..SelectedPassport.."", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.name.." "..IdentityLog.name2,
                        motivo = "Spawnou dinheiro no banco **"..parseFormat(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    local x, y, z = vCLIENT.GetPosition(SelectedPassport)
                    PerformHttpRequest(Config["Webhooks"]["ChangeBankMore"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Spawn Dinheiro Banco**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..parseFormat(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
            if SelectedType == "menos" then
                vRP.PaymentBank(SelectedPassport, SelectedValue)

                TriggerClientEvent("Notify", Source, "verde", "Você retirou "..parseFormat(SelectedValue).." $ do passaporte: "..SelectedPassport.."", 7000)

                local Identity2 = vRP.Identity(SelectedPassport)
                local x,y,z = vCLIENT.GetPosition(Source)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog.name.." "..IdentityLog.name2,
                        motivo = "Retirou dinheiro do banco **"..parseFormat(SelectedValue).."$** no passaporte ["..SelectedPassport.."]."
                    })

                    local Identity2 = vRP.Identity(SelectedPassport)
                    local x, y, z = vCLIENT.GetPosition(SelectedPassport)
                    PerformHttpRequest(Config["Webhooks"]["ChangeBankLess"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Remover Dinheiro Banco**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "💸 Quantidade:", 
                                        value = " "..parseFormat(SelectedValue).." $ ",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end

                return true
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Esse jogador está offline", 7000)
    end

    return false
end

function Creative.ChangeCoinsValues(SelectedPassport, SelectedValue, SelectedType)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)
    local SelectedValue = parseInt(SelectedValue)
    local SelectedSource = vRP.Source(SelectedPassport)

    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageCoins"][1], Config["Perms"]["ManageCoins"][2]) then
            local Identity = vRP.Identity(Passport)
            local Identity2 = vRP.Identity(SelectedPassport)

            if SelectedType == "mais" then
                vRP.Query("accounts/AddGems", { license = Identity2["license"], gems = SelectedValue })

                TriggerClientEvent("Notify", Source, "verde", "Você adicionou "..parseFormat(SelectedValue).." gemas para o passaporte: "..SelectedPassport, 7000)

                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "verde",
                    nome = Identity.name.." "..Identity.name2,
                    motivo = "Adicionou **"..parseFormat(SelectedValue).." gemas** no passaporte ["..SelectedPassport.."]."
                })
                return true
            end

            if SelectedType == "menos" then
                vRP.Query("accounts/RemoveGems", { license = Identity2["license"], gems = SelectedValue })

                TriggerClientEvent("Notify", Source, "verde", "Você removeu "..parseFormat(SelectedValue).." gemas do passaporte: "..SelectedPassport, 7000)

                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = Identity.name.." "..Identity.name2,
                    motivo = "Removeu **"..parseFormat(SelectedValue).." gemas** do passaporte ["..SelectedPassport.."]."
                })
                return true
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Esse jogador está offline", 7000)
    end
    return false
end

function Creative.ChangeNumberPhoneSelected(SelectedPassport,NewPhoneNumber)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)

    local SelectedSource = vRP.Source(SelectedPassport)
    if SelectedSource then
        if vRP.HasPermission(Passport, Config["Perms"]["ChangeNumber"][1],Config["Perms"]["ChangeNumber"][2]) then
            if not vRP.UserPhone(NewPhoneNumber) then
                local Identity2 = vRP.Identity(SelectedPassport)
                local OldPhoneNumber = Identity2["phone"]

                TriggerEvent("smartphone:updatePhoneNumber", SelectedPassport, NewPhoneNumber)
                vRP.UpgradePhone(SelectedPassport, NewPhoneNumber)

                TriggerClientEvent("Notify", Source, "verde", "Telefone atualizado.", 5000)
                TriggerClientEvent("Notify", Source, "verde", "Você alterou o celular para "..NewPhoneNumber.." do passaporte: "..SelectedPassport.."", 7000)

                local IdentityLog = vRP.Identity(Passport)
                if IdentityLog then
                    table.insert(PainelLogs, {
                        user_id = Passport,
                        cor = "vermelho",
                        nome = IdentityLog["name"].." "..IdentityLog["name2"],
                        motivo = "Trocou o número de celular do passaporte ["..SelectedPassport.."]: de **"..OldPhoneNumber.."** para **"..NewPhoneNumber.."**."
                    })

                    local x, y, z = vCLIENT.GetPosition(SelectedPassport)
                    PerformHttpRequest(Config["Webhooks"]["ChangeNumber"], function(err, text, headers) end, "POST", json.encode({
                        embeds = {
                            {     
                                title = "**Trocou o Celular**",
                                fields = {
                                    { 
                                        name = "📝 Author:", 
                                        value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                    },
                                    { 
                                        name = "📝 Jogador:", 
                                        value = "" ..Identity2["name"].." "..Identity2["name2"].." **#"..SelectedPassport.."** ",
                                    },
                                    { 
                                        name = "📱 Antigo Numero:", 
                                        value = " "..OldPhoneNumber.."",
                                    },
                                    { 
                                        name = "📱 Novo Numero:", 
                                        value = " "..NewPhoneNumber.."",
                                    },
                                    { 
                                        name = "🌐 Coordenada do Jogador:", 
                                            value = ""..x..","..y..","..z.." \n \n " 
                                    },
                                }, 
                                footer = { 
                                    text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                    icon_url = Config["Webhooks"]["DiscordImageFooter"]
                                },
                                thumbnail = { 
                                    url = Config["Webhooks"]["DiscordImageThumbanil"]
                                },
                                color = 3092790
                            }
                        }
                    }), { ["Content-Type"] = "application/json" })
                end
    
                return true
            else
                TriggerClientEvent("Notify", Source, "vermelho", "Esse celular não está disponivel!", 7000)
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Esse jogador está offline!", 7000)
    end

    return false
end

function Creative.ChangeSelectedName(SelectedPassport,FirstName,SecondName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local Identity = vRP.Identity(Passport)
    local SelectedPassport = parseInt(SelectedPassport)

    if SelectedPassport then
        if vRP.HasPermission(Passport, Config["Perms"]["ChangeName"][1],Config["Perms"]["ChangeName"][2]) then
            local Identity3 = vRP.Identity(SelectedPassport)
            local OldName = "" ..Identity3["name"].." "..Identity3["name2"]..""

            vRP.UpgradeNames(SelectedPassport, FirstName, SecondName)

            local Identity2 = vRP.Identity(SelectedPassport)
            TriggerClientEvent("Notify", Source, "verde", "Você trocou o nome do passaporte: "..SelectedPassport.." para "..FirstName.." "..SecondName..".", 7000)

            local IdentityLog = vRP.Identity(Passport)
            if IdentityLog then
                table.insert(PainelLogs, {
                    user_id = Passport,
                    cor = "vermelho",
                    nome = IdentityLog["name"].." "..IdentityLog["name2"],
                    motivo = "Trocou o nome do passaporte ["..SelectedPassport.."]: de **"..OldName.."** para **"..Identity2["name"].." "..Identity2["name2"].."**."
                })

                local x,y,z = vCLIENT.GetPosition(SelectedPassport)
                PerformHttpRequest(Config["Webhooks"]["ChangeName"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "**Troca de Nome**",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..Identity["name"].." "..Identity["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..OldName.." **#"..SelectedPassport.."** ",
                                },
                                { 
                                    name = "✨ Antigo Nome:", 
                                    value = " "..OldName.."",
                                },
                                { 
                                    name = "✨ Novo Nome:", 
                                    value = "" ..Identity2["name"].." "..Identity2["name2"].."",
                                },
                                { 
                                    name = "🌐 Coordenada do Jogador:", 
                                    value = ""..x..","..y..","..z.." \n \n " 
                                },
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })
            end

            return true
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 7000)
        end
    else
        TriggerClientEvent("Notify", Source, "vermelho", "Você precisa colocar um Passaporte!", 7000)
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AlllJobsList()
    local Source = source
    local Passport = vRP.Passport(Source)
    local JobsListTable = {}

    if Passport then
        local AllGroups = vRP.Groups()
        local Identity = vRP.Identity(Passport)
    
        for JobName,Ignore in pairs(AllGroups) do
            table.insert(JobsListTable, {user_id = Passport, nome = Identity["name"].." ".. Identity["name2"], emprego = JobName, empregotitle = JobName})
        end
    end

    return JobsListTable
end

function Creative.SelectedPassportJobsList(SelectedPassport)
    local Source = source
    local Passport = vRP.Passport(Source)
    local JobsListTable = {}
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        local Identity = vRP.Identity(SelectedPassport)
        local AllGroups = vRP.Groups()
        local Jobs = false
    
        for JobName,_ in pairs(AllGroups) do
            local DataGroup = vRP.DataGroups(JobName)
    
            if DataGroup[tostring(SelectedPassport)] then
                Jobs = true
                table.insert(JobsListTable, {
                    user_id = SelectedPassport,
                    nome = Identity["name"].." "..Identity["name2"],
                    emprego = JobName,
                    empregotitle = JobName
                })
            end
        end

        if not Jobs then
            table.insert(JobsListTable, {
                user_id = SelectedPassport,
                nome = Identity["name"].." "..Identity["name2"],
                emprego = nil,
                empregotitle = nil
            })
        end
    end

    return JobsListTable
end

function Creative.SetNewJobSelectedPassport(SelectedPassport, JobName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageGroups"][1], Config["Perms"]["ManageGroups"][2]) then
            vRP.SetPermission(SelectedPassport, JobName)

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog and IdentityAffected then
                table.insert(PainelLogs, { 
                    user_id = Passport, 
                    cor = "amarelo", 
                    nome = IdentityLog["name"].." "..IdentityLog["name2"], 
                    motivo = "Adicionou um novo grupo ["..JobName.."] no passaporte ["..SelectedPassport.."]." 
                })

                PerformHttpRequest(Config["Webhooks"]["SetNewPermission"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "Player adicionado no grupo: "..JobName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = "" ..IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."** ",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = "" ..IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."** ",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

                TriggerClientEvent("Notify", Source, "verde", "Você adicionou o passaporte "..SelectedPassport.." ao grupo "..JobName..".", 7000)
                return true
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 7000)
        end
    end

    return false
end

function Creative.DeleteSelectedJobPassport(SelectedPassport, JobName)
    local Source = source
    local Passport = vRP.Passport(Source)
    local SelectedPassport = parseInt(SelectedPassport)

    if Passport then
        if vRP.HasPermission(Passport, Config["Perms"]["ManageGroups"][1], Config["Perms"]["ManageGroups"][2]) then
            vRP.RemovePermission(SelectedPassport, JobName)

            local IdentityLog = vRP.Identity(Passport)
            local IdentityAffected = vRP.Identity(SelectedPassport)
            if IdentityLog and IdentityAffected then
                table.insert(PainelLogs, { 
                    user_id = Passport, 
                    cor = "amarelo", 
                    nome = IdentityLog["name"].." "..IdentityLog["name2"], 
                    motivo = "Removeu um grupo ["..JobName.."] no passaporte ["..SelectedPassport.."]." 
                })

                PerformHttpRequest(Config["Webhooks"]["RemovePermission"], function(err, text, headers) end, "POST", json.encode({
                    embeds = {
                        {     
                            title = "Player removido do grupo: "..JobName.."",
                            fields = {
                                { 
                                    name = "📝 Author:", 
                                    value = IdentityLog["name"].." "..IdentityLog["name2"].." **#"..Passport.."**",
                                },
                                { 
                                    name = "📝 Jogador:", 
                                    value = IdentityAffected["name"].." "..IdentityAffected["name2"].." **#"..SelectedPassport.."**",
                                }
                            }, 
                            footer = { 
                                text = os.date("Dia: %d/%m/%Y - Horas: %H:%M:%S"),
                                icon_url = Config["Webhooks"]["DiscordImageFooter"]
                            },
                            thumbnail = { 
                                url = Config["Webhooks"]["DiscordImageThumbanil"]
                            },
                            color = 3092790
                        }
                    }
                }), { ["Content-Type"] = "application/json" })

                TriggerClientEvent("Notify", Source, "verde", "Você removeu o passaporte "..SelectedPassport.." do grupo "..JobName..".", 7000)
                return true
            end
        else
            TriggerClientEvent("Notify", Source, "vermelho", "Você não tem permissão!", 7000)
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANÚNCIOS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetAnunciosLogs()
    return anunciosLogs
end

function Creative.CriarAnuncio(modo, extra, mensagem)
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local NomeAdmin = Identity.name .. " " .. Identity.name2
    local data = os.date("%d/%m/%Y (%H:%M)")
    local finalMessage = mensagem .. "<br></br>Enviado por: " .. NomeAdmin
    local novoId = #anunciosLogs + 1
    local destinatario = nil
    local organizacao = nil

    if modo == "Todos" then
        destinatario = "Todos"
        TriggerClientEvent("Notify", -1, "azul", finalMessage, 30000)

    elseif modo == "Individual" then
        local targetId = parseInt(extra)
        destinatario = targetId
        if targetId > 0 then
            local targetSource = vRP.Source(targetId)
            if targetSource then
                TriggerClientEvent("Notify", targetSource, "azul", finalMessage, 30000)
            end
        end

    elseif modo == "Permissao" then
        organizacao = extra
        local playersInService, _ = vRP.NumPermission(extra)
        for passport, tSource in pairs(playersInService) do
            if tSource then
                TriggerClientEvent("Notify", tSource, "azul", finalMessage, 30000)
            end
        end
    end

    table.insert(anunciosLogs, {
        id = novoId,
        admin = NomeAdmin,
        mensagem = mensagem,
        data = data,
        modo = modo,
        destinatario = destinatario,
        organizacao = organizacao
    })

    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Spectate[Passport] then
		Spectate[Passport] = nil
	end
end)