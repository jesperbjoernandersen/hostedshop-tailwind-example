{*

# Description
reCAPTCHA widget. A widget is a small helper template, with some functionality.
The widget gets a reCAPTCHA form for spam check.


## Date last modified
2021-02-16


## Primary variables
+ $text - Global scope variable containing translations


## Resource
+ [Google Recaptcha dokumentation](http://www.google.com/recaptcha/learnmore)

*}

{*** Check if spam check is enabled in settings ***}
{if $settings.spam_check}

    {*** Sets recaptcha version, and sets fallback ***}
    {$version = 'V2'}
    {if isset($settings.spam_recaptcha_version)}
        {$version = $settings.spam_recaptcha_version}
    {/if}

    {setting key=spam_recaptcha_invisble_mode assign=isInvisbleMode}

    {*** Handles if it should use invisible key or default. Default is used for both v2 and v3 ***}
    {$size = 'invisible'}
    {recaptchaSiteKey invisible="true" assign="siteKey"}
    {if isset($isInvisbleMode) && !$isInvisbleMode && $version == 'V2'}
        {$size = 'normal'}
        {recaptchaSiteKey assign="siteKey"}
    {/if}
    
    {*** reCAPTCHA's config ***}
    {$config = [
        'sitekey' => $siteKey|default:'missing site key',
        'size' => $size
    ]}

    {*** reCAPTCHA position ('bottomright', 'bottomleft', 'inline') ***}
    {$config['badge'] = 'inline'}

    {$options = [
        'version' => $version,
        'config' => $config,
        'lazyload' => $lazyload|default:false
    ]}
    {addScript src="modules/widgets/recaptcha/includes/js/recatpcha.js" 
        data-lazyload-src="https://www.google.com/recaptcha/api.js?onload=reCaptchaCallback&render=explicit"
        id="recaptcha"
        async="" 
        defer=""}

    <fieldset class="form-group w-recatpcha widget">
        {if $version !== 'V3'}
            <label class="form-label">
                {$text.SPAM_CHECK}
                {if !isset($isInvisbleMode)}
                    <span class="form-required">*</span>
                    <i class="fa fa-rotate-right" style="cursor:pointer;"></i>
                {/if}
            </label>
        {else}
            <input type="hidden" name="recaptcha_response">
        {/if}
        <div data-options={$options|json_encode} class="g-recaptcha"></div>
    </fieldset>
{/if}
