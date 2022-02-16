{*

# Description
Google Tagsmanager widget. A widget is a small helper template, with some functionality.


## Date last modified
2020-07-13


## Primary variables
+ $settings                                                             - Global scope variable containing platform settings
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
No extra templates required for this template

*}

{if isset($settings.google_tag_manager_id) && !empty($settings.google_tag_manager_id) && (isset($cookieConsent.consent) && $cookieConsent.consent['MARKETING'])}
    {if $page.isCheckout && isset($smarty.get.approved)}
        {strip}
            <script>
                {orderTracking orderId=$page.orderId type="tagmanager"}
            </script>
        {/strip}
    {/if}
    {strip}
        {literal}
        <script id="google-tagmanager">
        (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
            new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
            j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
            '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        {/literal}
        })(window,document,'script','dataLayer','{$settings.google_tag_manager_id}');
        </script>
    {/strip}
{/if}
