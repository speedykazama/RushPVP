-----------------------------------------------------------------------------------------------------------------------------------------
-- BASE
-----------------------------------------------------------------------------------------------------------------------------------------
BaseMode = "steam"  												-- "license", "steam" ou "universal"
-- Explicação dos modos:
-- "steam"      → só jogadores com Steam conseguem entrar. 
-- "license"    → qualquer jogador com License, seja Steam ou Rockstar, consegue entrar. 
-- "universal"  → tenta usar Steam primeiro, se não tiver Steam, usa License. Assim, qualquer jogador consegue entrar.
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
ServerName = "Rush PvP"									-- Nome do servidor
UsableF7 = true														-- Mostrar id em cima das cabeças
RadarEletronico = false                                              -- Ativar radares eletronicos
ShootCrouch = true													-- Atirar agachado
RunSpeedMultiplier = 1.12											-- Velocidade ao correr/sprint (1.0 = padrão do jogo)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
QueryFields = {                                                     -- Query da tabela characters
    "id", "license", "phone", "serial", "name", "name2", "sex", "bank", "blood", "prison", "gun", "fines", "medicplan", "taxs", "likes", "unlikes", "age", "login",
    "cardlimit", "spending", "cardpassword"
}

AccountFields = {													-- Query da tabela accounts
    "gems", "rolepass", "premiumplatina", "premiumprata", "premiumouro", "discord", "chars"
}

CharacterVRP = {													-- Funções extras quando o personagem é criado
    { func = "SetSerial", args = {} },								-- Gera um serial único para o jogador
    { func = "GiveBank", args = { "MoneyBank" } },					-- Adiciona o dinheiro inicial no banco
    { func = "SetWeight", args = { "BackpackWeightDefaultNormal" } } -- Define o peso padrão da mochila
}

