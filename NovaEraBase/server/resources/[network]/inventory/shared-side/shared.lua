-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRELIST
-----------------------------------------------------------------------------------------------------------------------------------------
TyreList = {
	["wheel_lf"] = 0,
	["wheel_rf"] = 1,
	["wheel_lm"] = 2,
	["wheel_rm"] = 3,
	["wheel_lr"] = 4,
	["wheel_rr"] = 5
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
-----------------------------------------------------------------------------------------------------------------------------------------
Buffs = {
	["Dexterity"] = {},
	["Luck"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRODUCTS
-----------------------------------------------------------------------------------------------------------------------------------------
Products = {
	["tablecoke"] = {
		{ ["timer"] = 20, ["need"] = {
				{ ["item"] = "sulfuric", ["amount"] = 1 },
				{ ["item"] = "cokebud",  ["amount"] = 1 }
			}, ["needAmount"] = 1, ["item"] = "cocaine", ["itemAmount"] = 3
		}
	},
	["tablemeth"] = {
		{ ["timer"] = 20, ["need"] = {
				{ ["item"] = "saline",  ["amount"] = 1 },
				{ ["item"] = "acetone", ["amount"] = 1 }
			}, ["needAmount"] = 1, ["item"] = "meth", ["itemAmount"] = 3
		}
	},
	["tableweed"] = {
		{ ["timer"] = 20, ["need"] = {
				{ ["item"] = "silk",    ["amount"] = 1 },
				{ ["item"] = "weedbud", ["amount"] = 1 }
			}, ["needAmount"] = 1, ["item"] = "joint", ["itemAmount"] = 1
		}
	},
	["paper"] = {
		{ ["timer"] = 20, ["need"] = {
			{ ["item"] = "woodlog", ["amount"] = 3 }
		}, ["needAmount"] = 1, ["item"] = "paper", ["itemAmount"] = 1 }
	},
	["milkBottle"] = {
		{ ["timer"] = 10, ["need"] = "emptybottle", ["needAmount"] = 1, ["item"] = "milkbottle", ["itemAmount"] = 1 }
	},
	["scanner"] = {
		{ ["timer"] = 5, ["item"] = "sheetmetal", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "roadsigns", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "syringe", ["itemAmount"] = 3 },
		{ ["timer"] = 5, ["item"] = "fishingrod", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "plate", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "aluminum", ["itemAmount"] = 3 },
		{ ["timer"] = 5, ["item"] = "copper", ["itemAmount"] = 3 },
		{ ["timer"] = 5, ["item"] = "lighter", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "battery", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "metalcan", ["itemAmount"] = 1 }
	},
	["fishfillet"] = {
		{ ["timer"] = 10, ["need"] = "fishfillet", ["needAmount"] = 1, ["item"] = "cookedfishfillet", ["itemAmount"] = 1 }
	},
	["marshmallow"] = {
		{ ["timer"] = 10, ["need"] = "sugar", ["needAmount"] = 4, ["item"] = "marshmallow", ["itemAmount"] = 1 }
	},
	["animalmeat"] = {
		{ ["timer"] = 10, ["need"] = "meat", ["needAmount"] = 1, ["item"] = "cookedmeat", ["itemAmount"] = 1 }
	},
	["emptybottle"] = {
		{ ["timer"] = 3, ["need"] = "emptybottle", ["needAmount"] = 1, ["item"] = "water", ["itemAmount"] = 1 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
LootItens = {
	["Medic"] = {
		["Players"] = {},
		["Cooldown"] = 3600,
		["List"] = {
			{ ["item"] = "alcohol", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "codeine", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "amphetamine", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "acetone", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "saline", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "sulfuric", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "syringe", ["min"] = 2, ["max"] = 4 }
		}
	},
	["Weapons"] = {
		["Players"] = {},
		["Cooldown"] = 3600,
		["List"] = {
			{ ["item"] = "roadsigns", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "techtrash", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "sheetmetal", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "explosives", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "aluminum", ["min"] = 6, ["max"] = 8 },
			{ ["item"] = "copper", ["min"] = 6, ["max"] = 8 }
		}
	},
	["Supplies"] = {
		["Players"] = {},
		["Cooldown"] = 3600,
		["List"] = {
			{ ["item"] = "tarp", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "techtrash", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "sheetmetal", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "roadsigns", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "sulfuric", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "saline", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "alcohol", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "explosives", ["min"] = 2, ["max"] = 4 },
			{ ["item"] = "aluminum", ["min"] = 4, ["max"] = 8 },
			{ ["item"] = "copper", ["min"] = 4, ["max"] = 8 }
		}
	}
}
---------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
Objects = {
    -- MEDIC
	["1"] = { x = 594.59, y = 146.52, z = 97.30, h = 70.04, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["2"] = { x = 660.44, y = 268.29, z = 102.04, h = 152.09, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["3"] = { x = 552.54, y = -198.45, z = 53.75, h = 89.32, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["4"] = { x = 339.75, y = -580.95, z = 73.42, h = 67.19, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["5"] = { x = 696.12, y = -965.69, z = 23.26, h = 271.33, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["6"] = { x = -2235.42, y = 363.52, z = 173.91, h = 23.73, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["7"] = { x = 1382.1, y = -2081.97, z = 51.25, h = 220.16, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["8"] = { x = 589.32, y = -2802.73, z = 5.32, h = 328.01, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["9"] = { x = -453.19, y = -2810.47, z = 6.56, h = 225.82, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["10"] = { x = -1007.18, y = -2836.12, z = 13.20, h = 149.3, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["11"] = { x = -2018.21, y = -361.03, z = 47.36, h = 324.55, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["12"] = { x = -1727.77, y = 250.26, z = 61.65, h = 24.7, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["13"] = { x = -1089.6, y = 2717.05, z = 18.33, h = 40.52, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["14"] = { x = 321.27, y = 2874.98, z = 42.71, h = 27.62, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["15"] = { x = 1163.47, y = 2722.09, z = 37.26, h = 179.11, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["16"] = { x = 1745.86, y = 3326.69, z = 40.30, h = 115.55, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["17"] = { x = 2013.4, y = 3934.36, z = 31.65, h = 236.38, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["18"] = { x = 2526.3, y = 4191.6, z = 44.53, h = 236.44, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["19"] = { x = 2874.05, y = 4861.57, z = 61.35, h = 87.57, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["20"] = { x = 1985.16, y = 6200.39, z = 41.33, h = 330.21, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["21"] = { x = 1552.97, y = 6610.24, z = 2.12, h = 145.64, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["22"] = { x = -298.32, y = 6392.66, z = 29.87, h = 302.99, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["23"] = { x = -813.88, y = 5384.45, z = 33.77, h = 356.87, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["24"] = { x = -1606.5, y = 5259.26, z = 1.35, h = 114.45, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["25"] = { x = -199.22, y = 3638.8, z = 63.70, h = 39.84, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["26"] = { x = -1487.45, y = 2688.99, z = 2.94, h = 317.89, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["27"] = { x = -3266.12, y = 1139.82, z = 1.91, h = 249.17, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["28"] = { x = 170.71, y = -1070.94, z = 28.5, h = 339.6, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["29"] = { x = 487.23, y = -1093.93, z = 28.71, h = 0.74, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["30"] = { x = 584.63, y = -1419.69, z = 18.52, h = 180.41, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["31"] = { x = 694.07, y = -1453.5, z = 19.03, h = 0.45, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["32"] = { x = 892.49, y = -2490.3, z = 28.88, h = 175.48, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["33"] = { x = 1463.09, y = -2613.91, z = 48.17, h = 76.65, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["34"] = { x = 1877.42, y = -1065.71, z = 80.22, h = 97.79, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["35"] = { x = 2557.67, y = -598.5, z = 64.23, h = 12.71, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["36"] = { x = 2546.8, y = 395.31, z = 107.92, h = 268.3, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["37"] = { x = 2074.59, y = 1403.29, z = 74.88, h = 300.3, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["38"] = { x = 2405.44, y = 2903.85, z = 39.67, h = 217.41, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["39"] = { x = 2895.84, y = 3735.4, z = 43.5, h = 289.37, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["40"] = { x = 1677.25, y = 4882.36, z = 46.62, h = 59.7, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["41"] = { x = -437.08, y = 6339.84, z = 12.06, h = 216.59, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["42"] = { x = 431.15, y = 6472.57, z = 28.08, h = 140.5, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["43"] = { x = -2303.74, y = 3389.16, z = 30.56, h = 324.26, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["44"] = { x = -2096.92, y = 3258.17, z = 32.12, h = 239.97, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["45"] = { x = -1773.55, y = 2995.46, z = 32.11, h = 330.02, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["46"] = { x = -2086.61, y = 2816.89, z = 32.27, h = 354.52, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
	["47"] = { x = -1511.83, y = 1520.27, z = 114.59, h = 255.31, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
    -- WEAPONS
	["48"] = { x = 574.01, y = 132.56, z = 98.48, h = 70.99, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["49"] = { x = 344.79, y = 929.2, z = 202.44, h = 268.09, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["50"] = { x = -123.8, y = 1896.67, z = 196.34, h = 358.95, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["51"] = { x = -1099.85, y = 2703.51, z = 21.99, h = 221.35, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["52"] = { x = -2198.91, y = 4243.21, z = 46.92, h = 128.84, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["53"] = { x = -1487.02, y = 4983.14, z = 62.67, h = 174.11, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["54"] = { x = 1346.49, y = 6396.73, z = 32.42, h = 90.94, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["55"] = { x = 2535.72, y = 4661.39, z = 33.08, h = 316.4, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["56"] = { x = 1155.62, y = -1334.48, z = 33.72, h = 174.97, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["57"] = { x = 1116.06, y = -2498.07, z = 32.37, h = 193.39, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["58"] = { x = 261.06, y = -3135.82, z = 4.8, h = 88.83, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["59"] = { x = -1619.81, y = -1035.0, z = 12.16, h = 50.84, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["60"] = { x = -3420.87, y = 977.0, z = 10.91, h = 226.29, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["61"] = { x = -1909.53, y = 4624.93, z = 56.07, h = 135.57, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["62"] = { x = 894.51, y = 3211.45, z = 38.09, h = 273.04, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["63"] = { x = 1791.71, y = 4602.84, z = 36.69, h = 185.86, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["64"] = { x = 464.8, y = 6462.03, z = 28.76, h = 334.71, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["65"] = { x = 63.22, y = 6323.67, z = 37.87, h = 301.22, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["66"] = { x = -736.64, y = 5594.98, z = 40.66, h = 268.78, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["67"] = { x = 720.76, y = 2330.87, z = 50.76, h = 179.99, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["68"] = { x = 1909.47, y = 611.47, z = 177.41, h = 65.57, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["69"] = { x = 1796.6, y = -1350.06, z = 98.75, h = 61.5, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["70"] = { x = 955.32, y = -3101.26, z = 4.91, h = 266.38, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["71"] = { x = -1306.41, y = -3387.9, z = 12.95, h = 59.92, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["72"] = { x = -1219.66, y = -2079.82, z = 13.16, h = 351.04, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["73"] = { x = -1203.53, y = -1804.25, z = 2.91, h = 245.4, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["74"] = { x = -720.47, y = -399.49, z = 33.9, h = 351.27, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["75"] = { x = -503.39, y = -1438.17, z = 13.16, h = 346.71, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["76"] = { x = 1398.24, y = 2117.57, z = 104.02, h = 131.36, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["77"] = { x = -1811.62, y = 3104.09, z = 31.85, h = 60.36, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["78"] = { x = -1812.86, y = 3101.95, z = 31.85, h = 62.1, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["79"] = { x = -1850.29, y = 3156.66, z = 31.82, h = 150.22, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["80"] = { x = -2052.86, y = 3173.31, z = 31.82, h = 240.03, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["81"] = { x = -2409.94, y = 3355.95, z = 31.83, h = 61.29, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
	["82"] = { x = -2450.39, y = 2946.63, z = 31.97, h = 330.0, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
    -- SUPPLIES
	["83"] = { x = -257.5, y = -966.54, z = 30.22, h = 26.06, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["84"] = { x = -2682.86, y = 2304.87, z = 20.85, h = 164.19, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["85"] = { x = -1282.33, y = 2559.98, z = 17.4, h = 148.06, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["86"] = { x = 159.65, y = 3118.8, z = 42.44, h = 16.37, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["87"] = { x = 1061.43, y = 3527.62, z = 33.15, h = 255.93, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["88"] = { x = 2370.22, y = 3156.55, z = 47.21, h = 221.77, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["89"] = { x = 2520.51, y = 2637.83, z = 36.95, h = 314.33, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["90"] = { x = 2572.37, y = 477.44, z = 107.68, h = 269.49, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["91"] = { x = 1223.15, y = -1079.56, z = 37.53, h = 123.38, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["92"] = { x = 1048.49, y = -247.53, z = 68.66, h = 149.33, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["93"] = { x = 499.41, y = -529.38, z = 23.76, h = 262.13, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["94"] = { x = 592.53, y = -2115.87, z = 4.76, h = 100.96, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["95"] = { x = 523.43, y = -2578.67, z = 13.82, h = 318.38, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["96"] = { x = -2.98, y = -1299.67, z = 28.28, h = 359.37, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["97"] = { x = 183.11, y = -1086.93, z = 28.28, h = 348.57, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["98"] = { x = 713.88, y = -850.95, z = 23.3, h = 271.63, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["99"] = { x = -2438.82, y = 2999.82, z = 32.07, h = 194.35, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["100"] = { x = -2440.04, y = 2999.46, z = 32.07, h = 194.41, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["101"] = { x = -2092.59, y = 3113.14, z = 31.82, h = 240.25, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["102"] = { x = -1824.95, y = 3016.0, z = 31.82, h = 329.62, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["103"] = { x = -202.03, y = 3651.99, z = 50.74, h = 192.39, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["104"] = { x = -203.41, y = 3651.71, z = 50.74, h = 192.96, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["105"] = { x = 2007.81, y = 4964.86, z = 40.71, h = 158.28, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["106"] = { x = 1904.26, y = 4930.73, z = 47.97, h = 156.61, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["107"] = { x = 1702.14, y = 4819.3, z = 40.96, h = 97.05, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["108"] = { x = 2030.66, y = 4727.43, z = 40.61, h = 294.35, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["109"] = { x = 2122.12, y = 4784.69, z = 39.98, h = 116.71, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["110"] = { x = 2177.23, y = 2169.39, z = 116.31, h = 229.64, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["111"] = { x = 2395.2, y = 2032.72, z = 90.35, h = 318.06, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["112"] = { x = 2619.31, y = 1691.36, z = 26.6, h = 270.01, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["113"] = { x = 1454.52, y = -1680.69, z = 65.03, h = 25.31, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["114"] = { x = 1453.05, y = -1681.37, z = 64.96, h = 24.93, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["115"] = { x = 240.42, y = -1864.8, z = 25.82, h = 49.31, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["116"] = { x = -139.01, y = -1995.56, z = 21.81, h = 181.56, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["117"] = { x = -343.54, y = -1333.09, z = 36.31, h = 89.4, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["118"] = { x = -350.99, y = -1333.15, z = 36.31, h = 269.98, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["119"] = { x = -346.45, y = -1337.38, z = 36.31, h = 359.9, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	["120"] = { x = -267.45, y = -971.56, z = 30.22, h = 25.86, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
	-- ROBBERY CLOTHESHOP
	["121"] = { x = 70.27, y = -1389.11, z = 29.13, h = 90.28, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["122"] = { x = -706.01, y = -150.49, z = 37.17, h = 28.61, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["123"] = { x = -167.66, y = -301.67, z = 39.49, h = 161.34, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["124"] = { x = -821.69, y = -1067.22, z = 11.08, h = 31.23, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["125"] = { x = -1186.62, y = -772.55, z = 17.09, h = 215.93, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["126"] = { x = -1446.85, y = -240.38, z = 49.57, h = 316.88, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["127"] = { x = 5.53, y = 6506.07, z = 31.63, h = 222.68, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["128"] = { x = 1699.51, y = 4819.72, z = 41.82, h = 277.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["129"] = { x = 117.83, y = -223.56, z = 54.31, h = 70.89, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["130"] = { x = 621.58, y = 2765.81, z = 41.84, h = 275.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["131"] = { x = 1200.46, y = 2715.37, z = 37.98, h = 0.24, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["132"] = { x = -3178.48, y = 1044.46, z = 20.62, h = 66.61, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["133"] = { x = -1102.05, y = 2716.93, z = 18.86, h = 40.85, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["134"] = { x = 430.72, y = -810.01, z = 29.25, h = 270.35, object = "p_v_43_safe_s", item = "", Distance = 50 },
	-- ROBBERY WEAPONSHOP
	["135"] = { x = 1688.78, y = 3759.13, z = 34.46, h = 47.5, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["136"] = { x = 256.35, y = -47.51, z = 69.7, h = 249.76, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["137"] = { x = 846.13, y = -1036.62, z = 27.95, h = 178.74, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["138"] = { x = -335.18, y = 6083.29, z = 31.21, h = 45.57, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["139"] = { x = -665.98, y = -932.24, z = 21.58, h = 358.38, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["140"] = { x = -1301.93, y = -391.36, z = 36.45, h = 255.85, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["141"] = { x = -1122.59, y = 2698.25, z = 18.31, h = 42.82, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["142"] = { x = 2571.67, y = 291.28, z = 108.49, h = 180.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["143"] = { x = 2571.66, y = 291.29, z = 108.49, h = 181.06, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["144"] = { x = 19.57, y = -1103.0, z = 29.55, h = 339.07, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["145"] = { x = 813.92, y = -2160.34, z = 29.37, h = 179.33, object = "p_v_43_safe_s", item = "", Distance = 50 },
	-- ROBBERY BARBERSHOP
	["146"] = { x = -807.9, y = -180.83, z = 37.32, h = 299.3, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["147"] = { x = 139.56, y = -1704.12, z = 29.05, h = 320.25, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["148"] = { x = -1278.11, y = -1116.66, z = 6.75, h = 270.07, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["149"] = { x = 1928.89, y = 3734.04, z = 32.6, h = 29.2, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["150"] = { x = 1217.05, y = -473.45, z = 65.96, h = 255.89, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["151"] = { x = -34.08, y = -157.01, z = 56.83, h = 159.63, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["152"] = { x = -274.5, y = 6225.27, z = 31.45, h = 225.27, object = "p_v_43_safe_s", item = "", Distance = 50 },
	-- ROBBERY TATTOOSHOP
	["153"] = { x = 1327.98, y = -1654.78, z = 52.03, h = 218.71, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["154"] = { x = -1149.04, y = -1428.64, z = 4.71, h = 215.2, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["155"] = { x = 322.01, y = 186.24, z = 103.34, h = 339.28, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["156"] = { x = -3175.64, y = 1075.54, z = 20.58, h = 65.96, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["157"] = { x = 1866.01, y = 3748.07, z = 32.79, h = 299.38, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["158"] = { x = -295.51, y = 6199.21, z = 31.24, h = 133.05, object = "p_v_43_safe_s", item = "", Distance = 50 },
	-- OTHER OBJECTS
	["9998"] = { x = -584.12, y = -1062.95, z = 22.38, h = 33.14, object = "bkr_prop_fakeid_clipboard_01a", item = "", Distance = 15 },
	["9999"] = { x = -1188.9, y = -897.82, z = 13.95, h = 130.04, object = "bkr_prop_fakeid_clipboard_01a", item = "", Distance = 15 }
}