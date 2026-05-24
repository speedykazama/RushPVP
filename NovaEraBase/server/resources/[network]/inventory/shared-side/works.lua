-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWORKMILKMAN
-----------------------------------------------------------------------------------------------------------------------------------------
CheckWorkMilkman = "Milkman"
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCEWORKMILKMAN
-----------------------------------------------------------------------------------------------------------------------------------------
ExperienceWorkMilkman = "Milkman"
LevelExperienceWorkMilkman = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITWORKGARBAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
InitWorkGarbageman = vec3(-322.25,-1545.91,31.02)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWORKGARBAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
CheckWorkGarbageman = "Garbageman"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEWORKGARBAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
VehicleWorkGarbageman = "trash"
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCEWORKGARBAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
ExperienceWorkGarbageman = "Garbageman"
LevelExperienceWorkGarbageman = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTGARGAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
ItemPaymentGarbageman = "dollars"
PaymentDefaultGarbageman = 100
TrashsTimerVerify = 300
CategoryIncrementsGarbageman = {
	[1] = 0,
    [2] = 2,
    [3] = 4,
    [4] = 6,
    [5] = 8,
    [6] = 10,
    [7] = 12,
    [8] = 15,
    [9] = 20,
    [10] = 25
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESETGARBAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
PresetGarbageman = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 }, -- ["p0"] = --chapeu
		["pants"] = { item = 36, texture = 0 }, -- [4] =  --calça
		["vest"] = { item = 0, texture = 0 }, -- [9] =--COLETE
		["bracelet"] = { item = -1, texture = 0 }, -- ["p6"] =  --braço esquerdo
		["backpack"] = { item = 0, texture = 0 }, -- [5] =  --Mochila
		["decals"] = { item = 0, texture = 0 }, -- [10] = --adesivo
		["mask"] = { item = 0, texture = 0 }, -- [1] =-- mascara
		["shoes"] = { item = 27, texture = 0 }, -- [6] =  --sapatos
		["tshirt"] = { item = 59, texture = 1 }, -- [8] = --camisa1
		["torso"] = { item = 57, texture = 0 }, -- [11] = --jaqueta
		["accessory"] = { item = 0, texture = 0 }, -- [7] =  --accessorio
		["watch"] = { item = -1, texture = 0 }, -- ["p7"] = --braço direitoaaa
		["arms"] = { item = 1, texture = 0 }, -- [3] =  --mãos
		["glass"] = { item = 0, texture = 0 }, -- ["p1"] = -- oculos
		["ear"] = { item = -1, texture = 0 } -- ["p2"] =  -- orelha
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 }, -- ["p0"] = --chapeu
		["pants"] = { item = 35, texture = 0 }, -- [4] =  --calça
		["vest"] = { item = -1, texture = 0 }, -- [9] =--COLETE
		["bracelet"] = { item = -1, texture = 0 }, -- ["p6"] =  --braço esquerdo
		["backpack"] = { item = 0, texture = 0 }, -- [5] =  --Mochila
		["decals"] = { item = 56, texture = 0 }, -- [10] = --adesivo
		["mask"] = { item = 0, texture = 0 }, -- [1] =-- mascara
		["shoes"] = { item = 26, texture = 0 }, -- [6] =  --sapatos
		["tshirt"] = { item = 36, texture = 0 }, -- [8] = --camisa1
		["torso"] = { item = 50, texture = 0 }, -- [11] = --jaqueta
		["accessory"] = { item = 155, texture = 4 }, -- [7] =  --accessorio
		["watch"] = { item = -1, texture = 0 }, -- ["p7"] = --braço direitoaaa
		["arms"] = { item = 1, texture = 0 }, -- [3] =  --mãos
		["glass"] = { item = 0, texture = 0 }, -- ["p1"] = -- oculos
		["ear"] = { item = -1, texture = 0 } -- ["p2"] =  -- orelha
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENSWORKGARBAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
ItensWorkGarbageman = {
    { item = "plastic", Amount = {1,3} },
    { item = "propertys", Amount = {1,3} },
    { item = "glass", Amount = {1,3} },
    { item = "rubber", Amount = {1,3} },
    { item = "aluminum", Amount = {1,3} },
    { item = "copper", Amount = {1,3} },
    { item = "emptybottle", Amount = {1,3} },
    { item = "rose", Amount = {1,3} },
    { item = "teddy", Amount = {1,3} },
    { item = "firecracker", Amount = {1,3} },
    { item = "plate", Amount = {1,3} },
    { item = "techtrash", Amount = {1,3} },
    { item = "tarp", Amount = {1,3} },
    { item = "sheetmetal", Amount = {1,3} },
    { item = "roadsigns", Amount = {1,3} },
    { item = "explosives", Amount = {1,3} },
    { item = "cotton", Amount = {1,3} },
    { item = "plaster", Amount = {1,3} },
    { item = "sulfuric", Amount = {1,3} },
    { item = "saline", Amount = {1,3} },
    { item = "alcohol", Amount = {1,3} }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALWORKFISHERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
InitWorkFisherman = vec3(1523.46,3782.86,34.87)
Fishings = vec3(1362.78,4082.29,29.49)
FishingsMaxDistance = 200
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWORKFISHERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
CheckWorkFisherman = "Fisherman"
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCEWORKFISHERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
ExperienceWorkFisherman = "Fisherman"
LevelExperienceWorkFisherman = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFISHERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
ItemPaymentFisherman = "dollars"
PaymentDefaultFisherman = 100
NeedBaitFishing = "worm"
CategoryIncrementsFisherman = {
	[1] = 0,
    [2] = 2,
    [3] = 4,
    [4] = 6,
    [5] = 8,
    [6] = 10,
    [7] = 12,
    [8] = 15,
    [9] = 20,
    [10] = 25
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESETFISHERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
PresetFisherman = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 }, -- ["p0"] = --chapeu
		["pants"] = { item = 2, texture = 13 }, -- [4] =  --calça
		["vest"] = { item = 0, texture = 0 }, -- [9] =--COLETE
		["bracelet"] = { item = -1, texture = 0 }, -- ["p6"] =  --braço esquerdo
		["backpack"] = { item = 0, texture = 0 }, -- [5] =  --Mochila
		["decals"] = { item = 0, texture = 0 }, -- [10] = --adesivo
		["mask"] = { item = 0, texture = 0 }, -- [1] =-- mascara
		["shoes"] = { item = 8, texture = 0 }, -- [6] =  --sapatos
		["tshirt"] = { item = 15, texture = 0 }, -- [8] = --camisa1
		["torso"] = { item = 80, texture = 0 }, -- [11] = --jaqueta
		["accessory"] = { item = -1, texture = 0 }, -- [7] =  --accessorio
		["watch"] = { item = -1, texture = 0 }, -- ["p7"] = --braço direitoaaa
		["arms"] = { item = 0, texture = 0 }, -- [3] =  --mãos
		["glass"] = { item = 0, texture = 0 }, -- ["p1"] = -- oculos
		["ear"] = { item = -1, texture = 0 } -- ["p2"] =  -- orelha
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 }, -- ["p0"] = --chapeu
		["pants"] = { item = 45, texture = 0 }, -- [4] =  --calça
		["vest"] = { item = -1, texture = 0 }, -- [9] =--COLETE
		["bracelet"] = { item = -1, texture = 0 }, -- ["p6"] =  --braço esquerdo
		["backpack"] = { item = 0, texture = 0 }, -- [5] =  --Mochila
		["decals"] = { item = 56, texture = 0 }, -- [10] = --adesivo
		["mask"] = { item = 0, texture = 0 }, -- [1] =-- mascara
		["shoes"] = { item = 31, texture = 0 }, -- [6] =  --sapatos
		["tshirt"] = { item = 15, texture = 0 }, -- [8] = --camisa1
		["torso"] = { item = 74, texture = 0 }, -- [11] = --jaqueta
		["accessory"] = { item = -1, texture = 0 }, -- [7] =  --accessorio
		["watch"] = { item = -1, texture = 0 }, -- ["p7"] = --braço direitoaaa
		["arms"] = { item = 15, texture = 0 }, -- [3] =  --mãos
		["glass"] = { item = 0, texture = 0 }, -- ["p1"] = -- oculos
		["ear"] = { item = -1, texture = 0 } -- ["p2"] =  -- orelha
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENSWORKFISHERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
ItensWorkFisherman = {
    { item = "anchovy", Amount = {1,3} },
    { item = "catfish", Amount = {1,3} },
    { item = "herring", Amount = {1,3} },
    { item = "orangeroughy", Amount = {1,3} },
    { item = "salmon", Amount = {1,3} },
    { item = "sardine", Amount = {1,3} },
    { item = "smallshark", Amount = {1,3} },
    { item = "smalltrout", Amount = {1,3} },
    { item = "yellowperch", Amount = {1,3} }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITWORKHUNTING
-----------------------------------------------------------------------------------------------------------------------------------------
InitWorkHunting = vec3(-776.01,5603.03,33.73)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWORKHUNTING
-----------------------------------------------------------------------------------------------------------------------------------------
CheckWorkHunting = "Hunter"
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCEWORKHUNTING
-----------------------------------------------------------------------------------------------------------------------------------------
ExperienceWorkHunting = "Hunter"
LevelExperienceWorkHunting = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNTERINFLUENCES
-----------------------------------------------------------------------------------------------------------------------------------------
HunterInfluences = {
    { 652.12, 4373.58, 95.12, 200 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
Animals = { "deer","boar","mtlion","coyote" }
AnimalsHunting = { -664053099, -832573324, -1323586730, 307287994, 1682622302 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTHUNTING
-----------------------------------------------------------------------------------------------------------------------------------------
ItemPaymentHunting = "dollars"
PaymentDefaultHunting = 100
NeedItemHunting = "WEAPON_SWITCHBLADE"
CategoryIncrementsHunting = {
	[1] = 0,
    [2] = 2,
    [3] = 4,
    [4] = 6,
    [5] = 8,
    [6] = 10,
    [7] = 12,
    [8] = 15,
    [9] = 20,
    [10] = 25
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALREWARDS
-----------------------------------------------------------------------------------------------------------------------------------------
AnimalRewards = {
	[-664053099] = { -- Veado
		{ item = "deer1star", chance = 50 },
		{ item = "deer2star", chance = 35 },
		{ item = "deer3star", chance = 15 },
		{ item = "animalpelt", amount = {2,4} },
		{ item = "meat", amount = {2,4} },
		{ item = "animalfat", amount = {2,4} },
		{ item = "leather", amount = {2,4} }
	},
	[-832573324] = { -- Javali
		{ item = "boar1star", chance = 45 },
		{ item = "boar2star", chance = 40 },
		{ item = "boar3star", chance = 15 },
		{ item = "animalpelt", amount = {2,4} },
		{ item = "meat", amount = {2,4} },
		{ item = "animalfat", amount = {2,4} },
		{ item = "leather", amount = {2,4} }
	},
	[-1323586730] = { -- Leão (variante 1)
		{ item = "mtlion1star", chance = 40 },
		{ item = "mtlion2star", chance = 40 },
		{ item = "mtlion3star", chance = 20 },
		{ item = "animalpelt", amount = {2,4} },
		{ item = "meat", amount = {2,4} },
		{ item = "animalfat", amount = {2,4} },
		{ item = "leather", amount = {2,4} }
	},
	[307287994] = { -- Leão (variante 2)
        { item = "mtlion1star", chance = 40 },
        { item = "mtlion2star", chance = 40 },
        { item = "mtlion3star", chance = 20 },
        { item = "animalpelt", amount = {2,4} },
        { item = "meat", amount = {2,4} },
        { item = "animalfat", amount = {2,4} },
        { item = "leather", amount = {2,4} }
    },
	[1682622302] = { -- Coiote
		{ item = "coyote1star", chance = 50 },
		{ item = "coyote2star", chance = 35 },
		{ item = "coyote3star", chance = 15 },
		{ item = "animalpelt", amount = {2,4} },
		{ item = "meat", amount = {2,4} },
		{ item = "animalfat", amount = {2,4} },
		{ item = "leather", amount = {2,4} }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTHUNTING
-----------------------------------------------------------------------------------------------------------------------------------------
PresetHunting = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 }, -- ["p0"] = --chapeu
		["pants"] = { item = 103, texture = 3 }, -- [4] =  --calça
		["vest"] = { item = 0, texture = 0 }, -- [9] =--COLETE
		["bracelet"] = { item = -1, texture = 0 }, -- ["p6"] =  --braço esquerdo
		["backpack"] = { item = 0, texture = 0 }, -- [5] =  --Mochila
		["decals"] = { item = 56, texture = 0 }, -- [10] = --adesivo
		["mask"] = { item = 0, texture = 0 }, -- [1] =-- mascara
		["shoes"] = { item = 12, texture = 0 }, -- [6] =  --sapatos
		["tshirt"] = { item = 15, texture = 0 }, -- [8] = --camisa1
		["torso"] = { item = 138, texture = 0 }, -- [11] = --jaqueta
		["accessory"] = { item = 120, texture = 1 }, -- [7] =  --accessorio
		["watch"] = { item = -1, texture = 0 }, -- ["p7"] = --braço direitoaaa
		["arms"] = { item = 14, texture = 0 }, -- [3] =  --mãos
		["glass"] = { item = 0, texture = 0 }, -- ["p1"] = -- oculos
		["ear"] = { item = -1, texture = 0 } -- ["p2"] =  -- orelha
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 }, -- ["p0"] = --chapeu
		["pants"] = { item = 110, texture = 3 }, -- [4] =  --calça
		["vest"] = { item = -1, texture = 0 }, -- [9] =--COLETE
		["bracelet"] = { item = -1, texture = 0 }, -- ["p6"] =  --braço esquerdo
		["backpack"] = { item = 0, texture = 0 }, -- [5] =  --Mochila
		["decals"] = { item = 0, texture = 0 }, -- [10] = --adesivo
		["mask"] = { item = 0, texture = 0 }, -- [1] =-- mascara
		["shoes"] = { item = 166, texture = 0 }, -- [6] =  --sapatos
		["tshirt"] = { item = 15, texture = 0 }, -- [8] = --camisa1
		["torso"] = { item = 135, texture = 2 }, -- [11] = --jaqueta
		["accessory"] = { item = 182, texture = 0 }, -- [7] =  --accessorio
		["watch"] = { item = -1, texture = 0 }, -- ["p7"] = --braço direitoaaa
		["arms"] = { item = 3, texture = 0 }, -- [3] =  --mãos
		["glass"] = { item = 58, texture = 4 }, -- ["p1"] = -- oculos
		["ear"] = { item = -1, texture = 0 } -- ["p2"] =  -- orelha
	}
}