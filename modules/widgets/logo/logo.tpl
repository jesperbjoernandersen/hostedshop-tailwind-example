{*

# Description
Logo widget. A widget is a small helper template, with some functionality.


## Date last modified
2021-02-09


## Primary variables
+ $template                                                             - Array with settings from the template


## Partials (templates)
No extra templates required for this template

*}

<a class="w-logo" href="/" title="{$contactdata.name|escape:'html'}">

	{* If the template is set to show a picture as logo *}
    {if $template.settings.LOGO_TYPE eq 'PICTURE' and !empty($template.settings.LOGO_SOURCE)}
        <img src="{$template.settings.LOGO_SOURCE|solutionPath}" alt="{$contactdata.name|escape:'html'}" class="w-logo-img" />

	{* Else show the solution name as logo *}
    {else}
        <span class="w-logo-text brand">{$contactdata.name}</span>
    {/if}
</a>
