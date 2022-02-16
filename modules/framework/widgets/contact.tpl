{*

# Description
Contact info widget. A widget is a small helper template, with some functionality.


## Date last modified
2018-08-30


## Primary variables
+ $template                                                             - Array with settings from the template
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

<strong>{$contactdata.name}</strong><br />
{if !empty($contactdata.company)}
    {$contactdata.company}<br />
{/if}

{if !empty($contactdata.address)}
    {$contactdata.address}<br />
    {$contactdata.zipcode} {$contactdata.city}<br />
    {$contactdata.country}<br />
{/if}

{if !empty($contactdata.cvr)}
    {$text.VAT_NR}: {$contactdata.cvr}<br />
{/if}

{if !empty($contactdata.phone)}
    {$text.TELEPHONE}: {$contactdata.phone}<br />
{/if}

{if !empty($contactdata.email)}
    {$text.MAIL}: <a href="mailto:{$contactdata.email}">{$contactdata.email}</a><br />
{/if}

<br /><a href="{$contactdata.url}" target="_blank" rel="noopener">{$contactdata.displayUrl}</a>
