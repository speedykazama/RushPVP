-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("radio",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESERVED
-----------------------------------------------------------------------------------------------------------------------------------------
local Reserved = {
	[911] = "PMERJ",
	[912] = "PMERJ",
	[913] = "PMERJ",
	[914] = "PCERJ",
	[915] = "PCERJ",
	[916] = "PCERJ",
	[917] = "PRF",
	[918] = "PRF",
	[919] = "PRF",
	[920] = "BOPE",
	[921] = "BOPE",
	[922] = "BOPE",
	[923] = "RECOM",
	[924] = "RECOM",
	[925] = "RECOM",
	[926] = "BPCHQ",
	[927] = "BPCHQ",
	[928] = "BPCHQ",
	[929] = "EX",
	[930] = "EX",
	[931] = "EX",
	[112] = "Paramedic",
	[113] = "Paramedic",
	[114] = "Paramedic",
	[115] = "Bombeiro",
	[116] = "Bombeiro",
	[117] = "Bombeiro",
	[118] = "Mechanic",
	[119] = "Mechanic",
	[120] = "Mechanic",
	[121] = "Mechanic2",
	[122] = "Mechanic2",
	[123] = "Mechanic2",
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Frequency(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		if Reserved[Number] then
			if vRP.HasService(Passport,Reserved[Number]) then
				return true
			else
				TriggerClientEvent("Notify",source,"amarelo","Você nao Tem Permissão para entrar nessa Rádio exclusiva para <b>"..Reserved[Number].."</b>.",5000)
			end
		else
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKRADIO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckRadio()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Consult = vRP.InventoryItemAmount(Passport,"radio")
		if Consult[1] <= 0 then
			return true
		end
	end

	return false
end