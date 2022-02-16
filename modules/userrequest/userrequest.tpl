{*

# Description
Controller and template for the User Create page type.


## Date last modified
2021-08-05


## Primary variables
+ $deliveryCountries 													- Collection of deliveryCountryController
+ $interestFields 														- Collection of interestFieldController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $settings                                                             - Global scope variable containing platform settings
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/recaptcha/recaptcha.tpl"                            - Recaptcha widget, for blog comments
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}


{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = $text.USER_ADD_B2B_HEADLINE}
{$opengraph_description = $text.USER_ADD_B2B_TEXT}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}

{* Fetch delivery countrys *}
{collection controller=deliveryCountry assign=deliveryCountries access=true}

{* Fetch interest fields *}
{collection controller=interestField assign=interestFields categoryId=4}

{* Phone code *}
{$phonecode = $general.deliveryCountryCode}

{if isset($returnPostData['countryCode'])}
	{$phonecode = $returnPostData['countryCode']}
{/if}

<div class="modules m-userrequest">
	<article class="m-userrequest-article">
		<header class="m-userrequest-header page-title">
			<h1 class="m-userrequest-headline">{$text.USER_ADD_B2B_HEADLINE}</h1>
		</header>

		<div class="m-userrequest-description description trailing">
			<p class="m-userrequest-description">{$text.USER_ADD_B2B_TEXT} {$text.USER_ADD_REQUIRED_FIELDS}</p>
		</div>

		<form id="m-userrequest" method="post" action="/actions/user/addb2b">
			{csrf type="input"}
			<div class="panel panel-border">
    			<div class="panel-body">
    				<div class="row">
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

							{* Customer type toggle and dynamic company related inputs *}
							{include
								file="modules/widgets/customertypeinput/customertypeinput.tpl"
								showPrivateOption=false
								requireCompanyFields=true
								inputFieldPrefix="m-userrequest"
								companyName=$returnPostData.company
								vatNumber=$returnPostData.vatNumber
								eanNumber=$returnPostData.eanNumber
							}

    						<fieldset class="form-group m-userrequest-firstname">
					        	<label class="form-label" for="m-userrequest-firstname">{$text.FIRSTNAME} <span class="form-required">*</span></label>
								<input id="m-userrequest-firstname" name="firstname" type="text" class="form-input small" placeholder="{$text.FIRSTNAME}" {if $returnPostData.firstname}value="{$returnPostData.firstname}"{/if} required>
							</fieldset>

							<fieldset class="form-group m-userrequest-lastname">
					        	<label class="form-label" for="m-userrequest-lastname">{$text.LASTNAME} <span class="form-required">*</span></label>
								<input id="m-userrequest-lastname" name="lastname" type="text" class="form-input small" placeholder="{$text.LASTNAME}" {if $returnPostData.lastname}value="{$returnPostData.lastname}"{/if} required>
							</fieldset>

							{if $settings.shop_customer_birthdate}
							<fieldset class="form-group m-userrequest-birthday">
					        	<label class="form-label" for="m-userrequest-birthday">{$text.BIRTHDATE}</label>
					        	<div class="input-group small">
									<span class="input-group-addon"><i class="fa fa-fw fa-calendar"></i></span>
									<input id="m-userrequest-birthday" name="birthday" type="date" class="form-input small" {if $returnPostData.birth}value="{$returnPostData.birthday}"{/if}>
								</div>
							</fieldset>
							{/if}

							<fieldset class="form-group m-userrequest-address">
					        	<label class="form-label" for="m-userrequest-address">{$text.ADDRESS} <span class="form-required">*</span></label>
								<input id="m-userrequest-address" name="address" type="text" class="form-input small" placeholder="{$text.ADDRESS}" {if $returnPostData.address}value="{$returnPostData.address}"{/if} required>
							</fieldset>

							{if $settings.shop_customer_address2}
							<fieldset class="form-group m-userrequest-address2">
					        	<label class="form-label" for="m-userrequest-address2">{$text.ADDRESS2}</label>
								<input id="m-userrequest-address2" name="address2" type="text" class="form-input small" placeholder="{$text.ADDRESS2}" {if $returnPostData.address2}value="{$returnPostData.address2}"{/if}>
							</fieldset>
							{/if}

							<fieldset class="form-group m-userrequest-zipcode">
					        	<label class="form-label" for="m-userrequest-zipcode">{$text.POSTCODE} <span class="form-required">*</span></label>
								<input id="m-userrequest-zipcode" name="zipcode" type="text" class="form-input small" placeholder="{$text.POSTCODE}" {if $returnPostData.zipcode}value="{$returnPostData.zipcode}"{/if} required>
							</fieldset>

							<fieldset class="form-group m-userrequest-city">
					        	<label class="form-label" for="m-userrequest-city">{$text.CITY} <span class="form-required">*</span></label>
								<input id="m-userrequest-city" name="city" type="text" class="form-input small" placeholder="{$text.CITY}" {if $returnPostData.city}value="{$returnPostData.city}"{/if} required>
							</fieldset>

							{if $deliveryCountries->getActualSize() gt 1}
								<fieldset class="form-group m-userrequest-country">
					        		<label class="form-label" for="m-userrequest-country">{$text.COUNTRY} <span class="form-required">*</span></label>
									<select id="m-userrequest-country" class="form-input form-select small" name="country">
										{foreach $deliveryCountries->getData() as $country}
											<option data-has-states="{count($country->CountryStates)}" value="{$country->Iso}" {if $returnPostData.country == $country->Iso}selected{elseif $general.deliveryCountryIso == $country->Iso && !isset($returnPostData.country)}selected{/if}>{$country->Title}</option>
										{/foreach}
									</select>
								</fieldset>
							{else}
								{foreach $deliveryCountries->getData() as $country}
									<input id="m-userrequest-country" type="hidden" name="country" value="{$general.deliveryCountryIso}" data-has-states="{count($country->CountryStates)}">
								{/foreach}
							{/if}

							<input type="hidden" name="state" value="">
							{foreach $deliveryCountries->getData() as $country}
								{if count($country->CountryStates) gt 0}
									<fieldset id="cuStateWrapper" class="form-group state-group state-group-{$country->Iso} {if (isset($returnPostData.country) and $returnPostData.country != $country->Iso) or $general.deliveryCountryIso != $country->Iso}is-hidden{/if}">
						        		<label class="form-label" for="m-userrequest-state">{$text.STATE} <span class="form-required">*</span></label>
										<select id="m-userrequest-state-{$country->Iso}" class="m-userrequest-state state-select form-input form-select small" name="state" disabled>
											{foreach $country->CountryStates as $state}
												<option value="{$state}" {if $returnPostData.state == $state}selected{/if}>{$state}</option>
											{/foreach}
										</select>
									</fieldset>
								{/if}
							{/foreach}

							{include file="modules/widgets/customdata/customdata.tpl" entityType='customer' context='user'}

    					</div>
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

    						<fieldset class="form-group m-userrequest-email">
					        	<label class="form-label" for="m-userrequest-email">{$text.MAIL} <span class="form-required">*</span></label>
								<input id="m-userrequest-email" name="email" type="email" class="form-input small" placeholder="{$text.MAIL}" {if $returnPostData.email}value="{$returnPostData.email}"{/if} required>
							</fieldset>

							{if $settings.shop_customer_email_confirm}
								<fieldset class="form-group m-userrequest-emailconf">
									<label class="form-label" for="m-userrequest-emailconf">{$text.MAIL_CONFIRM} <span class="form-required">*</span></label>
									<input id="m-userrequest-emailconf" name="email_confirmation" type="email" class="form-input small" placeholder="{$text.MAIL_CONFIRM}" {if $returnPostData.email_confirmation}value="{$returnPostData.email_confirmation}"{/if} required>
								</fieldset>
							{/if}

							<input class="countryCode" type="hidden" name="countryCode" value="{$phonecode}">

							{if $settings.shop_customer_phone}
							<fieldset class="form-group m-userrequest-phone">
					        	<label class="form-label" for="m-userrequest-phone">{$text.TELEPHONE} {if $settings.shop_customer_phone_validation}<span class="form-required">*</span>{/if}</label>
							    <div class="input-group small">
							        <span class="input-group-addon countryCode">+{$phonecode}</span>
							        <input id="m-userrequest-phone" name="phone" type="text" class="form-input input-group-main" placeholder="{$text.TELEPHONE}" {if $returnPostData.phone}value="{$returnPostData.phone}"{/if} {if $settings.shop_customer_phone_validation}required{/if}>
							    </div>
							</fieldset>
							{/if}

							{if $settings.shop_customer_mobile}
							<fieldset class="form-group m-userrequest-mobilephone">
					        	<label class="form-label" for="m-userrequest-mobilephone">{$text.MOBILE} {if $settings.shop_customer_mobile_validation}<span class="form-required">*</span>{/if}</label>
							    <div class="input-group small">
							        <span class="input-group-addon countryCode">+{$phonecode}</span>
									<input id="m-userrequest-mobilephone" name="mobilephone" type="text" class="form-input input-group-main small" placeholder="{$text.MOBILE}" {if $returnPostData.mobilephone}value="{$returnPostData.mobilephone}"{/if} {if $settings.shop_customer_mobile_validation}required{/if}>
								</div>
							</fieldset>
							{/if}

							<fieldset class="form-group m-userrequest-password">
					        	<label class="form-label" for="m-userrequest-password">{$text.PASSWORD} <span class="form-required">*</span></label>
								<input id="m-userrequest-password" name="password" type="password" class="form-input small" placeholder="{$text.PASSWORD}" required>
							</fieldset>

							<fieldset class="form-group m-userrequest-passwordconf">
					        	<label class="form-label" for="m-userrequest-passwordconf">{$text.PASSWORD_CONFIRM} <span class="form-required">*</span></label>
								<input id="m-userrequest-passwordconf" name="passwordConfirmation" type="password" class="form-input small" placeholder="{$text.PASSWORD_CONFIRM}" required>
							</fieldset>

							{if $settings.news_signup}
							<div class="m-userrequest-newsletter">
		    					{include file="modules/widgets/newsletter/type.tpl" description=true}
		    				</div>
							{/if}

							{if $interestFields->getActualSize() gt 0}
							<fieldset id="m-userrequest-newsletterfields" class="form-group {if !isset($returnPostData.newsletter) or !$returnPostData.newsletter}is-hidden{/if}">
								<label class="form-label" for="m-userrequest-newsletterfields">{$text.USER_NEWSLETTER_CHOOSE_INTEREST_GROUPS}</label>
								<ul class="list-unstyled list-inline m-userrequest-newsletterfields-interestgroups">
								{foreach $interestFields->getData() as $interestField}
									<li>
										<label class="m-userrequest-newsletterfields{$interestField->Id} form-label" for="m-userrequest-newsletterfields{$interestField->Id}">
											<input id="m-userrequest-newsletterfields[{$interestField->Id}]" name="interestGroups[{$interestField->Id}]" type="checkbox"
											{if isset($returnPostData.interestGroups) and isset($returnPostData.interestGroups[$interestField->Id])} checked="true"{/if}>
											<span class="m-userrequest-newsletterfields-label">{$interestField->Title}</span>
										</label>
									</li>
								{/foreach}
								</ul>
							</fieldset>
							{/if}

						</div>
					</div>
					{if $settings.spam_check}
					<div class="m-userrequest-spam-check">
						<hr>
						{include file="modules/widgets/recaptcha/recaptcha.tpl"}
    				</div>
    				{/if}
    				{if $settings.privacy_policy_user}
    				<div class="m-userrequest-consent">
    					<div class="row">
    						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
    							{include file="modules/widgets/consent/consent.tpl"}
    						</div>
    					</div>
    				</div>
    				{/if}
    			</div>
    			<div class="panel-footer">
    				<button name="submit" type="submit" class="button small">{$text.CONFIRM}</button>
    			</div>
			</div>
		</form>

		<div class="m-userrequest-description-bottom description trailing">
			<p class="m-userrequest-description-bottom consent-description">{if $general.isShop}{$text.ACCOUNT_CONSENT_DESCRIPTION_SHOP}{else}{$text.ACCOUNT_CONSENT_DESCRIPTION_CMS}{/if}</p>
		</div>

	</article>
</div>

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
