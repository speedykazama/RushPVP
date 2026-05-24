-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawned = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NPCS
-----------------------------------------------------------------------------------------------------------------------------------------
local NPCs = {
    { -- Porte de Armas
        Distance = 50,
        Coords = { 12.02,-1106.94,29.79,340.16 },
        Model = "s_m_y_marine_03",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
	{ -- Minerman
        Distance = 50,
        Coords = { 466.3,-735.75,27.36,87.88 },
        Model = "s_m_y_construct_01",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
	{ 
        Distance = 50,
        Coords = { 2964.35,2753.16,43.3,198.43 },
        Model = "s_m_y_construct_01",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Lumberman
        Distance = 50,
        Coords = { 2433.45,5013.46,46.99,314.65 },
        Model = "a_m_m_hillbilly_01",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Transporter
        Distance = 50,
        Coords = { -228.22,-843.52,30.68,161.58 },
        Model = "ig_casey",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Garbageman
        Distance = 50,
        Coords = { 82.98,-1553.55,29.59,51.03 },
        Model = "s_m_y_garbage",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Hunter
        Distance = 50,
        Coords = { -776.01,5603.03,33.73,257.96 },
        Model = "ig_hunter",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Fruitman
        Distance = 50,
        Coords = { 1997.95,5111.06,43.0,127.56 },
        Model = "a_m_m_farmer_01",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Impound
        Distance = 50,
        Coords = { 407.35,-1624.76,29.28,229.61 },
        Model = "g_m_m_armboss_01",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Fisherman
        Distance = 50,
        Coords = { 1522.88,3783.63,34.47,218.27 },
        Model = "a_f_y_eastsa_03",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Trucker
        Distance = 50,
        Coords = { 1239.87,-3257.2,7.09,274.97 },
        Model = "s_m_m_trucker_01",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Bus
        Distance = 50,
        Coords = { 442.01,-633.87,28.63,263.63 },
        Model = "a_m_y_business_02",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Taxi
        Distance = 50,
        Coords = { 905.53,-154.66,74.22,144.57 },
        Model = "a_m_y_business_02",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Cleaner
        Distance = 50,
        Coords = { -1275.5, -1139.56, 6.79, 113.39 },
        Model = "s_m_m_gardener_01",
        anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
    },  
	{ -- PostOp
        Distance = 50,
        Coords = { -424.36, -2789.78, 6.52, 328.82 },
        Model = "s_m_m_gentransport",
        anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
    },
    { -- PostOp
        Distance = 50,
        Coords = { -444.92, -2802.09, 7.3, 45.36 },
        Model = "s_m_m_gentransport",
        anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
    },
    { -- Milkman
        Distance = 50,
        Coords = { 2313.76,4888.19,41.8,53.86 },
        Model = "a_m_m_hillbilly_01",
        anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    },
    { -- Tractor
        Distance = 20,
        Coords = { 2251.68,5155.38,57.88,232.45 },
        Model = "a_m_m_farmer_01",
        anim = { "misscarstealfinale","packer_idle_1_trevor" }
    },
    { -- Diver
        Distance = 50,
        Coords = { 281.53,6789.32,15.86,260.79 },
        Model = "hc_gunman",
        anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
    },
    { -- Cemitery
        Distance = 100,
        Coords = { -1745.92,-204.83,57.39,320.32 },
        Model = "g_m_m_armboss_01",
        anim = { "timetable@trevor@smoking_meth@base","base" }
    },
	{ -- Prefeitura (Spawn)
		Distance = 50,
		Coords = { 728.75,1299.79,360.3,90.71 },
		Model = "ig_barry",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lanches (Spawn)
		Distance = 50,
		Coords = { 734.21,1299.8,360.3,178.59 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado (Spawn)
		Distance = 50,
		Coords = { 780.26,1300.34,360.3,87.88 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Maonegra
		Distance = 10,
		Coords = { 1278.45,68.77,98.12,22.68 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Bairro13
		Distance = 10,
		Coords = { -2239.5,-163.39,91.44,232.45 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Setor13
		Distance = 10,
		Coords = { 895.43,1984.04,81.5,331.66 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Grota
		Distance = 10,
		Coords = { 1369.43,-208.35,158.15,119.06 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Chernobyl
		Distance = 10,
		Coords = { 1863.06,-2245.67,171.75,85.04 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Crips
		Distance = 10,
		Coords = { 2311.42,2644.63,61.62,204.1 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Distrito
		Distance = 10,
		Coords = { 1902.85,0.86,188.89,45.36 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Dz7
		Distance = 10,
		Coords = { 2053.42,6480.7,110.45,294.81 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Labirinto
		Distance = 10,
		Coords = { 2219.82,3956.14,37.42,303.31 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- P77
		Distance = 10,
		Coords = { 1971.78,419.23,175.44,11.34 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Favela6
		Distance = 10,
		Coords = { -2397.61,2617.59,27.57,357.17 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Milicia
		Distance = 10,
		Coords = { 1552.21,1463.83,111.14,269.3 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Medellín
		Distance = 10,
		Coords = { 2236.45,3557.93,68.78,260.79 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mare
		Distance = 10,
		Coords = { 2356.78,484.73,202.01,158.75 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Crateva
		Distance = 10,
		Coords = { 619.86,2556.37,73.36,14.18 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Digital Den
		Distance = 50,
		Coords = { 1132.54,-474.31,66.71,343.0 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
	},{ -- Prison
		Distance = 50,
		Coords = { 1690.5, 2529.67, 45.56, 187.09 },
		Model = "s_f_y_cop_01",
		anim = { "amb@lo_res_idles@", "world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- GRIME (work)
		Distance = 100,
		Coords = { 68.96,127.53,79.21,164.41 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 100,
		Coords = { 120.8,-3021.49,7.04,260.79 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central
		Distance = 50,
		Coords = { 46.65,-1749.7,29.62,51.03 },
		Model = "ig_cletus",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	-- { -- Mercado Central
	-- 	Distance = 50,
	-- 	Coords = { 2747.31,3473.07,55.67,249.45 },  
	-- 	Model = "ig_cletus",
	-- 	anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	-- },
	{ -- Jardineiro
		Distance = 50,
		Coords = { -1275.5, -1139.56, 6.79, 113.39 },
		Model = "s_m_m_gardener_01",
		anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
	},
	{ -- Carteiro
		Distance = 50,
		Coords = { -424.36, -2789.78, 6.52, 328.82 },
		Model = "s_m_m_gentransport",
		anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
	},
	{ -- Carteiro
		Distance = 50,
		Coords = { -444.92, -2802.09, 7.3, 45.36 },
		Model = "s_m_m_gentransport",
		anim = { "anim@heists@heist_corona@single_team", "single_team_loop_boss" }
	},
	{ -- Lester
		Distance = 10,
		Coords = { 1272.26, -1711.54, 54.76, 34.02 },
		Model = "ig_lestercrest",
		anim = { "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { 1692.28,3760.94,34.69,229.61 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { 253.79,-50.5,69.94,68.04 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { 842.41,-1035.28,28.19,0.0 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { -331.62,6084.93,31.46,226.78 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { -662.29,-933.62,21.82,181.42 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { -1304.17,-394.62,36.7,73.71 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { -1118.95,2699.73,18.55,223.94 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { 2567.98,292.65,108.73,0.0 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { -3173.51,1088.38,20.84,249.45 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { 22.59,-1105.54,29.79,155.91 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammunation (Framework)
		Distance = 12,
		Coords = { 810.22,-2158.99,29.62,0.0 },
		Model = "ig_dale" ,
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},

	{ -- Departament (Framework) -1837.52,-1191.5,14.31,249.45
		Distance = 10,
		Coords = { 24.49,-1346.08,29.49,272.13 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework) -1837.52,-1191.5,14.31,249.45
		Distance = 50,
		Coords = { -1837.52,-1191.5,14.31,249.45 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { 2556.04,380.89,108.61,0.0 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { 1164.82,-323.63,69.2,99.22 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { -706.16,-914.55,19.21,90.71 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { -47.39,-1758.63,29.42,51.03 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { 372.86,327.53,103.56,257.96 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 6,
		Coords = { -3243.38,1000.11,12.82,0.0 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 6,
		Coords = { 1728.39,6416.21,35.03,246.62 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 6,
		Coords = { 549.2,2670.22,42.16,96.38 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 6,
		Coords = { 1959.54,3741.01,32.33,303.31 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 6,
		Coords = { 2677.07,3279.95,55.23,334.49 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 6,
		Coords = { 1697.35,4923.46,42.06,328.82 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 6,
		Coords = { -1819.55,793.51,138.08,133.23 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { 1392.03,3606.1,34.98,204.1 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { -2966.41,391.59,15.05,85.04 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { -3040.04,584.22,7.9,19.85 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { 1134.33,-983.09,46.4,277.8 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { 1165.26,2710.79,38.15,178.59 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { -1486.77,-377.56,40.15,133.23 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { -1221.42,-907.91,12.32,31.19 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)
		Distance = 10,
		Coords = { 812.46,-781.18,26.17,269.3 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Animal Park (Center)
		Distance = 15,
		Coords = { 562.95,2752.9,42.87,184.26 },
		Model = "a_f_y_eastsa_03",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Blackout
		Distance = 50,
		Coords = { 2101.89, 2323.65, 94.27, 272.13 },
		Model = "s_m_y_construct_01",
		anim = { "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop" }
	},
	{ -- Cassino (Center)
		Distance = 25,
		Coords = { 990.4,40.54,71.26,93.55 },
		Model = "s_f_y_casino_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Cassino (Center)
		Distance = 25,
		Coords = { 991.65,31.71,71.46,36.86 },
		Model = "s_f_y_casino_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Cassino (Center)
		Distance = 25,
		Coords = { 990.41,30.06,71.46,87.88 },
		Model = "s_f_y_casino_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Concessionária (Center)
		Distance = 25,
		Coords = { -339.48,-1370.03,31.86,272.13 },
		Model = "ig_siemonyetarian",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pharmacy Store
		Distance = 100,
		Coords = { 375.28,-829.27,29.28,274.97 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Premium (Center)
		Distance = 20,
		Coords = { -1083.15,-245.88,37.76,209.77 },
		Model = "ig_barry",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Prisão (Center)
		Distance = 100,
		Coords = { 1818.73,2596.25,45.7,141.74 },
		Model = "s_m_m_prisguard_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Properties (Center)
	    Distance = 100,
		Coords = { 1655.27,4874.31,42.04,280.63 },
		Model = "mp_f_boatstaff_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Properties (Center)
	    Distance = 100,
		Coords = { -308.09,-163.93,40.42,238.12 },
		Model = "mp_f_boatstaff_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Townhall (Center)
		Distance = 30,
		Coords = { -551.69,-190.11,38.22,164.41 },
		Model = "ig_barry",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Townhall (Center)
		Distance = 30,
		Coords = { -364.33,-249.33,36.08,53.86 },
		Model = "ig_barry",
		anim = { "anim@heists@prison_heistig1_p1_guard_checks_bus","loop" }
	},
	{ -- Auto Escola (Center)
		Distance = 30,
		Coords = { -697.84,-1673.4,25.0,2.84 },
		Model = "ig_barry",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Barman (Ilegal)
		Distance = 15,
		Coords = { 2194.73,5581.52,53.36,184.26 },
		Model = "u_f_y_bikerchic",
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" }
	},
	{ -- Barman (Ilegal)
		Distance = 15,
		Coords = { 1420.99,6336.16,23.32,269.3 },
		Model = "u_f_y_bikerchic",
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" }
	},
	{ -- Barman (Ilegal)
		Distance = 15,
		Coords = { 336.64,-1989.09,24.2,48.19 },
		Model = "u_f_y_bikerchic",
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" }
	},
	{ -- Barman (Ilegal)
		Distance = 15,
		Coords = { -157.19,-1611.54,33.65,249.45 },
		Model = "u_f_y_bikerchic",
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" }
	},
	{ -- Barman (Ilegal)
		Distance = 15,
		Coords = { 987.83,-95.28,74.85,223.94 },
		Model = "g_f_y_lost_01",
		anim = { "anim@amb@clubhouse@bar@drink@idle_a","idle_a_bartender" }
	},
	{ -- Lester (Ilegal)
		Distance = 10,
		Coords = { 1272.26,-1711.54,54.76,34.02 },
		Model = "ig_lestercrest",
		anim = { "anim@heists@prison_heiststation@cop_reactions","cop_b_idle" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 487.56,-1456.11,29.28,272.13 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 154.66,-1472.9,29.35,325.99 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { -653.36,-1502.26,5.24,215.44 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 389.69,-942.1,29.42,175.75 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Criminal (Ilegal)
		Distance = 100,
		Coords = { -195.15,3651.33,51.73,334.49 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Criminal (Ilegal)
		Distance = 100,
		Coords = { 904.34,3656.56,32.57,274.97 },
		Model = "g_m_y_ballaeast_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Criminal (Ilegal)
		Distance = 100,
		Coords = { 2450.88,3759.53,41.7,334.49 },
		Model = "g_m_y_ballasout_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Criminal (Ilegal)
		Distance = 100,
		Coords = { 1901.86,4925.07,48.86,153.08 },
		Model = "g_m_y_famca_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Danger (Ilegal)
		Distance = 100,
		Coords = { 1045.13,-2510.32,28.46,0.0 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Informations (Ilegal)
		Distance = 100,
		Coords = { -95.09,-2767.85,6.08,93.55 },
		Model = "ig_beverly",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},

	{ -- Chiliad (Routes)
		Distance = 10,
		Coords = { 1388.83,-2088.54,52.6,39.69 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Families (Routes)
		Distance = 10,
		Coords = { -147.85,-1605.83,35.03 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Highways (Routes)
		Distance = 10,
		Coords = { 1064.5,-2346.63,30.58,269.3 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Vagos (Routes)
		Distance = 10,
		Coords = { 330.07,-2014.33,22.39,277.8 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Barragem (Routes)
		Distance = 10,
		Coords = { 1313.29,-143.11,115.76,266.46 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Farol (Routes)
		Distance = 10,
		Coords = { 3235.61,5115.88,15.82,113.39 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Parque (Routes)
		Distance = 10,
		Coords = { 412.21,732.51,199.45,232.45 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Sandy (Routes)
		Distance = 10,
		Coords = { 2136.72,3982.87,34.32,308.98 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Petróleo (Routes)
		Distance = 10,
		Coords = { 1458.41,-2437.19,66.12,354.34 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Praia-1 (Routes)
		Distance = 10,
		Coords = { -3098.8,1428.45,27.01,45.36 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Praia-2 (Routes)
		Distance = 10,
		Coords = { -3102.03,1679.39,37.68,212.6 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Zancudo (Routes)
		Distance = 10,
		Coords = { -627.44,2204.64,126.14,229.61 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Madrazzo (Routes)
		Distance = 10,
		Coords = { 1393.4,1141.01,109.74,178.59 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Playboy (Routes)
		Distance = 10,
		Coords = { -1518.71,74.75,56.92,99.22 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- TheSouth (Routes)
		Distance = 10,
		Coords = { 983.71,-90.85,74.85,218.27 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Vineyard (Routes)
		Distance = 10,
		Coords = { -1865.69,2062.96,135.44,79.38 },
		Model = "g_m_y_ballaorig_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},

	{ -- DigitalDen (Market)
		Distance = 25,
		Coords = { -1232.05,-1439.69,4.36,218.27 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- DigitalDen (Market)
		Distance = 25,
		Coords = { 450.91,-809.34,27.8,274.97 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Brewery (Market)
		Distance = 25,
		Coords = { -1225.06,-1439.93,4.36,121.89 },
		Model = "a_f_y_business_04",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Cool Beans (Market)
		Distance = 25,
		Coords = { -1215.81,-1468.6,4.36,306.15 },
		Model = "a_f_m_ktown_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Masquerade (Market)
		Distance = 25,
		Coords = { -1219.72,-1431.09,4.36,221.11 },
		Model = "u_m_m_streetart_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills (Market)
		Distance = 25,
		Coords = { -1195.99,-1458.47,4.38,34.02 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills (Market)
		Distance = 25,
		Coords = { -1198.76,-1460.3,4.36,36.86 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- PRO Bikes (Market)
		Distance = 25,
		Coords = { -1225.04,-1434.83,4.36,221.11 },
		Model = "a_m_y_cyclist_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Truthorganic (Market)
		Distance = 25,
		Coords = { -1206.44,-1460.05,4.36,308.98 },
		Model = "s_m_m_cntrybar_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- LD Organies (Market)
		Distance = 25,
		Coords = { -1211.01,-1464.93,4.36,308.98 },
		Model = "ig_lamardavis",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Bus (Works)
		Distance = 50,
		Coords = { 442.01,-633.87,28.63,263.63 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Taxi (Works)
		Distance = 50,
		Coords = { 905.53,-154.66,74.22,144.57 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Cemitery (Works)
		Distance = 100,
		Coords = { -1745.92,-204.83,57.39,320.32 },
		Model = "g_m_m_armboss_01",
		anim = { "timetable@trevor@smoking_meth@base","base" }
	},
	{ -- Leiteiro (Works)
		Distance = 50,
		Coords = { 2313.76,4888.19,41.8,53.86 },
		Model = "a_m_m_hillbilly_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2266.83,4892.59,40.89,317.49 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2256.55,4902.48,40.78,311.82 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2248.82,4910.18,40.73,311.82 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2240.87,4918.91,40.76,311.82 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2232.99,4926.0,40.83,323.15 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2224.58,4934.4,40.88,314.65 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2203.05,4914.07,40.57,311.82 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2211.45,4905.68,40.81,306.15 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2217.82,4897.23,40.76,311.82 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2227.2,4889.42,40.71,314.65 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2235.72,4881.53,40.96,311.82 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2243.74,4872.59,40.81,317.49 },
		Model = "a_c_cow"
	},
	{ -- Fishing (Works)
		Distance = 10,
		Coords = { 1520.62,3780.07,34.46,274.97 },
		Model = "a_f_y_beach_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Fishing (Works)
		Distance = 10,
		Coords = { 1522.88,3783.63,34.47,218.27 },
		Model = "a_f_y_eastsa_03",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Hunting (Works)
		Distance = 10,
		Coords = { -776.01,5603.03,33.73,257.96 },
		Model = "ig_hunter",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Hunting (Works)
		Distance = 50,
		Coords = { -1593.08,5202.9,4.31,297.64 },
		Model = "a_m_o_ktown_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Impound (Works)
		Distance = 30,
		Coords = { 407.35,-1624.76,29.28,229.61 },
		Model = "g_m_m_armboss_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Impound (Works)
		Distance = 30,
		Coords = { -193.23,-1162.39,23.67,274.97 },
		Model = "g_m_m_armboss_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Impound (Works)
		Distance = 100,
		Coords = { -273.96,6121.63,31.41,130.4 },
		Model = "g_m_m_armboss_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Impound (Works)
		Distance = 100,
		Coords = { 1737.95,3709.1,34.14,19.85 },
		Model = "g_m_m_armboss_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Jewelry (Works)
		Distance = 15,
		Coords = { -628.79,-238.7,38.05,311.82 },
		Model = "cs_gurk",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lumberman (Works)
		Distance = 50,
		Coords = { -841.52,5401.32,34.61,297.64 },
		Model = "a_m_o_ktown_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},	
	{ -- Recycling (Works)
		Distance = 50,
		Coords = { -428.54,-1728.29,19.78,70.87 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling (Works)
		Distance = 50,
		Coords = { 85.34,-1550.66,29.59,42.52 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling (Works)
		Distance = 50,
		Coords = { 180.07,2793.29,45.65,283.47 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling (Works)
		Distance = 50,
		Coords = { -195.42,6264.62,31.49,42.52 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Transporter (Works)
		Distance = 20,
		Coords = { -228.22,-843.52,30.68,161.58 },
		Model = "ig_casey",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Tractor (Works)
		Distance = 20,
		Coords = { 2251.68,5155.38,57.88,232.45 },
		Model = "a_m_m_farmer_01",
		anim = { "misscarstealfinale","packer_idle_1_trevor" }
	},
	{ -- Trash (Works)
		Distance = 50,
		Coords = { 82.98,-1553.55,29.59,51.03 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Colheita (Works)
		Distance = 50,
		Coords = { 2416.44,4993.82,46.22,144.57 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Trash (Works)
		Distance = 50,
		Coords = { 287.77,2843.9,44.7,121.89 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Trash (Works)
		Distance = 50,
		Coords = { -413.97,6171.58,31.48,320.32 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Trucker (Works)
		Distance = 100,
		Coords = { 1239.87,-3257.2,7.09,274.97 },
		Model = "s_m_m_trucker_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Trucker (Works)
		Distance = 100,
		Coords = { 474.78,-1318.27,29.2,300.48 },
		Model = "s_m_m_trucker_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Venda Caçador (Works)
		Distance = 50,
		Coords = { -695.59,5802.32,17.32,53.86 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)   1792.32,4594.69,37.68,187.09
		Distance = 50,
		Coords = { 1043.13,698.81,158.84,56.7 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)   1121.7,-645.91,56.82,280.63
		Distance = 50,
		Coords = { 1792.32,4594.69,37.68,187.09 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament (Framework)   1121.7,-645.91,56.82,280.63
		Distance = 50,
		Coords = { 1121.7,-645.91,56.82,280.63 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- RESTAURANTE CAT CAFE (Framework)
		Distance = 50,
		Coords = { -584.71,-1061.44,22.34,269.3 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- RESTAURANTE JAPANESE (Framework)
		Distance = 50,
		Coords = { -171.98,295.03,93.75,266.46 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Market Place (Market)
		Distance = 25,
		Coords = { 567.71,-3127.05,18.77,0.0 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number = 1, #NPCs do
			local Distance = #(Coords - vec3(NPCs[Number]["Coords"][1], NPCs[Number]["Coords"][2], NPCs[Number]["Coords"][3]))
			if Distance <= NPCs[Number]["Distance"] then
				if not Spawned[Number] and LoadModel(NPCs[Number]["Model"]) then
					Spawned[Number] = CreatePed(4, NPCs[Number]["Model"], NPCs[Number]["Coords"][1], NPCs[Number]["Coords"][2], NPCs[Number]["Coords"][3] - 1, NPCs[Number]["Coords"][4], false, false)
					SetPedArmour(Spawned[Number], 100)
					SetEntityInvincible(Spawned[Number], true)
					FreezeEntityPosition(Spawned[Number], true)

					if FixedNpcsHasNoCollision then
						SetEntityNoCollisionEntity(Spawned[Number], Ped, false)
					end

					SetBlockingOfNonTemporaryEvents(Spawned[Number], true)

					SetModelAsNoLongerNeeded(NPCs[Number]["Model"])

					if NPCs[Number]["Model"] == "s_f_y_casino_01" then
						SetPedDefaultComponentVariation(Spawned[Number])
						SetPedComponentVariation(Spawned[Number], 0, 3, 0, 0)
						SetPedComponentVariation(Spawned[Number], 1, 0, 0, 0)
						SetPedComponentVariation(Spawned[Number], 2, 3, 0, 0)
						SetPedComponentVariation(Spawned[Number], 3, 0, 1, 0)
						SetPedComponentVariation(Spawned[Number], 4, 1, 0, 0)
						SetPedComponentVariation(Spawned[Number], 6, 1, 0, 0)
						SetPedComponentVariation(Spawned[Number], 7, 1, 0, 0)
						SetPedComponentVariation(Spawned[Number], 8, 0, 0, 0)
						SetPedComponentVariation(Spawned[Number], 10, 0, 0, 0)
						SetPedComponentVariation(Spawned[Number], 11, 0, 0, 0)
						SetPedPropIndex(Spawned[Number], 1, 0, 0, false)
					end

					if NPCs[Number]["anim"] and LoadAnim(NPCs[Number]["anim"][1]) then
						TaskPlayAnim(Spawned[Number], NPCs[Number]["anim"][1], NPCs[Number]["anim"][2], 8.0, 8.0, -1, 1, 1, 0, 0, 0)
					end
				end
			else
				if Spawned[Number] then
					if DoesEntityExist(Spawned[Number]) then
						DeleteEntity(Spawned[Number])
					end

					Spawned[Number] = nil
				end
			end
		end

		Wait(1000)
	end
end)