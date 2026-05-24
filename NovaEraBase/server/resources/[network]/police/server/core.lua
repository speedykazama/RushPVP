-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("police", Creative)
vCLIENT = Tunnel.getInterface("police")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Reduces = {}
local PlateSave = {}
local Announces = {}
local Perimeters = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Search(nuser_id)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local nuser_id = parseInt(nuser_id)
        local Identity = vRP.Identity(nuser_id)
        if Identity then
            local fines = vRP.GetFine(nuser_id)
            local records = vRP.Query("prison/Personal", { nuser_id = nuser_id })
            -- local ports = vRP.Query("gunlicense/List")
			local ports = vRP.Query("gunlicense/List", { Passport = nuser_id })
			-- local port = Identity["gun"]
            local port = (Identity["gun"] ~= nil) and Identity["gun"] or false
            return { 
                true,
                Identity["name"].." "..Identity["name2"],
                Identity["phone"],
                fines,
                records,
                port,
                ports,
                0
            }
        end
    end

    return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Prison(nuser_id, services, fines, text, association, residual, url, cops)
	local source = source
	local Passport = vRP.Passport(source)
	if Active[Passport] == nil then
		Active[Passport] = true

		local Identity = vRP.Identity(Passport)
		if Identity then
			local OtherPlayer = vRP.Source(nuser_id)
			if OtherPlayer then
				vCLIENT.Sync(OtherPlayer, true, true)
				Player(OtherPlayer)["state"]["Prison"] = true
				Player(OtherPlayer)["state"]["Handcuff"] = false
				Player(OtherPlayer)["state"]["Commands"] = false
				TriggerClientEvent("radio:RadioClean", OtherPlayer)
				exports["blipsystem"]:Enter(OtherPlayer, "Prisioneiro")
				TriggerClientEvent("Notify", OtherPlayer, "amarelo","As lixeiras do pátio estão disponíveis para <b>vasculhar</b> em troca de redução penal.", 10000)
			end

			vRP.Query("prison/Insert", {
				police = Identity["name"] .. " " .. Identity["name2"],
				nuser_id = parseInt(nuser_id),
				services = services,
				fines = fines,
				text = text,
				date = os.date("%d/%m/%Y") .. " ás " .. os.date("%H:%M"),
				cops = cops,
				association = association,
				residual = residual,
				url = url
			})

			TriggerClientEvent("Notify", source, "verde", "Prisão efetuada.",  5000)
			vRP.InitPrison(nuser_id, services)

			if fines > 0 then
				vRP.GiveFine(nuser_id, fines)
				exports["bank"]:AddFines(Passport, nuser_id, fines, text)

				if NewBankTaxs then
					exports["bank"]:AddTaxs(OtherPassport,"Prefeitura",fines,"Sistema Penitenciário.")
				end
			end

			TriggerEvent("Discord", "Prender", "**[Prendeu um Jogador]**\n\n**Passaporte do Polícial:** " .. parseFormat(Passport) .. "\n**Passaporte:** " .. parseFormat(nuser_id) .. "\n**Serviços:** " .. parseFormat(services) .. "\n**Multa:** $" .. parseFormat(fines) .. "\n**Horário:** " .. os.date("%H:%M:%S") .. "\n**Motivo:** " .. text, 16777215)
		end

		Active[Passport] = nil
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckPrison(prisonId)
	local records = vRP.Query("prison/Get", { id = parseInt(prisonId) })

	if records[1] then
		return {
			true,
			{},
			records[1]
		}
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Fine(nuser_id, fines, text)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and fines > 0 then
		if Active[Passport] == nil then
			Active[Passport] = true

			TriggerEvent("Discord", "Multar", "**[Multou um Jogador]**\n\n**Passaporte do Polícial:** " .. parseFormat(Passport) .. "\n**Passaporte:** " .. parseFormat(nuser_id) .. "\n**Multa:** $" .. parseFormat(fines) .. "\n**Horário:** " .. os.date("%H:%M:%S") .. "\n**Motivo:** " .. text, 16777215)

			TriggerClientEvent("Notify", source, "verde", "Multa aplicada.",  5000)
			TriggerClientEvent("police:Update", source, "reloadFine")
			--vRP.GiveFine(nuser_id, fines, text, Passport)

			if fines > 0 then
				vRP.GiveFine(nuser_id, fines)
				exports["bank"]:AddFines(Passport, nuser_id, fines, text)

				if NewBankTaxs then
					exports["bank"]:AddTaxs(nuser_id, "Prefeitura", fines * 0.2, "Sistema Penitenciário.")
				end
			end

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SearchGunlicense()
	local ports = vRP.Query("gunlicense/ListAll")
	if ports[1] then
		return {
			true,
			ports
		}
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GiveGunlicense(user_id, serial, status, weapon, exame)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Active[Passport] == nil and vRP.HasGroup(Passport, "Policia", 1) then
			Active[Passport] = true

			local Identity = vRP.Identity(Passport)
			local Identit = vRP.Identity(user_id)
			if Identity and Identit then
				vRP.Query("gunlicense/Insert", {
					identity = Identit["name"] .. " " .. Identit["name2"],
					user_id = user_id,
					portType = status,
					serial = serial,
					weapon = weapon,
					exam = exame,
					nidentity = Identity["name"] .. " " .. Identity["name2"],
					date = os.date("%d/%m/%Y") .. " ás " .. os.date("%H:%M")
				})

				TriggerEvent("Discord", "Portes", "**[Emissão de Porte de Arma]**\n\n**Policial:** " .. Passport .. "\n**Passaporte Alvo:** " .. user_id .. "\n**Tipo de Porte:** " .. status .. "\n**Serial da Arma:** " .. serial .. "\n**Arma:** " .. weapon .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
			end

			TriggerClientEvent("Notify", source, "verde", "Porte adicionado.",5000)
			TriggerClientEvent("police:Update", source, "reloadPortes")

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetGunlicense(portId)
	local port = vRP.Query("gunlicense/Personal", { portId = parseInt(portId) })

	if port[1] then
		return {
			true,
			port[1]
		}
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EDITGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.EditGunlicense(portId, user_id, serial, status, weapon, exame)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Active[Passport] == nil and vRP.HasGroup(Passport, "Policia", 1) then
			Active[Passport] = true

			local Identity = vRP.Identity(Passport)
			local Identit = vRP.Identity(user_id)
			if Identity and Identit then
				vRP.Query("gunlicense/Update", {
					portId = portId,
					identity = Identit["name"] .. " " .. Identit["name2"],
					user_id = user_id,
					portType = status,
					serial = serial,
					weapon = weapon,
					exam = exame,
					nidentity = Identity["name"] .. " " .. Identity["name2"],
					date = os.date("%d/%m/%Y") .. " ás " .. os.date("%H:%M")
				})
			end

			TriggerClientEvent("Notify", source, "verde", "Porte atualiado.",  5000)
			TriggerClientEvent("police:Update", source, "reloadPortes")

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DeleteGunlicense(portId)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Active[Passport] == nil and vRP.HasGroup(Passport, "Policia", 1) then
			Active[Passport] = true

			vRP.Query("gunlicense/Remove", { portId = portId })

			TriggerClientEvent("Notify", source, "verde", "Porte deletado.",  5000)
			TriggerClientEvent("police:Update", source, "reloadPortes")

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetWarrant()
	local warrant = vRP.Query("warrants/List")
	if warrant[1] then
		return {
			true,
			warrant
		}
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckWarrant(id)
	local warrant = vRP.Query("warrants/Personal", { id = id })
	if warrant[1] then
		return {
			true,
			warrant[1]["identity"],
			warrant[1]
		}
	end
	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DeleteWarrant(id)
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport, "Policia", 1) then
		vRP.Query("warrants/Remove", { id = id })

		TriggerClientEvent("police:Update", source, "reloadProcurados")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Warrant(user_id, reason)
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport, "Policia", 1) then
		local Identity = vRP.Identity(Passport)
		local Identit = vRP.Identity(user_id)
		if Identity and Identit then
			vRP.Query("warrants/Insert", {
				user_id = user_id,
				identity = Identit["name"] .. " " .. Identit["name2"],
				status = "Procurado",
				nidentity = Identity["name"] .. " " .. Identity["name2"],
				timeStamp = os.date("%d/%m/%Y") .. " ás " .. os.date("%H:%M"),
				reason = reason
			})

			TriggerClientEvent("police:Update", source, "reloadProcurados")
			TriggerEvent("Discord", "Procurados", "**[Mandado de Prisão]**\n\n**Policial:** " .. Identity["name"] .. " " .. Identity["name2"] .. "\n**Passaporte do Procurado:** " .. user_id .. "\n**Nome do Procurado:** " .. Identit["name"] .. " " .. Identit["name2"] .. "\n**Motivo:** " .. reason .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Reports()
	return vRP.Query("reports/List")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDREPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AddReport(data)
	if data["victim_id"] and data["victim_report"] and data["victim_name"] then
		local source = source
		local Passport = vRP.Passport(source)
		if Passport then
			if Active[Passport] == nil then
				Active[Passport] = true

				local Identity = vRP.Identity(Passport)
				if Identity then
					vRP.Query("reports/Insert", {
						victim_id = data["victim_id"],
						police_name = Identity["name"] .. " " .. Identity["name2"],
						solved = nil,
						victim_name = data["victim_name"],
						created_at = os.date("%d/%m/%Y") .. " ás " .. os.date("%H:%M"),
						victim_report = data["victim_report"],
						updated_at = os.date("%d/%m/%Y") .. " ás " .. os.date("%H:%M")
					})

					TriggerEvent("Discord", "Boletins", "**[Relatório de Boletim]**\n\n**Criado por:** " .. Identity["name"] .. " " .. Identity["name2"] .. "\n**ID da Vítima:** " .. data["victim_id"] .. "\n**Nome da Vítima:** " .. data["victim_name"] .. "\n**Relatório:** " .. data["victim_report"] .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				end
				Active[Passport] = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPORTSOLVED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReportSolved(id)
	vRP.Query("reports/Solved", { id = id, updated_at = os.date("%d/%m/%Y") .. " ás " .. os.date("%H:%M") })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPORTREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReportRemove(id)
	vRP.Query("reports/Remove", { id = id })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PRISONCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:prisonClothes")
AddEventHandler("police:prisonClothes", function(entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		local mHash = vRP.ModelPlayer(entity[1])
		if mHash == "mp_m_freemode_01" or mHash == "mp_f_freemode_01" then
			TriggerClientEvent("skinshop:Apply", entity[1], Preset[mHash])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdatePort(OtherPassport)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport, "Policia", 1) then
		local PortStatus = "Desativado"
		local OtherPassport = parseInt(OtherPassport)
		local Identity = vRP.Identity(OtherPassport)

		if parseInt(Identity["gun"]) == 0 then
			PortStatus = "Ativado"
			vRP.UpdateGunlicense(OtherPassport, 1)
		else
			vRP.UpdateGunlicense(OtherPassport, 0)
		end

		TriggerClientEvent("Notify", source, "verde", "Porte atualizado.")
		TriggerClientEvent("police:Update", source, "reloadSearch", parseInt(OtherPassport))

		if NewBankTaxs then
			exports["bank"]:AddTaxs(OtherPassport, "Prefeitura", 35, "Atualização de Identidade.")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:REDUCES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Reduces")
AddEventHandler("police:Reduces", function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Identity = vRP.Identity(Passport)
		if parseInt(Identity["prison"]) > 0 then
			if not Reduces[Number] then
				Reduces[Number] = {}
			end

			if Reduces[Number][Passport] then
				if os.time() > Reduces[Number][Passport] then
					Reduction(source, Passport, Number)
				else
					TriggerClientEvent("Notify",source,"amarelo","Aguarde "..CompleteTimers(Reduces[Number][Passport] - os.time())..".",5000)
				end
			else
				Reduction(source, Passport, Number)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCTION
-----------------------------------------------------------------------------------------------------------------------------------------
function Reduction(source, Passport, Number)
	vRPC.playAnim(source, false, { "amb@prop_human_bum_bin@base", "base" }, true)
	TriggerClientEvent("Progress", source, "Vasculhando", 10000)
	Reduces[Number][Passport] = os.time() + 600
	Player(source)["state"]["Buttons"] = true
	Player(source)["state"]["Cancel"] = true
	local timeProgress = 10

	repeat
		Wait(1000)
		timeProgress = timeProgress - 1
	until timeProgress <= 0

	local ItemChance = math.random(1, 100)
		if ItemChance >= 85 then
		local Random = math.random(#PrisonItens)
		local Amount = math.random(PrisonItens[Random]["Min"], PrisonItens[Random]["Max"])
		vRP.GenerateItem(Passport, PrisonItens[Random]["Item"], Amount, true)
	else
		TriggerClientEvent("Notify",source,"amarelo","Você não encontrou nada enquanto vasculhava.",5000)
	end

	if vRP.HasGroup(Passport, "Premium") then
		vRP.UpdatePrison(Passport, math.random(7, 9))
	elseif vRP.HasGroup(Passport, "PremiumOuro") then
		vRP.UpdatePrison(Passport, math.random(5, 7))
	elseif vRP.HasGroup(Passport, "PremiumPrata") then
		vRP.UpdatePrison(Passport, math.random(3, 5))
	else
		vRP.UpdatePrison(Passport, 1)
	end

	Player(source)["state"]["Buttons"] = false
	Player(source)["state"]["Cancel"] = false
	vRPC.Destroy(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:SCAPE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Scape")
AddEventHandler("police:Scape", function()
	local source = source
	local Passport = vRP.Passport(source)
	local Service, Total = vRP.NumPermission("Policia")
	local Coords = vRP.GetEntityCoords(source)
	if Passport then
		if Total >= 1 then
			if vRP.TakeItem(Passport, "key", 1, true) then
				Player(source)["state"]["Prison"] = false

				exports["blipsystem"]:Exit(source)
				vCLIENT.Sync(source, true, false)
				vRP.Query("characters/CleanPrison", { Passport = Passport })

				for Passports, Sources in pairs(Service) do
					async(function()
						vRPC.PlaySound(Sources, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
						TriggerClientEvent("Notify", Sources, "amarelo","Encontramos um fugitivo da penitenciária e todos os policiais foram avisados.", 5000)
						TriggerClientEvent("NotifyPush", Sources, { code = "QRU", title = "Fuga Do Presidio", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alarme de segurança", time = "Recebido às " .. os.date("%H:%M"), blipColor = 16 })
					end)
				end
			else
				TriggerClientEvent("Notify", source, "amarelo", "Você precisa de <b>1x " .. itemName("key") .. "</b>.", 5000)
			end
		else
			TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.",  5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Plate")
AddEventHandler("police:Plate", function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		PlateVehicle(source, Entity[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function PlateVehicle(source, Plate)
	local Passport = vRP.PassportPlate(Plate)
	if Passport then
		local Identity = vRP.Identity(Passport["Passport"])
		vRPC.PlaySound(source, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify", source, "azul","<b>Passaporte:</b> " .. Identity["id"] .. "<br><b>Nome:</b> " .. Identity["name"] .. " " .. Identity["name2"] .. "<br><b>Nº:</b> " .. Identity["phone"], false, 10000)
	else
		if not PlateSave[Plate] then
			PlateSave[Plate] = { PlateName[math.random(#PlateName)] .. " " .. PlateLastname[math.random(#PlateLastname)], vRP.GeneratePhone() }
		end

		vRPC.PlaySound(source, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
		TriggerClientEvent("Notify", source, "azul", "<b>Passaporte:</b> 9.999<br><b>Nome:</b> " .. PlateSave[Plate][1] .. "<br><b>Nº:</b> " .. PlateSave[Plate][2], false, 10000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:ARRESTVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:ArrestVehicles")
AddEventHandler("police:ArrestVehicles", function(entity)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        local Ped = GetPlayerPed(source)
        local Coords = GetEntityCoords(Ped)

        local Distance = {
            { 1313.64,-723.49,65.11  },		-- PMERJ
            { -318.42,-1050.4,27.47  },		-- PCERJ
            { 2540.97,-385.06,92.99  },		-- BOPE
            { -790.07,-2678.38,13.82 },		-- CHOQUE
            { 4047.09,-4836.11,6.6   },		-- EX
            { -1741.33,-737.85,12.1  },		-- RECOM
			{ 2625.08,5315.07,46.72  },		-- PRF
            { 409.03,-1638.92,29.28  }		-- IMPOUND
        }

        local DistanceDP = false
        for _, DPposition in ipairs(Distance) do
            local DPx = Coords.x - DPposition[1]
            local DPy = Coords.y - DPposition[2]
            local DPz = Coords.z - DPposition[3] 
            local distance = math.sqrt(DPx * DPx + DPy * DPy + DPz * DPz) 

            if distance <= 100.0 then 
                DistanceDP = true
                break
            end
        end

        if DistanceDP then
            if vRP.Request(source, "Apreender o veículo?") then
                local Passport = vRP.PassportPlate(entity[1])
                if Passport then
                    local Vehicle = vRP.Query("vehicles/selectVehicles", { Passport = Passport["Passport"], vehicle = entity[2] })
                    if Vehicle[1] then
                        if Vehicle[1]["arrest"] <= os.time() then
                            vRP.Query("vehicles/arrestVehicles", { Passport = Passport["Passport"], vehicle = entity[2] })
                            TriggerClientEvent("Notify", source, "verde", "Veículo apreendido.", 5000)
                        else
                            TriggerClientEvent("Notify", source, "amarelo", "Veículo já se encontra apreendido.", 5000)
                        end
                    end
                end
            end
        else
            TriggerClientEvent("Notify", source, "police", "Você precisa estar perto de um Departamento Policial para apreender o veículo.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:ARRESTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:ArrestItens")
AddEventHandler("police:ArrestItens", function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.Passport(Entity)
		local Inventory = vRP.Inventory(OtherPassport)
		if Inventory then
			for i = 1, vRP.GetWeight(OtherPassport) do
				local Slot = tostring(i)
				if Inventory[Slot] then
					if itemArrest(Inventory[Slot]["item"]) then
						vRP.RemoveItem(OtherPassport, Inventory[Slot]["item"], Inventory[Slot]["amount"], ArrestNotify)
						vRP.GiveItem(Passport, Inventory[Slot]["item"], Inventory[Slot]["amount"], ArrestNotify)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLACA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("placa",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Policia") and Message[1] then
			PlateVehicle(source,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANREC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cleanrec", function(source, Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport, "Policia", 1) and Message[1] and tonumber(Message[1]) then
		vRP.Query("prison/Clean", { ["nuser_id"] = tonumber(Message[1]) })

		if NewBankTaxs then
			exports["bank"]:AddTaxs(tonumber(Message[1]), "Prefeitura", 1250, "Limpeza de Ficha.")
		end
		
		TriggerClientEvent("Notify", source, "verde", "Ficha limpa.", 5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SOLTAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("soltar", function(source, args)
    local Passport = vRP.Passport(source)
    if Passport and args[1] then
        if vRP.HasGroup(Passport, "Admin",1) then
            local OtherPlayer = vRP.Source(tonumber(args[1]))
            if OtherPlayer then
                TriggerClientEvent("police:Prisioner", OtherPlayer, false)
                TriggerClientEvent("Notify", OtherPlayer, "azul", "Sua sentença terminou, esperamos não vê-lo novamente.", 5000)
                vRP.Query("characters/CleanPrison", { Passport = tonumber(args[1]) })
                Player(OtherPlayer)["state"]["Prison"] = false
                vRP.Teleport(tonumber(args[1]), BackPrison.x, BackPrison.y, BackPrison.z)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("perimetro", function(source)
    local Passport = vRP.Passport(source)

    if Passport then
        if vRP.HasGroup(Passport, "Policia", 2) or vRP.HasGroup(Passport, "Admin", 2) then
            local Keyboard = vKEYBOARD.keyDouble(source, "ABRIR OU FECHAR PERÍMETRO", "NOME DA AÇÃO")

            if Keyboard and Keyboard[1] then
                local State = Keyboard[1]
                local Action = Keyboard[2]

                local Ped = GetPlayerPed(source)
                local Coords = GetEntityCoords(Ped)

                if State == "ABRIR" then
                    if Coords then
                        Perimeters[Action] = { x = Coords["x"], y = Coords["y"], z = Coords["z"] }
                        TriggerClientEvent("police:Perimeter", -1, Coords["x"], Coords["y"], Coords["z"], Action)
                        TriggerClientEvent("Notify", -1, "police", "Informamos que o perímetro do(a) <b>" .. Action .. "</b> está sob atividades criminosas. Qualquer aproximação será considerada hostil. Para melhor visualização, marcamos em seu GPS a área exposta.", 30000, "DEPARTAMENTO DE POLICIA")
                    end
                elseif State == "FECHAR" then
                    if Perimeters[Action] then
                        Perimeters[Action] = nil
                        TriggerClientEvent("police:DeletePerimeter", -1, Action)
                        TriggerClientEvent("Notify", -1, "police", "Informamos que o perímetro do(a) <b>" .. Action .. "</b> se encontra em código 4 e livre para circulação. Agradecemos a compreensão.", 30000, "DEPARTAMENTO DE POLICIA")
                    else
                        TriggerClientEvent("Notify", source, "amarelo", "Nenhum perímetro com o nome <b>" .. Action .. "</b> está ativo.", 5000)
                    end
                end
            end
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
--------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, source)
	local Identity = vRP.Identity(Passport)
	if parseInt(Identity["prison"]) > 0 then
		Player(source)["state"]["Prison"] = true
		exports["blipsystem"]:Enter(source, "Prisioneiro")
		TriggerClientEvent("Notify", source, "amarelo", "Você ainda precisa cumprir <b>" .. parseInt(Identity["prison"]) .. " Serviços</b> para ter a redução penal zerada.",10000)
	end

	if Active[Passport] == true then
		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end

	if Announces[Passport] then
		Announces[Passport] = nil
	end
end)