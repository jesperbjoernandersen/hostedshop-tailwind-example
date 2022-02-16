{*

# Description
Replacement widget. A widget is a small helper template, with some functionality.


## Date last modified
2019-04-10


## Primary variables
+ $template                                                             - Array with settings from the template
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{if $result}
    {* Fallback if replacements isn't supplied *}
    {if !is_array($replacements)}
        {$replacements = []}
    {/if}

    {* Order replacements *}
    {if $order}
        {$replacements["ORDER_NUMBER"] = $order->Id} {* Order number *}
        {$replacements["#ORDER_NUMBER#"] = $order->Id} {* Order number in email subject translation *}
        {$replacements["#ORDER_STATUS#"] = $order->StatusText} {* Order status translation in email subject translation *}

        {if $order->Invoice}
            {$replacements["#INVOICE_NUMBER#"] = $order->Invoice->Id} {* Invoice number in email subject translation *}
        {/if}
    {/if}


    {* Company logo *}
    {include file="modules/framework/widgets/logo.tpl" assign=logoTpl style=false}
    {$result = str_replace( ['<img src="FIRMA_DATA_LOGO">', '<img src="OWNER_LOGO">', 'FIRMA_DATA_LOGO', 'OWNER_LOGO'], $logoTpl, $result )}


    {* Contact information *}
    {include file="modules/framework/widgets/contact.tpl" assign=contactTpl}
    {$result = str_replace( ["MAIL_CONTACT"], $contactTpl, $result )}


    {* Short code replacement list *}
    {$replacements["DEAR"] = $text.DEAR} {* Dear (from language file) *}
    {$replacements["FIRMA_DATA_MAIL"] = $contactdata["email"]} {* Company e-mail *}
    {$replacements["FIRMA_DATA_NAVN"] = $contactdata["name"]} {* Company name *}
    {$replacements["FIRMA_DATA_WWW"] = $contactdata["url"]} {* Company webpage *}
    {$replacements["OWNER_ADDRESS"] = $contactdata["address"]} {* Address *}
    {$replacements["OWNER_BANK"] = $contactdata["bankinfo"]} {* information *}
    {$replacements["OWNER_CITY"] = $contactdata["city"]} {* City *}
    {$replacements["OWNER_COMPANY"] = $contactdata["company"]} {* Company *}
    {$replacements["OWNER_COUNTRY"] = $contactdata["country"]} {* Country *}
    {$replacements["OWNER_MAIL_DUMMY"] = $contactdata["emaildummy"]} {* E-mail sender *}
    {$replacements["OWNER_MAIL"] = $contactdata["email"]} {* E-mail *}
    {$replacements["OWNER_MOBILE"] = $contactdata["mobilephone"]} {* Mobile No. *}
    {$replacements["OWNER_PHONE"] = $contactdata["phone"]} {* No. *}
    {$replacements["OWNER_TITLE"] = $contactdata["name"]} {* Title *}
    {$replacements["OWNER_VAT"] = $contactdata["vatnumber"]} {* Org. number *}
    {$replacements["OWNER_WWW"] = $contactdata["url"]} {* Address on web solution *}
    {$replacements["OWNER_ZIPCODE"] = $contactdata["zipcode"]} {* Postal code *}

    {* Styling replacement list *}
    {if isset($css)}
        {$replacements["<h1>"] = "<h1 style=\"{$css->h1}\">"}
        {$replacements["<h2>"] = "<h2 style=\"{$css->h2}\">"}
        {$replacements["<h3>"] = "<h3 style=\"{$css->h3}\">"}
        {$replacements["<p>"] = "<p style=\"{$css->p_content}\">"}
        {$replacements["<b>"] = "<b style=\"{$css->p}{$css->bold}\">"}
    {/if}

    {$result|strtr:$replacements}
{else}
    {$result}
{/if}
