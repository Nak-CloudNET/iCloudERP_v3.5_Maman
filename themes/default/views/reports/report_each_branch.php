
<?php
    echo form_open('reports/each_branch_actions', 'id="action-form"');
?>
<div class="box">
    <div class="box-header">
        <h2 class="blue"><i
                class="fa-fw fa fa-calendar-o"></i><?= lang('Product_Report_Each_Branch') . ' (' . ($warehouse?$warehouse->name : lang('all_warehouses')) . ')'; ?>
        </h2>

        <div class="box-icon">
            <ul class="btn-tasks">
                <?php if (!empty($warehouses) && ($Owner || $Admin)) { ?>
                    <li class="dropdown">
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                            <i class="icon fa fa-building-o tip" data-placement="left" title="<?= lang("warehouses") ?>"></i>
                        </a>
                        <ul class="dropdown-menu pull-right" class="tasks-menus" role="menu" aria-labelledby="dLabel">
                            <li>
                                <a href="<?= site_url('reports/each_branch') ?>">
                                    <i class="fa fa-building-o"></i> <?= lang('all_warehouses') ?>
                                </a>
                            </li>
                            <li class="divider"></li>
                            <?php
							if(is_array($warehouses)){
								foreach ($warehouses as $warehouse) {
									echo '<li ' . ($warehouse_id && $warehouse_id == $warehouse->id ? 'class="active"' : '') . '><a href="' . site_url('reports/each_branch/' . $warehouse->id) . '"><i class="fa fa-building"></i>' . $warehouse->name . '</a></li>';
								}
							}
                            ?>
                        </ul>
                    </li>
                <?php } ?>
            </ul>
        </div>
        <div class="box-icon">
            <ul class="btn-tasks">
                <li class="dropdown">
                    <a href="#" id="pdf" class="tip" data-action="export_pdf" title="<?= lang('download_pdf') ?>">
                        <i class="icon fa fa-file-pdf-o"></i>
                    </a>
                </li>
                <li class="dropdown">
                    <a href="#" id="excel" class="tip" data-action="export_excel" title="<?= lang('download_xls') ?>">
                        <i class="icon fa fa-file-excel-o"></i>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <div style="display: none;">
        <input type="hidden" name="form_action" value="" id="form_action"/>
		<input type="hidden" name="wareid" value="<?php echo $warehouse_id ?>" id="form_action"/>
        <?= form_submit('performAction', 'performAction', 'id="action-form-submit"') ?>
    </div>
    <?= form_close() ?>
    <div class="box-content">
        <div class="row">
            <div class="col-lg-12">

                <p class="introtext"><?= lang('list_results'); ?></p>

                <div class="table-responsive">
                    <table id="PQData1" cellpadding="0" cellspacing="0" border="0"
                           class="table table-bordered table-condensed table-hover table-striped dfTable reports-table">
                        <thead>
                        <tr class="active">
                            <th style="min-width:30px; width: 30px; text-align: center;">
                                <input class="checkbox checkth" type="checkbox" name="check"/>
                            </th>
                            <th><?php echo $this->lang->line("Branch"); ?></th>
                            <th><?php echo $this->lang->line("Total QTY"); ?></th>
                            <th><?php echo $this->lang->line("Total Price"); ?></th>
                            <th><?php echo $this->lang->line("Total Cost"); ?></th>
                            <th><?php echo $this->lang->line("Total Profit"); ?></th>

                        </tr>
                        </thead>
                        <tbody>

                        <?php
                            $g_total_price=0;
                            $g_total_cost=0;
                            $g_total_qty=0;
                            $g_total_profit=0;
                            foreach ($rows as $row){
                                //$this->erp->print_arrays($row);
                                $total_profit=$row->total_price-$row->total_cost;
                                $g_total_price+=$row->total_price;
                                $g_total_cost+=$row->total_cost;
                                $g_total_qty+=$row->total_qty;
                                $g_total_profit+=$total_profit;

                                ?>
                                    <tr>
                                        <td style="min-width:30px; width: 30px; text-align: center;">
                                            <input class="checkbox checkth" type="checkbox" name="check"/>
                                        </td>
                                        <td><?= $row->company ; ?></td>
                                        <td><?= $this->erp->formatDecimal($row->total_qty); ?></td>
                                        <td><?= $this->erp->formatMoney($row->total_price); ?></td>
                                        <td><?= $this->erp->formatMoney($row->total_cost); ?></td>
                                        <td><?= $this->erp->formatMoney($total_profit); ?></td>

                                    </tr>
                            <?php

                            }
                            ?>
                        </tbody>
                        <tfoot class="dtFilter">
                        <tr class="active">
                            <th style="min-width:30px; width: 30px; text-align: center;">
                                <input class="checkbox checkth" type="checkbox" name="check"/>
                            </th>
                            <th>TOTAL</th>
                            <th><?= $this->erp->formatDecimal($g_total_qty);?></th>
                            <th><?= $this->erp->formatMoney($g_total_price);?></th>
                            <th><?= $this->erp->formatMoney($g_total_cost);?></th>
                            <th><?= $this->erp->formatMoney($g_total_profit);?></th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="<?= $assets ?>js/html2canvas.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $('#image').click(function (event) {
            event.preventDefault();
            html2canvas($('.box'), {
                onrendered: function (canvas) {
                    var img = canvas.toDataURL()
                    window.open(img);
                }
            });
            return false;
        });
    });
</script>