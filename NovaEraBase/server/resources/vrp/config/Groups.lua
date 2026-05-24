-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
	["Admin"] = {
		["Parent"] = {
			["Admin"] = true
		},
		["Hierarchy"] = { "Fundador","Head-Staff","Admin","Moderador","Suporte" },
		["Service"] = {}
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- VIPS
-----------------------------------------------------------------------------------------------------------------------------------------
	["Premium"] = {
		["Parent"] = {
			["PremiumPlatina"] = true,
			["PremiumOuro"] = true,
			["PremiumPrata"] = true,
		},
		["Hierarchy"] = { "VIP" },
		["Service"] = {}
	},
	["PremiumPlatina"] = {
		["Parent"] = {
			["PremiumPlatina"] = true
		},
		["Hierarchy"] = { "Platina" },
		["Salary"] = { 5000 },
		["Service"] = {}
	},
	["PremiumOuro"] = {
		["Parent"] = {
			["PremiumOuro"] = true
		},
		["Hierarchy"] = { "Ouro" },
		["Salary"] = { 4000 },
		["Service"] = {}
	},
	["PremiumPrata"] = {
		["Parent"] = {
			["PremiumPrata"] = true
		},
		["Hierarchy"] = { "Prata" },
		["Salary"] = { 3000 },
		["Service"] = {}
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTROS
-----------------------------------------------------------------------------------------------------------------------------------------
	["Verify"] = {
		["Parent"] = {
			["Verify"] = true
		},
		["Hierarchy"] = { "Verify" },
		["Service"] = {}
	},
	["Streamer"] = {
		["Parent"] = {
			["Streamer"] = true
		},
		["Hierarchy"] = { "Streamer" },
		["Salary"] = { 2000 },
		["Service"] = {}
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
	["Policia"] = {
        ["Parent"] = {
            ["PMERJ"] = true,
            ["PCERJ"] = true,
            ["PRF"] = true,
            ["BOPE"] = true,
            ["RECOM"] = true,
            ["BPCHQ"] = true,
            ["EX"] = true
        },
        ["Hierarchy"] = { "Chefe" },
        ["Service"] = {}
    },
	["PMERJ"] = {
		["Parent"] = {
			["PMERJ"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 5000,4500,4000,3500,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["PCERJ"] = {
		["Parent"] = {
			["PCERJ"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 5000,4500,4000,3500,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["PRF"] = {
		["Parent"] = {
			["PRF"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 5000,4500,4000,3500,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["BOPE"] = {
		["Parent"] = {
			["BOPE"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 5000,4500,4000,3500,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["RECOM"] = {
		["Parent"] = {
			["RECOM"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 5000,4500,4000,3500,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["BPCHQ"] = {
		["Parent"] = {
			["BPCHQ"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 5000,4500,4000,3500,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["EX"] = {
		["Parent"] = {
			["EX"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 5000,4500,4000,3500,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- MECÂNICAS
-----------------------------------------------------------------------------------------------------------------------------------------
	["Mecanica"] = {
		["Parent"] = {
			["Mechanic"] = true,
			["Mechanic2"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Mechanic"] = {
		["Parent"] = {
			["Mechanic"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["Mechanic2"] = {
		["Parent"] = {
			["Mechanic2"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGÊNCIA
-----------------------------------------------------------------------------------------------------------------------------------------
	["Emergencia"] = {
		["Parent"] = {
			["Paramedic"] = true,
			["Bombeiro"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
    ["Paramedic"] = {
		["Parent"] = {
			["Paramedic"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,4250,4000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["Bombeiro"] = {
		["Parent"] = {
			["Bombeiro"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,4250,4000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTAURANTES
-----------------------------------------------------------------------------------------------------------------------------------------
	["Restaurantes"] = {
		["Parent"] = {
			["CatCafe"] = true,
			["Japanese"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["CatCafe"] = {
		["Parent"] = {
			["CatCafe"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
	["Japanese"] = {
		["Parent"] = {
			["Japanese"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work",
		["Ponto"] = true
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- FAVELAS
-----------------------------------------------------------------------------------------------------------------------------------------
	["Favelas"] = {
		["Parent"] = {
			["Maonegra"] = true,
			["Distrito"] = true,
			["P77"] = true,
			["Mare"] = true,
			["Milicia"] = true,
			["Favela6"] = true,
			["Chernobyl"] = true,
			["Bairro13"] = true,
			["Dz7"] = true,
			["Labirinto"] = true,
			["Medellín"] = true,
			["Crateva"] = true,
			["Setor13"] = true,
			["Crips"] = true,
			["Grota"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Maonegra"] = {
		["Parent"] = {
			["Maonegra"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Distrito"] = {
		["Parent"] = {
			["Distrito"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["P77"] = {
		["Parent"] = {
			["P77"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Mare"] = {
		["Parent"] = {
			["Mare"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Milicia"] = {
		["Parent"] = {
			["Milicia"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Favela6"] = {
		["Parent"] = {
			["Favela6"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Chernobyl"] = {
		["Parent"] = {
			["Chernobyl"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Bairro13"] = {
		["Parent"] = {
			["Bairro13"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Dz7"] = {
		["Parent"] = {
			["Dz7"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Labirinto"] = {
		["Parent"] = {
			["Labirinto"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Medellín"] = {
		["Parent"] = {
			["Medellín"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Crateva"] = {
		["Parent"] = {
			["Crateva"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Setor13"] = {
		["Parent"] = {
			["Setor13"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Crips"] = {
		["Parent"] = {
			["Crips"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Grota"] = {
		["Parent"] = {
			["Grota"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 4500,3500,3000 },
		["Service"] = {},
		["Type"] = "Work"
	}
}