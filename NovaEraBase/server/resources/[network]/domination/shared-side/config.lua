-----------------------------------------------------------------------------------------------------------------------------------------
-- DOMINAÇÃO — CONFIGURAÇÃO
-- Dominação por equipas (recurso party): só quem está numa equipa conta para maioria captura / defesa.
-----------------------------------------------------------------------------------------------------------------------------------------
-- Velocidade base (% da barra por segundo quando há vantagem mínima; multiplicado pela margem de jogadores.)
DominationCaptureRate = 1.85
DominationContestRate = 2.05
-- Ícone radial no mapa (centro da zona PolyZone). Alpha válido 0–255.
DominationNeutralBlipColour = 6
DominationNeutralBlipAlpha = 120
DominationCapturedBlipAlpha = 140
DominationRadiusBlipScale = 115.0
DominationMapBlipLabelPrefix = "Dominação - "
-----------------------------------------------------------------------------------------------------------------------------------------
-- ZONAS
-- Altere pontos via PolyZone in-game ou copie vértices como em safezone.
-----------------------------------------------------------------------------------------------------------------------------------------
DominationZones = {
	["dominacao1"] = {
		Label = "Dominação 1",
		PolyZone = PolyZone:Create({
			vec2(-20.96, -976.35),
			vec2(-70.43, -1117.8),
			vec2(-65.05, -1122.75),
			vec2(27.66, -1117.35),
			vec2(51.83, -1077.19),
			vec2(79.96, -1012.68)
		}, { ["name"] = "dominacao1" }),
		BlipColour = DominationNeutralBlipColour,
		MapBlipZ = 9.0
	}
}
