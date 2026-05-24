-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
Player = GetPlayerServerId(PlayerId())

local ValidNotify = {
    ["vermelho"] = true,
    ["verde"] = true,
    ["amarelo"] = true,
    ["azul"] = true,
    ["sangramento"] = true,
    ["compras"] = true,
    ["fome"] = true,
    ["sede"] = true,
    ["police"] = true,
    ["paramedic"] = true,
    ["bombeiro"] = true,
    ["mecanico"] = true,
    ["admin"] = true,
    ["dica"] = true,
    ["amor"] = true,
    ["airdrop"] = true,
    ["helicrash"] = true,
    ["service"] = true,
    ["salario2"] = true,
    ["locked"] = true,
    ["unlocked"] = true,
}

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(Css,Message,Timer,Title)
    if ValidNotify[Css] then
        SendNUIMessage({ Action = "Notify", Css = Css, Message = Message, Timer = Timer or 5000, Title = Title })
    else
        SendNUIMessage({ Action = "Notify", Css = "vermelho", Message = Message, Title = Title, Timer = Timer or 5000 })
    end
end)

RegisterNetEvent("Notify:Text")
AddEventHandler("Notify:Text",function(Text)
    SendNUIMessage({ Action = "Text", Message = Text})
end)

RegisterNetEvent("Announce")
AddEventHandler("Announce",function(Css,Message,Timer,Title)
    if ValidNotify[Css] then
        SendNUIMessage({ Action = "Announce", Css = Css, Message = Message, Timer = Timer or 5000, Title = Title })
    else
        SendNUIMessage({ Action = "Announce", Css = "admin", Message = Message, Title = Title, Timer = Timer or 5000 })
    end
end)

-- local infoHelp = false

-- function openCloseShortCuts()
--     TriggerEvent("help:open")
--     infoHelp = not infoHelp
--     SendNUIMessage({ Action = "Tutorial", Status = infoHelp})
-- end

-- RegisterCommand("help2",openCloseShortCuts)
-- RegisterKeyMapping("help2","Open/Close HELP","keyboard","EQUALS") 

-- RegisterNetEvent("notify:Tutorial")
-- AddEventHandler("notify:Tutorial",function()
--     openCloseShortCuts()
-- end)


-- local HelpNotify = {
--     "Você sabia que não pode ser assaltado enquanto estiver no modo safe?",
--     "Trabalho de Pescador, Minerador e Agricultor estão bufados! [Procure no Mapa]",
--     "Você pode fazer TestDrive gratuitamente de carros vips diretamente na concessionária da cidade!",
--     "Em breve punições serão aplicadas em jogadores com muitos deslikes.",
--     "Você pode denúnciar um jogador que deslogou em meio a uma ação através da box deixada no local da morte! [Advertência Automática]",
--     "Trabalho de Mineração de Bitcoin te permite ganhar dinheiro mesmo enquanto está AFK! [Próximo ao Cassino]",
--     "Você ganha 💎 diamantes por tempo online, use o comando /diamantes para acessar a loja de diamantes!",
--     "Você pode avaliar outro jogador (👍/👎) segurando ALT e mirando sobre ele!",
--     "Você sabia que o Sua cidade é uma empresa com atualmente 9 cidades de sucesso online e que já completou 3 anos de vida?",
--     "Você sabia que o Sua cidade foi um patrocinador de BGS 2022? [Acesse nosso instagram @Sua cidade NetWork_]",
--     "Você sabia que hoje mais de 40 colaboradores trabalham full-time no Sua cidade?",
--     "Você sabia que carros vip além de te dar mais respeito com os amigos correm mais que os demais carros da cidade?",
--     "Você sabia que Anti-RP não são bem vindos aqui? E que você pode denúnciar um mau jogador? [Aperte F5]",
--     "Você sabia que existe um FAQ de Dúvidas Frequentes na cidade? [Aperte F5]",
--     "Você sabia que pode abrir a loja vip da cidade a qualquer momento através do comando /lojavip?",
--     "Você sabia que pode avaliar um Staff como positivo ou negativo na prefeitura do Pier?",
--     "Recrutamentos para a polícia são feitos diariamente! [Procure no Mapa]",
--     "Jogadores ganham benefícios por recrutar iniciantes para Polícia, Hospital e Facções!",
--     "O Pier é o Ponto Central da Cidade e onde os moradores se socializam! [Procure no Mapa]",
--     "Você ganha benefícios gratuitamente por estar online através do BattlePass! [Aperte F4]",
--     "Os produtos mais vendidos na loja vip atualmente são o Vip Ouro e BattlePass! [digite /lojavip]",
--     "Seu personagem não morre mais de fome e sede enquanto você estiver AFK!",
--     "Em breve jogadores que receberem muitas avaliações como toxicas terão sérios problemas?",   
--     "Você sabia que o BattlePass é renovado todo dia 01 de cada mês?",
--     "Você sabia que Médico é uma profissão legal que paga muito bem?",
--     "Você sabia que pode salvar sua o preset da sua roupa atual e voltar facilmente pra ela depois? [F9/Roupas/Guardar]"
-- }

-- local HelpDone = {}

-- AddStateBagChangeHandler('Active',('player:%s'):format(Player) , function(_, _, Value)
--     local Ped = PlayerPedId()
--     if Value then
--         CreateThread(function()
--             Wait(60000 * 5)
--             while true do
--                 -- if not LocalPlayer["state"]["Newbie"] then
--                 --     return
--                 -- end
--                 ::Another::
--                 if #HelpDone == #HelpNotify then
--                     HelpDone = {}
--                 end
--                 local Random = math.random(1,#HelpNotify)
--                 if HelpDone[Random] then
--                     goto Another
--                 end
--                 HelpDone[Random] = true
--                 TriggerEvent("Notify","dica",HelpNotify[Random],30000,"Dicas")
--                 Wait(1000*60*5)
--             end
--         end)
--     end 
-- end)