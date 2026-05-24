-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("notepad",Creative)
vCLIENT = Tunnel.getInterface("notepad")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local notePad = {}
local notepedIds = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATENOTEPAD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.createNotepad(text)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		notepedIds = notepedIds + 1
		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)
		notePad[notepedIds] = { Passport = parseInt(Passport), id = notepedIds, text = tostring(text), x = coords["x"], y = coords["y"], z = coords["z"] }
		TriggerClientEvent("notepad:sendPlayers",-1,notepedIds,notePad[notepedIds])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EDITNOTEPAD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.editNotepad(id,text)
	if notePad[id] then
		notePad[id]["text"] = tostring(text)
		TriggerClientEvent("notepad:sendPlayers",-1,id,notePad[id])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTROYNOTEPAD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.destroyNotepad(id)
	if notePad[id] then
		notePad[id] = nil
		TriggerClientEvent("notepad:removePlayers",-1,id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(Passport,source)
	vCLIENT.updateNotepad(source,notePad)
end)