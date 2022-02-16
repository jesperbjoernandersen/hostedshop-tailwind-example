<script>
    ;(function (exports) {
        exports.text = {$text|jsonify};
        exports.platform = exports.platform || {};
        exports.platform.template = {$template|jsonify};
        exports.platform.currency = {$currency|json_encode};
        exports.platform.general = {$general|jsonify};
        exports.platform.shop = {$shop|jsonify};
        exports.platform.cookies = {$smarty.cookies|array_keys|jsonify};
        exports.platform.client = {
            ip: '{$client.ip}'
        };
        exports.platform.consent = {$cookieConsent.consent|jsonify};
        exports.platform.cookielist = {
            internal: {$cookieConsent.lists.internal},
            external: {$cookieConsent.lists.external}
        };
        exports.platform.language = {
            iso: '{$general.languageIso}',
            iso639: '{$general.languageIso639}'
        };
        exports.platform.page = {$page|jsonify};
        exports.platform.user = {$user|jsonify};
        exports.platform.adminUser = {$adminUser|jsonify};
        exports.platform.settings = {$settings|jsonify};
        exports.platform.getSetting = function (key) {
            if (typeof this.settings[key] !== 'undefined') {
                return this.settings[key];
            }
            return null;
        };
        {helperSession key='cartLastCache' assign='cartCache'}
        {if $cartCache}
            exports.platform.settings.cartLastCache = '{$cartCache}';
        {/if}
    })(window);
</script>

{*** Display all scripts added thru addScript help ***}
{foreach $head.scripts as $script}<script {foreach $script->attributes as $k => $v}{$k}="{$v}" {/foreach}></script>
{/foreach}

{*** Facebook like ***}
{if isset($settings.social_facebook) && $settings.social_facebook && (isset($cookieConsent.consent) && $cookieConsent.consent['MARKETING'])}
    {if strtolower($general.languageIso) === "uk"}
        {$lang = "en_US"}
    {else}
        {$lang = $general.languageIso639|cat:"_"|cat:$general.languageIso}
    {/if}

    <div id="fb-root"></div>
    <script id="facebook-jssdk" src="//connect.facebook.net/{$lang}/sdk.js#xfbml=1{if !empty($settings.fb_appId)}&amp;appId={$settings.fb_appId}{/if}&amp;version=v2.0" async></script>
{/if}

{*** Twitter tweet ***}
{if isset($settings.social_twitter) && $settings.social_twitter && (isset($cookieConsent.consent) && $cookieConsent.consent['FUNCTIONAL'] && $cookieConsent.consent['STATISTICS'])}
    <script id="twitter-wjs" src="//platform.twitter.com/widgets.js" async></script>
{/if}

{*** Google integration ***}
{include file="modules/widgets/integrations/google_tagsmanager_body.tpl"}
{*** Facebook Marketing Pixel integration ***}
{include file='modules/widgets/integrations/facebook_marketing_pixel.tpl'}
{*** ViaBill integration ***}
{include file="modules/widgets/integrations/viabill_pricetag.tpl" type="script"}

{includeScript file='partials/bodyBottom.js.tpl'}
