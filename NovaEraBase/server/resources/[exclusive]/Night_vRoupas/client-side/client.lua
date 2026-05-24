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
Tunnel.bindInterface("Night_vRoupas",Creative)
vSERVER = Tunnel.getInterface("Night_vRoupas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DUMPTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function DumpTable(tbl, indent, isRoot)
    indent = indent or 0
    isRoot = isRoot or false
    local str = ""
    local prefix = string.rep("    ", indent)

    if not isRoot then
        str = str .. "{\n"
    end

    local desiredOrder = {
        "hat",        -- Chapéu
        "glass",      -- Óculos
        "backpack",   -- Mochilas
        "vest",       -- Coletes
        "accessory",  -- Acessórios
        "ear",        -- Brincos
        "watch",      -- Relógios
        "tshirt",     -- Camisas
        "torso",      -- Jaquetas
        "pants",      -- Calças
        "arms",       -- Braços
        "mask",       -- Máscaras
        "bracelet",   -- Pulseiras
        "shoes",      -- Sapatos
        "decals"      -- Adesivos
    }

    local keys = {}

    for _,k in ipairs(desiredOrder) do
        if tbl[k] ~= nil then
            table.insert(keys,k)
        end
    end

    for k in pairs(tbl) do
        local found=false
        for _,dk in ipairs(desiredOrder) do if dk==k then found=true break end end
        if not found then table.insert(keys,k) end
    end

    for i, k in ipairs(keys) do
        local v = tbl[k]
        local isLast = (i == #keys)

        if type(v) == "table" then
            if v.item ~= nil and v.texture ~= nil and #v == 0 then
                str = str .. prefix ..
                    string.format('["%s"] = { item = %s, texture = %s }%s\n',
                        k, tostring(v.item), tostring(v.texture), isLast and "" or ",")
            else
                str = str .. prefix ..
                    string.format('["%s"] = %s%s\n',
                        k, DumpTable(v, indent+1), isLast and "" or ",")
            end
        elseif type(v) == "string" then
            str = str .. prefix ..
                string.format('["%s"] = "%s"%s\n',
                    k, v, isLast and "" or ",")
        else
            str = str .. prefix ..
                string.format('["%s"] = %s%s\n',
                    k, tostring(v), isLast and "" or ",")
        end
    end

    if not isRoot then
        str = str .. string.rep("    ", indent-1 >= 0 and indent-1 or 0) .. "}"
    end
    return str
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUILDOUTFITSNAPSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
local function buildOutfitSnapshot()
    local ped = PlayerPedId()
    local modelHash = GetEntityModel(ped)
    local modelName = (modelHash == GetHashKey("mp_m_freemode_01") and "mp_m_freemode_01") or (modelHash == GetHashKey("mp_f_freemode_01") and "mp_f_freemode_01") or "mp_m_freemode_01"

    local function compItem(compId)
        local draw = GetPedDrawableVariation(ped, compId)
        local tex  = GetPedTextureVariation(ped, compId)
        return { item = draw or 0, texture = tex or 0 }
    end

    local function propItem(propId)
        local draw = GetPedPropIndex(ped, propId)
        local tex  = (draw ~= -1 and GetPedPropTextureIndex(ped, propId)) or 0
        return { item = draw or -1, texture = tex or 0 }
    end

    local outfit = {
        [modelName] = {
            ["hat"]       = propItem(0),    -- chapéus
            ["glass"]     = propItem(1),    -- óculos
            ["backpack"]  = compItem(5),    -- mochilas
            ["vest"]      = compItem(9),    -- coletes
            ["accessory"] = compItem(7),    -- acessórios
            ["ear"]       = propItem(2),    -- brincos
            ["watch"]     = propItem(3),    -- relógios
            ["tshirt"]    = compItem(8),    -- camisas
            ["torso"]     = compItem(11),   -- jaquetas
            ["pants"]     = compItem(4),    -- calças
            ["arms"]      = compItem(3),    -- braços
            ["mask"]      = compItem(1),    -- máscaras
            ["bracelet"]  = propItem(4),    -- pulseiras
            ["shoes"]     = compItem(6),    -- sapatos
            ["decals"]    = compItem(10)    -- adesivos
        }
    }

    return outfit
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENWARDROBEUI
-----------------------------------------------------------------------------------------------------------------------------------------
local function openWardrobeUI()
    local outfit = buildOutfitSnapshot()
    local luaBlock = DumpTable(outfit, 0, true)

    SendNUIMessage({
        action = "open",
        payload = {
            outfit = outfit,
            luaBlock = luaBlock
        }
    })
    SetNuiFocus(true, true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERCOMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Command, function()
    if vSERVER.CheckPermission() then
        openWardrobeUI()
    else
        TriggerEvent("Notify","vermelho","Você não tem permissão.",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTOUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestOutfit", function(_, cb)
    local outfit = buildOutfitSnapshot()
    local luaBlock = DumpTable(outfit, 0, true)
    cb({ outfit = outfit, luaBlock = luaBlock })
end)