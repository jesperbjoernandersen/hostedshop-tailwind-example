{*

# Description



## Date last modified
2021-12-09


## Primary variables
+ $settings                                                             - Global scope variable containing platform settings
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{if isset($template.settings.COOKIE_TYPE) && $template.settings.COOKIE_TYPE == "COOKIE_CONSENT"}
    {addScript src='modules/widgets/cookie/includes/js/cookie.js'}

    {if !isset($smarty.cookies["cookie_consent"]) && !$client.isCrawler}
        {$options = [
            'REQUIRED'   => $text.COOKIES_REQUIRED,
            'FUNCTIONAL' => $text.COOKIES_FUNCTIONAL,
            'STATISTICS' => $text.COOKIES_STATISTICS,
            'MARKETING'  => $text.COOKIES_MARKETING
        ]}

        <div class="w-cookie {$template.settings.COOKIE_CONSENT_PLACEMENT}">
            <div class="w-cookie-modal">
                <form class="w-cookie-form container" data-group="w-cookie-form">
                    <div class="w-cookie-consent handle-scrollHeight" data-group="w-cookie-text">
                        <p class="w-cookie-title h2">{$text.COOKIES_TITLE}</p>
                        <div class="w-cookie-description handle-scrollHeight">{$text.COOKIES_INFO}</div>
                        <div class="w-cookie-extended-info handle-scrollHeight">{$text.COOKIES_EXTENDED_INFO}</div>
                        <button class="cookie-button button-text-simple trailing-db toggle-extended" type="button" data-toggle="collapse" data-target="w-cookie-text" data-class="extended-open">
                            <i class="fa fa-caret-up" aria-hidden="true"></i> {$text.COOKIES_LINK}
                        </button>
                        <div class="w-cookie-options trailing-db">
                            {foreach $options as $key => $option}
                                <fieldset class="w-cookie-option">
                                    <strong class="w-cookie-option-title">{$option}:</strong>
                                    <label class="switch">
                                        <input name="{$key}" type="checkbox" {if $key == 'REQUIRED'} checked disabled{/if}>
                                        <span class="switch-rail {$template.settings.COOKIE_CONSENT_THEME}"></span>
                                    </label>
                                </fieldset>
                            {/foreach}
                        </div>
                    </div>
                    <div class="w-cookie-actions-wrapper">
                        <div class="w-cookie-actions">
                            <button name="accept" type="submit" class="button-primary cookie-button">{$text.COOKIES_DECLINE_ALL}</button>
                            <button name="accept_all" type="submit" class="button-primary cookie-button">{$text.COOKIES_ACCEPT_ALL}</button>
                        </div>
                        <button class="w-cookie-toggle cookie-button button button-text" type="button" data-toggle="collapse" data-target="w-cookie-form" data-class="w-cookie-details">
                            <div class="w-cookie-toggle-details-show">{$text.COOKIES_SHOW_DETAILS}</div>
                            <div class="w-cookie-toggle-consent-show">{$text.COOKIES_SHOW_CONSENT}</div>
                            <i class="fa fa-arrow-down" aria-hidden="true"></i>
                        </button>
                    </div>
                    <div class="w-cookie-listing" data-inject="cookiedetails">
                        <center>{$text.COOKIES_LIST_ERROR}</center>
                    </div>
                    <div class="w-cookie-loader is-hidden">
                        <svg class="svg-spinner" viewBox='10 10 20 20'>
                            <circle cx='20' cy='20' r='8' />
                        </svg>
                    </div>
                </form>
            </div>
        </div>
    {/if}
{/if}
