
DROP TRIGGER IF EXISTS `gl_trans_adjustment_items_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_adjustment_items_insert` AFTER INSERT ON `erp_adjustment_items` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_default_stock_adjust INTEGER;
	DECLARE v_default_stock INTEGER;
	DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_biller_id INTEGER;
	DECLARE v_customer_id INTEGER;
	DECLARE v_reference_no VARCHAR(50);
	DECLARE v_note VARCHAR(255);
	DECLARE v_created_by INTEGER;
	DECLARE v_updated_by INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');
	SET v_reference_no = (SELECT erp_adjustments.reference_no FROM erp_adjustments WHERE erp_adjustments.id = NEW.adjust_id);

	SET v_tran_no = (SELECT erp_gl_trans.tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = v_reference_no LIMIT 1);
	IF v_tran_no <= 0 OR ISNULL(v_tran_no) THEN
		SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

		UPDATE erp_order_ref
			SET tr = v_tran_no
		WHERE
			DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
	END IF;

	SET v_biller_id = (SELECT erp_adjustments.biller_id FROM erp_adjustments WHERE erp_adjustments.id = NEW.adjust_id);
	SET v_customer_id = (SELECT erp_adjustments.customer_id FROM erp_adjustments WHERE erp_adjustments.id = NEW.adjust_id);
	SET v_note = (SELECT erp_adjustments.note FROM erp_adjustments WHERE erp_adjustments.id = NEW.adjust_id);
	SET v_created_by = (SELECT erp_adjustments.created_by FROM erp_adjustments WHERE erp_adjustments.id = NEW.adjust_id);
	SET v_updated_by = (SELECT erp_adjustments.updated_by FROM erp_adjustments WHERE erp_adjustments.id = NEW.adjust_id);

	SET v_default_stock_adjust = (SELECT
									erp_categories.ac_stock_adj
								FROM
									erp_categories
								INNER JOIN
									erp_products
								ON erp_categories.id = erp_products.category_id
								WHERE
									erp_products.id = NEW.product_id);

	SET v_default_stock = (SELECT
									erp_categories.ac_stock
								FROM
									erp_categories
								INNER JOIN
									erp_products
								ON erp_categories.id = erp_products.category_id
								WHERE
									erp_products.id = NEW.product_id);

	IF NEW.total_cost <> 0 THEN

		IF v_acc_cate_separate = 1 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				)
				SELECT
				'STOCK_ADJUST',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.total_cost,
				v_reference_no,
				v_note,
				v_biller_id,
				v_customer_id,
				v_created_by,
				v_updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = v_default_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = v_default_stock;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				)
				SELECT
				'STOCK_ADJUST',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * NEW.total_cost,
				v_reference_no,
				v_note,
				v_biller_id,
				v_customer_id,
				v_created_by,
				v_updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = v_default_stock_adjust
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = v_default_stock_adjust;

		END IF;

	END IF;


END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_adjustment_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_adjustment_delete`;
delimiter ;;
CREATE TRIGGER `gl_trans_adjustment_delete` AFTER DELETE ON `erp_adjustment_items` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE tran_type='STOCK_ADJUST' AND reference_no = OLD.id;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_adjustments
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_adjustments_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_adjustments_insert` AFTER INSERT ON `erp_adjustments` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_default_stock_adjust INTEGER;
	DECLARE v_default_stock INTEGER;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');
	SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

	UPDATE erp_order_ref
		SET tr = v_tran_no
	WHERE
		DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

	SET v_default_stock_adjust = (SELECT default_stock_adjust FROM erp_account_settings);
	SET v_default_stock = (SELECT default_stock FROM erp_account_settings);

	IF NEW.total_cost <> 0 THEN

		IF v_acc_cate_separate <> 1 THEN

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				)
				SELECT
				'STOCK_ADJUST',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.total_cost,
				NEW.reference_no,
				NEW.note,
				NEW.biller_id,
				NEW.customer_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = v_default_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = v_default_stock;

			INSERT INTO erp_gl_trans (

				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				)
				SELECT
				'STOCK_ADJUST',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * NEW.total_cost,
				NEW.reference_no,
				NEW.note,
				NEW.biller_id,
				NEW.customer_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = v_default_stock_adjust
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = v_default_stock_adjust;

		END IF;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_adjustments
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_adjustments_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_adjustments_update` AFTER UPDATE ON `erp_adjustments` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_default_stock_adjust INTEGER;
	DECLARE v_default_stock INTEGER;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');
	SET v_tran_no = (SELECT erp_gl_trans.tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = NEW.reference_no LIMIT 1);


	SET v_default_stock_adjust = (SELECT default_stock_adjust FROM erp_account_settings);
	SET v_default_stock = (SELECT default_stock FROM erp_account_settings);


	IF NEW.updated_by > 0 THEN

		DELETE FROM erp_gl_trans WHERE erp_gl_trans.reference_no = NEW.reference_no;

		IF NEW.total_cost <> 0 THEN

			IF v_acc_cate_separate <> 1 THEN

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
					)
					SELECT
					'STOCK_ADJUST',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					NEW.total_cost,
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = v_default_stock
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = v_default_stock;

				INSERT INTO erp_gl_trans (

					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
					)
					SELECT
					'STOCK_ADJUST',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * NEW.total_cost,
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = v_default_stock_adjust
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = v_default_stock_adjust;

			END IF;

		END IF;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_convert
-- ----------------------------
DROP TRIGGER IF EXISTS `delete_gl_trans_convert_update`;
delimiter ;;
CREATE TRIGGER `delete_gl_trans_convert_update` AFTER UPDATE ON `erp_convert` FOR EACH ROW BEGIN

	IF NEW.updated_by THEN

		DELETE FROM erp_gl_trans WHERE erp_gl_trans.reference_no = NEW.reference_no;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_convert_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_convert_items_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_convert_items_insert` AFTER INSERT ON `erp_convert_items` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_created_by INTEGER;
	DECLARE v_updated_by INTEGER;
	DECLARE v_biller_id INTEGER;
	DECLARE v_reference_no VARCHAR(50);
	DECLARE v_note VARCHAR(255);
	DECLARE v_category_id INTEGER;

	SET v_created_by = (SELECT erp_convert.created_by FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_updated_by = (SELECT erp_convert.updated_by FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_biller_id = (SELECT erp_convert.biller_id FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_tran_date = (SELECT erp_convert.date FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_reference_no = (SELECT erp_convert.reference_no FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_note = (SELECT erp_convert.noted FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);

	IF NOT ISNULL(v_updated_by) THEN

		SET v_tran_no = (SELECT erp_gl_trans.tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = v_reference_no LIMIT 0, 1);

		IF ISNULL(v_tran_no) THEN

			SET v_tran_no = (SELECT COALESCE (MAX(tran_no), 0) + 1 FROM erp_gl_trans);
			UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

		END IF;

	ELSE
		SET v_tran_no = (SELECT erp_gl_trans.tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = v_reference_no LIMIT 0, 1);

		IF ISNULL(v_tran_no) THEN

			SET v_tran_no = (SELECT COALESCE (MAX(tran_no), 0) + 1 FROM erp_gl_trans);
			UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

		END IF;

	END IF;

	IF NEW.status = 'deduct' THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'CONVERT',
			v_tran_no,
			v_tran_date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * abs(NEW.quantity * NEW.cost),
			v_reference_no,
			v_note,
			v_biller_id,
			v_created_by,
			v_updated_by
		FROM
			erp_categories
			INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
			INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_categories.id = v_category_id;

	END IF;

	IF NEW.status = 'add' THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'CONVERT',
			v_tran_no,
			v_tran_date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.quantity * NEW.cost),
			v_reference_no,
			v_note,
			v_biller_id,
			v_created_by,
			v_updated_by
		FROM
			erp_categories
			INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
			INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_categories.id = v_category_id;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_convert_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_convert_items_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_convert_items_update` AFTER UPDATE ON `erp_convert_items` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_created_by INTEGER;
	DECLARE v_updated_by INTEGER;
	DECLARE v_biller_id INTEGER;
	DECLARE v_reference_no VARCHAR(50);
	DECLARE v_note VARCHAR(255);
	DECLARE v_category_id INTEGER;

	SET v_created_by = (SELECT erp_convert.created_by FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_updated_by = (SELECT erp_convert.updated_by FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_biller_id = (SELECT erp_convert.biller_id FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_tran_date = (SELECT erp_convert.date FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_reference_no = (SELECT erp_convert.reference_no FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_note = (SELECT erp_convert.noted FROM erp_convert WHERE erp_convert.id = NEW.convert_id LIMIT 0, 1);
	SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);

	IF NOT ISNULL(v_updated_by) THEN

		SET v_tran_no = (SELECT erp_gl_trans.tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = v_reference_no LIMIT 0, 1);

		IF ISNULL(v_tran_no) THEN

			SET v_tran_no = (SELECT COALESCE (MAX(tran_no), 0) + 1 FROM erp_gl_trans);
			UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

		END IF;

	ELSE
		SET v_tran_no = (SELECT erp_gl_trans.tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = v_reference_no LIMIT 0, 1);

		IF ISNULL(v_tran_no) THEN

			SET v_tran_no = (SELECT COALESCE (MAX(tran_no), 0) + 1 FROM erp_gl_trans);
			UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

		END IF;

	END IF;

	IF NEW.status = 'deduct' THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'CONVERT',
			v_tran_no,
			v_tran_date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * abs(NEW.quantity * NEW.cost),
			v_reference_no,
			v_note,
			v_biller_id,
			v_created_by,
			v_updated_by
		FROM
			erp_categories
			INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
			INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_categories.id = v_category_id;

	END IF;

	IF NEW.status = 'add' THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'CONVERT',
			v_tran_no,
			v_tran_date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.quantity * NEW.cost),
			v_reference_no,
			v_note,
			v_biller_id,
			v_created_by,
			v_updated_by
		FROM
			erp_categories
			INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
			INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_categories.id = v_category_id;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_deliveries
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_deliveries_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_deliveries_insert` AFTER INSERT ON `erp_deliveries` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');
	IF NEW.delivery_status = "completed" THEN

		SET v_tran_no = (
			SELECT
				COALESCE (MAX(tran_no), 0) + 1
			FROM
				erp_gl_trans
		);
		UPDATE erp_order_ref
		SET tr = v_tran_no
		WHERE
			DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

		IF v_acc_cate_separate <> 1 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,

				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
			) SELECT
				'DELIVERY',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.total_cost,
				NEW.do_reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
			INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_cost;


			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
			) SELECT
				'DELIVERY',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(- 1) * abs(NEW.total_cost),
				NEW.do_reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
			INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_stock;
		END IF;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_deliveries
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_deliveries_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_deliveries_update` AFTER UPDATE ON `erp_deliveries` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF NEW.updated_count <> OLD.updated_count AND NEW.updated_by > 0 THEN

		DELETE FROM erp_gl_trans WHERE erp_gl_trans.tran_type = 'DELIVERY' AND erp_gl_trans.reference_no = NEW.do_reference_no;

		IF NEW.delivery_status = "completed" THEN
			SET v_tran_no = (
				SELECT
					COALESCE (MAX(tran_no), 0) + 1
				FROM
					erp_gl_trans
			);
			UPDATE erp_order_ref
			SET tr = v_tran_no
			WHERE
				DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

			IF v_acc_cate_separate <> 1 THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'DELIVERY',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					NEW.total_cost,
					NEW.do_reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_cost;


				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'DELIVERY',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(- 1) * abs(NEW.total_cost),
					NEW.do_reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;
			END IF;
		END IF;
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_delivery_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_delivery_items_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_delivery_items_insert` AFTER INSERT ON `erp_delivery_items` FOR EACH ROW BEGIN

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_delivery_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_delivery_items_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_delivery_items_update` AFTER UPDATE ON `erp_delivery_items` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_reference_no VARCHAR(50);
	DECLARE v_customer VARCHAR(55);
	DECLARE v_biller_id INTEGER;
	DECLARE v_category_id INTEGER;
	DECLARE v_qty_unit INTEGER;
	DECLARE v_delivery_status VARCHAR(50);

	IF NEW.updated_count <> OLD.updated_count AND NEW.updated_by > 0 THEN

		SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');
		SET v_delivery_status = (SELECT erp_deliveries.delivery_status FROM erp_deliveries WHERE erp_deliveries.id = NEW.delivery_id);

		IF v_delivery_status = "completed" THEN
			SET v_tran_date = (
						SELECT
							erp_deliveries.date
						FROM
							erp_deliveries
						WHERE
							erp_deliveries.id = NEW.delivery_id
						LIMIT 1
					);

			SET v_reference_no = (SELECT erp_deliveries.do_reference_no FROM erp_deliveries WHERE erp_deliveries.id = NEW.delivery_id);
			SET v_tran_no = (SELECT erp_gl_trans.tran_no FROM erp_gl_trans WHERE erp_gl_trans.tran_type = "DELIVERY" AND reference_no = v_reference_no LIMIT 1);
			IF ISNULL(v_tran_no) THEN
				SET v_tran_no = (
					SELECT
						COALESCE (MAX(tran_no), 0) + 1
					FROM
						erp_gl_trans
				);
				UPDATE erp_order_ref
				SET tr = v_tran_no
				WHERE
					DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
			END IF;
			SET v_customer = (SELECT erp_deliveries.customer FROM erp_deliveries WHERE erp_deliveries.id = NEW.delivery_id);
			SET v_biller_id = (SELECT erp_deliveries.biller_id FROM erp_deliveries WHERE erp_deliveries.id = NEW.delivery_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);

			IF NEW.option_id AND NEW.product_id THEN
				SET v_qty_unit = (SELECT erp_product_variants.qty_unit FROM erp_product_variants WHERE erp_product_variants.id = NEW.option_id AND erp_product_variants.product_id = NEW.product_id);
			ELSE
				SET v_qty_unit = 1;
			END IF;

			IF v_acc_cate_separate = 1 THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'DELIVERY',
					v_tran_no,
					v_tran_date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(NEW.cost * NEW.quantity_received),
					v_reference_no,
					v_customer,
					v_biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_cost
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					created_by,
					updated_by
				) SELECT
					'DELIVERY',
					v_tran_no,
					v_tran_date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(- 1) * (NEW.cost * NEW.quantity_received),
					v_reference_no,
					v_customer,
					v_biller_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;
			END IF;
		END IF;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_employee_salary_tax_small_taxpayers_trigger
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_salary_tax_small_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_salary_tax_small_insert` AFTER INSERT ON `erp_employee_salary_tax_small_taxpayers_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;
DECLARE v_date DATE;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);


IF v_tran_date = DATE_FORMAT(NEW.year_month, '%Y-%m') THEN

SET v_tran_no = (
	SELECT
		MAX(tran_no)
	FROM
		erp_gl_trans
);

ELSE

SET v_tran_no = (
	SELECT
		COALESCE (MAX(tran_no), 0) + 1
	FROM
		erp_gl_trans
);


UPDATE erp_order_ref
SET tr = v_tran_no
WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
END
IF;

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);

SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);


/* ==== Employee Salary Tax =====*/
IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
        'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense;

ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),

	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAY(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
        'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END
IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_employee_salary_tax_small_taxpayers_trigger
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_salary_tax_small_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_salary_tax_small_update` AFTER UPDATE ON `erp_employee_salary_tax_small_taxpayers_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;

SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no LIMIT 0,1);

DELETE FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);

SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);

/* ==== Employee Salary Tax =====*/
IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
        'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;


ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,

	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	DATE_FORMAT(CONCAT(NEW.year_month,'-', DAy(CURRENT_DATE())), '%Y-%m-%d'),
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END
IF;


END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_employee_salary_tax_trigger
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_tran_salary_tax_insert`;
delimiter ;;
CREATE TRIGGER `gl_tran_salary_tax_insert` AFTER INSERT ON `erp_employee_salary_tax_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_fringe_benefit_tax INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;
DECLARE v_date DATE;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);


IF v_tran_date = DATE_FORMAT(NEW.year_month, '%Y-%m') THEN

SET v_tran_no = (
	SELECT
		MAX(tran_no)
	FROM
		erp_gl_trans
);

ELSE

SET v_tran_no = (
	SELECT
		COALESCE (MAX(tran_no), 0) + 1
	FROM
		erp_gl_trans
);


UPDATE erp_order_ref
SET tr = v_tran_no
WHERE
	DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
END
IF;

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);
SET v_default_fringe_benefit_tax = (
	SELECT
		default_fringe_benefit_tax
	FROM
		erp_account_settings
);
SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);


/* ==== Employee Salary Tax =====*/
/* ==== Tab 1 =====*/

IF NEW.tab = 1 OR NEW.tab=2 THEN

IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
                                     NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;


ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
                                     (- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	 (- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END IF;
END IF;
/* ==== END Tab 1 =====*/
IF NEW.tab =3 THEN

INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'Fringe Benefit',
		v_tran_no,
                                     NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		 abs(NEW.total_allowance_tax*0.2),
		NEW.reference_no_j,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_tax_duties_expense;



INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'Fringe Benefit',
		v_tran_no,
                                     NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_allowance_tax*0.2),
		NEW.reference_no_j,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_fringe_benefit_tax
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_fringe_benefit_tax;







END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_employee_salary_tax_trigger
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_tran_salary_tax_update`;
delimiter ;;
CREATE TRIGGER `gl_tran_salary_tax_update` AFTER UPDATE ON `erp_employee_salary_tax_trigger` FOR EACH ROW BEGIN
DECLARE
	v_tran_no INTEGER;
DECLARE
	v_default_fringe_benefit_tax INTEGER;
DECLARE
	v_default_payroll INTEGER;
DECLARE
	v_default_salary_tax_payable INTEGER;
DECLARE
	v_default_salary_expense INTEGER;
DECLARE
	v_default_tax_duties_expense INTEGER;
DECLARE
	v_bank_code INTEGER;
DECLARE
	v_account_code INTEGER;
DECLARE
	v_tran_date DATETIME;
DECLARE
	v_biller_id INTEGER;
DECLARE
	v_tran_no_b INTEGER;

SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no LIMIT 0,1);
SET v_tran_no_b = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='Fringe Benefit' AND reference_no = NEW.reference_no_j LIMIT 0,1);


