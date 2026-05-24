-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blip,inTrip
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
local function createBlip(x, y, z, name)
  RemoveBlip(blip)
  blip = AddBlipForCoord(x/1, y/1, z/1)
  SetBlipSprite(blip, 1)
  SetBlipColour(blip, 5)
  SetBlipRoute(blip, true)
  SetBlipScale(blip, 1.0)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString(name)
  EndTextCommandSetBlipName(blip)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function eventHandlers.uber_message(msg)
  if not msg.sender and not Lua.getState('uber_chat') then
    TriggerEvent('smartphone:pusher', 'CUSTOM_NOTIFY', { 
      app = 'uber',
      title = inTrip and 'Mensagem do Passageiro'  or 'Mensagem do Motorista',
      subtitle = msg.content
    })
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
function Lua.create_uber_thread(trip)
  createBlip(trip.from.x, trip.from.y, trip.from.z, 'Passageiro')
  inTrip = trip

  CreateThread(function()
    Wait(5000)    
    local ped = PlayerPedId()

    while inTrip do
      local idle = 0

      if trip.entered then
        local cds = GetEntityCoords(ped)
        local distance = Vdist(cds.x, cds.y, 0, trip.to.x / 1, trip.to.y / 1, 0)
        if distance <= 30 then
          Net.uber_arrived()
          inTrip = nil
        end
      else
        local veh = GetVehiclePedIsIn(ped)
        if veh > 0 then
          local player = GetPlayerFromServerId(trip.customer.source)
          if player ~= -1 then
            local passenger = GetPlayerPed(player)
            if GetVehiclePedIsIn(passenger) == veh then
              Net.uber_customer_entered()
              trip.entered = true
              createBlip(trip.to.x, trip.to.y, trip.to.z, 'Destino')
            end
          end
        end
      end

      Wait(500)
    end

    RemoveBlip(blip)
  end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELLED
-----------------------------------------------------------------------------------------------------------------------------------------
function eventHandlers.uber_cancelled()
  inTrip = nil
end