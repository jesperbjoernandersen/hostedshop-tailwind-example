{*

# Description
Template for Newsletter in a column box


## Date last modified
2018-05-09


## Primary variables
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{*** Check if spam check is enabled ***}
{$displaySpamCheck = $settings.spam_check}

<div class="panel panel-border column-box b-newsletter" data-js="w-newsletter-signup">
	<form id="b-newsletter-assign" method="post" action="/actions/newsletter/regmail">
		{csrf type="input"}
		{if !$displaySpamCheck}
        <input type="hidden" name="form" value="quick">
        {/if}
        <input type="hidden" name="type" value="1">

	    <div class="panel-heading b-newsletter-assign-header b-header">
	        <span class="h5">{$text.NEWLSLETTER_MENU}</span>
	    </div>
	    <div class="panel-body">
				<fieldset class="form-group b-newsletter-username">
					<input name="name" type="text" class="form-input small" placeholder="{$text.NAME}" required>
				</fieldset>

				{if $settings.news_signup_type == 'email' || $settings.news_signup_type == 'both'}
				<fieldset class="form-group b-newsletter-email">
					<input name="email" type="text" class="form-input small" placeholder="{$text.MAIL}" required>
				</fieldset>
				{/if}

				{if $settings.news_signup_type == 'sms' || $settings.news_signup_type == 'both'}
				<fieldset class="form-group b-newsletter-mobile">
					<input name="mobile" type="text" class="form-input small" placeholder="{$text.MOBILE}" required>
				</fieldset>
				{/if}

				<div class="b-newsletter-newsletter">
	    		{include file="modules/widgets/newsletter/type.tpl"}
	    	</div>

			{if $displaySpamCheck}
				<div class="m-newsletter-spam-check" data-js="m-newsletter-spam-check">
					<hr>
					{include file="modules/widgets/recaptcha/recaptcha.tpl" lazyload=true}
				</div>
				{/if}

				{if $settings.privacy_policy_newsletter}
				<div class="b-newsletter-consent">
					{include file="modules/widgets/consent/consent.tpl" box=true}
				</div>
			{/if}

	    </div>
	    <div class="panel-footer">
	        <button class="form-submit button small" type="submit">{$text.CONFIRM}</button>
	    </div>
    </form>
</div>
