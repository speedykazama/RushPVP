-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("Night_AdminV2",Creative)
vSERVER = Tunnel.getInterface("Night_AdminV2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local StaffOpenPainel = false
local ItemCatchName = "nada"
local VehicleCatchName = "nada"
local SelectedPassportActions = 0
local SelectedCasaNameActions = nil
local SelectedCarNameActions = ""
local SelectedChestOrganization = ""
local OrganizationSelectedManagePart = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERCOMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.RegisterCommand, function()
    if not StaffOpenPainel then
        if vSERVER.CheckPermission() then
            NetworkSetInSpectatorMode(false)

            local Nome, Sobrenome, Imagem = vSERVER.ReturnNames()
            local Players2, Police2, Ilegal2, Staff2 = vSERVER.ReturnServices()
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "showMenu",
                nome = Nome,
                sobrenome = Sobrenome,
                imagem = Imagem,

                players = Players2,
                police = Police2,
                ilegal = Ilegal2,
                staff = Staff2
            }) 

            StartScreenEffect("MenuMGSelectionIn", 0, true)
			vRP.CreateObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,60309)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STAFFCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("staffClose",function(data)
	vRP.Destroy()
	SetNuiFocus(false,false)
	StopScreenEffect("MenuMGSelectionIn")
	StaffOpenPainel = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetPosition()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
	return x,y,z
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CoordsLista",function(Data,CallBack,imgperfil)
	local TeleportList = vSERVER.ConsultCoordsList()
	if TeleportList then
		CallBack({ teleporteslista = TeleportList })
	end
end)

RegisterNUICallback("teleport",function(Data,CallBack)
	local Ped = PlayerPedId()
	SetEntityCoords(Ped, tonumber(Data["x"]), tonumber(Data["y"]), tonumber(Data["z"]))
end)

RegisterNUICallback("addteleport",function(Data,CallBack)
	if vSERVER.AddTeleport(Data["nome"],Data["coord"]) then
		CallBack({retorno = "done"})
	end
end)

