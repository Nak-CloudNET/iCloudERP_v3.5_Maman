<?php
	//$this->erp->print_arrays($invs);
	$note_arr = explode('/',$biller->phone);
	//$this->erp->print_arrays($note_arr[0],$note_arr[1],$note_arr[2]);
	
?>
<!DOCTYPE html>
<html lang="en">
<head>
    
	<meta charset="UTF-8">
	<title>Credit Note</title>
	<link href="<?php echo $assets ?>styles/theme.css" rel="stylesheet">
	<link href="<?php echo $assets ?>styles/bootstrap.min.css" rel="stylesheet">
	<link href="<?php echo $assets ?>styles/custome.css" rel="stylesheet">
    <link href="<?= $assets ?>styles/helpers/bootstrap.min.css" rel="stylesheet"/>
</head>
<style>
	.container {
		width:17cm;
		height:auto;
		margin: 20px auto;
		/*padding: 10px;*/
		box-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
	}
	tbody{
		font-family:khmer Os;
		font-family:Times New Roman !important;
	}
	.table thead > tr > th, .table tbody > tr > th, .table tfoot > tr > th {
			background-color: #444 !important;
			color: #FFF !important;
		}
	.table thead > tr > th, .table tbody > tr > th, .table tfoot > tr > th, .table thead > tr > td, .table tbody > tr > td, .table tfoot > tr > td {
		border: 1px solid #000 !important;
	}
	#tels span {
		padding-left: 23px;
	}
	#tels span:first-child {
		padding-left: 0 !important;
	}
    @page  {
        size: A4;
        margin:20px;
    }
	@media print {
		thead th,b {
			font-size: 12px !important;
		}
		tr td{
			font-size: 13px !important;
		}

		#footer {
			bottom:70px !important;
			position: absolute !important;
			width:100% !important;
		}
        .no-print {
            display: none;
        }
	}
	.table thead > tr > th, .table tbody > tr > th, .table tfoot > tr > th {
			background-color: #fff !important;
			color: #000 !important;

		}
	.table thead > tr > th, .table tbody > tr > th, .table tfoot > tr > th, .table thead > tr > td, .table tbody > tr > td, .table tfoot > tr > td {
		border: 1px solid #000 !important;
	}	
