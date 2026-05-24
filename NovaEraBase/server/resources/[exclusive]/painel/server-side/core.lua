-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("painel",Creative)
vCLIENT = Tunnel.getInterface("painel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Panel = {}
local Cooldown = {}
local Extracts = {}
local CacheOrgs = {}
local CacheLogin = {}
local ExtractsCache = {}
local CacheIdentity = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.OpenTablet,function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then

		if Cooldown[Passport] then
			if os.time() < Cooldown[Passport] then
				TriggerClientEvent("Notify",source,"amarelo","Aguarde alguns segundos antes de executar essa função.",5000)
				return
			end
		end

		if vRP.HasPermission(Passport,Message[1]) then
			Panel[Passport] = Message[1]

			if Panel[Passport] then
				local Online = 0
				local Members = {}
				local Sources = vRP.Players()
				local Entitys = vRP.DataGroups(Panel[Passport])
				local Hierarchy = vRP.Hierarchy(Panel[Passport])
				
				for Number,v in pairs(Entitys) do
					local Number = parseInt(Number)
					local Identity = CacheUserIdentity(Number)

					if Identity and Hierarchy then
						Members[#Members + 1] = { ["name"] = Identity["name"].." #"..Number, ["phone"] = Identity["phone"], ["status"] = Sources[Number] and true or false, ["login"] = CacheLogin[Sources[Number]] or formatTime(vRP.Identity(Number) and vRP.Identity(Number)["lastlogin"] or nil), ["id"] = Number, ["role"] = Hierarchy[v] or Hierarchy }
						
						if Sources[Number] then
							Online = Online + 1
						end
					end
				end

				local MaxMembers = CacheOrgs[Panel[Passport]]

				local Data = {
					groupName = Panel[Passport],
					members = Members,
					max = MaxMembers,
					totalOnline = Online
				}

				Cooldown[Passport] = os.time() + 8
			
				vCLIENT.Open(source,Data)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Dismiss(Number)
    local source = source
    local Number = parseInt(Number)
    local Passport = vRP.Passport(source)

    if Passport and Panel[Passport] and Passport ~= Number then
        if vRP.HasPermission(Passport, Panel[Passport], 1) then

            if vRP.HasPermission(Number, Panel[Passport], 1) then
                TriggerClientEvent("Notify", source, "vermelho", "Você não pode remover outro líder.", 5000)
                return true
            end

            vRP.RemovePermission(Number, Panel[Passport])

            if vRP.GroupType(Panel[Passport]) == "Principal" then
                exports["oxmysql"]:query_async(
                    "INSERT INTO blocklist(passport,time) VALUES(?,?)",
                    { Number, os.time() + Config.CoolDownBlacklist * 60 * 60 }
                )
            end

            TriggerEvent("Discord", "Dismiss",
                "**[Ação de Remoção]**\n\n**Passaporte:** " .. Passport ..
                "\n**Jogador Removido:** " .. Number ..
                "\n**Motivo:** Remoção de organização\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),
                16777215
            )

            TriggerClientEvent("Notify", source, "verde", "Passaporte removido.", 5000)
        end
    end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVITE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Invite(Number)
    local source = source
    local Number = parseInt(Number)
    local Passport = vRP.Passport(source)

    if Passport and Panel[Passport] and Passport ~= Number then
        if vRP.HasPermission(Passport,Panel[Passport],2) then
            local OtherSource = vRP.Source(Number)
            if not OtherSource then
                TriggerClientEvent("Notify",source,"vermelho","O passaporte informado não está na cidade.",5000)
                return
            end

            local GroupType = vRP.GroupType(Panel[Passport])
            if vRP.CheckType(Number,GroupType) then
                TriggerClientEvent("Notify",source,"vermelho","Parece que o passaporte informado já está em uma organização.",5000)
                return
            end

            if not CacheOrgs[Panel[Passport]] then
                TriggerClientEvent("Notify",source,"vermelho","Não foi possível identificar algumas informações, contate um desenvolvedor.",5000)
                return
            end

            local Members = 0
            local DataGroup = vRP.DataGroups(Panel[Passport])
            for _,_ in pairs(DataGroup) do Members = Members + 1 end

            if Members >= CacheOrgs[Panel[Passport]] then
                TriggerClientEvent("Notify",source,"vermelho","Sua organização chegou ao limite de membros.",5000)
                return
            end

            local Consult = exports["oxmysql"]:query_async(
                "SELECT passport,time FROM blocklist WHERE passport = ?",
                { Number }
            )

            if not Consult[1] or tonumber(Consult[1]["time"] or 0) <= os.time() then
                if vRP.Request(OtherSource,"Você deseja fazer parte da organização: "..Panel[Passport]) then
                    exports["oxmysql"]:query_async("DELETE FROM blocklist WHERE passport = ?", { Number })
                    vRP.SetPermission(Number,Panel[Passport])

                    TriggerClientEvent("Notify",source,"verde","Passaporte adicionado.",5000)
                    TriggerClientEvent("Notify",OtherSource,"amarelo","Agora você faz parte da organização: <b>"..Panel[Passport].."</b>",5000)

                    TriggerEvent("Discord","Invite",
                        "**[Convite para Organização]**\n\n**Passaporte (quem convidou):** " .. Passport ..
                        "\n**Passaporte convidado:** " .. Number ..
                        "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),
                        16777215
                    )
                end
            else
                TriggerClientEvent("Notify",source,"vermelho","Este passaporte está em blocklist.",5000)
            end
        end
    end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Hierarchy(OtherPassport,Mode)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport and Panel[Passport] then
        if vRP.HasPermission(Passport,Panel[Passport],1) then
            if not vRP.HasPermission(OtherPassport,Panel[Passport],2) or Mode == "Demote" then
                vRP.SetPermission(OtherPassport,Panel[Passport],nil,Mode)

                TriggerEvent("Discord","Promote",
                    "**[Atualização de Hierarquia]**\n\n**Executor:** " .. Passport ..
                    "\n**Jogador Modificado:** " .. OtherPassport ..
                    "\n**Modo:** " .. tostring(Mode) ..
                    "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),
                    16777215
                )

                TriggerClientEvent("Notify",source,"verde","Hierarquia atualizada.",5000)
                return true
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEMBERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MemberList(orgName)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then 
		return 
	end

	Panel[Passport] = orgName

	local Online = 0
	local Members = {}
	local Sources = vRP.Players()
	local Entitys = vRP.DataGroups(Panel[Passport])
	local Hierarchy = vRP.Hierarchy(Panel[Passport])

	for Number,v in pairs(Entitys) do
		local Number = parseInt(Number)
		local Identity = CacheUserIdentity(Number)

		if Identity and Hierarchy then
			Members[#Members + 1] = { ["name"] = Identity["name"].." #"..Number, ["phone"] = Identity["phone"], ["status"] = Sources[Number] and true or false, ["login"] = CacheLogin[Sources[Number]] or formatTime(vRP.Identity(Number) and vRP.Identity(Number)["lastlogin"] or nil), ["id"] = Number, ["role"] = Hierarchy[v] or Hierarchy }
		end

		if Sources[Number] then
			Online = Online + 1
		end
	end

	local MaxMembers = CacheOrgs[Panel[Passport]]
	
	local Data = {
		groupName = Panel[Passport],
		members = Members,
		max = MaxMembers,
		totalOnline = Online
	}

	return Data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RBLOCKLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.RemBlacklist, function(source,Message) 
	local Passport = vRP.Passport(source)

	if Passport then
		if vRP.HasGroup(Passport,"Admin",1) then
			if Message[1] then
				local Consult = exports["oxmysql"]:query_async("SELECT * FROM blocklist WHERE passport = ?", { parseInt(Message[1]) })

				if Consult[1] then
					if vRP.Request(source,"Você deseja remover a blocklist do passaporte: "..parseInt(Message[1]).."?") then
						exports["oxmysql"]:query_async("DELETE FROM blocklist WHERE passport = ?", { parseInt(Message[1]) })
						TriggerClientEvent("Notify",source,"verde","Blocklist removida com sucesso do passaporte: "..parseInt(Message[1]),5000)
						TriggerEvent("Discord", "Blacklist", "**[Remoção de Blocklist]**\n\n**Admin:** " .. Passport .. "\n**Passaporte Removido:** " .. parseInt(Message[1]) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Não foi possivel encontrar este passaporte em blocklist",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET PLAYER BALANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetPlayerBalance()
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then 
		return 
	end

	return vRP.GetBank(source) or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET ORG BALANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetOrgBalance()
    local source = source
    local Passport = vRP.Passport(source)
    local orgName = Panel[Passport]

    if not Passport then 
        return 
    end

    local OrgQuery = exports["oxmysql"]:query_async("SELECT bank FROM painel_orgs WHERE org = ?", { orgName })

    if OrgQuery[1] then
        return OrgQuery[1]["bank"] or 0
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET EXTRACTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetExtracts()
    local source = source 
    local Passport = vRP.Passport(source)
    local Org = Panel[Passport]

    if not Passport then 
        return 
    end

    local extracts = Extracts[Org] or {}
    local limitedExtracts = {}
    local count = 0

    for k, v in pairs(extracts) do
        if count >= 15 then
            break
        end
        limitedExtracts[k] = v
        count = count + 1
    end

    return limitedExtracts
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE EXTRACT
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateExtract(Source, Amount, Action)
	local source = Source
	local Passport = vRP.Passport(source)

	if not Passport then 
		return 
	end

	local org = Panel[Passport]
	if not org then 
		return 
	end

	if not Extracts[org] then
		Extracts[org] = {}
	end
	
	if not ExtractsCache[org] then
		ExtractsCache[org] = {}
	end

	local Identity = CacheUserIdentity(Passport)
	
	table.insert(Extracts[org], { org = org, name = Identity["name"], passport = Passport, action = Action, amount = Amount, date = os.date("%d/%m/%Y %H:%M:%S") })
	table.insert(ExtractsCache[org], { org = org, name = Identity["name"], passport = Passport, action = Action, amount = Amount, date = os.date("%d/%m/%Y %H:%M:%S") })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deposit(amount)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then 
		return 
	end

	local org = Panel[Passport]
	if not org then 
		return 
	end

	if amount <= 0 then
		TriggerClientEvent("Notify",source,"vermelho","Você deve depositar um valor maior que 0.",5000)
		return
	end

	local OrgQuery = exports["oxmysql"]:query_async("SELECT org FROM painel_orgs WHERE org = ?", { org })

	if OrgQuery[1] then
		if vRP.GetBank(source) >= amount then
			vRP.PaymentFull(Passport, amount)
			CreateExtract(source, amount, "deposit")
			TriggerClientEvent("Notify",source,"verde","Depósito realizado com sucesso.",5000)
			exports["oxmysql"]:query_async("UPDATE painel_orgs SET bank = bank + ? WHERE org = ?", { amount, org })
			TriggerEvent("Discord", "Deposit", "**[Depósito de Dinheiro]**\n\n**Jogador:** " .. Passport .. "\n**Organização:** " .. org .. "\n**Valor Depositado:** " .. amount .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
		else
			TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Withdraw(amount)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then 
		return 
	end

	local org = Panel[Passport]
	if not org then 
		return 
	end

	if amount <= 0 then
		TriggerClientEvent("Notify",source,"vermelho","Você deve remover um valor maior que 0.",5000)
		return
	end

	if not vRP.HasGroup(Passport,org,2) then
		TriggerClientEvent("Notify",source,"vermelho","Você não possui permissão para remover dinheiro do banco.",5000)
		return
	end

	local OrgQuery = exports["oxmysql"]:query_async("SELECT bank FROM painel_orgs WHERE org = ?", { org })

	if OrgQuery[1] then
		if OrgQuery[1]["bank"] >= amount then
			vRP.GiveBank(Passport, amount, "Private")
			CreateExtract(source, amount, "withdraw")
			exports["oxmysql"]:query_async("UPDATE painel_orgs SET bank = bank - ? WHERE org = ?", { amount, org })
			TriggerClientEvent("Notify",source,"verde","Saque realizado com sucesso.",5000)
			TriggerEvent("Discord", "Withdraw", "**[Saque de Dinheiro]**\n\n**Jogador:** " .. Passport .. "\n**Organização:** " .. org .. "\n**Valor Sacado:** " .. amount .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
		else
			TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CACHE IDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function CacheUserIdentity(Passport)
	if not CacheIdentity[Passport] then
		local Identity = vRP.Identity(Passport)
		if Identity then
			CacheIdentity[Passport] = { name = Identity["name"] .. " " .. Identity["name2"], phone = Identity["phone"] }
		else
			CacheIdentity[Passport] = { name = "Individuo Indigente", phone = "000-000" }
		end
	end
	
	return CacheIdentity[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CACHE ORGANIZATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local Query = exports["oxmysql"]:query_async("SELECT * FROM painel_orgs")

	if Query[1] then
		for _,Table in pairs(Query) do
			CacheOrgs[Table["org"]] = Table["value"]
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CACHE EXTRACT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local Query = exports["oxmysql"]:query_async("SELECT * FROM painel_extract ORDER BY date DESC")
    for k,v in pairs(Query) do
        if not Extracts[v["org"]] then
            Extracts[v["org"]] = {}
        end

        table.insert(Extracts[v["org"]], { org = v["org"], name = v["name"], passport = v["passport"], action = v["action"], amount = v["amount"], date = v["date"] })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE CACHE ON THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	while true do
		for k,v in pairs(Extracts) do
			local OrgsExtracts = ExtractsCache[k]
			if OrgsExtracts and #OrgsExtracts > 0 then
				for i = 1, #OrgsExtracts do
					local Extract = OrgsExtracts[i]
					if Extract then
						table.remove(OrgsExtracts,i)
						exports["oxmysql"]:query("INSERT INTO painel_extract (org,name,passport,action,amount,date) VALUES (?,?,?,?,?,?)", { Extract["org"], Extract["name"], Extract["passport"], Extract["action"], Extract["amount"], Extract["date"] })
					end
				end
			end
		end
		Citizen.Wait(1000 * 60 * 5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE CACHE WHEN STOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(Resource)
    if (GetCurrentResourceName() ~= Resource) then
        return
    end

	for k,v in pairs(Extracts) do
        local OrgsExtracts = ExtractsCache[k]
        if OrgsExtracts and #OrgsExtracts > 0 then
            for i = 1, #OrgsExtracts do
                local Extract = OrgsExtracts[i]
                if Extract then
                    exports["oxmysql"]:query("INSERT INTO painel_extract (org,name,passport,action,amount,date) VALUES (?,?,?,?,?,?)", { Extract["org"], Extract["name"], Extract["passport"], Extract["action"], Extract["amount"], Extract["date"] })
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORMAT TIME
-----------------------------------------------------------------------------------------------------------------------------------------
function formatTime(Time)
	local CheckTime = "00/00/0000 00:00:00"

	if Time then
		if Time > 0 then
			CheckTime = os.date("%d/%m/%Y %H:%M:%S", Time)
		end
	end

	return CheckTime
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LAST LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("CharacterChosen", function(Passport,source)
	CacheLogin[source] = os.date("%d/%m/%Y %H:%M:%S")
end)