RegisterNUICallback("deleteteleport",function(Data,CallBack)
	if vSERVER.DeleteTeleport(Data["id"],Data["nome"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("LogsLista",function(Data,CallBack)
	local LogsList = vSERVER.ReturnLogsList()
	if LogsList then
		CallBack({ logslista = LogsList })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USUÁRIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ControleLista",function(Data,CallBack)
	local PlayersList = vSERVER.ReturnPlayerList()
	if PlayersList then
		CallBack({ controlelista = PlayersList })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUNIÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PunicoesLista",function(Data,CallBack)
	local Warnings = vSERVER.SeeInformationsWarnings()
	if Warnings then
		CallBack({ punicoes = Warnings })
	end
end)

RegisterNUICallback("DeleteAdv",function(Data,CallBack)
	if vSERVER.DeleteAdv(Data["passaporte"], Data["status"], Data["contagem"]) then
		CallBack({ retorno = "done" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ItensLista",function(Data,CallBack)
	local ItensList = vSERVER.SeeInformationsItemList()
	if ItensList then
		CallBack({ itens = ItensList })
	end
end)

RegisterNUICallback("garagemLista",function(Data,CallBack)
	local AllVehicles = vSERVER.SeeInformationsAllVeiculos()
	if AllVehicles then
		CallBack({ garagem = AllVehicles })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANÚNCIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("AnunciosLogs", function(data, cb)
    local logs = vSERVER.GetAnunciosLogs()
    if logs then
        cb({ anunciosLogs = logs })
    end
end)

RegisterNUICallback("fazeranuncioall", function(data, cb)
    if data.textoAnuncio and data.textoAnuncio ~= "" then
        local result = vSERVER.CriarAnuncio(data.modo, data.extra, data.textoAnuncio)
        cb({ retorno = result and "done" or "error" })
    else
        cb({ retorno = "error" })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("enviarItem",function(Data,CallBack)
	ItemCatchName = Data["item"]
	CallBack({})
end)

RegisterNUICallback("enviarCarro",function(Data,CallBack)
	VehicleCatchName = Data["carro"]
	CallBack({})
end)

RegisterNUICallback("pegarItemConfirm", function(data, callback)
    local quantidade = data["quantidade"]
    local idjogador = data["idjogador"]
    local item = data["item"]

    if vSERVER.CatchItem(idjogador, quantidade, item) then
        callback({retorno = "done"})
    else
        callback({retorno = "error"})
    end
end)

RegisterNUICallback("pegarCarroConfirmar", function(Data, CallBack)
    local SelectedPassport = tonumber(Data["passaporte"])
    local modo = Data["modo"]

    if modo == "Spawnar" then
        if vSERVER.SpawnVehicle(VehicleCatchName, SelectedPassport) then
            CallBack({retorno = "done"})
        else
            CallBack({retorno = "error"})
        end
    elseif modo == "Adicionar" then
        if vSERVER.GiveVehicle(VehicleCatchName, SelectedPassport) then
            CallBack({retorno = "done"})
        else
            CallBack({retorno = "error"})
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENVIARID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("EnviarID",function(Data,CallBack)
	if Data["passaporte"] then
		SelectedPassportActions = Data["passaporte"]

		if Data["tipo"] == "SADVS" then
			local nome, sobrenome = vSERVER.GetNameByPassport(Data["passaporte"])
			CallBack({
				tipo = Data["tipo"],
				nome = nome,
				sobrenome = sobrenome,
				passaporte = Data["passaporte"]
			})
		end

		if Data["tipo"] == "VERPERFIL" then
			local carteira,banco,nome,sobrenome,registro,celular,idade,emprego,vip,coins,img,banner = vSERVER.SeeInformationsProfile(Data["passaporte"])
			CallBack({
				tipo = Data["tipo"],
				carteira = carteira,
				banco = banco,
				nome = nome,
				sobrenome = sobrenome,
				registro = registro,
				celular = celular,
				idade = idade,
				emprego = emprego,
				vip = vip,
				coins = coins,
				img = img,
				banner = banner
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PegarInv",function(Data,CallBack)
    local InventorySelected = vSERVER.ReturnInventorySelected(SelectedPassportActions)
    if InventorySelected then
        CallBack(InventorySelected)
    end
end)

RegisterNUICallback("removerItem",function(Data,CallBack)
	if vSERVER.RemoveItemSelectedInventory(SelectedPassportActions,Data["item"],Data["quantidade"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPRIEDADES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PegarCasas", function(Data, CallBack)
    local CasasList = vSERVER.ReturnSelectedCasasList(SelectedPassportActions)
    if CasasList then
        CallBack({ casas = CasasList })
    end
end)

RegisterNUICallback("removerCasa", function(data, cb)
    if data and data.casa then
        local sucesso = vSERVER.removerCasa(data.casa)
        if sucesso then
            cb({ retorno = "done" })
        else
            cb({ retorno = "error" })
        end
    else
        cb({ retorno = "error" })
    end
end)

RegisterNUICallback("verBauCasa", function(Data, CallBack)
    SelectedCasaNameActions = Data["casa"]
    CallBack({ retorno = "done" })
end)

RegisterNUICallback("verBauCasaList", function(Data, CallBack)
    local CasaChestData = vSERVER.ReturnChestCasaList(SelectedPassportActions, SelectedCasaNameActions)
    if CasaChestData then
        CallBack(CasaChestData) 
    end
end)

RegisterNUICallback("removerItemBauCasa",function(Data,CallBack)
	if vSERVER.DeleteSelectedItemChestCasa(SelectedPassportActions,SelectedCasaNameActions,Data["item"],Data["quantidade"],Data["slot"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEÍCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PegarGaragem",function(Data,CallBack)
	local SelectedGarageList = vSERVER.ReturnSelectedGarageList(SelectedPassportActions)
	if SelectedGarageList then
		CallBack(SelectedGarageList)
	end
end)

RegisterNUICallback("removerCarro",function(Data,CallBack)
	if vSERVER.DeleteVehicleSelected(SelectedPassportActions, Data["item"]) then
		CallBack({retorno = "done"})
	end
end)

RegisterNUICallback("verBauCarro",function(Data,CallBack)
	SelectedCarNameActions = Data["carro"]
	CallBack({retorno = "done"})
end)

RegisterNUICallback("verBauCarroList", function(Data, CallBack)
    local VehicleChestData = vSERVER.ReturnChestVehicleList(SelectedPassportActions, SelectedCarNameActions)
    if VehicleChestData then
        CallBack(VehicleChestData) 
    end
end)

RegisterNUICallback("removerItemBauCarro",function(Data,CallBack)
	if vSERVER.DeleteSelectedItemChestVehicle(SelectedPassportActions,SelectedCarNameActions,Data["item"],Data["quantidade"],Data["slot"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMPREGOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PegarEmpregos",function(Data,CallBack)
	local JobsList = vSERVER.SelectedPassportJobsList(SelectedPassportActions)
	if JobsList then
		CallBack({ empregos = JobsList })
	end
end)

RegisterNUICallback("addEmprego",function(data,cb)
	local JobsList = vSERVER.AlllJobsList()
	if JobsList then
		cb({ listEmprego = JobsList })
	end
end)

RegisterNUICallback("removerCargo",function(Data,CallBack)
	if vSERVER.DeleteSelectedJobPassport(SelectedPassportActions,Data["emprego"]) then
		CallBack({retorno = "done"})
	end
end)

RegisterNUICallback("confirmaremprego",function(Data,CallBack)
	if vSERVER.SetNewJobSelectedPassport(SelectedPassportActions,Data["emprego"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AÇÕES RÁPIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("opcoesRapidas",function(Data,CallBack)
	if vSERVER.FastActionsToogle(SelectedPassportActions, Data["tipo"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR NOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("trocarnome", function(Data, CallBack)
	if vSERVER.ChangeSelectedName(SelectedPassportActions, Data["PrimeiroNome"], Data["SegundoNome"]) then
		local Nome2, Sobrenome2, Imagem = vSERVER.ReturnNames()
		local Carteira, Banco, Nome, Sobrenome, Registro, Celular, Idade, Emprego, Vip, Coins, Img, Banner = vSERVER.SeeInformationsProfile(SelectedPassportActions)
		CallBack({
			retorno = "done",
			nome = Nome,
			sobrenome = Sobrenome,
			nome2 = Nome2,
			sobrenome2 = Sobrenome2
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR CARTEIRA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("trocarcarteira", function(Data, CallBack)
	if vSERVER.ChangeWalletValues(SelectedPassportActions, Data["valor"], Data["tipo"]) then
		local Nome, Sobrenome, Imagem = vSERVER.ReturnNames()
		local Carteira, Banco, Nome2, Sobrenome2, Registro, Celular, Idade, Emprego, Vip, Coins, Img, Banner = vSERVER.SeeInformationsProfile(SelectedPassportActions)
		CallBack({ retorno = "done", carteira = Carteira })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR BANCO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("trocarbanco", function(Data, CallBack)
	if vSERVER.ChangeBankValues(SelectedPassportActions, Data["valor"], Data["tipo"]) then
		local Nome, Sobrenome, Imagem = vSERVER.ReturnNames()
		local Carteira, Banco, Nome2, Sobrenome2, Registro, Celular, Idade, Emprego, Vip, Coins, Img, Banner = vSERVER.SeeInformationsProfile(SelectedPassportActions)
		CallBack({ retorno = "done", banco = Banco })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR COINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("trocarcoins", function(Data, CallBack)
    if vSERVER.ChangeCoinsValues(SelectedPassportActions, Data["valor"], Data["tipo"]) then
        local Nome, Sobrenome, Imagem = vSERVER.ReturnNames()
        local Carteira, Banco, Nome2, Sobrenome2, Registro, Celular, Idade, Emprego, Vip, Coins, Img, Banner = vSERVER.SeeInformationsProfile(SelectedPassportActions)
        CallBack({ retorno = "done", coins = Coins })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR CELULAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("trocarcelular",function(Data,CallBack)
	if vSERVER.ChangeNumberPhoneSelected(SelectedPassportActions,Data["celularnovo"]) then
		local Nome, Sobrenome, Imagem = vSERVER.ReturnNames()
		local Carteira, Banco, Nome2, Sobrenome2, Registro, Celular, Idade, Emprego, Vip, Coins, Img, Banner = vSERVER.SeeInformationsProfile(SelectedPassportActions)
		CallBack({retorno = "done",celular = Celular})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCREENSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ScreenShotAction(ScreenShotLib,ScreenShotID)
	exports['screenshot']:requestScreenshotUpload(ScreenShotLib, "files[]", function(data)
	local ScreenShotURL = json.decode(data)["attachments"][1]["url"]
	vSERVER.AddScreenShot(ScreenShotURL, ScreenShotID)
	end)
end

RegisterNUICallback("screenshot",function(Data,CallBack)
	if SelectedPassportActions then
		local ImageReturn,Ignore = vSERVER.TakeScreenshot(parseInt(SelectedPassportActions))
		CallBack({retorno = "done", imagem = ImageReturn})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENVIAR MENSAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("enviarMensagem",function(Data,CallBack)
	if vSERVER.SendMessageStaff(SelectedPassportActions, Data["mensagem"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("skinsLista",function(Data,CallBack)
	local SkinsList = vSERVER.ReturnSkinsList()
	if SkinsList then
		CallBack({ skins = SkinsList })
	end
end)

RegisterNUICallback("setarSkin",function(Data,CallBack)
	if vSERVER.SetSkinStaff(SelectedPassportActions, Data["set"]) then
		CallBack({retorno = "done"})
	end
end)

RegisterNetEvent("skinmenuwn")
AddEventHandler("skinmenuwn",function(mhash)
    while not HasModelLoaded(mhash) do
        RequestModel(mhash)
        Citizen.Wait(10)
    end

    if HasModelLoaded(mhash) then
        SetPlayerModel(PlayerId(),mhash)
        SetModelAsNoLongerNeeded(mhash)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAÚ FACS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RegisterBauFac",function(Data,CallBack)
	SelectedChestOrganization = Data["bau"]
	CallBack({retorno = "done"})
end)

RegisterNUICallback("bausfacLista",function(Data,CallBack)
	local OrganizationsChestList = vSERVER.ReturnChestOrganizationsList()
	if OrganizationsChestList then
		CallBack({ bausfac = OrganizationsChestList })
	end
end)

RegisterNUICallback("verbausfacLista",function(Data,CallBack)
	local SelectedChestList = vSERVER.ReturnChestOrganizationSelected(SelectedChestOrganization)
	if SelectedChestList then
		CallBack({ verbausfac = SelectedChestList })
	end
end)

RegisterNUICallback("removerItemBauFac",function(Data,CallBack)
	if vSERVER.DeleteItemChestOrganization(SelectedChestOrganization,Data["item"],Data["quantidade"],Data["slot"]) then
		CallBack({retorno = "done"})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RegisterGroup",function(Data,CallBack)
	OrganizationSelectedManagePart = Data["empresa"]
	CallBack({retorno = "done"})
end)

RegisterNUICallback("verGrousList",function(Data,CallBack)
	local AllGroupsReturn = vSERVER.ReturnAllGroupsList()
	if AllGroupsReturn then
		CallBack({ groups = AllGroupsReturn })
	end
end)

RegisterNUICallback("verPlayersGroup",function(Data,CallBack)
	local PlayersFromOrganization = vSERVER.ReturnOrganizationListSelected(OrganizationSelectedManagePart)
	if PlayersFromOrganization then
		CallBack({ verPlayersGroup = PlayersFromOrganization })
	end
end)

RegisterNUICallback("gerenciarGrupos",function(Data,CallBack)
	vSERVER.ManageSelectedGroups(Data["passaporte"], OrganizationSelectedManagePart, Data["tipo"]) 
	CallBack({retorno = "done"})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUNIÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("addBan", function(Data, CallBack)
    local motivo = Data["motivo"]
    local tempoDias = tonumber(Data["tempo"])
    if tempoDias and motivo and vSERVER.AddBan(motivo, SelectedPassportActions, tempoDias) then
        CallBack({retorno = "done"})
    else
        CallBack({retorno = "error"})
    end
end)

RegisterNUICallback("addKick",function(Data,CallBack)
	if vSERVER.AddKick(Data["motivo"],SelectedPassportActions) then
		CallBack({retorno = "done"})
	end
end)

RegisterNUICallback("addAdv", function(Data, CallBack)
    if vSERVER.AddWarning(Data["motivo"], SelectedPassportActions, tonumber(Data["tempo"])) then
        CallBack({retorno = "done"})
    else
        CallBack({retorno = "error"})
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREAVEHICLE2
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateVehicle2(Model, Network, Engine, Health, Customize, Windows, Tyres, Vehicle, PlayerSource)
    if NetworkDoesNetworkIdExist(Network) then
        local Veh = NetToEnt(Network)
        if not DoesEntityExist(Veh) then return end

        if Customize then
            local Mods = json.decode(Customize)
            VehicleMods(Veh, Mods)
        end

        SetVehicleEngineHealth(Veh, Engine + 0.0)
        SetEntityHealth(Veh, Health)

        if Windows then
            local WindowsTable = json.decode(Windows)
            for k,v in pairs(WindowsTable or {}) do
                if not v then RemoveVehicleWindow(Veh, tonumber(k)) end
            end
        end

        if Tyres then
            local TyresTable = json.decode(Tyres)
            for k,Burst in pairs(TyresTable or {}) do
                if Burst then SetVehicleTyreBurst(Veh, tonumber(k), true, 1000.0) end
            end
        end

        if not DecorExistOn(Veh, "PlayerVehicle") then
            DecorSetInt(Veh, "PlayerVehicle", -1)
        end

        if PlayerSource == GetPlayerServerId(PlayerId()) then
            local Ped = PlayerPedId()
            SetPedIntoVehicle(Ped, Veh, -1)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINEL:REPAIRADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Painel:repairAdmin")
AddEventHandler("Painel:repairAdmin",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				local Fuel = GetVehicleFuelLevel(Vehicle)

				SetVehicleFixed(Vehicle)
				SetVehicleDeformationFixed(Vehicle)

				SetVehicleFuelLevel(Vehicle,Fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TACKLEADMIN:START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("TackleAdmin:Start")
AddEventHandler("TackleAdmin:Start",function()
	local Coords = GetEntityForwardVector(PlayerPedId())
	SetPedToRagdollWithFall(PlayerPedId(),10000,10000,0,Coords[1],Coords[2],Coords[3],10.0,0.0,0.0,0.0,0.0,0.0,0.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTENTITY:FIRE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("StartEntity:Fire")
AddEventHandler("StartEntity:Fire",function()
	StartEntityFire(PlayerPedId())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECATE
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Spectate"] = false

RegisterNetEvent("InitSpectate:Admin")
AddEventHandler("InitSpectate:Admin",function(source)
	if not NetworkIsInSpectatorMode() then
		local Pid = GetPlayerFromServerId(source)
		local Ped = GetPlayerPed(Pid)

		LocalPlayer["state"]["Spectate"] = true
		NetworkSetInSpectatorMode(true,Ped)
	end
end)

RegisterNetEvent("ResetSpect:Admin")
AddEventHandler("ResetSpect:Admin",function()
	if NetworkIsInSpectatorMode() then
		NetworkSetInSpectatorMode(false)
		LocalPlayer["state"]["Spectate"] = false
	end
end)