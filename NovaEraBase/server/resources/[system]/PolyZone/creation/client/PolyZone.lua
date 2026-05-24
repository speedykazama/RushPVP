local minZ, maxZ = nil, nil

local function handleInput(center)
  local rot = GetGameplayCamRot(2)
  center = handleArrowInput(center, rot.z)
  return center
end

function polyStart(name)
  local coords = GetEntityCoords(PlayerPedId())
  

  createdZone = PolyZone:Create({vector3(coords.x, coords.y, coords.z)}, {name = tostring(name), useGrid=false})
  
  Citizen.CreateThread(function()
    while createdZone do
      local lastPoint = createdZone.points[#createdZone.points]
      

      local currentZ = lastPoint.z or coords.z
      lastPoint = vector3(lastPoint.x, lastPoint.y, currentZ)
      
      lastPoint = handleInput(lastPoint)
      
      createdZone.points[#createdZone.points] = lastPoint 
      
      Wait(0)
    end
  end)
  
  minZ, maxZ = coords.z, coords.z
end

function polyFinish()
  TriggerServerEvent("polyzone:printPoly",
    {name=createdZone.name, points=createdZone.points, minZ=minZ, maxZ=maxZ})
end

RegisterNetEvent("polyzone:pzadd")
AddEventHandler("polyzone:pzadd", function()
  if not createdZone or createdZoneType ~= 'poly' then
    return
  end

  local hit, _, hitPos = rayCastGamePlayCamera(1000.0)

  if hit then
    if (hitPos.z > maxZ) then maxZ = hitPos.z end
    if (hitPos.z < minZ) then minZ = hitPos.z end


    createdZone.points[#createdZone.points+1] = hitPos
  else

    local coords = GetEntityCoords(PlayerPedId())
    createdZone.points[#createdZone.points+1] = coords
  end
end)

RegisterNetEvent("polyzone:pzundo")
AddEventHandler("polyzone:pzundo", function()
  if not createdZone or createdZoneType ~= 'poly' then
    return
  end

  createdZone.points[#createdZone.points] = nil
  if #createdZone.points == 0 then
    TriggerEvent("polyzone:pzcancel")
  end
end)