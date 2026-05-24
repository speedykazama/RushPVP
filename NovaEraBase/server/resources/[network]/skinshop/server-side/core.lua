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
Tunnel.bindInterface("skinshop",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Verify()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetFine(Passport) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Você possui multas pendentes.",10000)
			return false
		end

		if exports["hud"]:Wanted(Passport,source) and exports["hud"]:Reposed(Passport) then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Clothes,Spawn)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Clothings", dvalue = json.encode(Clothes) })
		if Spawn then
			vRP.Query("playerdata/SetData", { Passport = Passport, dkey = "Creator", dvalue = json.encode(1) })
			TriggerEvent("vRP:BucketServer", source, "Exit")
			Wait(1000)
			local Bags = { "prop_luggage_01a", "prop_luggage_02a", "prop_luggage_03a", "prop_luggage_04a", "prop_luggage_05a", "prop_luggage_06a", "prop_luggage_07a", "prop_luggage_08a", "prop_big_bag_01", "xm_prop_x17_bag_01d" }
			vRPC.CreateObjects(source,"move_weapon@jerrycan@generic","idle",Bags[math.random(#Bags)],50,57005,0.425,0.0,0.025, 0, 260.0,  60.0)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckPerm()
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport,"Admin") then
		return true
	else
		return
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and Message[1] then
        if vRP.HasGroup(Passport, "Admin") then
            local ClosestPed = vRP.Source(Message[1])
            if ClosestPed then
                vRPC.Skin(ClosestPed, Message[2])
                vRP.SkinCharacter(parseInt(Message[1]), Message[2])
                vRP.Query("playerdata/SetData", { Passport = Passport, dkey = "Skin", dvalue = Message[2] })

                local sex = nil
                if Message[2] == "mp_m_freemode_01" then
                    sex = "M"
                elseif Message[2] == "mp_f_freemode_01" then
                    sex = "F"
                end

                if sex then
                    vRP.Query("characters/SetSex", { Passport = Passport, sex = sex })
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:Remove")
AddEventHandler("skinshop:Remove",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if vRP.HasService(Passport,"Policia") or vRP.HasService(Passport,"Emergencia") then
				TriggerClientEvent("skinshop:set"..Mode,ClosestPed)
			end
		end
	end
end)