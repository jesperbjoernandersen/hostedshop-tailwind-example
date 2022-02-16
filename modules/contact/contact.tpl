{*

# Description
Controller for the Contact Page page type.


## Date last modified
2021-08-24


## Primary variables
+ $controller 															- Instance of contactController
+ $contactPage 															- Entity of contactController (the contactPage)
+ $text                                                     			- Global scope variable containing translations
+ $page 																- Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/widgets/recaptcha/recaptcha.tpl"							- Recaptcha widget, for displaying a google recaptcha element
+ "/modules/widgets/meta/opengraph.tpl"                     			- Social meta data

*}


{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{controller type=contact assign=controller}

{* Fetch settings for Contact page *}
{entity controller=$controller assign=contactPage}

{* Fetch translation for Contact page *}
{$contactPageData = $controller->getMeta($contactPage->PageId)}

<div class="modules m-contact" itemscope itemtype="http://schema.org/ContactPage">
	<article class="m-contact-article">
		<header class="m-contact-header page-title">
			<h1 class="m-contact-headline" itemprop="headline">{$page.headline}</h1>
		</header>

		<div class="m-contact-description description ck-content trailing" itemprop="description">
			{$contactPageData.text}
		</div>
		<form id="m-contact" method="post" action="/actions/contact/send">
			{csrf type="input"}
		    <div class="panel panel-border">
		        <div class="panel-body">
					<div class="row">
						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

							<fieldset class="form-group m-contact-company">
					        	<label class="form-label" for="m-contact-company">{$text.COMPANY}</label>
								<input id="m-contact-company" name="company" type="text" class="form-input small" placeholder="{$text.COMPANY}" {if $returnPostData.company}value="{$returnPostData.company}"{/if}>
							</fieldset>

							<fieldset class="form-group m-contact-name">
					        	<label class="form-label" for="m-contact-name">{$text.NAME} <span class="form-required">*</span></label>
								<input id="m-contact-name" name="name" type="text" class="form-input small" placeholder="{$text.NAME}" {if $returnPostData.name}value="{$returnPostData.name}"{/if} required>
							</fieldset>

							<fieldset class="form-group m-contact-address">
					        	<label class="form-label" for="m-contact-address">{$text.ADRESS}</label>
								<input id="m-contact-address" name="address" type="text" class="form-input small" placeholder="{$text.ADRESS}" {if $returnPostData.address}value="{$returnPostData.address}"{/if}>
							</fieldset>

							<fieldset class="form-group m-contact-zipcode">
					        	<label class="form-label" for="m-contact-zipcode">{$text.POSTCODE}</label>
								<input id="m-contact-zipcode" name="zipcode" type="text" class="form-input small" placeholder="{$text.POSTCODE}" {if $returnPostData.zipcode}value="{$returnPostData.zipcode}"{/if}>
							</fieldset>

							<fieldset class="form-group m-contact-city">
					        	<label class="form-label" for="m-contact-city">{$text.CITY}</label>
								<input id="m-contact-city" name="city" type="text" class="form-input small" placeholder="{$text.CITY}" {if $returnPostData.city}value="{$returnPostData.city}"{/if}>
							</fieldset>

							<fieldset class="form-group m-contact-country">
					    		<label class="form-label" for="m-contact-country">{$Text.COUNTRY} <span class="form-required">*</span></label>
								<input id="m-contact-country" name="country" type="text" class="form-input small" placeholder="{$text.COUNTRY}" {if $returnPostData.country}value="{$returnPostData.country}"{/if}>
							</fieldset>

							<fieldset class="form-group m-contact-phone">
					        	<label class="form-label" for="m-contact-phone">{$text.TELEPHONE} <span class="form-required">*</span></label>
							    <div class="input-group small">
							        <span class="input-group-addon"><i class="fa fa-fw fa-home"></i></span>
							        <input id="m-contact-phone" name="phone" type="text" class="form-input input-group-main" placeholder="{$text.TELEPHONE}" {if $returnPostData.phone}value="{$returnPostData.phone}"{/if} required>
							    </div>
							</fieldset>

							<fieldset class="form-group m-contact-email">
					        	<label class="form-label" for="m-contact-email">{$text.MAIL} <span class="form-required">*</span></label>
								<input id="m-contact-email" name="email" type="email" class="form-input small" placeholder="{$text.MAIL}" {if $returnPostData.email}value="{$returnPostData.email}"{/if} required>
							</fieldset>

						</div>
						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

							<fieldset class="form-group m-contact-subject">
					        	<label class="form-label" for="m-contact-subject">{$text.SUBJECT} <span class="form-required">*</span></label>
								<input id="m-contact-subject" name="subject" type="text" class="form-input small" placeholder="{$text.SUBJECT}" {if $returnPostData.subject}value="{$returnPostData.subject}"{/if} required>
							</fieldset>

							{if $contactPageData.dropdown|@count > 0}
								<fieldset class="form-group m-contact-where">
									<label class="form-label" for="m-contact-where">{$text.CONTACTFORM_WHERE_FIND_US} <span class="form-required">*</span></label>
										
									<select id="m-contact-where" name="where" class="form-input form-select small">
										<option value="">{$text.CHOOSE}</option>
										{foreach $contactPageData.dropdown as $option}
											<option value="{$option}" {if $returnPostData.where == $option}selected{/if}>{$option}</option>
										{/foreach}
									</select>
								</fieldset>
							{/if}

							<fieldset class="form-group m-contact-message">
								<label class="form-label" for="m-contact-message">{$text.MESSAGE} <span class="form-required">*</span></label>
								<textarea id="m-contact-message" name="message" class="form-input" style="height: 150px;" required>{if $returnPostData.message}{$returnPostData.message}{/if}</textarea>
							</fieldset>

							<div class="m-contact-data data-one">
								{if $contactPage->DisplayTitle}
									<div class="m-contact-data-name"><strong>{$contactdata.name}</strong></div>
								{/if}

								{if $contactPage->DisplayAddress}
									<div class="m-contact-data-address">{$contactdata.address}</div>
								{/if}

								{if $contactPage->DisplayZipcode || $contactPage->DisplayCity}
									<div class="m-contact-data-city">{$contactdata.zipcode} {$contactdata.city}</div>
								{/if}

								{if $contactPage->DisplayCountry}
									<div class="m-contact-data-country">{$contactdata.country}</div>
								{/if}
							</div>
							<div class="m-contact-data data-two">
								{if $contactPage->DisplayContactPerson}
									<div class="m-contact-data-contactperson">{$text.CONTACT_PERSON}: {$contactdata.contactperson}</div>
								{/if}

								{if $contactPage->DisplayPhone}
									<div class="m-contact-data-phone">{$text.TELEPHONE}: {$contactdata.phone}</div>
								{/if}

								{if $contactPage->DisplayMobile}
									<div class="m-contact-data-mobile">{$text.MOBILE}: {$contactdata.mobilephone}</div>
								{/if}

								{if $contactPage->DisplayFax}
									<div class="m-contact-data-fax">{$text.FAX}: {$contactdata.fax}</div>
								{/if}

								{if $contactPage->DisplayEmail}
									{if $settings.spam_email_block}
										{$email = $contactdata.email|replace:'@':'---'}
										{placeholdImage assign=placeholder text=$email color=$template.settings.FONT_COLOR_PRIMARY atreplace='---' transparent=true size=10}
									   	<a href="/obfuscated/" onclick="var m = '{$email}'; this.href = 'mailto:' + m.replace('---', '@'); return true;">
									   		<span>
													{img style="margin:0; vertical-align: middle;" alt="" src="{$placeholder->getRelativeFile()}"}
									      </span>
									   	</a>
									{else}
									   	<div class="m-contact-data-email">{$text.MAIL}: <a href="mailto:{$contactdata.email}">{$contactdata.email}</a></div>
									{/if}
								{/if}

								{if $contactPage->DisplayTaxnumber}
									<div class="m-contact-data-vatnumber">{$text.VAT_NR}: {$contactdata.vatnumber}</div>
								{/if}

								{if $contactPage->DisplayBankinfo}
									<div class="m-contact-data-bankinfo">{$text.BANK_DETAILS}: {$contactdata.bankinfo}</div>
								{/if}

								{if $contactPage->DisplayWebsite}
									<div class="m-contact-data-domain">{$text.WEB}: <a href="{$contactdata.url}">{$contactdata.displayUrl}</a></div>
								{/if}
							</div>

						</div>
					</div>
					{if $settings.spam_check}
					<div class="m-contact-spam-check">
						<hr>
						{include file="modules/widgets/recaptcha/recaptcha.tpl"}
    				</div>
    				{/if}

    				{if $settings.privacy_policy_contact}
    				<div class="m-contact-consent">
    					<div class="row">
    						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
    							{include file="modules/widgets/consent/consent.tpl"}
    						</div>
    					</div>
    				</div>
    				{/if}

				</div>
		        <div class="panel-footer">
		            <button class="form-submit {if !empty($modalCallToActionStyle) AND $modalCallToActionStyle eq "primary"}button-primary{else}button{/if} small" type="submit">{$text.SEND}</button>
		        </div>
			</div>
		</form>

		<div class="m-contact-description-bottom description trailing">
			<p class="m-contact-description-bottom consent-description">{if $general.isShop}{$text.CONTACT_CONSENT_DESCRIPTION_SHOP}{else}{$text.CONTACT_CONSENT_DESCRIPTION_CMS}{/if}</p>
		</div>

	</article>
</div>

{*** Open Graph ***}
{$opengraph_title = $page.title}
{$opengraph_description = {translation module=seo_page title=description id=$page.id}}

{if empty($opengraph_description)}
		{$opengraph_description = $contactPageData.text|strip_tags}
{/if}

{$opengraph_description = $opengraph_description|truncate:160}

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
