vRP.Prepare("vieira_dominacao/create_table", [[
CREATE TABLE IF NOT EXISTS vieira_dominacao_territories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(128) NOT NULL,
  image_url VARCHAR(512) NOT NULL DEFAULT '',
  center_x DOUBLE NOT NULL,
  center_y DOUBLE NOT NULL,
  center_z DOUBLE NOT NULL,
  min_z DOUBLE NULL,
  max_z DOUBLE NULL,
  points_json LONGTEXT NOT NULL,
  owner_group VARCHAR(64) NULL DEFAULT NULL,
  cooldown_ends BIGINT NULL DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]])

vRP.Prepare("vieira_dominacao/list_all", [[
SELECT id, name, image_url, center_x, center_y, center_z, min_z, max_z, points_json,
       owner_group, cooldown_ends, created_at, updated_at
FROM vieira_dominacao_territories
ORDER BY name ASC;
]])

vRP.Prepare("vieira_dominacao/get_by_id", [[
SELECT id, name, image_url, center_x, center_y, center_z, min_z, max_z, points_json,
       owner_group, cooldown_ends, created_at, updated_at
FROM vieira_dominacao_territories
WHERE id = @id
LIMIT 1;
]])

vRP.Prepare("vieira_dominacao/insert", [[
INSERT INTO vieira_dominacao_territories
  (name, image_url, center_x, center_y, center_z, min_z, max_z, points_json, owner_group, cooldown_ends)
VALUES
  (@name, @image_url, @center_x, @center_y, @center_z, @min_z, @max_z, @points_json, NULL, NULL);
]])

vRP.Prepare("vieira_dominacao/update_meta", [[
UPDATE vieira_dominacao_territories
SET name = @name, image_url = @image_url
WHERE id = @id;
]])

vRP.Prepare("vieira_dominacao/update_geometry", [[
UPDATE vieira_dominacao_territories
SET center_x = @center_x, center_y = @center_y, center_z = @center_z,
    min_z = @min_z, max_z = @max_z, points_json = @points_json
WHERE id = @id;
]])

vRP.Prepare("vieira_dominacao/update_owner", [[
UPDATE vieira_dominacao_territories
SET owner_group = NULLIF(@owner_group, '')
WHERE id = @id;
]])

vRP.Prepare("vieira_dominacao/update_cooldown", [[
UPDATE vieira_dominacao_territories
SET cooldown_ends = @cooldown_ends
WHERE id = @id;
]])

vRP.Prepare("vieira_dominacao/clear_cooldown", [[
UPDATE vieira_dominacao_territories
SET cooldown_ends = NULL
WHERE id = @id;
]])

vRP.Prepare("vieira_dominacao/delete", [[
DELETE FROM vieira_dominacao_territories WHERE id = @id;
]])

CreateThread(function()
  Wait(250)
  local ok = vRP.Query("vieira_dominacao/create_table", {})
  if ok then
    print("^2[vieira_dominacao] Tabela vieira_dominacao_territories OK^0")
  else
    print("^1[vieira_dominacao] Falha ao criar tabela vieira_dominacao_territories^0")
  end
end)
