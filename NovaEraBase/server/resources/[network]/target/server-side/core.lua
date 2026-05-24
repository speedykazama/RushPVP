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
Tunnel.bindInterface("target",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Calls = {}
local Workout = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
for Number,_ in pairs(Academy) do
	GlobalState["Academy-"..Number] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Academy(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not GlobalState["Academy-"..Number] and not Workout[Passport] then
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Cancel"] = true
		GlobalState["Academy-"..Number] = true
		Workout[Passport] = Number

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AcademyWeight(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Academy-"..Number] and Workout[Passport] == Number then
		local GainWeight = Academy[Number]["Weight"]

		if vRP.GetWeight(Passport, true) < 120 then
			vRP.SetWeight(Passport, GainWeight)
			TriggerClientEvent("Notify", source, "Academia", "Sinto minha força alcançando novos patamares, não há limites quando se trata de determinação e dedicação.", 5000)
		else
			TriggerClientEvent("Notify", source, "vermelho", "Você atingiu o seu limite na academia.", 5000)
		end

		Player(source)["state"]["Buttons"] = false
		Player(source)["state"]["Cancel"] = false
		GlobalState["Academy-"..Number] = false
		Workout[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Workout[Passport] then
		GlobalState["Academy-"..Workout[Passport]] = false
		Workout[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckIn()
    local source = source
    local Passport = vRP.Passport(source)

    local MedicInService = vRP.NumPermission("Paramedic")
    if #MedicInService >= 1 then
        TriggerClientEvent("Notify", source, "vermelho", "Existem Paramédicos em Serviço!", 5000)
        return false
    end

    if Passport then
        local MedicPlan = vRP.UserMedicPlan(Passport)

        if not MedicPlan then
            TriggerClientEvent("Notify", source, "vermelho", "Você não possui um plano de saúde ativo. Procure um médico ou contrate um plano.", 7000)
            return false
        end

        if vRP.GetHealth(source) > 100 then
            if not vRP.Request(source, "Prosseguir com o tratamento gratuito?") then
                return false
            end
        end

        vRP.UpgradeHunger(Passport, 20)
        vRP.UpgradeThirst(Passport, 20)
        -- TriggerEvent("Reposed", source, Passport, 900)

        TriggerClientEvent("Notify", source, "azul", "Seu plano de saúde cobriu todas as despesas médicas.", 5000)
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:MEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Medicplan")
AddEventHandler("target:Medicplan",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not vRP.UserMedicPlan(Passport) then
			if vRP.Request(source,"Assinar o plano de saúde por <b>$10.000</b>? Lembrando que a duração do mesmo é de 7 dias.") then
				if vRP.PaymentFull(Passport,10000,"Plano de Saúde") then
					vRP.SetMedicPlan(Passport,parseInt(os.time()+604800))
					vRP.GiveItem(Passport,"medicplan-" .. Passport,1,true)
					TriggerClientEvent("Notify",source,"verde","Obrigado por escolher nosso plano de saúde. Estamos aqui para cuidar de você!",5000)
				end
			end
		else
			if vRP.Request(source,"Prezado(a) cliente, está considerando uma segunda via do cartão do plano de saúde? Fico à disposição para ajudar. O custo é de <b>$1500</b>?") then
				if vRP.PaymentFull(Passport,1500,"Cartão Plano de Saúde") then
					vRP.GiveItem(Passport,"medicplan-" .. Passport,1,true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CALLWORKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:CallWorks")
AddEventHandler("target:CallWorks",function(Perm)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Calls[Perm] then
			Calls[Perm] = os.time()
		end

		if os.time() >= Calls[Perm] then
			if Perm == "Paramedic" then
                TriggerClientEvent("Notify",-1,"paramedic","<b>Hospital São Lucas:</b> Estamos em busca de doadores de sangue, seja solidário e ajude o próximo, procure um de nossos profissionais.",15000)
			elseif Perm == "Mechanic" then
				TriggerClientEvent("Notify",-1,"mecanico","<b>Mecanica East Custom:</b> Estamos atendendo, qualquer servico chamar ou vim até a Mecânica!",15000)
            elseif Perm == "Mechanic2" then
				TriggerClientEvent("Notify",-1,"mecanico","<b>Mecanica Red Lines:</b> Estamos atendendo, qualquer servico chamar ou vim até a Mecânica!",15000)
			end

			Calls[Perm] = os.time() + 600
		else
			local Cooldown = parseInt(Calls[Perm] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Cooldown.."</b> segundos.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Call")
AddEventHandler("target:Call", function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	local Identity = vRP.Identity(Passport)
	if Passport and Identity then
		if not Calls[Service] then
			Calls[Service] = os.time()
		end

		if os.time() >= Calls[Service] then
			if vRP.Request(source,  "Você realmente deseja ligar para <b>" .. Service .. "</b> por <b>$25</b>?") then
				TriggerClientEvent("emotes", source, "ligar")

				local Keyboard = vKEYBOARD.keyArea(source,"Qual o motivo do chamado?")
				if Keyboard then
					if vRP.PaymentFull(Passport,25) then
						local Coords = vRP.GetEntityCoords(source)
						local Permission = vRP.NumPermission(Service)
						for Passports,Sources in pairs(Permission) do
							async(function()
								TriggerClientEvent("NotifyPush",Sources,{ code = 20, phone = Identity["phone"], title = "Chamado de " .. Identity["name"] .. " " .. Identity["name2"], text = Keyboard[1], x = Coords["x"], y = Coords["y"], z = Coords["z"], time = "Recebido às " .. os.date("%H:%M"), blipColor = 2 })
							end)
						end

                        if NewBankTaxs then
							exports["bank"]:AddTaxs(Passport,"Prefeitura",25,"Telefone Coletivo.")
						end

						Calls[Service] = os.time() + 350
					end
				end

				vRPC.Destroy(source)
			end
		else
			local Cooldown = MinimalTimers(Calls[Service] - os.time())
			TriggerClientEvent("Notify", source, "azul", "Aguarde <b>"..Cooldown.."</b> segundos.", false, 5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:JOKENPO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Jokenpo")
AddEventHandler("target:Jokenpo", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local ClosestPed = vRPC.ClosestPed(source, 2)
        if ClosestPed then
            if vRP.GetHealth(ClosestPed) > 100 and not Player(ClosestPed)["state"]["Handcuff"] then
                local Identity = vRP.Identity(Passport)
                
                if vRP.Request(ClosestPed, "Aceitar o pedido de <b>"..Identity["name"].."</b> para jogar <b>Jokenpô</b>?") then
                    local selectedClosestPed = nil
                    if vRP.Request(ClosestPed, "Escolher Pedra?") then
                        selectedClosestPed = "rock"
                    elseif vRP.Request(ClosestPed, "Escolher Papel?") then
                        selectedClosestPed = "paper"
                    elseif vRP.Request(ClosestPed, "Escolher Tesoura?") then
                        selectedClosestPed = "scissors"
                    end

                    local selectedPlayerPed = nil
                    if vRP.Request(source, "Escolher Pedra?") then
                        selectedPlayerPed = "rock"
                    elseif vRP.Request(source, "Escolher Papel?") then
                        selectedPlayerPed = "paper"
                    elseif vRP.Request(source, "Escolher Tesoura?") then
                        selectedPlayerPed = "scissors"
                    end

                    if selectedClosestPed and selectedPlayerPed then
                        local Anims = {
                            ["rock"] = { "baspel@rock@animation", "rock_clip" },
                            ["paper"] = { "baspel@paper@animation", "paper_clip" },
                            ["scissors"] = { "baspel@scissors@animation", "scissors_clip" },
                            ["win"] = { "anim@amb@nightclub@peds@", "amb_world_human_cheering_female_c" },
                            ["lose"] = { "oddjobs@towingangryidle_a", "idle_a" },
                            ["tie"] = { "anim@mp_player_intuppersalute", "idle_a" }
                        }
                        TriggerClientEvent("syncAnim", source, 1.3)
                        vRPC.playAnim(ClosestPed, true, { Anims[selectedClosestPed][1], Anims[selectedClosestPed][2] }, false, 2.0, 2.0, 3000, 2)
                        vRPC.playAnim(source, true, { Anims[selectedPlayerPed][1], Anims[selectedPlayerPed][2] }, false, 2.0, 2.0, 3000, 2)
                        Wait(3200)

                        if selectedPlayerPed == selectedClosestPed then
                            vRPC.playAnim(source, true, { Anims["tie"][1], Anims["tie"][2] }, false, 2.0, 2.0, 3000, 2)
                            vRPC.playAnim(ClosestPed, true, { Anims["tie"][1], Anims["tie"][2] }, false, 2.0, 2.0, 3000, 2)
                        else
                            local resultMapping = {
                                ["rock"] = { ["paper"] = "lose", ["scissors"] = "win" },
                                ["paper"] = { ["rock"] = "win", ["scissors"] = "lose" },
                                ["scissors"] = { ["rock"] = "lose", ["paper"] = "win" }
                            }
                            
                            local playerResult = resultMapping[selectedPlayerPed][selectedClosestPed]
                            if playerResult == "win" then
                                vRPC.playAnim(source, true, { Anims["win"][1], Anims["win"][2] }, false, 2.0, 2.0, 3000, 2)
                                vRPC.playAnim(ClosestPed, true, { Anims["lose"][1], Anims["lose"][2] }, false, 2.0, 2.0, 3000, 2)
                            else
                                vRPC.playAnim(source, true, { Anims["lose"][1], Anims["lose"][2] }, false, 2.0, 2.0, 3000, 2)
                                vRPC.playAnim(ClosestPed, true, { Anims["win"][1], Anims["win"][2] }, false, 2.0, 2.0, 3000, 2)
                            end
                        end
                        
                        Wait(5000)
                        vRPC.stopAnim(ClosestPed, true)
                        vRPC.stopAnim(source, true)
                    end
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Stress")
AddEventHandler("target:Stress",function(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.DowngradeStress(Passport,Number)
	end
end)