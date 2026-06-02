RegisterCommand("criarblip", function(source, Message)
    local src = source
    if src == 0 then return end

    if not Message[1] or not Message[2] or not Message[3] then
        TriggerClientEvent("chat:addMessage", src, {
            color = {255, 150, 0},
            args = {"[SISTEMA]", "Use: /criarblip [ID Sprite] [ID Cor] [Nome]"}
        })
        return
    end

    local sprite = tonumber(Message[1])
    local cor = tonumber(Message[2])
    local nome = table.concat(Message, " ", 3) 

    local playerPed = GetPlayerPed(src)
    local coords = GetEntityCoords(playerPed)

    -- Envia o comando de criar com o nome como identificador
    TriggerClientEvent("blips:CriarInGame", -1, coords.x, coords.y, coords.z, sprite, cor, nome)

    TriggerClientEvent("chat:addMessage", src, {
        color = {0, 255, 0},
        args = {"[SISTEMA]", "Blip '" .. nome .. "' criado com sucesso!"}
    })
end, false)

-- NOVO COMANDO: Para remover o blip pelo nome
RegisterCommand("removerblip", function(source, Message)
    local src = source
    if src == 0 then return end

    if not Message[1] then
        TriggerClientEvent("chat:addMessage", src, {
            color = {255, 150, 0},
            args = {"[SISTEMA]", "Use: /removerblip [Nome Exato do Blip]"}
        })
        return
    end

    local nome = table.concat(Message, " ")

    -- Avisa todos os clientes para deletarem o blip com esse nome
    TriggerClientEvent("blips:RemoverInGame", -1, nome)

    TriggerClientEvent("chat:addMessage", src, {
        color = {255, 0, 0},
        args = {"[SISTEMA]", "Comando de remoção enviado para o blip: " .. nome}
    })
end, false)