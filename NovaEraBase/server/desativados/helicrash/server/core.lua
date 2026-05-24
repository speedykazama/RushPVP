-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local LootBoxes = 0
local Cooldown = os.time()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Helicrash"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Timers[os.date("%H:%M")] and os.time() >= Cooldown then
			LootBoxes = 0
			local Selected = math.random(#Components)
			for Number,v in pairs(Components[Selected]) do
				if Number ~= "1" then
					LootBoxes = LootBoxes + 1

					local Loot = math.random(#Loots)
					vRP.RemSrvData("Chest:Helicrash:" .. Number, false)
					TriggerEvent("chest:Cooldown","Helicrash:"..Number)
					vRP.SetSrvData("Chest:Helicrash:" .. Number, Loots[Loot], false)
				end
			end

			TriggerClientEvent("Notify",-1,"helicrash","Mayday! Mayday! Tivemos problemas técnicos em nossos motores e estamos em queda livre.",30000)
			GlobalState["Helicrash"] = Selected
			Cooldown = os.time() + 3600
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERCOMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("helicrash", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    
    if Passport and vRP.HasGroup(Passport, "Admin", 1) then

        if Cooldown then
            LootBoxes = 0
            local Selected = math.random(#Components)
            for Number, v in pairs(Components[Selected]) do
                if Number ~= "1" then
                    LootBoxes = LootBoxes + 1
					
                    local Loot = math.random(#Loots)
					vRP.RemSrvData("Chest:Helicrash:" .. Number, false)
					TriggerEvent("chest:Cooldown","Helicrash:"..Number)
					vRP.SetSrvData("Chest:Helicrash:" .. Number, Loots[Loot], false)
                end
            end

            TriggerClientEvent("Notify", -1, "helicrash", "Mayday! Mayday! Tivemos problemas técnicos em nossos motores e estamos em queda livre. Abra seu GPS para me localizar!", 30000)
            GlobalState["Helicrash"] = Selected
            Cooldown = os.time() + 3600
            TriggerEvent("Discord", "Helicrash", "**[Executou o comando /helicrash]**\n\n**Passaporte:** " .. Passport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
        end
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOX
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Box",function()
	if GlobalState["Helicrash"] then
		LootBoxes = LootBoxes - 1

		if LootBoxes <= 0 then
			GlobalState["Helicrash"] = false
			LootBoxes = 0
		end
	end
end)