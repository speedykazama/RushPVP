-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE — pres = jogadores dentro da zona; team = apenas quem está em equipa (party); contagem só usa team.
-----------------------------------------------------------------------------------------------------------------------------------------
local SaveKey = "Domination:Zones"
local Zones = {}

local function PartyStarted()
	return GetResourceState("party") == "started"
end

local function GetPlayerTeamRoom(Passport)
	if not PartyStarted() or not Passport then
		return nil
	end
	local RoomId = exports["party"]:GetPartyCaptureId(Passport)
	return RoomId
end

local function RoomLabel(RoomId)
	if not PartyStarted() or not RoomId then
		return nil
	end
	return exports["party"]:PartyRoomNameByRoomId(RoomId)
end

local function defenceTeamMatches(Z, LeaderRoomId)
	if not LeaderRoomId then
		return false
	end
	if Z.ownerRoom and Z.ownerRoom == LeaderRoomId then
		return true
	end
	local LName = RoomLabel(LeaderRoomId)
	return LName and Z.owner == LName
end

local function CountLeadingTeam(TeamMap)
	local Tall = {}
	for _, RoomId in pairs(TeamMap) do
		if RoomId then
			Tall[RoomId] = (Tall[RoomId] or 0) + 1
		end
	end
	local BestF, BestC, Second = nil, -1, -1
	for F, C in pairs(Tall) do
		if C > BestC then
			Second = BestC
			BestC = C
			BestF = F
		elseif C > Second then
			Second = C
		end
	end
	if not BestF then
		return nil, 0
	end
	local Tie = 0
	for _, C in pairs(Tall) do
		if C == BestC then
			Tie = Tie + 1
		end
	end
	if Tie > 1 then
		return nil, BestC
	end
	return BestF, math.max(1, BestC - math.max(Second, 0))
end

local function SlimZone(Z)
	return { owner = Z.owner, progress = Z.progress }
end

local function SlimPayload()
	local P = {}
	for Id, Z in pairs(Zones) do
		P[Id] = SlimZone(Z)
	end
	return P
end

local function LoadSaved()
	local Stored = vRP.GetSrvData(SaveKey) or {}
	for Id, _ in pairs(DominationZones) do
		if not Zones[Id] then
			Zones[Id] = {
				pres = {},
				team = {},
				owner = nil,
				ownerRoom = nil,
				progress = 0.0,
				captureLead = nil
			}
		end
		if Stored[Id] and Stored[Id].owner then
			Zones[Id].owner = Stored[Id].owner
			Zones[Id].ownerRoom = Stored[Id].ownerRoom or nil
			Zones[Id].progress = 100.0
			Zones[Id].captureLead = nil
		end
	end
end

local function Persist(Id)
	local Full = vRP.GetSrvData(SaveKey) or {}
	if not Full[Id] then
		Full[Id] = {}
	end
	Full[Id].owner = Zones[Id].owner
	Full[Id].ownerRoom = Zones[Id].ownerRoom
	vRP.SetSrvData(SaveKey, Full)
end

local function NotifyAll(Msg)
	for _, Src in pairs(vRP.Players()) do
		TriggerClientEvent("Notify", Src, "amarelo", Msg, 6500)
	end
end

local function SyncClient(Src)
	TriggerClientEvent("domination:fullSync", Src, SlimPayload())
end

local function BroadcastOwners()
	local Owners = {}
	for Id, Z in pairs(Zones) do
		Owners[Id] = Z.owner
	end
	TriggerClientEvent("domination:owners", -1, Owners)
end

local function PushZoneToViewers(Id)
	local Z = Zones[Id]
	if not Z then
		return
	end
	local Slice = SlimZone(Z)
	for Passport in pairs(Z.pres) do
		local Src = vRP.Source(Passport)
		if Src then
			TriggerClientEvent("domination:zonePatch", Src, Id, Slice)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
