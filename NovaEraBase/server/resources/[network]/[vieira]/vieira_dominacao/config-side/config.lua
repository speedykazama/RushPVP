Config = {}

Config.Cooldown = 24 -- Tempo em horas para conseguir dominar novamente a área
Config.AdminGroup = "Admin" -- Grupo permitido para acessar o painel administrativo
Config.AdminCommand = "admdominacao" -- Comando para abrir o painel administrativo

Config.AllowedGroups = {
  -- Grupos permitidos para dominar alguma área
  -- @group é o grupo (vRP.HasGroup e etc.)
  -- @label é o nome do grupo que aparecerá na interface
  { group = "Faccao01", label = "Testadores" },
  { group = "Faccao02", label = "Imperium" },
}

-- Captura (valores baixos = disputa mais longa)
Config.DominationTickMs = 1000 -- Intervalo do tick servidor
Config.DominationBaseRate = 0.68 -- Ganho base / tick (com vantagem numérica)
Config.DominationPeopleMult = 0.1 -- Bônus leve por pessoa a mais no grupo líder
Config.TerritoryDebugRed = true
Config.TerritoryVisualExtendDown = 80.0
Config.TerritoryVisualExtendUp = 520.0

-- Blips no mapa (círculo vermelho fixo + ícone no centro)
Config.MapBlipRadius = 80.0
Config.MapBlipColour = 1 -- vermelho
Config.MapBlipAlpha = 110
Config.MapBlipSprite = 487
Config.MapBlipScale = 0.85

-- Zona: XY do polígono; interiores não contam
Config.DisableDominationInInteriors = true
Config.ZonePollMs = 200
Config.ZoneExitDebounceTicks = 3
