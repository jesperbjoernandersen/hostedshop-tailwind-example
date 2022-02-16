{*

# Description
Checkout template partial for step 1, if the customer is a known user. Part of Checkout page type.


## Date last modified
2021-10-28


## Primary variables
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

<input type="hidden" name="user" id="user" value="1" />
<input type="hidden" name="userId" id="userId" value="{$user->Id}" />
<input type="hidden" name="firstname" autocomplete="given-name" id="firstname" value="{$user->Firstname}" />
<input type="hidden" name="lastname" autocomplete="family-name" id="lastname" value="{$user->Lastname}" />
<input type="hidden" name="company" autocomplete="organization" id="company" value="{$user->Company}" />
<input type="hidden" name="vatNumber" autocomplete="on" id="vatNumber" value="{$user->VatNumber}" />
<input type="hidden" name="eanNumber" autocomplete="on" id="eanNumber" value="{$user->Ean}" />
<input type="hidden" name="birthday" autocomplete="bday" id="birthday" value="{$user->DateOfBirth}" />
<input type="hidden" name="address" autocomplete="address-line1" id="address" value="{$user->Address}" />
<input type="hidden" name="address2" autocomplete="address-line2" id="address2" value="{$user->Address2}" />
<input type="hidden" name="zipcode" autocomplete="postal-code" id="zipcode" value="{$user->Zipcode}" />
<input type="hidden" name="city" autocomplete="address-level2" id="city" value="{$user->City}" />
<input type="hidden" name="country" autocomplete="country-name" id="country" value="{$user->Country}" />
<input type="hidden" name="countryCode" autocomplete="country" id="countryCode" value="{$user->CountryCode}" />
<input type="hidden" name="state" autocomplete="address-level1" id="state" value="{$user->State}" />
<input type="hidden" name="phone" autocomplete="tel" id="phone" value="{$user->Phone}" />
<input type="hidden" name="mobile" autocomplete="mobile tel" id="mobile" value="{$user->Mobile}" />
<input type="hidden" name="email" autocomplete="email" id="email" value="{$user->Email}" />

<div class="checkout-user">
	<p class="m-checkout-logged-in-text">{$Text.CHECKOUT_STEP_ONE_LOGGED_IN_TEXT}</p>

	<div class="m-checkout-data-name">
		<span class="m-checkout-firstname">{$user->Firstname}</span> <span class="m-checkout-lastname">{$user->Lastname}</span>
	</div>

	{if $user->Company}
        <div class="m-checkout-data-company">
        	<span class="m-checkout-company">{$user->Company}</span>{if $user->VatNumber} <span class="m-checkout-cvr">({$user->VatNumber})</span>{/if}
        </div>
	{/if}

	<div class="m-checkout-data-address">{$user->Address}</div>
	{if $user->Address2}
		<div class="m-checkout-data-address2">{$user->Address2}</div>
	{/if}

	{entity assign=userCountry controller=deliveryCountry iso=$user->Country}
	<div class="m-checkout-data-zip-city">
		<span class="m-checkout-zip">{$user->Zipcode}</span> {if $user->State and $userCountry}<span class="m-checkout-state">{$userCountry->CountryStates[$user->State]}</span>{/if} <span class="m-checkout-city">{$user->City}</span>
	</div>
	{if $userCountry}
 		<div class="m-checkout-data-country">{$userCountry->Title}</div>
 	{/if}

	{if $user->Phone}
 		<div class="m-checkout-data-phone">{$Text.TELEPHONE}: {$user->Phone}</div>
 	{/if}
	{if $user->Mobile}
 		<div class="m-checkout-data-phone">{$Text.MOBILE}: {$user->Mobile}</div>
 	{/if}
 	<div class="m-checkout-data-phone">{$Text.MAIL}: {$user->Email}</div>

	{include file="modules/widgets/customdata/customdata.tpl" entityType='customer' entityId=$user->Id context='checkout' display='list'}

 	<hr>
    <a class="button checkout-edit" href="/{$Text.USER_UPDATE_LINK}/">{$Text.EDIT}</a>
    <hr>
	<div class="m-checkout-logout"><p>{$Text.CHECKOUT_STEP_ONE_LOG_OUT_TEXT}</p></div>
	<hr>
</div>