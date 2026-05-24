-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local FinesCount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPEEDCAMERAFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SpeedCameraFines(Value, Speed, Vehicle, Plate)
    local source = source
    local Passport = vRP.Passport(source)

    if not RadarEletronico then
        return
    end

    if Passport and not Active[Passport] then
        if not (Player(source)["state"]["TestDrive"] or Player(source)["state"]["DrivingSchool"]) then
            local ignore = false
            for _, group in pairs(SpeedCameraIgnoreList) do
                if vRP.HasGroup(Passport, group) then
                    ignore = true
                    break
                end
            end

            if not ignore then
                local driverLicense = vRP.GetDriverLicense(Passport)
                if driverLicense and driverLicense["categories"] and next(driverLicense["categories"]) ~= nil then
                    Active[Passport] = true

                    local Coords = vRP.GetEntityCoords(source)
                    local Service, Total = vRP.NumPermission(SpeedCameraPermission)
                    for Passports, Sources in pairs(Service) do
                        async(function()
                            TriggerClientEvent("Notify", Sources, "police", "Alguém foi autuado por excesso de velocidade.", 5000)
                            vRPC.PlaySound(Sources, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
                        end)
                    end

                    TriggerClientEvent("sounds:source", source, "speedcamera", 0.5)
                    TriggerClientEvent("Notify", source, "amarelo", "Você excedeu o limite máximo de velocidade e foi multado em $"..Value.." dólares.", 10000)

                    vRP.GiveFine(Passport, Value)

                    FinesCount[Passport] = (FinesCount[Passport] or 0) + 1

                    local Consult = vRP.Query("vehicles/plateVehicles", { plate = Plate })
                    if Consult[1] then
                        if Consult[1]["arrest"] <= os.time() then
                            if FinesCount[Passport] >= FinesLearn then
                                vRP.Query("vehicles/arrestVehicles", { Passport = Consult[1]["Passport"], vehicle = Vehicle })
                                TriggerClientEvent("Notify", source, "police", "O veículo foi apreendido por excesso de multas.", 10000)
                                FinesCount[Passport] = 0
                            else
                                TriggerClientEvent("Notify", source, "police", "Você foi multado por exceder o limite máximo de velocidade. Multas acumuladas: " .. FinesCount[Passport] .. " / "..FinesLearn.." Ao chegar em 3, seu veículo será apreendido.", 10000)
                            end
                        end
                    end

                    TriggerEvent("blipsystem:Enter", source, "Corredor")

                    SetTimeout(15000, function()
                        TriggerEvent("blipsystem:Exit", source)
                    end)

                    Active[Passport] = nil
                else
                    TriggerClientEvent("Notify", source, "amarelo", "Você possui problemas em sua <b>Carteira de Habilitação</b>, por isso você passou despercebido.", 10000)    
                end
            else
                TriggerClientEvent("Notify", source, "amarelo", "Graças ao seu trabalho, você passou despercebido.", 10000)
            end
        end
    end
end