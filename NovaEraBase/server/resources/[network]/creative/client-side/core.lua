-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local TheNpcControl = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Blips = {
	-- Departament (Framework)
	-- { 29.2,-1351.89,29.34,52,36,"Loja de Departamento",0.5 },
	-- { 2561.74,385.22,108.61,52,36,"Loja de Departamento",0.5 },
	-- { 1160.21,-329.4,69.03,52,36,"Loja de Departamento",0.5 },
	-- { -711.99,-919.96,19.01,52,36,"Loja de Departamento",0.5 },
	-- { -54.56,-1758.56,29.05,52,36,"Loja de Departamento",0.5 },
	-- { 375.87,320.04,103.42,52,36,"Loja de Departamento",0.5 },
	-- { -3237.48,1004.72,12.45,52,36,"Loja de Departamento",0.5 },
	-- { 1730.64,6409.67,35.0,52,36,"Loja de Departamento",0.5 },
	-- { 543.51,2676.85,42.14,52,36,"Loja de Departamento",0.5 },
	-- { 1966.53,3737.95,32.18,52,36,"Loja de Departamento",0.5 },
	-- { 2684.73,3281.2,55.23,52,36,"Loja de Departamento",0.5 },
	-- { 1696.12,4931.56,42.07,52,36,"Loja de Departamento",0.5 },
	-- { -1820.18,785.69,137.98,52,36,"Loja de Departamento",0.5 },
	-- { 1395.35,3596.6,34.86,52,36,"Loja de Departamento",0.5 },
	-- { -2977.14,391.22,15.03,52,36,"Loja de Departamento",0.5 },
	-- { -3034.99,590.77,7.8,52,36,"Loja de Departamento",0.5 },
	-- { 1144.46,-980.74,46.19,52,36,"Loja de Departamento",0.5 },
	-- { 1166.06,2698.17,37.95,52,36,"Loja de Departamento",0.5 },
	-- { -1493.12,-385.55,39.87,52,36,"Loja de Departamento",0.5 },
	-- { -1228.6,-899.7,12.27,52,36,"Loja de Departamento",0.5 },
	-- Gas Station (Framework)
	-- { 265.09,-1258.94,29.13,361,35,"Posto de Gasolina",0.4 },
	-- { -2097.61,-320.57,13.16,361,35,"Posto de Gasolina",0.4 },
	-- { -2555.19,2334.31,33.08,361,35,"Posto de Gasolina",0.4 },
	-- { 179.99,6602.84,31.86,361,35,"Posto de Gasolina",0.4 },
	-- { 818.92,-1028.65,26.89,361,35,"Posto de Gasolina",0.4 },
	-- { 1207.05,-1403.68,36.26,361,35,"Posto de Gasolina",0.4 },
	-- { 1181.61,-330.8,69.78,361,35,"Posto de Gasolina",0.4 },
	-- { 619.47,270.18,103.26,361,35,"Posto de Gasolina",0.4 },
	-- { 2581.01,362.42,108.88,361,35,"Posto de Gasolina",0.4 },
	-- { 174.86,-1562.55,29.87,361,35,"Posto de Gasolina",0.4 },
	-- { -319.25,-1470.23,30.5,361,35,"Posto de Gasolina",0.4 },
	-- { 1786.08,3329.86,40.42,361,35,"Posto de Gasolina",0.4 },
	-- { 48.92,2779.59,57.05,361,35,"Posto de Gasolina",0.4 },
	-- { 264.98,2607.18,43.99,361,35,"Posto de Gasolina",0.4 },
	-- { 1039.9,2671.05,39.53,361,35,"Posto de Gasolina",0.4 },
	-- { 1208.52,2659.43,36.9,361,35,"Posto de Gasolina",0.4 },
	-- { 2539.8,2594.81,36.96,361,35,"Posto de Gasolina",0.4 },
	-- { 2006.21,3774.96,31.4,361,35,"Posto de Gasolina",0.4 },
	-- { 1690.1,4927.81,41.23,361,35,"Posto de Gasolina",0.4 },
	-- { 1701.73,6416.49,31.77,361,35,"Posto de Gasolina",0.4 },
	-- { -91.29,6422.54,30.65,361,35,"Posto de Gasolina",0.4 },
	-- { -1797.22,800.56,137.66,361,35,"Posto de Gasolina",0.4 },
	-- { -1435.5,-284.68,45.41,361,35,"Posto de Gasolina",0.4 },
	-- { -732.64,-939.32,18.22,361,35,"Posto de Gasolina",0.4 },
	-- { -524.92,-1216.15,17.33,361,35,"Posto de Gasolina",0.4 },
	-- { -69.45,-1758.01,28.55,361,35,"Posto de Gasolina",0.4 },
	-- Skinshop (Framework)
	-- { 86.06,-1391.64,29.23,366,62,"Loja de Roupas",0.5 },
	-- { -719.94,-158.18,37.0,366,62,"Loja de Roupas",0.5 },
	-- { -152.79,-306.79,38.67,366,62,"Loja de Roupas",0.5 },
	-- { -816.39,-1081.22,11.12,366,62,"Loja de Roupas",0.5 },
	-- { -1206.51,-781.5,17.12,366,62,"Loja de Roupas",0.5 },
	-- { -1458.26,-229.79,49.2,366,62,"Loja de Roupas",0.5 },
	-- { -2.41,6518.29,31.48,366,62,"Loja de Roupas",0.5 },
	-- { 1682.59,4819.98,42.04,366,62,"Loja de Roupas",0.5 },
	-- { 129.46,-205.18,54.51,366,62,"Loja de Roupas",0.5 },
	-- { 618.49,2745.54,42.01,366,62,"Loja de Roupas",0.5 },
	-- { 1197.93,2698.21,37.96,366,62,"Loja de Roupas",0.5 },
	-- { -3165.74,1061.29,20.84,366,62,"Loja de Roupas",0.5 },
	-- { -1093.76,2703.99,19.04,366,62,"Loja de Roupas",0.5 },
	-- { 414.86,-807.57,29.34,366,62,"Loja de Roupas",0.5 },
	-- { -1117.26,-1438.74,5.11,366,62,"Loja de Roupas",0.5 },
	-- -- Ammunation (Framework)
	-- { 1702.78,3748.82,34.05,76,6,"Loja de Armas",0.4 },
	-- { 240.06,-43.74,69.71,76,6,"Loja de Armas",0.4 },
	-- { 843.95,-1020.43,27.53,76,6,"Loja de Armas",0.4 },
	-- { -322.19,6072.86,31.27,76,6,"Loja de Armas",0.4 },
	-- { -664.03,-949.22,21.53,76,6,"Loja de Armas",0.4 },
	-- { -1318.83,-389.19,36.43,76,6,"Loja de Armas",0.4 },
	-- { -1110.11,2687.5,18.62,76,6,"Loja de Armas",0.4 },
	-- { 2569.23,309.46,108.46,76,6,"Loja de Armas",0.4 },
	-- { -3159.91,1080.64,20.69,76,6,"Loja de Armas",0.4 },
	-- { 15.42,-1120.47,28.81,76,6,"Loja de Armas",0.4 },
	-- { 811.81,-2145.58,29.34,76,6,"Loja de Armas",0.4 },
	-- -- Barbershop (Framework)
	-- { -815.12,-184.15,37.57,71,62,"Barbearia",0.5 },
	-- { 138.13,-1706.46,29.3,71,62,"Barbearia",0.5 },
	-- { -1280.92,-1117.07,7.0,71,62,"Barbearia",0.5 },
	-- { 1930.54,3732.06,32.85,71,62,"Barbearia",0.5 },
	-- { 1214.2,-473.18,66.21,71,62,"Barbearia",0.5 },
	-- { -33.61,-154.52,57.08,71,62,"Barbearia",0.5 },
	-- { -276.65,6226.76,31.7,71,62,"Barbearia",0.5 },
	-- -- Tattooshop (Framework)
	-- { 1322.93,-1652.29,52.27,75,13,"Loja de Tatuagem",0.5 },
	-- { -1154.42,-1425.9,4.95,75,13,"Loja de Tatuagem",0.5 },
	-- { 322.84,180.16,103.58,75,13,"Loja de Tatuagem",0.5 },
	-- { -3169.62,1075.8,20.83,75,13,"Loja de Tatuagem",0.5 },
	-- { 1864.07,3747.9,33.03,75,13,"Loja de Tatuagem",0.5 },
	-- { -293.57,6199.85,31.48,75,13,"Loja de Tatuagem",0.5 },
	-- -- Garages (Framework)
	-- { 55.43,-876.19,30.66,357,3,"Garagem",0.6 },
    -- { 598.04,2741.27,42.07,357,3,"Garagem",0.6 },
    -- { -136.36,6357.03,31.49,357,3,"Garagem",0.6 },
    -- { 596.40,90.65,93.12,357,3,"Garagem",0.6 },
    -- { -340.76,265.97,85.67,357,3,"Garagem",0.6 },
    -- { -2030.01,-465.97,11.60,357,3,"Garagem",0.6 },
    -- { -1184.92,-1510.00,4.64,357,3,"Garagem",0.6 },
    -- { -348.88,-874.02,31.31,357,3,"Garagem",0.6 },
    -- { 1035.89,-763.89,57.99,357,3,"Garagem",0.6 },
    -- { -796.63,-2022.77,9.16,357,3,"Garagem",0.6 },
    -- { 453.27,-1146.76,29.52,357,3,"Garagem",0.6 },
    -- { -1159.48,-739.32,19.89,357,3,"Garagem",0.6 },
    -- { 1725.21,4711.77,42.11,357,3,"Garagem",0.6 },
    -- { 1624.05,3566.14,35.15,357,3,"Garagem",0.6 },
	-- -- Boats (Framework)
	-- { -1728.06,-1050.69,1.71,266,62,"Embarcações",0.5 },
	-- { 1966.36,3975.86,31.51,266,62,"Embarcações",0.5 },
	-- { -776.72,-1495.02,2.29,266,62,"Embarcações",0.5 },
	-- { -893.97,5687.78,3.29,266,62,"Embarcações",0.5 },
	-- { 4952.76,-5163.6,-0.3,266,62,"Embarcações",0.5 },
	-- Works (Framework)
	-- { -841.54,5401.27,34.61,285,62,"EMPREGO | Lenhador",0.5 },
	-- { 82.54,-1553.28,29.59,318,62,"EMPREGO | Lixeiro",0.6 },
	-- { 287.36,2843.6,44.7,318,62,"EMPREGO | Lixeiro",0.6 },
	-- { -413.97,6171.58,31.48,318,62,"EMPREGO | Lixeiro",0.6 },
	-- { 2953.93,2787.49,41.5,617,62,"EMPREGO | Minerador",0.6 },
	-- { 2416.4,4993.75,46.22,76,62,"EMPREGO | Agricultor",0.4 },
	-- { 454.73,-600.83,28.56,513,62,"EMPREGO | Motorista",0.5 },
	-- { -772.61,5602.2,33.73,141,62,"EMPREGO | Caçador",0.7 },
	-- { 1121.08,-645.77,56.82,88,2,"EMPREGO | Faxineiro",0.5 },
	-- { -1275.62,-1139.63,6.79,88,2,"EMPREGO | Jardineiro",0.5 },
	-- { -231.62,-852.52,30.68,67,62,"EMPREGO | Transportador",0.5 },
	-- { 1529.56,3778.81,34.51,68,0,"EMPREGO | Pescador",0.6 },
	-- { 1239.87,-3257.2,7.09,67,62,"EMPREGO | Caminhoneiro",0.5 },
	-- { -1745.57,-205.19,57.37,89,62,"EMPREGO | Cemitério",0.5 },
	-- { 895.21,-179.7,74.7,56,5,"EMPREGO | Taxista",0.5 },  
	-- {-440.63,-2795.98,7.3,67,62,"EMPREGO | Carteiro",0.5 },
	-- { 2310.44,4884.82,41.8,636,4,"EMPREGO | Leiteiro",0.6 },
	-- { 2251.68,5155.38,57.88,479,4,"EMPREGO | Tratorista",0.6 },
	-- { 282.8,6790.96,15.69,78,21,"EMPREGO | Mergulhador",0.6 },
	-- { 409.03,-1638.92,29.28,357,9,"EMPREGO | Rebocador (Impound)",0.6 },
	-- { -428.56,-1728.33,19.79,467,11,"Venda Reciclagem",0.6 },
	-- { 180.07,2793.29,45.65,467,11,"Venda Reciclagem",0.6 },
	-- { -195.42,6264.62,31.49,467,11,"Venda Reciclagem",0.6 },
	-- { 1043.13,698.81,158.84,88,2,"Venda de Frutas",0.5 },
	-- { 1792.32,4594.69,37.68,88,2,"Venda de Frutas",0.5 }, 
	-- Emergency (Framework)
	--{ 1313.64,-723.49,65.5,60,3,"PMERJ",0.6 },
	-- { -318.42,-1050.4,76.89,60,2,"PCERJ / CORE",0.6 },
	-- { 2617.42,5343.67,58.54,60,5,"PRF",0.6 },
	-- --{ 2541.06,-385.09,92.99,60,1,"BOPE",0.6 },
	-- { -1731.85,-734.2,12.1,60,0,"RECOM",0.6 },
	-- { -790.12,-2678.37,14.12,60,22,"CHOQUE",0.6 },
	-- --{ 4050.91,-4653.37,4.18,60,25,"EB",0.6 },
	-- { -473.3,-339.87,35.2,153,1,"Hospital",0.6 },
	-- --{ -1128.65,-1712.26,5.04,106,49,"Bombeiro",0.5 },
	-- { 876.79, -2115.02, 30.46,643,33,"Mecânica East Customs",0.7 },
	-- { 2747.94,3472.82,55.67,643,1,"Mecânica Red Lines",0.7 },
	-- -- Pharmacy (Framework)
	-- { 378.52,-829.38,29.28,403,5,"Farmácia", 0.7 },
	-- -- Restaurants (Framework)
	-- --{ -581.02,-1065.81,22.34,93,34,"Cat Cafe",0.5 },
	-- --{ -160.98,288.57,97.83,93,0,"Japanese",0.5 },
	-- -- Others (Framework)
	-- { 45.79,-1748.82,29.6,78,11,"Megamall",0.5 },
	-- { 562.36,2741.56,42.87,273,11,"Animal Park",0.5 },
	-- { -1204.85,-1564.27,4.6,126,13,"Academia",0.6 },
	-- { 1133.99,-471.05,66.71,459,2,"Loja de Eletrônicos",0.6 },
	-- { -623.84,-234.35,38.05,617,53,"Joalheria",0.5 },
	-- { -1082.22,-247.54,37.77,439,73,"Life Invader",0.6 },
	-- { -550.11,-195.69,38.22,267,5,"Prefeitura",0.5 },
	-- { -326.33,-1369.76,32.39,523,0,"Concessionária",0.5 },
	-- --{ -1274.36,-3385.09,13.93,184,7,"Estúdio de Fotos",0.5 },
	-- --{ -1653.53,-3144.8,13.99,184,7,"Estúdio de Fotos",0.5 },
	-- { -364.41,-249.27,36.08,351,16,"Central de Empregos", 0.9 },
	-- { -1445.56,-541.46,34.74,475,0,"Hotel",0.6 },
	-- { 918.69,50.33,80.9,617,53,"Casino Resort",0.6 },
	-- --{ -704.05,-1667.6,25.0,498,4,"Auto Escola",0.6 },
	-- { 1689.49,2602.64,45.56,307,1,"Área Aérea", 0.7 },
	-- { 652.12,4373.58,95.12,141,52,"Área de Caça", 0.7 },
    -- { 1331.24,4052.22,32.96,68,29,"Área de Pesca", 0.7 },
    -- --{ 767.19,7192.03,-30.16,409,0,"Área de Mergulho", 0.6 },
	-- -- Favelas (Framework)
	-- { 1140.59,-171.78,63.54,84,1,"Zona de Risco",0.6 },
	-- { 1874.59,50.91,188.95,84,1,"Zona de Risco",0.6 },
	-- { 1946.56,366.9,173.45,84,1,"Zona de Risco",0.6 },
	-- { 2377.82,336.94,181.99,84,1,"Zona de Risco",0.6 },
	-- { 1531.52,1472.91,111.17,84,1,"Zona de Risco",0.6 },
	-- --{ -2496.1,2530.61,20.02,84,1,"Zona de Risco",0.6 },
	-- { 1808.3,-2366.2,152.95,84,1,"Zona de Risco",0.6 },
	-- { -2200.14,-262.52,53.8,84,1,"Zona de Risco",0.6 },
	-- { 1922.59,6392.29,76.13,84,1,"Zona de Risco",0.6 },
	-- { 2148.04,3894.88,37.25,84,1,"Zona de Risco",0.6 },
	-- { 2228.67,3694.73,41.38,84,1,"Zona de Risco",0.6 },
	-- { 582.06,2548.88,60.88,84,1,"Zona de Risco",0.6 },
	-- { 891.45,2043.87,64.72,84,1,"Zona de Risco",0.6 },
	-- { 2199.64,2653.56,68.38,84,1,"Zona de Risco",0.6 },
	-- { 1337.13,-312.44,142.11,84,1,"Zona de Risco",0.6 },
	-- --Mansões
	-- {176.79,1690.51,227.66,439,5,"Mansão à venda",0.8 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALPHAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Alphas = {
    -- Air Defense
    { vec3(1689.49, 2602.64, 45.56), 200, 1, 300.0 },
    -- Ilegal
    { vec3(-472.08, 6287.5, 14.63), 200, 1, 20.0 },
    -- Fishing
    { vec3(1331.24, 4052.22, 32.96), 200, 29, 200.0 },
    -- Hunter
    { vec3(652.12, 4373.58, 95.12), 200, 52, 200.0 },
    -- Scuba
    { vec3(767.19, 7192.03, -30.16), 200, 0, 100.0 },
    -- Speed Cameras
    --{ vec3(348.72, -1921.64, 24.2), 200, 76, 15.0 },
    --{ vec3(945.37, -1935.09, 30.46), 200, 76, 15.0 },
    --{ vec3(1280.27, -1504.25, 40.05), 200, 76, 15.0 },
    --{ vec3(145.67, -1614.32, 28.83), 200, 76, 15.0 },
    --{ vec3(310.92, 155.6, 103.32), 200, 76, 15.0 },
    --{ vec3(-441.11, 244.36, 82.58), 200, 76, 15.0 },
    --{ vec3(-2690.74, -39.01, 15.3), 200, 76, 15.0 },
    --{ vec3(-1468.19, -104.2, 50.36), 200, 76, 15.0 },
    --{ vec3(774.04, -743.38, 26.96), 200, 76, 15.0 },
    --{ vec3(-638.7, -837.08, 24.42), 200, 76, 15.0 },
    --{ vec3(-632.22, -373.37, 34.31), 200, 76, 15.0 },
    --{ vec3(-227.22, -1003.37, 28.83), 200, 76, 15.0 },
    --{ vec3(154.36, -1019.31, 28.88), 200, 76, 15.0 },
    --{ vec3(73.64, -164.13, 54.61), 200, 76, 15.0 },
    --{ vec3(394.65, -592.25, 28.27), 200, 76, 15.0 },
    --{ vec3(-521.92, -1770.01, 21.42), 200, 76, 15.0 },
    --{ vec3(2578.46, 4245.33, 41.8), 200, 76, 15.0 },
    --{ vec3(1578.62, -980.07, 60.09), 200, 76, 15.0 },
    --{ vec3(2134.19, -572.18, 95.1), 200, 76, 15.0 },
    --{ vec3(714.88, 6511.94, 27.41), 200, 76, 15.0 },
    --{ vec3(-2658.32, 2632.84, 16.68), 200, 76, 15.0 },
    --{ vec3(2559.33, 5399.29, 44.21), 200, 76, 15.0 },
    --{ vec3(2654.56, 4938.91, 44.4), 200, 76, 15.0 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISLAND
-----------------------------------------------------------------------------------------------------------------------------------------
local Island = {
	"h4_islandairstrip",
	"h4_islandairstrip_props",
	"h4_islandx_mansion",
	"h4_islandx_mansion_props",
	"h4_islandx_props",
	"h4_islandxdock",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxtower",
	"h4_islandx_maindock",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_IslandX_Mansion_Vault",
	"h4_islandairstrip_propsb",
	"h4_beach",
	"h4_beach_props",
	"h4_beach_bar_props",
	"h4_islandx_barrack_props",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_props",
	"h4_islandx_Mansion_Office",
	"h4_islandx_Mansion_LockUp_01",
	"h4_islandx_Mansion_LockUp_02",
	"h4_islandx_Mansion_LockUp_03",
	"h4_islandairstrip_hangar_props",
	"h4_IslandX_Mansion_B",
	"h4_islandairstrip_doorsclosed",
	"h4_Underwater_Gate_Closed",
	"h4_mansion_gate_closed",
	"h4_aa_guns",
	"h4_IslandX_Mansion_GuardFence",
	"h4_IslandX_Mansion_Entrance_Fence",
	"h4_IslandX_Mansion_B_Side_Fence",
	"h4_IslandX_Mansion_Lights",
	"h4_islandxcanal_props",
	"h4_beach_props_party",
	"h4_islandX_Terrain_props_06_a",
	"h4_islandX_Terrain_props_06_b",
	"h4_islandX_Terrain_props_06_c",
	"h4_islandX_Terrain_props_05_a",
	"h4_islandX_Terrain_props_05_b",
	"h4_islandX_Terrain_props_05_c",
	"h4_islandX_Terrain_props_05_d",
	"h4_islandX_Terrain_props_05_e",
	"h4_islandX_Terrain_props_05_f",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_06",
	"h4_ne_ipl_00",
	"h4_ne_ipl_01",
	"h4_ne_ipl_02",
	"h4_ne_ipl_03",
	"h4_ne_ipl_04",
	"h4_ne_ipl_05",
	"h4_ne_ipl_06",
	"h4_ne_ipl_07",
	"h4_ne_ipl_08",
	"h4_ne_ipl_09",
	"h4_nw_ipl_00",
	"h4_nw_ipl_01",
	"h4_nw_ipl_02",
	"h4_nw_ipl_03",
	"h4_nw_ipl_04",
	"h4_nw_ipl_05",
	"h4_nw_ipl_06",
	"h4_nw_ipl_07",
	"h4_nw_ipl_08",
	"h4_nw_ipl_09",
	"h4_se_ipl_00",
	"h4_se_ipl_01",
	"h4_se_ipl_02",
	"h4_se_ipl_03",
	"h4_se_ipl_04",
	"h4_se_ipl_05",
	"h4_se_ipl_06",
	"h4_se_ipl_07",
	"h4_se_ipl_08",
	"h4_se_ipl_09",
	"h4_sw_ipl_00",
	"h4_sw_ipl_01",
	"h4_sw_ipl_02",
	"h4_sw_ipl_03",
	"h4_sw_ipl_04",
	"h4_sw_ipl_05",
	"h4_sw_ipl_06",
	"h4_sw_ipl_07",
	"h4_sw_ipl_08",
	"h4_sw_ipl_09",
	"h4_islandx_mansion",
	"h4_islandxtower_veg",
	"h4_islandx_sea_mines",
	"h4_islandx",
	"h4_islandx_barrack_hatch",
	"h4_islandxdock_water_hatch",
	"h4_beach_party"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- IPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
local InfoList = {
	{
		["Props"] = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		["Coords"] = vec3(-1150.70,-1520.70,10.60)
	},{
		["Props"] = {
			"csr_beforeMission",
			"csr_inMission"
		},
		["Coords"] = vec3(-47.10,-1115.30,26.50)
	},{
		["Props"] = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		["Coords"] = vec3(-802.30,175.00,72.80)
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()

		for Number = 1,22 do
			if Number ~= 14 and Number ~= 16 then
				HideHudComponentThisFrame(Number)
			end
		end

		InvalidateIdleCam()
		InvalidateVehicleIdleCam()

		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
		BlockWeaponWheelThisFrame()
		DisableControlAction(0,37,true)
		DisableControlAction(0,204,true)
		DisableControlAction(0,211,true)
		DisableControlAction(0,349,true)
		DisableControlAction(0,192,true)
		DisableControlAction(0,157,true)
		DisableControlAction(0,158,true)
		DisableControlAction(0,159,true)
		DisableControlAction(0,160,true)
		DisableControlAction(0,161,true)
		DisableControlAction(0,162,true)
		DisableControlAction(0,163,true)
		DisableControlAction(0,164,true)
		DisableControlAction(0,165,true)

		SetVehicleDensityMultiplierThisFrame(TheNpcControl)
		SetRandomVehicleDensityMultiplierThisFrame(TheNpcControl)
		SetParkedVehicleDensityMultiplierThisFrame(TheNpcControl)
		SetScenarioPedDensityMultiplierThisFrame(TheNpcControl, TheNpcControl)
		SetPedDensityMultiplierThisFrame(TheNpcControl)

		if IsPedArmed(Ped,6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
		end

		if IsPedUsingActionMode(Ped) then
			SetPedUsingActionMode(Ped,-1,-1,1)
		end

		if IsPedInAnyVehicle(Ped) then
			DisableControlAction(0,345,true)
		end

		SetPauseMenuActive(false)
		DisablePlayerVehicleRewards(Pid)

		if InfiniteAmmoClip then
			SetPedInfiniteAmmoClip(Ped, true)
			SetPedInfiniteAmmo(Ped, true)
		else
			SetPedInfiniteAmmoClip(Ped, false)
			SetPedInfiniteAmmo(Ped, false)
		end

		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		if IsPlayerWantedLevelGreater(Pid,0) then
			ClearPlayerWantedLevel(Pid)
		end

		if not DisableTargetMode then
			SetPlayerLockonRangeOverride(Pid, 0.0)
		end

		SetArtificialLightsState(GlobalState["Blackout"])
		SetArtificialLightsStateAffectsVehicles(false)

		SetWeatherTypeNow(GlobalState["Weather"])
		SetWeatherTypePersist(GlobalState["Weather"])
		SetWeatherTypeNowPersist(GlobalState["Weather"])

		if LocalPlayer["state"]["Active"] then
			NetworkOverrideClockTime(GlobalState["Hours"], GlobalState["Minutes"], 00)
		else
			NetworkOverrideClockTime(12, 00, 00)
		end

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			local Distance = #(Coords - vec3(253.73, 224.19, 101.91))
			if Distance <= 1.5 then
				TimeDistance = 1

				if IsControlJustPressed(1, 38) then
					local Handle, Object = FindFirstObject()
					local Finished = false

					repeat
						local Heading = GetEntityHeading(Object)
						local CoordsObj = GetEntityCoords(Object)
						local DistanceObjs = #(CoordsObj - Coords)

						if DistanceObjs < 3.0 and GetEntityModel(Object) == 961976194 then
							if Heading > 150.0 then
								SetEntityHeading(Object, 0.0)
							else
								SetEntityHeading(Object, 160.0)
							end

							FreezeEntityPosition(Object, true)
							Finished = true
						end

						Finished, Object = FindNextObject(Handle)
					until not Finished

					EndFindObject(Handle)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onClientResourceStart",function(Resource)
	if (GetCurrentResourceName() ~= Resource) then
		return
	end

	SetMapZoomDataLevel(0,0.96,0.9,0.08,0.0,0.0)
	SetMapZoomDataLevel(1,1.6,0.9,0.08,0.0,0.0)
	SetMapZoomDataLevel(2,8.6,0.9,0.08,0.0,0.0)
	SetMapZoomDataLevel(3,12.3,0.9,0.08,0.0,0.0)
	SetMapZoomDataLevel(4,22.3,0.9,0.08,0.0,0.0)

	for _,v in pairs(InfoList) do
		local Interior = GetInteriorAtCoords(v["Coords"])
		LoadInterior(Interior)

		if v["Props"] then
			for _,Index in pairs(v["Props"]) do
				EnableInteriorProp(Interior,Index)
			end
		end

		RefreshInterior(Interior)
	end

	-- for Number = 1,#Alphas do
	-- 	local Blip = AddBlipForRadius(Alphas[Number][1]["x"],Alphas[Number][1]["y"],Alphas[Number][1]["z"],Alphas[Number][4])
	-- 	SetBlipAlpha(Blip,Alphas[Number][2])
	-- 	SetBlipColour(Blip,Alphas[Number][3])
	-- end

	-- for Number = 1,#Blips do
	-- 	local Blip = AddBlipForCoord(Blips[Number][1],Blips[Number][2],Blips[Number][3])
	-- 	SetBlipSprite(Blip,Blips[Number][4])
	-- 	SetBlipDisplay(Blip,4)
	-- 	SetBlipAsShortRange(Blip,true)
	-- 	SetBlipColour(Blip,Blips[Number][5])
	-- 	SetBlipScale(Blip,Blips[Number][7])
	-- 	BeginTextCommandSetBlipName("STRING")
	-- 	AddTextComponentString(Blips[Number][6])
	-- 	EndTextCommandSetBlipName(Blip)
	-- end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		if #(Coords - vec3(4840.57,-5174.42,2.0)) <= 2000 then
			if not IsIplActive("h4_islandairstrip") then
				for _,v in pairs(Island) do
					RequestIpl(v)
				end

				SetIslandHopperEnabled("HeistIsland",true)
				SetAiGlobalPathNodesType(1)
				SetDeepOceanScaler(0.0)
				LoadGlobalWaterType(1)
			end
		else
			if IsIplActive("h4_islandairstrip") then
				for _,v in pairs(Island) do
					RemoveIpl(v)
				end

				SetIslandHopperEnabled("HeistIsland",false)
				SetAiGlobalPathNodesType(0)
				SetDeepOceanScaler(1.0)
				LoadGlobalWaterType(0)
			end
		end

		for _,Entity in pairs(GetGamePool("CPed")) do
			if (NetworkGetEntityOwner(Entity) == -1 or NetworkGetEntityOwner(Entity) == PlayerId()) and GetPedArmour(Entity) <= 0 and not NetworkGetEntityIsNetworked(Entity) then
				if IsPedInAnyVehicle(Entity) then
					local Vehicle = GetVehiclePedIsUsing(Entity)
					if NetworkGetEntityIsNetworked(Vehicle) then
						TriggerServerEvent("garages:Delete",NetworkGetNetworkIdFromEntity(Vehicle),GetVehicleNumberPlateText(Vehicle))
					else
						DeleteEntity(Vehicle)
					end
				else
					DeleteEntity(Entity)
				end
			end
		end

		for _,Vehicle in pairs(GetGamePool("CVehicle")) do
			if (NetworkGetEntityOwner(Vehicle) == -1 or NetworkGetEntityOwner(Vehicle) == PlayerId()) and not NetworkGetEntityIsNetworked(Vehicle) and GetVehicleNumberPlateText(Vehicle) ~= "PDMSPORT" then
				DeleteEntity(Vehicle)
			end
		end

		for Number = 1,121 do
			EnableDispatchService(Number,false)
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRAPPEL
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyHeli(Ped) then
			TimeDistance = 1

			local Vehicle = GetVehiclePedIsUsing(Ped)
			if IsControlJustPressed(1,154) and not IsAnyPedRappellingFromHeli(Vehicle) and (GetPedInVehicleSeat(Vehicle,1) == Ped or GetPedInVehicleSeat(Vehicle,2) == Ped) then
				TaskRappelFromHeli(Ped,1)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAYO PERICO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        SetRadarAsExteriorThisFrame()
        SetRadarAsInteriorThisFrame("h4_fake_islandx", vec(4700.0, -5145.0), 0, 0)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLOR
-----------------------------------------------------------------------------------------------------------------------------------------
local Color = {
	{ 103.01, -1938.72, 30.80, 148, 0, 211, 50.0, 1.0}, 	-- BALAS
	{ 982.03, -112.44, 74.14, 0,0,255, 50.0, 1.0}, 			-- MOTOCLUB
	{ 336.98, -2042.08, 31.30, 255, 255, 0, 50.0, 1.0}, 	-- VAGOS
	{ -170.58, -1585.34, 34.88, 0, 128, 0, 50.0, 1.0}, 		-- FAMILIES
	{ 191.14, -926.19, 50.68, 65, 105, 225, 75.0, 0.5}, 	-- PRAÇA
	{ 1290.98,-1731.24,69.72, 21, 0, 211, 50.0, 1.0}, 		-- GUETO
	{ -1468.41, 169.88, 54.55, 148, 0, 211, 50.0, 1.0},  	-- PLAY BOY
	{ -1464.11, 120.56, 53.01, 255, 0, 0, 50.0, 1.0},  		-- PLAY BOY
	{ -1456.54, 212.32, 57.86, 50, 205, 50, 50.0, 1.0},  	-- PLAY BOY
	{  284.47, 146.63, 115.47, 148, 0, 211, 10.0, 1.0},		-- VINEWOOD
	{ 346.04, 160.59, 115.27, 0, 128, 0, 10.0, 1.0},		-- VINEWOOD
	{ 315.46,171.47,114.04, 255, 255, 0, 10.0, 1.0},		-- VINEWOOD
	{ 273.41,186.88,104.76, 0, 128, 0, 10.0, 1.0},			-- VINEWOOD
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for k,v in ipairs(Color) do
			local x,y,z,n,g,s,range,intensity = table.unpack(v)
			if GetClockHours() > 20 or GetClockHours() < 6 then
				DrawLightWithRangeAndShadow(x, y, z, n, g, s, range, intensity, 0.1)
			end
		end
	end
end)
------------------------------------------------------------------------------------------
-- CLEARAREA
------------------------------------------------------------------------------------------
local ClearArea = {
    { vector3(0.0, 0.0, 0.0), Radius = 0.0 }
}

CreateThread(function()
    while true do
        Wait(0)
        for _, area in ipairs(ClearArea) do
            local pos = area[1]
            ClearAreaOfPeds(pos.x, pos.y, pos.z, area.Radius, 1)
            ClearAreaOfVehicles(pos.x, pos.y, pos.z, area.Radius, false, false, false, false, false)
        end
    end
end)