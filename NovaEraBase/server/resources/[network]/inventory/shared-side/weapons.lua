-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONSATTACHMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
WeaponsAttachments = {
    lan = {
        WEAPON_PISTOL_MK2 = "COMPONENT_AT_PI_FLSH_02",
        WEAPON_HEAVYPISTOL = "COMPONENT_AT_PI_FLSH",
        WEAPON_COMBATPISTOL = "COMPONENT_AT_PI_FLSH",
        WEAPON_SMG_MK2 = "COMPONENT_AT_AR_FLSH",
        WEAPON_ASSAULTRIFLE_MK2 = "COMPONENT_AT_AR_FLSH",
        WEAPON_CARBINERIFLE = "COMPONENT_AT_AR_FLSH",
        WEAPON_SMG = "COMPONENT_AT_AR_FLSH",
        WEAPON_PUMPSHOTGUN = "COMPONENT_AT_AR_FLSH",
        WEAPON_CARBINERIFLE_MK2 = "COMPONENT_AT_AR_FLSH"
    },
    mira = {
        WEAPON_PISTOL_MK2 = "COMPONENT_AT_PI_RAIL",
        WEAPON_SMG_MK2 = "COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
        WEAPON_SMG = "COMPONENT_AT_SCOPE_MACRO_02",
        WEAPON_ASSAULTRIFLE_MK2 = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
        WEAPON_CARBINERIFLE_MK2 = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
        WEAPON_CARBINERIFLE = "COMPONENT_AT_SCOPE_MEDIUM"
    },
    emp = {
        WEAPON_ASSAULTRIFLE_MK2 = "COMPONENT_AT_AR_AFGRIP_02",
        WEAPON_SPECIALCARBINE_MK2 = "COMPONENT_AT_AR_AFGRIP_02",
        WEAPON_CARBINERIFLE = "COMPONENT_AT_AR_AFGRIP"
    },
    todos = {
        WEAPON_PISTOL_MK2 = { "COMPONENT_AT_PI_COMP" },
        WEAPON_MACHINEPISTOL = {},
        WEAPON_SMG_MK2 = { "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL_SMG_MK2" },
        WEAPON_COMBATPDW = { "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_AT_SCOPE_SMALL" },
        WEAPON_PUMPSHOTGUN = { "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SR_SUPP" },
        WEAPON_SMG = { "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MACRO_02", "COMPONENT_AT_PI_SUPP" },
        WEAPON_ASSAULTRIFLE_MK2 = { "COMPONENT_AT_SIGHTS", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM_MK2", "COMPONENT_AT_AR_AFGRIP_02", "COMPONENT_AT_MUZZLE_03" },
        WEAPON_SPECIALCARBINE_MK2 = { "COMPONENT_AT_SIGHTS", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM_MK2", "COMPONENT_AT_AR_AFGRIP_02", "COMPONENT_AT_MUZZLE_03" },
        WEAPON_CARBINERIFLE = { "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_AFGRIP" },
        WEAPON_SNSPISTOL_MK2 = { "COMPONENT_AT_PI_SUPP_02", "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE", "COMPONENT_SNSPISTOL_MK2_CLIP_02" },
        WEAPON_CARBINERIFLE_MK2 = { "COMPONENT_AT_AR_AFGRIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM_MK2", "COMPONENT_AT_MUZZLE_07", "COMPONENT_AT_MUZZLE_04" },
        WEAPON_BULLPUPRIFLE_MK2 = { "COMPONENT_AT_AR_AFGRIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_MEDIUM_MK2", "COMPONENT_AT_MUZZLE_07", "COMPONENT_AT_MUZZLE_04" },
        WEAPON_HEAVYSNIPER_MK2 = { "COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING", "COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ", "COMPONENT_AT_SCOPE_MAX", "COMPONENT_AT_SCOPE_NV", "COMPONENT_AT_SCOPE_THERMAL", "COMPONENT_AT_SR_SUPP_03" },
        WEAPON_HEAVYPISTOL = { "COMPONENT_AT_PI_FLSH", "COMPONENT_COMBATPISTOL_CLIP_02" },
        WEAPON_COMBATPISTOL = { "COMPONENT_AT_PI_FLSH", "COMPONENT_COMBATPISTOL_CLIP_02" }
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONAMMOS
-----------------------------------------------------------------------------------------------------------------------------------------
weaponAmmos = {
    ["WEAPON_PISTOL_AMMO"] = {
        "WEAPON_PISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_PISTOL50",
        "WEAPON_SNSPISTOL",
        "WEAPON_SNSPISTOL_MK2",
        "WEAPON_REVOLVER",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_GLOCK21"
    },
    ["WEAPON_NAIL_AMMO"] = {
        "WEAPON_NAILGUN"
    },
    ["WEAPON_RPG_AMMO"] = {
        "WEAPON_RPG"
    },
    ["WEAPON_SMG_AMMO"] = {
		"WEAPON_COMPACTRIFLE",
        "WEAPON_MICROSMG",
        "WEAPON_MINISMG",
        "WEAPON_GUSENBERG",
		"WEAPON_ASSAULTSMG",
        "WEAPON_MACHINEPISTOL"
    },
    ["WEAPON_RIFLE_AMMO"] = {
		"WEAPON_FNFAL",
		"WEAPON_FNSCAR",
		"WEAPON_QBZ83",
        "WEAPON_BULLPUPRIFLE_MK2",
        "WEAPON_ADVANCEDRIFLE",
        "WEAPON_ASSAULTRIFLE",
        "WEAPON_ASSAULTRIFLE_MK2",
        "WEAPON_SPECIALCARBINE",
        "WEAPON_SPECIALCARBINE_MK2",
		"WEAPON_VANDAL",
		"WEAPON_VANDAL1",
		"WEAPON_VANDAL2",
		"WEAPON_GLITCHPOPVANDAL",
    },
    ["WEAPON_SHOTGUN_AMMO"] = {
        "WEAPON_PUMPSHOTGUN_MK2",
        "WEAPON_SAWNOFFSHOTGUN"
    },
    ["WEAPON_POLICE_AMMO"] = {
        "WEAPON_COLTXM177",
        "WEAPON_TACTICALRIFLE",
        "WEAPON_HEAVYRIFLE",
        "WEAPON_PARAFAL",
		"WEAPON_APPISTOL",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_COMBATPISTOL",
        "WEAPON_SMG",
        "WEAPON_SMG_MK2",
        "WEAPON_BULLPUPRIFLE",
		"WEAPON_CARBINERIFLE",
        "WEAPON_PUMPSHOTGUN",
		"WEAPON_CARBINERIFLE_MK2"
    },
    ["WEAPON_MUSKET_AMMO"] = {
        "WEAPON_MUSKET",
        "WEAPON_SAUER"
    },
    ["WEAPON_PETROLCAN_AMMO"] = {
        "WEAPON_PETROLCAN"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
weaponAttachs = {
	["attachsFlashlight"] = {
		["WEAPON_PISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_FLSH_02",
		["WEAPON_APPISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_HEAVYPISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_MICROSMG"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_FLSH_03",
		["WEAPON_PISTOL50"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_COMBATPISTOL"] = "COMPONENT_AT_PI_FLSH",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_PUMPSHOTGUN"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SMG"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_FLSH",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_FLSH"
	},
	["attachsCrosshair"] = {
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_RAIL",
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_RAIL_02",
		["WEAPON_MICROSMG"] = "COMPONENT_AT_SCOPE_MACRO",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_SCOPE_MEDIUM",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_SCOPE_SMALL",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_SCOPE_MACRO_02_MK2",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_SCOPE_MEDIUM",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_SIGHTS",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SCOPE_SMALL_MK2",
		["WEAPON_SMG"] = "COMPONENT_AT_SCOPE_MACRO_02",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_SCOPE_MACRO",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_SCOPE_MACRO"
	},
	["attachsMagazine"] = {
		["WEAPON_PISTOL"] = "COMPONENT_PISTOL_CLIP_02",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_PISTOL_MK2_CLIP_02",
		["WEAPON_COMPACTRIFLE"] = "COMPONENT_COMPACTRIFLE_CLIP_02",
		["WEAPON_APPISTOL"] = "COMPONENT_APPISTOL_CLIP_02",
		["WEAPON_HEAVYPISTOL"] = "COMPONENT_HEAVYPISTOL_CLIP_02",
		["WEAPON_MACHINEPISTOL"] = "COMPONENT_MACHINEPISTOL_CLIP_02",
		["WEAPON_MICROSMG"] = "COMPONENT_MICROSMG_CLIP_02",
		["WEAPON_MINISMG"] = "COMPONENT_MINISMG_CLIP_02",
		["WEAPON_SNSPISTOL"] = "COMPONENT_SNSPISTOL_CLIP_02",
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_SNSPISTOL_MK2_CLIP_02",
		["WEAPON_VINTAGEPISTOL"] = "COMPONENT_VINTAGEPISTOL_CLIP_02",
		["WEAPON_PISTOL50"] = "COMPONENT_PISTOL50_CLIP_02",
		["WEAPON_COMBATPISTOL"] = "COMPONENT_COMBATPISTOL_CLIP_02",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_CARBINERIFLE_CLIP_02",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
		["WEAPON_ADVANCEDRIFLE"] = "COMPONENT_ADVANCEDRIFLE_CLIP_02",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_BULLPUPRIFLE_CLIP_02",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_SPECIALCARBINE_CLIP_02",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_SPECIALCARBINE_MK2_CLIP_02",
		["WEAPON_SMG"] = "COMPONENT_SMG_CLIP_02",
		["WEAPON_SMG_MK2"] = "COMPONENT_SMG_MK2_CLIP_02",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_ASSAULTRIFLE_CLIP_02",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_ASSAULTSMG_CLIP_02",
		["WEAPON_GUSENBERG"] = "COMPONENT_GUSENBERG_CLIP_02"
	},
	["attachsSilencer"] = {
		["WEAPON_PISTOL"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_APPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_MACHINEPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_BULLPUPRIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SR_SUPP_03",
		["WEAPON_SMG"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_COLTXM177"] = "COMPONENT_COLTXM177_SUPP",
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_SUPP_02"
	},
	["attachsGrip"] = {
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_AFGRIP",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_SPECIALCARBINE"] = "COMPONENT_AT_AR_AFGRIP",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_MUZZLE_08",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_AFGRIP",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_AFGRIP_02"
	},
	["attachsMuzzleFat"] = {
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_COMP",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_MUZZLE_03"
	},
	["attachsBarrel"] = {
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_BP_BARREL_02",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_AR_BARREL_02",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_CR_BARREL_02",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_SC_BARREL_01",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_SB_BARREL_02"
	},
	["attachsMuzzleHeavy"] = {
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_COMP",
		["WEAPON_CARBINERIFLE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_SPECIALCARBINE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_BULLPUPRIFLE_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_MUZZLE_03",
		["WEAPON_ASSAULTRIFLE_MK2"] = "COMPONENT_AT_MUZZLE_03"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NORMALWEAPONSTINTS
-----------------------------------------------------------------------------------------------------------------------------------------
NormalWeaponsTints = {
	["WEAPON_PISTOL"] = true,
	["WEAPON_COMPACTRIFLE"] = true,
	["WEAPON_APPISTOL"] = true,
	["WEAPON_HEAVYPISTOL"] = true,
	["WEAPON_MACHINEPISTOL"] = true,
	["WEAPON_MICROSMG"] = true,
	["WEAPON_RPG"] = true,
	["WEAPON_MINISMG"] = true,
	["WEAPON_SNSPISTOL"] = true,
	["WEAPON_VINTAGEPISTOL"] = true,
	["WEAPON_PISTOL50"] = true,
	["WEAPON_COMBATPISTOL"] = true,
	["WEAPON_CARBINERIFLE"] = true,
	["WEAPON_ADVANCEDRIFLE"] = true,
	["WEAPON_BULLPUPRIFLE"] = true,
	["WEAPON_SPECIALCARBINE"] = true,
	["WEAPON_PUMPSHOTGUN"] = true,
	["WEAPON_MUSKET"] = true,
	["WEAPON_SAWNOFFSHOTGUN"] = true,
	["WEAPON_SMG"] = true,
	["WEAPON_TACTICALRIFLE"] = true,
	["WEAPON_HEAVYRIFLE"] = true,
	["WEAPON_ASSAULTRIFLE"] = true,
	["WEAPON_ASSAULTSMG"] = true,
	["WEAPON_GUSENBERG"] = true,
	["WEAPON_STUNGUN"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECIALWEAPONSTINTS
-----------------------------------------------------------------------------------------------------------------------------------------
SpecialWeaponsTints = {
	["WEAPON_PISTOL_MK2"] = true,
	["WEAPON_SNSPISTOL_MK2"] = true,
	["WEAPON_CARBINERIFLE_MK2"] = true,
	["WEAPON_BULLPUPRIFLE_MK2"] = true,
	["WEAPON_SPECIALCARBINE_MK2"] = true,
	["WEAPON_PUMPSHOTGUN_MK2"] = true,
	["WEAPON_SMG_MK2"] = true,
	["WEAPON_ASSAULTRIFLE_MK2"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
SkinsWeapons = {
    ["WEAPON_PISTOL_MK2"] = {
        [1] = "COMPONENT_FIVESEVEN_AA",
        [2] = "COMPONENT_FIVESEVEN_AI",
        [3] = "COMPONENT_FIVESEVEN_AJ",
        [4] = "COMPONENT_FIVESEVEN_AM",
        [5] = "COMPONENT_FIVESEVEN_AO",
        [6] = "COMPONENT_FIVESEVEN_AP",
        [7] = "COMPONENT_FIVESEVEN_AR",
        [8] = "COMPONENT_FIVESEVEN_AT",
        [9] = "COMPONENT_FIVESEVEN_NV",
        [10] = "COMPONENT_FIVESEVEN_BARBIE",
    },
    ["WEAPON_COMBATPISTOL"] = {
        [1] = "COMPONENT_GLOCK_SNACKCLUB",
        [2] = "COMPONENT_GLOCK_SEATERROR",
        [3] = "COMPONENT_GLOCK_REDSAMURAI",
        [4] = "COMPONENT_GLOCK_BT",
        [5] = "COMPONENT_GLOCK_BW",
        [6] = "COMPONENT_GLOCK_CH",
        [7] = "COMPONENT_GLOCK_CI",
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        [1] = "COMPONENT_AK47_SKIN",
        [2] = "COMPONENT_AK47_MARK_SKIN",
        [3] = "COMPONENT_AK47_TOE_SKIN",
        [4] = "COMPONENT_AK47_WH_SKIN",
        [5] = "COMPONENT_AK47_WHITE_SKIN",
        [6] = "COMPONENT_AK47_WHITEB_SKIN",
        [7] = "COMPONENT_AK47_PARTEN_SKIN",
        [8] = "COMPONENT_AK47_YE_SKIN",
        [9] = "COMPONENT_AK47_AH_SKIN",
        [10] = "COMPONENT_AK47_AA_SKIN",
        [11] = "COMPONENT_AK47_AB_SKIN",
        [12] = "COMPONENT_AK47_AC_SKIN",
        [13] = "COMPONENT_AK47_AE_SKIN",
        [14] = "COMPONENT_AK47_AG_SKIN",
        [15] = "COMPONENT_AK47_AI_SKIN",
        [16] = "COMPONENT_AK47_AK_SKIN",
        [17] = "COMPONENT_AK47_AL_SKIN",
        [18] = "COMPONENT_AK47_AM_SKIN",
        [19] = "COMPONENT_AK47_AN_SKIN",
        [20] = "COMPONENT_AK47_AQ_SKIN",
    },
    ["WEAPON_CARBINERIFLE"] = {
        [1] = "COMPONENT_M4_AD_SKIN",
        [2] = "COMPONENT_M4_AL_SKIN",
        [3] = "COMPONENT_M4_AM_SKIN",
        [4] = "COMPONENT_M4_AR_SKIN",
        [5] = "COMPONENT_M4_AS_SKIN",
        [6] = "COMPONENT_M4_COLT_SKIN",
        [7] = "COMPONENT_M4_DK_SKIN",
        [8] = "COMPONENT_M4_DRAGON_SKIN",
        [9] = "COMPONENT_M4_GR_SKIN",
        [10] = "COMPONENT_M4_HUNTER_SKIN",
        [11] = "COMPONENT_M4_W_SKIN",
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        [1] = "COMPONENT_M4_MK2_AJ_SKIN",
        [2] = "COMPONENT_M4_MK2_BL_SKIN",
    },
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        [1] = "COMPONENT_AK47_AA_SKIN",
        [2] = "COMPONENT_AK47_AB_SKIN",
        [3] = "COMPONENT_AK47_AC_SKIN",
        [4] = "COMPONENT_AK47_AE_SKIN",
        [5] = "COMPONENT_AK47_AG_SKIN",
        [6] = "COMPONENT_AK47_AI_SKIN",
        [7] = "COMPONENT_AK47_AK_SKIN",
        [8] = "COMPONENT_AK47_AL_SKIN",
        [9] = "COMPONENT_AK47_AM_SKIN",
        [10] = "COMPONENT_AK47_AN_SKIN",
        [11] = "COMPONENT_AK47_AQ_SKIN",
    },
    ["WEAPON_SPECIALCARBINE"] = {
        [1] = "COMPONENT_G3_BB",
        [2] = "COMPONENT_G3_CA",
        [3] = "COMPONENT_G3_PB",
        [4] = "COMPONENT_G3_RAE",
        [5] = "COMPONENT_G3_SUB",
        [6] = "COMPONENT_G3_BRIN",
        [7] = "COMPONENT_G3_ANCI",
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        [1] = "COMPONENT_G3_MK2_GP",
        [2] = "COMPONENT_G3_MK2_ONI",
        [3] = "COMPONENT_G3_MK2_RGX",
        [4] = "COMPONENT_G3_MK2_SAQ",
        [5] = "COMPONENT_G3_MK2_SING",
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINCOMPONENTS
-----------------------------------------------------------------------------------------------------------------------------------------
SkinsComponents = {
    ["COMPONENT_FIVESEVEN_AA"] = { 
        nome = "Five Seven Korea", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_AI"] = { 
        nome = "Five Seven Hello Kitty", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_AJ"] = { 
        nome = "Five Seven Alien", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_AM"] = { 
        nome = "Five Seven Mexico", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_AO"] = { 
        nome = "Five Seven Nike X", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_AP"] = { 
        nome = "Five Seven My X", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_AR"] = { 
        nome = "Five Seven Vulcão", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_AT"] = { 
        nome = "Five Seven Nike Smile", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_NV"] = { 
        nome = "Five Seven Nike V.", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_FIVESEVEN_BARBIE"] = { 
        nome = "Five Seven Barbie", 
        arma = "WEAPON_PISTOL_MK2", 
        categoria = "Pistol"
    },
    ["COMPONENT_GLOCK_SNACKCLUB"] = { 
        nome = "Glock Snack Club", 
        arma = "WEAPON_COMBATPISTOL", 
        categoria = "Pistol"
    },
    ["COMPONENT_GLOCK_SEATERROR"] = { 
        nome = "Glock Sea Terror", 
        arma = "WEAPON_COMBATPISTOL", 
        categoria = "Pistol"
    },
    ["COMPONENT_GLOCK_REDSAMURAI"] = { 
        nome = "Glock Red Samurai", 
        arma = "WEAPON_COMBATPISTOL", 
        categoria = "Pistol"
    },
    ["COMPONENT_GLOCK_BT"] = { 
        nome = "Glock Gaiden", 
        arma = "WEAPON_COMBATPISTOL", 
        categoria = "Pistol"
    },
    ["COMPONENT_GLOCK_BW"] = { 
        nome = "Glock Royal Salute", 
        arma = "WEAPON_COMBATPISTOL", 
        categoria = "Pistol"
    },
    ["COMPONENT_GLOCK_CH"] = { 
        nome = "Glock Nike France", 
        arma = "WEAPON_COMBATPISTOL", 
        categoria = "Pistol"
    },
    ["COMPONENT_GLOCK_CI"] = { 
        nome = "Glock Cyclone", 
        arma = "WEAPON_COMBATPISTOL", 
        categoria = "Pistol"
    },
    ["COMPONENT_M4_MK2_AJ_SKIN"] = { 
        nome = "M4 MK2 Mark", 
        arma = "WEAPON_CARBINERIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_MK2_BL_SKIN"] = { 
        nome = "M4 MK2 BL", 
        arma = "WEAPON_CARBINERIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_SKIN"] = { 
        nome = "AK-47 Dragon", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_MARK_SKIN"] = { 
        nome = "AK-47 Mark", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_TOE_SKIN"] = { 
        nome = "AK-47 Toei", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_WHITE_SKIN"] = { 
        nome = "AK-47 White", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_WH_SKIN"] = { 
        nome = "AK-47 White Half", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_WHITEB_SKIN"] = { 
        nome = "AK-47 White B", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_PARTEN_SKIN"] = { 
        nome = "AK-47 Parten", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_YE_SKIN"] = { 
        nome = "AK-47 Yellow", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AH_SKIN"] = { 
        nome = "AK-47 Armor", 
        arma = "WEAPON_ASSAULTRIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AA_SKIN"] = { 
        nome = "AK-47 A", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AB_SKIN"] = { 
        nome = "AK-47 B", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AC_SKIN"] = { 
        nome = "AK-47 C", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AE_SKIN"] = { 
        nome = "AK-47 E", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AG_SKIN"] = { 
        nome = "AK-47 G", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AI_SKIN"] = { 
        nome = "AK-47 I", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AK_SKIN"] = { 
        nome = "AK-47 K", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AL_SKIN"] = { 
        nome = "AK-47 L", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AM_SKIN"] = { 
        nome = "AK-47 M", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AN_SKIN"] = { 
        nome = "AK-47 N", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_AK47_AQ_SKIN"] = { 
        nome = "AK-47 Q", 
        arma = "WEAPON_ASSAULTRIFLE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_AD_SKIN"] = { 
        nome = "M4 Ad", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_AL_SKIN"] = { 
        nome = "M4 Al", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_AM_SKIN"] = { 
        nome = "M4 Am", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_AR_SKIN"] = { 
        nome = "M4 Ar", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_AS_SKIN"] = { 
        nome = "M4 As", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_COLT_SKIN"] = { 
        nome = "M4 Colt", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_DK_SKIN"] = { 
        nome = "M4 DK", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_DRAGON_SKIN"] = { 
        nome = "M4 Dragon", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_GR_SKIN"] = { 
        nome = "M4 Green", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_HUNTER_SKIN"] = { 
        nome = "M4 Hunter", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_M4_W_SKIN"] = { 
        nome = "M4 White", 
        arma = "WEAPON_CARBINERIFLE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_BB"] = { 
        nome = "G3 BB", 
        arma = "WEAPON_SPECIALCARBINE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_CA"] = { 
        nome = "G3 CA", 
        arma = "WEAPON_SPECIALCARBINE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_PB"] = { 
        nome = "G3 PB", 
        arma = "WEAPON_SPECIALCARBINE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_RAE"] = { 
        nome = "G3 RAE", 
        arma = "WEAPON_SPECIALCARBINE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_SUB"] = { 
        nome = "G3 Sub", 
        arma = "WEAPON_SPECIALCARBINE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_BRIN"] = { 
        nome = "G3 Brin", 
        arma = "WEAPON_SPECIALCARBINE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_ANCI"] = { 
        nome = "G3 Anci", 
        arma = "WEAPON_SPECIALCARBINE", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_MK2_GP"] = { 
        nome = "G3 MK2 GP", 
        arma = "WEAPON_SPECIALCARBINE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_MK2_ONI"] = { 
        nome = "G3 MK2 Oni", 
        arma = "WEAPON_SPECIALCARBINE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_MK2_RGX"] = { 
        nome = "G3 MK2 RGX", 
        arma = "WEAPON_SPECIALCARBINE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_MK2_SAQ"] = { 
        nome = "G3 MK2 SAQ", 
        arma = "WEAPON_SPECIALCARBINE_MK2", 
        categoria = "Rifle"
    },
    ["COMPONENT_G3_MK2_SING"] = { 
        nome = "G3 MK2 Sing", 
        arma = "WEAPON_SPECIALCARBINE_MK2", 
        categoria = "Rifle"
    }
}