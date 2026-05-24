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
Tunnel.bindInterface("dynamic",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Works = {
    ["Minerman"] = "Minerador",
    ["Lumberman"] = "Lenhador",
    ["Transporter"] = "Transportador de Valores",
    ["Garbageman"] = "Lixeiro",
    ["Hunter"] = "Caçador",
    ["Fruitman"] = "Agricultor",
    ["Dismantle"] = "Desmanchador",
    ["Tows"] = "Rebocador",
    ["Fisherman"] = "Pescador",
    ["Trucker"] = "Caminhoneiro",
    ["Bus"] = "Motorista de Ônibus",
    ["Taxi"] = "Taxista",
    ["Cleaner"] = "Faxineiro",
    ["PostOp"] = "Carteiro",
    ["Milkman"] = "Leiteiro",
    ["Tractor"] = "Tratorista",
    ["Diver"] = "Mergulhador",
    ["Cemitery"] = "Coveiro"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Experience()
	local source = source
	local Passport = vRP.Passport(source)
	local Datatable = vRP.Datatable(Passport)
	if Passport and Datatable then
		local Experiences = {}

		for Index,v in pairs(Works) do
			if Datatable[Index] then
				Experiences[v] = Datatable[Index]
			else
				Experiences[v] = 0
			end
		end

		return Experiences
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
-- function Creative.Experience()
-- 	local source = source
-- 	local Passport = vRP.Passport(source)
-- 	local Datatable = vRP.Datatable(Passport)
-- 	if Passport and Datatable then
-- 		local Experiences = {}

-- 		for Index,v in pairs(Works) do
-- 			if Datatable[Index] then
-- 				Experiences[v] = Datatable[Index]
-- 			else
-- 				Experiences[v] = 0
-- 			end
-- 		end

-- 		return Experiences
-- 	end
-- end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:EMERGENCYANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:EmergencyAnnounce")
AddEventHandler("dynamic:EmergencyAnnounce",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Policia") then
			TriggerClientEvent("dynamic:closeSystem",source)
			local Keyboard = vKEYBOARD.keyDouble(source,"Mensagem:","Nome:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"police"," "..Keyboard[1].."<br></br>Enviado Por: <b>"..Keyboard[2].."</b>",45000)
				TriggerEvent("Discord","Aviso-policia","**Aviso Policial F10**\n\n**Passaporte:** "..Passport.."\n**Mensagem do Anuncio:** "..Keyboard[1].."\n**Nome que Colocou:** "..Keyboard[2].."\n**Horário:** "..os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:POLICEANUNCIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:PoliceAnuncio")
AddEventHandler("dynamic:PoliceAnuncio", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local identity = vRP.Identity(source)
        if vRP.HasGroup(Passport, "Policia") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Nome da Ação:")
			if Keyboard then
                local playerName = vRP.FullName(Passport)
                local NomaAcao = Keyboard[1]
                local finalMessage = "O <b>1º BPM Night City</b> informa: "..NomaAcao.." está sendo assaltado, evitem passar próximo, risco de ser alvejado. Mantenham distância! <br></br>Enviada Por: " .. playerName
                TriggerClientEvent("Notify", -1, "police", finalMessage.."</b>",30000)
				TriggerEvent("Discord", "Aviso-policia", "**Aviso Policial Ação F10**\n\n**Passaporte:** "..Passport.."\n**Mensagem do Anuncio:** "..NomaAcao.."\n**Nome que Colocou:** "..playerName.."\n**Horário:** "..os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:EMERGENCYANNOUNCEMEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:EmergencyAnnounceMedic")
AddEventHandler("dynamic:EmergencyAnnounceMedic",function()
	local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local identity = vRP.Identity(source)
        if vRP.HasGroup(Passport,"Paramedic")then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Mensagem:")
			if Keyboard then
                local playerName = vRP.FullName(Passport)
                local originalMessage = Keyboard[1]
                local finalMessage = originalMessage .. "<br></br>Enviada Por: " .. playerName
                TriggerClientEvent("Notify", -1, "paramedic", finalMessage.."</b>",30000)
				TriggerEvent("Discord", "Aviso-paramedic", "**Aviso Paramédico F10**\n\n**Passaporte:** "..Passport.."\n**Mensagem do Anuncio:** "..originalMessage.."\n**Nome que Colocou:** "..playerName.."\n**Horário:** "..os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:EMERGENCYANNOUNCEBOMBEIRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:EmergencyAnnounceBombeiro")
AddEventHandler("dynamic:EmergencyAnnounceBombeiro",function()
	local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local identity = vRP.Identity(source)
        if vRP.HasGroup(Passport,"Bombeiro") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Mensagem:")
			if Keyboard then
                local playerName = vRP.FullName(Passport)
                local originalMessage = Keyboard[1]
                local finalMessage = originalMessage .. "<br></br>Enviada Por: " .. playerName
                TriggerClientEvent("Notify", -1, "bombeiro", finalMessage.."</b>",30000)
				TriggerEvent("Discord", "Aviso-bombeiro", "**Aviso Bombeiro F10**\n\n**Passaporte:** "..Passport.."\n**Mensagem do Anuncio:** "..originalMessage.."\n**Nome que Colocou:** "..playerName.."\n**Horário:** "..os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:EMERGENCYANNOUNCEPARAMEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:EmergencyAnnounceMechanic")
AddEventHandler("dynamic:EmergencyAnnounceMechanic",function()
	local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local identity = vRP.Identity(source)
        if vRP.HasGroup(Passport,"Mecanica") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Mensagem:")
			if Keyboard then
                local playerName = vRP.FullName(Passport)
                local originalMessage = Keyboard[1]
                local finalMessage = originalMessage .. "<br></br>Enviada Por: " .. playerName
                TriggerClientEvent("Notify", -1, "mecanico", finalMessage.."</b>",30000)
				TriggerEvent("Discord", "Aviso-mecanica", "**Aviso Mecânico F10**\n\n**Passaporte:** "..Passport.."\n**Mensagem do Anuncio:** "..originalMessage.."\n**Nome que Colocou:** "..playerName.."\n**Horário:** "..os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:NIGHTIDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Creative:identity")
AddEventHandler("Creative:identity", function()
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport then
        local Identity = vRP.Identity(Passport)
        
        if Identity then
            --TriggerClientEvent("Notify", source, "azul", "<b>Passaporte:</b> " .. Passport .. "<br><b>Nome:</b> " .. vRP.FullName(Passport) .. "<br><b>Telefone:</b> " .. Identity["phone"] .. "<br><b>Sexo:</b> " .. Identity["sex"] .. "<br><b>Gemas:</b> " .. Identity["gems"] .. "<br><b>Banco:</b> $" .. parseFormat(Identity["bank"]), 15000)
			TriggerClientEvent("Notify", source, "azul", "<b>Passaporte:</b> " .. Passport .. "<br><b>Nome:</b> " .. Identity["name"] .. " " .. Identity["name2"] .. "<br><b>Telefone:</b> " .. Identity["phone"] .. "<br><b>Sexo:</b> " .. Identity["sex"] .. "<br><b>Gemas:</b> " .. Identity["gems"] .. "<br><b>Banco:</b> $" .. parseFormat(Identity["bank"]) .. "<br><b>Likes👍:</b> " .. Identity["likes"] .. "<br><b>Deslikes👎:</b> " .. Identity["unlikes"], 15000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TENCODES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tencodes = {
	[1] = {
		tag = "QTI",
		text = "Abordagem de trânsito",
		blip = 3
	},
	[2] = {
		tag = "QTH",
		text = "Localização",
		blip = 0
	},
	[3] = {
		tag = "QRR",
		text = "Apoio com prioridade",
		blip = 51
	},
	[4] = {
		tag = "QRT",
		text = "Oficial desmaiado/ferido",
		blip = 1
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:TENCODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:Tencode")
AddEventHandler("dynamic:Tencode",function(Code)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Identity = vRP.Identity(Passport)
		local Service = vRP.NumPermission("Policia")
		for Passports,Sources in pairs(Service) do
			async(function()
				if Code ~= 4 then
					vRPC.PlaySound(Sources,"Event_Start_Text","GTAO_FM_Events_Soundset")
				end

				TriggerClientEvent("NotifyPush",Sources,{ code = Tencodes[parseInt(Code)]["tag"], title = Tencodes[parseInt(Code)]["text"], x = Coords["x"], y = Coords["y"], z = Coords["z"], name = " ID: "..Passport.." "..Identity["name"].." "..Identity["name2"], time = "Recebido às "..os.date("%H:%M"), color = Tencodes[parseInt(Code)]["blip"] })
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Animals = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RegisterAnimal(objNet)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Animals[Passport] = objNet
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ClearAnimal()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("DeletePed", Animals[Passport])
		Animals[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
	if Animals[Passport] then
		TriggerEvent("DeletePed", Animals[Passport])
		Animals[Passport] = nil
	end
end)