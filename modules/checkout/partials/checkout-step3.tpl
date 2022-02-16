{*

# Description
Template partial for Checkout step 3 of the checkout process. Part of Checkout page type.


## Date last modified
2015-01-05


## Primary variables


## Partials (templates)
No extra templates required for this template

*}

<input type="hidden" name="post_packingType" value="{$returnPostData.packingType}">

{literal}
<script id="giftWrappingTemplate" type="text/x-jsrender">
	<div class="giftWrappingOption">
		<fieldset class="form-group">
			<div class="input-group">
				<span class="input-group-addon">
					<input id="packing_id{{:id}}" type="radio" name="packingType" class="radiobtn" value="{{:id}}">
				</span>
				<label for="packing_id{{:id}}" class="form-label input-group-main">
					<span class="packingTypeTitle is-block">{{:title}}</span>
					{{if price}}
					<span class="error_text">{{:price}}</span>
					{{/if}}
					{{if description}}
					<span class="is-block">{{:description}}</span>
					{{/if}}
				</label>
			</div>
		</fieldset>
	</div>
</script>
{/literal}

<div class="giftWrappingLeftContainer">
</div>
<div class="giftWrappingRightContainer" {{if $returnPostData.packing_type == 0}} style="display:none;" {{else}} style="display:block;" {{/if}}>
	<fieldset id="m-checkout-giftwrapping-message" class="form-group">
		<label class="form-label" for="m-checkout-giftwrapping-message">{$Text.CHECKOUT_STEP_THREE_NOTE_ADD}</label>
		<textarea class="form-input" name="packingMessage" id="packingMessage" placeholder="{$Text.CHECKOUT_STEP_THREE_NOTE_ADD}" style="min-height: 140px;">{$returnPostData.packingMessage}</textarea>
	</fieldset>
	
	<fieldset id="m-checkout-giftwrapping-from" class="form-group">
		<label class="form-label" for="m-checkout-giftwrapping-from">{$Text.CHECKOUT_STEP_THREE_NOTE_FROM}</label>
		<input type="text" name="packingFrom" id="packingFrom" value="{$returnPostData.packingFrom}" class="form-input" placeholder="{$Text.CHECKOUT_STEP_THREE_NOTE_FROM}">
	</fieldset>
</div>