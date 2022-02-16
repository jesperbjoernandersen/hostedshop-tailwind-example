{*

# Description
Controller and template for the "Send to a friend" page type.


# Date last modified
2020-08-14


## Primary variables
+ $pageSize                                                             - Number of search items pr page
+ $searchResults                                                        - Collection of pageController (list of search results)

+ $page                                                     			- Global scope variable containing page type information
+ $text                                                                 - Global scope variable containing translations
+ $user                                                                 - Global scope variable containing user data
+ $columns                                                              - Global scope variable containing columns
+ $boxes                                                                - Global scope variable containing column boxes


## Partials (templates)
+ "/modules/widgets/recaptcha/recaptcha.tpl"                			- Recaptcha widget, for blog comments
+ "/modules/widgets/meta/opengraph.tpl"                     			- Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = $text.SEND_TO_A_FRIEND_HEADLINE}
{$opengraph_description = $text.SEND_TO_A_FRIEND_TEXT}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}

{* Generate submit link *}
{if $smarty.get.link}
	{$submitLink = "/{$smarty.get.link|ltrim:'/'|htmlspecialchars}"}
{else}
	{$submitLink = "/"}
{/if}

<div class="modules m-sendtoafriend">
	<article class="m-sendtoafriend-article">
		<header class="m-sendtoafriend-header page-title">
			<h1 class="m-sendtoafriend-headline">{$text.SEND_TO_A_FRIEND_HEADLINE}</h1>
		</header>

		<form id="m-sendtoafriend" method="post" action="/actions/sendtoafriend/send">
			{csrf type="input"}
			<input type="hidden" name="link" value="{$submitLink}">

		    <div class="panel panel-border">
		        <div class="panel-body">
					<div class="m-sendtoafriend-description description trailing">
						<p class="m-sendtoafriend-text">
							{$text.SEND_TO_A_FRIEND_TEXT}
						</p>
						<p class="m-sendtoafriend-link">
							{$text.LINK}: <a href="{$submitLink}" target="_blank" rel="noopener">{$general.domain}{$submitLink}</a>
						</p>
						<p class="m-sendtoafriend-fields_required">
							{$text.USER_ADD_REQUIRED_FIELDS}
						</p>
					</div>
					<div class="row">
						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

    						<fieldset class="form-group m-sendtoafriend-name">
					        	<label class="form-label" for="m-sendtoafriend-name">{$text.SEND_TO_A_FRIEND_NAME_YOURS} <span class="form-required">*</span></label>
								<input id="m-sendtoafriend-name" name="name" type="text" class="form-input small" placeholder="{$text.SEND_TO_A_FRIEND_NAME_YOURS}" required>
							</fieldset>

						</div>
						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

    						<fieldset class="form-group m-sendtoafriend-nameto">
					        	<label class="form-label" for="m-sendtoafriend-nameto">{$text.SEND_TO_A_FRIEND_NAME_FRIEND} <span class="form-required">*</span></label>
								<input id="m-sendtoafriend-nameto" name="nameTo" type="text" class="form-input small" placeholder="{$text.SEND_TO_A_FRIEND_NAME_FRIEND}" required>
							</fieldset>

    						<fieldset class="form-group m-sendtoafriend-email">
					        	<label class="form-label" for="m-sendtoafriend-email">{$text.SEND_TO_A_FRIEND_MAIL_FRIEND} <span class="form-required">*</span></label>
								<input id="m-sendtoafriend-email" name="email" type="email" class="form-input small" placeholder="{$text.SEND_TO_A_FRIEND_MAIL_FRIEND}" required>
							</fieldset>

    						<fieldset class="form-group m-sendtoafriend-comment">
					        	<label class="form-label" for="m-sendtoafriend-comment">{$text.SEND_TO_A_FRIEND_COMMENT}</label>
								<textarea id="m-sendtoafriend-comment" class="form-input" name="comment" style="height: 150px;" placeholder="{$text.SEND_TO_A_FRIEND_COMMENT}"></textarea>
							</fieldset>

						</div>
					</div>
					<div class="m-sendtoafriend-spam-check">
						<hr>
						{include file="modules/widgets/recaptcha/recaptcha.tpl"}
    				</div>
    				{if $settings.privacy_policy_sendtoafriend}
    				<div class="m-sendtoafriend-consent">
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

		<div class="m-sendtoafriend-description-bottom description trailing">
            <p class="m-sendtoafriend-description-bottom consent-description">{if $general.isShop}{$text.SENDTOAFRIEND_CONSENT_DESCRIPTION_SHOP}{else}{$text.SENDTOAFRIEND_CONSENT_DESCRIPTION_CMS}{/if}</p>
        </div>

	</article>
</div>


{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
