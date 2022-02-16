{*

# Description
Template for a Product vat picker/switcher in a column box


## Date last modified
2014-08-01


## Primary variables
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


<div class="panel panel-border column-box b-vat">
	<div class="panel-heading b-vat-header b-header">
		<span class="h5">{$text.PRODUCT_CATALOG_VAT_DISPLAY}</span>
	</div>
	<div class="panel-body">
        <select name="vat" class="form-input form-select small" onchange="window.location = '/actions/vat/change?select='+ this.value +''">
            <option value="vat"{if $currency.hasVat} selected{/if}>{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_CLEAN}</option>
            <option value="no_vat"{if !$currency.hasVat} selected{/if}>{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO_CLEAN}</option>
        </select>
	</div>
</div>
