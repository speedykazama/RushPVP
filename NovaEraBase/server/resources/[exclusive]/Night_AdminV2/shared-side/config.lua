Config = {}
------------------------------------------
-- Geral
------------------------------------------
Config.RegisterCommand = "paineladm"                                -- COMANDO PARA ABRIR O PAINEL
Config.NumeroDeAdvParaBan = 3                                       -- NA TERCEIRA ADVERTÊNCIA O JOGADOR É BANIDO
Config.TempoDeBanMotivoAdv = 999                                    -- TEMPO DE BAN EM DIAS, CASO O JOGADOR TOME A QUANTIDADE DE ADVERTÊNCIAS CONFIGURADA ACIMA
------------------------------------------
-- Diretórios
------------------------------------------
Config.ImagensInventario = "nui://vrp/config/inventory/"            -- DIRETÓRIO DAS IMAGENS DOS ITENS
Config.ImagensGaragem = "http://localhost/veiculos/"                -- DIRETÓRIO DAS IMAGENS DOS VEÍCULOS
Config.ImagensSkins = "http://localhost/skins/"                     -- DIRETÓRIO DAS IMAGENS DAS SKINS
------------------------------------------
-- Permissões
------------------------------------------
Config.Perms = {
    OpenPainel = {"Admin",5},                                       -- PERMISSÃO E HIERARQUIA PARA ABRIR O PAINEL
    AddTeleport = {"Admin",1},                                      -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR ADICIONAR/REMOVER UM TELEPORT
    AddAdv = {"Admin",3},                                           -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR ADICIONAR/REMOVER UMA ADVERTÊNCIA
    AddKick = {"Admin",3},                                          -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR DAR KICK EM UM JOGADOR
    AddBan = {"Admin",3},                                           -- PERMISSÃO E HIERARQUIA PARA CONSEGUIR DAR BAN EM UM JOGADOR
    AddItens = {"Admin",1},                                         -- PERMISSÃO E HIERARQUIA PARA ADICIONAR ITENS NO INVENTÁRIO DE UM JOGADOR
    CatchVehicles = {"Admin",1},                                    -- PERMISSÃO E HIERARQUIA PARA SPAWAR/ADICIONAR VEÍCULOS NA GARAGEM DE UM JOGADOR
    AddSkins = {"Admin",1},                                         -- PERMISSÃO E HIERARQUIA PARA SETAR SKIN JOGADORES
    ManageChests = {"Admin",1},                                     -- PERMISSÃO E HIERARQUIA PARA GERENCIAR OS BAÚS DAS ORGANIZAÇÕES
    ManageGroups = {"Admin",3},                                     -- PERMISSÃO E HIERARQUIA PARA GERENCIAR AS PERMISSÕES DOS JOGADORES
    ManageInventory = {"Admin",1},                                  -- PERMISSÃO E HIERARQUIA PARA GERENCIAR O INVENTÁRIO DOS JOGADORES
    ManageVehicles = {"Admin",1},                                   -- PERMISSÃO E HIERARQUIA PARA GERENCIAR VEÍCULOS DOS JOGADORES
    ManageHouses = {"Admin",1},                                     -- PERMISSÃO E HIERARQUIA PARA GERENCIAR PROPRIEDADES DOS JOGADORES
    ManageMoney = {"Admin",1},                                      -- PERMISSÃO E HIERARQUIA PARA GERENCIAR DINHEIRO DOS JOGADORES
    ManageCoins = {"Admin",1},                                      -- PERMISSÃO E HIERARQUIA PARA GERENCIAR COINS DOS JOGADORES
    ChangeNumber = {"Admin",1},                                     -- PERMISSÃO E HIERARQUIA PARA ALTERAR NÚMERO DOS JOGADORES
    ChangeName = {"Admin",1},                                       -- PERMISSÃO E HIERARQUIA PARA ALTERAR NOME DOS JOGADORES

    Policia = "Policia",                                            -- PERMISSÃO DE POLÍCIA DA BASE
    Staff = "Admin",                                                -- PERMISSÃO DE ADMIN DA BASE
    Bandits = {                                                     -- PERMISSÃO DAS ORGANIZAÇÕES ILEGAIS DA BASE
        "Maonegra","Distrito","P77","Mare",
        "Milicia","Favela6","Chernobyl","Bairro13",
        "Dz7","Labirinto","Medellín","Crateva",
        "Setor13","Crips","Grota"
    }
}
------------------------------------------
-- Webhooks 
------------------------------------------
Config.Webhooks = {
    ScreenShots = "https://discord.com/api/webhooks/1445067443813744660/KxFEP3z-DzPauBYRodWOS1PFUmSYjhlwvmZ_iZ65jvwO9D8gX06Mh25RilLcjbQXlxnP",                                               -- WEBHOOK RESPONSÁVEL PELAS LOGS DAS IMAGENS
    Kick = "https://discord.com/api/webhooks/1445067527192313988/QuAdx3uIr2IEG_896MtETcnkEXS_WJqJ5jdppHCPmet9kp4Y1YpbMHI231cvdBAoLP7C",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DOS KICKS
    Ban = "https://discord.com/api/webhooks/1445067590421709023/6znJtoI402EdznQPqjQ4WJi6YzdaMccLehqhLVBzN1yMzZkJnrLPnIv5oyrkb-U3T7E0",                                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DOS BANS
    Itens = "https://discord.com/api/webhooks/1445067655093420156/OIx-ItkbtBDX5fElyGm7vnb75-b4lmnrlU1HOKZ3VnIxE_di3Vk1PJEaeOX-uVROJ2aL",                                                     -- WEBHOOK RESPONSÁVEL PELAS LOGS DOS ITENS
    God = "https://discord.com/api/webhooks/1445067731002196039/zx_pLGYitnZYdq0inNm5an5tVHKuxwmCFeMnSMf9mmiZRq3t3PhGJVPHkzas98PXCYdu",                                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REVIVER
    Kill = "https://discord.com/api/webhooks/1445067791286669586/HZtB4fiwG054mqcJ4ouTVyP4mf669scrDa78Y8ifrnXMvKObMjXiWn9k8-GI3zSqJq4T",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE KILL
    Vest = "https://discord.com/api/webhooks/1445067858705907935/LX7enUVXsFqXdqP00IDbhhqmlFQCJbPQsosbe6o2h8FTeENkT0OkQ5aAFIlF6xvuZuP_",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE COLETE
    Tpto = "https://discord.com/api/webhooks/1445067929451364453/y-GyWV_K0miZtUdoRH_Q-4Dc9IOxNVUOL0x1U_rs7r6aDTp-rsDvqn3gChXwTmTKIzN8",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE TPTO
    Tptome = "https://discord.com/api/webhooks/1445068015954559008/lhzpUcIQ-RGc70YZFmb8z6s8_nleEKgKeizv0xZZw_cMScnKNIX0v-e4BXj32C6rxUdf",                                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE TPTOME
    Fix = "https://discord.com/api/webhooks/1445068075958272025/4Q4jOSjEfwb6-T27jphsaWsoMU5q4zo4UMQGOnzfkVeo2HBOH33sJqH1Wmt3So52QeAX",                                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DE FIX
    Reset = "https://discord.com/api/webhooks/1445068142446383137/SkrtFnwIsB_t4xOMreo173QwU1CuJUNJcpnmhtWrE9ssBg603MotVIL0BWHL_maYwEe0",                                                     -- WEBHOOK RESPONSÁVEL PELAS LOGS DE RESET
    Algema = "https://discord.com/api/webhooks/1445068203368906782/Syqrlb7SNOQBQMUWVGv80CWa55PE2A4hSGDUyu4_xVqVT5yLtmGtv9cPPMJvFaNSgJSl",                                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ALGEMAR E DESALGEMAR
    Ragdoll = "https://discord.com/api/webhooks/1445068271031422976/ucgxnXqKKUjHiQIxsfmiLxUi7JTIGMJYCyb9lVMiPbH2aY0TL2IqmZ6ZEDXTtA-UKhbq",                                                   -- WEBHOOK RESPONSÁVEL PELAS LOGS DE DERRUBAR
    Fire = "https://discord.com/api/webhooks/1445068341617102961/_wViHVEA1zaFGaBooYQbSIq3EAxVsDasYlvzInrpjmcCPcoT5aiZ5raTc2unoXQra12T",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE FOGO
    HungerThirst = "https://discord.com/api/webhooks/1445068409380274329/TcAJ05iKxhJOBX-mn28Ymh48lePNOWXYICFGIv6nKKodyCc3OJOpR-Bn8QDcn2Odup3x",                                              -- WEBHOOK RESPONSÁVEL PELAS LOGS DE FOME E SEDE
    Spectate = "https://discord.com/api/webhooks/1445068533011841064/f-DYB2e7D-msMyuK8vwYgTQAqE6MiWHdLGBQHY4ei47Mi2LQSCQYy9u5hd4G0tc312qR",                                                  -- WEBHOOK RESPONSÁVEL PELAS LOGS DE SPECTAR
    Freeze = "https://discord.com/api/webhooks/1445068592566501386/QpxXjmpt11k5mNSiVnlqeNVPUvrtkryTZI83FZ3ZNeadVLLau7TGmO8crFJEwIZX9ed1",                                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE CONGELAR E DESCONGELAR
    Message = "https://discord.com/api/webhooks/1445068655783317576/841zVzMruPr_jthBvIHsv1XX5XzudSjRE4YluMYMMnjKNLdO8drLBHGetYL5N0hZB7EO",                                                   -- WEBHOOK RESPONSÁVEL PELAS LOGS DE MENSAGEM
    Skin = "https://discord.com/api/webhooks/1445068725546913813/HGwDc_emg7o7VSVWVTxJOec3_kGodCe_IV6NvD_x0AyOyoW_5hL6Zp5Pi-izr9BQ8rLT",                                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE SKIN
    UpgradeHierarchy = "https://discord.com/api/webhooks/1445068787102781580/wfKp3s7O8WbosLFwk9JxT2Ywu0_9r58p7_VlNj5UJS_177LXvt0v3g_MDIuUSuucB-a8",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE UPGRADE NA HIERARQUIA
    DowngradeHierarchy = "https://discord.com/api/webhooks/1445068949267021965/pnTX7GtjlmXZrq6HJhZJC_B8Z7TSptievZ-__exhRUgjdoef1PVLhaxmH_LycFPM4st0",                                        -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REBAIXAR HIERARQUIA
    Dismiss = "https://discord.com/api/webhooks/1445069002152874095/weMOcb7bcLXn3n0HBS-K_FwXKpUFFj9Yg_YTrfd8pVEdscB72fRcn1U3laEuhaq0K-M-",                                                   -- WEBHOOK RESPONSÁVEL PELAS LOGS DE DEMISSÃO
    RemoveItemInventory = "https://discord.com/api/webhooks/1445069106448695377/EFK_z2GV3I6fJz0w8jNRimppcNcfCt1KpsiHljihVsn6JhHWkmGX_EgwdGikTIqj2R57",                                       -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE ITEM NO INVENTÁRIO
    RemoveItemChestHouse = "https://discord.com/api/webhooks/1445075265721208966/xY3WZisvdRx4foJsXmRm-TaaFQevz5X7Bq_yYesJ9sByoQq59jq3FuAf1vd40jhKteAR",                                      -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE ITEM NO BAÚ DE PROPRIEDADE
    RemoveVehicle = "https://discord.com/api/webhooks/1445069401798869004/FtgfZSxE06qnxSdUN9dBc3IYBewY8-J7HLHLswf6BQeVlD5oua47O2_H3kTiirCvsEGu",                                             -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE VEÍCULOS
    RemoveItemChestVehicle = "https://discord.com/api/webhooks/1445069187323138148/o84CHKw0XI7xfNBSn0E950X3aFoLRe7PNvea_qL6TRTvTGih29P-KPgtee72Jqbqos2v",                                    -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOÇÃO DE ITEM NO BAÚ DE VEÍCULOS
    ChangeWalletMore = "https://discord.com/api/webhooks/1445075479756279953/nmDC2MHW-Cj9CYCwlFw3RUYT-ZjIf1FTc4OvMmVXoTWM_me9qjHDr3R-LDjLK_8p4-fp",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ADICIONAR DINHEIRO EM MÃOS
    ChangeWalletLess = "https://discord.com/api/webhooks/1445075572265980036/ewzpZ0pppKjgwJYNCOTzYRfNPCgDXB6wOhBMLcMZuFamiLekpk53OC80IX2oLk60Oieh",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOVER DINHEIRO EM MÃOS
    ChangeBankMore = "https://discord.com/api/webhooks/1445075479756279953/nmDC2MHW-Cj9CYCwlFw3RUYT-ZjIf1FTc4OvMmVXoTWM_me9qjHDr3R-LDjLK_8p4-fp",                                            -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ADICIONAR DINHEIRO NO BANCO
    ChangeBankLess = "https://discord.com/api/webhooks/1445075750947389463/ldh-v8965u2DyVGn11lTzo13eLIi-a1P_M5nNrWlbCHMIGVnVbK_ZtoDbBEHgrBYEU5_",                                            -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOVER DINHEIRO NO BANCO
    ChangeNumber = "https://discord.com/api/webhooks/1445075871927894140/mxYLwPzhu5CI7LE0TfTFtHzUpGrw7zP1-CVPyurLycaofReHKXv4AD-6Pv8CJ0aio8Iu",                                              -- WEBHOOK RESPONSÁVEL PELAS LOGS DE TROCAR DE NÚMERO
    ChangeName = "https://discord.com/api/webhooks/1445075932967866428/zs1JV__Jw41HNzBEVFxp71nBmY0p90FLe3QZslBkdVMfjG2TvmESp1jaMC-yP7jBmXpV",                                                -- WEBHOOK RESPONSÁVEL PELAS LOGS DE NOME
    SetNewPermission = "https://discord.com/api/webhooks/1445075995462733937/a9U4-TfQoSAltc7oD5oNC-pz6EX6-UXdHFIWJcBnRaS4ItnEekqZpAVicXM6NMA8rtFM",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE ADICIONAR PERMISSÃO
    RemovePermission = "https://discord.com/api/webhooks/1445076060457930763/b2FGXL0zNuBoVZPoaBwuvBKrr3O0fJeEAHBClERrJ_H0vT3m46ZSaKrbCUECKas0j89g",                                          -- WEBHOOK RESPONSÁVEL PELAS LOGS DE REMOVER PERMISSÃO
    DiscordImageFooter = "",                                        -- LINK DA LOGO DO SEU SERVIDOR
    DiscordImageThumbanil = ""                                      -- LINK DA LOGO DO SEU SERVIDOR
}
------------------------------------------
-- Skins
------------------------------------------
-- RESOLUÇÃO RECOMENDADA PARA AS IMAGENS DAS SKINS: 1100 x 900
-- Caso for mp_m_freemode_01 ou mp_f_freemode_01, mantém o Sex como "Default", caso for outros peds que não são defaults, coloca "M" para Masculino e "F" para Feminino
Config.Skins = {
    [1] = { Nome = "Default M", Spawn = "mp_m_freemode_01", Sex = "Default" },
    [2] = { Nome = "Default F", Spawn = "mp_f_freemode_01" , Sex = "Default" }
}

return Config