</style>
<body>
    <div class="container">
		<div class="row">
			<div class="col-lg-12 col-sm-12 col-xs-12">
				<center><h3 style="font-weight:bold !important;font-family:Time New Roman !important;margin-bottom:20px !important;">ប័ណ្ណឥណទាន CREDIT MEMMO</h3></center>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12 col-sm-12 col-xs-12">
				<table style=" width: 100%;font-size:12px;">
					<tr>
						<td style="width: 50%;border: #000 solid 1px;height: 25px;">លេខកូដ/Cust.ID &nbsp;&nbsp;:&nbsp;&nbsp;<?=$biller->code ?></td>
						<td style="width: 50%;border: #000 solid 1px;height: 25px;">អតិថិជនឈ្មោះ/Cust.Name &nbsp;&nbsp;:&nbsp;&nbsp;<?=$customer->names ?></td>
					</tr>
					<tr>
						<td style="width: 50%;border: #000 solid 1px;height: 25px;">អាស័យដ្ឋាន/Address &nbsp;&nbsp;:&nbsp;&nbsp;<?= $customer->address; ?></td>
						<td style="width: 50%;border: #000 solid 1px;height: 25px;">ភ្ជាប់ជួន/Att  &nbsp;&nbsp;:&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td style="width: 50%;border: #000 solid 1px;height: 25px;"></td>
					    <td style="width: 50%;border: #000 solid 1px;height: 25px;"></td>
					</tr>
					<tr>
						<td style="width: 50%;border: #000 solid 1px;height: 25px;">ទូរស័ព្ទ/Tel &nbsp;&nbsp;:&nbsp;&nbsp;<?=  $biller->phone;?></td>
						<td style="width: 50%;border: #000 solid 1px;height: 25px;">ទូរសារ/Fax &nbsp;&nbsp;:&nbsp;&nbsp;<?= $biller->email;?></td>
					</tr>
					<tr>
						<td style="width: 50%;border-top:#000 solid 1px;border-left:#000 solid 1px;border-right:#000 solid 1px;height: 25px;">លេខវិក័យប័ត្រយោង/ Ref.Inv number &nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<?= $inv->s_no; ?></td>
						<td style="width: 50%;border-top:#000 solid 1px;border-left:#000 solid 1px;border-right:#000 solid 1px;height: 25px;">លេខវិក័យប័ត្រឥណទាន/No.Credit Memo &nbsp;&nbsp;:&nbsp;&nbsp;<?= $inv->reference_no; ?></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="row">
            <?php
            $totaldis=0;
            foreach ($rows as $row){
                $totaldis+=$row->discount;

            }?>
			<div class="col-lg-12 col-sm-12 col-xs-12">
					<table class="table table-bordered table-hover" border="1">
				<thead>
					<tr>
						<th style="font-size:13px !important;" class="text-center"> ល.រ <br><?=lang('NO')?></th>
						<th style="font-size:13px !important;"class="text-center">កូដ <br><?=lang('Code')?></th>
						<th style="width:100px;font-size:13px !important;"class="text-center">បរិយាយ​ <br><?=lang('Descript')?></th>
						<th style="font-size:13px !important;width: 150px;"class="text-center">ឯកតា <br><?=lang(' Unit')?></th>
						<th style="font-size:13px !important;"class="text-center">បរិមាណ <br><?=lang('QTY')?></th>
						<th style="width:150px;font-size:13px !important;"class="text-center">តំលៃ <br><?=lang('Price')?></th>
                        <?php if($totaldis !=0){ ?>
                        <th style="font-size:13px !important;" class="text-center">បញ្ចុះតម្លៃ <br><?=lang('DISCOUNT')?></th>
                        <?php } ?>
						<th style="font-size:13px !important;" class="text-center">សរុប <br><?=lang('Total')?></th>
					</tr>
				</thead>
				<tbody>
					<?php //for($i=0; $i<20; $i++){
						$i=1;$erow=1;
						if(is_array($rows)){
							$total = 0;
							foreach ($rows as $row):
							//$this->erp->print_arrays($row);
							$free = lang('free');
							$product_unit = '';
							
							
							if($row->variant){
								$product_unit = $row->variant;
							}else{
								$product_unit = $row->uname;
							}
							$product_name_setting;
							if($Settings->show_code == 0) {
								$product_name_setting = $row->product_name ;
							}else {
								if($Settings->separate_code == 0) {
									$product_name_setting = $row->product_name . " (" . $row->product_code . ")";
								}else {
									$product_name_setting = $row->product_name;
								}
							}

							if($row->option_id){
										
							   $getvar = $this->sales_model->getAllProductVarain($row->product_id);
									 foreach($getvar as $varian){
										 if($varian->product_id){
											 if($varian->qty_unit == 0){
												$var = $this->sales_model->getVarain($row->option_id);
												$str_unit = $var->name;
											 }else{
												$var = $this->sales_model->getMaxqtyByProID($row->product_id);
												$var1 = $this->sales_model->getVarain($var->product_id);									
												$str_unit = $var1->name;
											}
										 }else{
											$str_unit = $row->uname;
										}
									}
							}else{
								$str_unit = $row->uname;
							}

					?>
					<tr style="border: #000 1px solid;">
						<td style=" text-align:center; vertical-align:middle;"><?=$i;?></td>
						<td style="text-align:left; vertical-align:middle;"><?= $row->product_code ?></td>
						<td style="text-align:left; vertical-align:middle;width:200px;">
								<?= $product_name_setting ?>
								<?= $row->details ? '<br>' . $row->details : ''; ?>
								<?= $row->serial_no ? '<br>' . $row->serial_no : ''; ?>
						</td>
						<td style="text-align:center; vertical-align:middle;">
							<?php
								if($row->piece != 0){
									echo $str_unit;
								}else{ 
									echo $row->product_unit;
								}

							?>
						</td>
						<td style=" text-align:center; vertical-align:middle;">
							<?php 
								if($row->piece != 0){ 
									echo $row->piece; 
								}else{ 
									echo $this->erp->formatQuantity($row->quantity);}
							?>
						</td>
						
						<td style="text-align:center; vertical-align:middle;">
							
							<div class="col-xs-6 text-right">
								<?=$this->erp->formatMoney($row->unit_price); ?>
							</div>
						</td>
                        <?php if($totaldis !=0){ ?>
                            <td style="text-align:center; vertical-align:middle;">
                                <div class="col-xs-3"></div>

                                <div class="col-xs-7 text-left">
                                    <?=$row->discount ? $row->discount:'0';?>
                                </div>
                            </td>
                        <?php } ?>

						<td style=" vertical-align:middle;">
							<div class="col-xs-3 text-left">
								<?php
									if ($row->subtotal!=0) {
										echo '';
									} else {
										echo '';
									}
								?>
							</div>
							<div class="col-xs-7 text-left">
								<?= $row->subtotal!=0 ? $this->erp->formatMoney($row->subtotal):$free; 
										$total += $row->subtotal;
										?>
							</div>
							
						</td>
					</tr>
					<?php 
						$i++;$erow++;
						endforeach;
					}
						if($erow<10){
							$k=10 - $erow;
							for($j=1;$j<=$k;$j++){
                                if($totaldis != 0) {
                                    echo  '<tr style="border: #000 1px solid;">
										<td height="34px" class="text-center" >'.$i.'</td>
										<td style="width:34px;"></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>';
                                }else {
                                    echo  '<tr style="border: #000 1px solid;">
										<td height="34px" class="text-center" >'.$i.'</td>
										<td style="width:34px;"></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>';
                                }

								$i++;
							}
						}
					?>
                    <?php
                    $rSpan = 0;
						$colspan=0;
						$col=0;
						$col1=0;
						$col2=0;
						if ($total != $inv->grand_total) {
							$rSpan = 5;
						}
						if ($inv->paid != 0)  {
							$rSpan = 4;
						}
						if( $inv->order_discount != 0 ){
                            $rSpan++;
                        }
						if(  $inv->shipping != 0 ){
                            $rSpan++;
                        }
						if(  $inv->order_tax !=0){
                            $rSpan++;
                        }

						if($totaldis!=0){
						    $col2 = 3;
                        }else{
                            $col2 = 2;
                        }
						if($totaldis!=0){
                            $colspan = 2;
                        }else{
                            $colspan = 1;
                        }

						
					?>

					<tr style="border: #000 1px solid;">
						<td colspan="5" rowspan="<?= $rSpan ?>" style="border-left: 1px solid #FFF !important;">
							<p style="text-align:left; font-weight: bold;border-left:1px solid white!important;border-bottom:"></p>
							<p><?= $inv->invoice_footer ?></p>
						</td>
						<td colspan="<?= $colspan ?>" style="text-align:left; "><?= lang('total')?></td>
						<td style="text-align:left; ">
							<div class="col-xs-3 text-left"></div>
							<div class="col-xs-7 text-left">
								<?=$this->erp->formatMoney($total);?>
							</div>
						</td>
					</tr>
					<?php if($inv->order_discount != 0){?>
					<tr style="border: #000 1px solid;">
						<!-- <td colspan="6" style="text-align:center; vertical-align:middle;"></td> -->
						<td colspan="<?= $colspan ?>" style="text-align:left; vertical-align:middle;"><?=lang('order_discount')?></td>
						<td style="text-align:left; vertical-align:middle;">
							<div class="col-xs-3 text-left"></div>
							<div class="col-xs-7 text-left">
								<?=$this->erp->formatMoney($inv->order_discount);?>
							</div>
						</td>
					</tr>
					<?php }?>
					<?php if($inv->shipping != 0){?>
					<tr style="border: #000 1px solid;">
						<!-- <td colspan="6" style="text-align:center; vertical-align:middle;"></td> -->
						<td colspan="<?= $colspan ?>"style="text-align:left; vertical-align:middle;"><?='ដឹកជញ្ជូន / '.lang('shipping')?></td>
						<td style="text-align:left; vertical-align:middle;">
							<div class="col-xs-3 text-left"></div>
							<div class="col-xs-7 text-left">
								<?=$this->erp->formatMoney($inv->shipping);?>
							</div>
						</td>
					</tr>
					<?php }?>
					<?php if($inv->order_tax !=0){?>
					<tr style="border: #000 1px solid;">
						<!-- <td colspan="6" style="text-align:center; vertical-align:middle;"></td> -->
						<td colspan="<?= $colspan ?>"style="text-align:left; vertical-align:middle;"><?='ពន្ធកម្ម៉ុង / '.lang('order_tax')?></td>
						<td style="text-align:left; vertical-align:middle;">
							<div class="col-xs-3 text-left"></div>
							<div class="col-xs-7 text-left">
								<?=$this->erp->formatMoney($inv->order_tax);?>
							</div>
						</td>
					</tr>
					<?php }?>
					<tr style="border: #000 1px solid;">
						
						<td colspan="<?= $colspan ?>"style="text-align:left; vertical-align:middle;"><?=lang('Total_Amount')?></td>
						<td style="text-align:left; vertical-align:middle;">
							<div class="col-xs-3 text-left"></div>
							<div class="col-xs-7 text-left">
								<?=$this->erp->formatMoney($inv->grand_total);?>
							</div>
						</td>
					</tr>
					<?php if($inv->paid !=0){?>
					<tr style="border: #000 1px solid;">
						<!-- <td colspan="6" style="text-align:center; vertical-align:middle;"></td> -->
						<td colspan="<?= $colspan ?>"style="text-align:left; vertical-align:middle;"><?='បង់ប្រាក់ / '.lang('paid')?></td>
						<td style="text-align:left; vertical-align:middle;">
							<div class="col-xs-3 text-left"></div>
							<div class="col-xs-7 text-left">
								<?=$this->erp->formatMoney($inv->paid);?>
							</div>
						</td>
					</tr>

                    <?php }?>
					<tr style="border: #000 1px solid;">
						<!-- <td colspan="7" style="text-align:center; vertical-align:middle;"></td> -->
						<td colspan="<?= $colspan ?>"style="text-align:left; vertical-align:middle;"><?='នៅខ្វះ / '.lang('balance')?></td>
						<td style="text-align:left; vertical-align:middle;">
							<div class="col-xs-3 text-left"></div>
							<div class="col-xs-7 text-left">
								<?=$this->erp->formatMoney($inv->grand_total - $inv->paid); ?>
							</div>
						</td>
					</tr>
                        <tr style="font-size: 12px;">
                            <td colspan="3" style="border: #000 solid 1px;height: 25px;text-align: center;">រៀបចំដោយ/Prepared By </td>
                            <td colspan="2" style="width: 16%; border: #000 solid 1px;height: 25px;"></td>
                            <td colspan="<?= $col2 ?>" style="width:37.5%; border-left: #000 solid 1px;border-right: #000 solid 1px;border-bottom: #000 solid 1px;height: 25px;">ទទូលដោយ​/Received By </td>
                        </tr>
                        <tr style="font-size: 12px;">
                            <td colspan="3" style="border: #000 solid 1px;height: 25px;"></td>
                            <td colspan="2" style="width: 16%;border: #000 solid 1px;height: 50px;"></td>
                            <td colspan="<?= $col2 ?>" style="border: #000 solid 1px;height: 25px;"></td>
                        </tr>
                        <tr style="font-size: 12px;">
                            <td colspan="3" style="border: #000 solid 1px;height: 25px;text-align: center;">អ្នកផ្គត់ផ្គង់ /Supplier </td>
                            <td colspan="2" style="width: 16%;border: #000 solid 1px;height: 25px;"></td>
                            <td colspan="<?= $col2 ?>" style="border: #000 solid 1px;height: 25px;">អតិថិជន/ Customer</td>
                        </tr>

				</tbody>
			</table>

                <br>
            </div>


		</div>
        <div style="width: 821px;margin: 20px">
            <a class="btn btn-warning no-print" href="<?= site_url('sales/return_sales'); ?>" style="border-radius: 0">
                <i class="fa fa-hand-o-left" aria-hidden="true"></i>&nbsp;<?= lang("back"); ?>
            </a>
        </div>
	</div>
	
</body>
</html>