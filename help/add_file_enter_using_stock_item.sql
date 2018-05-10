ALTER TABLE `iclouderp_3_5_dev`.`erp_enter_using_stock_items`
ADD COLUMN `product_id` int(11) NULL AFTER `id`;

ALTER TABLE `iclouderp_3_5_dev`.`erp_enter_using_stock`
ADD COLUMN `is_return` tinyint(1) NULL AFTER `total_using_cost`;