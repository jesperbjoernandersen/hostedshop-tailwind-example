{*

# Description
Controller and template for the User Login page type


## Date last modified
2021-07-12


## Primary variables
+ $deliveryCountries 													- Collection of deliveryCountryController
+ $interestFields 														- Collection of interestFieldController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $settings                                                             - Global scope variable containing platform settings
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}


{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = $text.LOGIN_HEADLINE}
{$opengraph_description = $text.LOGIN_TEXT}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}


<div class="modules m-userlogin">
	<article class="m-userlogin-article">
		<header class="m-userlogin-header page-title">
			<h1 class="m-userlogin-headline">{$text.LOGIN_HEADLINE}</h1>
		</header>

		<div class="m-userlogin-description description trailing">
			<p class="m-userlogin-description">{$text.LOGIN_TEXT}</p>
		</div>
		<form id="m-userlogin" method="post" action="/actions/user/recaptchalogin" autocomplete="off">
			{csrf type="input"}
			{if isset($smarty.get.goto)}
				<input type="hidden" name="goto" value="{$smarty.get.goto}">
			{/if}
			<div class="panel panel-border">
				<div class="panel-body">
					<fieldset class="form-group m-userlogin-username">
						<label class="form-label" for="m-userlogin-username">{$text.LOGIN_USER} <span class="form-required">*</span></label>
						<div class="input-group small">
							<span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="user"}</span>
							<input id="m-userlogin-username" name="username" type="text" class="form-input small input-group-main" placeholder="{$text.LOGIN_USER}" required>
						</div>
					</fieldset>
					<fieldset class="form-group m-userlogin-password">
						<label class="form-label" for="m-userlogin-password">{$text.LOGIN_PASSWORD} <span class="form-required">*</span></label>
						<div class="input-group small">
							<span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="lock"}</span>
							<input id="m-userlogin-password" name="password" type="password" class="form-input small input-group-main" placeholder="{$text.LOGIN_PASSWORD}" required>
						</div>
					</fieldset>
					<fieldset class="form-group m-userlogin-remember">
						<div class="input-group small">
							<span class="input-group-addon"><input id="m-userlogin-remember" name="auto_login" type="checkbox"></span>
							<label for="m-userlogin-remember" class="form-label input-group-main">{$text.USER_REMEMBER_LOGIN}</label>
						</div>
					</fieldset>
					<ul class="m-userlogin-links m-links list-unstyled">
						{if $settings.user_password_resend}
							<li class="m-userlogin-item m-links-userpasswordrecover"><a href="/{$text.SEND_PASSWORD_LINK}/" title="{$text.SEND_PASSWORD_QUESTION}">{$text.SEND_PASSWORD_QUESTION}</a></li>
						{/if}
						{if $access.user && $settings.user_add}
							<li class="m-userlogin-item m-links-usercreate"><a href="/{$text.USER_ADD_LINK}/" title="{$text.USER_ADD_MENU}">{$text.USER_ADD_MENU}</a></li>
						{/if}
						{if $settings.shop_b2b_customer_approval}
							<li class="m-userlogin-item m-links-userrequest"><a href="/{$text.USER_ADD_B2B_LINK}/" title="{$text.USER_ADD_B2B_MENU}">{$text.USER_ADD_B2B_MENU}</a></li>
						{/if}
					</ul>
					{if $settings.spam_check}
					<div class="m-userlogin-spam-check">
						<hr>
						{include file="modules/widgets/recaptcha/recaptcha.tpl"}
					</div>
					{/if}
				</div>
				<div class="panel-footer">
					<button class="form-submit {if !empty($modalCallToActionStyle) AND $modalCallToActionStyle eq "primary"}button-primary{else}button{/if} small" type="submit">{$text.LOGIN_MENU}</button>
				</div>
			</div>
		</form>
	</article>
</div>


{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
	og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
