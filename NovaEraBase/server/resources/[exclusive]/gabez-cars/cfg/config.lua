cfg = {}

cfg.comandoXenon = "xenon"
cfg.comandoNeon = "neon"
cfg.comandoSuspensao = "suspe"

cfg.permissaoParaInstalar = { existePermissao = fa, permissoes = { "Admin", "Mechanic", "Mechanic2" } }

-- cfg.blipsShopMec = {
-- 	{ loc = vec3(-183.86,-161.49,93.7), perms = { "Admin" } }
-- }

cfg.valores = {
	{ Item = "suspensionair", quantidade = 1, compra = 10000 },
	{ Item = "moduleneon",  quantidade = 1, compra = 5000 },
	{ Item = "modulexenon", quantidade = 1, compra = 5000 },
}

--vRP.GetSrvData (MUDAR ESSA FUNÇÃO PARA FUNCIONAR EM OUTRAS BASES)
--vRP.SetSrvData (MUDAR ESSA FUNÇÃO PARA FUNCIONAR EM OUTRAS BASES)