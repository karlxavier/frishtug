SELECT
  menus.id AS menu_id,
  menus.name,
  menus.price,
  menus.published,
  menus.unit_size,
  menus.unit_id,
  menus.item_number,
  menus.tax,
  menus.description,
  menus.asset_id,
  inventories.quantity,
  menus.menu_category_id,
  menu_categories.name AS menu_category_name,
  ARRAY(SELECT diet_categories.name
    FROM diet_categories
    INNER JOIN diet_categories_menus
    ON diet_categories_menus.diet_category_id = diet_categories.id
    AND diet_categories_menus.menu_id = menus.id) AS diet_categories
FROM
  menus
INNER JOIN
  menu_categories ON menu_categories.id = menus.menu_category_id
INNER JOIN
  units ON units.id = menus.unit_id
INNER JOIN
  inventories ON inventories.menu_id = menus.id
WHERE
  inventories.quantity != 0 AND menu_categories.part_of_plan = true
GROUP BY
  menu_categories.id,
  menus.id,
  inventories.quantity
ORDER BY
  menus.id DESC;