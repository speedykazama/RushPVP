local webhookURL = "https://discord.com/api/webhooks/1450659438464598109/TAbjAl91S835nFtkayXP4XOx_qn7Z99GpJRfwIIZWwQtTKkRUA2w7NcZE3cxQtDOA3Fb" 

local function SendDiscordLog(title, message, src)
    if webhookURL == "" or not webhookURL then
        print("^1[PolyZone] ERRO: Webhook nao configurado em server/creation.lua!^0")
        return
    end

    local playerName = GetPlayerName(src) or "Desconhecido"
    
    local embed = {
        {
            ["color"] = 16711680, 
            ["title"] = "**" .. title .. "**",
            ["author"] = {
                ["name"] = "LOGS DOMINAÇÃO | NOVAERA RP",
                ["icon_url"] = "https://i.imgur.com/PZ7o7sK.png" 
            },
            ["description"] = "```lua\n" .. message .. "\n```\n**Criado por:** " .. playerName .. " (ID: " .. src .. ")", 
            ["footer"] = {
                ["text"] = "Developed by Russo | PolyZone Logs - " .. os.date("%d/%m/%Y %H:%M:%S"),
            },
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "PolyZone Bot", embeds = embed}), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent("polyzone:printPoly")
AddEventHandler("polyzone:printPoly", function(zone)
  local src = source 
  local output = parsePoly(zone)
  SendDiscordLog("PolyZone Criada: " .. (zone.name or "Sem Nome"), output, src)
end)

RegisterServerEvent("polyzone:printCircle")
AddEventHandler("polyzone:printCircle", function(zone)
  local src = source 
  local output = parseCircle(zone)
  SendDiscordLog("CircleZone Criada: " .. (zone.name or "Sem Nome"), output, src)
end)

RegisterServerEvent("polyzone:printBox")
AddEventHandler("polyzone:printBox", function(zone)
  local src = source 
  local output = parseBox(zone)
  SendDiscordLog("BoxZone Criada: " .. (zone.name or "Sem Nome"), output, src)
end)


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function printoutHeader(name)
  return "--Name: " .. name .. " | " .. os.date("!%Y-%m-%dT%H:%M:%SZ\n")
end

function parsePoly(zone)
  local printout = printoutHeader(zone.name)
  printout = printout .. "PolyZone:Create({\n"
  for i=1, #zone.points do
    local pX = zone.points[i].x
    local pY = zone.points[i].y
    local pZ = zone.points[i].z or 0.0 

    if i ~= #zone.points then
      printout = printout .. "  vector3(" .. tostring(round(pX, 2)) .. ", " .. tostring(round(pY, 2))  .. ", " .. tostring(round(pZ, 2)) .."),\n"
    else
      printout = printout .. "  vector3(" .. tostring(round(pX, 2)) .. ", " .. tostring(round(pY, 2))  .. ", " .. tostring(round(pZ, 2)) ..")\n"
    end
  end
  printout = printout .. "}, {\n  name=\"" .. zone.name .. "\",\n  --minZ = " .. (zone.minZ or "nil") .. ",\n  --maxZ = " .. (zone.maxZ or "nil") .. "\n})\n"
  return printout
end

function parseCircle(zone)
  local printout = printoutHeader(zone.name)
  printout = printout .. "CircleZone:Create("
  printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
  printout = printout .. tostring(zone.radius) .. ", "
  printout = printout .. "{\n  name=\"" .. zone.name .. "\",\n  useZ=" .. tostring(zone.useZ) .. ",\n  --debugPoly=true\n})\n"
  return printout
end

function parseBox(zone)
  local printout = printoutHeader(zone.name)
  printout = printout .. "BoxZone:Create("
  printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
  printout = printout .. tostring(zone.length) .. ", "
  printout = printout .. tostring(zone.width) .. ", "
  
  printout = printout .. "{\n  name=\"" .. zone.name .. "\",\n  heading=" .. zone.heading .. ",\n  --debugPoly=true"
  if zone.minZ then
    printout = printout .. ",\n  minZ=" .. tostring(round(zone.minZ, 2))
  end
  if zone.maxZ then
    printout = printout .. ",\n  maxZ=" .. tostring(round(zone.maxZ, 2))
  end
  printout = printout .. "\n})\n"
  return printout
end