CharacterQueries = {												-- Queries executadas após criação do personagem
	{ query = "playerdata/SetData", params = function(Passport, source, Model) -- Salva a personalização da barbearia (aparência inicial) 					
		return { Passport = Passport, dkey = "Barbershop", dvalue = json.encode(BarbershopInit[Model]) }
	end },

  	{ query = "playerdata/SetData", params = function(Passport, source, Model) -- Salva as roupas iniciais do personagem
		return { Passport = Passport, dkey = "Clothings", dvalue = json.encode(StartClothes[Model]) }
	end },

	{ query = "playerdata/SetData", params = function(Passport, source, Model) -- Salva o datatable com todas as informações do personagem
		return { Passport = Passport, dkey = "Datatable", dvalue = json.encode(Characters[source]['table']) }
	end },

	{ query = "characters/LastLogin", params = function(Passport)	-- Atualiza o último login do jogador				
		return { Passport = Passport } 																
	end }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER / THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
ConsumeHunger = 0													-- Quantos % vai consumir da fome
ConsumeThirst = 0													-- Quantos % vai consumir da sede
CooldownHungerThrist = 0										-- Tempo de desgaste (180000 = 3 Minutos)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
MaxVehiclePadrao = 5                                       -- QUANTIDADE PADRÃO QUE UM JOGADOR PODE TER DE VEÍCULOS NA GARAGEM
MaxVehiclePremiumPrata = 2                                 -- VIP PRATA AUMENTA 2 SLOTS
MaxVehiclePremiumOuro = 3                                  -- VIP OURO AUMENTA 3 SLOTS
MaxVehiclePremiumPlatina = 5                               -- VIP PLATINA AUMENTA 5 SLOTS
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
MaxPropertysPadrao = 1                                       -- Quantidade padrão que um jogador pode ter de propriedades
MaxPropertysPremiumPrata = 2                                 -- Quantidade que um jogador vip prata pode ter de propriedades
MaxPropertysPremiumOuro = 3                                  -- Quantidade que um jogador vip ouro pode ter de propriedades
MaxPropertysPremiumPlatina = 5                               -- Quantidade que um jogador vip platina pode ter de propriedades
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
CleanDeathInventory = true											-- Limpar inventário ao morrer
BackpackWeightDefaultNormal = 30          							-- Peso padrão do inventário
ItemDurabilityEnabled = false										-- Itens não expiram (sem durabilidade/validade)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHITELIST
-----------------------------------------------------------------------------------------------------------------------------------------
Whitelisted = true													-- Whitelist no servidor
ReleaseText = "Envie na sala liberação"								-- Texto de liberação da whitelist
BanText = "Estás banido da cidade. Teu banimento cessará em %s." -- Texto de banimento
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALARY
-----------------------------------------------------------------------------------------------------------------------------------------
ShowNotificationSalary = true                 						-- Mostrar a notificação de salário
SalarySeconds = 1800                           						-- Intervalo do salário em segundos (1800 = 30 minutos)
SalaryVIPTextNotification = "Você recebeu R${salary} do seu VIP {work}."		-- Texto do salário de VIP
SalaryWorkTextNotification = "Você recebeu R${salary} do seu serviço {work}." 	-- Texto do salário de organização
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPAGANDA
-----------------------------------------------------------------------------------------------------------------------------------------
ClothesAdEnabled = true																-- Notificação periódica de roupas personalizadas
ClothesAdSeconds = 1800																-- Intervalo em segundos (1800 = 30 minutos)
ClothesAdMessage = "Queres fazer a tua roupa? Abre um ticket e nos ajudamos!"
ClothesAdTitle = "Roupas Personalizadas"
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKOUTTIME
-----------------------------------------------------------------------------------------------------------------------------------------
BlackoutTime = 600000                                               -- Tempo para o blackout acabar (600000 = 10 Minutos)
BlackoutText = "Os serviços em nossa central foram reestabelecidos."-- Texto da notificação padrão para blackout desativado
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTOSAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AutoSave = true                                						-- Salvar o Banco de dados automático
AutoSaveTime = 60000                           						-- (60000 = 1 Minuto)
AutoSaveSilenced = true                       						-- Printar no CMD quando o save for feito
AutoSaveMessage = "Banco de Dados foi salvo."						-- Mensagem que vai aparecer no CMD
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARENA
-----------------------------------------------------------------------------------------------------------------------------------------
BackArenaPos = vec3(-1046.43,-474.55,36.78)							-- Coordenada onde o jogador reaparece ao deslogar dentro da arena

ArenaItens = {														-- Itens recebidos ao entrar na arena
	["WEAPON_SPECIALCARBINE_MK2"] = 1,
	["WEAPON_PISTOL_MK2"] = 1,
	["WEAPON_PISTOL_AMMO"] = 1000,
	["WEAPON_RIFLE_AMMO"] = 1000,
	["energetic2"] = 30
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
SpawnPrison = vec3(1679.94, 2513.07, 45.56)                         -- Coordenada padrão de rntrada da prisão
BackPrison = vec3(1851.79,2612.54,45.66)							-- Coordenada padrão de saida da prisão
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
DefaultSkinshop = true                                             -- Vai utilizar a loja de roupas na criação de personagem?
DefaultBarbershop = true                                           -- Vai utilizar a barbearia na criação de personagem?
SpawnCreatorCoords = vec4(-38.67,-583.37,82.91,249.45)             -- Local onde o jogador é criado para configurar o personagem (criação inicial)
SpawnCamCreatorCoords = vec4(-37.00,-584.90,83.91,68.0)            -- Local onde a câmera do jogador é criado para configurar o personagem (criação inicial)
SpawnCoords = vec4(-1601.1,-1041.7,13.02,323.15)                   -- Local onde o jogador é levado após finalizar a criação do personagem
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAPSETTINGS
-----------------------------------------------------------------------------------------------------------------------------------------
MapNameModifier = true                                              -- Texto personalizado acima do mapa
MapTextName = "Nova Era RolePlay"              						-- Texto que vai aparecer acima do mapa
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONDAMAGE
-----------------------------------------------------------------------------------------------------------------------------------------
InfiniteAmmoClip = true												-- Balas infinitas sem precisar recarregar
AiWeaponDamageModifier = 0.75  										-- NPCs causam 75% do dano normal

WeaponDamageModifier = {											-- Quanto dano cada arma do jogador causa
    ["WEAPON_BAT"] = 0.25,
    ["WEAPON_KATANA"] = 0.25,
    ["WEAPON_HAMMER"] = 0.25,
    ["WEAPON_WRENCH"] = 0.25,
    ["WEAPON_UNARMED"] = 0.25,
    ["WEAPON_HATCHET"] = 0.25,
    ["WEAPON_CROWBAR"] = 0.25,
    ["WEAPON_MACHETE"] = 0.25,
    ["WEAPON_POOLCUE"] = 0.25,
    ["WEAPON_KNUCKLE"] = 0.25,
    ["WEAPON_KARAMBIT"] = 0.25,
    ["WEAPON_GOLFCLUB"] = 0.25,
    ["WEAPON_BATTLEAXE"] = 0.25,
    ["WEAPON_FLASHLIGHT"] = 0.25,
    ["WEAPON_NIGHTSTICK"] = 0.35,
    ["WEAPON_SMOKEGRENADE"] = 0.0,
    ["WEAPON_STONE_HATCHET"] = 0.25
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTAURANT
-----------------------------------------------------------------------------------------------------------------------------------------
PermissionsItensExtrasRestaurante = { "Restaurantes" } 				-- Permissões que recebem bônus de itens extras
ItensExtrasRestaurante = 10                            				-- Quantos itens extras os jogadores com permissão podem levar
-----------------------------------------------------------------------------------------------------------------------------------------
-- VIPS
-----------------------------------------------------------------------------------------------------------------------------------------
BackpackWeightPremiumPrata = 35           							-- Peso padrão para Premium Prata
BackpackWeightPremiumOuro = 40            							-- Peso padrão para Premium Ouro
BackpackWeightPremiumPlatina = 50        							-- Peso padrão para Premium Platina

ClearInventoryPremiumPrata = true									-- Limpar inventário ao morrer do Premium Prata
ClearInventoryPremiumOuro = true									-- Limpar inventário ao morrer do Premium Ouro
ClearInventoryPremiumPlatina = true									-- Limpar inventário ao morrer do Premium Platina

ItensExtrasPremiumPrata = 2   										-- Quantos itens a mais os Premium Prata vão podere levar na mochila
ItensExtrasPremiumOuro = 4   										-- Quantos itens a mais os Premium Ouro vão podere levar na mochila
ItensExtrasPremiumPlatina = 6   									-- Quantos itens a mais os Premium Platina vão podere levar na mochila

MaxVehiclePremiumPrata = 2											-- Maximo de veículos Premium Prata
MaxVehiclePremiumOuro = 2											-- Maximo de veículos Premium Ouro
MaxVehiclePremiumPlatina = 3										-- Maximo de veículos Premium Platina
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK
-----------------------------------------------------------------------------------------------------------------------------------------
NewBank = true                                                      -- true se você tiver o nosso bank
NewBankTaxs = true                                                  -- true se você quiser ativar os impostos
NewBankMinTaxs = 15000                                              -- true se quiser ativar os impostos na base com o nosso bank
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
BurstTyresBySpeed = false                                            -- Estourar pneus quando atingir grandes velocidades forçando o veículo
ShakeVehicleCamera = false                                           -- Balançar a câmera do personagem quando bater o veículo
EnableManeuvers = false                                              -- Se é permitido manobras em cima de motos pressionando as setas do teclado
CanPushCars = true													-- Empurrar veículos pressionando a letra Q
-----------------------------------------------------------------------------------------------------------------------------------------
-- HITMARKER
-----------------------------------------------------------------------------------------------------------------------------------------
HitMarker = true        											-- Mostrar danos em pessoas
ShowNPCDamages = false   											-- Mostrar danos em npcs
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEATHER
-----------------------------------------------------------------------------------------------------------------------------------------
TempoClima = 4														-- Tempo em horas para trocar o clima
WeatherList = { "CLEAR","CLEAR","CLEAR","CLEAR", } -- Lista dos climas
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS
-----------------------------------------------------------------------------------------------------------------------------------------
NewItemIdentity = false											-- Dar o item identidade ao criar um personagem
MoneyBank = 50000												    -- Dinheiro inicial no banco
NewGemstoneInitial = false     										-- Gemstone Inicial Grátis
QuantityGemstone = 0		  										-- Quantidade de Gemas Grátis Inicial

CharacterItens = {													-- Itens recebidos ao criar o personagem
	--["water"] = 3,
	--["sandwich"] = 5,
	["cellphone"] = 1,
	["dollars"] = 5000
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
ObjectsBlips = false                                                -- True para ativar blips das caixas de loot
ObjectsBlipAlpha = 200                                              -- Opacidade do blip das caixas de loot
ObjectsBlipColour = 2                                               -- Cor do blip das caixas de loot
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
Maintenance = false													-- True para ativar a manutenção
MaintenanceText = "Servidor em manutenção"							-- Texto exibido quando o servidor está em manutenção
MaintenanceLicenses = {												-- Licenses que podem entrar na manutenção
	[""] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOQUEARARMAPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
BloquearArmaPolice = false  											-- Bloquear armas policiais para somente Policiais usar?
WeaponsPoliceBlock = {
	"WEAPON_NIGHTSTICK",
	"WEAPON_STUNGUN",
	--"WEAPON_COLTXM177",
	--"WEAPON_TACTICALRIFLE",
	--"WEAPON_HEAVYRIFLE",
	"WEAPON_PARAFAL",
	--"WEAPON_APPISTOL",
	--"WEAPON_HEAVYPISTOL",
	--"WEAPON_COMBATPISTOL",
	--"WEAPON_SMG",
	"WEAPON_SMG_MK2",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_CARBINERIFLE",
	--"WEAPON_PUMPSHOTGUN",
	"WEAPON_CARBINERIFLE_MK2"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOQUEARARMAVIP
-----------------------------------------------------------------------------------------------------------------------------------------
BloquearArmaVip = false     											-- Bloquear armas vips para somente premiums usar?
WeaponsVip = {
	"WEAPON_VANDAL",
	"WEAPON_VANDAL1",
	"WEAPON_VANDAL2",
	"WEAPON_GLITCHPOPVANDAL"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOQUEARARMAPORTE
-----------------------------------------------------------------------------------------------------------------------------------------
BloquearArmaPorte = false											-- Bloquear armas de porte somente para quem ter porte?
WeaponsArmaPorteBlock = {
    "WEAPON_GLOCK21"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORBIDDENITENS
-----------------------------------------------------------------------------------------------------------------------------------------
ForbiddenItens = {													-- Itens que não podem ser descartados
	["newchars"] = true, 
	["chip"] = true,
	["diagram"] = true,
	["gemstone"] = true,
	["WEAPON_PICKAXE_PLUS"] = true, 
	["premiumplate"] = true, 
	["premiumprata"] = true, 
	["premiumouro"] = true, 
	["premiumplatina"] = true, 
	["namechange"] = true, 
	["verify"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXCLUSIVEITENS
-----------------------------------------------------------------------------------------------------------------------------------------
ExclusiveItens = {													-- Itens que não podem ser manuseados
    ["backpack"] = true,
    ["WEAPON_PARAGOLD"] = true,
    ["WEAPON_G3GOLD"] = true, 
    ["WEAPON_GGOLDLP"] = true, 
    ["WEAPON_M4GOLD"] = true, 
    ["WEAPON_AKGOLD"] = true, 
    ["mochilapremiump"] = true, 
    ["mochilapremiumm"] = true, 
    ["mochilapremiumg"] = true, 
    ["WEAPON_G3GOLD"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
GroupBlips = {														-- Serviços com blips em tempo real
	["PMERJ"] = true,
	["PCERJ"] = true,
	["PRF"] = true,
	["BOPE"] = true,
	["RECOM"] = true,
	["BPCHQ"] = true,
	["EX"] = true,
	["Paramedic"] = true,
	["Bombeiro"] = true,
	["Mechanic"] = true,
	["Mechanic2"] = true,
	["CatCafe"] = true,
	["Japanese"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENTSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
ClientState = {														-- Define grupos com estados ativos no cliente em tempo real
	["Admin"] = true,
	["Premium"] = true,
	["PremiumOuro"] = true,
	["PremiumPrata"] = true,
	["PMERJ"] = true,
	["PCERJ"] = true,
	["PRF"] = true,
	["BOPE"] = true,
	["RECOM"] = true,
	["BPCHQ"] = true,
	["EX"] = true,
	["Paramedic"] = true,
	["Bombeiro"] = true,
	["Mechanic"] = true,
	["Mechanic2"] = true,
	["CatCafe"] = true,
	["Japanese"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORK
-----------------------------------------------------------------------------------------------------------------------------------------
Work = {															-- Lista de empregos
    ["Minerman"] = "Minerador",
    ["Lumberman"] = "Lenhador",
    ["Transporter"] = "Transportador de Valores",
    ["Garbageman"] = "Lixeiro",
    ["Hunter"] = "Caçador",
    ["Fruitman"] = "Agricultor",
    ["Dismantle"] = "Desmanchador",
    ["Tows"] = "Rebocador",
    ["Fisherman"] = "Pescador",
    ["Trucker"] = "Caminhoneiro",
    ["Bus"] = "Motorista de Ônibus",
    ["Taxi"] = "Taxista",
    ["Cleaner"] = "Faxineiro",
    ["PostOp"] = "Carteiro",
    ["Milkman"] = "Leiteiro",
    ["Tractor"] = "Tratorista",
    ["Diver"] = "Mergulhador",
    ["Cemitery"] = "Coveiro"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYPES
-----------------------------------------------------------------------------------------------------------------------------------------
Types = { "A+","B+","A-","B-" }											-- Tipos sanguíneos
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKITEM
-----------------------------------------------------------------------------------------------------------------------------------------
BlockItem = {														-- Itens que só podem ser guardados em geladeira
	["mushroomteaplus"] = true,
	["mushroomtea"] = true,
	["nigirizushi"] = true,
	["sushi"] = true,
	["cupcake"] = true,
	["milkshake"] = true,
	["cappuccino"] = true,
	["applelove"] = true,
	["cheese"] = true,
	["burgershot1"] = true,
	["burgershot2"] = true,
	["burgershot3"] = true,
	["burgershot4"] = true,
	["pizzathis1"] = true,
	["pizzathis2"] = true,
	["pizzathis3"] = true,
	["pizzathis4"] = true,
	["uwucoffee1"] = true,
	["uwucoffee2"] = true,
	["uwucoffee3"] = true,
	["uwucoffee4"] = true,
	["beanmachine1"] = true,
	["beanmachine2"] = true,
	["beanmachine3"] = true,
	["beanmachine4"] = true,
	["octopus"] = true,
	["shrimp"] = true,
	["carp"] = true,
	["codfish"] = true,
	["catfish"] = true,
	["goldenfish"] = true,
	["horsefish"] = true,
	["tilapia"] = true,
	["pacu"] = true,
	["pirarucu"] = true,
	["tambaqui"] = true,
	["milkbottle"] = true,
	["guarananatural"] = true,
	["water"] = true,
	["coffee"] = true,
	["coffeemilk"] = true,
	["cola"] = true,
	["tacos"] = true,
	["fries"] = true,
	["soda"] = true,
	["apple"] = true,
	["orange"] = true,
	["strawberry"] = true,
	["coffee2"] = true,
	["grape"] = true,
	["tange"] = true,
	["banana"] = true,
	["guarana"] = true,
	["acerola"] = true,
	["passion"] = true,
	["tomato"] = true,
	["mushroom"] = true,
	["sugar"] = true,
	["cookies"] = true,
	["orangejuice"] = true,
	["tangejuice"] = true,
	["grapejuice"] = true,
	["strawberryjuice"] = true,
	["bananajuice"] = true,
	["acerolajuice"] = true,
	["passionjuice"] = true,
	["bread"] = true,
	["ketchup"] = true,
	["cannedsoup"] = true,
	["canofbeans"] = true,
	["meat"] = true,
	["fishfillet"] = true,
	["marshmallow"] = true,
	["cookedfishfillet"] = true,
	["cookedmeat"] = true,
	["hamburger"] = true,
	["hamburger2"] = true,
	["onionrings"] = true,
	["chickenfries"] = true,
	["pizzamozzarella"] = true,
	["pizzamushroom"] = true,
	["pizzabanana"] = true,
	["pizzachocolate"] = true,
	["calzone"] = true,
	["hotdog"] = true,
	["donut"] = true,
	["chocolate"] = true,
	["sandwich"] = true,
	["absolut"] = true,
	["chandon"] = true,
	["dewars"] = true,
	["hennessy"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BONES
-----------------------------------------------------------------------------------------------------------------------------------------
Bones = {														  	-- IDs dos ossos do ped mapeados para partes do corpo
	[11816] = "Pelvis",
	[58271] = "Coxa Esquerda",
	[63931] = "Panturrilha Esquerda",
	[14201] = "Pe Esquerdo",
	[2108] = "Dedo do Pe Esquerdo",
	[65245] = "Pe Esquerdo",
	[57717] = "Pe Esquerdo",
	[46078] = "Joelho Esquerdo",
	[51826] = "Coxa Direita",
	[36864] = "Panturrilha Direita",
	[52301] = "Pe Direito",
	[20781] = "Dedo do Pe Direito",
	[35502] = "Pe Direito",
	[24806] = "Pe Direito",
	[16335] = "Joelho Direito",
	[23639] = "Coxa Direita",
	[6442] = "Coxa Direita",
	[57597] = "Espinha Cervical",
	[23553] = "Espinha Toraxica",
	[24816] = "Espinha Lombar",
	[24817] = "Espinha Sacral",
	[24818] = "Espinha Cocciana",
	[64729] = "Escapula Esquerda",
	[45509] = "Braco Esquerdo",
	[61163] = "Antebraco Esquerdo",
	[18905] = "Mao Esquerda",
	[18905] = "Mao Esquerda",
	[26610] = "Dedo Esquerdo",
	[4089] = "Dedo Esquerdo",
	[4090] = "Dedo Esquerdo",
	[26611] = "Dedo Esquerdo",
	[4169] = "Dedo Esquerdo",
	[4170] = "Dedo Esquerdo",
	[26612] = "Dedo Esquerdo",
	[4185] = "Dedo Esquerdo",
	[4186] = "Dedo Esquerdo",
	[26613] = "Dedo Esquerdo",
	[4137] = "Dedo Esquerdo",
	[4138] = "Dedo Esquerdo",
	[26614] = "Dedo Esquerdo",
	[4153] = "Dedo Esquerdo",
	[4154] = "Dedo Esquerdo",
	[60309] = "Mao Esquerda",
	[36029] = "Mao Esquerda",
	[61007] = "Antebraco Esquerdo",
	[5232] = "Antebraco Esquerdo",
	[22711] = "Cotovelo Esquerdo",
	[10706] = "Escapula Direita",
	[40269] = "Braco Direito",
	[28252] = "Antebraco Direito",
	[57005] = "Mao Direita",
	[58866] = "Dedo Direito",
	[64016] = "Dedo Direito",
	[64017] = "Dedo Direito",
	[58867] = "Dedo Direito",
	[64096] = "Dedo Direito",
	[64097] = "Dedo Direito",
	[58868] = "Dedo Direito",
	[64112] = "Dedo Direito",
	[64113] = "Dedo Direito",
	[58869] = "Dedo Direito",
	[64064] = "Dedo Direito",
	[64065] = "Dedo Direito",
	[58870] = "Dedo Direito",
	[64080] = "Dedo Direito",
	[64081] = "Dedo Direito",
	[28422] = "Mao Direita",
	[6286] = "Mao Direita",
	[43810] = "Antebraço Direito",
	[37119] = "Antebraço Direito",
	[2992] = "Cotovelo Direito",
	[39317] = "Pescoco",
	[31086] = "Cabeca",
	[12844] = "Cabeca",
	[65068] = "Rosto"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
StartClothes = {													-- Roupa inicial que os jogadores nascem.
	["mp_m_freemode_01"] = {										-- Masculino
		["pants"] = { item = 105, texture = 4 },
		["arms"] = { item = 0, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 0, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["shoes"] = { item = 1, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["backpack"] = { item = 101, texture = 0 },
		["hat"] = { item = -1, texture = 0 },
		["glass"] = { item = -1, texture = 0 },
		["ear"] = { item = -1, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 }
	},
	["mp_f_freemode_01"] = {										-- Feminino
		["pants"] = { item = 156, texture = 0 },
		["arms"] = { item = 0, texture = 0 },
		["tshirt"] = { item = 3, texture = 0 },
		["torso"] = { item = 0, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["shoes"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["hat"] = { item = -1, texture = 0 },
		["glass"] = { item = -1, texture = 0 },
		["ear"] = { item = -1, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
BarbershopInit = {													-- Customização inicial que os jogadores nascem 
	mp_m_freemode_01 = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
	mp_f_freemode_01 = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LANG
-----------------------------------------------------------------------------------------------------------------------------------------
Lang = {
	["Join"] = "Entrando em Rush PvP...",
	["Connecting"] = "Conectando - se em Rush PvP...",
	["Position"] = "Você é o %d/%d da fila, aguarde sua conexão com a cidade Rush PvP",
	["Error"] = "Conexão perdida com a cidade Rush PvP."
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
Queue = {
	["List"] = {},
	["Players"] = {},
	["Counts"] = 0,
	["Connecting"] = {},
	["Threads"] = 0,
	["Max"] = 2048
}