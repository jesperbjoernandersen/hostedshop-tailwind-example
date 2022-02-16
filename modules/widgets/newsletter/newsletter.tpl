{*

# Description
Template for Newsletter signup in a widget


## Date last modified
2021-02-25


## Primary variables
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{*** Check if spam check is enabled ***}
{$displaySpamCheck = $settings.spam_check}

<div class="w-newsletter-signup" data-js="w-newsletter-signup">
	<form method="post" action="/actions/newsletter/regmail">
		{csrf type="input"}
		{if !$displaySpamCheck}
        <input type="hidden" name="form" value="quick">
        {/if}
        <input type="hidden" name="type" value="1">

        <fieldset class="form-group w-newsletter-name">
            <label aria-label="{$text.NAME}" for="name">
                <input name="name" type="text" class="form-input" placeholder="{$text.NAME}" required>
            </label>
        </fieldset>

        {if $settings.news_signup_type == 'email' || $settings.news_signup_type == 'both'}
        <fieldset class="form-group w-newsletter-email">
            <label aria-label="{$text.MAIL}" for="email">
                <input name="email" type="text" class="form-input" placeholder="{$text.MAIL}" required>
            </label>
        </fieldset>
        {/if}

        {if $settings.news_signup_type == 'sms' || $settings.news_signup_type == 'both'}
        <fieldset class="form-group w-newsletter-mobile">
            <label aria-label="{$text.MOBILE}" for="mobile">
                <input name="mobile" type="text" class="form-input" placeholder="{$text.MOBILE}" required>
            </label>
        </fieldset>
        {/if}

        <div class="m-newsletter-newsletter">
                {include file="modules/widgets/newsletter/type.tpl" widget=true}
        </div>

        {if $displaySpamCheck}
        <div class="m-newsletter-spam-check" data-js="m-newsletter-spam-check">
				{include file="modules/widgets/recaptcha/recaptcha.tpl" lazyload=$lazyloadRecaptcha|default:false}
        </div>
        {/if}

        {if $settings.privacy_policy_newsletter}
        <div class="m-newsletter-consent">
            {include file="modules/widgets/consent/consent.tpl" widget=true}
        </div>
        {/if}

        <button class="form-submit button-primary" type="submit" title="{$text.CONFIRM}">{$text.CONFIRM}</button>
    </form>
</div>