local function ProcessZone(Id, Z, Dt)
	local Leader, Margin = CountLeadingTeam(Z.team)
	local HasContestants = Leader ~= nil

	if not next(Z.pres) then
		return
	end

	if not HasContestants then
		return
	end

	local Owner = Z.owner
	local G = DominationCaptureRate * Margin * Dt
	local C = DominationContestRate * Margin * Dt

	if not Owner then
		if Z.captureLead ~= Leader then
			Z.captureLead = Leader
			Z.progress = 0.0
		end
		Z.progress = math.min(100.0, Z.progress + G)
		if Z.progress >= 100.0 then
			Z.progress = 100.0
			Z.ownerRoom = Leader
			Z.owner = RoomLabel(Leader) or ("Equipa #" .. tostring(Leader))
			Z.captureLead = nil
			Persist(Id)
			if DominationZones[Id] then
				local L = DominationZones[Id]["Label"] or Id
				local N = Z.owner or "Equipa"
				NotifyAll(L .. " ~w~foi dominada pela equipa ~y~" .. N .. "~w~.")
			end
			BroadcastOwners()
		end
		return
	end

	if defenceTeamMatches(Z, Leader) then
		Z.progress = math.min(100.0, Z.progress + G)
		Z.captureLead = nil
		return
	end

	Z.progress = math.max(0.0, Z.progress - C)
	if Z.progress <= 0.0 then
		Z.owner = nil
		Z.ownerRoom = nil
		Z.progress = 0.0
		Z.captureLead = nil
		Persist(Id)
		if DominationZones[Id] then
			local L = DominationZones[Id]["Label"] or Id
			NotifyAll(L .. " ~w~ficou ~r~neutra~w~ (contestada).")
		end
		BroadcastOwners()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
for Id, _ in pairs(DominationZones) do
	Zones[Id] = {
		pres = {},
		team = {},
		owner = nil,
		ownerRoom = nil,
		progress = 0.0,
		captureLead = nil
	}
end
LoadSaved()
BroadcastOwners()
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local elapsed = 1.0
	while true do
		for Id, Z in pairs(Zones) do
			if DominationZones[Id] then
				ProcessZone(Id, Z, elapsed)
				PushZoneToViewers(Id)
			end
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
local function RefreshTeamInZone(Passport, ZoneId)
	if not Zones[ZoneId] then
		return
	end
	local Rid = GetPlayerTeamRoom(Passport)
	Zones[ZoneId].team[Passport] = Rid or nil
end

RegisterNetEvent("domination:enter")
AddEventHandler("domination:enter", function(ZoneId)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not DominationZones[ZoneId] or not Zones[ZoneId] then
		return
	end
	Zones[ZoneId].pres[Passport] = true
	RefreshTeamInZone(Passport, ZoneId)
	SyncClient(source)
end)

RegisterNetEvent("domination:leave")
AddEventHandler("domination:leave", function(ZoneId)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not Zones[ZoneId] then
		return
	end
	Zones[ZoneId].pres[Passport] = nil
	Zones[ZoneId].team[Passport] = nil
	TriggerClientEvent("domination:leftZone", source, ZoneId)
end)

RegisterNetEvent("domination:syncParty")
AddEventHandler("domination:syncParty", function(ZoneId)
	local Passport = vRP.Passport(source)
	if not Passport or not Zones[ZoneId] or not Zones[ZoneId].pres[Passport] then
		return
	end
	RefreshTeamInZone(Passport, ZoneId)
end)

RegisterNetEvent("domination:requestSync")
AddEventHandler("domination:requestSync", function()
	SyncClient(source)
end)

AddEventHandler("playerDropped", function()
	local Passport = vRP.Passport(source)
	if not Passport then
		return
	end
	for _, Z in pairs(Zones) do
		Z.pres[Passport] = nil
		Z.team[Passport] = nil
	end
end)

AddEventHandler("onResourceStart", function(Res)
	if Res == GetCurrentResourceName() then
		for Id, _ in pairs(DominationZones) do
			if not Zones[Id] then
				Zones[Id] = {
					pres = {},
					team = {},
					owner = nil,
					ownerRoom = nil,
					progress = 0.0,
					captureLead = nil
				}
			end
		end
		LoadSaved()
		BroadcastOwners()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GetZoneOwner", function(ZoneId)
	if Zones[ZoneId] then
		return Zones[ZoneId].owner
	end
	return nil
end)

exports("GetZoneState", function(ZoneId)
	return Zones[ZoneId]
end)
