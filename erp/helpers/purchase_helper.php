<?php defined('BASEPATH') OR exit('No direct script access allowed');

if (!function_exists('getLastCloseDate')) {
    function getLastCloseDate()
    {
        $ci =& get_instance();

        $q = $ci->db->query("SELECT close_date FROM erp_stock_trans
                              WHERE is_close = '1' ORDER BY close_date DESC LIMIT 1");
        if ($q->num_rows() > 0) {
            return $q->row()->close_date;
        }
        return false;
    }
}

if (!function_exists('isCloseDate')) {
    function isCloseDate($tran_date)
    {
        $ci =& get_instance();
        $re = true;
        $close_date = getLastCloseDate();
        if($close_date == false){ }else{
            $dateDif = dateDiff($close_date,$tran_date);
            if($dateDif != null){
                $re = $dateDif > 0;
            }
        }
        return $re;
    }
}

if (!function_exists('getProductInfo')) {
    function getProductInfo($product_id)
    {
        $ci =& get_instance();

        $q = $ci->db->query("SELECT * FROM erp_products
                              WHERE id = '{$product_id}' LIMIT 1");
        if ($q->num_rows() > 0) {
            return $q->row();
        }
        return false;
    }
}

if (!function_exists('updateStockOnHand')) {
    function updateStockOnHand($product_id = NULL)
    {
        $ci =& get_instance();

        $where = ($product_id == NULL ? '' : 'WHERE st.product_id = '. ($product_id-0));

//        $q = $ci->db->query("SELECT
//                st.product_id,
//                st.option_id,
//                st.warehouse_id,
//                Sum(COALESCE (st.quantity_balance_unit, 0) ) AS qty
//                FROM
//                erp_stock_trans AS st
//                {$where}
//                GROUP BY
//                st.product_id,
//                st.option_id,
//                st.warehouse_id");


        //===================================
        //===================================
        //===================================
        //===================================
        $q3 = $ci->db->query("SELECT
                st.product_id,
                st.option_id,
                st.warehouse_id,
                Sum(COALESCE (st.quantity_balance, 0) ) AS qty
                FROM
                erp_purchase_items AS st
                {$where}
                GROUP BY
                st.product_id,
                st.option_id,
                st.warehouse_id");

        $q2 = $ci->db->query("SELECT
                st.product_id,
                st.warehouse_id,
                Sum(COALESCE (st.quantity_balance, 0) ) AS qty
                FROM
                erp_purchase_items AS st
                {$where}
                GROUP BY
                st.product_id,
                st.warehouse_id");

        $q1 = $ci->db->query("SELECT
                st.product_id,
                Sum(COALESCE (st.quantity_balance, 0) ) AS qty
                FROM
                erp_purchase_items AS st
                {$where}
                GROUP BY
                st.product_id
                ");

        if ($q3->num_rows() > 0) {
            foreach ($q3->result() as $row) {
                $ci->db->update('warehouses_products_variants', array('quantity' => $row->qty),
                    array('product_id' => $row->product_id,
                        'warehouse_id' => $row->warehouse_id,
                        'option_id' => $row->option_id));
            }
        }

        if ($q2->num_rows() > 0) {
            foreach ($q2->result() as $row) {
                $ci->db->update('warehouses_products', array('quantity' => $row->qty),
                    array('product_id' => $row->product_id,
                        'warehouse_id' => $row->warehouse_id));
            }
        }

        if ($q1->num_rows() > 0) {
            foreach ($q1->result() as $row) {
                $ci->db->update('products', array('quantity' => $row->qty),
                    array('id' => $row->product_id));
            }
        }
        //===================================
        //===================================
        //===================================
        //===================================

        return false;
    }
}

if (!function_exists('optimizeOpeningQuantity')) {
    function optimizeOpeningQuantity($tran_date)
    {
        $ci =& get_instance();

        $arr_product_id = [];

        $q_open_items = $ci->db->query("SELECT * FROM erp_purchase_items
                            WHERE transaction_type = 'OPENING QUANTITY'");

             if(count($q_open_items)>0){

                 $ci->db->query("DELETE FROM erp_stock_trans WHERE tran_type = 'OPENING QUANTITY'");

                 foreach ($q_open_items->result() as $item) {
                     if ($item->product_id > 0) {
                         $ci->db->insert('stock_trans',
                             [
                                 'biller_id' => 0,
                                 'purchase_item_id' => $item->id,
                                 'tran_date' => $item->date,
                                 'product_id' => $item->product_id,
                                 'warehouse_id' => $item->warehouse_id,
                                 'option_id' => $item->option_id,
                                 'quantity' => $item->quantity,
                                 'quantity_balance_unit' => $item->quantity_balance,
                                 'tran_type' => 'OPENING QUANTITY',
                                 'tran_id' => $item->id,
                                 'raw_cost' => $item->real_unit_cost,
                                 'freight_cost' => 0,
                                 'total_cost' => $item->real_unit_cost,
                                 'expired_date' => $item->expiry,
                                 'serial' => $item->serial_no
                             ]);

                         //Will use this function in the future
                         updateStockOnHand($item->product_id);
                         $arr_product_id[$item->product_id] = $item->product_id;
                     }
                 }
             }
            //Will use this function in the future
            if(count($arr_product_id)>0)
            getAvgCost($tran_date, $arr_product_id);


    }
}

if (!function_exists('optimizePurchases')) {
    function optimizePurchases($tran_date)
    {
        $ci =& get_instance();

        $arr_product_id = [];

        $q_all_purchases = $ci->db->query("SELECT * FROM erp_purchases 
                            WHERE DATE(`date`) >= DATE('{$tran_date}') ORDER BY `date` ASC; ");

        if ($q_all_purchases->num_rows() > 0) {
            foreach ($q_all_purchases->result() as $row_purchase) {
                $q_purchase_items = $ci->db->query("SELECT * FROM erp_purchase_items
                                    WHERE purchase_id = '{$row_purchase->id}' 
                                    AND transaction_type = 'PURCHASE'; ");

//                //===================================================Accounting on Not Separate Account by Category===========================================
//                $ci->db->delete("gl_trans", ['reference_no' => $row_purchase->reference_no, 'tran_type' => 'PURCHASES']);
//                $tran_no = getScalarValue("SELECT tran_no FROM erp_gl_trans WHERE reference_no = '{$row_purchase->reference_no}' AND tran_type = 'PURCHASES'", "tran_no");
//                $purchase_note = str_replace("'", "`", $row_purchase->note);
//
//                if ($tran_no <= 0 OR $tran_no != NULL) {
//                    $tran_no = getScalarValue("SELECT (COALESCE(MAX(tran_no), 0) + 1) AS tran_no FROM erp_gl_trans", "tran_no");
//
//                    $ci->db->query("UPDATE erp_order_ref
//                            SET tr = '{$tran_no}'
//                        WHERE
//                            DATE_FORMAT(`date`, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')");
//                }
//
//                if ($row_purchase->status == "received" && $row_purchase->total > 0) {
//
//                    if($row_purchase->type_of_po == "po") {
//
//                        if($row_purchase->opening_ap != 1) {
//
//                            if ($ci->Settings->acc_cate_separate == 0) {
//
//                                if($row_purchase->cogs != 0) {
//
//                                    $ci->db->query("INSERT INTO erp_gl_trans (
//                                                tran_type,
//                                                tran_no,
//                                                tran_date,
//                                                sectionid,
//                                                account_code,
//                                                narrative,
//                                                amount,
//                                                reference_no,
//                                                description,
//                                                biller_id,
//                                                customer_id,
//                                                created_by,
//                                                updated_by
//                                            ) SELECT
//                                                'PURCHASES',
//                                                '{$tran_no}',
//                                                '{$row_purchase->date}',
//                                                erp_gl_sections.sectionid,
//                                                erp_gl_charts.accountcode,
//                                                erp_gl_charts.accountname,
//                                                '{$row_purchase->cogs}',
//                                                '{$row_purchase->reference_no}',
//                                                '{$purchase_note}',
//                                                '{$row_purchase->biller_id}',
//                                                '{$row_purchase->customer_id}',
//                                                '{$row_purchase->created_by}',
//                                                '{$row_purchase->updated_by}'
//                                            FROM
//                                                erp_account_settings
//                                                INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_stock
//                                                INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                            WHERE
//                                                erp_gl_charts.accountcode = erp_account_settings.default_stock");
//
//                                    $ci->db->query("INSERT INTO erp_gl_trans (
//                                                tran_type,
//                                                tran_no,
//                                                tran_date,
//                                                sectionid,
//                                                account_code,
//                                                narrative,
//                                                amount,
//                                                reference_no,
//                                                description,
//                                                biller_id,
//                                                customer_id,
//                                                created_by,
//                                                updated_by
//                                            ) SELECT
//                                                'PURCHASES',
//                                                '{$tran_no}',
//                                                '{$row_purchase->date}',
//                                                erp_gl_sections.sectionid,
//                                                erp_gl_charts.accountcode,
//                                                erp_gl_charts.accountname,
//                                                -'{$row_purchase->cogs}',
//                                                '{$row_purchase->reference_no}',
//                                                '{$purchase_note}',
//                                                '{$row_purchase->biller_id}',
//                                                '{$row_purchase->customer_id}',
//                                                '{$row_purchase->created_by}',
//                                                '{$row_purchase->updated_by}'
//                                            FROM
//                                                erp_account_settings
//                                                INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_cost
//                                                INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                            WHERE
//                                                erp_gl_charts.accountcode = erp_account_settings.default_cost");
//
//                                }
//
//                                $ci->db->query("INSERT INTO erp_gl_trans (
//                                        tran_type,
//                                        tran_no,
//                                        tran_date,
//                                        sectionid,
//                                        account_code,
//                                        narrative,
//                                        amount,
//                                        reference_no,
//                                        description,
//                                        biller_id,
//                                        customer_id,
//                                        created_by,
//                                        updated_by
//                                    ) SELECT
//                                        'PURCHASES',
//                                        '{$tran_no}',
//                                        '{$row_purchase->date}',
//                                        erp_gl_sections.sectionid,
//                                        erp_gl_charts.accountcode,
//                                        erp_gl_charts.accountname,
//                                        '{$row_purchase->total}' + '{$row_purchase->shipping}',
//                                        '{$row_purchase->reference_no}',
//                                        '{$purchase_note}',
//                                        '{$row_purchase->biller_id}',
//                                        '{$row_purchase->customer_id}',
//                                        '{$row_purchase->created_by}',
//                                        '{$row_purchase->updated_by}'
//                                    FROM
//                                        erp_account_settings
//                                        INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase
//                                        INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                    WHERE
//                                        erp_gl_charts.accountcode = erp_account_settings.default_purchase");
//
//                            }
//
//                            $ci->db->query("INSERT INTO erp_gl_trans (
//                                    tran_type,
//                                    tran_no,
//                                    tran_date,
//                                    sectionid,
//                                    account_code,
//                                    narrative,
//                                    amount,
//                                    reference_no,
//                                    description,
//                                    biller_id,
//                                    customer_id,
//                                    created_by,
//                                    updated_by
//                                ) SELECT
//                                    'PURCHASES',
//                                    '{$tran_no}',
//                                    '{$row_purchase->date}',
//                                    erp_gl_sections.sectionid,
//                                    erp_gl_charts.accountcode,
//                                    erp_gl_charts.accountname,
//                                    -'{$row_purchase->grand_total}',
//                                    '{$row_purchase->reference_no}',
//                                    '{$purchase_note}',
//                                    '{$row_purchase->biller_id}',
//                                    '{$row_purchase->customer_id}',
//                                    '{$row_purchase->created_by}',
//                                    '{$row_purchase->updated_by}'
//                                FROM
//                                    erp_account_settings
//                                    INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_payable
//                                    INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                WHERE
//                                    erp_gl_charts.accountcode = erp_account_settings.default_payable");
//
//                        }
//
//                        if($row_purchase->order_discount != NULL && $row_purchase->order_discount > 0) {
//                            $ci->db->query("INSERT INTO erp_gl_trans(
//                                    tran_type,
//                                    tran_no,
//                                    tran_date,
//                                    sectionid,
//                                    account_code,
//                                    narrative,
//                                    amount,
//                                    reference_no,
//                                    description,
//                                    biller_id,
//                                    customer_id,
//                                    created_by,
//                                    updated_by
//                                ) SELECT
//                                    'PURCHASES',
//                                    '{$tran_no}',
//                                    '{$row_purchase->date}',
//                                    erp_gl_sections.sectionid,
//                                    erp_gl_charts.accountcode,
//                                    erp_gl_charts.accountname,
//                                    -'{$row_purchase->order_discount}',
//                                    '{$row_purchase->reference_no}',
//                                    '{$purchase_note}',
//                                    '{$row_purchase->biller_id}',
//                                    '{$row_purchase->customer_id}',
//                                    '{$row_purchase->created_by}',
//                                    '{$row_purchase->updated_by}'
//                                    FROM
//                                        erp_account_settings
//                                        INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount
//                                        INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                    WHERE
//                                        erp_gl_charts.accountcode = erp_account_settings.default_purchase_discount");
//                        }
//
//                        if($row_purchase->order_tax != NULL && $row_purchase->order_tax > 0) {
//                            $ci->db->query("INSERT INTO erp_gl_trans(
//                                    tran_type,
//                                    tran_no,
//                                    tran_date,
//                                    sectionid,
//                                    account_code,
//                                    narrative,
//                                    amount,
//                                    reference_no,
//                                    description,
//                                    biller_id,
//                                    customer_id,
//                                    created_by,
//                                    updated_by
//                                ) SELECT
//                                    'PURCHASES',
//                                    '{$tran_no}',
//                                    '{$row_purchase->date}',
//                                    erp_gl_sections.sectionid,
//                                    erp_gl_charts.accountcode,
//                                    erp_gl_charts.accountname,
//                                    '{$row_purchase->order_tax}',
//                                    '{$row_purchase->reference_no}',
//                                    '{$purchase_note}',
//                                    '{$row_purchase->biller_id}',
//                                    '{$row_purchase->customer_id}',
//                                    '{$row_purchase->created_by}',
//                                    '{$row_purchase->updated_by}'
//                                    FROM
//                                        erp_account_settings
//                                        INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax
//                                        INNER JOIN erp_gl_sections
//                                        ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                    WHERE
//                                        erp_gl_charts.accountcode = erp_account_settings.default_purchase_tax");
//                        }
//
//                    }
//
//                    if($row_purchase->opening_ap == 1) {
//
//                        $ci->db->query("INSERT INTO erp_gl_trans(
//                                tran_type,
//                                tran_no,
//                                tran_date,
//                                sectionid,
//                                account_code,
//                                narrative,
//                                amount,
//                                reference_no,
//                                description,
//                                biller_id,
//                                customer_id,
//                                created_by,
//                                updated_by
//                            ) SELECT
//                                'PURCHASES',
//                                '{$tran_no}',
//                                '{$row_purchase->date}',
//                                erp_gl_sections.sectionid,
//                                erp_gl_charts.accountcode,
//                                erp_gl_charts.accountname,
//                                '{$row_purchase->grand_total}',
//                            '{$row_purchase->reference_no}',
//                            '{$purchase_note}',
//                            '{$row_purchase->biller_id}',
//                            '{$row_purchase->customer_id}',
//                            '{$row_purchase->created_by}',
//                            '{$row_purchase->updated_by}'
//                                FROM
//                                    erp_account_settings
//                                    INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_open_balance
//                                    INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                WHERE
//                                    erp_gl_charts.accountcode = erp_account_settings.default_open_balance");
//
//                        $ci->db->query("INSERT INTO erp_gl_trans(
//                            tran_type,
//                            tran_no,
//                            tran_date,
//                            sectionid,
//                            account_code,
//                            narrative,
//                            amount,
//                            reference_no,
//                            description,
//                            biller_id,
//                            customer_id,
//                            created_by,
//                            updated_by
//                        ) SELECT
//                            'PURCHASES',
//                            '{$tran_no}',
//                            '{$row_purchase->date}',
//                            erp_gl_sections.sectionid,
//                            erp_gl_charts.accountcode,
//                            erp_gl_charts.accountname,
//                            -'{$row_purchase->grand_total}',
//                            '{$row_purchase->reference_no}',
//                            '{$purchase_note}',
//                            '{$row_purchase->biller_id}',
//                            '{$row_purchase->customer_id}',
//                            '{$row_purchase->created_by}',
//                            '{$row_purchase->updated_by}'
//                            FROM
//                                erp_account_settings
//                                INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_account_settings.default_payable
//                                INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                            WHERE
//                                erp_gl_charts.accountcode = erp_account_settings.default_payable");
//
//                    }
//
//                }
//                //===================================================End Accounting============================================================================

                if ($q_purchase_items->num_rows() > 0) {

                    $items = [];
                    $services = [];
                    $total_services = ($row_purchase->shipping - 0);
                    $total_item_cost = 0;

                    foreach ($q_purchase_items->result() as $row_purchase_item) {
                        $product_id = $row_purchase_item->product_id;
                        $product_info = getProductInfo($product_id);
                        if ($product_info->type == 'service') {
                            if ($product_info->service_type - 0 == 1) {
                                $services[] = $row_purchase_item;
                                $total_services += ($row_purchase_item->subtotal - 0);
                            }
                        } else {
                            $items[] = $row_purchase_item;
                            $total_item_cost += ($row_purchase_item->subtotal - 0);
                        }

//                        //===========================================================Start Account Separate by Category========================================================
//                        if ($row_purchase->status == "received") {
//                            if ($ci->Settings->acc_cate_separate == 1) {
//                                $default_purchase = getScalarValue("SELECT ac_purchase FROM erp_categories WHERE id = '{$product_info->category_id}'", "ac_purchase");
//                                $default_stock = getScalarValue("SELECT ac_stock FROM erp_categories WHERE id = '{$product_info->category_id}'", "ac_stock");
//                                $default_cost = getScalarValue("SELECT ac_cost FROM erp_categories WHERE id = '{$product_info->category_id}'", "ac_cost");
//                                if ($default_purchase == '' && $default_purchase == NULL) {
//                                    $default_purchase = getScalarValue("SELECT default_purchase FROM erp_account_settings", "default_purchase");
//                                }
//                                if ($default_stock == '' && $default_stock == NULL) {
//                                    $default_stock = getScalarValue("SELECT default_stock FROM erp_account_settings", "default_stock");
//                                }
//                                if ($default_cost == '' && $default_cost == NULL) {
//                                    $default_cost = getScalarValue("SELECT default_cost FROM erp_account_settings", "default_cost");
//                                }
//
//                                if (($row_purchase_item->subtotal + $row_purchase_item->net_shipping) > 0) {
//
//                                    $ci->db->query("INSERT INTO erp_gl_trans (
//                                            tran_type,
//                                            tran_no,
//                                            tran_date,
//                                            sectionid,
//                                            account_code,
//                                            narrative,
//                                            amount,
//                                            reference_no,
//                                            description,
//                                            biller_id,
//                                            customer_id,
//                                            created_by,
//                                            updated_by
//                                        ) SELECT
//                                            'PURCHASES',
//                                            '{$tran_no}',
//                                            '{$row_purchase->date}',
//                                            erp_gl_sections.sectionid,
//                                            erp_gl_charts.accountcode,
//                                            erp_gl_charts.accountname,
//                                            '{$row_purchase_item->subtotal}' + '{$row_purchase_item->net_shipping}',
//                                            '{$row_purchase->reference_no}',
//                                            '{$purchase_note}',
//                                            '{$row_purchase->biller_id}',
//                                            '{$row_purchase->customer_id}',
//                                            '{$row_purchase->created_by}',
//                                            '{$row_purchase->updated_by}'
//                                        FROM
//                                            erp_account_settings
//                                            INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = '{$default_purchase}'
//                                            INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                        WHERE
//                                            erp_gl_charts.accountcode = '{$default_purchase}'");
//
//                                }
//
//                                if ($row_purchase_item->cb_qty < 0) {
//
//                                    $ci->db->query("INSERT INTO erp_gl_trans (
//                                            tran_type,
//                                            tran_no,
//                                            tran_date,
//                                            sectionid,
//                                            account_code,
//                                            narrative,
//                                            amount,
//                                            reference_no,
//                                            description,
//                                            biller_id,
//                                            customer_id,
//                                            created_by,
//                                            updated_by
//                                        ) SELECT
//                                            'PURCHASES',
//                                            '{$tran_no}',
//                                            '{$row_purchase->date}',
//                                            erp_gl_sections.sectionid,
//                                            erp_gl_charts.accountcode,
//                                            erp_gl_charts.accountname,
//                                            ('{$row_purchase_item->real_unit_cost}' - '{$row_purchase_item->cb_avg}') * '{$row_purchase_item->cb_qty}',
//                                            '{$row_purchase->reference_no}',
//                                            '{$purchase_note}',
//                                            '{$row_purchase->biller_id}',
//                                            '{$row_purchase->customer_id}',
//                                            '{$row_purchase->created_by}',
//                                            '{$row_purchase->updated_by}'
//                                        FROM
//                                            erp_account_settings
//                                            INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = '{$default_stock}'
//                                            INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                        WHERE
//                                            erp_gl_charts.accountcode = '{$default_stock}'");
//
//                                    $ci->db->query("INSERT INTO erp_gl_trans (
//                                            tran_type,
//                                            tran_no,
//                                            tran_date,
//                                            sectionid,
//                                            account_code,
//                                            narrative,
//                                            amount,
//                                            reference_no,
//                                            description,
//                                            biller_id,
//                                            customer_id,
//                                            created_by,
//                                            updated_by
//                                        ) SELECT
//                                            'PURCHASES',
//                                            '{$tran_no}',
//                                            '{$row_purchase->date}',
//                                            erp_gl_sections.sectionid,
//                                            erp_gl_charts.accountcode,
//                                            erp_gl_charts.accountname,
//                                            -('{$row_purchase_item->real_unit_cost}' - '{$row_purchase_item->cb_avg}') * '{$row_purchase_item->cb_qty}',
//                                            '{$row_purchase->reference_no}',
//                                            '{$purchase_note}',
//                                            '{$row_purchase->biller_id}',
//                                            '{$row_purchase->customer_id}',
//                                            '{$row_purchase->created_by}',
//                                            '{$row_purchase->updated_by}'
//                                        FROM
//                                            erp_account_settings
//                                            INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = '{$default_cost}'
//                                            INNER JOIN erp_gl_sections ON erp_gl_sections.sectionid = erp_gl_charts.sectionid
//                                        WHERE
//                                            erp_gl_charts.accountcode = '{$default_cost}'");
//
//                                }
//                            }
//                        }
//                        //=============================================================end separate account by category=====================================================

                    }

                    $ci->db->query("DELETE FROM erp_stock_trans WHERE tran_type = 'PURCHASE' AND tran_id = '{$row_purchase->id}'");

                    foreach ($items as $item) {
                        $percentage_item = ($item->subtotal / $total_item_cost);
                        $product_cost_ship = $percentage_item * $total_services;

                        if ($item->quantity_balance - 0 > 0) {
                            $product_unit_cost = ($item->subtotal + $product_cost_ship) / $item->quantity_balance;
                        } else {
                            $product_unit_cost = ($item->subtotal + $product_cost_ship);
                        }

                        $ci->db->update('purchase_items',
                            ['real_unit_cost' => $product_unit_cost], ['id' => $item->id]);

                        $ci->db->insert('stock_trans',
                            [
                                'biller_id' => $row_purchase->biller_id,
                                'purchase_item_id' => $item->id,
                                'tran_date' => $row_purchase->date,
                                'product_id' => $item->product_id,
                                'warehouse_id' => $item->warehouse_id,
                                'option_id' => $item->option_id,
                                'quantity' => $item->quantity,
                                'quantity_balance_unit' => $item->quantity_balance,
                                'tran_type' => 'PURCHASE',
                                'tran_id' => $row_purchase->id,
                                'manufacture_cost' => $item->net_unit_cost,
                                'freight_cost' => $product_cost_ship,
                                'total_cost' => $product_unit_cost,
                                'expired_date' => $item->expiry,
                                'serial' => $item->serial_no
                            ]);

                        //Will use this function in the future
                        updateStockOnHand($item->product_id);
                        $arr_product_id[$item->product_id] = $item->product_id;

                    }
                }
            }

            //Will use this function in the future
            getAvgCost($tran_date, $arr_product_id);

        }
    }
}

if (!function_exists('optimizeStockAdjustment')) {
    function optimizeStockAdjustment($tran_date)
    {
        $ci =& get_instance();

        $arr_product_id = [];

        $q_all_adj = $ci->db->query("SELECT * FROM erp_adjustments 
                            WHERE DATE(`date`) >= DATE('{$tran_date}') ORDER BY `date` ASC; ");
        if($q_all_adj->num_rows() > 0) {
            foreach($q_all_adj->result() as $row_adj) {
                $q_adj_items = $ci->db->query("SELECT * FROM erp_adjustment_items 
                    WHERE adjust_id = {$row_adj->id}");

                $ci->db->query("DELETE FROM erp_stock_trans WHERE 
                      tran_type = 'ADJUSTMENT' AND tran_id = '{$row_adj->id}'");

                if($q_adj_items->num_rows() > 0) {
                    foreach($q_adj_items->result() as $row_adj_item) {
                        $option_value = 1;
                        if($row_adj_item->option_id) {
                            $q_product_variant = $ci->db->query("SELECT * FROM erp_product_variants
                                WHERE id = {$row_adj_item->option_id}");
                            if($q_product_variant->num_rows() > 0) {
                                $option_value = $q_product_variant->row()->qty_unit;
                            }
                        }
                        $ci->db->insert('stock_trans',
                            [
                                'biller_id' => $row_adj->biller_id,
                                'purchase_item_id' => 0,
                                'tran_date' => $row_adj->date,
                                'product_id' => $row_adj_item->product_id,
                                'warehouse_id' => $row_adj->warehouse_id,
                                'option_id' => $row_adj_item->option_id,
                                'quantity' => $row_adj_item->quantity,
                                'quantity_balance_unit' => $option_value * $row_adj_item->quantity,
                                'tran_type' => 'ADJUSTMENT',
                                'tran_id' => $row_adj->id,
                                'manufacture_cost' => 0,
                                'freight_cost' => 0,
                                'total_cost' => 0,
                                'expired_date' => $row_adj_item->expiry,
                                'serial' => $row_adj_item->serial_no
                            ]);

                        //Will use this function in the future
                        updateStockOnHand($row_adj_item->product_id);
                        $arr_product_id[$row_adj_item->product_id] = $row_adj_item->product_id;

                    }
                }
            }

            //Will use this function in the future
            getAvgCost($tran_date, $arr_product_id);

        }
    }
}

if (!function_exists('optimizeTransferStock')) {
    function optimizeTransferStock($tran_date)
    {
        $ci =& get_instance();

        $arr_product_id = [];

        $q_all_tran = $ci->db->query("SELECT * FROM erp_transfers 
                            WHERE DATE(`date`) >= DATE('{$tran_date}') ORDER BY `date` ASC; ");
        if($q_all_tran->num_rows() > 0) {
            foreach($q_all_tran->result() as $row_tran) {
                $q_tran_items = $ci->db->query("SELECT * FROM erp_transfer_items 
                    WHERE transfer_id = {$row_tran->id}");

                $ci->db->query("DELETE FROM erp_stock_trans WHERE 
                      tran_type = 'TRANSFER' AND tran_id = '{$row_tran->id}'");

                if($q_tran_items->num_rows() > 0) {
                    foreach($q_tran_items->result() as $row_tran_item) {
                        $option_value = 1;
                        if($row_tran_item->option_id) {
                            $q_product_variant = $ci->db->query("SELECT * FROM erp_product_variants
                                WHERE id = {$row_tran_item->option_id}");
                            if($q_product_variant->num_rows() > 0) {
                                $option_value = $q_product_variant->row()->qty_unit;
                            }
                        }
                        $ci->db->insert('stock_trans',
                            [
                                'biller_id' => $row_tran->biller_id,
                                'purchase_item_id' => 0,
                                'tran_date' => $row_tran->date,
                                'product_id' => $row_tran_item->product_id,
                                'warehouse_id' => $row_tran->from_warehouse_id,
                                'option_id' => $row_tran_item->option_id,
                                'quantity' => -$row_tran_item->quantity,
                                'quantity_balance_unit' => -($option_value * $row_tran_item->quantity),
                                'tran_type' => 'TRANSFER',
                                'tran_id' => $row_tran->id,
                                'manufacture_cost' => 0,
                                'freight_cost' => 0,
                                'total_cost' => 0,
                                'expired_date' => $row_tran_item->expiry,
                                'serial' => 0
                            ]);
                        $ci->db->insert('stock_trans',
                            [
                                'biller_id' => $row_tran->biller_id,
                                'purchase_item_id' => 0,
                                'tran_date' => $row_tran->date,
                                'product_id' => $row_tran_item->product_id,
                                'warehouse_id' => $row_tran->to_warehouse_id,
                                'option_id' => $row_tran_item->option_id,
                                'quantity' => $row_tran_item->quantity,
                                'quantity_balance_unit' => $option_value * $row_tran_item->quantity,
                                'tran_type' => 'TRANSFER',
                                'tran_id' => $row_tran->id,
                                'manufacture_cost' => 0,
                                'freight_cost' => 0,
                                'total_cost' => 0,
                                'expired_date' => $row_tran_item->expiry,
                                'serial' => 0
                            ]);

                        //Will use this function in the future
                        updateStockOnHand($row_tran_item->product_id);
                        $arr_product_id[$row_tran_item->product_id] = $row_tran_item->product_id;

                    }
                }
            }

            //Will use this function in the future
            getAvgCost($tran_date, $arr_product_id);

        }
    }
}

if (!function_exists('optimizeConvert')) {
    function optimizeConvert($tran_date)
    {
        $ci =& get_instance();

        $arr_product_id = [];

        $q_all_convert= $ci->db->query("SELECT * FROM erp_convert 
                            WHERE DATE(`date`) >= DATE('{$tran_date}') ORDER BY `date` ASC; ");
        if($q_all_convert->num_rows() > 0) {
            foreach($q_all_convert->result() as $row_convert) {
                $q_convert_items = $ci->db->query("SELECT * FROM erp_convert_items 
                    WHERE convert_id = {$row_convert->id}");

                $ci->db->query("DELETE FROM erp_stock_trans WHERE 
                      tran_type = 'CONVERT' AND tran_id = '{$row_convert->id}'");

                if($q_convert_items->num_rows() > 0) {
                    foreach($q_convert_items->result() as $row_convert_item) {
                        $option_value = 1;
                        if($row_convert_item->option_id) {
                            $q_product_variant = $ci->db->query("SELECT * FROM erp_product_variants
                                WHERE id = {$row_convert_item->option_id}");
                            if($q_product_variant->num_rows() > 0) {
                                $option_value = $q_product_variant->row()->qty_unit;
                            }
                        }
                        if($row_convert_item->status == 'deduct') {
                            $ci->db->insert('stock_trans',
                                [
                                    'biller_id' => $row_convert->biller_id,
                                    'purchase_item_id' => 0,
                                    'tran_date' => $row_convert->date,
                                    'product_id' => $row_convert_item->product_id,
                                    'warehouse_id' => $row_convert->warehouse_id,
                                    'option_id' => $row_convert_item->option_id,
                                    'quantity' => -$row_convert_item->quantity,
                                    'quantity_balance_unit' => -($option_value * $row_convert_item->quantity),
                                    'tran_type' => 'CONVERT',
                                    'tran_id' => $row_convert->id,
                                    'manufacture_cost' => 0,
                                    'freight_cost' => 0,
                                    'total_cost' => 0,
                                    'expired_date' => NULL,
                                    'serial' => 0
                                ]);
                        }else {
                            $ci->db->insert('stock_trans',
                                [
                                    'purchase_item_id' => 0,
                                    'tran_date' => $row_convert->date,
                                    'product_id' => $row_convert_item->product_id,
                                    'warehouse_id' => $row_convert->warehouse_id,
                                    'option_id' => $row_convert_item->option_id,
                                    'quantity' => $row_convert_item->quantity,
                                    'quantity_balance_unit' => $option_value * $row_convert_item->quantity,
                                    'tran_type' => 'CONVERT',
                                    'tran_id' => $row_convert->id,
                                    'manufacture_cost' => 0,
                                    'freight_cost' => 0,
                                    'total_cost' => 0,
                                    'expired_date' => NULL,
                                    'serial' => 0
                                ]);
                        }

                        //Will use this function in the future
                        updateStockOnHand($row_convert_item->product_id);
                        $arr_product_id[$row_convert_item->product_id] = $row_convert_item->product_id;

                    }
                }
            }

            //Will use this function in the future
            getAvgCost($tran_date, $arr_product_id);

        }
    }
}
