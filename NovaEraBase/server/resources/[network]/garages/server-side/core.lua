-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages",Creative)
vCLIENT = Tunnel.getInterface("garages")
vKEYBOARD = Tunnel.getInterface("keyboard")
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
GlobalState["Nitro"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Verify(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return false end

	if vRP.GetFine(Passport) > 0 then
		TriggerClientEvent("Notify", source, "amarelo", "Você possui multas pendentes.", 10000)
		return false
	end

	if exports["hud"]:Wanted(Passport, source) then
		return false
	end

	if Garages[Number]["license"] then
		local Driverlicense = vRP.UserData(Passport, "Driverlicense")

		if not Driverlicense or not Driverlicense["categories"] or json.encode(Driverlicense) == "[]" then
			TriggerClientEvent("Notify", source, "amarelo", "Você não possui <b>Carteira de Habilitação</b>.", 5000)
			return false
		end

		local RequiredCategory = Garages[Number]["license"]
		if RequiredCategory == true then return true end

		local categoriesToCheck = type(RequiredCategory) == "string" and { RequiredCategory } or RequiredCategory
		local ValidLicense = false
		for _, category in ipairs(categoriesToCheck) do
			for _, playerCategory in pairs(Driverlicense["categories"]) do
				if playerCategory == category then
					ValidLicense = true
					break
				end
			end
			if ValidLicense then break end
		end

		if not ValidLicense then
			TriggerClientEvent("Notify", source, "amarelo", "Você não possui a categoria necessária (<b>" .. (type(RequiredCategory) == "table" and table.concat(RequiredCategory, ", ") or RequiredCategory) .. "</b>) para abrir esta garagem.", 5000)
			return false
		end

		if os.time() > (Driverlicense["expiration"] or 0) then
			TriggerClientEvent("Notify", source, "amarelo", "Sua <b>Carteira de Habilitação</b> está vencida.", 5000)
			return false
		end

		return true
	end

	local garage = Garages[Number]
	if garage then
		local work = vRP.GetWork(Passport)
		local RequiredJob = RequiredGarageJobs[garage.name]

		if RequiredJob and work ~= RequiredJob then
			TriggerClientEvent("Notify", source, "amarelo", "Você não possui <b>Carteira de Trabalho Assinada</b> para este emprego: " .. ClassWork(RequiredJob) .. ".", 5000)
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ServerVehicle(Model, x, y, z, Heading, Plate, Nitrox, Doors, Body, Fuel)
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
            local DoorsTable = json.decode(Doors)
            if DoorsTable ~= nil then
                for Number, Status in pairs(DoorsTable) do
                    if Status then
                        SetVehicleDoorBroken(Vehicle, parseInt(Number), true)
                    end
                end
            end
        end

        if SpawnVehicleLocked then
            SetVehicleDoorsLocked(Vehicle, 2)
        else
            SetVehicleDoorsLocked(Vehicle, 1)
        end

        local Network = NetworkGetNetworkIdFromEntity(Vehicle)

        if Model ~= "wheelchair" then
            SetVehicleDoorsLocked(Vehicle, SpawnVehicleLocked and 2 or 1)
            if not GlobalState["Nitro"] then
                GlobalState["Nitro"] = {}
            end
            local Nitro = GlobalState["Nitro"]
            Nitro[Plate] = Nitrox or 0
            GlobalState:set("Nitro", Nitro, true)
        end

        return Network, Vehicle
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("signalRemove",function(Plate)
	if not Signal[Plate] then
		Signal[Plate] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateReveryone",function(Plate)
	if GlobalState["Plates"][Plate] then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = nil
		GlobalState:set("Plates",Plates,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateEveryone",function(Plate)
	local Plates = GlobalState["Plates"]
	Plates[Plate] = true
	GlobalState:set("Plates",Plates,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("platePlayers",function(Plate,Passport)
	if not vRP.PassportPlate(Plate) then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = Passport
		GlobalState:set("Plates",Plates,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Vehicles(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport) then
		if Garages[Number]["perm"] then
			if not vRP.HasService(Passport,Garages[Number]["perm"]) then
				return false
			end
		end

		if string.sub(Number,1,9) == "Propertys" then
			local Consult = vRP.Query("propertys/Exist",{ name = Number })
			if Consult[1] then
				if parseInt(Consult[1]["Passport"]) == Passport or vRP.InventoryFull(Passport,"propertys-"..Consult[1]["Serial"]) then
					if os.time() > Consult[1]["Tax"] then
						TriggerClientEvent("Notify",source,"amarelo","Aluguel atrasado, procure um <b>Corretor de Imóveis</b>.",5000)
						return false
					end
				else
					return false
				end
			end
		end

		local Vehicle = {}
		local Garage = Garages[Number]["name"]
		if GaragesVehicles[Garage] then
			for _,v in pairs(GaragesVehicles[Garage]) do
				local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = v })
				if VehicleExist(v) then
					if vehicle[1] then
						Vehicle[#Vehicle + 1] = { 
							["model"] = v,
							["name"] = VehicleName(v),
	
							["type"] = VehicleMode(v),
	
							["engine"] = vehicle[1]["engine"],
							["chassi"] = vehicle[1]["health"],
							["body"] = vehicle[1]["body"],
							["gas"] = vehicle[1]["fuel"],
	
							["chest"] = VehicleChest(v),
							["tax"] = VehiclePrice(v) * PercetageTax
						}
					else
						Vehicle[#Vehicle + 1] = { 
							["model"] = v,
							["name"] = VehicleName(v),
	
							["type"] = VehicleMode(v),
	
							["engine"] = 1000,
							["chassi"] = 1000,
							["body"] = 1000,
							["gas"] = 100,
	
							["chest"] = VehicleChest(v),
							["tax"] = VehiclePrice(v) * PercetageTax
						}
					end
				end
			end
		else
			local Consult = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })
			for _,v in pairs(Consult) do
				if VehicleExist(v["vehicle"]) then
					if v["work"] == "false" then
						Vehicle[#Vehicle + 1] = { 
							["model"] = v["vehicle"],
							["name"] = VehicleName(v["vehicle"]),

							["type"] = VehicleMode(v["vehicle"]),

							["engine"] = v["engine"],
							["chassi"] = v["health"],
							["body"] = v["body"],
							["gas"] = v["fuel"],

							["chest"] = VehicleChest(v["vehicle"]),
							["tax"] = VehiclePrice(v["vehicle"]) * PercetageTax
						}
					end
				end
			end
		end

		return Vehicle
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Impound()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicles = {}
		local Vehicle = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })

		for Number,v in ipairs(Vehicle) do
			if v["arrest"] >= os.time() then
				Vehicles[#Vehicles + 1] = { ["Model"] = Vehicle[Number]["vehicle"], ["name"] = VehicleName(Vehicle[Number]["vehicle"]) }
			end
		end

		return Vehicles
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Impound")
AddEventHandler("garages:Impound",function(vehName)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local VehiclePrice = VehiclePrice(vehName) * PercentageArrest
		TriggerClientEvent("dynamic:closeSystem",source)

		if vRP.Request(source,"A liberação do veículo tem o custo de <b>$"..parseFormat(VehiclePrice).."</b> dólares, deseja prosseguir com a liberação do mesmo?","Sim, efetuar o pagamento","Não, decido depois") then
			if vRP.PaymentFull(Passport,VehiclePrice) then
				vRP.Query("vehicles/paymentArrest",{ Passport = Passport, vehicle = vehName })
				TriggerClientEvent("Notify",source,"verde","Veículo liberado.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAX
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Tax(Name)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Consult = vRP.Query("vehicles/selectVehicles", { Passport = Passport, vehicle = Name })
        if Consult[1] and Consult[1]["tax"] <= os.time() then
            local Price = VehiclePrice(Name) * PercetageTax

            if vRP.Request(source, "Deseja Pagar a Taxa do veiculo por <b>$" .. parseFormat(Price) .. "</b> dólares?") then
                if vRP.PaymentFull(Passport, Price) then
                    vRP.Query("vehicles/updateVehiclesTax", { Passport = Passport, vehicle = Name })
                    TriggerClientEvent("Notify", source, "verde", "Pagamento concluído.", 5000)
                else
                    TriggerClientEvent("Notify", source, "vermelho", "<b>Dólares</b> insuficientes.", 5000)
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Sell(Name)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Mode = VehicleMode(Name)
        for _, ProhibitedMode in ipairs(ProhibitedClasses) do
            if Mode == ProhibitedMode then
                TriggerClientEvent("Notify", source, "amarelo", "Veículos de Aluguel ou de Trabalho não podem ser transferidos.", 5000)
                return false
            end
        end

        local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
        if Consult[1] then
            local Price = VehiclePrice(Name) * PercetageSelling
            if vRP.Request(source,"Vender o veículo <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(Price).."</b>?","Sim, concluír venda","Não, mudei de ideia") then
                local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
                if Consult[1] then
                    vRP.GiveBank(Passport,Price)
                    vRP.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = Name })
                    vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
                    vRP.Query("entitydata/RemoveData",{ dkey = "Chest:"..Passport..":"..Name })

                    TriggerEvent("Discord","GaragesVenda","**[Venda de Veículo]**\n\n**Passaporte:** "..Passport.."\n**Veículo Vendido:** "..Name.."\n**Valor:** $"..parseFormat(Price) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Transfer(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Mode = VehicleMode(Name)
        for _, ProhibitedMode in ipairs(ProhibitedClasses) do
            if Mode == ProhibitedMode then
                TriggerClientEvent("Notify", source, "amarelo", "Veículos de Aluguel ou de Trabalho não podem ser transferidos.", 5000)
                return false
            end
        end
		
		local myVehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if myVehicle[1] then
			TriggerClientEvent("dynamic:closeSystem",source)

			local Keyboard = vKEYBOARD.keySingle(source,"Passaporte:")
			if Keyboard then
				local OtherPassport = tonumber(Keyboard[1])
				local Identity = vRP.Identity(OtherPassport)
				if Identity then

					local MaxVehicles = MaxVehiclePadrao
					if vRP.HasGroup(Passport,"PremiumPrata") then
						MaxVehicles = MaxVehicles + MaxVehiclePremiumPrata
					elseif vRP.HasGroup(Passport,"PremiumOuro") then
						MaxVehicles = MaxVehicles + MaxVehiclePremiumOuro
					elseif vRP.HasGroup(Passport,"PremiumPlatina") then
						MaxVehicles = MaxVehicles + MaxVehiclePremiumPlatina
					end

					local Vehicles = exports["oxmysql"]:query_async("SELECT vehicle, COUNT(vehicle) AS countVehicle FROM vehicles WHERE work = 'false' AND Passport = @Passport GROUP BY vehicle ORDER BY countVehicle DESC;",{ Passport = OtherPassport })
					if #Vehicles >= MaxVehicles then
						TriggerClientEvent("Notify",source,"azul","<b>"..Identity["name"].." "..Identity["name2"].."</b> Atingiu o número máximo de veículos em sua garagem.",8000)
					else

						if vRP.Request(source,"Transferir o veículo <b>"..VehicleName(Name).."</b> para <b>"..Identity["name"].." "..Identity["name2"].."</b>?","Sim, transferir","Não, mudei de ideia") then
							local Vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = OtherPassport, vehicle = Name })
							if Vehicle[1] then
								TriggerClientEvent("Notify",source,"amarelo","<b>"..Identity["name"].." "..Identity["name2"].."</b> já possui este modelo de veículo.",5000)
							else
								vRP.Query("vehicles/moveVehicles",{ Passport = Passport, OtherPassport = OtherPassport, vehicle = Name })

								local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
								if #Datatable > 0 then
									vRP.Query("entitydata/SetData",{ dkey = "Mods:"..OtherPassport..":"..Name, dvalue = Datatable[1]["dvalue"] })
									vRP.Query("entitydata/RemoveData",{ dkey = "Mods:"..Passport..":"..Name })
								end

								local Datatable = vRP.GetSrvData("Chest:"..Passport..":"..Name)
								vRP.SetSrvData("Chest:"..OtherPassport..":"..Name,Datatable)
								vRP.RemSrvData("Chest:"..Passport..":"..Name)

								TriggerClientEvent("Notify",source,"verde","Transferência concluída.",5000)
							end
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Spawn(Name, Number)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Gemstone = VehicleGems(Name)
        local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })

        if not vehicle[1] then
            if parseInt(Gemstone) > 0 then
                local GemTax = parseInt(Gemstone * PercetageTaxGemstoneInitial)
                if vRP.Request(source,"Alugar o veículo <b>"..VehicleName(Name).."</b> por <b>"..GemTax.."</b> gemas?","Sim, concluír aluguel","Não, mudei de ideia") then
                    if vRP.PaymentGems(Passport,GemTax) then
                        vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
                        TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.",5000)
                        vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
                    else
                        TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
                        return
                    end
                else
                    return
                end
            else
                local VehiclePrice = VehiclePrice(Name)
                if parseInt(VehiclePrice) > 0 then
                    if vRP.Request(source,"Comprar <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(VehiclePrice).."</b> dólares?","Sim, concluír pagamento","Não, mudei de ideia") then
                        if vRP.PaymentFull(Passport,VehiclePrice) then
                            vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
                            vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
                        else
                            TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
                        end
                    else
                        return
                    end
                else
                    vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
                    vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
                end
            end
        end

        if vehicle[1] then
            local Plates = GlobalState["Plates"]
            local Plate = vehicle[1]["plate"]

            if Spawn[Plate] then
                if not Signal[Plate] then
                    if not Searched[Passport] then
                        Searched[Passport] = os.time()
                    end

                    if os.time() >= parseInt(Searched[Passport]) then
                        Searched[Passport] = os.time() + 60

                        local Network = Spawn[Plate][3]
                        local Network = NetworkGetEntityFromNetworkId(Network)
                        if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
                            vCLIENT.SearchBlip(source,GetEntityCoords(Network))
                            TriggerClientEvent("Notify",source,"amarelo","Rastreador do veículo foi ativado por <b>30</b> segundos, lembrando que se o mesmo estiver em movimento a localização pode ser imprecisa.",10000)
                        else
                            if Spawn[Plate] then
                                Spawn[Plate] = nil
                            end

                            if Plates[Plate] then
                                Plates[Plate] = nil
                                GlobalState:set("Plates",Plates,true)
                            end

                            TriggerClientEvent("Notify",source,"verde","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.",5000)
                        end
                    else
                        TriggerClientEvent("Notify",source,"amarelo","Rastreador só pode ser ativado a cada <b>60</b> segundos.",5000)
                    end
                else
                    TriggerClientEvent("Notify",source,"amarelo","Rastreador está desativado.",5000)
                end
            else
                if vehicle[1]["tax"] <= os.time() then
                    TriggerClientEvent("Notify",source,"amarelo","Taxa do veículo atrasada.",5000)
                elseif vehicle[1]["arrest"] >= os.time() then
                    TriggerClientEvent("Notify",source,"amarelo","Veículo apreendido, dirija-se até o <b>Impound</b> e efetue o pagamento da liberação do mesmo.",5000)
                else
                    if vehicle[1]["rental"] ~= 0 then
                        if vehicle[1]["rental"] <= os.time() then
                            local GemTax = parseInt(Gemstone * PercetageTaxgemstoneRenew)
                            if vRP.Request(source,"Atualizar o aluguel do veículo <b>"..VehicleName(Name).."</b> por <b>"..GemTax.." gemas</b>?","Sim, concluír pagamento","Não, mudei de ideia") then
                                if vRP.PaymentGems(Passport,GemTax) then
                                    vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
                                    TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.",5000)
                                else
                                    TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
                                    return
                                end
                            else
                                return
                            end
                        end
                    end

                    local Coords = vCLIENT.SpawnPosition(source,Number)
                    if Coords then
                        local Mods = nil
                        local Datatable = vRP.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
                        if parseInt(#Datatable) > 0 then
                            Mods = Datatable[1]["dvalue"]
                        end

                        if Garages[Number]["payment"] then
                            if vRP.UserPremium(Passport) or vRP.UserPremiumOuro(Passport) or vRP.UserPremiumPrata(Passport) then
                                TriggerClientEvent("dynamic:closeSystem",source)
                                local Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

                                if Network then
                                    vCLIENT.CreateVehicle(-1, Name, Network, vehicle[1]["engine"], vehicle[1]["health"], Mods, vehicle[1]["windows"], vehicle[1]["tyres"], source)
                                    TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),5000)
                                    TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
                                    Spawn[Plate] = { Passport,Name,Network }

                                    Plates[Plate] = Passport
                                    GlobalState:set("Plates",Plates,true)

                                    TriggerClientEvent("notebook:ApplyRemap", source, Network, Plate)
                                end
                            else
                                local VehiclePrice = VehiclePrice(Name)
                                if vRP.Request(source,"Retirar o veículo por <b>$"..parseFormat(VehiclePrice * PercentageSpawn).."</b> dólares?","Sim, efetuar o pagamento","Não, volto depois") then
                                    local Amount = parseInt(VehiclePrice * PercentageSpawn)
                                    if vRP.ConsultItem(Passport,"dollars",Amount) or vRP.GetBank(source) >= Amount then
                                        TriggerClientEvent("dynamic:closeSystem",source)
                                        local Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

                                        if Network then
                                            vCLIENT.CreateVehicle(-1, Name, Network, vehicle[1]["engine"], vehicle[1]["health"], Mods, vehicle[1]["windows"], vehicle[1]["tyres"], source)
                                            TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),5000)
                                            TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
                                            Spawn[Plate] = { Passport,Name,Network }
                                            vRP.PaymentFull(Passport,Amount)

                                            Plates[Plate] = Passport
                                            GlobalState:set("Plates",Plates,true)

                                            TriggerClientEvent("notebook:ApplyRemap", source, Network, Plate)
                                        end
                                    else
                                        TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
                                    end
                                end
                            end
                        else
                            TriggerClientEvent("dynamic:closeSystem",source)
                            local Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

                            if Network then
                                vCLIENT.CreateVehicle(-1, Name, Network, vehicle[1]["engine"], vehicle[1]["health"], Mods, vehicle[1]["windows"], vehicle[1]["tyres"], source)
                                TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),1000)
                                TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
                                Spawn[Plate] = { Passport,Name,Network }

                                Plates[Plate] = Passport
                                GlobalState:set("Plates",Plates,true)

                                TriggerClientEvent("notebook:ApplyRemap", source, Network, Plate)
                            end
                        end
                    end
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,CarPermission) and Message[1] then
			local VehicleName = Message[1]
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Heading = GetEntityHeading(Ped)
			local Plate = "VEH"..(10000 + Passport)
			local Network,Vehicle = Creative.ServerVehicle(VehicleName,Coords["x"],Coords["y"],Coords["z"],Heading,Plate,2000,nil,1000)

			if not Network then 
				return 
			end

			TriggerEvent("Discord", "GaragesCar", "**[Comando: /car]**\n\n**Passaporte:** " .. Passport .. "\n**Veículo:** " .. VehicleName .. "\n**Placa:** " .. Plate .. "\n**Coordenadas:** x = " .. Coords.x .. ", y = " .. Coords.y .. ", z = " .. Coords.z .. "\n**Heading:** " .. Heading .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)

			vCLIENT.CreateVehicle(-1,VehicleName,Network,1000,1000,nil,false,false)
			Spawn[Plate] = { Passport,VehicleName,Network }
			TriggerEvent("engine:tryFuel",Plate,100)
			SetPedIntoVehicle(Ped,Vehicle,-1)

			local Plates = GlobalState["Plates"]
			Plates[Plate] = Passport
			GlobalState:set("Plates",Plates,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv", function(source)
    local Passport = vRP.Passport(source)
    
    if Passport and vRP.HasGroup(Passport, "Admin") then 
        
     
        if Player(source).state.StaffTime then
            
            TriggerEvent("Discord", "GaragesDv", "**[Comando: /dv]**\n\n**Passaporte:** " .. Passport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
            TriggerClientEvent("garages:Delete", source)
            
        else
            TriggerClientEvent("Notify", source, "vermelho", "Precisas de entrar em modo <b>/staff</b> primeiro!", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:KEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Key")
AddEventHandler("garages:Key",function(entity)
	local source = source
	local Plate = entity[1]
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		vRP.GenerateItem(Passport,"vehkey-"..Plate,1,true,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Lock")
AddEventHandler("garages:Lock",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		TriggerEvent("garages:LockVehicle",source,Network)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:LockVehicle",function(source,Network)
	local Network = NetworkGetEntityFromNetworkId(Network)
	local Doors = GetVehicleDoorLockStatus(Network)

	if parseInt(Doors) <= 1 then
		TriggerClientEvent("Notify",source,"locked","Veículo trancado.",5000)
		TriggerClientEvent("sounds:source",source,"unlocked",0.7)
		SetVehicleDoorsLocked(Network,2)
	else
		TriggerClientEvent("Notify",source,"unlocked","Veículo destrancado.",5000)
		TriggerClientEvent("sounds:source",source,"locked",0.7)
		SetVehicleDoorsLocked(Network,1)
	end

	if not vRP.InsideVehicle(source) then
		vRPC.CreateObjects(source,"anim@mp_player_intmenu@key_fob@","fob_click_fp","p_car_keys_01",48,57005,0.11, 0.03, -0.03, 90.0, 0.0, 0.0)
		Wait(500)
		vRPC.Destroy(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Delete(Network,Health,Engine,Body,Fuel,Doors,Windows,Tyres,Plate)
	if Spawn[Plate] then
		local Passport = Spawn[Plate][1]
		local vehName = Spawn[Plate][2]

		if parseInt(Engine) <= 100 then
			Engine = 100
		end

		if parseInt(Body) <= 100 then
			Body = 100
		end

		if parseInt(Fuel) >= 100 then
			Fuel = 100
		end

		if parseInt(Fuel) <= 0 then
			Fuel = 0
		end

		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] ~= nil then
			vRP.Query("vehicles/updateVehicles",{ Passport = Passport, vehicle = vehName, nitro = (GlobalState["Nitro"] and GlobalState["Nitro"][Plate]) or 0, engine = parseInt(Engine), body = parseInt(Body), health = parseInt(Health), fuel = parseInt(Fuel), doors = json.encode(Doors), windows = json.encode(Windows), tyres = json.encode(Tyres) })
		end
	end

	TriggerEvent("garages:deleteVehicle",Network,Plate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicle")
AddEventHandler("garages:deleteVehicle",function(Network,Plate)
	if Network ~= nil and Plate ~= nil then
		if GlobalState["Plates"][Plate] then
			local Plates = GlobalState["Plates"]
			Plates[Plate] = nil
			GlobalState:set("Plates",Plates,true)
		end

		if GlobalState["Nitro"] and GlobalState["Nitro"][Plate] then
			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = nil
			GlobalState:set("Nitro",Nitro,true)
		end

		if Signal[Plate] then
			Signal[Plate] = nil
		end

		if Spawn[Plate] then
			Spawn[Plate] = nil
		end

		if string.sub(Plate,1,4) == "DISM" then
			local Passport = parseInt(string.sub(Plate,5,8)) - 1000
			local source = vRP.Source(Passport)
			if source then
				TriggerClientEvent("target:DismantleReset",source)
				TriggerClientEvent("Notify",source,"amarelo","O veículo do seu contrato foi encaminhado para o <b>Impound</b> e o <b>Lester</b> disse que você pode assinar um novo contrato quando quiser.",10000)
			end
		end

		local Network = NetworkGetEntityFromNetworkId(Network)
		if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 and GetVehicleNumberPlateText(Network) == Plate then
			DeleteEntity(Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DISMANTLEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:dismantleVehicle")
AddEventHandler("garages:dismantleVehicle", function(Network, Plate)
	if Network ~= nil and Plate ~= nil then
		if GlobalState["Plates"][Plate] then
			local Plates = GlobalState["Plates"]
			Plates[Plate] = nil
			GlobalState:set("Plates", Plates, true)
		end

		if GlobalState["Nitro"] and GlobalState["Nitro"][Plate] then
			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = nil
			GlobalState:set("Nitro", Nitro, true)
		end

		if Signal[Plate] then
			Signal[Plate] = nil
		end

		if Spawn[Plate] then
			Spawn[Plate] = nil
		end

		if string.sub(Plate, 1, 4) == "DISM" then
			local Passport = parseInt(string.sub(Plate, 5, 8)) - 1000
			local source = vRP.Source(Passport)
			if source then
				TriggerClientEvent("target:DismantleReset", source)
				TriggerClientEvent("Notify", source, "verde","O seu serviço foi finalizado com sucesso, e você pode assinar um novo contrato quando quiser.", 10000)
			end
		end

		local Network = NetworkGetEntityFromNetworkId(Network)
		if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 and GetVehicleNumberPlateText(Network) == Plate then
			DeleteEntity(Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Propertys")
AddEventHandler("garages:Propertys",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("dynamic:closeSystem",source)
		TriggerClientEvent("Notify",source,"amarelo","Selecione o local da garagem.",5000)

		local Hash = "prop_offroad_tyres02"
		local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
		if Application then
			if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
				TriggerClientEvent("Notify",source,"amarelo","Selecione o local do veículo.",5000)

				local Open = Coords
				local Hash = "patriot"
				local Application,Coords,Heading = vRPC.objectCoords(source,Hash)
				if Application then
					if #(Coords - exports["propertys"]:Coords(Name)) <= 25 then
						local New = {
							["1"] = { mathLength(Open["x"]),mathLength(Open["y"]),mathLength(Open["z"] + 1) },
							["2"] = { mathLength(Coords["x"]),mathLength(Coords["y"]),mathLength(Coords["z"] + 1),mathLength(Heading) }
						}

						Garages[Name] = { name = "Garage", payment = false, license = false}

						Propertys[Name] = {
							["x"] = New["1"][1],
							["y"] = New["1"][2],
							["z"] = New["1"][3],
							["1"] = New["2"]
						}

						vRP.Query("propertys/Garage",{ name = Name, garage = json.encode(New) })
						TriggerClientEvent("garages:Propertys",-1,Propertys)
					else
						TriggerClientEvent("Notify",source,"amarelo","A garagem precisa ser próximo da entrada.",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","A garagem precisa ser próximo da entrada.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Consult = vRP.Query("propertys/Garages")
	for _,v in pairs(Consult) do
		local Name = v["Name"]
		if not Propertys[Name] and v["Garage"] ~= "{}" then
			local Table = json.decode(v["Garage"])
			Garages[Name] = { name = "Garage", payment = false, license = false }

			Propertys[Name] = {
				["x"] = Table["1"][1],
				["y"] = Table["1"][2],
				["z"] = Table["1"][3],
				["1"] = Table["2"]
			}
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Signal",function(Plate)
	return Signal[Plate]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("garages:Propertys",source,Propertys)
end)