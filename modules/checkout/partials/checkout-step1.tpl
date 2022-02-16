{*

# Description
Template partial for Checkout step 1 of the checkout process. Part of Checkout page type.


## Date last modified
2018-11-14


## Primary variables
+ $User                                                    				- Global scope variable containing user data
+ $deliveryCountries													- Collection of the deliveryCountryController (countries we deliver to)


## Partials (templates)
+ "/modules/widgets/order/order.tpl"                        			- Template widget for the User Order Details
+ "/modules/checkout/partials/checkout-step1-user.tpl" 					- Template partial to fetch user data from $User
+ "/modules/checkout/partials/checkout-step1-customer.tpl"  			- Template partial to ask user for data

*}

{* Fetch delivery countrys *}
{collection controller=deliveryCountry assign=deliveryCountries access=true}

{* If the user is logged in, display the users information in step 1 *}
{if $user}
	{include file='modules/checkout/partials/checkout-step1-user.tpl'}
{* No user logged in *}
{else}
	{include file='modules/checkout/partials/checkout-step1-customer.tpl'}
{/if}

{if $settings.checkout_show_delivery_address}

<div class="deliveryContactInfoContainer">
	<div class="deliveryContactInfoDisplay checkbox">
		<fieldset id="m-checkout-del" class="form-group">
			<div class="input-group">
				<span class="input-group-addon"><input type="checkbox" class="radiobtn" name="deliveryActive" id="deliveryActive" {if $returnPostData.deliveryActive || $user->ShippingFirstname}checked{/if} /></span>
				<label for="deliveryActive" class="form-label input-group-main">{$Text.CHECKOUT_DELIVERY_ADDRESS_TEXT}</label>
			</div>
		</fieldset>
	</div>
	<div class="deliveryContactInfo" style="display: none;">
		<fieldset id="m-checkout-del-firstname" class="form-group">
			<label class="form-label" for="m-checkout-del-firstname">{$Text.FIRSTNAME} <span class="form-required">*</span></label>
			{if $returnPostData.deliveryFirstname}{$deliveryFirstName = $returnPostData.deliveryFirstname}{else}{$deliveryFirstName = $user->ShippingFirstname}{/if}
			<input type="text" name="deliveryFirstname" autocomplete="given-name" value="{$deliveryFirstName}"  id="deliveryFirstname" class="form-input" placeholder="{$Text.FIRSTNAME}" disabled required>
		</fieldset>

		<fieldset class="form-group m-checkout-del-lastname">
			<label class="form-label" for="m-checkout-del-lastname">{$Text.LASTNAME} <span class="form-required">*</span></label>
			{if $returnPostData.deliveryLastname}{$deliveryLastName = $returnPostData.deliveryLastname}{else}{$deliveryLastName = $user->ShippingLastname}{/if}
			<input type="text" name="deliveryLastname" autocomplete="family-name" value="{$deliveryLastName}" id="deliveryLastname" class="form-input" placeholder="{$Text.LASTNAME}" disabled required>
		</fieldset>

		<fieldset class="form-group m-checkout-del-company">
			<label class="form-label" for="m-checkout-del-company">{$Text.COMPANY}</label>
			{if $returnPostData.deliveryCompany}{$deliveryCompany = $returnPostData.deliveryCompany}{else}{$deliveryCompany = $user->ShippingCompany}{/if}
			<input type="text" name="deliveryCompany" autocomplete="organization" value="{$deliveryCompany}" id="deliveryCompany" class="form-input" placeholder="{$Text.COMPANY}" disabled>
		</fieldset>

		<fieldset class="form-group m-checkout-del-address">
			<label class="form-label" for="m-checkout-del-address">{$Text.ADDRESS} <span class="form-required">*</span></label>
			{if $returnPostData.deliveryAddress}{$deliveryAddress = $returnPostData.deliveryAddress}{else}{$deliveryAddress = $user->ShippingAddress}{/if}
			<input type="text" name="deliveryAddress" autocomplete="address-line1" value="{$deliveryAddress}" id="deliveryAddress" class="form-input" placeholder="{$Text.ADDRESS}" disabled required>
		</fieldset>

		{if $settings.shop_customer_address2}
		<fieldset class="form-group m-checkout-del-address2">
			<label class="form-label" for="m-checkout-del-address2">{$Text.ADDRESS2}</label>
			{if $returnPostData.deliveryAddress2}{$deliveryAddress2 = $returnPostData.deliveryAddress2}{else}{$deliveryAddress2 = $user->ShippingAddress2}{/if}
			<input type="text" name="deliveryAddress2" autocomplete="address-line2" value="{$deliveryAddress2}" id="deliveryAddress2" class="form-input" placeholder="{$Text.ADDRESS2}" disabled>
		</fieldset>
		{/if}

		<fieldset class="form-group m-checkout-del-zipcode">
			<label class="form-label" for="m-checkout-del-zipcode">{$Text.POSTCODE} <span class="form-required">*</span></label>
			{if $returnPostData.deliveryZipcode}{$deliveryZipcode = $returnPostData.deliveryZipcode}{else}{$deliveryZipcode = $user->ShippingZipcode}{/if}
			<input type="text" name="deliveryZipcode" autocomplete="postal-code" value="{$deliveryZipcode}" id="deliveryZipcode" placeholder="{$Text.POSTCODE}" class="form-input" disabled required>
		</fieldset>

		<fieldset class="form-group m-checkout-del-city">
			<label class="form-label" for="m-checkout-del-city">{$Text.CITY} <span class="form-required">*</span></label>
			{if $returnPostData.deliveryCity}{$deliveryCity = $returnPostData.deliveryCity}{else}{$deliveryCity = $user->ShippingCity}{/if}
			<input type="text" name="deliveryCity" autocomplete="address-level2" value="{$deliveryCity}" id="deliveryCity" class="form-input" placeholder="{$Text.CITY}" disabled required>
		</fieldset>

		<div class="deliveryCountry">
		{if $deliveryCountries->getActualSize() gt 1}
			<fieldset class="form-group m-checkout-del-country">
        		<label class="form-label" for="m-checkout-del-country">{$Text.COUNTRY} <span class="form-required">*</span></label>
				<select id="deliveryCountry" class="country-select form-input form-select small" name="deliveryCountry" autocomplete="shipping country">
					{if $returnPostData.deliveryCountry}{$deliveryCountry = $returnPostData.deliveryCountry}{else}{$deliveryCountry = $user->ShippingCountry}{/if}
					{foreach $deliveryCountries->getData() as $country}
						<option data-has-states="{count($country->CountryStates)}" value="{$country->Iso}"
						{if $deliveryCountry}
							{if $country->Iso eq $deliveryCountry}selected{/if}
						{elseif $country->Iso eq $general.deliveryCountryIso}selected{/if}>{$country->Title}</option>
					{/foreach}
				</select>
			</fieldset>
		{else}
			<input type="hidden" id="deliveryCountry" name="deliveryCountry" autocomplete="shipping country" value="{$general.deliveryCountryIso}">
		{/if}

		{foreach $deliveryCountries->getData() as $country}
			{if count($country->CountryStates) gt 0}
				<fieldset class="form-group deliveryCountry-state-group deliveryCountry-state-group-{$country->Iso} {if $general.deliveryCountryIso != $country->Iso}is-hidden{/if}">
	        		<label for="deliveryState{$country->Id}" class="form-label">{$Text.STATE} <span class="form-required">*</span></label>
					<select id="deliveryState{$country->Id}" class="deliveryCountry-state-select form-input form-select small" name="deliveryState" autocomplete="address-level1">
						{if $returnPostData.deliveryState}{$deliveryState = $returnPostData.deliveryState}{else}{$deliveryState = $user->ShippingState}{/if}
						{foreach $country->CountryStates as $DeliveryStateAbbr => $DeliveryStateName}
							<option value="{$DeliveryStateAbbr}"
							{if $DeliveryStateAbbr eq $deliveryState}selected{/if}>{$DeliveryStateName}</option>
						{/foreach}
					</select>
				</fieldset>
			{/if}
		{/foreach}
		</div>

		{if $settings.shop_customer_phone || $settings.shop_customer_mobile}
			{$deliveryCountryCode = $general.deliveryCountryCode}
			{if $returnPostData.deliveryCountryCode}
				{$deliveryCountryCode = $returnPostData.deliveryCountryCode}
			{/if}

			{if $settings.shop_customer_phone}
				<fieldset class="form-group m-checkout-del-phone">
					<label class="form-label" for="m-checkout-del-phone">{$Text.TELEPHONE} {if $settings.shop_customer_phone_validation}<span class="form-required">*</span>{/if}</label>
					<input class="deliveryCountryCode" type="hidden" name="deliveryCountryCode" autocomplete="tel-country-code" value="{$deliveryCountryCode}" />
					{if $returnPostData.deliveryPhone}{$deliveryPhone = $returnPostData.deliveryPhone}{else}{$deliveryPhone = $user->ShippingPhone}{/if}
					<div class="input-group">
						<span class="deliveryCountryCode input-group-addon">+{$deliveryCountryCode}</span>
						<input type="text" name="deliveryPhone" autocomplete="tel-national" value="{$deliveryPhone}" id="deliveryPhone" class="form-input input-group-main" placeholder="{$Text.TELEPHONE}">
					</div>
				</fieldset>
			{/if}

			{if $settings.shop_customer_mobile}
				<fieldset class="form-group m-checkout-del-mobile">
					<label class="form-label" for="m-checkout-del-mobile">{$Text.MOBILE} {if $settings.shop_customer_mobile_validation}<span class="form-required">*</span>{/if}</label>
					<input class="deliveryCountryCode" type="hidden" name="deliveryCountryCode" autocomplete="tel-country-code" value="{$deliveryCountryCode}" />
					{if $returnPostData.deliveryMobile}{$deliveryMobile = $returnPostData.deliveryMobile}{else}{$deliveryMobile = $user->ShippingMobile}{/if}
					<div class="input-group">
						<span class="deliveryCountryCode input-group-addon">+{$deliveryCountryCode}</span>
						<input type="text" name="deliveryMobile" autocomplete="mobile tel-national" value="{$deliveryMobile}" id="deliveryMobile" class="form-input input-group-main" placeholder="{$Text.MOBILE}">
					</div>
				</fieldset>
			{/if}
		{/if}
	</div>
</div>
{/if}

{if $settings.checkout_reference_number}
<div class="referenceNumber">
	<fieldset class="form-group m-checkout-del-reference">
		<label class="form-label" for="m-checkout-del-reference">{$Text.MY_ORDERS_REFERENCE_NUMBER}{if $settings.checkout_reference_number_required} <span class="form-required">*</span>{/if}</label>
		<input type="text" name="referenceNumber" autocomplete="disabled" value="{$returnPostData.referenceNumber}" id="referenceNumber" class="form-input" placeholder="{$Text.MY_ORDERS_REFERENCE_NUMBER}" {if $settings.checkout_reference_number_required}required{/if}>
	</fieldset>
</div>
{/if}
