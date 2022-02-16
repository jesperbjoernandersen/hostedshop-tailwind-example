<div class="DroppointAddressContainer panel panel-border" style="display:none;">
	<div class="panel-heading">
		<a class="DroppointAddressToggle" href="#" data-target=".DroppointAddressContent">{$Text.CHECKOUT_STEP_TWO_DROPPOINT_SEARCH} <i class="fa fa-fw fa-caret-down pull-right is--closed"></i><i class="fa fa-fw fa-caret-up pull-right is--opened"></i></a>
	</div>
	<div class="DroppointAddressContent" style="display:none;">
		<div class="panel-body">
			<fieldset class="form-group">
				<input class="m-address form-input" type="text" name="droppoint_address" value="" placeholder="{$Text.ADDRESS}">
				<input class="m-zipcode form-input" type="text" name="droppoint_zipcode" value="" placeholder="{$Text.POSTCODE}">
			</fieldset>
		</div>
		<div class="panel-footer">
			<fieldset class="form-group form-action">
				<button class="SearchDroppointAddress m-search button-primary form-submit" type="button">{$Text.SEARCH}</button>
			</fieldset>
		</div>
	</div>
</div>