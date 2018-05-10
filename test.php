<?php if ($Owner || $Admin || !$this->session->userdata('biller_id')) { ?>
    <div class="col-md-4">
        <div class="form-group">
            <?= lang("biller", "slbiller"); ?>
            <?php
            $bl[""] = "";
            foreach ($billers as $biller) {
                $bl[$biller->id] = $biller->company != '-' ? $biller->code .'-'.$biller->company : $biller->name;
            }
            echo form_dropdown('biller', $bl, (isset($_POST['biller']) ? $_POST['biller'] :
                $Settings->default_biller), 'id="slbiller" 
                data-placeholder="' . lang("select") . ' ' . lang("biller") . '" required="required" class="form-control input-tip select" style="width:100%;"');
            ?>
        </div>
    </div>
<?php } else if($this->session->userdata('biller_id')){ ?>
    <div class="col-md-4">
        <div class="form-group">
            <?= lang("biller", "slbiller"); ?>
            <?php
            $bl[""] = "";
            foreach ($billers as $biller) {
                $bl[$biller->id] = $biller->company != '-' ? $biller->code .'-'.$biller->company : $biller->name;
            }
            echo form_dropdown('biller', $bl, (isset($_POST['biller']) ? $_POST['biller'] : $this->session->userdata('biller_id')), 'id="slbiller" data-placeholder="' . lang("select") . ' ' . lang("biller") . '" required="required" class="form-control input-tip select" style="width:100%; pointer-events: none;"');
            ?>
        </div>
    </div>
<?php } ?>