DELETE FROM erp_gl_trans WHERE tran_type='SALARY TAX' AND reference_no = NEW.reference_no;

SET v_biller_id = (
                   SELECT default_biller FROM erp_settings
);

SET v_default_payroll = (
	SELECT
		default_payroll
	FROM
		erp_account_settings
);
SET v_default_fringe_benefit_tax = (
	SELECT
		default_fringe_benefit_tax
	FROM
		erp_account_settings
);
SET v_default_salary_tax_payable = (
	SELECT
		default_salary_tax_payable
	FROM
		erp_account_settings
);
SET v_default_tax_duties_expense = (
	SELECT
		default_tax_duties_expense
	FROM
		erp_account_settings
);
SET v_default_salary_expense = (
	SELECT
		default_salary_expense
	FROM
		erp_account_settings
);

/* ==== Employee Salary Tax =====*/
/* ==== Tab 1 =====*/

IF NEW.tab = 1 OR NEW.tab=2 THEN

IF NEW.isCompany = 0 THEN
	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
                                     NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_salary_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	(- 1) * abs(NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_tax_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_tax_duties_expense ;


INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;


ELSE

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	NEW.total_salary_usd,
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_expense
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_expense ;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'SALARY TAX',
		v_tran_no,
		NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
                                     (- 1) * (NEW.total_salary_usd - NEW.total_salary_tax_usd),
		NEW.reference_no,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_payroll
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_payroll;

INSERT INTO erp_gl_trans (
	tran_type,
	tran_no,
	tran_date,
	sectionid,
	account_code,
	narrative,
	amount,
	reference_no,
	description,
	biller_id,
	created_by,
	bank,
	updated_by
) SELECT
	'SALARY TAX',
	v_tran_no,
	NEW.date,
	erp_gl_sections.sectionid,
	erp_gl_charts.accountcode,
	erp_gl_charts.accountname,
	 (- 1) * (NEW.total_salary_tax_usd),
	NEW.reference_no,
	'Employee Salary Tax',
	v_biller_id,
	NEW.created_by,
	'1',
	NEW.updated_by
FROM
	erp_account_settings
INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_salary_tax_payable
INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
WHERE
	erp_gl_charts.accountcode =v_default_salary_tax_payable;

END IF;
END IF;
/* ==== END Tab 1 =====*/
IF NEW.tab =3 THEN

DELETE FROM erp_gl_trans WHERE tran_type='Fringe Benefit' AND reference_no = NEW.reference_no_j;


INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'Fringe Benefit',
		v_tran_no_b,
                                     NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		 abs(NEW.total_allowance_tax*0.2),
		NEW.reference_no_j,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_tax_duties_expense
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_tax_duties_expense;



INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		bank,
		updated_by
	) SELECT
		'Fringe Benefit',
		v_tran_no_b,
                                     NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		(- 1) * abs(NEW.total_allowance_tax*0.2),
		NEW.reference_no_j,
                                     'Employee Salary Tax',
		v_biller_id,
		NEW.created_by,
		'1',
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = v_default_fringe_benefit_tax
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode =v_default_fringe_benefit_tax;







END IF;





