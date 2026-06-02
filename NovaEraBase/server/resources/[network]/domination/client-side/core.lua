-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE
-----------------------------------------------------------------------------------------------------------------------------------------
local ServerZones = {}
local Owners = {}
local CurrentZone = nil
local BlipHandles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
local function RemoveBlips()
	for _, H in pairs(BlipHandles) do
		if DoesBlipExist(H) then
			RemoveBlip(H)
		end
	end
	BlipHandles = {}
end

local function BlipColourForEquipa(LabelOwner)
	if not LabelOwner or LabelOwner == "" then
		return DominationNeutralBlipColour or 0
	end
	local H = 0
	local S = tostring(LabelOwner)
	for i = 1, #S do
		H = (H * 31 + string.byte(S, i)) % 85
	end
	if H == (DominationNeutralBlipColour or 0) then
		H = (H + 19) % 85
	end
	return H
end

local function BlipAlphaClamped(A)
	A = tonumber(A) or DominationNeutralBlipAlpha or 120
	return math.max(0, math.min(255, math.floor(A)))
end

local function RebuildBlips()
	RemoveBlips()
	for Id, Zone in pairs(DominationZones) do
		local Poly = Zone["PolyZone"]
		if Poly and Poly.center and Poly.boundingRadius then
			local Z = Zone["MapBlipZ"] or 0.0
			local Owner = Owners[Id]
			local Col = Owner and BlipColourForEquipa(Owner) or (Zone["BlipColour"] or DominationNeutralBlipColour)
			local Alpha = BlipAlphaClamped(Owner and DominationCapturedBlipAlpha or DominationNeutralBlipAlpha)
			local Radius = AddBlipForRadius(Poly.center.x, Poly.center.y, Z, Poly.boundingRadius)
			SetBlipColour(Radius, Col)
			SetBlipAlpha(Radius, Alpha)
			SetBlipAsShortRange(Radius, false)
			SetBlipDisplay(Radius, 4)
			BlipHandles[#BlipHandles + 1] = Radius
			local Icon = AddBlipForCoord(Poly.center.x, Poly.center.y, Z)
			SetBlipSprite(Icon, 437)
			SetBlipColour(Icon, Col)
			SetBlipScale(Icon, 0.9)
			SetBlipAsShortRange(Icon, false)
			SetBlipDisplay(Icon, 4)
			BeginTextCommandSetBlipName("STRING")
			local Prefix = DominationMapBlipLabelPrefix or "Dominação - "
			local BaseLabel = Zone["Label"] or Id
			local Text = BaseLabel
			if Prefix ~= "" and BaseLabel:sub(1, #Prefix) ~= Prefix then
				Text = Prefix .. BaseLabel
			end
			if Owner then
				Text = Text .. " | " .. Owner
			else
				Text = Text .. " | Neutra (só equipas)"
			end
			AddTextComponentString(Text)
			EndTextCommandSetBlipName(Icon)
			BlipHandles[#BlipHandles + 1] = Icon
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD (barra simples)
-----------------------------------------------------------------------------------------------------------------------------------------
local function DrawDominationHud(Label, Progress, Sub)
	local W, H = 0.26, 0.028
	local X, Y = 0.5, 0.88
	DrawRect(X, Y, W, H, 15, 15, 20, 220)
	local Fill = math.max(0.0, math.min(1.0, Progress / 100.0))
	local FillW = (W - 0.004) * Fill
	if FillW > 0.0 then
		DrawRect(X - (W - FillW) / 2 + FillW / 2, Y, FillW, H - 0.006, 180, 40, 40, 240)
	end
	SetTextFont(4)
	SetTextScale(0.0, 0.38)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(true)
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(Label)
	EndTextCommandDisplayText(X, Y - 0.045)
	if Sub and Sub ~= "" then
		SetTextScale(0.0, 0.32)
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringPlayerName(Sub)
		EndTextCommandDisplayText(X, Y + 0.022)
	end
	SetTextScale(0.0, 0.34)
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(string.format("~w~%.0f%%", Progress))
	EndTextCommandDisplayText(X + W / 2 - 0.02, Y - 0.012)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ZONE THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local InsideId = nil
		for Id, Zone in pairs(DominationZones) do
			if Zone["PolyZone"] and Zone["PolyZone"]:isPointInside(Coords) then
				InsideId = Id
				break
			end
		end
		if InsideId and CurrentZone ~= InsideId then
			if CurrentZone then
				TriggerServerEvent("domination:leave", CurrentZone)
			end
			CurrentZone = InsideId
			TriggerServerEvent("domination:enter", InsideId)
		elseif not InsideId and CurrentZone then
			TriggerServerEvent("domination:leave", CurrentZone)
			CurrentZone = nil
		end
		if CurrentZone then
			TriggerServerEvent("domination:syncParty", CurrentZone)
		end
		Wait(350)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local WaitMs = 500
		if CurrentZone and ServerZones[CurrentZone] then
			WaitMs = 0
			local Z = ServerZones[CurrentZone]
			local Label = DominationZones[CurrentZone]["Label"] or "Zona"
			local Owner = Z.owner
			local P = Z.progress or 0.0
			local Sub = ""
			if Owner then
				Sub = "~w~Equipa dominante: ~y~" .. Owner
			else
				Sub = "~w~Neutra ~w~- só jogadores ~g~com equipa~w~ contam na zona"
			end
			DrawDominationHud(Label, P, Sub)
		end
		Wait(WaitMs)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("domination:fullSync")
AddEventHandler("domination:fullSync", function(Payload)
	if type(Payload) == "table" then
		ServerZones = Payload
	end
end)

RegisterNetEvent("domination:zonePatch")
AddEventHandler("domination:zonePatch", function(ZoneId, Slice)
	if type(ZoneId) ~= "string" or type(Slice) ~= "table" then
		return
	end
	if not ServerZones[ZoneId] then
		ServerZones[ZoneId] = {}
	end
	ServerZones[ZoneId].owner = Slice.owner
	ServerZones[ZoneId].progress = Slice.progress
end)

RegisterNetEvent("domination:owners")
AddEventHandler("domination:owners", function(Payload)
	if type(Payload) == "table" then
		Owners = Payload
		RebuildBlips()
	end
end)

RegisterNetEvent("domination:leftZone")
AddEventHandler("domination:leftZone", function()
	-- noop: estado local usa CurrentZone
end)

AddEventHandler("onClientResourceStart", function(Res)
	if Res == GetCurrentResourceName() then
		TriggerServerEvent("domination:requestSync")
		RebuildBlips()
	end
end)

AddEventHandler("onResourceStop", function(Res)
	if Res == GetCurrentResourceName() then
		RemoveBlips()
	end
end)
