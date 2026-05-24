ALTER TABLE characters  
ADD COLUMN login INT(20) NOT NULL DEFAULT 0;

-- Copiando dados para a tabela night_blocklist
CREATE TABLE IF NOT EXISTS `blocklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) DEFAULT NULL,
  `Time` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Index 1` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela night_painel_extract
CREATE TABLE IF NOT EXISTS `painel_extract` (
  `org` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `passport` int(11) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela night_painel_orgs
CREATE TABLE IF NOT EXISTS `painel_orgs` (
  `org` varchar(50) NOT NULL,
  `value` int(3) DEFAULT 70,
  `bank` int(11) DEFAULT 0,
  PRIMARY KEY (`org`) USING BTREE,
  KEY `Index 2` (`org`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `painel_orgs` (`org`, `value`, `bank` ) VALUES
  ('Admin', 50, 0),
  ('Paramedic', 50, 0),
  ('Bombeiro', 50, 0),
  ('Mechanic', 50, 0),
  ('Mechanic2', 50, 0),
  ('CatCafe', 50, 0),
  ('Japanese', 50, 0),
  ('PMERJ', 50, 0),
  ('PCERJ', 50, 0),
  ('PRF', 50, 0),
  ('BOPE', 50, 0),
  ('RECOM', 50, 0),
  ('BPCHQ', 50, 0),
  ('EX', 50, 0),
  ('Maonegra', 50, 0),  
  ('Distrito', 50, 0),
  ('P77', 50, 0), 
  ('Mare', 50, 0), 
  ('Milicia', 50, 0), 
  ('Favela6', 50, 0), 
  ('Chernobyl', 50, 0), 
  ('Bairro13', 50, 0), 
  ('Dz7', 50, 0), 
  ('Labirinto', 50, 0), 
  ('Medellín', 50, 0), 
  ('Crateva', 50, 0), 
  ('Setor13', 50, 0), 
  ('Crips', 50, 0), 
  ('Grota', 50, 0);