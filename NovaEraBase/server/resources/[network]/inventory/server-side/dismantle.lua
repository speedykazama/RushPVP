-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Dismantle = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Dismantle(Entity)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and not Active[Passport] then
        Active[Passport] = os.time() + 10
        Player(source)["state"]["Buttons"] = true
        TriggerClientEvent("inventory:Close", source)
        TriggerClientEvent("Progress", source, "Desmanchando", 10000)
        vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)

        repeat
            if os.time() >= parseInt(Active[Passport]) then
                Active[Passport] = nil
                vRPC.Destroy(source)
                Player(source)["state"]["Buttons"] = false
                TriggerEvent("garages:dismantleVehicle", Entity[4], Entity[1])

                local Class = 1
                if Dismantle[Passport] then
                    Class = ClassCategory(Dismantle[Passport])
                end

                local AmountRange = CategoryIncrementsDismantle[Class]
                local AmountItens = AmountRange and math.random(AmountRange.Min, AmountRange.Max)

                vRP.GenerateItem(Passport, DismantleItem, AmountItens, true)
                vRP.PutExperience(Passport, DismantleWork, DismantleExperience)

                if math.random(100) <= 20 then
                    local Ped = GetPlayerPed(source)
                    local Coords = GetEntityCoords(Ped)
                    local Service = vRP.NumPermission(DisantlePermission)

                    for _, policeSource in pairs(Service) do
                        async(function()
                            TriggerClientEvent("NotifyPush", policeSource, {
                                code = 31,
                                title = "Desmanche de Veículo",
                                x = Coords["x"],
                                y = Coords["y"],
                                z = Coords["z"],
                                criminal = "Alarme de segurança",
                                time = "Recebido às " .. os.date("%H:%M"),
                                color = 44
                            })
                        end)
                    end
                end
            end

            Wait(100)
        until not Active[Passport]
    end
end