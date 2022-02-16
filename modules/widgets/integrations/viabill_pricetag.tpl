{*

# Description
ViaBill PriceTag widget for showing ViaBill price tag on product sheet, cart and checkout. A widget is a small helper template, with some functionality.


## Date last modified
2020-07-13


## Primary variables
+ $settings                                                             - Global scope variable containing platform settings
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
No extra templates required for this template

*}

{* Viabill PriceTag supported currency/languages *}
{assign var=viabill_currency value=["DKK","NOK","USD"]}
{assign var=viabill_language value=["da","en","no","nn","nb"]}

{if isset($settings.viabill_id) && !empty($settings.viabill_id) && in_array($general.currencyIso,$viabill_currency) && in_array($general.languageIso639,$viabill_language)}
	{if $type eq "script"}
		{* Viabill Head tag *}
		{literal}
		<script>!function(){var t={necessary:!0,functional:platform.consent.FUNCTIONAL,statistical:platform.consent.STATISTICS,marketing:platform.consent.MARKETING};window.viabillOptions=window.viabillOptions||[],window.viabillOptions.push({"pricetag.cookiesEnabled":Object.keys(t).filter(function(i){return t[i]})});var i=document.createElement("script");i.type="text/javascript",i.async=!0,i.src="https://pricetag.viabill.com/script/{/literal}{$settings.viabill_id}{literal}";var e=document.getElementsByTagName("script")[0];e.parentNode.insertBefore(i,e)}();</script>
		{/literal}
	{else}
		{* Viabill Cart price tag *}
		<div class="viabill-pricetag" data-view="{$type}" data-price="{$price}" data-currency="{$general.currencyIso}" data-language="{$general.languageIso639}"></div>
	{/if}
{/if}
