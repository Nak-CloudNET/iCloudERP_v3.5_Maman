

-- ----------------------------
-- Table structure for erp_account_settings
-- ----------------------------
DROP TABLE IF EXISTS `erp_account_settings`;
CREATE TABLE `erp_account_settings` (
  `id` int(1) NOT NULL,
  `biller_id` int(11) NOT NULL DEFAULT '0',
  `default_open_balance` varchar(20) DEFAULT NULL,
  `default_sale` varchar(20) DEFAULT 'yes',
  `default_sale_discount` varchar(20) DEFAULT NULL,
  `default_sale_tax` varchar(20) DEFAULT NULL,
  `default_sale_freight` varchar(20) DEFAULT NULL,
  `default_sale_deposit` varchar(20) DEFAULT NULL,
  `default_receivable` varchar(20) DEFAULT NULL,
  `default_purchase` varchar(20) DEFAULT NULL,
  `default_purchase_discount` varchar(20) DEFAULT NULL,
  `default_purchase_tax` varchar(20) DEFAULT NULL,
  `default_purchase_freight` varchar(20) DEFAULT NULL,
  `default_purchase_deposit` varchar(20) DEFAULT NULL,
  `default_payable` varchar(20) DEFAULT NULL,
  `default_stock` varchar(20) DEFAULT NULL,
  `default_stock_adjust` varchar(20) DEFAULT NULL,
  `default_cost` varchar(20) DEFAULT NULL,
  `default_payroll` varchar(20) DEFAULT NULL,
  `default_cash` varchar(20) DEFAULT NULL,
  `default_credit_card` varchar(20) DEFAULT NULL,
  `default_gift_card` varchar(20) DEFAULT NULL,
  `default_cheque` varchar(20) DEFAULT NULL,
  `default_loan` varchar(20) DEFAULT NULL,
  `default_retained_earnings` varchar(20) DEFAULT NULL,
  `default_cost_variant` varchar(20) DEFAULT NULL,
  `default_interest_income` varchar(20) DEFAULT NULL,
  `default_transfer_owner` varchar(20) DEFAULT NULL,
  `default_tax_expense` varchar(20) DEFAULT NULL,
  `default_vat_payable` varchar(20) DEFAULT NULL,
  `default_salary_tax_payable` varchar(20) DEFAULT NULL,
  `default_tax_duties_expense` varchar(20) DEFAULT NULL,
  `default_salary_expense` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`,`biller_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_adjustment_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_adjustment_items`;
CREATE TABLE `erp_adjustment_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `adjust_id` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` int(11) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `cost` decimal(19,4) DEFAULT '0.0000',
  `total_cost` decimal(19,4) DEFAULT '0.0000',
  `biller_id` int(11) DEFAULT '0',
  `count_id` int(11) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `adjust_id` (`adjust_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `count_id` (`count_id`) USING BTREE,
  KEY `serial_no` (`serial_no`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_adjustments
-- ----------------------------
DROP TABLE IF EXISTS `erp_adjustments`;
CREATE TABLE `erp_adjustments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reference_no` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` mediumtext,
  `attachment` varchar(55) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `count_id` int(11) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `total_cost` decimal(25,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `count_id` (`count_id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_bom
-- ----------------------------
DROP TABLE IF EXISTS `erp_bom`;
CREATE TABLE `erp_bom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `noted` varchar(200) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) NOT NULL,
  `reference_no` varchar(55) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_bom_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_bom_items`;
CREATE TABLE `erp_bom_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bom_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `quantity` decimal(25,4) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT '0.0000',
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `transfer_id` (`bom_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_brands
-- ----------------------------
DROP TABLE IF EXISTS `erp_brands`;
CREATE TABLE `erp_brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `image` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_calendar
-- ----------------------------
DROP TABLE IF EXISTS `erp_calendar`;
CREATE TABLE `erp_calendar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(55) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `activity` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `color` varchar(7) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_captcha
-- ----------------------------
DROP TABLE IF EXISTS `erp_captcha`;
CREATE TABLE `erp_captcha` (
  `captcha_id` bigint(13) unsigned NOT NULL AUTO_INCREMENT,
  `captcha_time` int(10) unsigned NOT NULL,
  `ip_address` varchar(16) NOT NULL DEFAULT '0',
  `word` varchar(20) NOT NULL,
  PRIMARY KEY (`captcha_id`) USING BTREE,
  KEY `word` (`word`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_cash_advances
-- ----------------------------
DROP TABLE IF EXISTS `erp_cash_advances`;
CREATE TABLE `erp_cash_advances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `emp_id` int(11) DEFAULT NULL,
  `amount` decimal(25,4) DEFAULT NULL,
  `paid_by` varchar(50) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `bank_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `reference` varchar(50) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `po_id` int(11) DEFAULT NULL,
  `payment_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_categories
-- ----------------------------
DROP TABLE IF EXISTS `erp_categories`;
CREATE TABLE `erp_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_id` int(11) DEFAULT NULL,
  `categories_note_id` varchar(100) DEFAULT NULL,
  `code` varchar(55) DEFAULT NULL,
  `name` varchar(55) DEFAULT NULL,
  `image` varchar(55) DEFAULT 'no_image.png',
  `jobs` tinyint(1) unsigned DEFAULT '1',
  `auto_delivery` tinyint(1) DEFAULT NULL,
  `ac_sale` varchar(20) DEFAULT NULL,
  `ac_cost` varchar(20) DEFAULT NULL,
  `ac_stock` varchar(20) DEFAULT NULL,
  `ac_stock_adj` varchar(20) DEFAULT NULL,
  `ac_wip` varchar(20) DEFAULT NULL,
  `ac_cost_variant` varchar(20) DEFAULT NULL,
  `ac_purchase` varchar(20) DEFAULT NULL,
  `prom_startdate` datetime DEFAULT NULL,
  `prom_enddate` datetime DEFAULT NULL,
  `prom_percentage` int(4) DEFAULT NULL,
  `type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_categories_group
-- ----------------------------
DROP TABLE IF EXISTS `erp_categories_group`;
CREATE TABLE `erp_categories_group` (
  `cate_id` int(11) DEFAULT NULL,
  `customer_group_id` int(11) DEFAULT NULL,
  `percent` double DEFAULT NULL,
  `sub_cate` int(11) DEFAULT '0',
  `cate_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_categories_note
-- ----------------------------
DROP TABLE IF EXISTS `erp_categories_note`;
CREATE TABLE `erp_categories_note` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_combine_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_combine_items`;
CREATE TABLE `erp_combine_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sale_deliveries_id` bigint(20) NOT NULL,
  `sale_deliveries_id_combine` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `sale_delivery_id` (`sale_deliveries_id`) USING BTREE,
  KEY `sale_deliveries_id_combine` (`sale_deliveries_id_combine`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_combo_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_combo_items`;
CREATE TABLE `erp_combo_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `item_code` varchar(20) DEFAULT NULL,
  `quantity` decimal(12,4) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `item_code` (`item_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_companies
-- ----------------------------
DROP TABLE IF EXISTS `erp_companies`;
CREATE TABLE `erp_companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `group_id` int(10) unsigned DEFAULT NULL,
  `group_name` varchar(20) DEFAULT NULL,
  `customer_group_id` int(11) DEFAULT NULL,
  `customer_group_name` varchar(100) DEFAULT NULL,
  `price_group_id` int(11) DEFAULT NULL,
  `name` varchar(55) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `company_kh` varchar(255) DEFAULT NULL,
  `name_kh` varchar(255) DEFAULT NULL,
  `vat_no` varchar(100) DEFAULT NULL,
  `group_areas_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `address_1` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `address_3` varchar(255) DEFAULT NULL,
  `address_4` varchar(255) DEFAULT NULL,
  `address_5` varchar(255) DEFAULT NULL,
  `address_kh` varchar(255) DEFAULT NULL,
  `sale_man` int(11) DEFAULT NULL,
  `city` varchar(55) DEFAULT NULL,
  `state` varchar(55) DEFAULT NULL,
  `postal_code` varchar(8) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `contact_person` varchar(150) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `cf1` varchar(100) DEFAULT NULL,
  `cf2` varchar(100) DEFAULT NULL,
  `cf3` varchar(100) DEFAULT NULL,
  `cf4` varchar(100) DEFAULT NULL,
  `cf5` varchar(100) DEFAULT NULL,
  `cf6` varchar(100) DEFAULT NULL,
  `invoice_footer` mediumtext,
  `payment_term` int(11) DEFAULT '0',
  `logo` varchar(255) DEFAULT 'logo.png',
  `award_points` int(11) DEFAULT '0',
  `deposit_amount` decimal(25,4) DEFAULT NULL,
  `status` char(20) DEFAULT NULL,
  `posta_card` char(50) DEFAULT NULL,
  `gender` char(10) DEFAULT NULL,
  `attachment` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `credit_limited` decimal(25,4) DEFAULT NULL,
  `business_activity` varchar(255) DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `village` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `sangkat` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `period` varchar(100) DEFAULT NULL,
  `amount` decimal(25,4) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `begining_balance` decimal(25,4) DEFAULT NULL,
  `biller_prefix` varchar(50) DEFAULT NULL,
  `wifi_code` varchar(50) DEFAULT NULL,
  `identify_date` date DEFAULT NULL,
  `public_charge_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `code` (`code`) USING BTREE,
  KEY `group_price_id` (`price_group_id`) USING BTREE,
  KEY `group_name` (`group_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_condition_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_condition_tax`;
CREATE TABLE `erp_condition_tax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(55) NOT NULL,
  `rate` decimal(12,4) NOT NULL,
  `min_salary` double(19,0) DEFAULT NULL,
  `max_salary` double(19,0) DEFAULT NULL,
  `reduct_tax` double(19,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_convert
-- ----------------------------
DROP TABLE IF EXISTS `erp_convert`;
CREATE TABLE `erp_convert` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(55) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `noted` varchar(200) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bom_id` int(11) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_convert_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_convert_items`;
CREATE TABLE `erp_convert_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `convert_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `quantity` decimal(25,4) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT '0.0000',
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `transfer_id` (`convert_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_costing
-- ----------------------------
DROP TABLE IF EXISTS `erp_costing`;
CREATE TABLE `erp_costing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `sale_item_id` int(11) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `delivery_item_id` int(11) DEFAULT NULL,
  `delivery_id` int(11) DEFAULT NULL,
  `purchase_item_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `purchase_net_unit_cost` decimal(25,4) DEFAULT NULL,
  `purchase_unit_cost` decimal(25,4) DEFAULT NULL,
  `sale_net_unit_price` decimal(25,4) DEFAULT NULL,
  `sale_unit_price` decimal(25,4) DEFAULT NULL,
  `quantity_balance` decimal(15,4) DEFAULT NULL,
  `inventory` tinyint(1) DEFAULT '0',
  `overselling` tinyint(1) DEFAULT '0',
  `option_id` int(11) DEFAULT NULL,
  `transaction_type` varchar(50) DEFAULT NULL,
  `transaction_id` varchar(50) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `sale_item_id` (`sale_item_id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `delivery_item_id` (`delivery_item_id`) USING BTREE,
  KEY `delivery_id` (`delivery_id`) USING BTREE,
  KEY `purchase_item_id` (`purchase_item_id`) USING BTREE,
  KEY `transaction_type` (`transaction_type`) USING BTREE,
  KEY `transaction_id` (`transaction_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_currencies
-- ----------------------------
DROP TABLE IF EXISTS `erp_currencies`;
CREATE TABLE `erp_currencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(5) DEFAULT NULL,
  `name` varchar(55) DEFAULT NULL,
  `in_out` tinyint(1) DEFAULT NULL,
  `rate` decimal(12,4) DEFAULT NULL,
  `auto_update` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_customer_groups
-- ----------------------------
DROP TABLE IF EXISTS `erp_customer_groups`;
CREATE TABLE `erp_customer_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `percent` int(11) DEFAULT NULL,
  `makeup_cost` tinyint(3) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_customer_public_charge
-- ----------------------------
DROP TABLE IF EXISTS `erp_customer_public_charge`;
CREATE TABLE `erp_customer_public_charge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `pub_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `amount` decimal(25,4) DEFAULT '0.0000',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `period` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `pub_id` (`pub_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_date_format
-- ----------------------------
DROP TABLE IF EXISTS `erp_date_format`;
CREATE TABLE `erp_date_format` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `js` varchar(20) DEFAULT NULL,
  `php` varchar(20) DEFAULT NULL,
  `sql` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_define_public_charge
-- ----------------------------
DROP TABLE IF EXISTS `erp_define_public_charge`;
CREATE TABLE `erp_define_public_charge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_deliveries
-- ----------------------------
DROP TABLE IF EXISTS `erp_deliveries`;
CREATE TABLE `erp_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_id` int(11) DEFAULT NULL,
  `do_reference_no` varchar(50) DEFAULT NULL,
  `sale_reference_no` varchar(50) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total_cost` decimal(8,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_count` int(4) unsigned zerofill DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `delivery_status` varchar(50) DEFAULT NULL,
  `delivery_by` int(11) DEFAULT NULL,
  `sale_status` varchar(50) DEFAULT NULL,
  `issued_sale_id` int(11) DEFAULT '0',
  `pos` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_delivery_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_delivery_items`;
CREATE TABLE `erp_delivery_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `delivery_id` int(11) DEFAULT NULL,
  `do_reference_no` varchar(50) DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `category_name` varchar(255) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `begining_balance` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `ending_balance` decimal(25,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `updated_count` int(4) unsigned zerofill DEFAULT NULL,
  `cost` decimal(8,6) unsigned zerofill DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sale_id` (`do_reference_no`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`do_reference_no`) USING BTREE,
  KEY `sale_id_2` (`do_reference_no`,`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_deposits
-- ----------------------------
DROP TABLE IF EXISTS `erp_deposits`;
CREATE TABLE `erp_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `company_id` int(11) DEFAULT NULL,
  `amount` decimal(25,4) DEFAULT NULL,
  `paid_by` varchar(50) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `bank_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `reference` varchar(50) DEFAULT NULL,
  `po_reference_no` varchar(50) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `so_id` int(11) DEFAULT NULL,
  `payment_id` int(11) DEFAULT NULL,
  `po_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `deposit_id` int(11) DEFAULT NULL,
  `opening` tinyint(1) unsigned zerofill DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `account_code` (`account_code`) USING BTREE,
  KEY `bank_code` (`bank_code`) USING BTREE,
  KEY `payment_id` (`payment_id`) USING BTREE,
  KEY `deposit_id` (`deposit_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_digital_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_digital_items`;
CREATE TABLE `erp_digital_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `digital_pro_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_document_photos
-- ----------------------------
DROP TABLE IF EXISTS `erp_document_photos`;
CREATE TABLE `erp_document_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `photo` varchar(100) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_documents
-- ----------------------------
DROP TABLE IF EXISTS `erp_documents`;
CREATE TABLE `erp_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `description` text,
  `brand_id` varchar(50) DEFAULT NULL,
  `category_id` varchar(50) DEFAULT NULL,
  `subcategory_id` varchar(50) DEFAULT NULL,
  `cost` decimal(50,0) DEFAULT NULL,
  `price` decimal(8,4) DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `image` varchar(150) DEFAULT NULL,
  `serial` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_employee_salary_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax`;
CREATE TABLE `erp_employee_salary_tax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL DEFAULT '0',
  `basic_salary` decimal(24,4) DEFAULT NULL,
  `amount_usd` decimal(24,4) DEFAULT NULL,
  `spouse` int(10) DEFAULT NULL,
  `minor_children` int(20) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `date_insert` date DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `location` varchar(300) DEFAULT NULL,
  `date_print` date NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `trigger_id` int(11) DEFAULT NULL,
  `tax_rate` double DEFAULT NULL,
  `salary_tax` double DEFAULT NULL,
  `salary_tobe_paid` double DEFAULT NULL,
  `declare_salary_tax` tinyint(1) NOT NULL DEFAULT '0',
  `tab` tinyint(1) DEFAULT NULL,
  `allowance` decimal(4,0) DEFAULT NULL,
  `allowance_tax` decimal(4,0) DEFAULT NULL,
  `remark_fb` mediumtext,
  `declare_tax` tinyint(1) DEFAULT '0',
  `hide_row` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `employee_id` (`employee_id`) USING BTREE,
  KEY `trigger_id` (`trigger_id`) USING BTREE,
  KEY `date_insert` (`date_insert`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_employee_salary_tax_small_taxpayers
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax_small_taxpayers`;
CREATE TABLE `erp_employee_salary_tax_small_taxpayers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL DEFAULT '0',
  `basic_salary` decimal(24,4) DEFAULT NULL,
  `amount_usd` decimal(24,4) DEFAULT NULL,
  `spouse` int(10) DEFAULT NULL,
  `minor_children` int(20) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `date_insert` date DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `location` varchar(300) DEFAULT NULL,
  `date_print` date NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `trigger_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_employee_salary_tax_small_taxpayers_trigger
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax_small_taxpayers_trigger`;
CREATE TABLE `erp_employee_salary_tax_small_taxpayers_trigger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL,
  `year_month` date NOT NULL,
  `isCompany` tinyint(1) unsigned NOT NULL,
  `updated_by` int(11) unsigned DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  `total_salary_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_cal_base_riel` decimal(24,2) DEFAULT NULL,
  `total_salary_tax_riel` decimal(24,2) DEFAULT NULL,
  `date_print` date DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `trigger_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_employee_salary_tax_trigger
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_salary_tax_trigger`;
CREATE TABLE `erp_employee_salary_tax_trigger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL,
  `year_month` varchar(15) NOT NULL,
  `isCompany` tinyint(1) unsigned NOT NULL,
  `updated_by` int(11) unsigned DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  `total_salary_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_usd` decimal(24,2) unsigned DEFAULT NULL,
  `total_salary_tax_cal_base_riel` decimal(24,2) DEFAULT NULL,
  `total_salary_tax_riel` decimal(24,2) DEFAULT NULL,
  `date_print` date NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `tab` tinyint(1) DEFAULT NULL,
  `total_allowance_tax` decimal(25,4) DEFAULT NULL,
  `reference_no_j` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `reference` (`reference_no`) USING BTREE,
  KEY `year_month` (`year_month`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_employee_type
-- ----------------------------
DROP TABLE IF EXISTS `erp_employee_type`;
CREATE TABLE `erp_employee_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(120) NOT NULL DEFAULT '',
  `code` varchar(30) DEFAULT NULL,
  `account_salary` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_enter_using_stock
-- ----------------------------
DROP TABLE IF EXISTS `erp_enter_using_stock`;
CREATE TABLE `erp_enter_using_stock` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `warehouse_id` int(5) DEFAULT NULL,
  `authorize_id` int(10) DEFAULT NULL,
  `employee_id` int(10) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `plan_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `shop` int(10) DEFAULT NULL,
  `account` int(20) DEFAULT NULL,
  `note` text,
  `create_by` int(10) DEFAULT NULL,
  `reference_no` varchar(255) DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL,
  `total_cost` decimal(25,4) DEFAULT NULL,
  `using_reference_no` varchar(255) DEFAULT NULL,
  `total_using_cost` decimal(25,4) DEFAULT NULL,
  `is_return` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `authorize_id` (`authorize_id`) USING BTREE,
  KEY `employee_id` (`employee_id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `plan_id` (`plan_id`) USING BTREE,
  KEY `address_id` (`address_id`) USING BTREE,
  KEY `create_by` (`create_by`) USING BTREE,
  KEY `reference_no` (`reference_no`(191)) USING BTREE,
  KEY `using_reference_no` (`using_reference_no`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_enter_using_stock_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_enter_using_stock_items`;
CREATE TABLE `erp_enter_using_stock_items` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` text,
  `reason` text,
  `qty_use` decimal(25,4) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `reference_no` varchar(255) DEFAULT NULL,
  `warehouse_id` int(10) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `qty_by_unit` decimal(25,4) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  `exp_cate_id` text,
  `option_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `code` (`code`(191)) USING BTREE,
  KEY `reference_no` (`reference_no`(191)) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_expense_categories
-- ----------------------------
DROP TABLE IF EXISTS `erp_expense_categories`;
CREATE TABLE `erp_expense_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(55) NOT NULL,
  `name` varchar(55) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_expenses
-- ----------------------------
DROP TABLE IF EXISTS `erp_expenses`;
CREATE TABLE `erp_expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reference` varchar(55) DEFAULT NULL,
  `amount` decimal(25,6) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `bank_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `tax` tinyint(3) DEFAULT '0',
  `status` varchar(55) DEFAULT '',
  `warehouse_id` int(11) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_expenses_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_expenses_audit`;
CREATE TABLE `erp_expenses_audit` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference` varchar(55) NOT NULL,
  `amount` decimal(25,6) NOT NULL,
  `note` varchar(1000) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `bank_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `tax` tinyint(3) DEFAULT '0',
  `status` varchar(55) DEFAULT '',
  `warehouse_id` int(11) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) NOT NULL,
  `audit_record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_type` varchar(55) NOT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_frequency
-- ----------------------------
DROP TABLE IF EXISTS `erp_frequency`;
CREATE TABLE `erp_frequency` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `day` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_gift_cards
-- ----------------------------
DROP TABLE IF EXISTS `erp_gift_cards`;
CREATE TABLE `erp_gift_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `card_no` varchar(20) DEFAULT NULL,
  `value` decimal(25,4) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(255) DEFAULT NULL,
  `balance` decimal(25,4) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `created_by` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `card_no` (`card_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_gift_cards_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_gift_cards_audit`;
CREATE TABLE `erp_gift_cards_audit` (
  `id` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `card_no` varchar(20) DEFAULT NULL,
  `value` decimal(25,4) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(255) DEFAULT NULL,
  `balance` decimal(25,4) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `created_by` varchar(55) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `card_no` (`card_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_gl_charts
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_charts`;
CREATE TABLE `erp_gl_charts` (
  `accountcode` int(11) NOT NULL DEFAULT '0',
  `accountname` varchar(200) DEFAULT '',
  `parent_acc` int(11) DEFAULT '0',
  `sectionid` int(11) DEFAULT '0',
  `account_tax_id` int(11) DEFAULT '0',
  `acc_level` int(11) DEFAULT '0',
  `lineage` varchar(500) DEFAULT NULL,
  `bank` tinyint(1) DEFAULT NULL,
  `value` decimal(55,2) DEFAULT '0.00',
  PRIMARY KEY (`accountcode`) USING BTREE,
  KEY `AccountCode` (`accountcode`) USING BTREE,
  KEY `AccountName` (`accountname`(191)) USING BTREE,
  KEY `parent_acc` (`parent_acc`) USING BTREE,
  KEY `sectionid` (`sectionid`) USING BTREE,
  KEY `account_tax_id` (`account_tax_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_gl_charts_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_charts_tax`;
CREATE TABLE `erp_gl_charts_tax` (
  `account_tax_id` int(11) NOT NULL AUTO_INCREMENT,
  `accountcode` varchar(19) DEFAULT '0',
  `accountname` varchar(200) DEFAULT '',
  `accountname_kh` varchar(250) DEFAULT '0',
  `sectionid` int(11) DEFAULT '0',
  PRIMARY KEY (`account_tax_id`) USING BTREE,
  KEY `AccountCode` (`accountcode`) USING BTREE,
  KEY `AccountName` (`accountname`(191)) USING BTREE,
  KEY `sectionid` (`sectionid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_gl_sections
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_sections`;
CREATE TABLE `erp_gl_sections` (
  `sectionid` int(11) NOT NULL DEFAULT '0',
  `sectionname` mediumtext,
  `sectionname_kh` mediumtext,
  `AccountType` char(2) DEFAULT NULL,
  `description` mediumtext,
  `pandl` int(11) DEFAULT '0',
  `order_stat` int(11) DEFAULT '0',
  PRIMARY KEY (`sectionid`) USING BTREE,
  KEY `sectionid` (`sectionid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_gl_trans
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_trans`;
CREATE TABLE `erp_gl_trans` (
  `tran_id` int(11) NOT NULL AUTO_INCREMENT,
  `tran_type` varchar(20) DEFAULT '0',
  `tran_no` bigint(20) DEFAULT '1',
  `tran_date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `sectionid` int(11) DEFAULT '0',
  `account_code` int(19) DEFAULT '0',
  `narrative` varchar(100) DEFAULT '',
  `amount` decimal(25,4) DEFAULT '0.0000',
  `reference_no` varchar(55) DEFAULT '',
  `description` varchar(250) DEFAULT '',
  `biller_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bank` tinyint(3) DEFAULT '0',
  `gov_tax` tinyint(3) DEFAULT '0',
  `reference_gov_tax` varchar(55) DEFAULT '',
  `people_id` int(11) DEFAULT NULL,
  `invoice_ref` varchar(55) DEFAULT NULL,
  `ref_type` int(11) DEFAULT NULL,
  `created_name` varchar(100) DEFAULT NULL,
  `created_type` varchar(10) DEFAULT NULL,
  `people` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `status_tax` varchar(50) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `payment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`tran_id`) USING BTREE,
  KEY `Account` (`account_code`) USING BTREE,
  KEY `TranDate` (`tran_date`) USING BTREE,
  KEY `TypeNo` (`tran_no`) USING BTREE,
  KEY `Type_and_Number` (`tran_type`,`tran_no`) USING BTREE,
  KEY `tran_id` (`tran_id`) USING BTREE,
  KEY `sectionid` (`sectionid`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `payment_id` (`payment_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=333 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_gl_trans_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_gl_trans_audit`;
CREATE TABLE `erp_gl_trans_audit` (
  `tran_id` int(11) DEFAULT NULL,
  `tran_type` varchar(20) DEFAULT '0',
  `tran_no` bigint(20) DEFAULT '1',
  `tran_date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `sectionid` int(11) DEFAULT '0',
  `account_code` int(19) DEFAULT '0',
  `narrative` varchar(100) DEFAULT '',
  `amount` decimal(25,4) DEFAULT '0.0000',
  `reference_no` varchar(55) DEFAULT '',
  `description` varchar(250) DEFAULT '',
  `biller_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `bank` tinyint(3) DEFAULT '0',
  `gov_tax` tinyint(3) DEFAULT '0',
  `reference_gov_tax` varchar(55) DEFAULT '',
  `people_id` int(11) DEFAULT NULL,
  `invoice_ref` varchar(55) DEFAULT NULL,
  `ref_type` int(11) DEFAULT NULL,
  `created_name` varchar(100) DEFAULT NULL,
  `created_type` varchar(10) DEFAULT NULL,
  `people` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `status_tax` varchar(50) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `Account` (`account_code`) USING BTREE,
  KEY `TranDate` (`tran_date`) USING BTREE,
  KEY `TypeNo` (`tran_no`) USING BTREE,
  KEY `Type_and_Number` (`tran_type`,`tran_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_group_areas
-- ----------------------------
DROP TABLE IF EXISTS `erp_group_areas`;
CREATE TABLE `erp_group_areas` (
  `areas_g_code` int(3) NOT NULL AUTO_INCREMENT,
  `areas_group` varchar(100) DEFAULT '',
  PRIMARY KEY (`areas_g_code`) USING BTREE,
  KEY `group_area_code` (`areas_g_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_groups
-- ----------------------------
DROP TABLE IF EXISTS `erp_groups`;
CREATE TABLE `erp_groups` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_inventory_valuation_details
-- ----------------------------
DROP TABLE IF EXISTS `erp_inventory_valuation_details`;
CREATE TABLE `erp_inventory_valuation_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `sub_category_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `reference_no` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `cost` decimal(15,4) DEFAULT NULL,
  `qty_on_hand` decimal(15,4) DEFAULT NULL,
  `avg_cost` decimal(15,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `plan_id` int(11) DEFAULT NULL,
  `field_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `category_id` (`category_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1047 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_loans
-- ----------------------------
DROP TABLE IF EXISTS `erp_loans`;
CREATE TABLE `erp_loans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period` smallint(6) DEFAULT NULL,
  `dateline` date DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `reference_no` varchar(50) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `rated` varchar(255) DEFAULT NULL,
  `payment` decimal(25,10) DEFAULT NULL,
  `principle` decimal(25,10) DEFAULT NULL,
  `interest` decimal(25,10) DEFAULT NULL,
  `balance` decimal(25,10) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `paid_by` varchar(50) DEFAULT NULL,
  `paid_amount` decimal(25,4) DEFAULT NULL,
  `discount` decimal(25,4) DEFAULT NULL,
  `paid_date` datetime DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `account_code` varchar(20) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `updated_by` varchar(55) DEFAULT NULL,
  `total_service_charge` decimal(25,8) DEFAULT NULL,
  `other_amount` decimal(25,8) DEFAULT NULL,
  `overdue_days` int(5) DEFAULT NULL,
  `overdue_amount` decimal(25,8) DEFAULT NULL,
  `owed` double(25,8) DEFAULT NULL,
  `old_date` date DEFAULT NULL,
  `paid_interest` decimal(25,8) DEFAULT '0.00000000',
  `payment_status` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `account_code` (`account_code`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_login_attempts
-- ----------------------------
DROP TABLE IF EXISTS `erp_login_attempts`;
CREATE TABLE `erp_login_attempts` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varbinary(16) DEFAULT NULL,
  `login` varchar(100) DEFAULT NULL,
  `time` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_marchine
-- ----------------------------
DROP TABLE IF EXISTS `erp_marchine`;
CREATE TABLE `erp_marchine` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `type` varchar(20) DEFAULT '0',
  `biller_id` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `13` int(11) DEFAULT '0',
  `15` int(11) DEFAULT '0',
  `25` int(11) DEFAULT '0',
  `30` int(11) DEFAULT '0',
  `50` int(11) DEFAULT '0',
  `60` int(11) DEFAULT '0',
  `76` int(11) DEFAULT '0',
  `80` int(11) DEFAULT '0',
  `100` int(11) DEFAULT '0',
  `120` int(11) DEFAULT '0',
  `150` int(11) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_marchine_logs
-- ----------------------------
DROP TABLE IF EXISTS `erp_marchine_logs`;
CREATE TABLE `erp_marchine_logs` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `marchine_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `old_number` int(11) DEFAULT NULL,
  `new_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_migrations
-- ----------------------------
DROP TABLE IF EXISTS `erp_migrations`;
CREATE TABLE `erp_migrations` (
  `version` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_notifications
-- ----------------------------
DROP TABLE IF EXISTS `erp_notifications`;
CREATE TABLE `erp_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` mediumtext,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `from_date` datetime DEFAULT NULL,
  `till_date` datetime DEFAULT NULL,
  `scope` tinyint(1) DEFAULT '3',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_order_loans
-- ----------------------------
DROP TABLE IF EXISTS `erp_order_loans`;
CREATE TABLE `erp_order_loans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period` smallint(6) DEFAULT NULL,
  `dateline` date DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `rated` varchar(255) DEFAULT NULL,
  `payment` decimal(25,10) DEFAULT NULL,
  `principle` decimal(25,10) DEFAULT NULL,
  `interest` decimal(25,10) DEFAULT NULL,
  `balance` decimal(25,10) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_order_ref
-- ----------------------------
DROP TABLE IF EXISTS `erp_order_ref`;
CREATE TABLE `erp_order_ref` (
  `ref_id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `so` int(11) DEFAULT '1' COMMENT 'sale order',
  `qu` int(11) DEFAULT '1' COMMENT 'quote',
  `po` int(11) DEFAULT '1' COMMENT 'purchase order',
  `to` int(11) DEFAULT '1' COMMENT 'transfer to',
  `pos` int(11) DEFAULT '1' COMMENT 'pos',
  `do` int(11) DEFAULT '1' COMMENT 'delivery order',
  `pay` int(11) DEFAULT '1' COMMENT 'expense payment',
  `re` int(11) DEFAULT '1' COMMENT 'sale return',
  `ex` int(11) DEFAULT '1' COMMENT 'expense',
  `sp` int(11) DEFAULT '1' COMMENT 'sale payement',
  `pp` int(11) DEFAULT '1' COMMENT 'purchase payment',
  `sl` int(11) DEFAULT '1' COMMENT 'sale loan',
  `tr` int(11) DEFAULT '1' COMMENT 'transfer',
  `rep` int(11) DEFAULT '1' COMMENT 'purchase return',
  `con` int(11) DEFAULT '1' COMMENT 'convert product',
  `pj` int(11) DEFAULT '1' COMMENT 'prouduct job',
  `sd` int(11) DEFAULT '1',
  `es` int(11) DEFAULT '1',
  `esr` int(11) DEFAULT '1',
  `sao` int(11) DEFAULT '1',
  `poa` int(11) DEFAULT '1',
  `pq` int(11) DEFAULT '1',
  `jr` int(11) DEFAULT NULL,
  `qa` int(11) DEFAULT '1',
  `st` int(11) DEFAULT '1',
  `adc` int(11) DEFAULT '1',
  `tx` int(11) unsigned DEFAULT '1' COMMENT 'TAX',
  `pro` int(11) DEFAULT NULL,
  `cus` int(11) DEFAULT NULL,
  `sup` int(11) DEFAULT NULL,
  `emp` int(11) DEFAULT NULL,
  `pn` int(11) DEFAULT '1',
  PRIMARY KEY (`ref_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_pack_lists
-- ----------------------------
DROP TABLE IF EXISTS `erp_pack_lists`;
CREATE TABLE `erp_pack_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pack_code` varchar(20) DEFAULT NULL,
  `name` varchar(55) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `parent` int(11) DEFAULT '0',
  `level` int(11) DEFAULT '0',
  `status` tinyint(3) DEFAULT '0',
  `cf1` varchar(255) DEFAULT NULL,
  `cf2` varchar(255) DEFAULT NULL,
  `cf3` varchar(255) DEFAULT NULL,
  `cf4` varchar(255) DEFAULT NULL,
  `cf5` varchar(255) DEFAULT NULL,
  `cf6` varchar(255) DEFAULT NULL,
  `cf7` varchar(255) DEFAULT NULL,
  `cf8` varchar(255) DEFAULT NULL,
  `cf9` varchar(255) DEFAULT NULL,
  `cf10` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_payment_term
-- ----------------------------
DROP TABLE IF EXISTS `erp_payment_term`;
CREATE TABLE `erp_payment_term` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(55) DEFAULT NULL,
  `due_day` int(11) DEFAULT '0',
  `due_day_for_discount` int(11) DEFAULT '0',
  `discount` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_payments
-- ----------------------------
DROP TABLE IF EXISTS `erp_payments`;
CREATE TABLE `erp_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_id` int(11) DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `deposit_id` int(11) DEFAULT NULL,
  `cash_advance_id` int(11) DEFAULT NULL,
  `purchase_deposit_id` int(11) DEFAULT NULL,
  `loan_id` int(11) DEFAULT NULL,
  `expense_id` int(11) DEFAULT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `transfer_owner_id` int(11) DEFAULT NULL,
  `reference_no` varchar(50) DEFAULT NULL,
  `paid_by` varchar(20) DEFAULT NULL,
  `cheque_no` varchar(20) DEFAULT NULL,
  `cc_no` varchar(20) DEFAULT NULL,
  `cc_holder` varchar(25) DEFAULT NULL,
  `cc_month` varchar(2) DEFAULT NULL,
  `cc_year` varchar(4) DEFAULT NULL,
  `cc_type` varchar(20) DEFAULT NULL,
  `amount` decimal(25,4) DEFAULT NULL,
  `pos_paid` decimal(25,4) DEFAULT '0.0000',
  `currency` varchar(3) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `pos_balance` decimal(25,4) DEFAULT '0.0000',
  `pos_paid_other` decimal(25,4) DEFAULT NULL,
  `pos_paid_other_rate` decimal(25,4) DEFAULT NULL,
  `approval_code` varchar(50) DEFAULT NULL,
  `purchase_return_id` int(11) DEFAULT NULL,
  `return_deposit_id` int(11) DEFAULT NULL,
  `extra_paid` decimal(25,4) DEFAULT NULL,
  `deposit_quote_id` int(11) DEFAULT NULL,
  `add_payment` tinyint(1) DEFAULT NULL,
  `discount_id` varchar(20) DEFAULT NULL,
  `discount` decimal(25,4) DEFAULT NULL,
  `tax` int(11) DEFAULT NULL,
  `commission` int(11) DEFAULT NULL,
  `bank_account` int(11) DEFAULT NULL,
  `created_by_name` varchar(100) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_count` int(4) unsigned zerofill DEFAULT NULL,
  `old_reference_no` varchar(50) DEFAULT NULL,
  `interest_paid` decimal(25,4) DEFAULT NULL,
  `opening` tinyint(1) unsigned zerofill DEFAULT '0',
  `principle_paid` decimal(25,4) DEFAULT NULL,
  `is_down_payment` int(11) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `return_id` (`return_id`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `deposit_id` (`deposit_id`) USING BTREE,
  KEY `purchase_deposit_id` (`purchase_deposit_id`) USING BTREE,
  KEY `loan_id` (`loan_id`) USING BTREE,
  KEY `expense_id` (`expense_id`) USING BTREE,
  KEY `transaction_id` (`transaction_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `bank_account` (`bank_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_payments_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_payments_audit`;
CREATE TABLE `erp_payments_audit` (
  `id` int(11) NOT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_id` int(11) DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `deposit_id` int(11) DEFAULT NULL,
  `purchase_deposit_id` int(11) DEFAULT NULL,
  `loan_id` int(11) DEFAULT NULL,
  `expense_id` int(11) DEFAULT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `reference_no` varchar(50) NOT NULL,
  `paid_by` varchar(20) NOT NULL,
  `cheque_no` varchar(20) DEFAULT NULL,
  `cc_no` varchar(20) DEFAULT NULL,
  `cc_holder` varchar(25) DEFAULT NULL,
  `cc_month` varchar(2) DEFAULT NULL,
  `cc_year` varchar(4) DEFAULT NULL,
  `cc_type` varchar(20) DEFAULT NULL,
  `amount` decimal(25,4) NOT NULL,
  `pos_paid` decimal(25,4) DEFAULT '0.0000',
  `currency` varchar(3) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `pos_balance` decimal(25,4) DEFAULT '0.0000',
  `pos_paid_other` decimal(25,4) DEFAULT NULL,
  `pos_paid_other_rate` decimal(25,4) DEFAULT NULL,
  `approval_code` varchar(50) DEFAULT NULL,
  `purchase_return_id` int(11) DEFAULT NULL,
  `return_deposit_id` int(11) DEFAULT NULL,
  `extra_paid` decimal(25,4) DEFAULT NULL,
  `deposit_quote_id` int(11) DEFAULT NULL,
  `add_payment` tinyint(1) DEFAULT NULL,
  `discount_id` varchar(20) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `tax` int(11) DEFAULT NULL,
  `commission` int(11) DEFAULT NULL,
  `bank_account` int(11) DEFAULT NULL,
  `created_by_name` varchar(100) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_count` int(4) unsigned zerofill NOT NULL,
  `old_reference_no` varchar(50) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) NOT NULL,
  `audit_record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `audit_type` varchar(55) NOT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_paypal
-- ----------------------------
DROP TABLE IF EXISTS `erp_paypal`;
CREATE TABLE `erp_paypal` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL,
  `paypal_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '2.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '3.9000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '4.4000',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_permissions
-- ----------------------------
DROP TABLE IF EXISTS `erp_permissions`;
CREATE TABLE `erp_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `products-index` tinyint(1) DEFAULT '0',
  `products-add` tinyint(1) DEFAULT '0',
  `products-edit` tinyint(1) DEFAULT '0',
  `products-delete` tinyint(1) DEFAULT '0',
  `products-cost` tinyint(1) DEFAULT '0',
  `products-price` tinyint(1) DEFAULT '0',
  `products-import` tinyint(1) DEFAULT '0',
  `products-export` tinyint(1) DEFAULT '0',
  `products_convert_add` tinyint(1) DEFAULT NULL,
  `products-items_convert` tinyint(1) DEFAULT NULL,
  `products_print_barcodes` tinyint(1) DEFAULT NULL,
  `products-using_stock` tinyint(1) DEFAULT NULL,
  `products-list_using_stock` tinyint(1) DEFAULT NULL,
  `products-count_stocks` tinyint(1) DEFAULT NULL,
  `product_import` tinyint(1) DEFAULT NULL,
  `products-import_quantity` tinyint(1) DEFAULT NULL,
  `products-import_price_cost` tinyint(1) DEFAULT NULL,
  `products-print_barcodes` tinyint(1) DEFAULT NULL,
  `products-return_list` tinyint(1) DEFAULT NULL,
  `products-sync_quantity` tinyint(1) DEFAULT NULL,
  `quotes-index` tinyint(1) DEFAULT '0',
  `quotes-add` tinyint(1) DEFAULT '0',
  `quotes-edit` tinyint(1) DEFAULT '0',
  `quotes-email` tinyint(1) DEFAULT '0',
  `quotes-delete` tinyint(1) DEFAULT '0',
  `quotes-pdf` tinyint(1) DEFAULT '0',
  `quotes-export` tinyint(1) DEFAULT '0',
  `quotes-import` tinyint(1) DEFAULT '0',
  `quotes-authorize` tinyint(1) DEFAULT NULL,
  `quotes-conbine_pdf` tinyint(1) DEFAULT NULL,
  `sales-index` tinyint(1) DEFAULT '0',
  `sales-add` tinyint(1) DEFAULT '0',
  `sales-edit` tinyint(1) DEFAULT '0',
  `sales-email` tinyint(1) DEFAULT '0',
  `sales-pdf` tinyint(1) DEFAULT '0',
  `sales-delete` tinyint(1) DEFAULT '0',
  `sales-export` tinyint(1) DEFAULT '0',
  `sales-import` tinyint(1) DEFAULT '0',
  `purchases-index` tinyint(1) DEFAULT '0',
  `purchases-add` tinyint(1) DEFAULT '0',
  `purchases-edit` tinyint(1) DEFAULT '0',
  `purchases-email` tinyint(1) DEFAULT '0',
  `purchases-pdf` tinyint(1) DEFAULT '0',
  `purchases-delete` tinyint(1) DEFAULT '0',
  `purchases-export` tinyint(1) DEFAULT '0',
  `purchases-import` tinyint(1) DEFAULT '0',
  `purchases-return_list` tinyint(1) DEFAULT NULL,
  `purchases-return_add` tinyint(1) DEFAULT NULL,
  `purchases-cost` tinyint(1) DEFAULT NULL,
  `purchases-price` tinyint(1) DEFAULT NULL,
  `purchases-opening_ap` tinyint(1) DEFAULT NULL,
  `purchases-expenses` tinyint(1) DEFAULT '0',
  `purchases-import_expanse` tinyint(1) DEFAULT NULL,
  `purchases-payments` tinyint(1) DEFAULT '0',
  `purchases-combine_pdf` tinyint(1) DEFAULT NULL,
  `purchases-supplier_balance` tinyint(1) DEFAULT NULL,
  `transfers-index` tinyint(1) DEFAULT '0',
  `transfers-add` tinyint(1) DEFAULT '0',
  `transfers-edit` tinyint(1) DEFAULT '0',
  `transfers-email` tinyint(1) DEFAULT '0',
  `transfers-delete` tinyint(1) DEFAULT '0',
  `transfers-pdf` tinyint(1) DEFAULT '0',
  `transfers-export` tinyint(1) DEFAULT '0',
  `transfers-import` tinyint(1) DEFAULT '0',
  `transfers-combine_pdf` tinyint(1) DEFAULT NULL,
  `customers-index` tinyint(1) DEFAULT '0',
  `customers-add` tinyint(1) DEFAULT '0',
  `customers-edit` tinyint(1) DEFAULT '0',
  `customers-delete` tinyint(1) DEFAULT '0',
  `customers-export` tinyint(1) DEFAULT '0',
  `customers-import` tinyint(1) DEFAULT '0',
  `suppliers-index` tinyint(1) DEFAULT '0',
  `suppliers-add` tinyint(1) DEFAULT '0',
  `suppliers-edit` tinyint(1) DEFAULT '0',
  `suppliers-delete` tinyint(1) DEFAULT '0',
  `suppliers-import` tinyint(1) DEFAULT '0',
  `suppliers-export` tinyint(1) DEFAULT '0',
  `sales-deliveries` tinyint(1) DEFAULT '0',
  `sales-add_delivery` tinyint(1) DEFAULT '0',
  `sales-edit_delivery` tinyint(1) DEFAULT '0',
  `sales-delete_delivery` tinyint(1) DEFAULT '0',
  `sales-pdf_delivery` tinyint(1) DEFAULT '0',
  `sales-email_delivery` tinyint(1) DEFAULT '0',
  `sales-export_delivery` tinyint(1) DEFAULT '0',
  `sales-import_delivery` tinyint(1) DEFAULT '0',
  `sales-gift_cards` tinyint(1) DEFAULT '0',
  `sales-add_gift_card` tinyint(1) DEFAULT '0',
  `sales-edit_gift_card` tinyint(1) DEFAULT '0',
  `sales-delete_gift_card` tinyint(1) DEFAULT '0',
  `sales-import_gift_card` tinyint(1) DEFAULT '0',
  `sales-export_gift_card` tinyint(1) DEFAULT '0',
  `sales-authorize` tinyint(1) DEFAULT NULL,
  `pos-index` tinyint(1) DEFAULT '0',
  `sales-return_sales` tinyint(1) DEFAULT '0',
  `reports-index` tinyint(1) DEFAULT '0',
  `reports-warehouse_stock` tinyint(1) DEFAULT '0',
  `reports-quantity_alerts` tinyint(1) DEFAULT '0',
  `reports-expiry_alerts` tinyint(1) DEFAULT '0',
  `reports-products` tinyint(1) DEFAULT '0',
  `reports-daily_sales` tinyint(1) DEFAULT '0',
  `reports-monthly_sales` tinyint(1) DEFAULT '0',
  `reports-sales` tinyint(1) DEFAULT '0',
  `reports-payments` tinyint(1) DEFAULT '0',
  `reports-purchases` tinyint(1) DEFAULT '0',
  `reports-profit_loss` tinyint(1) DEFAULT '0',
  `reports-customers` tinyint(1) DEFAULT '0',
  `reports-suppliers` tinyint(1) DEFAULT '0',
  `reports-staff` tinyint(1) DEFAULT '0',
  `reports-register` tinyint(1) DEFAULT '0',
  `reports-account` tinyint(1) DEFAULT '0',
  `sales-payments` tinyint(1) DEFAULT '0',
  `bulk_actions` tinyint(1) DEFAULT '0',
  `customers-deposits` tinyint(1) DEFAULT '0',
  `customers-delete_deposit` tinyint(1) DEFAULT '0',
  `products-adjustments` tinyint(1) DEFAULT '0',
  `accounts-index` tinyint(1) DEFAULT '0',
  `accounts-add` tinyint(1) DEFAULT '0',
  `accounts-edit` tinyint(1) DEFAULT '0',
  `accounts-delete` tinyint(1) DEFAULT '0',
  `accounts-import` tinyint(1) DEFAULT '0',
  `accounts-export` tinyint(1) DEFAULT '0',
  `account-list_receivable` tinyint(1) DEFAULT NULL,
  `account-list_ar_aging` tinyint(1) DEFAULT NULL,
  `account-ar_by_customer` tinyint(1) DEFAULT NULL,
  `account-bill_receipt` tinyint(1) DEFAULT NULL,
  `account-list_payable` tinyint(1) DEFAULT NULL,
  `account-list_ap_aging` tinyint(1) DEFAULT NULL,
  `account-ap_by_supplier` tinyint(1) DEFAULT NULL,
  `account-bill_payable` tinyint(1) DEFAULT NULL,
  `account-list_ac_head` tinyint(1) DEFAULT NULL,
  `account-add_ac_head` tinyint(1) DEFAULT NULL,
  `account-list_customer_deposit` tinyint(1) DEFAULT NULL,
  `account-add_customer_deposit` tinyint(1) DEFAULT NULL,
  `account-list_supplier_deposit` tinyint(1) DEFAULT NULL,
  `account-add_supplier_deposit` tinyint(1) DEFAULT NULL,
  `account_setting` tinyint(1) DEFAULT NULL,
  `sales-discount` tinyint(1) DEFAULT '0',
  `sales-price` tinyint(1) DEFAULT '0',
  `sales-opening_ar` tinyint(1) DEFAULT NULL,
  `sales-loan` tinyint(1) DEFAULT '0',
  `reports-daily_purchases` tinyint(1) DEFAULT '0',
  `reports-monthly_purchases` tinyint(1) DEFAULT '0',
  `room-index` tinyint(1) DEFAULT NULL,
  `room-add` tinyint(1) DEFAULT NULL,
  `room-edit` tinyint(1) DEFAULT NULL,
  `room-delete` tinyint(1) DEFAULT NULL,
  `room-import` tinyint(1) DEFAULT NULL,
  `room-export` tinyint(1) DEFAULT NULL,
  `sale-room-index` tinyint(1) DEFAULT NULL,
  `sale-room-add` tinyint(1) DEFAULT NULL,
  `sale-room-edit` tinyint(1) DEFAULT NULL,
  `sale-room-delete` tinyint(1) DEFAULT NULL,
  `sale-room-import` tinyint(1) DEFAULT NULL,
  `sale-room-export` tinyint(1) DEFAULT NULL,
  `sales-combine_pdf` tinyint(1) DEFAULT NULL,
  `sales-combine_delivery` tinyint(1) DEFAULT NULL,
  `sale_order-index` tinyint(1) DEFAULT NULL,
  `sale_order-add` tinyint(1) DEFAULT NULL,
  `sale_order-edit` tinyint(1) DEFAULT NULL,
  `sale_order-delete` tinyint(1) DEFAULT NULL,
  `sale_order-import` tinyint(1) DEFAULT NULL,
  `sale_order-export` tinyint(1) DEFAULT NULL,
  `sale_order-authorize` tinyint(1) DEFAULT NULL,
  `sale_order-combine_pdf` tinyint(1) DEFAULT NULL,
  `sale_order-price` tinyint(1) DEFAULT NULL,
  `sale_order-deposit` tinyint(1) DEFAULT NULL,
  `purchases_order-index` tinyint(1) DEFAULT NULL,
  `purchases_order-edit` tinyint(1) DEFAULT NULL,
  `purchases_order-add` tinyint(1) DEFAULT NULL,
  `purchases_order-delete` tinyint(1) DEFAULT NULL,
  `purchases_order-email` tinyint(1) DEFAULT NULL,
  `purchases_order-import` tinyint(1) DEFAULT NULL,
  `purchases_order-export` tinyint(1) DEFAULT NULL,
  `purchases_order-pdf` tinyint(1) DEFAULT NULL,
  `purchases_order-payments` tinyint(1) DEFAULT NULL,
  `purchases_order-expenses` tinyint(1) DEFAULT NULL,
  `purchase_order-cost` tinyint(1) DEFAULT NULL,
  `purchase_order-price` tinyint(1) DEFAULT NULL,
  `purchase_order-import_expanse` tinyint(1) DEFAULT NULL,
  `purchase_order-combine_pdf` tinyint(1) DEFAULT NULL,
  `purchase_order-authorize` tinyint(1) DEFAULT NULL,
  `purchase_request-index` tinyint(1) DEFAULT NULL,
  `purchase_request-add` tinyint(1) DEFAULT NULL,
  `purchase_request-edit` tinyint(1) DEFAULT NULL,
  `purchase_request-delete` tinyint(1) DEFAULT NULL,
  `purchase_request-export` tinyint(1) DEFAULT NULL,
  `purchase_request-import` tinyint(1) DEFAULT NULL,
  `purchase_request-cost` tinyint(1) DEFAULT NULL,
  `purchase_request-price` tinyint(1) DEFAULT NULL,
  `purchase_request-import_expanse` tinyint(1) DEFAULT NULL,
  `purchase_request-combine_pdf` tinyint(1) DEFAULT NULL,
  `purchase_request-authorize` tinyint(1) DEFAULT NULL,
  `users-index` tinyint(1) DEFAULT NULL,
  `users-edit` tinyint(1) DEFAULT NULL,
  `users-add` tinyint(1) DEFAULT NULL,
  `users-delete` tinyint(1) DEFAULT NULL,
  `users-import` tinyint(1) DEFAULT NULL,
  `users-export` tinyint(1) DEFAULT NULL,
  `drivers-index` tinyint(1) DEFAULT NULL,
  `drivers-edit` tinyint(1) DEFAULT NULL,
  `drivers-add` tinyint(1) DEFAULT NULL,
  `drivers-delete` tinyint(1) DEFAULT NULL,
  `drivers-import` tinyint(1) DEFAULT NULL,
  `drivers-export` tinyint(1) DEFAULT NULL,
  `employees-index` tinyint(1) DEFAULT NULL,
  `employees-edit` tinyint(1) DEFAULT NULL,
  `employees-add` tinyint(1) DEFAULT NULL,
  `employees-delete` tinyint(1) DEFAULT NULL,
  `employees-import` tinyint(1) DEFAULT NULL,
  `employees-export` tinyint(1) DEFAULT NULL,
  `projects-index` tinyint(1) DEFAULT NULL,
  `projects-edit` tinyint(1) DEFAULT NULL,
  `projects-add` tinyint(1) DEFAULT NULL,
  `projects-delete` tinyint(1) DEFAULT NULL,
  `projects-import` tinyint(1) DEFAULT NULL,
  `projects-export` tinyint(1) DEFAULT NULL,
  `product_report-index` tinyint(1) DEFAULT NULL,
  `product_report-quantity_alert` tinyint(1) DEFAULT NULL,
  `product_report-product` tinyint(1) DEFAULT NULL,
  `product_report-warehouse` tinyint(1) DEFAULT NULL,
  `product_report-in_out` tinyint(1) DEFAULT NULL,
  `product_report-monthly` tinyint(1) DEFAULT NULL,
  `product_report-daily` tinyint(1) DEFAULT NULL,
  `product_report-suppliers` tinyint(1) DEFAULT NULL,
  `product_report-customers` tinyint(1) DEFAULT NULL,
  `product_report-categories` tinyint(1) DEFAULT NULL,
  `product_report-categories_value` tinyint(1) DEFAULT NULL,
  `product_report-inventory_valuation_detail` tinyint(1) DEFAULT NULL,
  `product_report-product_value` varchar(1) DEFAULT NULL,
  `sale_report-index` tinyint(1) DEFAULT NULL,
  `sale_report-register` tinyint(1) DEFAULT NULL,
  `sale_report-daily` tinyint(1) DEFAULT NULL,
  `sale_report-monthly` tinyint(1) DEFAULT NULL,
  `sale_report-report_sale` tinyint(1) DEFAULT NULL,
  `sale_report-disccount` tinyint(1) DEFAULT NULL,
  `sale_report-by_delivery_person` tinyint(1) DEFAULT NULL,
  `sale_report-delivery_detail` tinyint(1) DEFAULT NULL,
  `sale_report-customer` tinyint(1) DEFAULT NULL,
  `sale_report-saleman` tinyint(1) DEFAULT NULL,
  `sale_report-saleman_detail` tinyint(1) DEFAULT NULL,
  `sale_report-staff` tinyint(1) DEFAULT NULL,
  `sale_report-supplier` tinyint(1) DEFAULT NULL,
  `sale_report-project` tinyint(1) DEFAULT NULL,
  `sale_report-detail` tinyint(1) DEFAULT NULL,
  `sale_report-by_invoice` tinyint(1) DEFAULT NULL,
  `sale_report-sale_profit` tinyint(1) DEFAULT NULL,
  `sale_report-room_table` tinyint(1) DEFAULT NULL,
  `sale_report-project_manager` tinyint(1) DEFAULT NULL,
  `sale_report-sale_payment_report` tinyint(1) DEFAULT NULL,
  `chart_report-index` tinyint(1) DEFAULT NULL,
  `chart_report-over_view` tinyint(1) DEFAULT NULL,
  `chart_report-warehouse_stock` tinyint(1) DEFAULT NULL,
  `chart_report-category_stock` tinyint(1) DEFAULT NULL,
  `chart_report-profit` tinyint(1) DEFAULT NULL,
  `chart_report-cash_analysis` tinyint(1) DEFAULT NULL,
  `chart_report-customize` tinyint(1) DEFAULT NULL,
  `chart_report-room_table` tinyint(1) DEFAULT NULL,
  `chart_report-suspend_profit_and_lose` tinyint(1) DEFAULT NULL,
  `account_report-index` tinyint(1) DEFAULT NULL,
  `account_report-ledger` tinyint(1) DEFAULT NULL,
  `account_report-trail_balance` tinyint(1) DEFAULT NULL,
  `account_report-journal` tinyint(1) DEFAULT NULL,
  `account_report-ac_injuiry_report` tinyint(1) DEFAULT NULL,
  `account_report-balance_sheet` tinyint(1) DEFAULT NULL,
  `account_report-bsh_by_month` tinyint(1) DEFAULT NULL,
  `account_report-bsh_by_year` tinyint(1) DEFAULT NULL,
  `account_report-bsh_by_project` tinyint(1) DEFAULT NULL,
  `account_report-bsh_by_budget` tinyint(1) DEFAULT NULL,
  `account_report-income_statement` tinyint(1) DEFAULT NULL,
  `account_report-income_statement_detail` tinyint(1) DEFAULT NULL,
  `account_report-ins_by_month` tinyint(1) DEFAULT NULL,
  `account_report-ins_by_year` tinyint(1) DEFAULT NULL,
  `account_report-ins_by_project` tinyint(1) DEFAULT NULL,
  `account_report-ins_by_budget` tinyint(1) DEFAULT NULL,
  `account_report-cash_flow_statement` tinyint(1) DEFAULT NULL,
  `account_report-cash_book` tinyint(1) DEFAULT NULL,
  `account_report-payment` tinyint(1) DEFAULT NULL,
  `report_profit-index` tinyint(1) DEFAULT NULL,
  `report_profit-payments` tinyint(1) DEFAULT NULL,
  `report_profit-profit_andOr_lose` tinyint(1) DEFAULT NULL,
  `report_profit-stock` tinyint(1) DEFAULT NULL,
  `report_profit-category` tinyint(1) DEFAULT NULL,
  `report_profit-sale_profit` tinyint(1) DEFAULT NULL,
  `report_profit-project` tinyint(1) DEFAULT NULL,
  `report_profit-project_profit` tinyint(1) DEFAULT NULL,
  `purchase_report-index` tinyint(1) DEFAULT NULL,
  `purchase_report-purchas` tinyint(1) DEFAULT NULL,
  `purchase_report-daily` tinyint(1) DEFAULT NULL,
  `purchase_report-monthly` tinyint(1) DEFAULT NULL,
  `purchase_report-supplier` tinyint(1) DEFAULT NULL,
  `purchase-authorize` tinyint(1) DEFAULT NULL,
  `product_using_stock` tinyint(1) DEFAULT NULL,
  `product_list_using_stock` tinyint(1) DEFAULT NULL,
  `product_return_list` tinyint(1) DEFAULT NULL,
  `sale_report-customer_transfers` tinyint(1) DEFAULT NULL,
  `purchases_add-expenses` tinyint(1) DEFAULT NULL,
  `customers_balance` tinyint(1) DEFAULT NULL,
  `report_convert` tinyint(1) DEFAULT NULL,
  `report_list_using_stock` tinyint(1) DEFAULT NULL,
  `report_transfers` tinyint(1) DEFAULT NULL,
  `product_stock_count` tinyint(1) DEFAULT NULL,
  `product_import_quantity` tinyint(1) DEFAULT NULL,
  `product_import_price_cost` varchar(1) DEFAULT NULL,
  `purchase_report-expense` varchar(1) DEFAULT NULL,
  `reports-product_top_sale` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_plan_address
-- ----------------------------
DROP TABLE IF EXISTS `erp_plan_address`;
CREATE TABLE `erp_plan_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_pos_register
-- ----------------------------
DROP TABLE IF EXISTS `erp_pos_register`;
CREATE TABLE `erp_pos_register` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) DEFAULT NULL,
  `cash_in_hand` decimal(25,4) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `total_cash` decimal(25,4) DEFAULT NULL,
  `total_cheques` int(11) DEFAULT NULL,
  `total_cc_slips` int(11) DEFAULT NULL,
  `total_cash_submitted` decimal(25,4) DEFAULT NULL,
  `total_cheques_submitted` int(11) DEFAULT NULL,
  `total_cc_slips_submitted` int(11) DEFAULT NULL,
  `total_member_slips` int(11) DEFAULT NULL,
  `total_member_slips_submitted` int(11) DEFAULT NULL,
  `total_voucher_slips` int(11) DEFAULT NULL,
  `total_voucher_slips_submitted` int(11) DEFAULT NULL,
  `note` mediumtext,
  `closed_at` timestamp NULL DEFAULT NULL,
  `transfer_opened_bills` varchar(50) DEFAULT NULL,
  `closed_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_pos_settings
-- ----------------------------
DROP TABLE IF EXISTS `erp_pos_settings`;
CREATE TABLE `erp_pos_settings` (
  `pos_id` int(1) NOT NULL,
  `cat_limit` int(11) NOT NULL,
  `pro_limit` int(11) NOT NULL,
  `default_category` int(11) NOT NULL,
  `default_customer` int(11) NOT NULL,
  `default_biller` int(11) NOT NULL,
  `display_time` varchar(3) NOT NULL DEFAULT 'yes',
  `cf_title1` varchar(255) DEFAULT NULL,
  `cf_title2` varchar(255) DEFAULT NULL,
  `cf_value1` varchar(255) DEFAULT NULL,
  `cf_value2` varchar(255) DEFAULT NULL,
  `receipt_printer` varchar(55) DEFAULT NULL,
  `cash_drawer_codes` varchar(55) DEFAULT NULL,
  `focus_add_item` varchar(55) DEFAULT NULL,
  `add_manual_product` varchar(55) DEFAULT NULL,
  `customer_selection` varchar(55) DEFAULT NULL,
  `add_customer` varchar(55) DEFAULT NULL,
  `toggle_category_slider` varchar(55) DEFAULT NULL,
  `toggle_subcategory_slider` varchar(55) DEFAULT NULL,
  `show_search_item` varchar(55) DEFAULT NULL,
  `product_unit` varchar(55) DEFAULT NULL,
  `cancel_sale` varchar(55) DEFAULT NULL,
  `suspend_sale` varchar(55) DEFAULT NULL,
  `print_items_list` varchar(55) DEFAULT NULL,
  `print_bill` varchar(55) DEFAULT NULL,
  `finalize_sale` varchar(55) DEFAULT NULL,
  `today_sale` varchar(55) DEFAULT NULL,
  `open_hold_bills` varchar(55) DEFAULT NULL,
  `close_register` varchar(55) DEFAULT NULL,
  `keyboard` tinyint(1) NOT NULL,
  `pos_printers` varchar(255) DEFAULT NULL,
  `java_applet` tinyint(1) NOT NULL,
  `product_button_color` varchar(20) NOT NULL DEFAULT 'default',
  `tooltips` tinyint(1) DEFAULT '1',
  `paypal_pro` tinyint(1) DEFAULT '0',
  `stripe` tinyint(1) DEFAULT '0',
  `rounding` tinyint(1) DEFAULT '0',
  `char_per_line` tinyint(4) DEFAULT '42',
  `pin_code` varchar(20) DEFAULT NULL,
  `purchase_code` varchar(100) DEFAULT 'purchase_code',
  `envato_username` varchar(50) DEFAULT 'envato_username',
  `version` varchar(10) DEFAULT '3.0.1.21',
  `show_item_img` tinyint(1) DEFAULT NULL,
  `pos_layout` tinyint(1) DEFAULT NULL,
  `display_qrcode` tinyint(1) DEFAULT NULL,
  `show_suspend_bar` tinyint(1) DEFAULT NULL,
  `show_payment_noted` tinyint(1) DEFAULT NULL,
  `payment_balance` tinyint(1) DEFAULT NULL,
  `authorize` tinyint(1) DEFAULT '0',
  `show_product_code` tinyint(1) unsigned DEFAULT '1',
  `auto_delivery` tinyint(1) unsigned DEFAULT '1',
  `in_out_rate` tinyint(1) DEFAULT '0',
  `discount` decimal(8,4) DEFAULT NULL,
  `count_cash` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`pos_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_position
-- ----------------------------
DROP TABLE IF EXISTS `erp_position`;
CREATE TABLE `erp_position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_price_groups
-- ----------------------------
DROP TABLE IF EXISTS `erp_price_groups`;
CREATE TABLE `erp_price_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_principles
-- ----------------------------
DROP TABLE IF EXISTS `erp_principles`;
CREATE TABLE `erp_principles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period` int(11) DEFAULT NULL,
  `term_type_id` int(11) DEFAULT NULL,
  `dateline` date DEFAULT '0000-00-00',
  `value` varchar(11) DEFAULT '0',
  `remark` varchar(150) DEFAULT NULL,
  `rate` decimal(11,0) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_product_note
-- ----------------------------
DROP TABLE IF EXISTS `erp_product_note`;
CREATE TABLE `erp_product_note` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(55) DEFAULT NULL,
  `name` varchar(55) DEFAULT NULL,
  `price` decimal(25,4) DEFAULT NULL,
  `image` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_product_photos
-- ----------------------------
DROP TABLE IF EXISTS `erp_product_photos`;
CREATE TABLE `erp_product_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `photo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_product_prices
-- ----------------------------
DROP TABLE IF EXISTS `erp_product_prices`;
CREATE TABLE `erp_product_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `unit_type` varchar(50) DEFAULT NULL,
  `price_group_id` int(11) DEFAULT NULL,
  `price` decimal(25,4) DEFAULT NULL,
  `currency_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `price_group_id` (`price_group_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_product_variants
-- ----------------------------
DROP TABLE IF EXISTS `erp_product_variants`;
CREATE TABLE `erp_product_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `name` varchar(55) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  `price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `qty_unit` decimal(15,4) DEFAULT NULL,
  `currentcy_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `currency_code` (`currentcy_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_products
-- ----------------------------
DROP TABLE IF EXISTS `erp_products`;
CREATE TABLE `erp_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `name_kh` varchar(50) DEFAULT NULL,
  `name` char(255) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `cost` decimal(25,8) DEFAULT NULL,
  `price` decimal(25,8) DEFAULT NULL,
  `alert_quantity` decimal(15,0) DEFAULT '20',
  `image` varchar(255) DEFAULT 'no_image.png',
  `category_id` int(11) DEFAULT NULL,
  `subcategory_id` int(11) DEFAULT NULL,
  `cf1` varchar(255) DEFAULT NULL,
  `cf2` varchar(255) DEFAULT NULL,
  `cf3` varchar(255) DEFAULT NULL,
  `cf4` varchar(255) DEFAULT NULL,
  `cf5` varchar(255) DEFAULT NULL,
  `cf6` varchar(255) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `tax_rate` int(11) DEFAULT NULL,
  `track_quantity` tinyint(1) DEFAULT '1',
  `details` varchar(1000) DEFAULT NULL,
  `warehouse` int(11) DEFAULT NULL,
  `barcode_symbology` varchar(55) DEFAULT 'code128',
  `file` varchar(100) DEFAULT NULL,
  `product_details` mediumtext,
  `tax_method` tinyint(1) DEFAULT '0',
  `type` varchar(55) DEFAULT 'standard',
  `supplier1` int(11) DEFAULT NULL,
  `supplier1price` decimal(25,4) DEFAULT NULL,
  `supplier2` int(11) DEFAULT NULL,
  `supplier2price` decimal(25,4) DEFAULT NULL,
  `supplier3` int(11) DEFAULT NULL,
  `supplier3price` decimal(25,4) DEFAULT NULL,
  `supplier4` int(11) DEFAULT NULL,
  `supplier4price` decimal(25,4) DEFAULT NULL,
  `supplier5` int(11) DEFAULT NULL,
  `supplier5price` decimal(25,4) DEFAULT NULL,
  `no` int(11) DEFAULT NULL,
  `promotion` tinyint(1) DEFAULT '0',
  `promo_price` varchar(10) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `supplier1_part_no` varchar(50) DEFAULT NULL,
  `supplier2_part_no` varchar(50) DEFAULT NULL,
  `supplier3_part_no` varchar(50) DEFAULT NULL,
  `supplier4_part_no` varchar(50) DEFAULT NULL,
  `supplier5_part_no` varchar(50) DEFAULT NULL,
  `currentcy_code` varchar(10) DEFAULT NULL,
  `inactived` tinyint(1) unsigned DEFAULT '0',
  `service_type` int(2) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `opening_stock` int(11) DEFAULT NULL,
  `contruction_status` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE,
  KEY `category_id` (`category_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `subcategory_id` (`subcategory_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_project_plan
-- ----------------------------
DROP TABLE IF EXISTS `erp_project_plan`;
CREATE TABLE `erp_project_plan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `plan` varchar(150) DEFAULT NULL,
  `reference_no` varchar(150) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_project_plan_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_project_plan_items`;
CREATE TABLE `erp_project_plan_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_plan_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(65) DEFAULT NULL,
  `product_name` varchar(250) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `quantity` decimal(25,8) DEFAULT NULL,
  `quantity_balance` decimal(25,8) DEFAULT NULL,
  `quantity_used` decimal(25,8) DEFAULT '0.00000000',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_promotion_categories
-- ----------------------------
DROP TABLE IF EXISTS `erp_promotion_categories`;
CREATE TABLE `erp_promotion_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `discount` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_promotions
-- ----------------------------
DROP TABLE IF EXISTS `erp_promotions`;
CREATE TABLE `erp_promotions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_public_charge_detail
-- ----------------------------
DROP TABLE IF EXISTS `erp_public_charge_detail`;
CREATE TABLE `erp_public_charge_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `amount` decimal(25,4) DEFAULT NULL,
  `pub_id` int(11) DEFAULT NULL,
  `period` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchase_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_items`;
CREATE TABLE `erp_purchase_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `delivery_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `product_type` varchar(55) DEFAULT NULL,
  `net_unit_cost` decimal(25,8) DEFAULT NULL,
  `quantity` decimal(15,8) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `tax_method` int(11) DEFAULT NULL,
  `item_tax` decimal(25,8) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(20) DEFAULT NULL,
  `discount` varchar(20) DEFAULT NULL,
  `item_discount` decimal(25,8) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `subtotal` decimal(25,8) DEFAULT NULL,
  `quantity_balance` decimal(15,8) DEFAULT '0.00000000',
  `date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `unit_cost` decimal(25,8) DEFAULT NULL,
  `real_unit_cost` decimal(25,8) DEFAULT NULL,
  `quantity_received` decimal(15,8) DEFAULT NULL,
  `supplier_part_no` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `job_name` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `convert_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `opening_stock` int(11) DEFAULT NULL,
  `create_id` int(11) DEFAULT NULL,
  `returned` decimal(15,8) DEFAULT NULL,
  `acc_cate_separate` tinyint(1) DEFAULT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `payment_of_profit_tax` int(10) DEFAULT NULL,
  `performance_royalty_intangible` int(10) DEFAULT NULL,
  `payment_interest_non_bank` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_fixed` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_non_fixed` int(10) DEFAULT NULL,
  `payment_rental_immovable_property` int(10) DEFAULT NULL,
  `payment_of_interest` int(10) DEFAULT NULL,
  `payment_royalty_rental_income_related` int(10) DEFAULT NULL,
  `payment_management_technical` int(10) DEFAULT NULL,
  `payment_dividend` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` int(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` int(10) DEFAULT NULL,
  `transaction_type` varchar(25) DEFAULT '' COMMENT 'Ex: SALE or PURCHASE',
  `transaction_id` int(11) DEFAULT NULL,
  `net_shipping` decimal(25,8) DEFAULT NULL,
  `cb_avg` decimal(25,8) DEFAULT '0.00000000' COMMENT '0',
  `cb_qty` decimal(25,8) DEFAULT '0.00000000' COMMENT '0',
  `product_noted` varchar(255) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `delivery_id` (`delivery_id`) USING BTREE,
  KEY `transfer_id` (`transfer_id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `tax_rate_id` (`tax_rate_id`) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `convert_id` (`convert_id`) USING BTREE,
  KEY `reference` (`reference`(191)) USING BTREE,
  KEY `transaction_id` (`transaction_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchase_items_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_items_audit`;
CREATE TABLE `erp_purchase_items_audit` (
  `id` int(11) DEFAULT NULL,
  `delivery_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `product_type` varchar(55) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(20) DEFAULT NULL,
  `discount` varchar(20) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `quantity_balance` decimal(15,4) DEFAULT '0.0000',
  `date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `supplier_part_no` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `job_name` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `convert_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `opening_stock` int(11) DEFAULT NULL,
  `create_id` int(11) DEFAULT NULL,
  `returned` decimal(15,4) DEFAULT NULL,
  `acc_cate_separate` tinyint(1) DEFAULT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `payment_of_profit_tax` int(10) DEFAULT NULL,
  `performance_royalty_intangible` int(10) DEFAULT NULL,
  `payment_interest_non_bank` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_fixed` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_non_fixed` int(10) DEFAULT NULL,
  `payment_rental_immovable_property` int(10) DEFAULT NULL,
  `payment_of_interest` int(10) DEFAULT NULL,
  `payment_royalty_rental_income_related` int(10) DEFAULT NULL,
  `payment_management_technical` int(10) DEFAULT NULL,
  `payment_dividend` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` int(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` int(10) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=965 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchase_order_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_order_items`;
CREATE TABLE `erp_purchase_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_cost` decimal(25,8) DEFAULT NULL,
  `quantity` decimal(15,8) DEFAULT NULL,
  `quantity_po` decimal(15,8) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `tax_method` int(11) DEFAULT NULL,
  `item_tax` decimal(25,8) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(20) DEFAULT NULL,
  `discount` varchar(20) DEFAULT NULL,
  `item_discount` decimal(25,8) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `subtotal` decimal(25,8) DEFAULT NULL,
  `quantity_balance` decimal(15,8) DEFAULT '0.00000000',
  `date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `unit_cost` decimal(25,8) DEFAULT NULL,
  `real_unit_cost` decimal(25,8) DEFAULT NULL,
  `quantity_received` decimal(15,8) unsigned DEFAULT '0.00000000',
  `supplier_part_no` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `price` decimal(25,8) DEFAULT NULL,
  `create_order` varchar(2) DEFAULT '0',
  `create_id` int(11) DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `transfer_id` (`transfer_id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `tax_rate_id` (`tax_rate_id`) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `create_id` (`create_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchase_request_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_request_items`;
CREATE TABLE `erp_purchase_request_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `delivery_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `product_type` varchar(55) DEFAULT NULL,
  `net_unit_cost` decimal(25,8) DEFAULT NULL,
  `quantity` decimal(15,8) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `tax_method` int(11) DEFAULT '0',
  `item_tax` decimal(25,8) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(20) DEFAULT NULL,
  `discount` varchar(20) DEFAULT NULL,
  `item_discount` decimal(25,8) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `subtotal` decimal(25,8) DEFAULT NULL,
  `quantity_balance` decimal(15,8) DEFAULT '0.00000000',
  `date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `unit_cost` decimal(25,8) DEFAULT NULL,
  `real_unit_cost` decimal(25,8) DEFAULT NULL,
  `quantity_received` decimal(15,8) DEFAULT NULL,
  `supplier_part_no` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `job_name` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `convert_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `opening_stock` int(11) DEFAULT NULL,
  `create_status` varchar(2) DEFAULT '0',
  `create_qty` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `delivery_id` (`delivery_id`) USING BTREE,
  KEY `transfer_id` (`transfer_id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `tax_rate_id` (`tax_rate_id`) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `convert_id` (`convert_id`) USING BTREE,
  KEY `reference` (`reference`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchase_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchase_tax`;
CREATE TABLE `erp_purchase_tax` (
  `vat_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(100) DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `purchase_id` varchar(10) DEFAULT NULL,
  `purchase_ref` varchar(100) DEFAULT NULL,
  `supplier_id` varchar(100) DEFAULT NULL,
  `issuedate` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `qty` double(25,4) DEFAULT NULL,
  `vatin` varchar(100) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `amount_tax` double DEFAULT NULL,
  `amount_declear` double DEFAULT NULL,
  `non_tax_pur` double(25,4) DEFAULT NULL,
  `tax_value` double(25,4) DEFAULT NULL,
  `vat` double(25,4) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_location` varchar(255) DEFAULT NULL,
  `journal_date` date DEFAULT NULL,
  `amount_tax_declare` decimal(25,4) DEFAULT NULL,
  `value_import` decimal(25,4) DEFAULT NULL,
  `purchase_type` tinyint(1) DEFAULT NULL,
  `status_tax` varchar(25) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `pns` tinyint(1) DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`vat_id`) USING BTREE,
  KEY `vat_id` (`vat_id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `purchase_ref` (`purchase_ref`) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `tax_id` (`tax_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchases
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchases`;
CREATE TABLE `erp_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `stotal` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `paid` decimal(25,4) DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `suspend_note` varchar(100) DEFAULT NULL,
  `reference_no_tax` varchar(100) DEFAULT NULL,
  `tax_status` varchar(100) DEFAULT NULL,
  `opening_ap` tinyint(1) DEFAULT '0',
  `type_of_po` varchar(50) DEFAULT NULL,
  `order_ref` varchar(50) DEFAULT NULL,
  `request_ref` varchar(50) DEFAULT NULL,
  `paid_by` varchar(15) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `account_code` varchar(20) DEFAULT '',
  `pur_refer` varchar(50) DEFAULT NULL,
  `purchase_type` int(1) DEFAULT NULL,
  `purchase_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `item_status` varchar(25) DEFAULT NULL,
  `container_no` varchar(50) DEFAULT NULL,
  `container_size` decimal(25,4) DEFAULT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `order_reference_no` int(50) DEFAULT NULL,
  `good_or_services` varchar(255) DEFAULT NULL,
  `acc_cate_separate` int(1) DEFAULT NULL,
  `cogs` decimal(25,4) DEFAULT NULL,
  `updated_count` int(4) unsigned zerofill DEFAULT '0000',
  `customer_id` int(11) DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `quote_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `reference_no_tax` (`reference_no_tax`) USING BTREE,
  KEY `order_ref` (`order_ref`) USING BTREE,
  KEY `request_ref` (`request_ref`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `account_code` (`account_code`) USING BTREE,
  KEY `pur_ref` (`pur_refer`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `quote_id` (`quote_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchases_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchases_audit`;
CREATE TABLE `erp_purchases_audit` (
  `id` int(11) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `paid` decimal(25,4) DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `suspend_note` varchar(100) DEFAULT NULL,
  `reference_no_tax` varchar(100) DEFAULT NULL,
  `tax_status` varchar(100) DEFAULT NULL,
  `opening_ap` tinyint(1) DEFAULT '0',
  `type_of_po` varchar(50) DEFAULT NULL,
  `order_ref` varchar(50) DEFAULT NULL,
  `request_ref` varchar(50) DEFAULT NULL,
  `paid_by` varchar(15) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `account_code` varchar(20) DEFAULT '',
  `pur_refer` varchar(50) DEFAULT NULL,
  `purchase_type` int(1) DEFAULT NULL,
  `purchase_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `item_status` varchar(25) DEFAULT NULL,
  `container_no` varchar(50) DEFAULT NULL,
  `container_size` decimal(25,4) DEFAULT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `order_reference_no` int(50) DEFAULT NULL,
  `good_or_services` varchar(255) DEFAULT NULL,
  `acc_cate_separate` int(1) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchases_order
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchases_order`;
CREATE TABLE `erp_purchases_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `purchase_ref` varchar(255) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `paid` decimal(25,4) DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `suspend_note` varchar(100) DEFAULT NULL,
  `reference_no_tax` varchar(100) DEFAULT NULL,
  `tax_status` varchar(100) DEFAULT NULL,
  `purchase_type` int(1) DEFAULT NULL,
  `purchase_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `order_status` varchar(15) DEFAULT 'pending',
  `request_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `purchase_ref` (`purchase_ref`(191)) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `request_id` (`request_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchases_order_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchases_order_audit`;
CREATE TABLE `erp_purchases_order_audit` (
  `id` int(11) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `purchase_ref` varchar(255) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `paid` decimal(25,4) DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `suspend_note` varchar(100) DEFAULT NULL,
  `reference_no_tax` varchar(100) DEFAULT NULL,
  `tax_status` varchar(100) DEFAULT NULL,
  `purchase_type` int(1) DEFAULT NULL,
  `purchase_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `order_status` varchar(15) DEFAULT 'pending',
  `request_id` int(11) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchases_request
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchases_request`;
CREATE TABLE `erp_purchases_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_discount` decimal(25,4) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT NULL,
  `product_tax` decimal(25,4) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `paid` decimal(25,4) DEFAULT '0.0000',
  `status` varchar(55) DEFAULT '',
  `payment_status` varchar(20) DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `suspend_note` varchar(100) DEFAULT NULL,
  `reference_no_tax` varchar(100) DEFAULT NULL,
  `tax_status` varchar(100) DEFAULT NULL,
  `opening_ap` tinyint(1) DEFAULT '0',
  `order_status` varchar(20) DEFAULT 'pending',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `reference_no_tax` (`reference_no_tax`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_purchasing_taxes
-- ----------------------------
DROP TABLE IF EXISTS `erp_purchasing_taxes`;
CREATE TABLE `erp_purchasing_taxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_id` int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `reference_no` varchar(255) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(150) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` varchar(150) DEFAULT NULL,
  `amount` decimal(24,4) DEFAULT NULL,
  `vat_id` int(11) DEFAULT NULL,
  `vat` decimal(24,4) DEFAULT NULL,
  `balance` decimal(24,4) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `status_tax` varchar(100) DEFAULT NULL,
  `remark_id` int(1) DEFAULT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `tax_type` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `insert_id` (`insert_id`) USING BTREE,
  KEY `reference_no` (`reference_no`(191)) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `invoice_no` (`invoice_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_quote_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_quote_items`;
CREATE TABLE `erp_quote_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quote_id` int(11) DEFAULT NULL,
  `digital_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `quantity_received` decimal(25,4) unsigned zerofill DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) unsigned zerofill DEFAULT NULL,
  `group_price_id` int(11) DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `expiry_id` int(11) DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `quote_id` (`quote_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_quotes
-- ----------------------------
DROP TABLE IF EXISTS `erp_quotes`;
CREATE TABLE `erp_quotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `biller` varchar(55) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `internal_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT NULL,
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier` varchar(55) DEFAULT NULL,
  `saleman` int(11) DEFAULT NULL,
  `issue_invoice` varchar(55) DEFAULT NULL,
  `project_manager` int(11) DEFAULT NULL,
  `quote_status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_reasons
-- ----------------------------
DROP TABLE IF EXISTS `erp_reasons`;
CREATE TABLE `erp_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position_id` int(11) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `description` mediumtext,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_related_products
-- ----------------------------
DROP TABLE IF EXISTS `erp_related_products`;
CREATE TABLE `erp_related_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(50) DEFAULT NULL,
  `related_product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `related_product_code` (`related_product_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_items`;
CREATE TABLE `erp_return_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) unsigned DEFAULT NULL,
  `return_id` int(11) unsigned DEFAULT NULL,
  `sale_item_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `unit_price` decimal(55,4) DEFAULT NULL,
  `unit_cost` decimal(25,8) DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`sale_id`) USING BTREE,
  KEY `sale_id_2` (`sale_id`,`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_purchase_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_purchase_items`;
CREATE TABLE `erp_return_purchase_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) unsigned NOT NULL,
  `return_id` int(11) unsigned NOT NULL,
  `purchase_item_id` int(11) DEFAULT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_code` varchar(55) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) NOT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `old_subtotal` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) NOT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`purchase_id`) USING BTREE,
  KEY `purchase_id_2` (`purchase_id`,`product_id`) USING BTREE,
  KEY `return_id` (`return_id`) USING BTREE,
  KEY `purcahse_item-id` (`purchase_item_id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_purchases
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_purchases`;
CREATE TABLE `erp_return_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL,
  `supplier` varchar(55) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `old_grand_total` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `paid` decimal(25,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  `shipping` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `purchase_id` (`purchase_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `supplier_id` (`supplier_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_sales
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_sales`;
CREATE TABLE `erp_return_sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `biller` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total_cost` decimal(25,4) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `paid` double(25,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_tax_back`;
CREATE TABLE `erp_return_tax_back` (
  `orderlineno` int(11) DEFAULT NULL,
  `tax_return_id` int(11) DEFAULT NULL,
  `itemcode` varchar(50) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `specific_tax` double DEFAULT NULL,
  `amount_tax` double DEFAULT NULL,
  `inv_num` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_tax_front
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_tax_front`;
CREATE TABLE `erp_return_tax_front` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `credit_lmonth04` double DEFAULT '0',
  `precaba_month05` double DEFAULT '0',
  `premonth_rate06` double DEFAULT '0',
  `crecarry_forward07` double DEFAULT '0',
  `preprofit_taxdue08` double DEFAULT '0',
  `sptax_calbase09` double DEFAULT '0',
  `sptax_duerate10` double DEFAULT '0',
  `sptax_calbase11` double DEFAULT '0',
  `sptax_duerate12` double DEFAULT '0',
  `taxacc_calbase13` double DEFAULT '0',
  `taxacc_duerate14` double DEFAULT '0',
  `taxpuli_calbase15` double DEFAULT '0',
  `specify` varchar(100) DEFAULT '',
  `taxpuli_duerate16` double DEFAULT '0',
  `tax_calbase17` double DEFAULT '0',
  `tax_duerate18` double DEFAULT '0',
  `total_taxdue19` double DEFAULT '0',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` int(11) DEFAULT '0',
  `month` int(11) DEFAULT '0',
  `filed_in_kh` varchar(100) DEFAULT NULL,
  `filed_in_en` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_value_added_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_value_added_tax`;
CREATE TABLE `erp_return_value_added_tax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `pusa_act04` varchar(100) DEFAULT '',
  `tax_credit_premonth05` varchar(100) DEFAULT '',
  `ncredit_purch06` varchar(100) DEFAULT '',
  `strate_purch07` varchar(100) DEFAULT '',
  `strate_purch08` varchar(100) DEFAULT '',
  `strate_imports09` varchar(100) DEFAULT '',
  `strate_imports10` varchar(100) DEFAULT '',
  `total_intax11` varchar(100) DEFAULT '',
  `ntaxa_sales12` varchar(100) DEFAULT '',
  `exports13` varchar(100) DEFAULT '',
  `strate_sales14` varchar(100) DEFAULT '',
  `strate_sales15` varchar(100) DEFAULT '',
  `pay_difference16` varchar(100) DEFAULT '',
  `refund17` varchar(100) DEFAULT '',
  `credit_forward18` varchar(100) DEFAULT '',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` int(11) DEFAULT '0',
  `month` int(11) DEFAULT '0',
  `field_in_kh` varchar(100) DEFAULT NULL,
  `field_in_en` varchar(100) DEFAULT NULL,
  `state_change` tinyint(1) DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `created_by` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_value_added_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_value_added_tax_back`;
CREATE TABLE `erp_return_value_added_tax_back` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value_id` int(11) DEFAULT '0',
  `productid` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `inv_cust_desc` varchar(255) DEFAULT NULL,
  `supp_exp_inn` varchar(255) DEFAULT NULL,
  `val_vat` varchar(255) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `val_vat_g` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_withholding_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_withholding_tax`;
CREATE TABLE `erp_return_withholding_tax` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  `month` int(11) DEFAULT '0',
  `taxref` varchar(255) DEFAULT NULL,
  `field_in_kh` varchar(255) DEFAULT NULL,
  `field_in_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_withholding_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_withholding_tax_back`;
CREATE TABLE `erp_return_withholding_tax_back` (
  `withholding_id` varchar(10) DEFAULT NULL,
  `emp_code` varchar(100) DEFAULT NULL,
  `object_of_payment` varchar(255) DEFAULT NULL,
  `invoice_paynote` varchar(255) DEFAULT NULL,
  `amount_paid` double DEFAULT NULL,
  `tax_rate` double DEFAULT NULL,
  `withholding_tax` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_return_withholding_tax_front
-- ----------------------------
DROP TABLE IF EXISTS `erp_return_withholding_tax_front`;
CREATE TABLE `erp_return_withholding_tax_front` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `withholding_id` int(11) DEFAULT '0',
  `amount_paid` double DEFAULT '0',
  `tax_rate` double DEFAULT '1',
  `withholding_tax` double DEFAULT '0',
  `remarks` text,
  `type` varchar(10) DEFAULT NULL,
  `type_of_oop` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_revenues
-- ----------------------------
DROP TABLE IF EXISTS `erp_revenues`;
CREATE TABLE `erp_revenues` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `tax_type` varchar(255) NOT NULL,
  `revenue` varchar(255) NOT NULL,
  `goods_and_service` varchar(255) DEFAULT NULL,
  `description` text,
  `created_by` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_salary_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_salary_tax`;
CREATE TABLE `erp_salary_tax` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT '0',
  `covreturn_start` date DEFAULT NULL,
  `covreturn_end` date DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `year` int(11) DEFAULT '0',
  `month` int(11) DEFAULT '0',
  `filed_in_kh` varchar(255) DEFAULT '0',
  `filed_in_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_salary_tax_back
-- ----------------------------
DROP TABLE IF EXISTS `erp_salary_tax_back`;
CREATE TABLE `erp_salary_tax_back` (
  `orderno` int(11) NOT NULL AUTO_INCREMENT,
  `salary_tax_id` int(11) NOT NULL,
  `empcode` varchar(50) DEFAULT '0',
  `salary_paid` double(25,8) DEFAULT NULL,
  `spouse` int(10) DEFAULT NULL,
  `minor_children` int(5) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `date_insert` date DEFAULT NULL,
  `tax_type` varchar(50) NOT NULL,
  `tax_rate` double(25,8) DEFAULT NULL,
  `tax_salary` double(25,8) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`orderno`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_salary_tax_front
-- ----------------------------
DROP TABLE IF EXISTS `erp_salary_tax_front`;
CREATE TABLE `erp_salary_tax_front` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `salary_tax_id` int(11) DEFAULT '0',
  `emp_num` int(11) DEFAULT '0',
  `salary_paid` double DEFAULT '0',
  `spouse_num` int(11) DEFAULT '0',
  `children_num` int(11) DEFAULT '0',
  `tax_salcalbase` double DEFAULT '0',
  `tax_rate` double DEFAULT '1',
  `tax_salary` double DEFAULT '0',
  `tax_type` char(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_areas
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_areas`;
CREATE TABLE `erp_sale_areas` (
  `areacode` int(3) NOT NULL AUTO_INCREMENT,
  `areadescription` varchar(100) DEFAULT '',
  `areas_g_code` varchar(100) DEFAULT '',
  PRIMARY KEY (`areacode`) USING BTREE,
  KEY `area_code` (`areacode`) USING BTREE,
  KEY `area_g_code` (`areas_g_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_dev_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_dev_items`;
CREATE TABLE `erp_sale_dev_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `category_name` varchar(255) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `machine_name` varchar(50) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `grand_total` decimal(25,4) DEFAULT NULL,
  `quantity_break` decimal(25,4) DEFAULT NULL,
  `quantity_index` decimal(25,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_1` int(11) DEFAULT NULL,
  `user_2` int(11) DEFAULT NULL,
  `user_3` int(11) DEFAULT NULL,
  `user_4` int(11) DEFAULT NULL,
  `user_5` int(11) DEFAULT NULL,
  `user_6` int(11) DEFAULT NULL,
  `user_7` int(11) DEFAULT NULL,
  `user_8` int(11) DEFAULT NULL,
  `user_9` int(11) DEFAULT NULL,
  `cf1` varchar(20) DEFAULT NULL,
  `cf2` varchar(20) DEFAULT NULL,
  `cf3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`sale_id`) USING BTREE,
  KEY `sale_id_2` (`sale_id`,`product_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_dev_items_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_dev_items_audit`;
CREATE TABLE `erp_sale_dev_items_audit` (
  `id` int(11) NOT NULL,
  `sale_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `option_id` int(11) DEFAULT NULL,
  `category_name` varchar(255) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `machine_name` varchar(50) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) NOT NULL,
  `grand_total` decimal(25,4) DEFAULT NULL,
  `quantity_break` decimal(25,4) DEFAULT NULL,
  `quantity_index` decimal(25,4) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_1` int(11) DEFAULT NULL,
  `user_2` int(11) DEFAULT NULL,
  `user_3` int(11) DEFAULT NULL,
  `user_4` int(11) DEFAULT NULL,
  `user_5` int(11) DEFAULT NULL,
  `user_6` int(11) DEFAULT NULL,
  `user_7` int(11) DEFAULT NULL,
  `user_8` int(11) DEFAULT NULL,
  `user_9` int(11) DEFAULT NULL,
  `cf1` varchar(20) DEFAULT NULL,
  `cf2` varchar(20) DEFAULT NULL,
  `cf3` varchar(20) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) NOT NULL,
  `audit_record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_type` varchar(55) NOT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`sale_id`) USING BTREE,
  KEY `sale_id_2` (`sale_id`,`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_items`;
CREATE TABLE `erp_sale_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) unsigned DEFAULT NULL,
  `digital_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(255) DEFAULT NULL,
  `returned` decimal(15,4) DEFAULT NULL,
  `group_price_id` int(11) DEFAULT NULL,
  `acc_cate_separate` tinyint(1) DEFAULT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `payment_of_profit_tax` int(10) DEFAULT NULL,
  `performance_royalty_intangible` int(10) DEFAULT NULL,
  `payment_interest_non_bank` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_fixed` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_non_fixed` int(10) DEFAULT NULL,
  `payment_rental_immovable_property` int(10) DEFAULT NULL,
  `payment_of_interest` int(10) DEFAULT NULL,
  `payment_royalty_rental_income_related` int(10) DEFAULT NULL,
  `payment_management_technical` int(10) DEFAULT NULL,
  `payment_dividend` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` int(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` int(10) DEFAULT NULL,
  `order_status` int(25) DEFAULT NULL,
  `unit_cost` decimal(25,8) DEFAULT NULL,
  `quantity_balance` decimal(15,8) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `description` varchar(150) DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `expiry_id` int(11) DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`sale_id`) USING BTREE,
  KEY `sale_id_2` (`sale_id`,`product_id`) USING BTREE,
  KEY `digital_id` (`digital_id`) USING BTREE,
  KEY `category_id` (`category_id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `tax_rate_id` (`tax_rate_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_items_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_items_audit`;
CREATE TABLE `erp_sale_items_audit` (
  `id` int(11) DEFAULT NULL,
  `sale_id` int(11) unsigned DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  `returned` decimal(15,4) DEFAULT NULL,
  `group_price_id` int(11) DEFAULT NULL,
  `acc_cate_separate` tinyint(1) DEFAULT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `payment_of_profit_tax` int(10) DEFAULT NULL,
  `performance_royalty_intangible` int(10) DEFAULT NULL,
  `payment_interest_non_bank` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_fixed` int(10) DEFAULT NULL,
  `payment_interest_taxpayer_non_fixed` int(10) DEFAULT NULL,
  `payment_rental_immovable_property` int(10) DEFAULT NULL,
  `payment_of_interest` int(10) DEFAULT NULL,
  `payment_royalty_rental_income_related` int(10) DEFAULT NULL,
  `payment_management_technical` int(10) DEFAULT NULL,
  `payment_dividend` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` int(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` int(10) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`sale_id`) USING BTREE,
  KEY `sale_id_2` (`sale_id`,`product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_order
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_order`;
CREATE TABLE `erp_sale_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `quote_id` int(11) DEFAULT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `group_areas_id` int(10) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `biller` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `order_status` varchar(20) DEFAULT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_items` tinyint(4) DEFAULT NULL,
  `total_cost` decimal(25,4) DEFAULT NULL,
  `pos` tinyint(1) DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `suspend_note` varchar(20) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) DEFAULT NULL,
  `other_cur_paid_rate` decimal(25,0) DEFAULT '1',
  `other_cur_paid1` decimal(25,4) DEFAULT NULL,
  `other_cur_paid_rate1` decimal(25,4) DEFAULT NULL,
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) DEFAULT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) DEFAULT '0',
  `delivery_by` int(11) DEFAULT NULL,
  `sale_type` tinyint(1) DEFAULT NULL,
  `delivery_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `bill_to` varchar(255) DEFAULT NULL,
  `po` varchar(50) DEFAULT NULL,
  `project_manager` int(11) DEFAULT NULL,
  `assign_to_id` int(11) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `term` int(4) DEFAULT NULL,
  `interest_rate` double DEFAULT NULL,
  `frequency` int(11) DEFAULT NULL,
  `depreciation_type` int(11) DEFAULT NULL,
  `principle_type` int(11) DEFAULT NULL,
  `join_lease_id` int(11) DEFAULT NULL,
  `down_amount` decimal(25,4) DEFAULT NULL,
  `term_id` int(11) DEFAULT NULL,
  `principle_term` int(11) DEFAULT NULL,
  `installment_date` date DEFAULT NULL,
  `principle_amount` decimal(25,4) DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `quote_id` (`quote_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `group_areas_id` (`group_areas_id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `join_lease_id` (`join_lease_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_order_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_order_audit`;
CREATE TABLE `erp_sale_order_audit` (
  `id` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `quote_id` int(11) DEFAULT NULL,
  `reference_no` varchar(55) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `group_areas_id` int(10) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `biller` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `order_status` varchar(20) DEFAULT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_items` tinyint(4) DEFAULT NULL,
  `total_cost` decimal(25,4) DEFAULT NULL,
  `pos` tinyint(1) DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `suspend_note` varchar(20) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) DEFAULT NULL,
  `other_cur_paid_rate` decimal(25,0) DEFAULT '1',
  `other_cur_paid1` decimal(25,4) DEFAULT NULL,
  `other_cur_paid_rate1` decimal(25,4) DEFAULT NULL,
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) DEFAULT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) DEFAULT '0',
  `delivery_by` int(11) DEFAULT NULL,
  `sale_type` tinyint(1) DEFAULT NULL,
  `delivery_status` varchar(20) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `bill_to` varchar(255) DEFAULT NULL,
  `po` varchar(50) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_order_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_order_items`;
CREATE TABLE `erp_sale_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `digital_id` int(11) DEFAULT NULL,
  `sale_order_id` int(11) unsigned DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT '0.0000',
  `quantity` decimal(15,4) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  `group_price_id` int(11) DEFAULT NULL,
  `piece` double DEFAULT NULL,
  `wpiece` double DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `expiry_id` int(11) DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`sale_order_id`) USING BTREE,
  KEY `sale_id_2` (`sale_order_id`,`product_id`) USING BTREE,
  KEY `sale_order_id` (`sale_order_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `tax_rate_id` (`tax_rate_id`) USING BTREE,
  KEY `group_price_id` (`group_price_id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `expired_id` (`expiry_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_order_items_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_order_items_audit`;
CREATE TABLE `erp_sale_order_items_audit` (
  `id` int(11) DEFAULT NULL,
  `sale_order_id` int(11) unsigned DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `net_unit_price` decimal(25,4) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity_received` decimal(15,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  `group_price_id` int(11) DEFAULT NULL,
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) DEFAULT NULL,
  `audit_record_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `sale_id` (`sale_order_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `product_id_2` (`product_id`,`sale_order_id`) USING BTREE,
  KEY `sale_id_2` (`sale_order_id`,`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sale_tax
-- ----------------------------
DROP TABLE IF EXISTS `erp_sale_tax`;
CREATE TABLE `erp_sale_tax` (
  `vat_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(100) DEFAULT '',
  `sale_id` varchar(100) DEFAULT '',
  `customer_id` varchar(100) DEFAULT '',
  `issuedate` datetime DEFAULT NULL,
  `vatin` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `qty` double(8,4) DEFAULT NULL,
  `non_tax_sale` double(8,4) DEFAULT NULL,
  `value_export` double(8,4) DEFAULT NULL,
  `amound` double DEFAULT NULL,
  `amound_tax` double DEFAULT '0',
  `amound_declare` double(8,4) DEFAULT NULL,
  `tax_value` double(8,4) DEFAULT NULL,
  `vat` double(8,4) DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_date` date DEFAULT NULL,
  `journal_location` varchar(100) DEFAULT NULL,
  `referent_no` varchar(255) DEFAULT NULL,
  `amount_tax_declare` int(100) DEFAULT NULL,
  `tax_type` tinyint(1) DEFAULT NULL,
  `pns` int(2) DEFAULT NULL,
  `sale_type` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`vat_id`) USING BTREE,
  KEY `vat_id` (`vat_id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `tax_id` (`tax_id`) USING BTREE,
  KEY `referenct_no` (`referent_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sales
-- ----------------------------
DROP TABLE IF EXISTS `erp_sales`;
CREATE TABLE `erp_sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `group_areas_id` int(11) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `biller` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) DEFAULT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `delivery_status` varchar(50) DEFAULT NULL,
  `delivery_by` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_count` int(4) unsigned zerofill DEFAULT NULL,
  `total_items` tinyint(4) DEFAULT NULL,
  `total_cost` decimal(25,4) DEFAULT NULL,
  `pos` tinyint(1) DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `type` varchar(55) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) DEFAULT NULL,
  `other_cur_paid_rate` decimal(25,0) DEFAULT '1',
  `other_cur_paid1` decimal(25,4) DEFAULT NULL,
  `other_cur_paid_rate1` decimal(25,4) DEFAULT NULL,
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) DEFAULT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) DEFAULT '0',
  `sale_type` tinyint(1) DEFAULT NULL,
  `bill_to` varchar(255) DEFAULT NULL,
  `po` varchar(50) DEFAULT NULL,
  `suspend_note` varchar(255) DEFAULT NULL,
  `tax_type` varchar(40) DEFAULT NULL,
  `so_id` int(11) DEFAULT NULL,
  `revenues_type` int(10) DEFAULT NULL,
  `acc_cate_separate` tinyint(1) DEFAULT NULL,
  `hide_tax` tinyint(1) DEFAULT '0',
  `quote_id` int(11) DEFAULT NULL,
  `project_manager` int(11) DEFAULT NULL,
  `assign_to_id` int(11) DEFAULT NULL,
  `tax_reference_no` varchar(55) DEFAULT NULL,
  `service_date` varchar(20) DEFAULT NULL,
  `cheque_name` varchar(64) DEFAULT NULL,
  `term` int(4) DEFAULT NULL,
  `total_interest` double DEFAULT '0',
  `frequency` int(11) DEFAULT NULL,
  `depreciation_type` int(11) DEFAULT NULL,
  `principle_type` int(11) DEFAULT NULL,
  `queue` int(11) DEFAULT NULL,
  `deposit_so_id` int(11) DEFAULT NULL,
  `recieve_usd` decimal(25,4) DEFAULT NULL,
  `recieve_real` decimal(25,4) DEFAULT NULL,
  `join_lease_id` int(11) DEFAULT NULL,
  `term_id` int(11) DEFAULT NULL,
  `transfer_charge` decimal(25,4) DEFAULT NULL,
  `old_customer` varchar(255) DEFAULT NULL,
  `transfer_date` datetime DEFAULT NULL,
  `commision` decimal(25,4) DEFAULT NULL,
  `down_date` date DEFAULT NULL,
  `down_amount` decimal(25,4) DEFAULT NULL,
  `installment_date` date DEFAULT NULL,
  `principle_term` int(11) DEFAULT NULL,
  `principle_amount` decimal(25,4) DEFAULT NULL,
  `interest_rate` double(11,0) DEFAULT NULL,
  `assign_salesman_id` int(11) DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `saleman` (`saleman_by`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `updated_by` (`updated_by`) USING BTREE,
  KEY `group_areas_id` (`group_areas_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `so_id` (`so_id`) USING BTREE,
  KEY `quote_id` (`quote_id`) USING BTREE,
  KEY `deposit_so_id` (`deposit_so_id`) USING BTREE,
  KEY `join_lease_id` (`join_lease_id`) USING BTREE,
  KEY `Assign_to-id` (`assign_to_id`) USING BTREE,
  KEY `assign_to_saleman` (`assign_salesman_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sales_audit
-- ----------------------------
DROP TABLE IF EXISTS `erp_sales_audit`;
CREATE TABLE `erp_sales_audit` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` varchar(55) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `group_areas_id` int(11) DEFAULT NULL,
  `biller_id` int(11) NOT NULL,
  `biller` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `staff_note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) NOT NULL,
  `product_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount_id` varchar(20) DEFAULT NULL,
  `total_discount` decimal(25,4) DEFAULT '0.0000',
  `order_discount` decimal(25,4) DEFAULT '0.0000',
  `product_tax` decimal(25,4) DEFAULT '0.0000',
  `order_tax_id` int(11) DEFAULT NULL,
  `order_tax` decimal(25,4) DEFAULT '0.0000',
  `total_tax` decimal(25,4) DEFAULT '0.0000',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `grand_total` decimal(25,4) NOT NULL,
  `sale_status` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `payment_term` tinyint(4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `delivery_status` varchar(50) DEFAULT NULL,
  `delivery_by` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_count` int(4) unsigned zerofill NOT NULL,
  `total_items` tinyint(4) DEFAULT NULL,
  `total_cost` decimal(25,4) NOT NULL,
  `pos` tinyint(1) NOT NULL DEFAULT '0',
  `paid` decimal(25,4) DEFAULT '0.0000',
  `return_id` int(11) DEFAULT NULL,
  `surcharge` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `type` varchar(55) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `other_cur_paid` decimal(25,0) DEFAULT NULL,
  `other_cur_paid_rate` decimal(25,0) DEFAULT '1',
  `other_cur_paid1` decimal(25,4) DEFAULT NULL,
  `other_cur_paid_rate1` decimal(25,4) DEFAULT NULL,
  `saleman_by` int(11) DEFAULT NULL,
  `reference_no_tax` varchar(55) NOT NULL,
  `tax_status` varchar(255) DEFAULT NULL,
  `opening_ar` tinyint(1) DEFAULT '0',
  `sale_type` tinyint(1) DEFAULT NULL,
  `bill_to` varchar(255) DEFAULT NULL,
  `po` varchar(50) DEFAULT NULL,
  `suspend_note` varchar(255) DEFAULT NULL,
  `tax_type` varchar(40) DEFAULT NULL,
  `so_id` int(11) DEFAULT NULL,
  `revenues_type` int(10) DEFAULT NULL,
  `acc_cate_separate` tinyint(1) DEFAULT NULL,
  `hide_tax` tinyint(1) DEFAULT '0',
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_created_by` int(11) NOT NULL,
  `audit_record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_type` varchar(55) NOT NULL,
  PRIMARY KEY (`audit_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sales_types
-- ----------------------------
DROP TABLE IF EXISTS `erp_sales_types`;
CREATE TABLE `erp_sales_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_code` varchar(20) DEFAULT '',
  `type_name` varchar(100) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `Sales_Type` (`type_name`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `type_code` (`type_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_salesman_assign
-- ----------------------------
DROP TABLE IF EXISTS `erp_salesman_assign`;
CREATE TABLE `erp_salesman_assign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) NOT NULL DEFAULT '0',
  `customer_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `isClear` int(11) DEFAULT '0',
  `reference_no` varchar(100) DEFAULT '',
  `created_by` varchar(100) DEFAULT '',
  `saleman` varchar(100) DEFAULT NULL,
  `assign_date` datetime DEFAULT NULL,
  `getMoneyBy` varchar(100) DEFAULT NULL,
  `totalMoney` double DEFAULT NULL,
  `isCompleted` int(11) DEFAULT '0',
  `status` int(1) DEFAULT '0',
  `user_clear_date` date DEFAULT NULL,
  `admin_clear_date` date DEFAULT NULL,
  `clear_by` varchar(100) DEFAULT NULL,
  `status_assigned` int(1) DEFAULT NULL,
  `total_balance` decimal(25,8) DEFAULT NULL,
  `user_clear_amount` decimal(25,8) DEFAULT NULL,
  `tmpClear` decimal(25,8) DEFAULT NULL,
  `sm_amount_us` decimal(25,8) DEFAULT '0.00000000',
  `sm_amount_kh` decimal(25,8) DEFAULT '0.00000000',
  `sm_discount` decimal(25,8) DEFAULT '0.00000000',
  `sm_rate` double DEFAULT '0',
  `assign_to_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`sale_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `reference_no` (`reference_no`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `saleman_id` (`saleman`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_salesman_clear_money
-- ----------------------------
DROP TABLE IF EXISTS `erp_salesman_clear_money`;
CREATE TABLE `erp_salesman_clear_money` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) DEFAULT '0',
  `customer_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `receive_amount` double DEFAULT '0',
  `balance` double NOT NULL,
  `clear_amount` double DEFAULT '0',
  `clear_amoud_kh` double DEFAULT NULL,
  `clear_rate_kh` double DEFAULT NULL,
  `isClear` int(11) DEFAULT '0',
  `inv_num` varchar(100) DEFAULT '',
  `creatorby` varchar(100) DEFAULT '',
  `asign_num` varchar(100) DEFAULT NULL,
  `salesperson` varchar(100) DEFAULT NULL,
  `clear_date` date DEFAULT NULL,
  `saleman_id` int(11) DEFAULT NULL,
  `clear_num` varchar(250) DEFAULT NULL,
  `admin_discount` double NOT NULL,
  `admin_clear` double NOT NULL,
  `admin_clear_kh` double NOT NULL,
  `admin_clear_rate` double NOT NULL,
  `admin_clear_date` date DEFAULT NULL,
  `admin_clear_by` varchar(100) DEFAULT NULL,
  `currabrev` char(3) DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `discount` decimal(24,3) DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_serial
-- ----------------------------
DROP TABLE IF EXISTS `erp_serial`;
CREATE TABLE `erp_serial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `serial_number` varchar(150) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `warehouse` int(11) DEFAULT NULL,
  `serial_status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_sessions
-- ----------------------------
DROP TABLE IF EXISTS `erp_sessions`;
CREATE TABLE `erp_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ci_sessions_timestamp` (`timestamp`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_settings
-- ----------------------------
DROP TABLE IF EXISTS `erp_settings`;
CREATE TABLE `erp_settings` (
  `setting_id` int(1) NOT NULL,
  `logo` varchar(255) NOT NULL,
  `logo2` varchar(255) NOT NULL,
  `site_name` varchar(55) NOT NULL,
  `language` varchar(20) NOT NULL,
  `default_warehouse` int(2) NOT NULL,
  `accounting_method` tinyint(4) NOT NULL DEFAULT '0',
  `default_currency` varchar(10) NOT NULL,
  `default_tax_rate` int(2) NOT NULL,
  `rows_per_page` int(2) NOT NULL,
  `version` varchar(10) NOT NULL DEFAULT '1.0',
  `default_tax_rate2` int(11) NOT NULL DEFAULT '0',
  `dateformat` int(11) NOT NULL,
  `sales_prefix` varchar(20) DEFAULT NULL,
  `quote_prefix` varchar(20) DEFAULT NULL,
  `purchase_prefix` varchar(20) DEFAULT NULL,
  `transfer_prefix` varchar(20) DEFAULT NULL,
  `delivery_prefix` varchar(20) DEFAULT NULL,
  `payment_prefix` varchar(20) DEFAULT NULL,
  `return_prefix` varchar(20) DEFAULT NULL,
  `expense_prefix` varchar(20) DEFAULT NULL,
  `transaction_prefix` varchar(10) DEFAULT NULL,
  `stock_count_prefix` varchar(25) DEFAULT NULL,
  `project_plan_prefix` varchar(25) DEFAULT NULL,
  `adjust_cost_prefix` varchar(25) DEFAULT NULL,
  `item_addition` tinyint(1) NOT NULL DEFAULT '0',
  `theme` varchar(20) NOT NULL,
  `product_serial` tinyint(4) NOT NULL,
  `default_discount` int(11) NOT NULL,
  `product_discount` tinyint(1) NOT NULL DEFAULT '0',
  `discount_method` tinyint(4) NOT NULL,
  `tax1` tinyint(4) NOT NULL,
  `tax2` tinyint(4) NOT NULL,
  `overselling` tinyint(1) NOT NULL DEFAULT '0',
  `restrict_user` tinyint(4) NOT NULL DEFAULT '0',
  `restrict_calendar` tinyint(4) NOT NULL DEFAULT '0',
  `timezone` varchar(100) DEFAULT NULL,
  `iwidth` int(11) NOT NULL DEFAULT '0',
  `iheight` int(11) NOT NULL,
  `twidth` int(11) NOT NULL,
  `theight` int(11) NOT NULL,
  `watermark` tinyint(1) DEFAULT NULL,
  `reg_ver` tinyint(1) DEFAULT NULL,
  `allow_reg` tinyint(1) DEFAULT NULL,
  `reg_notification` tinyint(1) DEFAULT NULL,
  `auto_reg` tinyint(1) DEFAULT NULL,
  `protocol` varchar(20) NOT NULL DEFAULT 'mail',
  `mailpath` varchar(55) DEFAULT '/usr/sbin/sendmail',
  `smtp_host` varchar(100) DEFAULT NULL,
  `smtp_user` varchar(100) DEFAULT NULL,
  `smtp_pass` varchar(255) DEFAULT NULL,
  `smtp_port` varchar(10) DEFAULT '25',
  `smtp_crypto` varchar(10) DEFAULT NULL,
  `corn` datetime DEFAULT NULL,
  `customer_group` int(11) NOT NULL,
  `default_email` varchar(100) NOT NULL,
  `mmode` tinyint(1) NOT NULL,
  `bc_fix` tinyint(4) NOT NULL DEFAULT '0',
  `auto_detect_barcode` tinyint(1) NOT NULL DEFAULT '0',
  `captcha` tinyint(1) NOT NULL DEFAULT '1',
  `reference_format` tinyint(1) NOT NULL DEFAULT '1',
  `racks` tinyint(1) DEFAULT '0',
  `attributes` tinyint(1) NOT NULL DEFAULT '0',
  `product_expiry` tinyint(1) NOT NULL DEFAULT '0',
  `purchase_decimals` tinyint(2) NOT NULL DEFAULT '2',
  `decimals` tinyint(2) NOT NULL DEFAULT '2',
  `qty_decimals` tinyint(2) NOT NULL DEFAULT '2',
  `decimals_sep` varchar(2) NOT NULL DEFAULT '.',
  `thousands_sep` varchar(2) NOT NULL DEFAULT ',',
  `invoice_view` tinyint(1) DEFAULT '0',
  `default_biller` int(11) DEFAULT NULL,
  `envato_username` varchar(50) DEFAULT NULL,
  `purchase_code` varchar(100) DEFAULT NULL,
  `rtl` tinyint(1) DEFAULT '0',
  `each_spent` decimal(15,4) DEFAULT NULL,
  `ca_point` tinyint(4) DEFAULT NULL,
  `each_sale` decimal(15,4) DEFAULT NULL,
  `sa_point` tinyint(4) DEFAULT NULL,
  `update` tinyint(1) DEFAULT '0',
  `sac` tinyint(1) DEFAULT '0',
  `display_all_products` tinyint(1) DEFAULT '0',
  `display_symbol` tinyint(1) DEFAULT NULL,
  `symbol` varchar(50) DEFAULT NULL,
  `item_slideshow` tinyint(1) DEFAULT NULL,
  `barcode_separator` varchar(2) NOT NULL DEFAULT '_',
  `remove_expired` tinyint(1) DEFAULT '0',
  `sale_payment_prefix` varchar(20) DEFAULT NULL,
  `purchase_payment_prefix` varchar(20) DEFAULT NULL,
  `sale_loan_prefix` varchar(20) DEFAULT NULL,
  `auto_print` tinyint(1) DEFAULT '1',
  `returnp_prefix` varchar(20) DEFAULT NULL,
  `alert_day` tinyint(3) NOT NULL DEFAULT '0',
  `convert_prefix` varchar(20) DEFAULT NULL,
  `purchase_serial` tinyint(4) NOT NULL,
  `enter_using_stock_prefix` varchar(25) DEFAULT NULL,
  `enter_using_stock_return_prefix` varchar(25) DEFAULT NULL,
  `supplier_deposit_prefix` varchar(20) DEFAULT NULL,
  `sale_order_prefix` varchar(20) DEFAULT NULL,
  `boms_method` tinyint(1) DEFAULT '0',
  `separate_code` tinyint(1) DEFAULT NULL,
  `show_code` tinyint(1) DEFAULT NULL,
  `bill_to` tinyint(1) DEFAULT NULL,
  `show_po` tinyint(1) DEFAULT NULL,
  `show_company_code` tinyint(1) DEFAULT NULL,
  `purchase_order_prefix` varchar(20) DEFAULT NULL,
  `credit_limit` int(11) DEFAULT '0',
  `purchase_request_prefix` varchar(20) DEFAULT NULL,
  `acc_cate_separate` tinyint(1) DEFAULT NULL,
  `stock_deduction` varchar(10) DEFAULT NULL,
  `delivery` varchar(25) DEFAULT NULL,
  `authorization` varchar(50) DEFAULT NULL,
  `shipping` tinyint(1) DEFAULT '0',
  `separate_ref` varchar(50) DEFAULT NULL,
  `journal_prefix` varchar(50) DEFAULT NULL,
  `adjustment_prefix` varchar(50) DEFAULT NULL,
  `system_management` varchar(50) DEFAULT NULL,
  `table_item` varchar(20) DEFAULT NULL,
  `show_logo_invoice` tinyint(1) DEFAULT '1' COMMENT 'Show Logo On Invoice',
  `show_biller_name_invoice` tinyint(1) DEFAULT '1' COMMENT 'Show Biller Name on Footer Invoice',
  `tax_prefix` varchar(20) DEFAULT NULL COMMENT 'TAX Prefix',
  `project_code_prefix` varchar(20) DEFAULT NULL,
  `customer_code_prefix` varchar(20) DEFAULT NULL,
  `supplier_code_prefix` varchar(20) DEFAULT NULL,
  `employee_code_prefix` varchar(20) DEFAULT NULL,
  `allow_change_date` tinyint(1) DEFAULT NULL,
  `increase_stock_import` tinyint(1) DEFAULT NULL,
  `member_card_expiry` tinyint(1) DEFAULT NULL,
  `tax_calculate` tinyint(1) DEFAULT NULL,
  `business_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`setting_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_skrill
-- ----------------------------
DROP TABLE IF EXISTS `erp_skrill`;
CREATE TABLE `erp_skrill` (
  `id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `account_email` varchar(255) NOT NULL DEFAULT 'testaccount2@moneybookers.com',
  `secret_word` varchar(20) NOT NULL DEFAULT 'mbtest',
  `skrill_currency` varchar(3) NOT NULL DEFAULT 'USD',
  `fixed_charges` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_my` decimal(25,4) NOT NULL DEFAULT '0.0000',
  `extra_charges_other` decimal(25,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_stock_count_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_count_items`;
CREATE TABLE `erp_stock_count_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_count_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_variant` varchar(55) DEFAULT NULL,
  `product_variant_id` int(11) DEFAULT NULL,
  `expected` decimal(15,4) DEFAULT NULL,
  `counted` decimal(15,4) DEFAULT NULL,
  `cost` decimal(25,4) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `stock_count_id` (`stock_count_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_stock_counts
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_counts`;
CREATE TABLE `erp_stock_counts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reference_no` varchar(55) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `initial_file` varchar(50) DEFAULT NULL,
  `final_file` varchar(50) DEFAULT NULL,
  `brands` varchar(50) DEFAULT NULL,
  `brand_names` varchar(100) DEFAULT NULL,
  `categories` varchar(50) DEFAULT NULL,
  `category_names` varchar(100) DEFAULT NULL,
  `note` text,
  `products` int(11) DEFAULT NULL,
  `rows` int(11) DEFAULT NULL,
  `differences` int(11) DEFAULT NULL,
  `matches` int(11) DEFAULT NULL,
  `missing` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `finalized` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_stock_trans
-- ----------------------------
DROP TABLE IF EXISTS `erp_stock_trans`;
CREATE TABLE `erp_stock_trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biller_id` int(11) DEFAULT NULL,
  `purchase_item_id` int(10) unsigned DEFAULT '0',
  `tran_date` date DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) unsigned DEFAULT '0.00',
  `quantity_balance_unit` decimal(8,2) DEFAULT NULL,
  `tran_type` varchar(100) DEFAULT NULL,
  `tran_id` int(11) DEFAULT NULL,
  `tran_ref_type` varchar(100) DEFAULT NULL,
  `tran_ref_id` int(11) DEFAULT NULL,
  `manufacture_cost` decimal(25,8) unsigned DEFAULT '0.00000000',
  `freight_cost` decimal(25,8) unsigned DEFAULT '0.00000000',
  `raw_cost` decimal(25,8) unsigned DEFAULT '0.00000000',
  `labor_cost` decimal(25,8) unsigned DEFAULT '0.00000000',
  `overhead_cost` decimal(25,8) unsigned DEFAULT '0.00000000',
  `total_cost` decimal(25,8) unsigned DEFAULT '0.00000000',
  `is_close` tinyint(1) unsigned DEFAULT '0',
  `close_date` date DEFAULT NULL,
  `expired_date` date DEFAULT NULL,
  `serial` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2876 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_subcategories
-- ----------------------------
DROP TABLE IF EXISTS `erp_subcategories`;
CREATE TABLE `erp_subcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `code` varchar(55) DEFAULT NULL,
  `name` varchar(55) DEFAULT NULL,
  `image` varchar(55) DEFAULT 'no_image.png',
  `type` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_suspend_layout
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspend_layout`;
CREATE TABLE `erp_suspend_layout` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `suspend_id` int(20) NOT NULL,
  `order` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `suspend_id` (`suspend_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_suspended
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspended`;
CREATE TABLE `erp_suspended` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `floor` varchar(20) DEFAULT '0',
  `ppl_number` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_suspended_bills
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspended_bills`;
CREATE TABLE `erp_suspended_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `end_date` datetime DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `customer` varchar(55) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `order_discount_id` varchar(20) DEFAULT NULL,
  `order_tax_id` int(11) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `biller_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `suspend_id` int(11) DEFAULT '0',
  `suspend_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `customer_id` (`customer_id`) USING BTREE,
  KEY `order_tax_id` (`order_tax_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `suspend_id` (`suspend_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_suspended_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_suspended_items`;
CREATE TABLE `erp_suspended_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suspend_id` int(11) unsigned DEFAULT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `digital_id` int(11) DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `net_unit_price` decimal(25,4) DEFAULT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `unit_price` decimal(25,4) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT '0.0000',
  `warehouse_id` int(11) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `discount` varchar(55) DEFAULT NULL,
  `item_discount` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `serial_no` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `real_unit_price` decimal(25,4) DEFAULT NULL,
  `product_noted` varchar(30) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `printed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `suspend_id` (`suspend_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `digital_id` (`digital_id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `tax_rate_id` (`tax_rate_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_tax_exchange_rate
-- ----------------------------
DROP TABLE IF EXISTS `erp_tax_exchange_rate`;
CREATE TABLE `erp_tax_exchange_rate` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `usd` int(10) DEFAULT NULL,
  `salary_khm` int(50) DEFAULT NULL,
  `average_khm` varchar(50) DEFAULT NULL,
  `month` int(2) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  `tax_type` varchar(255) DEFAULT NULL,
  `usd_curency` varchar(255) DEFAULT NULL,
  `kh_curency` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_tax_purchase_vat
-- ----------------------------
DROP TABLE IF EXISTS `erp_tax_purchase_vat`;
CREATE TABLE `erp_tax_purchase_vat` (
  `vat_id` int(11) NOT NULL,
  `bill_num` varchar(100) DEFAULT NULL,
  `debtorno` varchar(100) DEFAULT NULL,
  `locationname` varchar(100) DEFAULT NULL,
  `issuedate` date DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `amount_tax` double DEFAULT NULL,
  `tax_id` int(11) DEFAULT NULL,
  `journal_location` varchar(255) DEFAULT NULL,
  `journal_date` date DEFAULT NULL,
  PRIMARY KEY (`vat_id`) USING BTREE,
  KEY `vat_id` (`vat_id`) USING BTREE,
  KEY `bill_num` (`bill_num`) USING BTREE,
  KEY `tax_id` (`tax_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_tax_rates
-- ----------------------------
DROP TABLE IF EXISTS `erp_tax_rates`;
CREATE TABLE `erp_tax_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  `rate` decimal(12,4) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_taxation_type_of_account
-- ----------------------------
DROP TABLE IF EXISTS `erp_taxation_type_of_account`;
CREATE TABLE `erp_taxation_type_of_account` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `account_code` int(10) NOT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` varchar(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` varchar(10) DEFAULT NULL,
  `account_tax_code` varchar(10) DEFAULT NULL,
  `deductible_expenses` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_taxation_type_of_product
-- ----------------------------
DROP TABLE IF EXISTS `erp_taxation_type_of_product`;
CREATE TABLE `erp_taxation_type_of_product` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `product_id` int(10) NOT NULL,
  `specific_tax_on_certain_merchandise_and_services` int(10) DEFAULT NULL,
  `accommodation_tax` int(10) DEFAULT NULL,
  `public_lighting_tax` int(10) DEFAULT NULL,
  `other_tax` int(10) DEFAULT NULL,
  `withholding_tax_on_resident` varchar(10) DEFAULT NULL,
  `withholding_tax_on_non_resident` varchar(10) DEFAULT NULL,
  `payment_of_profit_tax` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_term_types
-- ----------------------------
DROP TABLE IF EXISTS `erp_term_types`;
CREATE TABLE `erp_term_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_terms
-- ----------------------------
DROP TABLE IF EXISTS `erp_terms`;
CREATE TABLE `erp_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `day` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_transfer_customers
-- ----------------------------
DROP TABLE IF EXISTS `erp_transfer_customers`;
CREATE TABLE `erp_transfer_customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `old_customer` int(11) DEFAULT NULL,
  `new_customer` int(11) DEFAULT NULL,
  `grand_total` decimal(28,4) DEFAULT NULL,
  `paid` decimal(28,4) DEFAULT NULL,
  `transfer_charge` decimal(28,4) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `sale_id` (`sale_id`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_transfer_items
-- ----------------------------
DROP TABLE IF EXISTS `erp_transfer_items`;
CREATE TABLE `erp_transfer_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(55) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  `tax` varchar(55) DEFAULT NULL,
  `item_tax` decimal(25,4) DEFAULT NULL,
  `net_unit_cost` decimal(25,4) DEFAULT NULL,
  `subtotal` decimal(25,4) DEFAULT NULL,
  `quantity_balance` decimal(15,4) DEFAULT NULL,
  `unit_cost` decimal(25,4) DEFAULT NULL,
  `real_unit_cost` decimal(25,4) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `product_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `transfer_id` (`transfer_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `product_code` (`product_code`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `tax_rate_id` (`tax_rate_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_transfers
-- ----------------------------
DROP TABLE IF EXISTS `erp_transfers`;
CREATE TABLE `erp_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_no` varchar(55) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `from_warehouse_id` int(11) DEFAULT NULL,
  `from_warehouse_code` varchar(55) DEFAULT NULL,
  `from_warehouse_name` varchar(55) DEFAULT NULL,
  `to_warehouse_id` int(11) DEFAULT NULL,
  `to_warehouse_code` varchar(55) DEFAULT NULL,
  `to_warehouse_name` varchar(55) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `total` decimal(25,4) DEFAULT NULL,
  `total_tax` decimal(25,4) DEFAULT NULL,
  `grand_total` decimal(25,4) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `authorize_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `status` varchar(55) DEFAULT 'pending',
  `shipping` decimal(25,4) DEFAULT '0.0000',
  `attachment` varchar(55) DEFAULT NULL,
  `attachment1` varchar(55) DEFAULT NULL,
  `attachment2` varchar(55) DEFAULT NULL,
  `biller_id` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `transfer_no` (`transfer_no`) USING BTREE,
  KEY `from_warehouse_id` (`from_warehouse_id`) USING BTREE,
  KEY `from_warehouse_code` (`from_warehouse_code`) USING BTREE,
  KEY `to_warehouse_id` (`to_warehouse_id`) USING BTREE,
  KEY `to_warehouse_code` (`to_warehouse_code`) USING BTREE,
  KEY `created_by` (`created_by`) USING BTREE,
  KEY `authorize_id` (`authorize_id`) USING BTREE,
  KEY `employee_id` (`employee_id`) USING BTREE,
  KEY `biller_id` (`biller_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_units
-- ----------------------------
DROP TABLE IF EXISTS `erp_units`;
CREATE TABLE `erp_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL,
  `name` varchar(55) DEFAULT NULL,
  `base_unit` int(11) DEFAULT NULL,
  `operator` varchar(1) DEFAULT NULL,
  `unit_value` varchar(55) DEFAULT NULL,
  `operation_value` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `base_unit` (`base_unit`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_user_logins
-- ----------------------------
DROP TABLE IF EXISTS `erp_user_logins`;
CREATE TABLE `erp_user_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `ip_address` varbinary(16) DEFAULT NULL,
  `login` varchar(100) DEFAULT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_users
-- ----------------------------
DROP TABLE IF EXISTS `erp_users`;
CREATE TABLE `erp_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `last_ip_address` varbinary(45) DEFAULT NULL,
  `ip_address` varbinary(45) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `forgotten_password_code` varchar(40) DEFAULT NULL,
  `forgotten_password_time` int(11) unsigned DEFAULT NULL,
  `remember_code` varchar(40) DEFAULT NULL,
  `created_on` int(11) unsigned DEFAULT NULL,
  `last_login` int(11) unsigned DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `avatar` varchar(55) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `group_id` int(10) unsigned DEFAULT NULL,
  `warehouse_id` varchar(20) DEFAULT NULL,
  `biller_id` varchar(500) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `show_cost` tinyint(1) DEFAULT '0',
  `show_price` tinyint(1) DEFAULT '0',
  `award_points` int(11) DEFAULT '0',
  `view_right` tinyint(1) DEFAULT '0',
  `edit_right` tinyint(1) DEFAULT '0',
  `allow_discount` tinyint(1) DEFAULT '0',
  `annualLeave` int(11) DEFAULT '0',
  `sickday` int(11) DEFAULT '0',
  `speacialLeave` int(11) DEFAULT NULL,
  `othersLeave` int(11) DEFAULT NULL,
  `first_name_kh` varchar(50) DEFAULT NULL,
  `last_name_kh` varchar(50) DEFAULT NULL,
  `nationality_kh` varchar(50) DEFAULT NULL,
  `race_kh` varchar(20) DEFAULT NULL,
  `pos_layout` tinyint(1) DEFAULT NULL,
  `pack_id` varchar(50) DEFAULT NULL,
  `sales_standard` tinyint(1) DEFAULT NULL,
  `sales_combo` tinyint(1) DEFAULT NULL,
  `sales_digital` tinyint(1) DEFAULT NULL,
  `sales_service` tinyint(1) DEFAULT NULL,
  `sales_category` varchar(150) DEFAULT NULL,
  `purchase_standard` tinyint(1) DEFAULT NULL,
  `purchase_combo` tinyint(1) DEFAULT NULL,
  `purchase_digital` tinyint(1) DEFAULT NULL,
  `purchase_service` tinyint(1) DEFAULT NULL,
  `purchase_category` varchar(150) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `nationality` varchar(64) DEFAULT NULL,
  `position` varchar(150) DEFAULT NULL,
  `salary` decimal(24,4) DEFAULT NULL,
  `spouse` varchar(150) DEFAULT NULL,
  `number_of_child` tinyint(4) DEFAULT NULL,
  `employeed_date` date DEFAULT NULL,
  `last_paid` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `note` text,
  `emergency_contact` varchar(255) DEFAULT NULL,
  `emp_code` varchar(50) DEFAULT NULL,
  `allowance` decimal(24,4) DEFAULT NULL,
  `emp_type` varchar(10) DEFAULT NULL,
  `tax_salary_type` varchar(10) DEFAULT NULL,
  `hide_row` tinyint(1) DEFAULT '0',
  `emp_group` int(11) DEFAULT NULL,
  `identify` varchar(50) DEFAULT NULL,
  `identify_date` date DEFAULT NULL,
  `user_type` varchar(30) DEFAULT NULL,
  `advance_amount` decimal(25,8) unsigned zerofill DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `group_id` (`group_id`,`warehouse_id`,`biller_id`(255)) USING BTREE,
  KEY `group_id_2` (`group_id`,`company_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `created_on` (`created_on`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `biller_id` (`biller_id`(255)) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_users_bank_account
-- ----------------------------
DROP TABLE IF EXISTS `erp_users_bank_account`;
CREATE TABLE `erp_users_bank_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `bankaccount_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `bankaccount_code` (`bankaccount_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=277 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_variants
-- ----------------------------
DROP TABLE IF EXISTS `erp_variants`;
CREATE TABLE `erp_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_warehouses
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouses`;
CREATE TABLE `erp_warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `map` varchar(255) DEFAULT NULL,
  `phone` varchar(55) DEFAULT NULL,
  `email` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_warehouses_products
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouses_products`;
CREATE TABLE `erp_warehouses_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `rack` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for erp_warehouses_products_variants
-- ----------------------------
DROP TABLE IF EXISTS `erp_warehouses_products_variants`;
CREATE TABLE `erp_warehouses_products_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `option_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `quantity` decimal(15,4) DEFAULT NULL,
  `rack` varchar(55) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `option_id` (`option_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `warehouse_id` (`warehouse_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Triggers structure for table erp_adjustment_items
-- ----------------------------
