-----------------------------------------------------------------------------------------------------------------------------------------
-- SHUTDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("shutdown",function(source)
	if source == 0 then
		TriggerClientEvent("Notify",-1,"vermelho","Os geólogos informaram para nossa unidade governamental que foi encontrado um abalo de magnitude <b>60</b> na <b>Escala Richter</b>, encontrem abrigo até que o mesmo passe.",60000,"TERREMOTO")
		GlobalState["Quake"] = true

		SetTimeout(60000, function()
			local List = vRP.Players()
			for _,Sources in pairs(List) do
				vRP.Kick(Sources,"Desconectado, a cidade reiniciou.")
				Wait(100)
			end

			TriggerEvent("SaveServer",false)
			TriggerEvent("SaveServer2",false)
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("quake", function(source)
    if source ~= 0 then
        local Passport = vRP.Passport(source)
        if not vRP.HasGroup(Passport, "Admin", 1) then
            return
        end
    end

    TriggerClientEvent("Notify", -1, "vermelho", "Os geólogos informaram para nossa unidade governamental que foi encontrado um abalo de magnitude <b>60</b> na <b>Escala Richter</b>, encontrem abrigo até que o mesmo passe.",60000,"TERREMOTO")
    GlobalState["Quake"] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall", function(source)
	local Passport = "Console"
    if source ~= 0 then
        Passport = vRP.Passport(source)
        if not vRP.HasGroup(Passport, "Admin", 1) then
            return
        end
    end

    local List = vRP.Players()
    for _, Sources in pairs(List) do
        vRP.Kick(Sources, "Desconectado, a cidade reiniciou.")
        Wait(100)
		TriggerEvent("Discord", "KickAll", "**[Expulsou os Jogadores]**\n\n**Passaporte:** " .. Passport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
    end

    TriggerEvent("SaveServer", false)
    TriggerEvent("SaveServer2", false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console",function(source,Message,History)
	if source == 0 then
		TriggerClientEvent("Notify",-1,"amarelo",History:sub(9),60000,"PREFEITURA")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONLINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("onlines",function(source)
	if source == 0 then
		print("Atualmente ^2tem ^5"..GetNumPlayerIndices().." Jogador(es) Online^0.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("save",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin") then
			return
		end
	end

	TriggerEvent("SaveServer",false)
	TriggerEvent("SaveServer2",false)
end)