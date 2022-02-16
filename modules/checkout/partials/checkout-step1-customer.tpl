{*

# Description
Checkout template partial for step 1, if the customer is a new user. Part of Checkout page type.


## Date last modified
2021-08-05


## Primary variables
+ $text                                                     			- Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

<input type="hidden" name="bruger" value="0" />

<div class="contactInfoContainer">
	{if $settings.shop_customer_company or $settings.shop_customer_institution}
	<fieldset class="form-group m-checkout-customer-type" style="display:none;">
		<label class="form-label">{$Text.CUSTOMER_TYPE}</label>
		<div class="button-group">
			<label class="button-primary">
				<input type="radio" name="customer-type" value="private">
				<span>{$Text.CUSTOMER_TYPE_PRIVATE}</span>
			</label>

			{if $settings.shop_customer_company}
			<label class="button">
				<input type="radio" name="customer-type" value="company">
				<span>{$Text.CUSTOMER_TYPE_COMPANY}</span>
			</label>
			{/if}
			
			{if $settings.shop_customer_institution}
			<label class="button">
				<input type="radio" name="customer-type" value="institution">
				<span>{$Text.CUSTOMER_TYPE_INSTITUTION}</span>
			</label>
			{/if}
		</div>
	</fieldset>
	{/if}

	{if $settings.shop_customer_company}
	<div class="customer-type-dynamic-fields" style="display:none">
		<fieldset class="form-group m-checkout-company" data-active-on-customer-type="company" style="display: none;">
			<label class="form-label" for="m-checkout-company">{$Text.COMPANY} <span class="form-required">*</span></label>
			<input type="text" name="company" autocomplete="organization" value="{$returnPostData.company}" id="company" class="form-input" placeholder="{$Text.COMPANY}" data-is-required disabled>
		</fieldset>
		
		<fieldset class="form-group m-checkout-vatnumber" data-active-on-customer-type="company" style="display: none;">
			<label class="form-label" for="m-checkout-vatnumber">{$Text.VAT_NR} <span class="form-required">*</span></label>
			<input type="text" name="vatNumber" autocomplete="disable" value="{$returnPostData.vatNumber}" id="vatNumber" class="form-input" placeholder="{$Text.VAT_NR}" data-is-required disabled>
		</fieldset>
		
		<fieldset class="form-group m-checkout-eannumber" data-active-on-customer-type="company" style="display: none;">
			<label class="form-label" for="m-checkout-eannumber">{$Text.EAN}</label>
			<input type="text" name="eanNumber" autocomplete="disable" value="{$returnPostData.eanNumber}" id="eanNumber" class="form-input" placeholder="{$Text.EAN}" disabled>
		</fieldset>
	</div>
	{/if}

	{if $settings.shop_customer_institution}
	<div class="customer-type-dynamic-fields" style="display:none">
		<fieldset class="form-group m-checkout-company" data-active-on-customer-type="institution" style="display: none;">
			<label class="form-label" for="m-checkout-company">{$Text.COMPANY_OR_INSTITUTION} <span class="form-required">*</span></label>
			<input type="text" name="company" autocomplete="organization" value="{$returnPostData.company}" id="company" class="form-input" placeholder="{$Text.COMPANY_OR_INSTITUTION}" data-is-required disabled>
		</fieldset>
		
		<fieldset class="form-group m-checkout-eannumber" data-active-on-customer-type="institution" style="display: none;">
			<label class="form-label" for="m-checkout-eannumber">{$Text.EAN} <span class="form-required">*</span></label>
			<input type="text" name="eanNumber" autocomplete="disable" value="{$returnPostData.eanNumber}" id="eanNumber" class="form-input" placeholder="{$Text.EAN}" data-is-required disabled>
		</fieldset>
	</div>
	{/if}

	<fieldset class="form-group m-checkout-firstname">
		<label class="form-label" for="m-checkout-firstname">{$Text.FIRSTNAME} <span class="form-required">*</span></label>
		<input type="text" name="firstname" autocomplete="given-name" value="{$returnPostData.firstname}" id="firstname" class="form-input" placeholder="{$Text.FIRSTNAME}" required>
	</fieldset>

	<fieldset class="form-group m-checkout-lastname">
		<label class="form-label" for="m-checkout-lastname">{$Text.LASTNAME} <span class="form-required">*</span></label>
		<input type="text" name="lastname" autocomplete="family-name" value="{$returnPostData.lastname}" id="lastname" class="form-input" placeholder="{$Text.LASTNAME}" required>
	</fieldset>

	<div class="customer-type-static-fields">
		{if $settings.shop_customer_company}
		<fieldset class="form-group m-checkout-company">
			<label class="form-label" for="m-checkout-company">{$Text.COMPANY} {$Text.USER_ONLY_FOR_COMPANIES}</label>
			<input type="text" name="company" autocomplete="organization" value="{$returnPostData.company}" id="company" class="form-input" placeholder="{$Text.COMPANY} {$Text.USER_ONLY_FOR_COMPANIES}">
		</fieldset>
		{/if}

		{if $settings.shop_customer_company}
		<fieldset class="form-group m-checkout-vatnumber">
			<label class="form-label" for="m-checkout-vatnumber">{$Text.VAT_NR} {$Text.USER_ONLY_FOR_COMPANIES}</label>
			<input type="text" name="vatNumber" autocomplete="disable" value="{$returnPostData.vatNumber}" id="vatNumber" class="form-input" placeholder="{$Text.VAT_NR} {$Text.USER_ONLY_FOR_COMPANIES}">
		</fieldset>
		{/if}

		{if $settings.shop_customer_institution}
		<fieldset class="form-group m-checkout-eannumber">
			<label class="form-label" for="m-checkout-eannumber">{$Text.EAN} {$Text.USER_ONLY_FOR_INSTITUTIONS}</label>
			<input type="text" name="eanNumber" autocomplete="disable" value="{$returnPostData.eanNumber}" id="eanNumber" class="form-input" placeholder="{$Text.EAN} {$Text.USER_ONLY_FOR_INSTITUTIONS}">
		</fieldset>
		{/if}
	</div>
	
	{if $settings.shop_customer_birthdate}
	<fieldset class="form-group m-checkout-birthday">
		<label class="form-label" for="m-checkout-birthday">{$Text.BIRTHDATE}</label>
		<div class="input-group small">
			<span class="input-group-addon"><i class="fa fa-fw fa-calendar"></i></span>
			<input type="date" name="birthday" autocomplete="bday" id="birthday" value="{$returnPostData.birthday}" class="form-input" placeholder="{$Text.BIRTHDATE}">
		</div>
	</fieldset>
	{/if}

	<fieldset class="form-group m-checkout-address">
		<label class="form-label" for="m-checkout-address">{$Text.ADDRESS} <span class="form-required">*</span></label>
		<input type="text" name="address" autocomplete="street-address" value="{$returnPostData.address}" id="address" class="form-input" placeholder="{$Text.ADDRESS}" required>
	</fieldset>

	{if $settings.shop_customer_address2}
	<fieldset class="form-group m-checkout-address2">
		<label class="form-label" for="m-checkout-address2">{$Text.ADDRESS2}</label>
		<input type="text" name="address2" autocomplete="address-line2" value="{$returnPostData.address2}" id="address2" class="form-input" placeholder="{$Text.ADDRESS2}">
	</fieldset>
	{/if}

	<fieldset class="form-group m-checkout-zipcode">
		<label class="form-label" for="m-checkout-zipcode">{$Text.POSTCODE} <span class="form-required">*</span></label>
		<input type="text" name="zipcode" autocomplete="postal-code" value="{$returnPostData.zipcode}" id="zipcode" class="form-input" placeholder="{$Text.POSTCODE}" required>
	</fieldset>

	<fieldset class="form-group m-checkout-city">
		<label class="form-label" for="m-checkout-city">{$Text.CITY} <span class="form-required">*</span></label>
		<input type="text" name="city" autocomplete="address-level2" value="{$returnPostData.city}" id="city" class="form-input" placeholder="{$Text.CITY}" required>
	</fieldset>

	<div class="country">
	{if $deliveryCountries->getActualSize() gt 1}
		<fieldset class="form-group m-checkout-country">
    		<label class="form-label" for="m-checkout-country">{$Text.COUNTRY} <span class="form-required">*</span></label>
			<select id="country" class="country-select form-input form-select small" name="country" autocomplete="shipping country">
				{foreach $deliveryCountries->getData() as $country}
					<option data-has-states="{count($country->CountryStates)}" value="{$country->Iso}"
					{if $returnPostData.country}{if $country->Iso eq $returnPostData.country}selected{/if}{elseif $country->Iso eq $general.deliveryCountryIso}selected{/if}>{$country->Title}</option>
				{/foreach}
			</select>
		</fieldset>
	{else}
		{foreach $deliveryCountries->getData() as $country}
			<input id="country" type="hidden" name="country" autocomplete="shipping country" value="{$general.deliveryCountryIso}" data-has-states="{count($country->CountryStates)}">
		{/foreach}
	{/if}

	{foreach $deliveryCountries->getData() as $country}
		{if count($country->CountryStates) gt 0}
			<fieldset class="form-group country-state-group country-state-group-{$country->Iso} {if $general.deliveryCountryIso != $country->Iso}is-hidden{/if}">
        		<label class="form-label" for="state{$country->Id}">{$Text.STATE} <span class="form-required">*</span></label>
				<select id="state{$country->Id}" class="country-state-select form-input form-select small" name="state" autocomplete="address-level1" disabled required>
					{foreach $country->CountryStates as $DeliveryStateAbbr => $DeliveryState}
						<option value="{$DeliveryStateAbbr}" {if $DeliveryStateAbbr eq $returnPostData.state}selected{/if}>{$DeliveryState}</option>
					{/foreach}
				</select>
			</fieldset>
		{/if}
	{/foreach}
	</div>

	<fieldset class="form-group m-checkout-email">
		<label class="form-label" for="m-checkout-email">{$Text.MAIL} <span class="form-required">*</span></label>
		<input type="email" name="email" autocomplete="email" value="{$returnPostData.email}" id="email" class="form-input" placeholder="{$Text.MAIL}" required>
	</fieldset>

	{if $settings.shop_customer_email_confirm}
		<fieldset class="form-group m-checkout-emailconf">
			<label class="form-label" for="m-checkout-emailconf">{$text.MAIL_CONFIRM} <span class="form-required">*</span></label>
			<input id="m-checkout-emailconf" name="email_confirmation" autocomplete="email" type="email" class="form-input" placeholder="{$text.MAIL_CONFIRM}" {if $returnPostData.email_confirmation}value="{$returnPostData.email_confirmation}"{/if} required>
		</fieldset>
	{/if}

	{if $settings.shop_customer_phone || $settings.shop_customer_mobile}
		{$countryCode = $general.deliveryCountryCode}
		{if $returnPostData.countryCode}
			{$countryCode = $returnPostData.countryCode}
		{/if}

		{if $settings.shop_customer_phone}
			<fieldset class="form-group m-checkout-phone">
			<label class="form-label" for="m-checkout-phone">{$Text.TELEPHONE} {if $settings.shop_customer_phone_validation}<span class="form-required">*</span>{/if}</label>
				<input class="countryCode" type="hidden" name="countryCode" autocomplete="tel-country-code" value="{$countryCode}" />
			    <div class="input-group">
					<span class="countryCode input-group-addon">+{$countryCode}</span>
				<input type="text" name="phone" autocomplete="tel-national" value="{$returnPostData.phone}" id="phone" class="form-input input-group-main" placeholder="{$Text.TELEPHONE}" {if $settings.shop_customer_phone_validation}required{/if}>
			    </div>
			</fieldset>
		{/if}

		{if $settings.shop_customer_mobile}
			<fieldset class="form-group m-checkout-mobile">
				<label class="form-label" for="m-checkout-mobile">{$Text.MOBILE} {if $settings.shop_customer_mobile_validation}<span class="form-required">*</span>{/if}</label>
				<input class="countryCode" type="hidden" name="countryCode" autocomplete="tel-country-code" value="{$countryCode}" />
			    <div class="input-group">
					<span class="countryCode input-group-addon">+{$countryCode}</span>
					<input type="text" name="mobile" autocomplete="mobile tel-national" value="{$returnPostData.mobile}" id="mobile" class="form-input input-group-main" placeholder="{$Text.MOBILE}" {if $settings.shop_customer_mobile_validation}required{/if}>
			    </div>
			</fieldset>
		{/if}
	{/if}

	{include file="modules/widgets/customdata/customdata.tpl" entityType='customer' entityId=$user->Id context='checkout'}
</div>

<hr>

{if $access.user && $settings.news_signup}
<div class="newsletterContainer">
	<div class="newsletter checkbox">
		<fieldset class="form-group m-checkout-newsletter">
			<div class="input-group">
				<span class="input-group-addon"><input type="checkbox" name="newsletter" class="radiobtn" id="newsletter" {if $returnPostData.newsletter}checked{/if} /></span>
				<label for="newsletter" class="form-label input-group-main">{$Text.USER_NEWSLETTER} <i class="fa fa-question-circle tooltip"><span class="tooltiptext">{$text.NEWSLETTER_TYPE_DESCRIPTION_SHOP}</span>
					</i></label>
			</div>
		</fieldset>
	</div>
</div>
{/if}

<div class="interestsContainer">
	{collection controller=interestField assign=interestFieldsCustomer categoryId=1}
	{collection controller=interestField assign=interestFieldsNewsletter categoryId=3}

	{if $interestFieldsNewsletter->getActualSize() gt 0}
		<div id="interests" style="display:none;">
			<div class="interestsTitle">{$Text.USER_NEWSLETTER_CHOOSE_INTEREST_GROUPS}</div>
			{foreach from=$interestFieldsNewsletter->getData() key=k item=v}
		        <div class="checkbox{if $k % 4 == 3} newline{/if}">
			    	<fieldset id="m-checkout-newsletterfields" class="form-group">
						<div class="input-group">
							<span class="input-group-addon">
								<input type="checkbox" name="interestGroups[{$v->Id}]" class="radiobtn" id="newsletter[{$v->Id}]" />
							</span>
							<label for="newsletter[{$v->Id}]" class="form-label input-group-main">{$v->Title}</label>
						</div>
					</fieldset>
				</div>
			{/foreach}
		</div>
	{/if}

	{if $interestFieldsCustomer->getActualSize() gt 0}
		<div id="interests_customer" style="display:none;">
			<div class="interestsTitle">{$Text.USER_NEWSLETTER_CHOOSE_INTEREST_GROUPS}</div>
			{foreach from=$interestFieldsCustomer->getData() key=k item=v}
		        <div class="checkbox{if $k % 4 == 3} interestNewline{/if}">
			    	<fieldset id="m-checkout-newsletterfields" class="form-group">
						<div class="input-group">
							<span class="input-group-addon">
								<input type="checkbox" name="interestGroups[{$v->Id}]" class="radiobtn" id="newsletter[{$v->Id}]" />
							</span>
							<label for="newsletter[{$v->Id}]" class="form-label input-group-main">{$v->Title}</label>
						</div>
					</fieldset>
				</div>
			{/foreach}
		</div>
	{/if}
</div>

{if $access.user && $settings.user_add}
<div class="createUserContainer">
	<div class="checkbox">
		<fieldset id="m-checkout-createuser" class="form-group">
			<div class="input-group">
				<span class="input-group-addon"><input type="checkbox" class="radiobtn" name="createUser" id="createUser" {if $returnPostData.createUser}checked{/if} /></span>
				<label for="createUser" class="form-label input-group-main">{$Text.CHECKOUT_STEP_ONE_PASSWORD_YES} <i class="fa fa-question-circle tooltip"><span class="tooltiptext">{$text.ACCOUNT_CONSENT_DESCRIPTION_SHOP}</span>
					</i></label>
			</div>
		</fieldset>
	</div>

	<div id="inputPassword" style="display: none;">
		<fieldset class="form-group m-checkout-password">
			<label class="form-label" for="password">{$Text.PASSWORD} <span class="form-required">*</span></label>
			<input type="password" name="password" autocomplete="new-password" id="password" class="form-input" placeholder="{$Text.PASSWORD}" disabled required>
		</fieldset>

		<fieldset class="form-group m-checkout-passwordconf">
			<label class="form-label" for="passwordConfirmation">{$Text.PASSWORD_CONFIRM} <span class="form-required">*</span></label>
			<input type="password" name="passwordConfirmation" autocomplete="new-password" id="passwordConfirmation" class="form-input" placeholder="{$Text.PASSWORD_CONFIRM}" disabled required>
		</fieldset>
	</div>
</div>
{/if}
