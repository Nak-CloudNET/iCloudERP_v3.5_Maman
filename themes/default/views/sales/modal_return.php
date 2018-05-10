<?php
function product_name($name)
{
    return character_limiter($name, (isset($pos_settings->char_per_line) ? ($pos_settings->char_per_line-8) : 35));
}

?>
<style type="text/css">
    @media print {
        .modal-dialog {
            width: 95% !important;
        }
        .modal-content {
            border: none !important;
        }
    }
    hr{
    border-color:#333;
    }
	#wrapper {
		max-width: 480px;
		margin: 0 auto;
		padding-top: 20px;
	}
</style>
<div class="modal-dialog" id="wrapper">
    <div class="modal-content">
        <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                <i class="fa fa-2x">&times;</i>
            </button>
            
			<div class="row">
				<?php if (isset($biller->logo)) { ?>
					<div class="col-xs-12 text-center">
						<img src="<?= base_url() . 'assets/uploads/logos/' . $biller->logo; ?>" alt="<?= $biller->company; ?>" style="width: 120px !important;">
					</div>
				<?php }else{
					echo "";
				} ?>

				<div class="col-xs-12 text-center company">
					<h3 style="font-family: 'Arial Black';"><b><?= strstr($biller->company, '(', true)?strstr($biller->company, '(', true):$biller->company; ?></b></h3>
					<h5 style="font-family: 'Arial Black';"><b><?= strstr($biller->company, '(', false); ?></b></h5>
					<h5><b>BABIES & KID CLOTHES FURNITURE</b></h5>
				</div>
			</div>
			<div class="text-center">
				<?php
					echo "<p style='margin-top: 15px !important;'>" . $biller->address . " " . $biller->city . " " . $biller->postal_code . " " . $biller->state . " " . $biller->country .
						"<br>" . lang("tel") . " : " . $biller->phone;
						//$this->erp->print_arrays($inv);
				?>
			</div>
			<h3 class="text-center" style="padding-top:-10px;"><b>Return Sale</b></h3>
           
            <div class="" style="margin-bottom: 10px;">
				<div style="width:100%;">
					<table class="text-left" style="width:100%;white-space: nowrap;">
						<tr>
							<td >វិក័យប័ត្រ​ / Order N<sup>o</sup>: </td>
							<td style="text-align: right;"><?= $inv->reference_no ?></td>
						</tr>
						<tr>
							<td>បេឡាករ​  / Cashier: </td>
							<td style="text-align: right;"><?= $inv->username ?></td>
						</tr>
						<tr>
							<td >កាលបរិច្ឆេទ / Date Time: </td>
							<td style="text-align: right;"><?=$this->erp->hrld($inv->date)?></td>
						</tr>
						<tr>
							<td >អតិថិជន / Customer: </td>
							<td style="text-align: right;"><?=$inv->customer;?></td>
						</tr>
					</table>
				</div>
				<div class="row" style="clear: both;"></div>
			</div>

           <?php
				$total_disc = 0;
				if(is_array($rows)){
					foreach ($rows as $d) {
						if($d->discount != 0){
							$total_disc = $d->discount;
						}
					}
				}
			?>
			
			<table class="table-condensed receipt no_border_btm" style="width:100%;">
				<thead>
					<tr style="border:1px dotted black !important;">
						<th style="width: 5%;"><?= lang("no"); ?></th>
						<th style="width: 150px;"><?= lang("Description"); ?></th>
						<th style="text-align:center;width: 100px;"><?= lang("qty"); ?></th>
						<th style="text-align:center;"><?= lang("Price"); ?></th>
						<?php if ($inv->Product_discount != 0 || $total_disc != '') {
							echo '<th style="text-align:right;width: 100px;">'.lang('discount').'</th>';
						} ?>
						<th style="padding-left:10px;padding-right:10px;text-align:right;width: 100px;"><?= lang("amount"); ?> </th>
					</tr>
				</thead>
				<tbody style="border-bottom:2px solid black;">
					<?php
					$r = 1;
					$m_us = 0;
					$total_quantity = 0;
					$tax_summary = array();
					$sub_total=0;
					if(is_array($rows)){
						//$this->erp->print_arrays($rows);
						foreach ($rows as $row) {
							$free = lang('free');
							//$this->erp->print_arrays($row);
							if (isset($tax_summary[$row->tax_code])) {
								$tax_summary[$row->tax_code]['items'] += $row->quantity;
								$tax_summary[$row->tax_code]['tax'] += $row->item_tax;
								$tax_summary[$row->tax_code]['amt'] += ($row->quantity * $row->net_unit_price) - $row->item_discount;
							} else {
								$tax_summary[$row->tax_code]['items'] = $row->quantity;
								$tax_summary[$row->tax_code]['tax'] = $row->item_tax;
								$tax_summary[$row->tax_code]['amt'] = ($row->quantity * $row->net_unit_price) - $row->item_discount;
								$tax_summary[$row->tax_code]['name'] = $row->tax_name;
								$tax_summary[$row->tax_code]['code'] = $row->tax_code;
								$tax_summary[$row->tax_code]['rate'] = $row->tax_rate;
							}
							$totals+=$row->subtotal;

							echo '<tr ' . ($row->product_type === 'combo' ? '' : 'class="item"') . '>';
							echo '	<td style="text-align:center;width: 5%;">' . $r . '</td>';
							echo '	<td class="text-left">' .product_name($row->product_name) . ($row->cat_name ? ' (' . $row->cat_name . ')' : '') . ($row->product_noted ? ' <br/>(' . $row->product_noted . ')' : '') . '</td>';

							echo '	<td class="text-center" style="font-size: 13px !important;">' . $this->erp->formatQuantity($row->quantity) . '</td>';

							echo '	<td class="text-center"  style="text-align:center; width:100px !important; font-size: 13px !important">' . (($row->unit_price)==0? $free:$this->erp->formatMoney($row->unit_price)) . '</td>';

							$colspan = 5;
							if ($inv->product_discount != 0 || $row->item_discount != 0) {
								echo '<td style="width: 100px; text-align:right; vertical-align:middle; font-size: 13px !important">' .$this->erp->formatMoney($row->item_discount) . ($row->discount != 0 ? '<small>(' . $row->discount . ')</small> ' : ''). '</td>';
							}
							echo '<td class="text-right">' . (($row->subtotal) == 0 ? $free : $this->erp->formatMoney($row->subtotal)) . '</td>';

							$r++;
							$total_quantity += $row->quantity;

							if($row->product_type === 'combo')
							{
								$this->db->select('*, (select name from erp_products p where p.id = erp_combo_items.product_id) as p_name ');
								$this->db->where('erp_combo_items.product_id = "' . $row->product_id . '"');
								$comboLoop = $this->db->get('erp_combo_items');
								$c = 1;
								$cTotal = count($comboLoop->result());
								foreach ($comboLoop->result() as $val) {
									echo '<tr ' . ($c === $cTotal ? 'class="item"' : '') . '>';
									echo '<td></td>';
									echo '<td><span style="padding-right: 5px;">' . $c . '. ' . $val->p_name . '</span></td>';
									echo '<td class="text-center"></td>';
									echo '<td class="text-center"></td>';
									echo '<td></td>';
									echo '<td></td>';
									echo '</tr>';
									$c++;
								}
							}
						}}
					?>

				</tbody>
				<tfoot>
				</tfoot>
			</table>
			
			<table style="width: 100%; margin-top: 5px; ">
            <?php //$this->erp->print_arrays($inv);?>

            <tr>
                <td class="text-left"style="width:30%; ">សរុបបរិមាណ</td>
                <td class="text-left"style="width: 25%; text-align:left;">Total QTY </td>
                <td style="text-align:right;width: 45%;"><?=$total_quantity?></td>
            </tr>
            <tr>
                <td class="text-left">សរុប</td>
                <td class="text-left">Total (<?= $default_currency->code; ?>)</td>
                <td style="text-align:right;"><?=$this->erp->formatMoney($totals);?></td>
            </tr>
            <?php if($inv->order_discount != 0){
                $string= $inv->order_discount_id;
                ?>
                <tr>
                    <td class="text-left">បញ្ចុះតម្លៃ</td>
                    <td class="text-left">Discount(<?= $default_currency->code; ?>)</td>
                    <td style="text-align:right;">
                        <?php
                        if(strpos($string, "%"))
                        {
                            echo '<small>(' . $inv->order_discount_id . ')</small> '.$this->erp->formatMoney($inv->order_discount);
                        } else {
                            echo '<small>(' . $inv->order_discount_id .'%'. ')</small> '.$this->erp->formatMoney($inv->order_discount);
                        }
                        ?>
                    </td>
                </tr>
            <?php }
            //$this->erp->print_arrays($inv);
            ?>

            <tr>
                <td class="text-left">សរុបចុងក្រោយ</td>
                <td class="text-left">Grand Total (<?= $default_currency->code; ?>)</td>
                <td style="text-align:right;"><?=$this->erp->formatMoney($inv->grand_total);?></td>
            </tr>
            <!-- <?php if($inv->order_discount != 0){?>
                    <tr>
                        <td style="text-align:left;">Order Discount </td>
                        <td style="text-align:right;"> <?=($inv->order_discount != 0 ? '<small>(' . $inv->order_discount_id . ')</small> ' : '').$this->erp->formatMoney($inv->order_discount)?></td>
                    </tr>
                <?php }else{?>
                    <tr>
                        <td style="text-align:left;">Order Discount </td>
                        <td style="text-align:right;"> <?=($inv->order_discount != 0 ? '<small>(' . $inv->order_discount_id . ')</small> ' : '').'$ '.$this->erp->formatMoney($inv->order_discount)?></td>
                    </tr>
                <?php }?>
				<?php if($inv->order_tax != 0){?>
					<tr>
						<td class="text-left">Order Tax</td>
						<td style="text-align:right;">$ <?=$this->erp->formatMoney($inv->order_tax);?>
						</td>
					</tr>
				<?php }else{?>
					<tr>
                        <td class="text-left"><?=$inv->tax_rate ?></td>
                        <td style="text-align:right;">$ <?=$this->erp->formatMoney($inv->order_tax);?>
                        </td>
                    </tr>
				<?php }?>-->

            <!-- <?php
            if ($pos_paid < $inv->grand_total) {
                if(count($payments) > 1){
                    foreach($payments as $payment) {
                        $us_paid=$this->erp->formatMoney($payment->pos_paid);
                        if($inv->other_cur_paid){
                            $riel_paid=$inv->other_cur_paid . '  ៛' ;
                        }else{}
                    }
                }else{
                    $us_paid=$this->erp->formatMoney($pos_paid);
                    if($inv->other_cur_paid){
                        $riel_paid=$inv->other_cur_paid . '  ៛' ;
                    }else{}
                }
            }
            ?> -->

        </table>
			
			<table class="received" style="width:100%;margin-top: 5px;">
				<?php
				$pos_paid = 0;
				$pos_paidd = 0;
				$colspan = 0;
				if($payments){
					foreach($payments as $payment) {
						 
						$pos_paid = $payment->pos_paid;
						
						if($pos_settings->in_out_rate){
							$pos_paid_other = ($payment->pos_paid_other != null ? $payment->pos_paid_other/$outexchange_rate->rate : 0);
						}else{
							$pos_paid_other = ($payment->pos_paid_other != null ? $payment->pos_paid_other/$exchange_rate->rate : 0);
						}
					}
					
					$pos_paidd = $pos_paid + $pos_paid_other;
					//echo $pos_paid_other;
					//echo $pos_settings->in_out_rate;
					//$this->erp->print_arrays($inv->grand_total,'___',$pos_paid,"__",$pos_paid_other);
				}

			   //$this->erp->print_arrays($pos_paid);
				if($pos_paidd >= $inv->grand_total){

					if(count($payments) > 1){
						//separate payments

						?>
						<tr style="width: 100%;">
							<th colspan="<?= $colspan + 2 ?>">
								<?php
								foreach($payments as $payment) {
									?>
									<table style="width: 100%;">
										<caption style="float: left; padding-left: 13px;">
											<?php if ($payment->paid_by=='Cheque'){
												echo lang('paid_by').' '.lang($payment->paid_by).' '.lang('('.$payment->cheque_no.')');
											}elseif ($payment->paid_by=='CC'){
												echo lang('paid_by').' '.lang($payment->paid_by).' '.lang('('.$payment->cc_no.')');
											}else{
												echo lang('paid_by').' '.lang($payment->paid_by);
											}?>
										</caption>
										<tr>
											<th style="border-left:2px solid #000;border-top:2px solid #000;border-right:none;padding-right: 12px;width:64%;"  class="text-right">Received (USD) :</th>
											<th style="border-right:2px solid #000;border-top:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= $this->erp->formatMoney($inv->paid); ?></th>
										</tr>
										<?php
										if($payment->pos_paid_other==0){
											?>
											<tr>
												<th style="border-left:2px solid #000;border-bottom:2px solid #000;padding-right: 12px;width:64%;"  class="text-right">Received (Riel) :</th>
												<th style="border-bottom:2px solid #000;border-right:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= number_format($payment->pos_paid_other) . ' ៛' ; ?></th>
											</tr>
											<?php
										}
										?>
									</table>

									<?php
								}
								?>
							</th>
						</tr>
						<?php
					}else{

						
						if($inv->other_cur_paid)
						{
							$khr_paid = ($inv->other_cur_paid/$inv->other_cur_paid_rate);
						}else{
							$khr_paid = 0;
						}
						?>
						<tr>
							<th style="border-left:2px solid #000;border-top:2px solid #000;border-right:none;width:64%;"  class="text-right">Received (<?= $default_currency->code; ?>) :</th>
							<th style="border-right:2px solid #000;border-top:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= $this->erp->formatMoney($inv->recieve_usd); ?></th>
						</tr>
						<tr>
							<th style="border-left:2px solid #000;border-bottom:2px solid #000;border-right:none;width:64%;"  class="text-right">Received (Riel) :</th>
							<th style="border-bottom:2px solid #000;border-right:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= number_format($payment->pos_paid_other) . ' ៛' ; ?></th>
						</tr>

						<?php
					}
					if(count($payments) > 1){

						$pay = '';
						$pay_kh = '';
						foreach($payments as $payment)
						{

							$pay += $payment->pos_paid;
							$pay_kh += $payment->pos_paid_other;
						}

						if((($pay + ($pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate : $exchange_rate->rate))) - $inv->grand_total) != 0){

							?>

							<tr>
								<th style="border-top:2px dotted #000;padding-right: 12px;" class="text-right"><?= lang("change_amount_us"); ?>:</th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right">
									<?php
									echo $this->erp->formatMoney(($pay+$pay_kh) - $inv->grand_total);
									$total_us_b = $this->erp->formatMoney(($pay+$pay_kh) - $inv->grand_total);
									$m_us = $this->erp->fraction($total_us_b);
									?>
								</th>
							</tr>
							<tr>
								<th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("change_amount_kh"); ?></th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right"><?= number_format(round($payment->pos_balance * $payment->pos_paid_other_rate)) ; ?> <sup> ៛</sup></th>
							</tr>
							<?php
						}
					}else{
						//$this->erp->print_arrays($payments);
						// $this->erp->print_arrays($inv);

						if((($pos_paid+$pos_paid_other) - $inv->grand_total) != 0 || ($this->erp->formatMoney((($pos_paid+$amount_kh_to_us) - $inv->grand_total) * $exchange_rate->rate)) != 0) { ?>
							<tr>
								<th style="border-top:2px dotted #000" class="text-right"><?= lang("change_amount_us"); ?> :</th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right">
									<?php
									echo $this->erp->formatMoney($payment->pos_balance);
									$total_us_b = $this->erp->formatMoney(($pos_paid+$amount_kh_to_us) - $inv->grand_total);
									$m_us = $this->erp->fraction($total_us_b);
									?>
								</th>
							</tr>
							<tr>
								<th style="border-top:2px dotted #000" class="text-right"><?= lang("change_amount_kh"); ?> :</th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right">
									<?= number_format(round($payment->pos_balance * $payment->pos_paid_other_rate)) ; ?> <sup> ៛</sup>

								</th>
							</tr>

							<?php

						}
					}
				}
				if ($pos_paidd < $inv->grand_total) {
					//separate payments

					if(count($payments) > 1){
						?>
						<tr>
							<th colspan="<?= $colspan + 2 ?>">
								<?php

								foreach($payments as $payment) {
									//$this->erp->print_arrays($inv);

									if($payment->pos_paid>0){

										?>

										<table style="width:100%;">
											<caption style="float: left; padding-left: 13px;">
												<?php if ($payment->paid_by=='Cheque'){
													echo lang('paid_by').' '.lang($payment->paid_by).' '.lang('('.$payment->cheque_no.')');
												}elseif ($payment->paid_by=='CC'){
													echo lang('paid_by').' '.lang($payment->paid_by).' '.lang('('.$payment->cc_no.')');
												}else{
													echo lang('paid_by').' '.lang($payment->paid_by);
												}?>
											</caption>
											<tr>
												<th style="border:2px solid #000;border-right:none;padding-right: 92px;width:81%;" colspan="<?= $colspan ?>" class="text-right">Received (<?= $default_currency->code; ?>):</th>
												<th style="border:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= $this->erp->formatMoney($payment->pos_paid); ?></th>
											</tr>
											<?php
											if($inv->other_cur_paid){

												?>
												<tr>
													<th style="border:2px solid #000;border-right:none;padding-right: 92px;width:81%;" colspan="<?= $colspan ?>" class="text-right">Received (Riel):</th>
													<th style="border:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= number_format($payment->pos_paid_other) . ' ៛' ; ?></th>
												</tr>
												<?php

											}else{}
											?>
										</table>
										<?php
									}

								}
								?>
							</th>
						</tr>
						<?php
					}else{
						?>
						<tr>
							<th style="border:2px solid #000;border-right:none;padding-right: 92px;" colspan="<?= $colspan ?>" class="text-right">Received (<?= $default_currency->code; ?>):</th>
							<th style="border:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= $this->erp->formatMoney($inv->paid); ?></th>
						</tr>
						<?php
						if($inv->other_cur_paid){
							?>
							<tr>
								<th style="border:2px solid #000;border-right:none;padding-right: 92px;" colspan="<?= $colspan ?>" class="text-right">Received (Riel):</th>
								<th style="border:2px solid #000;border-left:none; font-size: 13px !important;" class="text-right"><?= number_format($payment->pos_paid_other) . ' ៛' ; ?></th>
							</tr>
							<?php
						}else{}
						?>
						<?php
					}

					if(count($payments) > 1){
						$pay = '';
						$pay_kh = '';
						foreach($payments as $payment) {

							$pay += $payment->pos_paid;
							$pay_kh += $payment->pos_paid_other;
						}
						//echo $money_kh;
						if((($pay + ($pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) - $inv->grand_total) != 0){
							?>
							<tr>
								<th style="border-top:2px dotted #000;padding-right: 92px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_us"); ?></th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right">
									<?php
									$money_kh = $pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate);
									echo $this->erp->formatMoney(abs(($pay+$money_kh) - $inv->grand_total));
									$total_us_b = $this->erp->formatMoney(($pay+$money_kh) - $inv->grand_total);
									$m_us = $this->erp->fraction($total_us_b);
									//echo $m_us;
									?>
								</th>
							</tr>
							<tr>
								<th style="border-top:2px dotted #000;padding-right: 92px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_kh"); ?></th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right"><?= number_format(abs((($pay+$money_kh) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) . ' ៛' ; ?></th>
							</tr>
							<?php
						}
					}else{
						if(($inv->grand_total-($pos_paid+$pos_paid_other)) > 0  || ($this->erp->formatMoney((($pos_paid+$amount_kh_to_us) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate)))){ ?>
							<tr>
								<th style="border-top:2px dotted #000;padding-right: 92px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_us"); ?> :</th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right">
									<?php
									echo $this->erp->formatMoney(abs($inv->grand_total-$inv->pos_paid ));
									//echo $this->erp->formatMoney(abs($inv->grand_total-($pos_paid+$amount_kh_to_us) ));
									$total_us_b = $this->erp->formatMoney($inv->grand_total-($pos_paid+$amount_kh_to_us));
									$m_us = $this->erp->fraction($total_us_b);
									?>
								</th>
							</tr>
							<tr>
								<th style="border-top:2px dotted #000;padding-right: 92px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_kh"); ?> :</th>
								<th style="border-top:2px dotted #000; font-size: 13px !important;" class="text-right"><?= number_format(abs(($inv->pos_paid - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) . ' ៛' ; ?></th>
							</tr>
						<?php }
					}

				}

				?>
			</table>
			
			<table width="100%" class="text-center">
				<tr>
					<td style="padding-top:10px;padding-left:20px;" ><?=$biller->invoice_footer;?></td>
				</tr>
				<tr>
					<td class="text-center" style="padding-top: 10px;">~ ~ ~ <b>CloudNet</b> &nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:12px;">www.cloudnet.com.kh</span> ~ ~ ~</td>
				</tr>
			</table>
			<br>

      
        </div>
</div>
<script type="text/javascript">
    $(document).ready( function() {
        $('.tip').tooltip();
    });
</script>
