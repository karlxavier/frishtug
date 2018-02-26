SELECT
  users.id AS searchable_id,
  'Users' AS searchable_type,
  users.first_name AS term
FROM
  users

UNION

SELECT
  users.id AS searchable_id,
  'Users' AS searchable_type,
  users.last_name AS term
FROM
  users

UNION

SELECT
  users.id AS searchable_id,
  'Users' AS searchable_type,
  users.email AS term
FROM
  users

UNION

SELECT
  menus.id AS searchable_id,
  'Menus' AS searchable_type,
  menus.name AS term
FROM
  menus

UNION

SELECT
  menus.id AS searchable_id,
  'Menus' AS searchable_type,
  menus.description AS term
FROM
  menus

UNION

SELECT
  menus.id AS searchable_id,
  'Menus' AS searchable_type,
  menus.item_number AS term
FROM
  menus

UNION

SELECT
  orders.id AS searchable_id,
  'Orders' AS searchable_type,
  orders.sku AS term
FROM
  orders