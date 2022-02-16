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
    <noscript><iframe src="//www.googletagmanager.com/ns.html?id={$settings.google_tag_manager_id}" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
{/if}
