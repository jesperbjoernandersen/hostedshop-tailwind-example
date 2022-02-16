{*

# Description
Template partial for Checkout delivery of the checkout process. Part of Checkout widget.
Consisting mostly of a [jsRender Template](http://www.jsviews.com/#jsrender).


## Date last modified
2021-01-25


## Resource
+ [jsRender Template](http://www.jsviews.com/#jsrender)


## Primary variables


## Partials (templates)
No extra templates required for this template

*}

{$country = $general.deliveryCountryIso}

{if $user}	
	{if !empty($user->Country)}
		{$country = $user->Country}
	{/if}
	<input type="hidden" name="company" id="company" value="{$user->Company}">
	<input type="hidden" name="vatNumber" id="vatNumber" value="{$user->VatNumber}">
	<input type="hidden" name="eanNumber" id="eanNumber" value="{$user->Ean}">
{/if}

{if $settings.shop_delivery_hidden}
	<input type="hidden" name="country" id="country" value="{$country}" />
{else}
	{collection controller=deliveryCountry payment_online_method_id=$pbsId assign=deliveryCountries access=true}
	<div class="w-checkout-delivery">
		<input type="hidden" name="post_delivery_method" value="{$returnPostData.delivery_method}">
		{if $returnPostData.delivery_multi}
			{foreach $returnPostData.delivery_multi as $key => $deliveryFixed}
				<input type="hidden" class="post_delivery_method_fixed" name="post_{$key}" value="{$deliveryFixed}">
			{/foreach}
		{/if}

		<div class="delivery">
			<div class="delivery-address">
				{if $deliveryCountries->getActualSize() gt 1}
					<fieldset class="form-group w-checkout-country">
						<label class="form-label" for="w-checkout-country">{$text.COUNTRY} <span class="form-required">*</span></label>
						<select id="country" class="country-select form-input form-select small" name="country" autocomplete="shipping country">
							{foreach $deliveryCountries->getData() as $country}
								<option value="{$country->Iso}"
									{if $returnPostData.country}{if $country->Iso eq $returnPostData.country}selected{/if}
										{elseif $country->Iso eq $general.deliveryCountryIso}selected{/if}>
									{$country->Title}
								</option>
							{/foreach}
						</select>
					</fieldset>
				{else}
					<input type="hidden" name="country" id="country" value="{$country}">
				{/if}

				<fieldset class="form-group w-checkout-zipcode">
					<label class="form-label" for="zipcode">{$text.POSTCODE} <span class="form-required">*</span></label>
					<input type="text" name="zipcode" autocomplete="postal-code" value="{strip}
						{if $user}
							{if $returnPostData.zipcode && $returnPostData.zipcode.length == 4}
								{$returnPostData.zipcode}
							{else}
								{$user->Zipcode}
							{/if}
						{else}
							{$returnPostData.zipcode}
						{/if}
					{/strip}" id="zipcode" class="form-input w-zipcode" placeholder="{$text.POSTCODE}" required>
				</fieldset>
			</div>

			<div class="delivery-list">
				<div class="methods-not-found is-hidden">{$text.CHECKOUT_STEP_TWO_METHODS_NONE}</div>
				{$loader}

				{* JS Render:  list of all delivery methods *}
				<ul class="delivery-method-list list-unstyled"></ul>

				<div class="delivery-notice">
					<fieldset class="form-group notice-order">
						<label class="form-label" for="customerNotice">
							<strong>{$text.CHECKOUT_STEP_TWO_COMMENT}</strong>
							<span class="w-checkout-link clear pull-right is-hidden">{$text.CHECKOUT_WIDGET_CLEAR}</span>
						</label>
						<textarea class="form-input" name="customerNotice" id="customerNotice" placeholder="{$text.CHECKOUT_STEP_TWO_COMMENT}">{$returnPostData.customerNotice}</textarea>
					</fieldset>
					<fieldset class="form-group notice-delivery is-hidden">
						<label class="form-label" for="customerNoticeDelivery">
							<strong>{$text.CHECKOUT_STEP_TWO_COMMENT_DELIVERY} *</strong>
							<span class="w-checkout-link clear pull-right is-hidden">{$text.CHECKOUT_WIDGET_CLEAR}</span>
						</label>
						<textarea class="form-input" name="customerNoticeDelivery" id="customerNoticeDelivery" placeholder="{$text.CHECKOUT_STEP_TWO_COMMENT_DELIVERY}">{$returnPostData.customerNoticeDelivery}</textarea>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
{/if}
