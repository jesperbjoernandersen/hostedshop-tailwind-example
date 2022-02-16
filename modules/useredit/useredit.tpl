{*

# Description
Controller and template for the User Edit page type


## Date last modified
2021-08-05


## Primary variables
+ $item 																- Entity of userController (the current user)
+ $deliveryCountries 													- Collection of deliveryCountryController
+ $interestFields 														- Collection of interestFieldController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $settings                                                             - Global scope variable containing platform settings
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{* Fetch delivery countrys *}
{collection controller=deliveryCountry assign=deliveryCountries access=true}

{* Fetch interest fields *}
{collection controller=interestField assign=interestFields categoryId=$user->CategoryId}

{* Phone code *}
{$phonecode = $user->CountryCode}

{if $phonecode == 0}
	{$phonecode = $general.deliveryCountryCode}
{/if}

{if $settings.privacy_policy_user && !$user->Consent}
<div class="w-notification">
    <div class="panel panel-danger">
        <div class="panel-body text-center">
            {$text.CONSENT_WARNING_MESSAGE}
        </div>
    </div>
</div>
{/if}

<div class="modules m-useredit">
	<article class="m-useredit-article">
		<header class="m-useredit-header page-title">
			<h1 class="m-useredit-headline">{$text.USER_UPDATE_HEADLINE}</h1>
		</header>

		<div class="m-useredit-description description trailing">
			<p class="m-useredit-description">{$text.USER_UPDATE_PROFILE_TEXT}. {$text.USER_ADD_REQUIRED_FIELDS}.</p>
		</div>

		<form id="m-useredit" method="post" action="/actions/user/edit">
			{csrf type="input"}
			<div class="panel panel-border">
    			<div class="panel-body">
    				<div class="row trailing">
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
			              	{if $general.isShop}
			       				<h5>{$text.BILLING_ADDRESS}</h5>
			              	{/if}

							{* Customer type toggle and dynamic company related inputs *}
							{include
								file="modules/widgets/customertypeinput/customertypeinput.tpl"
								inputFieldPrefix="m-useredit"
								companyName=$user->Company
								vatNumber=$user->VatNumber
								eanNumber=$user->Ean
							}

    						<fieldset class="form-group m-useredit-firstname">
					        	<label class="form-label" for="m-useredit-firstname">{$text.FIRSTNAME} <span class="form-required">*</span></label>
								<input id="m-useredit-firstname" name="firstname" type="text" class="form-input small" placeholder="{$text.FIRSTNAME}" value="{$user->Firstname}" required>
							</fieldset>

							<fieldset class="form-group m-useredit-lastname">
					        	<label class="form-label" for="m-useredit-lastname">{$text.LASTNAME} <span class="form-required">*</span></label>
								<input id="m-useredit-lastname" name="lastname" type="text" class="form-input small" placeholder="{$text.LASTNAME}" value="{$user->Lastname}" required>
							</fieldset>

							{if $settings.shop_customer_birthdate}
							<fieldset class="form-group m-useredit-birthday">
					        	<label class="form-label" for="m-useredit-birthday">{$text.BIRTHDATE}</label>
					        	<div class="input-group small">
						        	<span class="input-group-addon"><i class="fa fa-fw fa-calendar"></i></span>
									<input id="m-useredit-birthday" name="birthday" type="date" class="form-input small" value="{$user->DateOfBirth|date_format:'%Y-%m-%d'}">
								</div>
							</fieldset>
							{/if}

							<fieldset class="form-group m-useredit-address">
					        	<label class="form-label" for="m-useredit-address">{$text.ADDRESS} <span class="form-required">*</span></label>
								<input id="m-useredit-address" name="address" type="text" class="form-input small" placeholder="{$text.ADDRESS}" value="{$user->Address}" required>
							</fieldset>

							{if $settings.shop_customer_address2}
							<fieldset class="form-group m-useredit-address2">
					        	<label class="form-label" for="m-useredit-address2">{$text.ADDRESS2}</label>
								<input id="m-useredit-address2" name="address2" type="text" class="form-input small" placeholder="{$text.ADDRESS2}" value="{$user->Address2}">
							</fieldset>
							{/if}

							<fieldset class="form-group m-useredit-zipcode">
					        	<label class="form-label" for="m-useredit-zipcode">{$text.POSTCODE} <span class="form-required">*</span></label>
								<input id="m-useredit-zipcode" name="zipcode" type="text" class="form-input small" placeholder="{$text.POSTCODE}" value="{$user->Zipcode}" required>
							</fieldset>

							<fieldset class="form-group m-useredit-city">
					        	<label class="form-label" for="m-useredit-city">{$text.CITY} <span class="form-required">*</span></label>
								<input id="m-useredit-city" name="city" type="text" class="form-input small" placeholder="{$text.CITY}" value="{$user->City}" required>
							</fieldset>

							{if $deliveryCountries->getActualSize() gt 1}
								<fieldset class="form-group m-useredit-country">
					        		<label class="form-label" for="m-useredit-country">{$text.COUNTRY} <span class="form-required">*</span></label>
									<select id="m-useredit-country" class="form-input form-select small" name="country">
										{foreach $deliveryCountries->getData() as $country}
											<option data-has-states="{count($country->CountryStates)}" value="{$country->Iso}" {if $user->Country == $country->Iso}selected{/if}>{$country->Title}</option>
										{/foreach}
									</select>
								</fieldset>
							{else}
								{foreach $deliveryCountries->getData() as $country}
									<input id="m-useredit-country" type="hidden" name="country" value="{$general.deliveryCountryIso}" data-has-states="{count($country->CountryStates)}">
								{/foreach}
							{/if}

							<input type="hidden" name="state" value="">
							{foreach $deliveryCountries->getData() as $country}
								{if count($country->CountryStates) gt 0}
									<fieldset id="cuStateWrapper" class="form-group state-group state-group-{$country->Iso} {if $user->Country != $country->Iso}is-hidden{/if}">
						        		<label class="form-label" for="m-useredit-state">{$text.STATE} <span class="form-required">*</span></label>
										<select id="m-useredit-state-{$country->Iso}" class="m-useredit-state state-select form-input form-select small" name="state" disabled>
											{foreach $country->CountryStates as $state}
												<option value="{$state}" {if $user->State == $state}selected{/if}>{$state}</option>
											{/foreach}
										</select>
									</fieldset>
								{/if}
							{/foreach}

							<input class="countryCode" type="hidden" name="countryCode" value="{$phonecode}">

							{if $settings.shop_customer_phone}
							<fieldset class="form-group m-useredit-phone">
					        	<label class="form-label" for="m-useredit-phone">{$text.TELEPHONE} {if $settings.shop_customer_phone_validation}<span class="form-required">*</span>{/if}</label>
							    <div class="input-group small">
							        <span class="input-group-addon countryCode">+{$phonecode}</span>
							        <input id="m-useredit-phone" name="phone" type="text" class="form-input input-group-main" placeholder="{$text.TELEPHONE}" value="{$user->Phone}" {if $settings.shop_customer_phone_validation}required{/if}>
							    </div>
							</fieldset>
							{/if}

							{if $settings.shop_customer_mobile}
							<fieldset class="form-group m-useredit-mobilephone">
					        	<label class="form-label" for="m-useredit-mobilephone">{$text.MOBILE} {if $settings.shop_customer_mobile_validation}<span class="form-required">*</span>{/if}</label>
							    <div class="input-group small">
							        <span class="input-group-addon countryCode">+{$phonecode}</span>
									<input id="m-useredit-mobilephone" name="mobilephone" type="text" class="form-input input-group-main small" placeholder="{$text.MOBILE}" value="{$user->Mobile}" {if $settings.shop_customer_mobile_validation}required{/if}>
								</div>
							</fieldset>
							{/if}

		                	{include file="modules/widgets/customdata/customdata.tpl" entityType='customer' entityId=$user->Id context='user'}

    					</div>
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

							{if $interestFields->getActualSize() gt 0}
							<fieldset id="m-useredit-newsletterfields" class="form-group {if !$user->Newsletter}is-hidden{/if}">
								<label class="form-label" for="m-useredit-newsletterfields">{$text.USER_NEWSLETTER_CHOOSE_INTEREST_GROUPS}</label>
								<ul class="list-unstyled list-inline m-useredit-newsletterfields-interestgroups">
								{foreach $interestFields->getData() as $interestField}
									<li>
										<label class="m-useredit-newsletterfields{$interestField->Id} form-label" for="m-useredit-newsletterfields{$interestField->Id}">
											<input id="m-useredit-newsletterfields[{$interestField->Id}]" name="interestGroups[{$interestField->Id}]" type="checkbox"
											{if in_array($interestField->Id, $user->InterestFieldIds)} checked="checked"{/if}>
											<span class="m-useredit-newsletterfields-label">{$interestField->Title}</span>
											{if in_array($interestField->Id, $user->InterestFieldIds)}<input type="hidden" name="interestGroupsOff[{$interestField->Id}]">{/if}
										</label>
									</li>
								{/foreach}
								</ul>
							</fieldset>
							{/if}

							<div id="deliveryContactInfoContainer" class="deliveryContactInfoContainer is-hidden">
								{if $settings.checkout_show_delivery_address && $general.isShop}
	              				<h5>{$text.DELIVERY_ADDRESS}</h5>
									<div class="deliveryContactInfoDisplay checkbox">
										<br/>
										<fieldset id="m-useredit-del" class="form-group">
											<div class="input-group">
												<span class="input-group-addon"><input type="checkbox" class="radiobtn" name="deliveryActive" id="deliveryActive" {if $user->ShippingFirstname || $returnPostData.deliveryActive}checked{/if} /></span>
												<label for="deliveryActive" class="form-label input-group-main">{$text.USER_ADD_SAVE_DELIVERY_ADDRESS}</label>
											</div>
										</fieldset>
									</div>

									<div class="deliveryContactInfo" style="display: none;">
										<fieldset id="m-useredit-del-firstname" class="form-group">
											<label class="form-label" for="m-useredit-del-firstname">{$Text.FIRSTNAME} <span class="form-required">*</span></label>
											<input type="text" name="deliveryFirstname" value="{$user -> ShippingFirstname}" id="deliveryFirstname" class="form-input" placeholder="{$Text.FIRSTNAME}" disabled required>
										</fieldset>

										<fieldset class="form-group m-useredit-del-lastname">
											<label class="form-label" for="m-useredit-del-lastname">{$Text.LASTNAME} <span class="form-required">*</span></label>
											<input type="text" name="deliveryLastname" value="{$user -> ShippingLastname}" id="deliveryLastname" class="form-input" placeholder="{$Text.LASTNAME}" disabled required>
										</fieldset>

										{if $settings.shop_customer_company}
										<fieldset class="form-group m-useredit-del-company">
											<label class="form-label" for="m-useredit-del-company">{$Text.COMPANY} {$Text.USER_ONLY_FOR_COMPANIES}</label>
											<input type="text" name="deliveryCompany" value="{$user -> ShippingCompany}" id="deliveryCompany" class="form-input" placeholder="{$Text.COMPANY}">
										</fieldset>
										{/if}

										<fieldset class="form-group m-useredit-del-address">
											<label class="form-label" for="m-useredit-del-address">{$Text.ADDRESS} <span class="form-required">*</span></label>
											<input type="text" name="deliveryAddress" value="{$user -> ShippingAddress}" id="deliveryAddress" class="form-input" placeholder="{$Text.ADDRESS}" disabled required>
										</fieldset>

										{if $settings.shop_customer_address2}
										<fieldset class="form-group m-useredit-del-address2">
											<label class="form-label" for="m-useredit-del-address2">{$Text.ADDRESS2}</label>
											<input type="text" name="deliveryAddress2" value="{$user -> ShippingAddress2}" id="deliveryAddress2" class="form-input" placeholder="{$Text.ADDRESS2}" disabled>
										</fieldset>
										{/if}

										<fieldset class="form-group m-useredit-del-zipcode">
											<label class="form-label" for="m-useredit-del-zipcode">{$Text.POSTCODE} <span class="form-required">*</span></label>
											<input type="text" name="deliveryZipcode" value="{$user -> ShippingZipcode}" id="deliveryZipcode" placeholder="{$Text.POSTCODE}" autocomplete="off" class="form-input" disabled required>
										</fieldset>

										<fieldset class="form-group m-useredit-del-city">
											<label class="form-label" for="m-useredit-del-city">{$Text.CITY} <span class="form-required">*</span></label>
											<input type="text" name="deliveryCity" value="{$user -> ShippingCity}" id="deliveryCity" class="form-input" placeholder="{$Text.CITY}" disabled required>
										</fieldset>

										{if $deliveryCountries->getActualSize() gt 1}
						                    <fieldset class="form-group m-useredit-del-country">
						                          <label class="form-label" for="m-useredit-del-country">{$text.COUNTRY} <span class="form-required">*</span></label>
						                      <select id="m-useredit-del-country" class="form-input form-select small" name="deliveryCountry">
						                        {foreach $deliveryCountries->getData() as $country}
						                          <option data-has-states="{count($country->CountryStates)}" value="{$country->Iso}" {if $user->ShippingCountry == $country->Iso}selected{/if}>{$country->Title}</option>
						                        {/foreach}
						                      </select>
						                    </fieldset>
						                {else}
						                    {foreach $deliveryCountries->getData() as $country}
						                      <input id="m-useredit-del-country" type="hidden" name="deliveryCountry" value="{$general.deliveryCountryIso}" data-has-states="{count($country->CountryStates)}">
						                    {/foreach}
						                {/if}
						                <input type="hidden" name="deliveryState" value="">
					                    {foreach $deliveryCountries->getData() as $country}
					                      {if count($country->CountryStates) gt 0}
					                        <fieldset id="cuStateWrapper" class="form-group del-state-group del-state-group-{$country->Iso} {if $user->ShippingCountry != $country->Iso}is-hidden{/if}">
					                          <label class="form-label" for="m-useredit-del-state">{$text.STATE} <span class="form-required">*</span></label>
					                          <select id="m-useredit-del-state-{$country->Iso}" class="m-useredit-del-state del-state-select form-input form-select small" name="deliveryState" disabled>
					                            {foreach $country->CountryStates as $state}
					                              <option value="{$state}" {if $user->ShippingState == $state}selected{/if}>{$state}</option>
					                            {/foreach}
					                          </select>
					                        </fieldset>
					                      {/if}
						                {/foreach}

										<input class="countryCode" type="hidden" name="deliveryCountryCode" value="{$phonecode}">

										{if $settings.shop_customer_phone}
										<fieldset class="form-group m-useredit-del-phone">
								        	<label class="form-label" for="m-useredit-del-phone">{$text.TELEPHONE} {if $settings.shop_customer_phone_validation}<span class="form-required">*</span>{/if}</label>
										    <div class="input-group small">
										        <span class="input-group-addon countryCode">+{$phonecode}</span>
										        <input id="m-useredit-del-phone" name="deliveryPhone" type="text" class="form-input input-group-main" placeholder="{$text.TELEPHONE}" value="{$user->ShippingPhone}">
										    </div>
										</fieldset>
										{/if}

										{if $settings.shop_customer_mobile}
										<fieldset class="form-group m-useredit-del-mobilephone">
								        	<label class="form-label" for="m-useredit-del-mobilephone">{$text.MOBILE} {if $settings.shop_customer_mobile_validation}<span class="form-required">*</span>{/if}</label>
										    <div class="input-group small">
										        <span class="input-group-addon countryCode">+{$phonecode}</span>
												<input id="m-useredit-del-mobilephone" name="deliveryMobile" type="text" class="form-input input-group-main small" placeholder="{$text.MOBILE}" value="{$user->ShippingMobile}">
											</div>
										</fieldset>
										{/if}

		      						</div>
	    						{/if}
		      					</div>
    						<p>
			                  <fieldset class="form-group m-useredit-email">
			                      <label class="form-label" for="m-useredit-email">{$text.MAIL} <span class="form-required">*</span></label>
			                  {$user->Email} (<a href="/{$text.USER_UPDATE_EMAIL_LINK}/" title="{$text.EDIT}">{$text.EDIT}</a>)
			                  </fieldset>

			                    <fieldset class="form-group m-useredit-password">
			                        <label class="form-label" for="m-useredit-password">{$text.PASSWORD} <span class="form-required">*</span></label>
			                    ******** (<a href="/{$text.USER_UPDATE_PASSWORD_LINK}/" title="{$text.EDIT}">{$text.EDIT}</a>)
			                  </fieldset>
			                  {if $settings.news_signup}
			                    <div class="m-useredit-newsletter">
			    					{include file="modules/widgets/newsletter/type.tpl" description=true}
			    				</div>
			                  {/if}
		                	</p>
						</div>
					</div>
					{if $settings.privacy_policy_user}
					<div class="row">
						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
		    				<div class="m-useredit-consent">
		    					{include file="modules/widgets/consent/consent.tpl"}
		    				</div>
		    			</div>
					</div>
					{/if}
    			</div>
    			<div class="panel-footer">
    				<button name="submit" type="submit" class="button small">{$text.SAVE}</button>
    			</div>
			</div>
		</form>
	</article>
</div>


<div data-userdelete="panel" class="modules m-userremove is-hidden">
	<article class="m-userremove-article">
		<form id="m-userremove" method="post" action="/actions/user/remove">
			{csrf type="input"}
			<div class="panel panel-border">
    			<div class="panel-body">
					<header class="m-userremove-header">
						<h5 class="m-userremove-headline">{$text.USER_DELETE_FORM_TITLE}</h5>
					</header>

	    			<div data-userdelete="confirm" class="m-userremove__text-wrap m-userremove__text-wrap--confirmation trailing-db is-hidden panel-body panel-warning clearfix">
	    				<span class="h5 m-userremove__text--confirmation">{$text.USER_DELETE_FORM_CONFIRM_TEXT}</span>
	    				<button class="button small button-warning pull-right" data-userdelete="cancel"><i class="fa fa-close"></i></button>
	    			</div>

	    			<div data-userdelete="description" class="m-userremove__text-wrap m-userremove__text-wrap--description trailing-db">
	    				<span class="m-userremove__text--description">{$text.USER_DELETE_FORM_TEXT}</span>
	    				<div class="m-userremove-description-bottom description trailing">
	    					<p class="m-userremove-description-bottom consent-description">{if $general.isShop}{$text.ACCOUNT_CONSENT_DELETE_SHOP}{else}{$text.ACCOUNT_CONSENT_DELETE_CMS}{/if}</p>
	    				</div>
	    			</div>

					<button data-userdelete="button" name="submit" type="button" class="button small">{$text.DELETE}</button>
    			</div>
    		</div>
    	</form>
	</article>
</div>
