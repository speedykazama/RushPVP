-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Commands"] = true                        -- Se for false, comandos estão desativados. se for true, comandos estão ativados.
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Noclip = {}
local Blips = {}
local StaffList = {} 

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawn = {}
local Signal = {}
local Searched = {}
local Propertys = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Plates"] = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local WebhookLink = "https://discord.com/api/webhooks/1450704176949628928/JBehrb_zTBq3p06lAgBJhQRTgQPB_2zHnXy_Seb9YVMgWTRENIlNLmEAucx0geSH8sv5" 
local StaffTimeCount = {} 
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO — LOCAIS RÁPIDOS (nome → coordenadas)
-----------------------------------------------------------------------------------------------------------------------------------------
TptoQuickLocations = {
	["paleto"] = { 1425.45, 6531.99, 16.85 },
	["docas"] = { 382.87, -2175.77, 15.05 },
	["samir"] = { 1364.84, -578.94, 74.37 },
	["pier"] = { -1623.92, -1001.64, 13.04 },
	["aeroporto trevor"] = { 1286.71, 3129.68, 40.44 },
	["aeroportotrevor"] = { 1286.71, 3129.68, 40.44 }
}

function AdminTptoResolveLocation(input)
	if not input then return nil end
	local key
	if type(input) == "table" then
		if not input[1] or tostring(input[1]) == "" then return nil end
		local parts = {}
		for i = 1, #input do
			local w = tostring(input[i] or ""):lower():match("^%s*(.-)%s*$") or ""
			if w ~= "" then parts[#parts + 1] = w end
		end
		key = table.concat(parts, " ")
	else
		key = tostring(input):lower():gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
	end
	if key == "" then return nil end
	local c = TptoQuickLocations[key]
	if not c then
		c = TptoQuickLocations[key:gsub("%s+", "")]
	end
	if c then
		return c[1], c[2], c[3], key
	end
	return nil
end

local function FormatDuration(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    
    if h > 0 then
        return string.format("%d horas, %d minutos e %d segundos", h, m, s)
    elseif m > 0 then
        return string.format("%d minutos e %d segundos", m, s)
    else
        return string.format("%d segundos", s)
    end
end


local function SendWebhook(title, message, color)
    if WebhookLink == "" then return end
    
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. title .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = os.date("%d/%m/%Y | %H:%M:%S"),
            },
        }
    }

    PerformHttpRequest(WebhookLink, function(err, text, headers) end, 'POST', json.encode({username = "Sistema de Staff", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local function CleanTags(text)
    return text:gsub("~%w~", ""):gsub("%[", ""):gsub("%]", "")
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO DE DESCONEXÃO (CORREÇÃO)
-- Este evento garante que a variável é limpa quando o jogador sai da cidade.
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped", function(reason)
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport and StaffList[Passport] then
        -- Limpa a lista para que, ao voltar, ele tenha de dar /staff para entrar de novo
        StaffList[Passport] = nil
        
        -- Limpa outras tabelas auxiliares
        if StaffTimeCount[Passport] then StaffTimeCount[Passport] = nil end
        if Noclip[Passport] then Noclip[Passport] = nil end

        -- Log opcional de saída forçada
        print("^3[STAFF] O passaporte " .. Passport .. " desconectou-se em modo staff. Resetado.^7")
        
        local msg = "**ID:** " .. Passport .. "\n**Ação:** Desconectou-se enquanto estava em modo Staff (Variáveis Resetadas)."
        SendWebhook("Staff Log - Disconnect", msg, 16711680)
    end
end)


RegisterCommand("staff", function(source, args)
    local Passport = vRP.Passport(source)
    if Passport then
        local identity = vRP.Identity(Passport) 
        local nome = identity.name .. " " .. identity.name2
        local staffLabel = nil

        if vRP.HasGroup(Passport, "Admin", 1) then
            staffLabel = "[~r~STAFF ~w~ON~r~]"
        elseif vRP.HasGroup(Passport, "Admin", 2) then
            staffLabel = "[~r~STAFF ~w~ON~r~]"
        elseif vRP.HasGroup(Passport, "Admin", 3) then
            staffLabel = "[~r~STAFF ~w~ON~r~]"
        elseif vRP.HasGroup(Passport, "Admin", 4) then
            staffLabel = "[~r~STAFF ~w~ON~r~]"
        elseif vRP.HasGroup(Passport, "Admin", 5) then
            staffLabel = "[~r~STAFF ~w~ON~r~]"
        end

        if staffLabel then
            local cargoLimpo = CleanTags(staffLabel) 

            -- SE NÃO ESTIVER NA LISTA (ENTRAR)
            if not StaffList[Passport] then
                StaffList[Passport] = true
                StaffTimeCount[Passport] = os.time()
                
                Player(source).state:set("StaffTime", staffLabel, true)
                Player(source).state:set("ThanosActive", true, true)
                
                vRP.UpgradeThirst(Passport, 100)
                vRP.UpgradeHunger(Passport, 100)
                vRP.DowngradeStress(Passport, 100)
                vRP.Revive(source, 400)

                TriggerClientEvent("admin:StaffEffect", -1, source)

                -- [[ MENSAGEM GLOBAL (-1) ]] --
               TriggerClientEvent("Notify", 1, "verde", "O Staff <b>" .. nome .. " (" .. Passport .. ")</b> entrou em serviço.", 10000)

                local msg = "**ID:** " .. Passport .. "\n**Nome:** " .. nome .. "\n**Cargo:** " .. cargoLimpo .. "\n**Ação:** Iniciou serviço."
                SendWebhook("Staff Log - Entrada", msg, 65280)

            -- SE JÁ ESTIVER NA LISTA (SAIR)
            else

                if Player(source).state.WallActive then
                    TriggerClientEvent("Notify", source, "negado", "Não podes sair do Staff com o <b>WALL</b> ligado! Desliga-o primeiro.", 6000)
                    return 
                end

                if Player(source).state.NoclipActive then
                    TriggerClientEvent("Notify", source, "negado", "Não podes sair do Staff com o <b>NOCLIP</b> ligado! Desliga-o primeiro.", 6000)
                    return 
                end

                StaffList[Passport] = nil
                
                Player(source).state:set("StaffTime", nil, true)
                Player(source).state:set("ThanosActive", false, true)

                if Noclip[Passport] then
                    Noclip[Passport] = false
                    vRPC.noClip(source, false)
                    Player(source).state:set("NoclipActive", false, true)
                end

                TriggerClientEvent("admin:StaffEffect", 1, source)
                
                -- [[ MENSAGEM GLOBAL (1) ]] --
                TriggerClientEvent("Notify", 1, "vermelho", "O Staff <b>" .. nome .. " (" .. Passport .. ")</b> saiu de serviço.", 10000)

                local tempoDecorrido = "Tempo desconhecido"
                if StaffTimeCount[Passport] then
                    local segundos = os.time() - StaffTimeCount[Passport]
                    tempoDecorrido = FormatDuration(segundos)
                    StaffTimeCount[Passport] = nil 
                end

                local msg = "**ID:** " .. Passport .. "\n**Nome:** " .. nome .. "\n**Cargo:** " .. cargoLimpo .. "\n**Ação:** Terminou serviço.\n**Tempo em Staff:** " .. tempoDecorrido
                SendWebhook("Staff Log - Saída", msg, 16711680)
            end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão.", 5000)
        end
    end
end)

function isStaffActive(Passport)
    if StaffList[Passport] then
        return true
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- USOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("usource",function(source,Message)
	local Passport = vRP.Passport(source)
	local OtherSource = parseInt(Message[1])
	if Passport and GlobalState["Commands"] and OtherSource and OtherSource > 0 and vRP.Passport(OtherSource) and vRP.HasGroup(Passport,"Admin") then
		if StaffList[Passport] then
			if not StaffList[Passport] then
				TriggerClientEvent("Notify",source,"azul","<b>Passaporte:</b> "..vRP.Passport(OtherSource),5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blackout", function(source, args)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				if GlobalState["Blackout"] then
					GlobalState["Blackout"] = false
					TriggerClientEvent("Notify",source,"amarelo","Modo blackout desativado.",5000)
				else
					GlobalState["Blackout"] = true
					TriggerClientEvent("Notify",source,"verde","Modo blackout ativado.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
			end
		end
	end
end)	
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("deleteall", function(source, Message, rawCmd)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
		if not vRP.HasGroup(Passport, "Admin",2) then
			return
		end

		if not Message[1] then
			return
		end

		if StaffList[Passport] then

			if Message[1] == "objects" then
				for _, item in pairs(GetAllObjects()) do
					DeleteEntity(item)
				end
				vRPC.removeObjects(source)
				vRPC.removeActived(source)
				TriggerClientEvent("Notify", source, "amarelo", "Todos os objetos foram <b>DELETADOS</b> com sucesso", 10000)
				TriggerEvent("Discord", "DeleteAll", "**[Deletar Todos os Objetos]**\n\n**Passaporte:** " .. Passport .. "\n**Tipo:** Objetos\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			elseif Message[1] == "npcs" then
				for _, pedHandle in pairs(GetAllPeds()) do
					DeleteEntity(pedHandle)
				end
				TriggerClientEvent("Notify", source, "amarelo", "Todos os npcs foram <b>DELETADOS</b> com sucesso", 10000)
				TriggerEvent("Discord", "DeleteAll", "**[Deletar Todos os NPCs]**\n\n**Passaporte:** " .. Passport .. "\n**Tipo:** NPCs\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			elseif Message[1] == "vehicles" then
				local vehicles = GetAllVehicles()
				for _, vehicle in pairs(vehicles) do
					local driver = GetPedInVehicleSeat(vehicle, -1)
					if not driver or driver == 0 then
						DeleteEntity(vehicle)
					end
				end
				TriggerClientEvent("Notify", source, "amarelo", "Todos os veículos foram <b>DELETADOS</b> com sucesso", 10000)
				TriggerEvent("Discord", "DeleteAll", "**[Deletar Todos os Veículos]**\n\n**Passaporte:** " .. Passport .. "\n**Tipo:** Veículos\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limpararea", function(source, args)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin",2) then
			if StaffList[Passport] then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				vCLIENT.Limparea(source, Coords)
				TriggerClientEvent("Notify", source, "vermelho", "Area Limpa.", 5000)
				TriggerEvent("Discord", "LimparArea", "**[Limpar Área]**\n\n**Passaporte:** " .. Passport .. "\n**Coordenadas:** " .. Coords.x .. ", " .. Coords.y .. ", " .. Coords.z .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			else
            	TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUNDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mundo", function(source, args)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport, "Admin", 3) then
			if StaffList[Passport] then
				if #args == 2 then
					local targetPlayerId = tonumber(args[1])
					local routingBucket = tonumber(args[2])
					if targetPlayerId and routingBucket then
						SetPlayerRoutingBucket(targetPlayerId, routingBucket)
						local notification = " Jogador: " .. targetPlayerId .. " definido para a dimensão: " .. routingBucket
						TriggerClientEvent("Notify", source, "verde", notification,10000)
						TriggerEvent("Discord", "Mundo", "**[Mudança de Dimensão]**\n\n**Passaporte Executor:** " .. Passport .. "\n**Jogador Alvo:** " .. targetPlayerId .. "\n**Nova Dimensão:** " .. routingBucket .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
					else
						TriggerClientEvent("Notify", source, "vermelho", "Use /mundo [ID] [NÚMERO]",7500)
					end
				else
					TriggerClientEvent("Notify", source, "vermelho", "Use /mundo [ID] [NÚMERO]",10000)
				end
			end
		else
			TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para usar este comando.",7500)
		end
	end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pon",function(source,args,rawCommand)
    local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport, "Admin",5) then
			if StaffList[Passport] then
				local users = vRP.Players()
				local players = ""
				local quantidade = 0
				for k,v in pairs(users) do
					if k ~= #users then
						players = players..", "
					end
					players = players..k
					quantidade = quantidade + 1
				end
				TriggerClientEvent("Notify",source,"amarelo","TOTAL ONLINE : <b>"..quantidade.."</b><br>ID's ONLINE : <b>"..players.."</b>",5000)
			end
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cam",function(source)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				TriggerClientEvent("freecam:Active",source)
			end
		else
			TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para usar este comando.",7500)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETCHAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("resetchar",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		local OtherPassport = parseInt(Message[1])
		if vRP.HasGroup(Passport,"Admin",1) and OtherPassport > 0 then
			if StaffList[Passport] then
				local Creator = vRP.UserData(Passport,"Creator")
				if Creator == 1 then
					vRP.Query("playerdata/SetData",{ Passport = OtherPassport, dkey = "Creator", dvalue = 0 })	
					TriggerClientEvent("Notify",source,"verde","Reset concluído.",5000)		
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addback",function(source,args,rawCommand)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] and args[1] then
        if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				local OtherPassport = parseInt(args[1])
				local PesoBack = parseInt(args[2])
				vRP.SetWeight(OtherPassport,PesoBack)
				TriggerClientEvent("Notify",source,"verde","Mochila adicionado para <b>"..OtherPassport.."</b> em "..PesoBack.."KG.",5000)
				TriggerEvent("Discord","Addback","**[Adicionou KG na Mochila]**\n\n**Passaporte:** "..Passport.."\n**Para o ID :** "..args[1].."\n**Kilos Setados :** "..args[2].."kg \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMBACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remback",function(source,args,rawCommand)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] and args[1] then
        if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				local OtherPassport = parseInt(args[1])
				local PesoBack = parseInt(args[2])
				vRP.RemoveWeight(OtherPassport,PesoBack)
				TriggerClientEvent("Notify",source,"verde","Mochila removida de <b>"..OtherPassport.."</b> em "..PesoBack.."KG.",5000)
				TriggerEvent("Discord","Remback","**[Removeu KG da Mochila]**\n\n**Passaporte:** "..Passport.."\n**Retirou do ID :** "..args[1].."\n**Kilos Retirados :** "..args[2].."kg \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALGEMAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("algemar", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] and Message[1] then
        if vRP.HasGroup(Passport, "Admin", 5) then
			if StaffList[Passport] then
				local OtherPassport = tonumber(Message[1])
				local PlayerState = Player(OtherPassport)

				if PlayerState then
					if PlayerState["state"]["Handcuff"] then
						PlayerState["state"]["Handcuff"] = false
						vRPC.stopAnim(source,true)
						TriggerClientEvent("Notify", source, "verde", "Você desalgemou o jogador com ID " .. OtherPassport, 5000)
						TriggerEvent("Discord", "Algemar", "**[Desalgemou o Jogador]**\n\n**Passaporte Executor:** " .. Passport .. "\n**Passaporte Desalgemado:** " .. OtherPassport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
					else
						PlayerState["state"]["Handcuff"] = true
						TriggerClientEvent("radio:RadioClean",OtherPassport)
						TriggerClientEvent("Notify", source, "verde", "Você algemou o jogador com ID " .. OtherPassport, 5000)
						TriggerEvent("Discord", "Algemar", "**[Algemou o Jogador]**\n\n**Passaporte Executor:** " .. Passport .. "\n**Passaporte Algemado:** " .. OtherPassport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
					end
					TriggerClientEvent("sounds:source", source, "cuff", 0.5)
				else
					TriggerClientEvent("Notify", source, "vermelho", "ID do jogador inválido.", 5000)
				end
			end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para usar este comando.", 5000)
        end
    else
        TriggerClientEvent("Notify", source, "vermelho", "Você não possui um passaporte válido para usar este comando.", 5000)
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addcar",function(source,Message)
	local source = source
	local Passport = vRP.Passport(source)
	local Sources = vRP.Source(Message[1])
	if vRP.HasGroup(Passport,"Admin",1) then
		if StaffList[Passport] then
			if Passport and GlobalState["Commands"] and Message[1] and Message[2] then
				vRP.Query("vehicles/addVehicles",{ Passport = parseInt(Message[1]), vehicle = Message[2], plate = vRP.GeneratePlate(), work = tostring(false) })
				TriggerClientEvent("Notify",source,"verde","Adicionado o veiculo <b>"..Message[2].."</b> na garagem de ID <b>"..Message[1].."</b>.",10000)
				TriggerClientEvent("Notify",Sources,"verde","Adicionado o veiculo <b>"..Message[2].."</b> em sua garagem<b> .",10000)
				TriggerEvent("Discord","Addcar","**[Adicionou veículo na Garagem]**\n\n**Passaporte:** "..Passport.."\n**Adicionou Carro :** "..Message[2].."\n**Na Garagem do ID :** "..Message[1].." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remcar",function(source,Message)
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport,"Admin",1) then
		if StaffList[Passport] then
			if Passport and GlobalState["Commands"] and Message[1] and Message[2] then
				vRP.Query("vehicles/removeVehicles",{ Passport = parseInt(Message[1]), vehicle = Message[2]})
				TriggerClientEvent("Notify",source,"verde","Retirado o veiculo <b>"..Message[2].."</b> da garagem de ID <b>"..Message[1].."</b>.",10000)
				TriggerEvent("Discord","Remcar","**[Removeu veículo na Garagem]**\n\n**Passaporte:** "..Passport.."\n**Retirou Carro :** "..Message[2].."\n**Da Garagem do ID :** "..Message[1].." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anuncio", function(source, args)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        local identity = vRP.Identity(source)
        if vRP.HasGroup(Passport, "Admin", 4) then
			if StaffList[Passport] then
				local message = vKEYBOARD.keyDouble(source, "Mensagem:", "Moderador:")
				if message and message[1] and message[2] then
					local finalMessage = message[1] .. "<br></br>Enviada Por: " .. message[2]
					TriggerClientEvent("Notify", -1, "azul", finalMessage .. "</b>", 45000)

					TriggerEvent("Discord", "Aviso-admin", "**[Aviso Admin]**\n\n**Passaporte:** " .. Passport .. "\n**Mensagem:** " .. message[1] .. "\n**Moderador:** " .. message[2] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				else
					TriggerClientEvent("Notify", source, "vermelho", "A mensagem não pode estar vazia.", 5000)
				end
			else
				TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissões para isso.", 5000)
			end
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("chatanuncio",function(source)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",4) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keyArea(source,"Anúncio:")
				if Keyboard then
					local Messages = Keyboard[1]:gsub("[<>]", "")
					TriggerClientEvent("chat:ClientMessage", -1, "Prefeitura", Messages, "Anúncio")
					TriggerEvent("Discord", "Aviso-admin", "**[Aviso Admin]**\n\n**Passaporte:** " .. Passport .. "\n**Mensagem:** " .. Messages .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				end
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("debug",function(source)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				TriggerClientEvent("admin:ToggleDebug",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODMAIL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("modmail",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",3) and parseInt(Message[1]) > 0 then
			if StaffList[Passport] then
				local OtherPassport = parseInt(Message[1])
				local ClosestPed = vRP.Source(OtherPassport)
				if ClosestPed then
					local Keyboard = vKEYBOARD.keyTertiary(source,"Mensagem:","Cor:","Tempo (em MS):")
						if Keyboard then
						TriggerClientEvent("Notify",ClosestPed,Keyboard[2],Keyboard[1],Keyboard[3])
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ugroups",function(source,Message)
	local Passport = vRP.Passport(source)
	if StaffList[Passport] then
		if Passport and GlobalState["Commands"] and parseInt(Message[1]) > 0 then
			local Messages = ""
			local Groups = vRP.Groups()
			local OtherPassport = Message[1]
			for Permission,_ in pairs(Groups) do
				local Data = vRP.DataGroups(Permission)
				if Data[OtherPassport] then
					Messages = Messages..Permission.."<br>"
				end
			end

			if Messages ~= "" then
				TriggerClientEvent("Notify",source,"verde",Messages,30000)
			end
		end
	else
		TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		local OtherPassport = parseInt(Message[1])
		if vRP.HasGroup(Passport,"Admin",3) and OtherPassport > 0 then
			if StaffList[Passport] then
				TriggerClientEvent("Notify",source,"verde","ID: <b>"..Message[1].."</b> Liberado <b>",5000)
				vRP.Query("accounts/updateWhitelist",{ id = Message[1], whitelist = 1 })
				TriggerEvent("Discord","wl","**[Liberou whitelist]**\n\n**Passaporte:** "..Passport.."\n**Aprovou ID:** "..Message[1] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unwl", function(source, Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		local OtherPassport = parseInt(Message[1])
		if vRP.HasGroup(Passport,"Admin",1) and OtherPassport > 0 then
			if StaffList[Passport] then
				TriggerClientEvent("Notify",source,"verde","ID: <b>"..Message[1].."</b> Removido <b>",5000)
				vRP.Query("accounts/updateWhitelist", { id = Message[1], whitelist = 0 })
				TriggerEvent("Discord","unwl","**[Removeu whitelist]**\n\n**Passaporte:** " .. Passport .. "\n**Para:** " .. Message[1] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearinv",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) and parseInt(Message[1]) > 0 then
			if StaffList[Passport] then
				if vRP.Request(source,"Deseja Limpar o Inventario do #"..Message[1].." - "..vRP.FullName(Message[1]),"Y - Sim","U - Não") then
				TriggerClientEvent("Notify",source,"verde","Limpeza concluída.",5000)
				vRP.ClearInventory(Message[1])
				TriggerEvent("Discord","Clearinv","**[Limpou o Inventário]**\n\n**Passaporte:** "..Passport.."\n**Limpou Inventario do ID:** "..Message[1] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearchest",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) and Message[1] then
			if StaffList[Passport] then
				local Consult = vRP.Query("chests/GetChests",{ name = Message[1] })
				if Consult[1] then
					if vRP.Request(source,"Deseja Limpar o Chest do #"..Message[1].." ?") then
					TriggerClientEvent("Notify",source,"verde","Limpeza concluída.",5000)
					vRP.SetSrvData("Chest:"..Message[1],{},true)
					TriggerEvent("Discord", "Clearchest", "**[Limpou um baú]**\n\n**Passaporte:** " .. Passport .. "\n**Chest:** " .. Message[1] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gem",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
			if StaffList[Passport] then
				local Amount = parseInt(Message[2])
				local OtherPassport = parseInt(Message[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					TriggerClientEvent("Notify",source,"verde","Gemas entregues.",5000)
					vRP.Query("accounts/AddGems",{ license = Identity["license"], gems = Amount })
					vRP.UpgradeGemstone(Passport,Amount)
					TriggerEvent("Discord", "Gemstone", "**[Entrega de Gemas]**\n\n**Passaporte de Origem:** " .. Passport .. "\n**Destinatário:** " .. OtherPassport .. "\n**Quantidade de Gemas:** " .. Amount .. "\n**Endereço IP:** " .. GetPlayerEndpoint(source), 16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addgem",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
			if StaffList[Passport] then
				local Amount = parseInt(Message[2])
				local OtherPassport = parseInt(Message[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					if vRP.Request(source,"Deseja Adicionar "..Message[2].." Gemstone para o Passporte <green>#"..OtherPassport.." - "..vRP.FullName(OtherPassport).."</green> !","Y - Sim","U - Não") then
						TriggerClientEvent("Notify",source,"verde","Gemas entregues para #"..OtherPassport.." - "..vRP.FullName(OtherPassport).." !",5000)
						vRP.UpgradeGemstone(OtherPassport,Amount)
					
						local OtherSource = vRP.Source(OtherPassport)
						if OtherSource then
							TriggerClientEvent("Notify",OtherSource,"azul","Você recebeu <b>"..Amount.."x Gemas</b>.",5000)
						end
						TriggerEvent("Discord", "Gemstone", "**[Entrega de Gemas]**\n\n**Passaporte de Origem:** " .. Passport .. "\n**Destinatário:** " .. OtherPassport .. "\n**Quantidade de Gemas:** " .. Amount .. "\n**Endereço IP:** " .. GetPlayerEndpoint(source), 16777215)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blips", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) or vRP.HasGroup(Passport, "Staff", 1) then
			if StaffList[Passport] then
				local Text = ""

				if not Blips[Passport] then
					Blips[Passport] = true
					Text = "Ativado"
					TriggerEvent("Discord", "Blips", "**[Ativou os Blips]**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text .. " \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				else
					Blips[Passport] = nil
					Text = "Desativado"
					TriggerEvent("Discord", "Blips", "**[Desativou os Blips]**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text .. " \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				end

				vRPC.BlipAdmin(source)

				if Blips[Passport] then
				else
				end
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",4) then
			if Message[1] then
				TriggerEvent("Discord","God","**[GOD]**\n\n**Passaporte:** "..Passport.."\n**Comando:** god "..Message[1] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				local OtherPassport = parseInt(Message[1])
				local ClosestPed = vRP.Source(OtherPassport)
				if ClosestPed then
					vRP.UpgradeThirst(OtherPassport,100)
					vRP.UpgradeHunger(OtherPassport,100)
					vRP.DowngradeStress(OtherPassport,100)
					vRP.Revive(ClosestPed,200)
					TriggerEvent("Discord","God","**[GOD]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				end
			else
				vRP.Revive(source,200,true)
				--vRP.SetArmour(source,99)
				vRP.UpgradeThirst(Passport,100)
				vRP.UpgradeHunger(Passport,100)
				vRP.DowngradeStress(Passport,100)
				TriggerEvent("Discord","God","**[GOD]**\n\n**Passaporte:** "..Passport.."\n**Deu God em Si mesmo:** \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)

				TriggerClientEvent("paramedic:Reset",source)

				vRPC.Destroy(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("good",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				if Message[1] then
					local OtherPassport = parseInt(Message[1])
					local ClosestPed = vRP.Source(OtherPassport)
					if ClosestPed then
						vRP.UpgradeThirst(OtherPassport,100)
						vRP.UpgradeHunger(OtherPassport,100)
						vRP.DowngradeStress(OtherPassport,100)
						vRP.Revive(ClosestPed,200)
						vRP.SetArmour(source,99)
						TriggerEvent("Discord","God","**[GOOD]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
					end
				else
					vRP.Revive(source,200,true)
					vRP.SetArmour(source,99)
					vRP.UpgradeThirst(Passport,100)
					vRP.UpgradeHunger(Passport,100)
					vRP.DowngradeStress(Passport,100)
					TriggerEvent("Discord","God","**[GOOD]**\n\n**Passaporte:** "..Passport.."\n**Deu God em Si mesmo:** \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)

					TriggerClientEvent("paramedic:Reset",source)

					vRPC.Destroy(source)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KILL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kill",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",3) then
			if StaffList[Passport] then
				if Message[1] then
					TriggerEvent("Discord","Kill","**[KILL]**\n\n**Passaporte:** "..Passport.."\n**Comando:** god "..Message[1] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
					local OtherPassport = parseInt(Message[1])
					local ClosestPed = vRP.Source(OtherPassport)
					if ClosestPed then
						vRP.UpgradeThirst(OtherPassport,100)
						vRP.UpgradeHunger(OtherPassport,100)
						vRP.DowngradeStress(OtherPassport,100)
						vRP.Revive(ClosestPed,100)
						TriggerEvent("Discord","Kill","**[KILL]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
					end
				else
					vRP.Revive(source,100,true)
					--vRP.SetArmour(source,99)
					vRP.UpgradeThirst(Passport,100)
					vRP.UpgradeHunger(Passport,100)
					vRP.DowngradeStress(Passport,100)
					TriggerEvent("Discord","Kill","**[KILL]**\n\n**Passaporte:** "..Passport.."\n**Deu God em Si mesmo:** \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)

					TriggerClientEvent("paramedic:Reset",source)

					vRPC.Destroy(source)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god2",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) or vRP.HasGroup(Passport,"Staff",1) then
			if StaffList[Passport] then
				if Message[1] then
					local OtherPassport = parseInt(Message[1])
					local ClosestPed = vRP.Source(OtherPassport)
					if ClosestPed then
						vRP.UpgradeThirst(OtherPassport,100)
						vRP.UpgradeHunger(OtherPassport,100)
						vRP.DowngradeStress(OtherPassport,100)
						vRP.Revive(ClosestPed,200)
						vRP.SetArmour(source,99)
						TriggerEvent("Discord","God","**[GOD 2]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
					end
				else
					vRP.Revive(source,200,true)
					vRP.SetArmour(source,99)
					vRP.UpgradeThirst(Passport,100)
					vRP.UpgradeHunger(Passport,100)
					vRP.DowngradeStress(Passport,100)
					TriggerEvent("Discord","God","**[GOD 2]**\n\n**Passaporte:** "..Passport.."\n**Deu God em Si mesmo:** \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)

					TriggerClientEvent("paramedic:Reset",source)

					vRPC.Destroy(source)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				if Message[1] and Message[2] and itemBody(Message[1]) ~= nil then
					local Amount = parseInt(Message[2])
					vRP.GenerateItem(Passport,Message[1],Amount,true)
					TriggerClientEvent("inventory:Update",source,"Backpack")
					TriggerEvent("Discord","Item","**[Pegou um item]**\n\n**Passaporte:** "..Passport.."\n**Item:** "..Amount.."x "..itemName(Message[1]).." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item2",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) and Message[3] and itemBody(Message[1]) then
			if StaffList[Passport] then
				local OtherPassport = parseInt(Message[3])
				if OtherPassport > 0 then
					local Amount = parseInt(Message[2])
					local Item = itemName(Message[1])
					vRP.GenerateItem(Message[3],Message[1],Amount,true)
					TriggerClientEvent("Notify",source,"verde","Você enviou <b>"..Amount.."x "..Item.."</b> para o passaporte <b>"..OtherPassport.."</b>.",5000)
					
					TriggerEvent("Discord","Item","**[Pegou um item 2]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.."\n**Item:** "..Amount.."x "..Item.." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kit", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) then
			if StaffList[Passport] then
				vRP.GenerateItem(Passport, "WEAPON_PISTOL_MK2", 1, true)
				vRP.GenerateItem(Passport, "WEAPON_SPECIALCARBINE_MK2", 1, true)
				vRP.GenerateItem(Passport, "WEAPON_PISTOL_AMMO", 500, true)
				vRP.GenerateItem(Passport, "WEAPON_RIFLE_AMMO", 500, true)
				vRP.GenerateItem(Passport, "energetic2", 10, true)
				TriggerClientEvent("inventory:Update", source, "Backpack")
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] and Message[1] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				local OtherPassport = parseInt(Message[1])
				vRP.Query("characters/removeCharacter",{ id = OtherPassport })
				vRP.Kick(OtherPassport,"A Historia do seu Personagem Chegou ao FIM!.")
				TriggerClientEvent("Notify",source,"verde","Personagem <b>"..OtherPassport.."</b> levou PD e foi Deletado.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc", function(source)
    local Passport = vRP.Passport(source)

    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 5) then
            if StaffList[Passport] then
                local Text = ""
                local Action = ""

                if not Noclip[Passport] then
                    Noclip[Passport] = true
                    
                    Player(source).state:set("NoclipActive", true, true)
                    
                    Text = "Ativado"
                    Action = "ativou"
					TriggerClientEvent("admin:StaffEffect", -1, source)
                else
                    Noclip[Passport] = false
                    Player(source).state:set("NoclipActive", false, true)
                    
                    Text = "Desativado"
                    Action = "desativou"
					TriggerClientEvent("admin:StaffEffect", -1, source)
                end

                TriggerEvent("Discord", "Noclip", "**[Noclip]**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text .. " \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
                
                vRPC.noClip(source, Noclip[Passport])
            else
                TriggerClientEvent("Notify", source, "vermelho", "Precisas de estar em modo <b>/staff</b> para usar noclip.", 5000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",3) and parseInt(Message[1]) > 0 then
			if StaffList[Passport] then
				local OtherSource = vRP.Source(Message[1])
				if OtherSource then
					TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..Message[1].."</b> expulso.",5000)
					vRP.Kick(OtherSource,"Expulso da cidade.")
					
					TriggerEvent("Discord","Kick","**[Expulsou um Jogador]**\n\n**Passaporte:** "..Passport.."\n**Expulsou Passaporte:** "..Message[1].." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",3) and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
			if StaffList[Passport] then
				local Days = parseInt(Message[2])
				local OtherPassport = parseInt(Message[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					vRP.Query("banneds/InsertBanned",{ license = Identity["license"], time = Days })
					TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..OtherPassport.."</b> banido por <b>"..Days.."</b> dias.",5000)
					TriggerEvent("Discord","Ban","**[Baniu um Jogador]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Message[1].."\n**Tempo:** "..Message[2].." dias \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
					
					local OtherSource = vRP.Source(OtherPassport)
					if OtherSource then
						vRP.Kick(OtherSource,"Banido.")
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) or vRP.HasGroup(Passport,"Staff",1) and parseInt(Message[1]) > 0 then
			if StaffList[Passport] then
				local OtherPassport = parseInt(Message[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					vRP.Query("banneds/RemoveBanned",{ license = Identity["license"] })
					TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..OtherPassport.."</b> desbanido.",5000)
					
					TriggerEvent("Discord","Unban","**[Desbaniu um Jogador]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 5) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keySingle(source, "Cordenadas:")
				if Keyboard then
					local Split = splitString(Keyboard[1], ",")
					local x = tonumber(Split[1]) or 0 
					local y = tonumber(Split[2]) or 0
					local z = tonumber(Split[3]) or 0

					vRP.Teleport(source, x, y, z)

					TriggerEvent("Discord", "Tpcds", "**[Teleportação de Coordenadas]**\n\n**Passaporte:** " .. Passport .. "\n**Coordenadas:** " .. x .. ", " .. y .. ", " .. z .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				end
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 5) or vRP.HasGroup(Passport, "Staff", 1) then
			if StaffList[Passport] then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				local heading = GetEntityHeading(Ped)

				vKEYBOARD.keyCopy(source, "Cordenadas:", mathLength(Coords["x"]) .. "," .. mathLength(Coords["y"]) .. "," .. mathLength(Coords["z"]) .. "," .. mathLength(heading))

				TriggerEvent("Discord", "cds", "**[Comando: /cds]**\n\n**Passaporte:** " .. Passport .. "\n**Coordenadas:** " .. Coords.x .. ", " .. Coords.y .. ", " .. Coords.z .. "\n**Heading:** " .. heading .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds2", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 5) or vRP.HasGroup(Passport, "Staff", 1) then
			if StaffList[Passport] then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				local heading = GetEntityHeading(Ped)

				vKEYBOARD.keyCopy(source, "Cordenadas:", "x = " .. mathLength(Coords["x"]) .. ", y = " .. mathLength(Coords["y"]) .. ", z = " .. mathLength(Coords["z"]) .. ", h = " .. mathLength(heading))

				TriggerEvent("Discord", "cds", "**[Comando: /cds2]**\n\n**Passaporte:** " .. Passport .. "\n**Coordenadas:** x = " .. Coords.x .. ", y = " .. Coords.y .. ", z = " .. Coords.z .. ", h = " .. heading .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS3
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds3", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 5) or vRP.HasGroup(Passport, "Staff", 1) then
			if StaffList[Passport] then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				local heading = GetEntityHeading(Ped)

				vKEYBOARD.keyCopy(source, "Cordenadas:", "['x'] = " .. mathLength(Coords["x"]) .. ", ['y'] = " .. mathLength(Coords["y"]) .. ", ['z'] = " .. mathLength(Coords["z"]) .. ", ['h'] = " .. mathLength(heading))

				TriggerEvent("Discord", "cds", "**[Comando: /cds3]**\n\n**Passaporte:** " .. Passport .. "\n**Coordenadas:** ['x'] = " .. Coords.x .. ", ['y'] = " .. Coords.y .. ", ['z'] = " .. Coords.z .. ", ['h'] = " .. heading .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- XP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("xp", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keyTertiary(source, "ID:", "Emprego:","Quantidade XP:")
				if Keyboard then
					vRP.PutExperience(Keyboard[1], Keyboard[2], Keyboard[3])
					TriggerClientEvent("Notify", source, "amarelo", "Você Setou " .. Keyboard[3] .."XP  no Emprego:" .. Keyboard[2] .. " Para o ID: "..vRP.FullName(Keyboard[1]), 5000)
				end
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wanted", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keyDouble(source, "ID:","Quantidade Wanted:")
				if Keyboard then
					TriggerEvent("Wanted",source,Keyboard[1],Keyboard[2])
				end
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- XPPASS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("xppass", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keyDouble(source, "ID:", "Quantidade de XP:")
				if Keyboard then
					TriggerEvent("pause:AddPoints", parseInt(Keyboard[1]), parseInt(Keyboard[2]))
					TriggerClientEvent("Notify", source, "amarelo", "Você Setou " .. Keyboard[2] .. " XP no BattlePass Para o: " .. vRP.FullName(Keyboard[1]), 5000)
				end
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if parseInt(Message[1]) > 0 and Message[2] and parseInt(Message[3]) then
            if Passport == 1 or vRP.HasGroup(Passport, "Admin", 3) then
				if StaffList[Passport] then
				  TriggerClientEvent("Notify", source, "verde", "Adicionado <b>"..Message[2].."</b> ao passaporte <b>"..Message[1].."</b>.", 5000)
				  TriggerEvent("Discord", "Group", "**[Adicionou um group]**\n\n**ID:** "..Passport.."\n**Setou:** "..Message[1].." \n**Grupo:** "..Message[2].." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				  vRP.SetPermission(Message[1], Message[2], Message[3])
				end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",3) and parseInt(Message[1]) > 0 and Message[2] then
			if StaffList[Passport] then
				TriggerClientEvent("Notify",source,"verde","Removido <b>"..Message[2].."</b> ao passaporte <b>"..Message[1].."</b>.",5000)
				TriggerEvent("Discord","Ungroup","**[Removou um group]**\n\n**ID:** "..Passport.."\n**Removeu:** "..Message[1].." \n**Grupo:** "..Message[2].." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				vRP.RemovePermission(Message[1],Message[2])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NAMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("names", function(source)
    local Passport = vRP.Passport(source) 
    if Passport and GlobalState["Commands"] and vRP.HasGroup(Passport, "Admin", 5) then
		if StaffList[Passport] then
			local List = vRP.Players()
			local Players = ""
			for k, v in pairs(List) do
				local IDIdentity = vRP.Identity(k)
				Players = Players .. k .. ": " .. IDIdentity["name"] .. " " .. IDIdentity["name2"] .. "\n"
			end

			vKEYBOARD.keyCopy(source, "Players Conectados:", Players)
		end
    else
        TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NAMES2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("names2", function(source)
    local Passport = vRP.Passport(source) 
    if Passport and GlobalState["Commands"] and vRP.HasGroup(Passport, "Admin", 5) then
		if StaffList[Passport] then
			local List = vRP.Players()
			local Players = ""
			for k, v in pairs(List) do
				local IDIdentity = vRP.Identity(k)
				Players = Players .. IDIdentity["name"] .. " " .. IDIdentity["name2"] .. "\n" 
			end

			
			TriggerClientEvent("Notify", source, "azul", "Jogadores Conectados: " .. Players, 15000)
		end
    else
        TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.",  5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPESO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('checkpeso', function(source)
    local Passport = vRP.Passport(source)
	if StaffList[Passport] then
		if Passport ~= nil and GlobalState["Commands"] then
			local peso = vRP.InventoryWeight(Passport)
			local maxPeso = vRP.GetWeight(Passport)
			TriggerClientEvent("Notify", source, "azul", "Peso no Inventário: " .. peso .. "/" .. maxPeso .. "kg",10000)
		else
			TriggerClientEvent("Notify", source, "vermelho", "Erro: Não foi possível encontrar o seu usuário.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",5) or vRP.HasGroup(Passport,"Admin",1) and parseInt(Message[1]) > 0 then
			if StaffList[Passport] then
				local ClosestPed = vRP.Source(Message[1])
				if ClosestPed then
					local Ped = GetPlayerPed(source)
					local Coords = GetEntityCoords(Ped)
					
					vRP.Teleport(ClosestPed,Coords["x"],Coords["y"],Coords["z"])
					TriggerEvent("Discord","Tptome","**[TPTOME]**\n\n**Passaporte:** "..Passport.."\n**Puxou o ID:** "..Message[1].." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GODAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("godarea",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",3) then
			if StaffList[Passport] then
				local Range = parseInt(Message[1])
				if Range then
					local Text = ""
					local Players = vRPC.ClosestPeds(source,Range)
					for _,v in pairs(Players) do
						async(function()
							local OtherPlayer = vRP.Passport(v)
							vRP.UpgradeThirst(OtherPlayer,100)
							vRP.UpgradeHunger(OtherPlayer,100)
							vRP.DowngradeStress(OtherPlayer,100)
							vRP.Revive(v,200)

							TriggerClientEvent("paramedic:Reset",v)

							if Text == "" then
								Text = OtherPlayer
							else
								Text = Text..", "..OtherPlayer
							end
						end)
					end

					TriggerEvent("Discord","God","**[GOD ÁREA]**\n\n**Passaporte:** "..Passport.."\n**Utilizou o comando /godarea** "..Text,16777215)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		local LocX, LocY, LocZ, PlaceKey = AdminTptoResolveLocation(Message)
		local TargetId = Message[1] and parseInt(Message[1]) or 0
		if vRP.HasGroup(Passport,"Admin",5) or (vRP.HasGroup(Passport,"Admin",1) and (TargetId > 0 or LocX)) then
			if StaffList[Passport] then
				if not Message[1] then
					TriggerClientEvent("Notify",source,"amarelo","Use <b>/tpto [ID]</b> ou <b>/tpto [local]</b>: paleto, docas, samir, pier, aeroporto trevor.",8000)
				elseif LocX and LocY and LocZ then
					vRP.Teleport(source,LocX,LocY,LocZ)
					TriggerEvent("Discord","Tpto","**[TPTO]**\n\n**Passaporte:** "..Passport.."\n**Local:** "..PlaceKey.."\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				elseif TargetId > 0 then
					local ClosestPed = vRP.Source(Message[1])
					if ClosestPed then
						local Ped = GetPlayerPed(ClosestPed)
						local Coords = GetEntityCoords(Ped)
						vRP.Teleport(source,Coords["x"],Coords["y"],Coords["z"])
						TriggerEvent("Discord","Tpto","**[TPTO]**\n\n**Passaporte:** "..Passport.."\n**Deu TPTO No ID:** "..Message[1].." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
					else
						TriggerClientEvent("Notify",source,"amarelo","Jogador não encontrado ou local inválido.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Jogador não encontrado ou local inválido.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",5) then
			if StaffList[Passport] then
				vCLIENT.teleportWay(source)
				TriggerEvent("Discord", "Tpway", "**[Teleportação de Caminho]**\n\n**Passaporte:** " .. Passport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMBO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source)
	local Passport = vRP.Passport(source)
	if StaffList[Passport] then
		if Passport and vRP.GetHealth(source) <= 100 then
			vCLIENT.TeleportLimbo(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",5) then
			if StaffList[Passport] then
				local Vehicle = vRPC.VehicleHash(source)
				if Vehicle then
					vKEYBOARD.keyCopy(source,"Hash do veículo:",Vehicle)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) then
			if StaffList[Passport] then
				TriggerClientEvent("admin:Tuning", source)
				TriggerClientEvent("Notify", source, "verde", "Veículo modificado com sucesso.", 5000)
				
				TriggerEvent("Discord", "Tuning", "**[Veículo Modificado]**\n\n" .."**Jogador (ID):** " .. Passport .. "\n".."**Ação:** usou o /tuning" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
        else
            TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("id", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 5) and tonumber(args[1]) > 0 then
			if StaffList[Passport] then
				local Identity = vRP.Identity(tonumber(args[1]))
				if Identity then
					TriggerClientEvent("Notify", source, "azul", "<b>Passaporte:</b> " .. args[1] .. "<br><b>Nome:</b> " .. Identity["name"] .. " " .. Identity["name2"] .. "<br><b>Telefone:</b> " .. Identity["phone"] .. "<br><b>Sexo:</b> " .. Identity["sex"] .. "<br><b>Gemas:</b> " .. Identity["gems"] .. "<br><b>Banco:</b> $" .. parseFormat(Identity["bank"]) .. "<br><b>Likes:</b> 👍" .. Identity["likes"] .. "<br><b>LDeslikes:</b> 👎" .. Identity["unlikes"], 15000)
				end
			end
        end
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("commands",function(source)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keySingle(source,"Número: (0 = desativado / 1 = ativado)")
				if Keyboard then
					if tonumber(Keyboard[1]) == 1 then
						GlobalState["Commands"] = true
						TriggerClientEvent("Notify",source,"verde","Comandos ativados.",5000)
					elseif tonumber(Keyboard[1]) == 0 then
						GlobalState["Commands"] = false
						TriggerClientEvent("Notify",source,"amarelo","Comandos desativados.",5000)
					end
				end
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("setbank", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keyDouble(source, "ID:", "Quantidade:")
				if Keyboard then
					local targetPlayerId = tonumber(Keyboard[1])
					local amount = tonumber(Keyboard[2])
					
					if targetPlayerId and amount then
						vRP.GiveBank(targetPlayerId, amount)
						
						TriggerClientEvent("Notify", source, "verde", "Envio concluído.", 5000)
						
						local targetPlayerName = vRP.FullName(Passport)
						local message = "Você recebeu $" .. amount .. " de " .. vRP.FullName(Passport) .. " (ID: " .. source .. ")"
						
						TriggerClientEvent("Notify", targetPlayerId, "verde", message, 5000)
						
						TriggerEvent("Discord", "SetBank", "**[Transação bancária - ADIÇÃO]**\n\n" .."**Remetente (ID):** " .. Passport .. "\n" .."**Destinatário (ID):** " .. targetPlayerId .. "\n" .."**Quantidade:** $" .. amount, 16777215)
					else
						TriggerClientEvent("Notify", source, "amarelo", "ID ou quantidade inválida.", 5000)
					end
				end
			end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissões para isso.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("removebank", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 1) then
			if StaffList[Passport] then
				local Keyboard = vKEYBOARD.keyDouble(source, "ID:", "Quantidade:")
				if Keyboard then
					local targetPlayerId = tonumber(Keyboard[1])
					local amount = tonumber(Keyboard[2])

					if targetPlayerId and amount then
						local success = vRP.RemoveBank(targetPlayerId, amount)
					else

						if success then
							TriggerClientEvent("Notify", source, "verde", "Remoção concluída.", 5000)
							local targetPlayerName = vRP.FullName(Passport)
							local message = "Você teve $" .. amount .. " removido por " .. vRP.FullName(Passport) .. " (ID: " .. Passport .. ")"
							TriggerClientEvent("Notify", targetPlayerId, "vermelho", message, 5000)
							TriggerEvent("Discord", "RemoveBank", "Transação bancária - SUBTRAÇÃO\n\n" .."**Remetente (ID):** " .. Passport .. "\n" .."**Destinatário (ID):** " .. targetPlayerId .. "\n" .."**Quantidade removida:** $" .. amount, 16777215)
						end
					end
				end
			end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissões para isso.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix", function(source)
    local Passport = vRP.Passport(source)
    if Passport and GlobalState["Commands"] then
        if vRP.HasGroup(Passport, "Admin", 4) then
			if StaffList[Passport] then
				local Vehicle, Network, Plate = vRPC.VehicleList(source, 10)
				if Vehicle then
					TriggerClientEvent("inventory:repairAdmin", -1, Network, Plate)
					TriggerClientEvent("Notify", source, "verde", "Veículo " .. Plate .. " reparado com sucesso.", 5000)
					
					TriggerEvent("Discord", "Fix",string.format("**[FIX]**\n\n**ID: %d**\nReparou o veículo com a placa **%s** com sucesso.", Passport, Plate) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				else
					TriggerClientEvent("Notify", source, "amarelo", "Não há veículo próximo ou você não tem permissões para isso.", 5000)
				end
			end
        else
            TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparea",function(source)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				TriggerClientEvent("syncarea",source,Coords["x"],Coords["y"],Coords["z"],100)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",5) or vRP.HasGroup(Passport,"Staff",1) then
			if StaffList[Passport] then
				TriggerClientEvent("Notify",source,"azul","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,Message)
	local Passport = vRP.Passport(source)
		if Passport and GlobalState["Commands"] then
			if vRP.HasGroup(Passport,"Admin",1) then
			if StaffList[Passport] then
				local Text = ""
				local List = vRP.Players()
				
				for OtherPlayer,_ in pairs(List) do
					async(function()
						if Text == "" then
							Text = OtherPlayer
						else
							Text = Text..", "..OtherPlayer
						end
						
						vRP.GenerateItem(OtherPlayer,Message[1],Message[2],true)
					end)
				end
				TriggerEvent("Discord","Itemall","**[ITEM ALL]**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Text.."\n**Item:** "..Message[2].."x "..itemName(Message[1]).." \n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end	
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("spectate",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin",5) then
			if StaffList[Passport] then
				if Spectate[Passport] then
					local Ped = GetPlayerPed(Spectate[Passport])
					if DoesEntityExist(Ped) then
						SetEntityDistanceCullingRadius(Ped,0.0)
					end

					TriggerClientEvent("admin:resetSpectate",source)
					TriggerEvent("Discord", "Spectate", "**[Espectador Finalizado]**\n\n**Passaporte:** " .. Passport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
					Spectate[Passport] = nil

					TriggerClientEvent("Notify",source,"amarelo","Modo espião desativado.",5000)
				else
					local OtherSource = vRP.Source(Message[1])
					if OtherSource then
						local OtherPassport = vRP.Passport(OtherSource)
						local OtherIdentity = vRP.Identity(OtherPassport)
						if OtherPassport and OtherIdentity then
							if vRP.Request(source,"Você realmente deseja espionar <b>"..vRP.FullName(OtherPassport).."</b>?") then
								local Ped = GetPlayerPed(OtherSource)
								if DoesEntityExist(Ped) then
									SetEntityDistanceCullingRadius(Ped,999999999.0)
									Wait(1000)
									TriggerClientEvent("admin:initSpectate",source,OtherSource)
									Spectate[Passport] = OtherSource
									TriggerEvent("Discord", "Spectate", "**[Espectador Iniciado]**\n\n**Passaporte:** " .. Passport .. "\n**Observando:** " .. Message[1] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)

									TriggerClientEvent("Notify",source,"verde","Você está espiando <b>"..vRP.FullName(OtherPassport).."</b>.",5000)
								end
							end
						end
					end
				end
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------
-- RGBCAR
-------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rgbcar',function(source,args,rawCommand)
    local Passport = vRP.Passport(source)
	if Passport and GlobalState["Commands"] then
		if vRP.HasGroup(Passport,"Admin", 1) then
			if StaffList[Passport] then
				TriggerClientEvent('rgbcar',source)
				TriggerClientEvent("Notify",source,"sucesso","Você tunou o <b>veículo</b> RGB com sucesso.",5000)
			end
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOP DE CURA NO SERVIDOR (CORRIGIDO)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local idle = 2000

        local users = vRP.Players() 
        

        if users then
            for Passport, Source in pairs(users) do
                local source = parseInt(Source)
                local passport = parseInt(Passport)
                

                if Player(source) and Player(source).state.ThanosActive then
                    idle = 100 
                    local ped = GetPlayerPed(source)
                    
                    if GetEntityHealth(ped) < 390 then
                        vRP.UpgradeThirst(passport, 100)
                        vRP.UpgradeHunger(passport, 100)
                        vRP.DowngradeStress(passport, 100)
                        vRP.Revive(source, 400)
                    end
                end
            end
        end
        
        Wait(idle)
    end
end)