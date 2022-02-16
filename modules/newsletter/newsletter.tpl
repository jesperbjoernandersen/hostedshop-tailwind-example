{*

# Description
Controller for the Newsletter page type


## Date last modified
2020-08-28


## Primary variables
+ $interestFields 														- Fields of interest (like new products, products on sale ...)
+ $text                                                     			- Global scope variable containing translations
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/widgets/recaptcha/recaptcha.tpl"                			- Recaptcha widget, for blog comments
+ "/modules/widgets/meta/meta.tpl"                          			- SEO meta and link data
+ "/modules/widgets/meta/opengraph.tpl"                     			- Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = $text.NEWSLETTER_TEXT_SUBSCRIBE}
{$opengraph_description = $text.NEWSLETTER_TYPE_HEADLINE}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}

{* Fetch interest fields *}
{collection controller=interestField assign=interestFields categoryId=3}

<div class="modules m-newsletter">
	<article class="m-newsletter-article">
		<header class="m-newsletter-header page-title">
			<h1 class="m-newsletter-headline">{if isset($smarty.get.unsubscribe)}{$text.NEWSLETTER_HEADLINE_UNSUBSCRIBE}{else}{$text.NEWSLETTER_TYPE_HEADLINE}{/if}</h1>
		</header>

		<div class="m-newsletter-description description trailing">
			<p class="m-newsletter-description">{if isset($smarty.get.unsubscribe)}{$text.NEWSLETTER_TEXT_UNSUBSCRIBE}{else}{$text.NEWSLETTER_TEXT_SUBSCRIBE}{/if}</p>
		</div>
		<form id="m-newsletter" method="post" action="/actions/newsletter/regmail">
			{csrf type="input"}
			{if isset($smarty.get.unsubscribe)}
				<input type="hidden" name="type" value="0">
			{else}
				<input type="hidden" name="type" value="1">
			{/if}
			<div class="panel panel-border">
    			<div class="panel-body">

					<fieldset class="form-group m-newsletter-name">
			        	<label class="form-label" for="m-newsletter-name">{$text.NAME} <span class="form-required">*</span></label>
						<input id="m-newsletter-name" name="name" type="text" class="form-input small" placeholder="{$text.NAME}" {if $returnPostData.name}value="{$returnPostData.name}"{/if} required>
					</fieldset>

					{if $settings.news_signup_type == 'email' || $settings.news_signup_type == 'both'}
					<fieldset class="form-group m-newsletter-email">
			        	<label class="form-label" for="m-newsletter-email">{$text.MAIL} <span class="form-required">*</span></label>
						<input id="m-newsletter-email" name="email" type="text" class="form-input small" placeholder="{$text.MAIL}" {if $returnPostData.email}value="{$returnPostData.email}"{/if} required>
					</fieldset>
					{/if}

					{if $settings.news_signup_type == 'sms' || $settings.news_signup_type == 'both'}
					<fieldset class="form-group m-newsletter-mobile">
			        	<label class="form-label" for="m-newsletter-mobile">{$text.MOBILE} <span class="form-required">*</span></label>
						<input id="m-newsletter-mobile" name="mobile" type="text" class="form-input small" placeholder="{$text.MOBILE}" {if $returnPostData.mobile}value="{$returnPostData.mobile}"{/if} required>
					</fieldset>
					{/if}

					{if $interestFields->getActualSize() gt 0 && !isset($smarty.get.unsubscribe)}
					<fieldset id="m-newsletter-newsletterfields" class="form-group">
						<label class="form-label" for="m-newsletter-newsletterfields">{$text.USER_NEWSLETTER_CHOOSE_INTEREST_GROUPS}</label>
						<ul class="list-unstyled list-inline m-newsletter-newsletterfields-interestgroups">
						{foreach $interestFields->getData() as $interestField}
							<li>
								<label class="m-newsletter-newsletterfields{$interestField->Id} form-label" for="m-newsletter-newsletterfields{$interestField->Id}">
									<input id="m-newsletter-newsletterfields[{$interestField->Id}]" name="interestGroups[{$interestField->Id}]" type="checkbox"
									{if isset($returnPostData.interestGroups) and isset($returnPostData.interestGroups[$interestField->Id])} checked="true"{/if}>
									<span class="m-newsletter-newsletterfields-label">{$interestField->Title}</span>
								</label>
							</li>
						{/foreach}
						</ul>
					</fieldset>
					{/if}

					{if $settings.spam_check}
					<div class="m-newsletter-spam-check">
						<hr>
						{include file="modules/widgets/recaptcha/recaptcha.tpl"}
    				</div>
    				{/if}

    				{if $settings.privacy_policy_newsletter && !isset($smarty.get.unsubscribe)}
					<div class="m-newsletter-consent">
						<div class="row">
    						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
					  			{include file="modules/widgets/consent/consent.tpl"}
					  		</div>
					  	</div>
					</div>
					{/if}

    			</div>
    			<div class="panel-footer">
    				<button name="submit" type="submit" class="button small is-inline-block">{if isset($smarty.get.unsubscribe)}{$text.NEWSLETTER_SIGNOFF}{else}{$text.NEWSLETTER_SIGNIN}{/if}</button>
    				{if isset($smarty.get.unsubscribe)}
    					<a href="{$general.domain}/{$text.NEWLSLETTER_LINK}" class="button button-text small pull-right">{$text.NEWSLETTER_SIGNIN}</a>
    				{else}
    					<a href="{$general.domain}/{$text.NEWLSLETTER_LINK}/?unsubscribe" class="button button-text small pull-right">{$text.NEWSLETTER_SIGNOFF}</a>
    				{/if}
    			</div>
			</div>

		</form>


		<div class="m-newsletter-description-bottom description trailing">
			<p class="m-newsletter-description-bottom consent-description">
			{if isset($smarty.get.unsubscribe)}
				{if $general.isShop}{$text.NEWSLETTER_TYPE_DESCRIPTION_UNSUBSCRIBE_SHOP}{else}{$text.NEWSLETTER_TYPE_DESCRIPTION_UNSUBSCRIBE_CMS}{/if}
			{else}
				{if $general.isShop}{$text.NEWSLETTER_TYPE_DESCRIPTION_SHOP}{else}{$text.NEWSLETTER_TYPE_DESCRIPTION_CMS}{/if}
			{/if}
			</p>
		</div>

	</article>
</div>


{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