END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_enter_using_stock
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_enter_using_stock_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_enter_using_stock_insert` AFTER INSERT ON `erp_enter_using_stock` FOR EACH ROW BEGIN

	DECLARE e_tran_type VARCHAR (50);
	DECLARE e_tran_date DATETIME;
	DECLARE e_account_code INTEGER;
	DECLARE e_narrative VARCHAR (255);
	DECLARE v_tran_no INTEGER;
	DECLARE inv_account_code INTEGER;
	DECLARE inv_narrative VARCHAR (255);
	DECLARE cost_variant_account_code INTEGER;
	DECLARE cost_variant_narrative VARCHAR (255);
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');
	SET v_tran_no = (
		SELECT
			COALESCE (MAX(tran_no), 0) + 1
		FROM
			erp_gl_trans
	);

	UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

	SET e_narrative = (
		SELECT
			erp_gl_charts.accountname
		FROM
			erp_gl_charts
		WHERE
			erp_gl_charts.accountcode = NEW.account
	);

	SET inv_account_code = (
		SELECT
			erp_account_settings.default_stock
		FROM
			erp_account_settings
	);

	SET inv_narrative = (
		SELECT
			erp_gl_charts.accountname
		FROM
			erp_gl_charts
		WHERE
			erp_gl_charts.accountcode = inv_account_code
	);

	SET cost_variant_account_code = (
		SELECT
			erp_account_settings.default_cost_variant
		FROM
			erp_account_settings
	);

	SET cost_variant_narrative = (
		SELECT
			erp_gl_charts.accountname
		FROM
			erp_gl_charts
		WHERE
			erp_gl_charts.accountcode = cost_variant_account_code
	);

	IF NEW.type = 'use' THEN
		IF v_acc_cate_separate <> 1 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by
			)
			SELECT
				'USING STOCK',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(- 1) * abs(NEW.total_cost),
				NEW.reference_no,
				NEW.note,
				NEW.shop,
				NEW.customer_id,
				NEW.create_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;
		END IF;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by
		)
		SELECT
			'USING STOCK',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			NEW.total_cost,
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.create_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = NEW.account
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = NEW.account;
	END IF;

	IF NEW.type = 'return' THEN
		IF v_acc_cate_separate <> 1 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by
			)
			SELECT
				'RETURN USING STOCK',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.total_cost),
				NEW.reference_no,
				NEW.note,
				NEW.shop,
				NEW.customer_id,
				NEW.create_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;
		END IF;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			customer_id,
			created_by
		)
		SELECT
			'RETURN USING STOCK',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * NEW.total_cost,
			NEW.reference_no,
			NEW.note,
			NEW.shop,
			NEW.customer_id,
			NEW.create_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = NEW.account
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = NEW.account;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_enter_using_stock
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_enter_using_stock_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_enter_using_stock_update` AFTER UPDATE ON `erp_enter_using_stock` FOR EACH ROW BEGIN

	DECLARE e_tran_type VARCHAR (50);
	DECLARE e_tran_date DATETIME;
	DECLARE e_account_code INTEGER;
	DECLARE e_narrative VARCHAR (255);
	DECLARE v_tran_no INTEGER;
	DECLARE inv_account_code INTEGER;
	DECLARE inv_narrative VARCHAR (255);
	DECLARE cost_variant_account_code INTEGER;
	DECLARE cost_variant_narrative VARCHAR (255);
	DECLARE inv_created_by VARCHAR (255);
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	SET  inv_created_by = (SELECT created_by from erp_gl_trans where reference_no = NEW.reference_no LIMIT 1);
	SET v_tran_no = (SELECT COALESCE (MAX(tran_no), 0) + 1 FROM erp_gl_trans);

	UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

	SET e_narrative = (
		SELECT
			erp_gl_charts.accountname
		FROM
			erp_gl_charts
		WHERE
			erp_gl_charts.accountcode = NEW.account
	);

	DELETE FROM erp_gl_trans WHERE tran_type='USING STOCK' AND bank=0 AND reference_no = NEW.reference_no;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		customer_id,
		updated_by
	)
	SELECT
		'USING STOCK',
		v_tran_no,
		NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		NEW.total_cost,
		NEW.reference_no,
		NEW.note,
		NEW.shop,
		inv_created_by,
		NEW.customer_id,
		NEW.create_by
		FROM
			erp_account_settings
			INNER JOIN erp_gl_charts
			ON erp_gl_charts.accountcode = NEW.account
			INNER JOIN erp_gl_sections
			ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = NEW.account;

	SET inv_account_code = (
		SELECT
			erp_account_settings.default_stock
		FROM
			erp_account_settings
	);
	SET inv_narrative = (
		SELECT
			erp_gl_charts.accountname
		FROM
			erp_gl_charts
		WHERE
			erp_gl_charts.accountcode = inv_account_code
	);
	SET cost_variant_account_code = (
		SELECT
			erp_account_settings.default_cost_variant
		FROM
			erp_account_settings
	);
	SET cost_variant_narrative = (
		SELECT
			erp_gl_charts.accountname
		FROM
			erp_gl_charts
		WHERE
			erp_gl_charts.accountcode = cost_variant_account_code
	);

	IF v_acc_cate_separate <> 1 THEN
		IF NEW.type = 'use' THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by
			)
			SELECT
				'USING STOCK',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(- 1) * abs(NEW.total_cost),
				NEW.reference_no,
				NEW.note,
				NEW.shop,
				NEW.customer_id,
				NEW.create_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;
		END IF;
	END IF;

	IF NEW.type = 'return' THEN
		IF NEW.total_cost <> NEW.total_using_cost THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by
			)
			SELECT
				'RETURN USING STOCK',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(NEW.total_using_cost)-(NEW.total_cost),
				NEW.reference_no,
				NEW.note,
				NEW.shop,
				NEW.customer_id,
				NEW.create_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_cost_variant
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_cost_variant;
		END IF;
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			customer_id,
			created_by
		)
		SELECT
				'RETURN USING STOCK',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(- 1) * abs(NEW.total_using_cost),
				NEW.reference_no,
				NEW.note,
				NEW.shop,
				NEW.customer_id,
				NEW.create_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_enter_using_stock_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_enter_using_stock_items_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_enter_using_stock_items_insert` AFTER INSERT ON `erp_enter_using_stock_items` FOR EACH ROW BEGIN

	DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_tran_no INTEGER;
	DECLARE v_cate_id INTEGER;
	DECLARE v_type VARCHAR(50);
	DECLARE v_date DATETIME;
	DECLARE v_note VARCHAR(255);
	DECLARE v_shop VARCHAR(50);
	DECLARE v_customer_id INTEGER;
	DECLARE v_created_by VARCHAR(50);

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF v_acc_cate_separate = 1 THEN
		SET v_tran_no = (
			SELECT
				erp_gl_trans.tran_no
			FROM
				erp_gl_trans
			WHERE
				erp_gl_trans.reference_no = NEW.reference_no LIMIT 1
		);
		SET v_type = (SELECT
				erp_enter_using_stock.type
			FROM
				erp_enter_using_stock
			WHERE
				erp_enter_using_stock.reference_no = NEW.reference_no LIMIT 1
		);
		SET v_date = (SELECT
				erp_enter_using_stock.date
			FROM
				erp_enter_using_stock
			WHERE
				erp_enter_using_stock.reference_no = NEW.reference_no LIMIT 1
		);
		SET v_note = (SELECT
				erp_enter_using_stock.note
			FROM
				erp_enter_using_stock
			WHERE
				erp_enter_using_stock.reference_no = NEW.reference_no LIMIT 1
		);
		SET v_shop = (SELECT
				erp_enter_using_stock.shop
			FROM
				erp_enter_using_stock
			WHERE
				erp_enter_using_stock.reference_no = NEW.reference_no LIMIT 1
		);
		SET v_created_by = (SELECT
				erp_enter_using_stock.create_by
			FROM
				erp_enter_using_stock
			WHERE
				erp_enter_using_stock.reference_no = NEW.reference_no LIMIT 1
		);
		SET v_customer_id = (SELECT
				erp_enter_using_stock.customer_id
			FROM
				erp_enter_using_stock
			WHERE
				erp_enter_using_stock.reference_no = NEW.reference_no LIMIT 1
		);
		SET v_cate_id = (SELECT
				erp_products.category_id
			FROM
				erp_products
			WHERE
				erp_products.code = NEW.code LIMIT 1
		);

		IF v_type = 'use' THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by
			)
			SELECT
				'USING STOCK',
				v_tran_no,
				v_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(- 1) * ((SELECT COALESCE(erp_products.cost, 0) FROM erp_products WHERE erp_products.code = NEW.code)*NEW.qty_use),
				NEW.reference_no,
				v_note,
				v_shop,
				v_customer_id,
				v_created_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_categories.ac_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_cate_id;

		END IF;

		IF v_type = 'return' THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by
			)
			SELECT
				'RETURN USING STOCK',
				v_tran_no,
				v_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				((SELECT COALESCE(erp_products.cost, 0) FROM erp_products WHERE erp_products.code = NEW.code)*NEW.qty_use),
				NEW.reference_no,
				v_note,
				v_shop,
				v_customer_id,
				v_created_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_categories.ac_stock
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_cate_id;

		END IF;
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_expenses
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_expenses_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_expenses_insert` AFTER INSERT ON `erp_expenses` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;


	IF NEW.created_by THEN

		SET v_tran_date = (SELECT erp_expenses.date
			FROM erp_payments
			INNER JOIN erp_expenses ON erp_expenses.id = erp_payments.expense_id
			WHERE erp_expenses.id = NEW.id LIMIT 0,1);

		IF v_tran_date = NEW.date THEN
			SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
		ELSE
			SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

			UPDATE erp_order_ref
			SET tr = v_tran_no
			WHERE
			DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
		END IF;



		INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by,
				sale_id,
				customer_id
			) SELECT
				'JOURNAL',
				v_tran_no,
				NEW.date,
				erp_gl_charts.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.amount,
				NEW.reference,
				NEW.note,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by,
				NEW.sale_id,
				NEW.customer_id
				FROM
					erp_gl_charts
				WHERE
					erp_gl_charts.accountcode = NEW.account_code;

		INSERT INTO erp_gl_trans (
				tran_type,

				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by,
				sale_id,
				customer_id
			) SELECT
				'JOURNAL',
				v_tran_no,
				NEW.date,
				erp_gl_charts.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1)*NEW.amount,
				NEW.reference,
				NEW.note,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by,
				NEW.sale_id,
				NEW.customer_id
				FROM
					erp_gl_charts
				WHERE
					erp_gl_charts.accountcode = NEW.bank_code;


	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_expenses
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_expenses_update`;
delimiter ;;
CREATE TRIGGER `audit_expenses_update` BEFORE UPDATE ON `erp_expenses` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_expenses_audit (
			id,
			date,
			reference,
			amount,
			note,
			created_by,
			attachment,
			account_code,
			bank_code,
			biller_id,
			updated_by,
			updated_at,
			tax,
			status,
			warehouse_id,
			audit_type
		) SELECT
			id,
			date,
			reference,
			amount,
			note,
			created_by,
			attachment,
			account_code,
			bank_code,
			biller_id,
			updated_by,
			updated_at,
			tax,
			status,
			warehouse_id,
			"UPDATED"
		FROM
			erp_expenses
		WHERE
			erp_expenses.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_expenses
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_expenses_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_expenses_update` AFTER UPDATE ON `erp_expenses` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;

	SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE reference_no = NEW.reference LIMIT 0,1);
	IF v_tran_no < 1  THEN
		SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

		UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
	ELSE
	                SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
	END IF;

	IF NEW.updated_by THEN


		DELETE FROM erp_gl_trans WHERE reference_no = NEW.reference AND tran_type = 'JOURNAL';

		INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,

				description,
				biller_id,
				created_by,
				updated_by,
				sale_id,
				customer_id
			) SELECT
				'JOURNAL',
				v_tran_no,
				NEW.date,
				erp_gl_charts.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.amount,
				NEW.reference,
				NEW.note,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by,
				NEW.sale_id,
				NEW.customer_id
				FROM
					erp_gl_charts
				WHERE
					erp_gl_charts.accountcode = NEW.account_code;

		INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by,
				sale_id,
				customer_id
			) SELECT
				'JOURNAL',
				v_tran_no,
				NEW.date,
				erp_gl_charts.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1)*NEW.amount,
				NEW.reference,
				NEW.note,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by,
				NEW.sale_id,
				NEW.customer_id
				FROM
					erp_gl_charts
				WHERE
					erp_gl_charts.accountcode = NEW.bank_code;


	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_expenses
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_expenses_delete`;
delimiter ;;
CREATE TRIGGER `gl_trans_expenses_delete` AFTER DELETE ON `erp_expenses` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_expenses
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_expenses_delete`;
delimiter ;;
CREATE TRIGGER `audit_expenses_delete` BEFORE DELETE ON `erp_expenses` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_expenses_audit (
			id,
			date,
			reference,
			amount,
			note,
			created_by,
			attachment,
			account_code,
			bank_code,
			biller_id,
			updated_by,
			updated_at,
			tax,
			status,
			warehouse_id,
			audit_type
		) SELECT
			id,
			date,
			reference,
			amount,
			note,
			created_by,
			attachment,
			account_code,
			bank_code,
			biller_id,
			updated_by,
			updated_at,
			tax,
			status,
			warehouse_id,
			"DELETED"
		FROM
			erp_expenses
		WHERE
			erp_expenses.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_gift_cards
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_gift_cards_update`;
delimiter ;;
CREATE TRIGGER `audit_gift_cards_update` BEFORE UPDATE ON `erp_gift_cards` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_gift_cards_audit (
			id,
			date,
			card_no,
			value,
			customer_id,
			customer,
			balance,
			expiry,
			created_by,
			audit_type
		) SELECT
			id,
			date,
			card_no,
			value,
			customer_id,
			customer,
			balance,
			expiry,
			created_by,
			"UPDATED"
		FROM
			erp_gift_cards
		WHERE
			erp_gift_cards.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_gift_cards
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_gift_cards_delete`;
delimiter ;;
CREATE TRIGGER `audit_gift_cards_delete` BEFORE DELETE ON `erp_gift_cards` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_gift_cards_audit (
			id,
			date,
			card_no,
			value,
			customer_id,
			customer,
			balance,
			expiry,
			created_by,
			audit_type
		) SELECT
			id,
			date,
			card_no,
			value,
			customer_id,
			customer,
			balance,
			expiry,
			created_by,
			"DELETED"
		FROM
			erp_gift_cards
		WHERE
			erp_gift_cards.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_gl_trans
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_gl_trans_update`;
delimiter ;;
CREATE TRIGGER `audit_gl_trans_update` BEFORE UPDATE ON `erp_gl_trans` FOR EACH ROW BEGIN
	IF OLD.tran_id THEN
		INSERT INTO erp_gl_trans_audit (
			tran_id,
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by,
			bank,
			gov_tax,
			reference_gov_tax,
			people_id,
			invoice_ref,
			ref_type,
			created_name,
			created_type,
			people,
			type,
			status_tax,
			audit_type
		) SELECT
			tran_id,
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by,
			bank,
			gov_tax,
			reference_gov_tax,
			people_id,
			invoice_ref,
			ref_type,
			created_name,
			created_type,
			people,
			type,
			status_tax,
			"UPDATED"
		FROM
			erp_gl_trans
		WHERE
			erp_gl_trans.tran_id= OLD.tran_id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_gl_trans
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_gl_trans_delete`;
delimiter ;;
CREATE TRIGGER `audit_gl_trans_delete` BEFORE DELETE ON `erp_gl_trans` FOR EACH ROW BEGIN
	IF OLD.tran_id THEN
		INSERT INTO erp_gl_trans_audit (
			tran_id,
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by,
			bank,
			gov_tax,
			reference_gov_tax,
			people_id,
			invoice_ref,
			ref_type,
			created_name,
			created_type,
			people,
			type,
			status_tax,
			audit_type
		) SELECT
			tran_id,
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by,
			bank,
			gov_tax,
			reference_gov_tax,
			people_id,
			invoice_ref,
			ref_type,
			created_name,
			created_type,
			people,
			type,
			status_tax,
			"DELETED"
		FROM
			erp_gl_trans
		WHERE
			erp_gl_trans.tran_id= OLD.tran_id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_loans
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_loan_delete`;
delimiter ;;
CREATE TRIGGER `gl_trans_loan_delete` AFTER DELETE ON `erp_loans` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchase_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_purchase_items_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_purchase_items_insert` AFTER INSERT ON `erp_purchase_items` FOR EACH ROW BEGIN
	DECLARE v_reference_no VARCHAR(55);
	DECLARE v_tran_no INTEGER;
	DECLARE v_date DATETIME;
	DECLARE v_biller_id INTEGER;
	DECLARE v_supplier VARCHAR(55);
	DECLARE v_created_by INTEGER;
	DECLARE v_updated_by INTEGER;
	DECLARE v_cost DECIMAL(4);
	DECLARE v_status VARCHAR(50);
                  DECLARE v_status_tr VARCHAR(50);
	DECLARE v_category_id INTEGER;
	DECLARE v_qoh INTEGER;
	DECLARE v_updated_at DATETIME;
	DECLARE v_transaction_id INTEGER;
	DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_transaction_type VARCHAR(25);
	DECLARE v_tran_note VARCHAR(255);
	DECLARE v_chk_acc  INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');
	SET v_transaction_id = NEW.transaction_id;
	SET v_transaction_type = NEW.transaction_type;

	IF NEW.product_id THEN

		/* SALE */
			IF v_transaction_type = 'SALE' THEN

				SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
				SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
				SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

				SET v_date = (SELECT
					erp_sales.date
				FROM
					erp_sales
					JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
				WHERE
					erp_sale_items.id = v_transaction_id
				LIMIT 0,1);

				SET v_reference_no = (SELECT
							erp_sales.reference_no
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_supplier = (SELECT
							erp_sales.customer
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_biller_id = (SELECT
							erp_sales.biller_id
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_created_by = (SELECT
							erp_sales.created_by
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_updated_by = (SELECT
							erp_sales.updated_by
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_status = (SELECT
							erp_sales.sale_status
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
                                                                          SET v_status_tr = (SELECT
							erp_deliveries.delivery_status
						FROM
							erp_deliveries
							JOIN erp_sale_items ON erp_deliveries.sale_id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_updated_at = (SELECT
							erp_sales.updated_at
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);

				IF v_status = 'completed' THEN
					INSERT INTO erp_inventory_valuation_details (
						type,
						biller_id,
						product_id,
						product_code,
						product_name,
						category_id,
						reference_no,
						date,
						NAME,
						quantity,
						warehouse_id,
						cost,
						qty_on_hand,
						avg_cost,
						created_by,
						updated_by,
						updated_at,
						field_id
						)
						VALUES
						(
						v_transaction_type,
						v_biller_id,
						NEW.product_id,
						NEW.product_code,
						NEW.product_name,
						v_category_id,
						v_reference_no,
						v_date ,
						v_supplier,
						(-1)*NEW.quantity_balance,
						NEW.warehouse_id,
						v_cost,
						v_qoh,
						v_cost,
						v_created_by,
						v_updated_by,
						v_updated_at,
						v_transaction_id
					);
				END IF;

			END IF;
		/* End SALE */

                                    /* DELIVERY */
		IF NEW.transaction_type = 'DELIVERY' THEN

			SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id  = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);


			SET v_date = (SELECT
				erp_deliveries.date
			FROM
				erp_deliveries
			WHERE
				erp_deliveries.id = NEW.delivery_id
			LIMIT 0,1);

			SET v_reference_no = (SELECT
	                                                                                            erp_deliveries.do_reference_no FROM
                                                                                                    erp_deliveries
					WHERE
						erp_deliveries.id = NEW.delivery_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
	                                                                                            erp_deliveries.customer FROM
                                                                                                    erp_deliveries
					WHERE
						erp_deliveries.id = NEW.delivery_id
					LIMIT 0,1);

			SET v_biller_id  = (SELECT
						erp_deliveries.biller_id
					FROM
						erp_deliveries
					WHERE
						erp_deliveries.id =  NEW.delivery_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_deliveries.created_by
					FROM
						erp_deliveries
					WHERE
						erp_deliveries.id =NEW.delivery_id
					LIMIT 0,1);

			SET v_updated_by = (SELECT
						erp_deliveries.updated_by
					FROM
						erp_deliveries
					WHERE
						erp_deliveries.id =NEW.delivery_id
					LIMIT 0,1);

			SET v_updated_at = (SELECT
						erp_deliveries.updated_at
					FROM
						erp_deliveries
					WHERE
						erp_deliveries.id =NEW.delivery_id
					LIMIT 0,1);

			SET v_status = (SELECT
						erp_deliveries.delivery_status
					FROM
						erp_deliveries
					WHERE
						erp_deliveries.id =NEW.delivery_id
					LIMIT 0,1);

			SET v_tran_note = (SELECT
						erp_deliveries.note
					FROM
						erp_deliveries
					WHERE
						erp_deliveries.id =NEW.delivery_id
					LIMIT 0,1);
			IF v_status = 'completed' THEN
				INSERT INTO erp_inventory_valuation_details (
						type,
						biller_id,
						product_id,
						product_code,
						product_name,
						category_id,
						reference_no,
						date,
						NAME,
						quantity,
						warehouse_id,
						cost,
						qty_on_hand,
						avg_cost,
						created_by,
						updated_by,
						updated_at,
						field_id
						)
						VALUES
						(
						v_transaction_type,
						v_biller_id,
						NEW.product_id,
						NEW.product_code,
						NEW.product_name,
						v_category_id,
						v_reference_no,
						v_date ,
						v_supplier,
						(-1)*NEW.quantity_balance,
						NEW.warehouse_id,
						v_cost,
						v_qoh,
						v_cost,
						v_created_by,
						v_updated_by,
						v_updated_at,
						v_transaction_id
					);
			            END IF;
			  END IF;
                                      /* DELIVERY */

		/* SALE RETURN */
		IF v_transaction_type = 'SALE RETURN' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_return_sales.date
			FROM
				erp_return_sales
				JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
			WHERE
				erp_return_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_return_sales.reference_no
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
						erp_return_sales.customer
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_return_sales.biller_id
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_return_sales.created_by
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_return_sales.updated_by
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_at = (SELECT
						erp_return_sales.updated_at
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);

			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				updated_by,
				updated_at,
				field_id
				)
				VALUES
				(
				v_transaction_type,
				v_biller_id,
				NEW.product_id,
				NEW.product_code,
				NEW.product_name,
				v_category_id,
				v_reference_no,
				v_date ,
				v_supplier,
				NEW.quantity_balance,
				NEW.warehouse_id,
				v_cost,
				v_qoh,
				v_cost,
				v_created_by,
				v_updated_by,
				v_updated_at,
				v_transaction_id
				);
		END IF;
		/* End SALE RETURN */

		/* PURCHASE */
		IF NEW.transaction_type = 'PURCHASE' THEN
			SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id  	= (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);


			SET v_date = (SELECT
				erp_purchases.date
			FROM
				erp_purchases
				JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
			WHERE
				erp_purchase_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_purchases.reference_no
					FROM
						erp_purchases
					WHERE
						erp_purchases.id = NEW.purchase_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
						erp_purchases.supplier
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id  = (SELECT
						erp_purchases.biller_id
					FROM
						erp_purchases
					WHERE
						erp_purchases.id =  NEW.purchase_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_purchases.created_by
					FROM
						erp_purchases
					WHERE
						erp_purchases.id = NEW.purchase_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_purchases.updated_by
					FROM
						erp_purchases
					WHERE
						erp_purchases.id = NEW.purchase_id
					LIMIT 0,1);
			SET v_updated_at = (SELECT
						erp_purchases.updated_at
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						erp_purchases.status
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_tran_note = (SELECT
						erp_purchases.note
					FROM
						erp_purchases
					WHERE
						erp_purchases.id = NEW.purchase_id
					LIMIT 0,1);

			IF v_acc_cate_separate = 1 THEN

				SET  v_chk_acc  =  ( SELECT
										COUNT(*) as row
									FROM
										erp_categories
									INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_purchase
									INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
									WHERE
										erp_categories.id = v_category_id );

				IF NEW.status = "received" THEN

					IF   v_chk_acc  > 0 THEN

						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							created_by,
							updated_by
						) SELECT
							'PURCHASES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(NEW.subtotal + NEW.net_shipping),
							v_reference_no,
							v_tran_note   ,
							v_biller_id,
							v_created_by,
							v_updated_by
						FROM
							erp_categories
							INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_purchase
							INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_categories.id = v_category_id ;

						IF NEW.cb_qty < 0 THEN

							INSERT INTO erp_gl_trans (
								tran_type,
								tran_no,
								tran_date,
								sectionid,
								account_code,
								narrative,
								amount,
								reference_no,
								description,
								biller_id,
								created_by,
								updated_by
							) SELECT

								'PURCHASES',
								v_tran_no,
								NEW.date,
								erp_gl_sections.sectionid,
								erp_gl_charts.accountcode,
								erp_gl_charts.accountname,
								((NEW.real_unit_cost - NEW.cb_avg) * NEW.cb_qty),
								v_reference_no,
								v_tran_note   ,
								v_biller_id,
								v_created_by,
								v_updated_by
							FROM
								erp_categories
								INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
								INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
							WHERE
								erp_categories.id = v_category_id ;

							INSERT INTO erp_gl_trans (
								tran_type,
								tran_no,
								tran_date,
								sectionid,
								account_code,
								narrative,
								amount,
								reference_no,
								description,
								biller_id,
								created_by,
								updated_by
							) SELECT

								'PURCHASES',
								v_tran_no,
								NEW.date,
								erp_gl_sections.sectionid,
								erp_gl_charts.accountcode,
								erp_gl_charts.accountname,
								(-1) * ((NEW.real_unit_cost - NEW.cb_avg) * NEW.cb_qty),
								v_reference_no,
								v_tran_note   ,
								v_biller_id,
								v_created_by,
								v_updated_by
							FROM
								erp_categories
								INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_cost
								INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
							WHERE
								erp_categories.id = v_category_id ;

						END IF;

					END IF;

					IF   v_chk_acc  <= 0   THEN

						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							created_by,
							updated_by
						) SELECT

							'PURCHASES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(NEW.subtotal + NEW.net_shipping),
							v_reference_no,
							v_tran_note   ,
							v_biller_id,
							v_created_by,
							v_updated_by
						FROM
							erp_account_settings
							INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
							INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_purchase;

						IF NEW.cb_qty < 0 THEN

							INSERT INTO erp_gl_trans (
								tran_type,
								tran_no,
								tran_date,
								sectionid,
								account_code,
								narrative,
								amount,
								reference_no,
								description,
								biller_id,
								created_by,
								updated_by
							) SELECT

								'PURCHASES',
								v_tran_no,
								NEW.date,
								erp_gl_sections.sectionid,
								erp_gl_charts.accountcode,
								erp_gl_charts.accountname,
								((NEW.real_unit_cost - NEW.cb_avg) * NEW.cb_qty),
								v_reference_no,
								v_tran_note   ,
								v_biller_id,
								v_created_by,
								v_updated_by
							FROM
								erp_account_settings
								INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
								INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
							WHERE
								erp_gl_charts.accountcode = erp_account_settings.default_stock;

							INSERT INTO erp_gl_trans (
								tran_type,
								tran_no,
								tran_date,
								sectionid,
								account_code,
								narrative,
								amount,
								reference_no,
								description,
								biller_id,
								created_by,
								updated_by
							) SELECT

								'PURCHASES',
								v_tran_no,
								NEW.date,
								erp_gl_sections.sectionid,
								erp_gl_charts.accountcode,
								erp_gl_charts.accountname,
								(-1) * ((NEW.real_unit_cost - NEW.cb_avg) * NEW.cb_qty),
								v_reference_no,
								v_tran_note   ,
								v_biller_id,
								v_created_by,
								v_updated_by
							FROM
								erp_account_settings
								INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
								INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
							WHERE
								erp_gl_charts.accountcode = erp_account_settings.default_cost;

						END IF;

					END IF;

				END IF;

			END IF;


			IF v_status = 'received' THEN
				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					updated_at,
					field_id
					)
					VALUES
					(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date ,
					v_supplier,
					NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_updated_by,
					v_updated_at,
					v_transaction_id
				);
			END IF;
		END IF;
		/* End PURCHASE */

		/* PURCHASE RETURN */
		IF NEW.transaction_type = 'PURCHASE RETURN' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_return_purchases.date
			FROM
				erp_return_purchases
				JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
			WHERE
				erp_return_purchase_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_return_purchases.reference_no
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
						erp_return_purchases.supplier
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_return_purchases.biller_id
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_return_purchases.created_by
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_return_purchases.updated_by
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_at = (SELECT
						erp_return_purchases.updated_at
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);

			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				updated_by,
				updated_at,
				field_id
				)
				VALUES
				(
				v_transaction_type,
				v_biller_id,
				NEW.product_id,
				NEW.product_code,
				NEW.product_name,
				v_category_id,
				v_reference_no,
				v_date ,
				v_supplier,
				(-1)*NEW.quantity_balance,
				NEW.warehouse_id,
				v_cost,
				v_qoh,
				v_cost,
				v_created_by,
				v_updated_by,
				v_updated_at,
				v_transaction_id
			);
		END IF;
		/* End PURCHASE RETURN */

		/* TRANSFER */
		IF NEW.transaction_type = 'TRANSFER' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_transfers.date
			FROM
				erp_transfers
				JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
			WHERE
				erp_transfer_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_transfers.transfer_no
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_transfers.biller_id
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_transfers.created_by
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						erp_transfers.status
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);
			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				field_id
				)
				VALUES
				(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date,
					NULL,
					(-1)*NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_transaction_id
				);
		END IF;
		/* End TRANSFER */

		/* USING STOCK */
		IF NEW.transaction_type = 'USING STOCK' THEN
			SET v_cost = (SELECT cost FROM erp_products WHERE id = NEW.product_id);
			SET v_category_id = (SELECT category_id FROM erp_products WHERE id = NEW.product_id);
			SET v_qoh =  (SELECT quantity FROM erp_products WHERE id = NEW.product_id);

			SET v_date = (SELECT
				erp_enter_using_stock.date
			FROM
				erp_enter_using_stock
				JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
			WHERE
				erp_enter_using_stock_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_enter_using_stock.reference_no
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_enter_using_stock.shop
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_enter_using_stock.create_by
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);
			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				field_id
				)
				VALUES
				(
				v_transaction_type,
				v_biller_id,
				NEW.product_id,
				NEW.product_code,
				NEW.product_name,
				v_category_id,
				v_reference_no,
				v_date ,
				NULL,
				NEW.quantity_balance,
				NEW.warehouse_id,
				v_cost,
				v_qoh,
				v_cost,
				v_created_by,
				v_transaction_id
			);
		END IF;
		/* End USING STOCK */

		/* RETURN USING STOCK */
		IF NEW.transaction_type = 'RETURN USING STOCK' THEN
			SET v_cost = (SELECT cost FROM erp_products WHERE id = NEW.product_id);
			SET v_category_id = (SELECT category_id FROM erp_products WHERE id = NEW.product_id);
			SET v_qoh =  (SELECT quantity FROM erp_products WHERE id = NEW.product_id);

			SET v_date = (SELECT
				erp_enter_using_stock.date
			FROM
				erp_enter_using_stock
				JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
			WHERE
				erp_enter_using_stock_items.id = v_transaction_id
			LIMIT 0,1);

			SET v_reference_no = (SELECT
						erp_enter_using_stock.reference_no
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);

			SET v_biller_id = (SELECT
						erp_enter_using_stock.shop
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);

			SET v_created_by = (SELECT
						erp_enter_using_stock.create_by
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);

			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				field_id
				)
				VALUES
				(
				v_transaction_type,
				v_biller_id,
				NEW.product_id,
				NEW.product_code,
				NEW.product_name,
				v_category_id,
				v_reference_no,
				v_date ,
				NULL,
				NEW.quantity_balance,
				NEW.warehouse_id,
				v_cost,
				v_qoh,
				v_cost,
				v_created_by,
				v_transaction_id
			);
		END IF;
		/* RETURN USING STOCK */

		/* ADJUSTMENT */
		IF NEW.transaction_type = 'ADJUSTMENT' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_adjustments.date
			FROM
				erp_adjustments
			INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
			WHERE
				erp_adjustment_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_adjustments.biller_id
					FROM
						erp_adjustments
                    INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
					WHERE
						erp_adjustment_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_adjustments.created_by
					FROM
						erp_adjustments
                    INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
					WHERE
						erp_adjustment_items.id  = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_adjustments.updated_by
					FROM
						erp_adjustments
					INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
					WHERE
						erp_adjustment_items.id  =  v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						type
					FROM
						erp_adjustment_items
					WHERE
						id = v_transaction_id
					LIMIT 0,1);

			SET v_reference_no = (SELECT
						erp_adjustments.reference_no
					FROM
						erp_adjustments
						JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
					WHERE
						erp_adjustment_items.id = v_transaction_id
					LIMIT 0,1);

			IF v_status = 'addition' THEN

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date ,
					v_supplier,
					NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_updated_by,
					v_transaction_id
				);

			ELSE

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date ,
					v_supplier,
					NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_updated_by,
					v_transaction_id
				);

			END IF;

		END IF;
		/* End ADJUSTMENT */

		/* CONVERT */
		IF NEW.transaction_type = 'CONVERT' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id =(SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_convert.date
			FROM
				erp_convert
				JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
			WHERE
				erp_convert_items.id = v_transaction_id
			LIMIT 0,1);

			SET v_reference_no = (SELECT
						erp_convert.reference_no
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_convert_items.id = v_transaction_id
					LIMIT 0,1);

		                 SET v_biller_id = (SELECT
						erp_convert.biller_id
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_convert_items.id = v_transaction_id
					LIMIT 0,1);


			SET v_created_by = (SELECT
						erp_convert.created_by
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_convert_items.id  = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_convert.updated_by
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_convert_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						erp_convert_items.status
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_convert_items.id = v_transaction_id
					LIMIT 0,1);
			IF v_status = 'add' THEN

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date ,
					NULL,
					NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_updated_by,
					v_transaction_id
				);

			ELSE

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
						v_transaction_type,
						v_biller_id,
						NEW.product_id,
						NEW.product_code,
						NEW.product_name,
						v_category_id,
						v_reference_no,
						v_date ,
						NULL,
						NEW.quantity_balance,
						NEW.warehouse_id,
						v_cost,
						v_qoh,
						v_cost,
						v_created_by,
						v_updated_by,
						v_transaction_id
					);

			END IF;

		END IF;

		/* End CONVERT */

        /* PURCHASE OPENING QTY */
		IF NEW.transaction_type = 'OPENING QUANTITY' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id  = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_biller_id  = 0;
			SET v_date = CURDATE();

			SET v_reference_no = (SELECT
						erp_purchases.reference_no
					FROM
						erp_purchases
					WHERE
						erp_purchases.id = NEW.purchase_id
					LIMIT 0,1);

			SET v_supplier = (SELECT
						erp_purchases.supplier
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);

			SET v_created_by = (SELECT
						erp_purchases.created_by
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_purchases.updated_by
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_at = (SELECT
						erp_purchases.updated_at
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);

            INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
						v_transaction_type,
						v_biller_id,
						NEW.product_id,
						NEW.product_code,
						NEW.product_name,
						v_category_id,
						v_reference_no,
						v_date ,
						NULL,
						NEW.quantity_balance,
						NEW.warehouse_id,
						v_cost,
						v_qoh,
						v_cost,
						v_created_by,
						v_updated_by,
						v_transaction_id
					);
		END IF;
		/* End PURCHASE OPENING QTY */
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchase_items
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_purchase_items_update`;
delimiter ;;
CREATE TRIGGER `audit_purchase_items_update` BEFORE UPDATE ON `erp_purchase_items` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_purchase_items_audit (
			id,
			delivery_id,
			purchase_id,
			transfer_id,
			product_id,
			product_code,
			product_name,
			option_id,
			product_type,
			net_unit_cost,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			expiry,
			subtotal,
			quantity_balance,
			date,
			status,
			unit_cost,
			real_unit_cost,
			quantity_received,
			supplier_part_no,
			supplier_id,
			job_name,
			note,
			convert_id,
			type,
			reference,
			opening_stock,
			create_id,
			returned,
			acc_cate_separate,
			specific_tax_on_certain_merchandise_and_services,
			accommodation_tax,
			public_lighting_tax,
			other_tax,
			payment_of_profit_tax,
			performance_royalty_intangible,
			payment_interest_non_bank,
			payment_interest_taxpayer_fixed,
			payment_interest_taxpayer_non_fixed,
			payment_rental_immovable_property,
			payment_of_interest,
			payment_royalty_rental_income_related,
			payment_management_technical,
			payment_dividend,
			withholding_tax_on_resident,
			withholding_tax_on_non_resident,
			audit_type
		) SELECT
			id,
			delivery_id,
			purchase_id,
			transfer_id,
			product_id,
			product_code,
			product_name,
			option_id,
			product_type,
			net_unit_cost,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			expiry,
			subtotal,
			quantity_balance,
			date,
			status,
			unit_cost,
			real_unit_cost,
			quantity_received,
			supplier_part_no,
			supplier_id,
			job_name,
			note,
			convert_id,
			type,
			reference,
			opening_stock,
			create_id,
			returned,
			acc_cate_separate,
			specific_tax_on_certain_merchandise_and_services,
			accommodation_tax,
			public_lighting_tax,
			other_tax,
			payment_of_profit_tax,
			performance_royalty_intangible,
			payment_interest_non_bank,
			payment_interest_taxpayer_fixed,
			payment_interest_taxpayer_non_fixed,
			payment_rental_immovable_property,
			payment_of_interest,
			payment_royalty_rental_income_related,
			payment_management_technical,
			payment_dividend,
			withholding_tax_on_resident,
			withholding_tax_on_non_resident,
			"UPDATED"
		FROM
			erp_purchase_items
		WHERE
			erp_purchase_items.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchase_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_purchase_items_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_purchase_items_update` AFTER UPDATE ON `erp_purchase_items` FOR EACH ROW BEGIN
	DECLARE v_reference_no VARCHAR(55);
	DECLARE v_date DATETIME;
	DECLARE v_biller_id INTEGER;
	DECLARE v_supplier VARCHAR(55);
	DECLARE v_created_by INTEGER;
	DECLARE v_updated_by INTEGER;
	DECLARE v_cost DECIMAL(4);
	DECLARE v_status VARCHAR(50);
	DECLARE v_category_id INTEGER;
	DECLARE v_qoh INTEGER;
	DECLARE v_updated_at DATETIME;
	DECLARE v_transaction_id INTEGER;
	DECLARE v_transaction_type VARCHAR(25);
	DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_tran_note VARCHAR(255);
    DECLARE v_chk_acc  INTEGER;
	DECLARE v_tran_no INTEGER;


	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF NEW.product_id THEN

		SET v_transaction_id = NEW.transaction_id;
		SET v_transaction_type = NEW.transaction_type;

		/* SALE */
		IF NEW.transaction_id THEN
			IF v_transaction_type = 'SALE' THEN

				SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
				SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
				SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);
															SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);

				SET v_date = (SELECT
					erp_sales.date
				FROM
					erp_sales
					JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
				WHERE
					erp_sale_items.id = v_transaction_id
				LIMIT 0,1);
				SET v_reference_no = (SELECT
							erp_sales.reference_no
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_supplier = (SELECT
							erp_sales.customer
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_biller_id = (SELECT
							erp_sales.biller_id
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_created_by = (SELECT
							erp_sales.created_by
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items = v_transaction_id
						LIMIT 0,1);
				SET v_updated_by = (SELECT
							erp_sales.updated_by
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_status = (SELECT
							erp_sales.sale_status
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);
				SET v_updated_at = (SELECT
							erp_sales.updated_at
						FROM
							erp_sales
							JOIN erp_sale_items ON erp_sales.id = erp_sale_items.sale_id
						WHERE
							erp_sale_items.id = v_transaction_id
						LIMIT 0,1);

				DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'SALE' AND field_id = v_transaction_id;

				IF v_status = 'completed' THEN
					INSERT INTO erp_inventory_valuation_details (
						type,
						biller_id,
						product_id,
						product_code,
						product_name,
						category_id,
						reference_no,
						date,
						NAME,
						quantity,
						warehouse_id,
						cost,
						qty_on_hand,
						avg_cost,
						created_by,
						updated_by,
						updated_at,
						field_id
						)
						VALUES
						(
						v_transaction_type,
						v_biller_id,
						NEW.product_id,
						NEW.product_code,
						NEW.product_name,
						v_category_id,
						v_reference_no,
						v_date ,
						v_supplier,
						(-1)*NEW.quantity_balance,
						NEW.warehouse_id,
						v_cost,
						v_qoh,
						v_cost,
						v_created_by,
						v_updated_by,
						v_updated_at,
						v_transaction_id
					);
				END IF;

				END IF;
		END IF;
		/* End SALE */

		/* SALE RETURN */
		IF v_transaction_type = 'SALE RETURN' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_return_sales.date
			FROM
				erp_return_sales
				JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
			WHERE
				erp_return_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_return_sales.reference_no
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
						erp_return_sales.customer
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_return_sales.biller_id
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_return_sales.created_by
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_return_sales.updated_by
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_at = (SELECT
						erp_return_sales.updated_at
					FROM
						erp_return_sales
						JOIN erp_return_items ON erp_return_sales.id = erp_return_items.return_id
					WHERE
						erp_return_items.id = v_transaction_id
					LIMIT 0,1);

			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'SALE RETURN' AND field_id = v_transaction_id;

			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				updated_by,
				updated_at,
				field_id
				)
				VALUES
				(
				v_transaction_type,
				v_biller_id,
				NEW.product_id,
				NEW.product_code,
				NEW.product_name,
				v_category_id,
				v_reference_no,
				v_date ,
				v_supplier,
				NEW.quantity_balance,
				NEW.warehouse_id,
				v_cost,
				v_qoh,
				v_cost,
				v_created_by,
				v_updated_by,
				v_updated_at,
				v_transaction_id
				);
		END IF;
		/* End SALE RETURN */

		/* PURCHASE */
		IF NEW.transaction_type = 'PURCHASE' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_purchases.date
			FROM
				erp_purchases
				JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
			WHERE
				erp_purchase_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_purchases.reference_no
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
						erp_purchases.supplier
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_purchases.biller_id
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_purchases.created_by
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_purchases.updated_by
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_at = (SELECT
						erp_purchases.updated_at
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						erp_purchases.status
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_tran_note = (SELECT
						erp_purchases.note
					FROM
						erp_purchases
						JOIN erp_purchase_items ON erp_purchases.id = erp_purchase_items.purchase_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);

			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'PURCHASE' AND field_id = v_transaction_id;

			IF v_status = 'received' THEN
				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					updated_at,
					field_id
					)
					VALUES
					(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date ,
					v_supplier,
					NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_updated_by,
					v_updated_at,
					v_transaction_id
				);
			END IF;

		END IF;
		/* End PURCHASE */

		/* PURCHASE RETURN */
		IF NEW.transaction_type = 'PURCHASE RETURN' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_return_purchases.date
			FROM
				erp_return_purchases
				JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
			WHERE
				erp_return_purchase_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_return_purchases.reference_no
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
						erp_return_purchases.supplier
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_return_purchases.biller_id
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_return_purchases.created_by
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_return_purchases.updated_by
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_at = (SELECT
						erp_return_purchases.updated_at
					FROM
						erp_return_purchases
						JOIN erp_return_purchase_items ON erp_return_purchases.id = erp_return_purchase_items.return_id
					WHERE
						erp_return_purchase_items.id = v_transaction_id
					LIMIT 0,1);

			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'PURCHASE RETURN' AND field_id = v_transaction_id;

			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				updated_by,
				updated_at,
				field_id
				)
				VALUES
				(
				v_transaction_type,
				v_biller_id,
				NEW.product_id,
				NEW.product_code,
				NEW.product_name,
				v_category_id,
				v_reference_no,
				v_date ,
				v_supplier,
				(-1)*NEW.quantity_balance,
				NEW.warehouse_id,
				v_cost,
				v_qoh,
				v_cost,
				v_created_by,
				v_updated_by,
				v_updated_at,
				v_transaction_id
			);
		END IF;
		/* End PURCHASE RETURN */

		/* TRANSFER */
		IF NEW.transaction_type = 'TRANSFER' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_transfers.date
			FROM
				erp_transfers
				JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
			WHERE
				erp_transfer_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_transfers.transfer_no
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_transfers.biller_id
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_transfers.created_by
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						erp_transfers.status
					FROM
						erp_transfers
						JOIN erp_transfer_items ON erp_transfers.id = erp_transfer_items.transfer_id
					WHERE
						erp_transfer_items.id = v_transaction_id
					LIMIT 0,1);

			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'TRANSFER' AND field_id = v_transaction_id;

			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				field_id
				)
				VALUES
				(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date,
					NULL,
					(-1)*NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_transaction_id
				);
		END IF;
		/* End TRANSFER */

		/* USING STOCK */
		IF NEW.transaction_type = 'USING STOCK' THEN
			SET v_cost = (SELECT cost FROM erp_products WHERE id = NEW.product_id);
			SET v_category_id = (SELECT category_id FROM erp_products WHERE id = NEW.product_id);
			SET v_qoh =  (SELECT quantity FROM erp_products WHERE id = NEW.product_id);

			SET v_date = (SELECT
				erp_enter_using_stock.date
			FROM
				erp_enter_using_stock
				JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
			WHERE
				erp_enter_using_stock_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_enter_using_stock.reference_no
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_enter_using_stock.shop
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_enter_using_stock.create_by
					FROM
						erp_enter_using_stock
						JOIN erp_enter_using_stock_items ON erp_enter_using_stock.reference_no = erp_enter_using_stock_items.reference_no
					WHERE
						erp_enter_using_stock_items.id = v_transaction_id
					LIMIT 0,1);

			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'USING STOCK' AND field_id = v_transaction_id;

			INSERT INTO erp_inventory_valuation_details (
				type,
				biller_id,
				product_id,
				product_code,
				product_name,
				category_id,
				reference_no,
				date,
				NAME,
				quantity,
				warehouse_id,
				cost,
				qty_on_hand,
				avg_cost,
				created_by,
				field_id
				)
				VALUES
				(
				v_transaction_type,
				v_biller_id,
				NEW.product_id,
				NEW.product_code,
				NEW.product_name,
				v_category_id,
				v_reference_no,
				v_date ,
				NULL,
				(-1)*NEW.quantity_balance,
				NEW.warehouse_id,
				v_cost,
				v_qoh,
				v_cost,
				v_created_by,
				v_transaction_id
			);
		END IF;
		/* End USING STOCK */

		/* ADJUSTMENT */
		IF NEW.transaction_type = 'ADJUSTMENT' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_adjustments.date
			FROM
				erp_adjustments
			INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
			WHERE
				erp_adjustment_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_adjustments.biller_id
					FROM
						erp_adjustments
                    INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
					WHERE
						erp_adjustment_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_adjustments.created_by
					FROM
						erp_adjustments
                                                                                             INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
					WHERE
						erp_adjustment_items.id  = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_adjustments.updated_by
					FROM
						erp_adjustments
                                                                                             INNER JOIN erp_adjustment_items ON erp_adjustment_items.adjust_id = erp_adjustments.id
					WHERE
						erp_adjustment_items.id  =  v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						type
					FROM
						erp_adjustment_items
					WHERE
						id = v_transaction_id
					LIMIT 0,1);

			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'ADJUSTMENT' AND field_id = v_transaction_id;

			IF v_status = 'addition' THEN

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
						v_transaction_type,
						v_biller_id,
						NEW.product_id,
						NEW.product_code,
						NEW.product_name,
						v_category_id,
						NULL,
						v_date ,
						v_supplier,
						NEW.quantity_balance,
						NEW.warehouse_id,
						v_cost,
						v_qoh,
						v_cost,
						v_created_by,
						v_updated_by,
						v_transaction_id
					);

			ELSE

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					NULL,
					v_date ,
					v_supplier,
					NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_updated_by,
					v_transaction_id
				);

			END IF;

		END IF;
		/* End ADJUSTMENT */

		/* CONVERT */
		IF NEW.transaction_type = 'CONVERT' THEN
			SET v_cost = (SELECT erp_products.cost FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
			SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);

			SET v_date = (SELECT
				erp_convert.date
			FROM
				erp_convert
				JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
			WHERE
				erp_convert_items.id = v_transaction_id
			LIMIT 0,1);
			SET v_reference_no = (SELECT
						erp_convert.reference_no
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_supplier = (SELECT
						erp_convert.customer
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_biller_id = (SELECT
						erp_convert.biller_id
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_created_by = (SELECT
						erp_convert.created_by
					FROM
						erp_purchases
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_updated_by = (SELECT
						erp_convert.updated_by
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			SET v_status = (SELECT
						erp_convert.status
					FROM
						erp_convert
						JOIN erp_convert_items ON erp_convert.id = erp_convert_items.convert_id
					WHERE
						erp_purchase_items.id = v_transaction_id
					LIMIT 0,1);
			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = NEW.product_id AND type = 'CONVERT' AND field_id = v_transaction_id;
			IF v_status = 'add' THEN

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
					v_transaction_type,
					v_biller_id,
					NEW.product_id,
					NEW.product_code,
					NEW.product_name,
					v_category_id,
					v_reference_no,
					v_date ,
					NULL,
					NEW.quantity_balance,
					NEW.warehouse_id,
					v_cost,
					v_qoh,
					v_cost,
					v_created_by,
					v_updated_by,
					v_transaction_id
				);

			ELSE

				INSERT INTO erp_inventory_valuation_details (
					type,
					biller_id,
					product_id,
					product_code,
					product_name,
					category_id,
					reference_no,
					date,
					NAME,
					quantity,
					warehouse_id,
					cost,
					qty_on_hand,
					avg_cost,
					created_by,
					updated_by,
					field_id
					)
					VALUES
					(
						v_transaction_type,
						v_biller_id,
						NEW.product_id,
						NEW.product_code,
						NEW.product_name,
						v_category_id,
						v_reference_no,
						v_date ,
						NULL,
						(-1)*NEW.quantity_balance,
						NEW.warehouse_id,
						v_cost,
						v_qoh,
						v_cost,
						v_created_by,
						v_updated_by,
						v_transaction_id
					);

			END IF;

		END IF;
		/* End CONVERT */
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchase_items
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_purchase_items_delete`;
delimiter ;;
CREATE TRIGGER `audit_purchase_items_delete` BEFORE DELETE ON `erp_purchase_items` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_purchase_items_audit (
			id,
			delivery_id,
			purchase_id,
			transfer_id,
			product_id,
			product_code,
			product_name,
			option_id,
			product_type,
			net_unit_cost,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			expiry,
			subtotal,
			quantity_balance,
			date,
			status,
			unit_cost,
			real_unit_cost,
			quantity_received,
			supplier_part_no,
			supplier_id,
			job_name,
			note,
			convert_id,
			type,
			reference,
			opening_stock,
			create_id,
			returned,
			acc_cate_separate,
			specific_tax_on_certain_merchandise_and_services,
			accommodation_tax,
			public_lighting_tax,
			other_tax,
			payment_of_profit_tax,
			performance_royalty_intangible,
			payment_interest_non_bank,
			payment_interest_taxpayer_fixed,
			payment_interest_taxpayer_non_fixed,
			payment_rental_immovable_property,
			payment_of_interest,
			payment_royalty_rental_income_related,
			payment_management_technical,
			payment_dividend,
			withholding_tax_on_resident,
			withholding_tax_on_non_resident,
			audit_type
		) SELECT
			id,
			delivery_id,
			purchase_id,
			transfer_id,
			product_id,
			product_code,
			product_name,
			option_id,
			product_type,
			net_unit_cost,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			expiry,
			subtotal,
			quantity_balance,
			date,
			status,
			unit_cost,
			real_unit_cost,
			quantity_received,
			supplier_part_no,
			supplier_id,
			job_name,
			note,
			convert_id,
			type,
			reference,
			opening_stock,
			create_id,
			returned,
			acc_cate_separate,
			specific_tax_on_certain_merchandise_and_services,
			accommodation_tax,
			public_lighting_tax,
			other_tax,
			payment_of_profit_tax,
			performance_royalty_intangible,
			payment_interest_non_bank,
			payment_interest_taxpayer_fixed,
			payment_interest_taxpayer_non_fixed,
			payment_rental_immovable_property,
			payment_of_interest,
			payment_royalty_rental_income_related,
			payment_management_technical,
			payment_dividend,
			withholding_tax_on_resident,
			withholding_tax_on_non_resident,
			"DELETED"
		FROM
			erp_purchase_items
		WHERE
			erp_purchase_items.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchase_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_purchase_items_delete`;
delimiter ;;
CREATE TRIGGER `gl_trans_purchase_items_delete` AFTER DELETE ON `erp_purchase_items` FOR EACH ROW BEGIN
DECLARE v_reference_no VARCHAR(55);
DECLARE v_status VARCHAR(50);
DECLARE v_transaction_id INTEGER;
DECLARE v_transaction_type VARCHAR(25);

IF OLD.product_id THEN

	SET v_transaction_id = OLD.transaction_id;
	SET v_transaction_type = OLD.transaction_type;

	IF OLD.transaction_id THEN

		/* SALE */
		IF v_transaction_type = 'SALE' THEN
			IF v_status = 'completed' THEN
				DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'SALE' AND field_id = v_transaction_id;
			END IF;
		END IF;
		/* End SALE */

		/* SALE RETURN */
		IF v_transaction_type = 'SALE RETURN' THEN
			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'SALE RETURN' AND field_id = v_transaction_id;
		END IF;
		/* End SALE RETURN */

		/* PURCHASE */
		IF v_transaction_type = 'PURCHASE' THEN
			IF v_status = 'received' THEN
				DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'PURCHASE' AND field_id = v_transaction_id;
			END IF;
		END IF;
		/* End PURCHASE */

		/* PURCHASE RETURN */
		IF v_transaction_type = 'PURCHASE RETURN' THEN
			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'PURCHASE RETURN' AND field_id = v_transaction_id;
		END IF;
		/* End PURCHASE RETURN */

		/* TRANSFER */
		IF v_transaction_type = 'TRANSFER' THEN
			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'TRANSFER' AND field_id = v_transaction_id;
		END IF;
		/* End TRANSFER */

		/* USING STOCK */
		IF v_transaction_type = 'USING STOCK' THEN
			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'USING STOCK' AND field_id = v_transaction_id;
		END IF;
		/* End USING STOCK */

		/* ADJUSTMENT */
		IF v_transaction_type = 'ADJUSTMENT' THEN
			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'ADJUSTMENT' AND field_id = v_transaction_id;
		END IF;
		/* End ADJUSTMENT */

		/* CONVERT */
		IF v_transaction_type = 'CONVERT' THEN
			DELETE FROM erp_inventory_valuation_details WHERE reference_no = v_reference_no AND product_id = OLD.product_id AND type = 'CONVERT' AND field_id = v_transaction_id;
		END IF;
		/* End CONVERT */
	END IF;
END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_purchase_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_purchase_insert` AFTER INSERT ON `erp_purchases` FOR EACH ROW BEGIN
	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF NEW.status="received" AND NEW.total > 0 THEN

		SET v_tran_date = (SELECT erp_purchases.date
				FROM erp_payments
				INNER JOIN erp_purchases ON erp_purchases.id = erp_payments.purchase_id
				WHERE erp_purchases.id = NEW.id LIMIT 0,1);

		IF v_tran_date = NEW.date THEN
			SET v_tran_no = (SELECT MAX(tran_no) + 1 FROM erp_gl_trans);
		ELSE
			SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

			UPDATE erp_order_ref
			SET tr = v_tran_no
			WHERE
			DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
		END IF;

		IF NEW.type_of_po="po"  THEN

			IF NEW.opening_ap != 1 THEN

				IF  v_acc_cate_separate <> 1 THEN

					IF NEW.cogs <> 0 THEN

						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'PURCHASES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							NEW.cogs,
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
							INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
							INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_stock;

						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'PURCHASES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(-1) * NEW.cogs,
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
							INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
							INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_cost;

					END IF;

					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'PURCHASES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.total + NEW.shipping,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_purchase;

				END IF;

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
				) SELECT
					'PURCHASES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * abs(NEW.grand_total),
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_payable
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_payable;

			END IF;

			IF NEW.order_discount THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
					) SELECT
					'PURCHASES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * abs(NEW.order_discount),

					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount
						INNER JOIN erp_gl_sections

						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount;
			END IF;

			IF NEW.order_tax THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
					) SELECT
					'PURCHASES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					NEW.order_tax,
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax;
			END IF;

		END IF;

		IF NEW.opening_ap = 1 THEN

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				) SELECT
				'PURCHASES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.grand_total),
				NEW.reference_no,
				NEW.note,
				NEW.biller_id,
				NEW.customer_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_open_balance;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				) SELECT
				'PURCHASES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * abs(NEW.grand_total),
				NEW.reference_no,
				NEW.note,
				NEW.biller_id,
				NEW.customer_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_payable
					INNER JOIN erp_gl_sections
					ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_payable;

		END IF;


	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_purchases_update`;
delimiter ;;
CREATE TRIGGER `audit_purchases_update` BEFORE UPDATE ON `erp_purchases` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_purchases_audit (
			id,
			biller_id,
			reference_no,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			opening_ap,
			type_of_po,
			order_ref,
			request_ref,
			paid_by,
			order_id,
			account_code,
			pur_refer,
			purchase_type,
			purchase_status,
			tax_type,
			item_status,
			container_no,
			container_size,
			invoice_no,
			order_reference_no,
			good_or_services,
			acc_cate_separate,
			audit_type
		) SELECT
			id,
			biller_id,
			reference_no,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			opening_ap,
			type_of_po,
			order_ref,
			request_ref,
			paid_by,
			order_id,
			account_code,
			pur_refer,
			purchase_type,
			purchase_status,
			tax_type,
			item_status,
			container_no,
			container_size,
			invoice_no,
			order_reference_no,
			good_or_services,
			acc_cate_separate,
			"UPDATED"
		FROM
			erp_purchases
		WHERE
			erp_purchases.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_purchase_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_purchase_update` AFTER UPDATE ON `erp_purchases` FOR EACH ROW BEGIN
	DECLARE v_tran_no INTEGER;
    DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_tran_date DATETIME;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF NEW.type_of_po = "po" THEN

		IF NEW.updated_by > 0 AND NEW.updated_count <> OLD.updated_count THEN

			DELETE FROM erp_gl_trans WHERE tran_type = 'PURCHASES' AND reference_no = NEW.reference_no;

		END IF;

		IF NEW.STATUS = "received" AND NEW.total > 0 AND NEW.updated_by > 0 AND NEW.updated_count <> OLD.updated_count AND ISNULL(NEW.return_id) THEN

			SET v_tran_no = (
				SELECT
					tran_no
				FROM
					erp_gl_trans
				WHERE
					tran_type = 'PURCHASES'
				AND reference_no = NEW.reference_no
				LIMIT 0,
				1
			);

			IF v_tran_no < 1 OR ISNULL(v_tran_no) THEN

				SET v_tran_no = (
					SELECT
						COALESCE (MAX(tran_no), 0) + 1
					FROM
						erp_gl_trans
				);

				UPDATE erp_order_ref
					SET tr = v_tran_no
				WHERE
					DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

			END IF;

			IF NEW.opening_ap != 1 THEN

				IF  v_acc_cate_separate <> 1 THEN

					IF NEW.cogs <> 0 THEN

						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'PURCHASES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							NEW.cogs,
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
							INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
							INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_stock;

						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'PURCHASES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(-1) * NEW.cogs,
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
							INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
							INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_cost;

					END IF;

					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'PURCHASES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.total + NEW.shipping,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_purchase;
				END IF;

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
				) SELECT
					'PURCHASES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(- 1) * abs(NEW.grand_total),
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_payable
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_payable;

				IF NEW.order_discount THEN

					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'PURCHASES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * abs(NEW.order_discount),
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount;


				END IF;

				IF NEW.order_tax THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'PURCHASES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.order_tax,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax;


				END IF;

			END IF;

			IF NEW.opening_ap = 1 THEN

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
					) SELECT
					'PURCHASES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					abs(NEW.grand_total),
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_open_balance;

				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
					) SELECT
					'PURCHASES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(-1) * abs(NEW.grand_total),
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
					FROM
						erp_account_settings
						INNER JOIN erp_gl_charts
						ON erp_gl_charts.accountcode = erp_account_settings.default_payable
						INNER JOIN erp_gl_sections
						ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_payable;

			END IF;

		END IF;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_purchases_delete`;
delimiter ;;
CREATE TRIGGER `audit_purchases_delete` BEFORE DELETE ON `erp_purchases` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_purchases_audit (
			id,
			biller_id,
			reference_no,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			opening_ap,
			type_of_po,
			order_ref,
			request_ref,
			paid_by,
			order_id,
			account_code,
			pur_refer,
			purchase_type,
			purchase_status,
			tax_type,
			item_status,
			container_no,
			container_size,
			invoice_no,
			order_reference_no,
			good_or_services,
			acc_cate_separate,
			audit_type
		) SELECT
			id,
			biller_id,
			reference_no,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			opening_ap,
			type_of_po,
			order_ref,
			request_ref,
			paid_by,
			order_id,
			account_code,
			pur_refer,
			purchase_type,
			purchase_status,
			tax_type,
			item_status,
			container_no,
			container_size,
			invoice_no,
			order_reference_no,
			good_or_services,
			acc_cate_separate,
			"DELETED"
		FROM
			erp_purchases
		WHERE
			erp_purchases.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_purchase_delete`;
delimiter ;;
CREATE TRIGGER `gl_trans_purchase_delete` AFTER DELETE ON `erp_purchases` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description = CONCAT(description,' (Cancelled)')
   WHERE reference_no = OLD.reference_no;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchases_order
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_purchases_order_update`;
delimiter ;;
CREATE TRIGGER `audit_purchases_order_update` BEFORE UPDATE ON `erp_purchases_order` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_purchases_order_audit (
			id,
			biller_id,
			reference_no,
			purchase_ref,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			purchase_type,
			purchase_status,
			tax_type,
			order_status,
			request_id,
			audit_type
		) SELECT
			id,
			biller_id,
			reference_no,
			purchase_ref,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			purchase_type,
			purchase_status,
			tax_type,
			order_status,
			request_id,
			"UPDATED"
		FROM
			erp_purchases_order
		WHERE
			erp_purchases_order.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_purchases_order
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_purchases_order_delete`;
delimiter ;;
CREATE TRIGGER `audit_purchases_order_delete` BEFORE DELETE ON `erp_purchases_order` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_purchases_order_audit (
			id,
			biller_id,
			reference_no,
			purchase_ref,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			purchase_type,
			purchase_status,
			tax_type,
			order_status,
			request_id,
			audit_type
		) SELECT
			id,
			biller_id,
			reference_no,
			purchase_ref,
			date,
			supplier_id,
			supplier,
			warehouse_id,
			note,
			total,
			product_discount,
			order_discount_id,
			order_discount,
			total_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			paid,
			status,
			payment_status,
			created_by,
			updated_by,
			updated_at,
			attachment,
			payment_term,
			due_date,
			return_id,
			surcharge,
			suspend_note,
			reference_no_tax,
			tax_status,
			purchase_type,
			purchase_status,
			tax_type,
			order_status,
			request_id,
			"DELETED"
		FROM
			erp_purchases_order
		WHERE
			erp_purchases_order.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_return_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_return_items_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_return_items_insert` AFTER INSERT ON `erp_return_items` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_tran_reference_no VARCHAR(55);
	DECLARE v_tran_customer VARCHAR(55);
	DECLARE v_tran_biller_id INTEGER;
	DECLARE v_tran_created_by INTEGER;
	DECLARE v_tran_updated_by INTEGER;
	DECLARE v_tax_type INTEGER;
	DECLARE v_order_tax_id INTEGER;
	DECLARE v_sale_type INTEGER;
	DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_tran_note VARCHAR(255);
	DECLARE v_category_id INTEGER;
	DECLARE v_unit_quantity INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF v_acc_cate_separate = 1 THEN

		SET v_tran_date = (SELECT erp_return_sales.date
			FROM erp_return_sales
			WHERE erp_return_sales.id = NEW.return_id LIMIT 0,1);

		SET v_tran_reference_no = (SELECT erp_return_sales.reference_no FROM erp_return_sales WHERE erp_return_sales.id = NEW.return_id);
		SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = v_tran_reference_no LIMIT 1);
		SET v_tran_customer = (SELECT erp_return_sales.customer FROM erp_return_sales WHERE erp_return_sales.id = NEW.return_id);
		SET v_tran_biller_id = (SELECT erp_return_sales.biller_id FROM erp_return_sales WHERE erp_return_sales.id = NEW.return_id);
		SET v_tran_created_by = (SELECT erp_return_sales.created_by FROM erp_return_sales WHERE erp_return_sales.id = NEW.return_id);
		SET v_tran_updated_by = (SELECT erp_return_sales.updated_by FROM erp_return_sales WHERE erp_return_sales.id = NEW.return_id);
		SET v_tran_note = (SELECT erp_return_sales.note FROM erp_return_sales WHERE erp_return_sales.id = NEW.return_id);
		SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);

		IF NEW.product_id AND NEW.option_id THEN
			SET v_unit_quantity = (SELECT qty_unit FROM erp_product_variants WHERE product_id = NEW.product_id AND id = NEW.option_id);
		ELSE
			SET v_unit_quantity = 1;
		END IF;

		IF NEW.subtotal > 0 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
			) SELECT
				'SALES-RETURN',
				v_tran_no,
				v_tran_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.subtotal),
				v_tran_reference_no,
				v_tran_customer,
				v_tran_biller_id,
				v_tran_created_by,
				v_tran_updated_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_sale
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;
		END IF;

		IF (NEW.unit_cost * NEW.quantity) > 0 THEN

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				v_tran_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * (NEW.unit_cost * (NEW.quantity * v_unit_quantity)),
				v_tran_reference_no,
				v_tran_customer,
				v_tran_biller_id,
				v_tran_created_by,
				v_tran_updated_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_cost
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				v_tran_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.unit_cost * (NEW.quantity * v_unit_quantity)),
				v_tran_reference_no,
				v_tran_customer,
				v_tran_biller_id,
				v_tran_created_by,
				v_tran_updated_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;

		END IF;

	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_return_purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_return_purchse_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_return_purchse_insert` AFTER INSERT ON `erp_return_purchases` FOR EACH ROW BEGIN

    DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_tran_date = (
		SELECT
			erp_purchases.date
		FROM
			erp_payments
		INNER JOIN erp_purchases ON erp_purchases.id = erp_payments.purchase_id
		WHERE
			erp_purchases.id = NEW.id
		LIMIT 0,
		1
	);

	SET v_acc_cate_separate = (
		SELECT
			erp_settings.acc_cate_separate
		FROM
			erp_settings
		WHERE
			erp_settings.setting_id = '1'
	);

	IF v_tran_date = NEW.date THEN

		SET v_tran_no = (
			SELECT
				MAX(tran_no)
			FROM
				erp_gl_trans
		);

	ELSE

		SET v_tran_no = (
			SELECT
				COALESCE (MAX(tran_no), 0) + 1
			FROM
				erp_gl_trans
		);

		UPDATE erp_order_ref
		SET tr = v_tran_no
		WHERE
			DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

	END IF;

	IF  v_acc_cate_separate <> 1 THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'PURCHASES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * (
				NEW.total + NEW.product_discount + NEW.shipping
			),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
		FROM
			erp_account_settings
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
		INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = erp_account_settings.default_purchase;
	END IF;

	INSERT INTO erp_gl_trans (
		tran_type,
		tran_no,
		tran_date,
		sectionid,
		account_code,
		narrative,
		amount,
		reference_no,
		description,
		biller_id,
		created_by,
		updated_by
	) SELECT
		'PURCHASES-RETURN',
		v_tran_no,
		NEW.date,
		erp_gl_sections.sectionid,
		erp_gl_charts.accountcode,
		erp_gl_charts.accountname,
		abs(NEW.grand_total),
		NEW.reference_no,
		NEW.supplier,
		NEW.biller_id,
		NEW.created_by,
		NEW.updated_by
	FROM
		erp_account_settings
	INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_payable
	INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
	WHERE
		erp_gl_charts.accountcode = erp_account_settings.default_payable;

	IF NEW.total_discount THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'PURCHASES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.total_discount),
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
		FROM
			erp_account_settings
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount
		INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount;


	END IF;

	IF NEW.total_tax THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'PURCHASES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * NEW.total_tax,
			NEW.reference_no,
			NEW.supplier,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
		FROM
			erp_account_settings
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax
		INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_return_sales
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_return_sales_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_return_sales_insert` AFTER INSERT ON `erp_return_sales` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	SET v_tran_date = (SELECT erp_return_sales.date
			FROM erp_payments
			INNER JOIN erp_return_sales ON erp_return_sales.id = erp_payments.return_id
			WHERE erp_return_sales.id = NEW.id LIMIT 0,1);

	IF v_tran_date = NEW.date THEN
		SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);
	ELSE
		SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

		UPDATE erp_order_ref
		SET tr = v_tran_no
		WHERE
		DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
	END IF;

	IF NEW.grand_total > 0 THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * (NEW.grand_total),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_receivable;

	END IF;

	IF v_acc_cate_separate <> 1 THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.total),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,

			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale;

		IF NEW.total_cost > 0 THEN

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * NEW.total_cost,
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_cost
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_cost;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.total_cost),
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;

		END IF;

	END IF;

	IF NEW.order_discount THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * NEW.order_discount,
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_sale_discount
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale_discount;
	END IF;

	IF NEW.order_tax THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.order_tax),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;
	END IF;

	IF NEW.shipping THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.shipping),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_sale_freight
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale_freight;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_return_sales
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_return_sales_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_return_sales_update` AFTER UPDATE ON `erp_return_sales` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	SET v_tran_date = (SELECT erp_return_sales.date
			FROM erp_payments
			INNER JOIN erp_return_sales ON erp_return_sales.id = erp_payments.return_id
			WHERE erp_return_sales.id = NEW.id LIMIT 0,1);

	IF v_tran_date = NEW.date THEN
		SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE erp_gl_trans.reference_no = NEW.reference_no LIMIT 1);
	ELSE
		SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);

		UPDATE erp_order_ref
		SET tr = v_tran_no
		WHERE
		DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
	END IF;

	DELETE FROM erp_gl_trans WHERE erp_gl_trans.reference_no = NEW.reference_no AND erp_gl_trans.tran_type = 'SALES-RETURN';

	IF NEW.grand_total > 0 THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * (NEW.grand_total),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_receivable;

	END IF;

	IF v_acc_cate_separate <> 1 THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
		) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.total),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,

			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale;

		IF NEW.total_cost > 0 THEN

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * NEW.total_cost,
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_cost
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_cost;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				created_by,
				updated_by
				) SELECT
				'SALES-RETURN',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				abs(NEW.total_cost),
				NEW.reference_no,
				NEW.customer,
				NEW.biller_id,
				NEW.created_by,
				NEW.updated_by
				FROM
					erp_account_settings
					INNER JOIN erp_gl_charts
					ON erp_gl_charts.accountcode = erp_account_settings.default_stock
					INNER JOIN erp_gl_sections   ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_stock;

		END IF;

	END IF;

	IF NEW.order_discount THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * NEW.order_discount,
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_sale_discount
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale_discount;
	END IF;

	IF NEW.order_tax THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.order_tax),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;
	END IF;

	IF NEW.shipping THEN
		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			created_by,
			updated_by
			) SELECT
			'SALES-RETURN',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			abs(NEW.shipping),
			NEW.reference_no,
			NEW.customer,
			NEW.biller_id,
			NEW.created_by,
			NEW.updated_by
			FROM
				erp_account_settings
				INNER JOIN erp_gl_charts
				ON erp_gl_charts.accountcode = erp_account_settings.default_sale_freight
				INNER JOIN erp_gl_sections
				ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_sale_freight;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sale_items
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_sale_items_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_sale_items_insert` AFTER INSERT ON `erp_sale_items` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_sale_type INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_tran_reference_no VARCHAR(55);
	DECLARE v_tran_customer VARCHAR(255);
	DECLARE v_tran_customer_id INTEGER;
	DECLARE v_tran_biller_id INTEGER;
	DECLARE v_tran_created_by INTEGER;
	DECLARE v_tran_updated_by INTEGER;
	DECLARE v_tax_type INTEGER;
	DECLARE v_order_tax_id INTEGER;
	DECLARE v_sale_type INTEGER;
	DECLARE v_acc_cate_separate INTEGER;
	DECLARE v_tran_note VARCHAR(1000);
	DECLARE v_sale_status VARCHAR(50);
	DECLARE v_category_id INTEGER;
	DECLARE v_qoh DECIMAL(15,4);
	DECLARE v_updated_at DATETIME;
	DECLARE v_product_type VARCHAR(50);
	DECLARE v_unit_quantity INTEGER;
	DECLARE v_paid DECIMAL(5,2);
	DECLARE v_grand_total DECIMAL(5,2);

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	SET v_tran_date = (SELECT erp_sales.date
			FROM erp_sales
			WHERE erp_sales.id = NEW.sale_id LIMIT 0,1);

	SET v_paid = (SELECT erp_sales.paid FROM erp_sales WHERE erp_sales.id = NEW.sale_id LIMIT 0,1);
	SET v_grand_total = (SELECT erp_sales.grand_total FROM erp_sales WHERE erp_sales.id = NEW.sale_id LIMIT 0,1);

	/*SET v_tran_no = (SELECT MAX(tran_no) FROM erp_gl_trans);*/

	SET v_tran_sale_type = (SELECT erp_sales.sale_type FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_reference_no = (SELECT erp_sales.reference_no FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_customer = (SELECT erp_sales.customer FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_customer_id = (SELECT erp_sales.customer_id FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_biller_id = (SELECT erp_sales.biller_id FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_created_by = (SELECT erp_sales.created_by FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_updated_by = (SELECT erp_sales.updated_by FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_note = (SELECT erp_sales.note FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_sale_status = (SELECT erp_sales.sale_status FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_category_id = (SELECT erp_products.category_id FROM erp_products WHERE erp_products.id = NEW.product_id);
	SET v_qoh =  (SELECT erp_products.quantity FROM erp_products WHERE erp_products.id = NEW.product_id);
	SET v_product_type = (SELECT erp_products.type FROM erp_products WHERE erp_products.id = NEW.product_id);
	SET v_updated_at = (SELECT erp_sales.updated_at FROM erp_sales WHERE erp_sales.id = NEW.sale_id);
	SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE reference_no = v_tran_reference_no LIMIT 1);

	IF NEW.product_id AND NEW.option_id THEN
		SET v_unit_quantity = (SELECT qty_unit FROM erp_product_variants WHERE product_id = NEW.product_id AND id = NEW.option_id);
	ELSE
		SET v_unit_quantity = 1;
	END IF;

	IF NEW.item_tax > 0 THEN

		INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
			) SELECT
				'SALES',
				v_tran_no,
				v_tran_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(- 1) * NEW.item_tax,
				v_tran_reference_no,
				v_tran_note,
				v_tran_biller_id,
				v_tran_customer_id,
				v_tran_created_by,
				v_tran_updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;

	END IF;

	IF v_acc_cate_separate = 1 THEN

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			customer_id,
			created_by,
			updated_by
		) SELECT
			'SALES',
			v_tran_no,
			v_tran_date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(-1) * abs(NEW.subtotal - NEW.item_tax),
			v_tran_reference_no,
			v_tran_note,
			v_tran_biller_id,
			v_tran_customer_id,
			v_tran_created_by,
			v_tran_updated_by
			FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_sale
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;

		IF v_sale_status = "completed" AND (NEW.unit_cost * NEW.quantity) > 0 AND v_product_type <> "service" THEN

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				) SELECT
				'SALES',
				v_tran_no,
				v_tran_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(NEW.unit_cost * (NEW.quantity * v_unit_quantity)),
				v_tran_reference_no,
				v_tran_note,
				v_tran_biller_id,
				v_tran_customer_id,
				v_tran_created_by,
				v_tran_updated_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_cost
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;

			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				) SELECT
				'SALES',
				v_tran_no,
				v_tran_date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				(-1) * abs(NEW.unit_cost * (NEW.quantity * v_unit_quantity)),
				v_tran_reference_no,
				v_tran_note,
				v_tran_biller_id,
				v_tran_customer_id,
				v_tran_created_by,
				v_tran_updated_by
				FROM
					erp_categories
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_categories.ac_stock
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_categories.id = v_category_id;
		END IF;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sale_items
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_items_delete`;
delimiter ;;
CREATE TRIGGER `audit_sales_items_delete` BEFORE DELETE ON `erp_sale_items` FOR EACH ROW BEGIN

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sale_items
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_items_update`;
delimiter ;;
CREATE TRIGGER `audit_sales_items_update` BEFORE UPDATE ON `erp_sale_items` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_sale_items_audit (
			id,
			sale_id,
			category_id,
			product_id,
			product_code,
			product_name,
			product_type,
			option_id,
			net_unit_price,
			unit_price,
			quantity_received,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			subtotal,
			serial_no,
			real_unit_price,
			product_noted,
			returned,
			group_price_id,
			acc_cate_separate,
			specific_tax_on_certain_merchandise_and_services,
			accommodation_tax,
			public_lighting_tax,
			other_tax,
			payment_of_profit_tax,
			performance_royalty_intangible,
			payment_interest_non_bank,
			payment_interest_taxpayer_fixed,
			payment_interest_taxpayer_non_fixed,
			payment_rental_immovable_property,
			payment_of_interest,
			payment_royalty_rental_income_related,
			payment_management_technical,
			payment_dividend,
			withholding_tax_on_resident,
			withholding_tax_on_non_resident,
			audit_type
		) SELECT
			id,
			sale_id,
			category_id,
			product_id,
			product_code,
			product_name,
			product_type,
			option_id,
			net_unit_price,
			unit_price,
			quantity_received,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			subtotal,
			serial_no,
			real_unit_price,
			product_noted,
			returned,
			group_price_id,
			acc_cate_separate,
			specific_tax_on_certain_merchandise_and_services,
			accommodation_tax,
			public_lighting_tax,
			other_tax,
			payment_of_profit_tax,
			performance_royalty_intangible,
			payment_interest_non_bank,
			payment_interest_taxpayer_fixed,
			payment_interest_taxpayer_non_fixed,
			payment_rental_immovable_property,
			payment_of_interest,
			payment_royalty_rental_income_related,
			payment_management_technical,
			payment_dividend,
			withholding_tax_on_resident,
			withholding_tax_on_non_resident,
			"UPDATED"
		FROM
			erp_sale_items
		WHERE
			erp_sale_items.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sale_order
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_orders_update`;
delimiter ;;
CREATE TRIGGER `audit_sales_orders_update` BEFORE UPDATE ON `erp_sale_order` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_sale_order_audit (
			id,
			date,
			quote_id,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			order_status,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			created_by,
			updated_by,
			updated_at,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			suspend_note,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			delivery_by,
			sale_type,
			delivery_status,
			tax_type,
			bill_to,
			po,
			audit_type
		) SELECT
			id,
			date,
			quote_id,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			order_status,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			created_by,
			updated_by,
			updated_at,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			suspend_note,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			delivery_by,
			sale_type,
			delivery_status,
			tax_type,
			bill_to,
			po,
			"UPDATED"
		FROM
			erp_sale_order
		WHERE
			erp_sale_order.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sale_order
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_orders_delete`;
delimiter ;;
CREATE TRIGGER `audit_sales_orders_delete` BEFORE DELETE ON `erp_sale_order` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_sale_order_audit (
			id,
			date,
			quote_id,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			order_status,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			created_by,
			updated_by,
			updated_at,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			suspend_note,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			delivery_by,
			sale_type,
			delivery_status,
			tax_type,
			bill_to,
			po,
			audit_type
		) SELECT
			id,
			date,
			quote_id,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			order_status,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			created_by,
			updated_by,
			updated_at,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			suspend_note,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			delivery_by,
			sale_type,
			delivery_status,
			tax_type,
			bill_to,
			po,
			"DELETED"
		FROM
			erp_sale_order
		WHERE
			erp_sale_order.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sale_order_items
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_order_items_update`;
delimiter ;;
CREATE TRIGGER `audit_sales_order_items_update` BEFORE UPDATE ON `erp_sale_order_items` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_sale_order_items_audit (
			id,
			sale_order_id,
			product_id,
			product_code,
			product_name,
			product_type,
			option_id,
			net_unit_price,
			unit_price,
			quantity_received,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			subtotal,
			serial_no,
			real_unit_price,
			product_noted,
			group_price_id
		) SELECT
			id,
			sale_order_id,
			product_id,
			product_code,
			product_name,
			product_type,
			option_id,
			net_unit_price,
			unit_price,
			quantity_received,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			subtotal,
			serial_no,
			real_unit_price,
			product_noted,
			group_price_id
		FROM
			erp_sale_order_items
		WHERE
			erp_sale_order_items.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sale_order_items
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_order_items_delete`;
delimiter ;;
CREATE TRIGGER `audit_sales_order_items_delete` BEFORE DELETE ON `erp_sale_order_items` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_sale_order_items_audit (
			id,
			sale_order_id,
			product_id,
			product_code,
			product_name,
			product_type,
			option_id,
			net_unit_price,
			unit_price,
			quantity_received,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			subtotal,
			serial_no,
			real_unit_price,
			product_noted,
			group_price_id
		) SELECT
			id,
			sale_order_id,
			product_id,
			product_code,
			product_name,
			product_type,
			option_id,
			net_unit_price,
			unit_price,
			quantity_received,
			quantity,
			warehouse_id,
			item_tax,
			tax_rate_id,
			tax,
			discount,
			item_discount,
			subtotal,
			serial_no,
			real_unit_price,
			product_noted,
			group_price_id
		FROM
			erp_sale_order_items
		WHERE
			erp_sale_order_items.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sales
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_sales_insert`;
delimiter ;;
CREATE TRIGGER `gl_trans_sales_insert` AFTER INSERT ON `erp_sales` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF NEW.opening_ar != 2 THEN
		IF NEW.total > 0 || NEW.total_discount THEN
			SET v_tran_date = (
				SELECT
					erp_sales.date
				FROM
					erp_payments
				INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
				WHERE
					erp_sales.id = NEW.id
				LIMIT 0,
				1
			);

			IF v_tran_date = NEW.date THEN
				SET v_tran_no = (
					SELECT
						COALESCE (MAX(tran_no), 0) + 1
					FROM
						erp_gl_trans
				);
			ELSE
				SET v_tran_no = (
					SELECT
						COALESCE (MAX(tran_no), 0) + 1
					FROM
						erp_gl_trans
				);
				UPDATE erp_order_ref
				SET tr = v_tran_no
				WHERE
					DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


			END IF;

			IF NEW.opening_ar = 1 THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
				) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(- 1) * abs(
						NEW.total - NEW.product_tax
					),
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_open_balance;

			ELSE
				IF v_acc_cate_separate <> 1 THEN
					INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'SALES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(- 1) * abs(
								NEW.total - NEW.product_tax
							),
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_sale;

					IF NEW.sale_status = "completed" AND NEW.total_cost > 0 THEN
						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'SALES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							NEW.total_cost,
							NEW.reference_no,
							NEW.customer,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_cost;


						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'SALES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(- 1) * abs(NEW.total_cost),
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_stock;
					END IF;
				END IF;

				IF NEW.order_discount THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.order_discount,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_discount
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_discount;

				END IF;

				IF NEW.shipping THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * NEW.shipping,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_freight
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_freight;

				END IF;

				IF NEW.order_tax THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * abs(NEW.order_tax),
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;


				END IF;

			END IF;
		END IF;

		IF NEW.grand_total THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
			) SELECT
				'SALES',
				v_tran_no,
				NEW.date,
				erp_gl_sections.sectionid,
				erp_gl_charts.accountcode,
				erp_gl_charts.accountname,
				NEW.grand_total,
				NEW.reference_no,
				NEW.note,
				NEW.biller_id,
				NEW.customer_id,
				NEW.created_by,
				NEW.updated_by
			FROM
				erp_account_settings
			INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
			INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
			WHERE
				erp_gl_charts.accountcode = erp_account_settings.default_receivable;
		END IF;

	END IF;

	IF NEW.opening_ar = 2 THEN
		SET v_tran_date = (
			SELECT
				erp_sales.date
			FROM
				erp_payments
			INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
			WHERE
				erp_sales.id = NEW.id
			LIMIT 0,
			1
		);

		IF v_tran_date = NEW.date THEN
			SET v_tran_no = (
				SELECT
					COALESCE (MAX(tran_no), 0) + 1
				FROM
					erp_gl_trans
			);
		ELSE
			SET v_tran_no = (
				SELECT
					COALESCE (MAX(tran_no), 0) + 1
				FROM
					erp_gl_trans
			);

			UPDATE erp_order_ref
			SET tr = v_tran_no
			WHERE
				DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


		END IF;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			customer_id,
			created_by,
			updated_by
		) SELECT
			'SALES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(
				NEW.total - NEW.product_tax
			),
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.customer_id,
			NEW.created_by,
			NEW.updated_by
		FROM
			erp_account_settings
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
		INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = erp_account_settings.default_open_balance;

        IF NEW.paid <= 0 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				   ) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.grand_total,
						NEW.reference_no,
						NEW.note,

						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
					erp_account_settings
					   INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
					   INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					   WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_receivable;
		END IF;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sales
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_sales_update`;
delimiter ;;
CREATE TRIGGER `gl_trans_sales_update` AFTER UPDATE ON `erp_sales` FOR EACH ROW BEGIN

	DECLARE v_tran_no INTEGER;
	DECLARE v_tran_date DATETIME;
	DECLARE v_acc_cate_separate INTEGER;

	SET v_acc_cate_separate = (SELECT erp_settings.acc_cate_separate FROM erp_settings WHERE erp_settings.setting_id = '1');

	IF NEW.opening_ar != 2 THEN

		IF NEW.total > 0 AND NEW.updated_by > 0 AND NEW.updated_count <> OLD.updated_count THEN

			SET v_tran_no = (SELECT tran_no FROM erp_gl_trans WHERE tran_type='SALES' AND reference_no = NEW.reference_no LIMIT 0,1);

			IF v_tran_no < 1  THEN
				SET v_tran_no = (SELECT COALESCE(MAX(tran_no),0) +1 FROM erp_gl_trans);
				UPDATE erp_order_ref SET tr = v_tran_no WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');
			END IF;

			DELETE FROM erp_gl_trans WHERE bank = '0' AND tran_type='SALES' AND reference_no = NEW.reference_no;

			IF NEW.opening_ar = 1 THEN
				INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
				) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					(- 1) * abs(
						NEW.total - NEW.product_tax
					),
					NEW.reference_no,
					NEW.note,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_open_balance;

			ELSE
				IF v_acc_cate_separate <> 1 THEN
					INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'SALES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(- 1) * abs(
								NEW.total - NEW.product_tax
							),
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_sale;

					IF NEW.sale_status = "completed" AND NEW.total_cost > 0 THEN
						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'SALES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							NEW.total_cost,
							NEW.reference_no,
							NEW.customer,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_cost;


						INSERT INTO erp_gl_trans (
							tran_type,
							tran_no,
							tran_date,
							sectionid,
							account_code,
							narrative,
							amount,
							reference_no,
							description,
							biller_id,
							customer_id,
							created_by,
							updated_by
						) SELECT
							'SALES',
							v_tran_no,
							NEW.date,
							erp_gl_sections.sectionid,
							erp_gl_charts.accountcode,
							erp_gl_charts.accountname,
							(- 1) * abs(NEW.total_cost),
							NEW.reference_no,
							NEW.note,
							NEW.biller_id,
							NEW.customer_id,
							NEW.created_by,
							NEW.updated_by
						FROM
							erp_account_settings
						INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
						INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
						WHERE
							erp_gl_charts.accountcode = erp_account_settings.default_stock;
					END IF;
				END IF;

				IF NEW.order_discount THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.order_discount,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings

					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_discount
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_discount;

				END IF;

				IF NEW.shipping THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * NEW.shipping,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_freight
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_freight;

				END IF;

				IF NEW.order_tax THEN
					INSERT INTO erp_gl_trans (
						tran_type,
						tran_no,
						tran_date,
						sectionid,
						account_code,
						narrative,
						amount,
						reference_no,
						description,
						biller_id,
						customer_id,
						created_by,
						updated_by
					) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						(- 1) * abs(NEW.order_tax),
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
						erp_account_settings
					INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_sale_tax
					INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					WHERE
						erp_gl_charts.accountcode = erp_account_settings.default_sale_tax;


				END IF;

			END IF;

		END IF;
		IF NEW.total > 0 AND NEW.updated_by > 0 AND NEW.updated_count <> OLD.updated_count THEN

			INSERT INTO erp_gl_trans (
					tran_type,
					tran_no,
					tran_date,
					sectionid,
					account_code,
					narrative,
					amount,
					reference_no,
					description,
					biller_id,
					customer_id,
					created_by,
					updated_by
				) SELECT
					'SALES',
					v_tran_no,
					NEW.date,
					erp_gl_sections.sectionid,
					erp_gl_charts.accountcode,
					erp_gl_charts.accountname,
					NEW.grand_total,
					NEW.reference_no,
					NEW.customer,
					NEW.biller_id,
					NEW.customer_id,
					NEW.created_by,
					NEW.updated_by
				FROM
					erp_account_settings
				INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
				INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
				WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_receivable;

		END IF;

	END IF;

	IF NEW.opening_ar = 2 THEN
		SET v_tran_date = (
			SELECT
				erp_sales.date
			FROM
				erp_payments
			INNER JOIN erp_sales ON erp_sales.id = erp_payments.sale_id
			WHERE
				erp_sales.id = NEW.id
			LIMIT 0,
			1
		);

		IF v_tran_date = NEW.date THEN
			SET v_tran_no = (
				SELECT
					MAX(tran_no)
				FROM
					erp_gl_trans
			);
		ELSE
			SET v_tran_no = (
				SELECT
					COALESCE (MAX(tran_no), 0) + 1
				FROM
					erp_gl_trans
			);

			UPDATE erp_order_ref
			SET tr = v_tran_no
			WHERE
				DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');


		END IF;

		INSERT INTO erp_gl_trans (
			tran_type,
			tran_no,
			tran_date,
			sectionid,
			account_code,
			narrative,
			amount,
			reference_no,
			description,
			biller_id,
			customer_id,
			created_by,
			updated_by
		) SELECT
			'SALES',
			v_tran_no,
			NEW.date,
			erp_gl_sections.sectionid,
			erp_gl_charts.accountcode,
			erp_gl_charts.accountname,
			(- 1) * abs(
				NEW.total - NEW.product_tax
			),
			NEW.reference_no,
			NEW.note,
			NEW.biller_id,
			NEW.customer_id,
			NEW.created_by,
			NEW.updated_by
		FROM
			erp_account_settings
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
		INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
		WHERE
			erp_gl_charts.accountcode = erp_account_settings.default_open_balance;

        IF NEW.paid <= 0 THEN
			INSERT INTO erp_gl_trans (
				tran_type,
				tran_no,
				tran_date,
				sectionid,
				account_code,
				narrative,
				amount,
				reference_no,
				description,
				biller_id,
				customer_id,
				created_by,
				updated_by
				   ) SELECT
						'SALES',
						v_tran_no,
						NEW.date,
						erp_gl_sections.sectionid,
						erp_gl_charts.accountcode,
						erp_gl_charts.accountname,
						NEW.grand_total,
						NEW.reference_no,
						NEW.note,
						NEW.biller_id,
						NEW.customer_id,
						NEW.created_by,
						NEW.updated_by
					FROM
					erp_account_settings
					   INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_receivable
					   INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
					   WHERE
					erp_gl_charts.accountcode = erp_account_settings.default_receivable;
		END IF;

	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sales
-- ----------------------------
DROP TRIGGER IF EXISTS `gl_trans_sales_delete`;
delimiter ;;
CREATE TRIGGER `gl_trans_sales_delete` AFTER DELETE ON `erp_sales` FOR EACH ROW BEGIN

   UPDATE erp_gl_trans SET amount = 0, description =  CONCAT(CAST(description AS CHAR CHARACTER SET utf8),CAST(' (Cancelled)' AS CHAR CHARACTER SET utf8))
   WHERE reference_no = OLD.reference_no;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sales_audit
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_update`;
delimiter ;;
CREATE TRIGGER `audit_sales_update` BEFORE UPDATE ON `erp_sales_audit` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_sales_audit (
			id,
			date,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			delivery_status,
			delivery_by,
			created_by,
			updated_by,
			updated_at,
			updated_count,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			type,
			type_id,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			sale_type,
			bill_to,
			po,
			suspend_note,
			tax_type,
			so_id,
			revenues_type,
			acc_cate_separate,
			hide_tax,
			audit_type
		) SELECT
			id,
			date,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			delivery_status,
			delivery_by,
			created_by,
			updated_by,
			updated_at,
			updated_count,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			type,
			type_id,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			sale_type,
			bill_to,
			po,
			suspend_note,
			tax_type,
			so_id,
			revenues_type,
			acc_cate_separate,
			hide_tax,
			"UPDATED"
		FROM
			erp_sales
		WHERE
			erp_sales.id = OLD.id;
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table erp_sales_audit
-- ----------------------------
DROP TRIGGER IF EXISTS `audit_sales_delete`;
delimiter ;;
CREATE TRIGGER `audit_sales_delete` BEFORE DELETE ON `erp_sales_audit` FOR EACH ROW BEGIN
	IF OLD.id THEN
		INSERT INTO erp_sales_audit (
			id,
			date,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			delivery_status,
			delivery_by,
			created_by,
			updated_by,
			updated_at,
			updated_count,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			type,
			type_id,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			sale_type,
			bill_to,
			po,
			suspend_note,
			tax_type,
			so_id,
			revenues_type,
			acc_cate_separate,
			hide_tax,
			audit_type
		) SELECT
			id,
			date,
			reference_no,
			customer_id,
			customer,
			group_areas_id,
			biller_id,
			biller,
			warehouse_id,
			note,
			staff_note,
			total,
			product_discount,
			order_discount_id,
			total_discount,
			order_discount,
			product_tax,
			order_tax_id,
			order_tax,
			total_tax,
			shipping,
			grand_total,
			sale_status,
			payment_status,
			payment_term,
			due_date,
			delivery_status,
			delivery_by,
			created_by,
			updated_by,
			updated_at,
			updated_count,
			total_items,
			total_cost,
			pos,
			paid,
			return_id,
			surcharge,
			attachment,
			attachment1,
			attachment2,
			type,
			type_id,
			other_cur_paid,
			other_cur_paid_rate,
			other_cur_paid1,
			other_cur_paid_rate1,
			saleman_by,
			reference_no_tax,
			tax_status,
			opening_ar,
			sale_type,
			bill_to,
			po,
			suspend_note,
			tax_type,
			so_id,
			revenues_type,
			acc_cate_separate,
			hide_tax,
			"DELETED"
		FROM
			erp_sales
		WHERE
			erp_sales.id = OLD.id;
	END IF;

END
;;
delimiter ;

