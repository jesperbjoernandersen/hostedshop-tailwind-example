{*

# Description
Logo widget. A widget is a small helper template, with some functionality.


## Date last modified
2019-03-15


## Primary variables
+ $template                                                             - Array with settings from the template
+ $text                                                                 - Global scope variable containing translations
+ $forceLogo                                                            - Force logo into specific state


## Partials (templates)
No extra templates required for this template

*}

{* ******************************** *
    HELPER FUNCTIONS DEFINED FIRST
  ********************************* *}
{function logoImage source='' style=false}{strip}
    <a href="{$general.domain}" style="text-decoration:none;" title="{$contactdata.name|escape:'html'}"><img style="height:auto;max-width:100%;{if $style}{$style}{/if}" src="{if $request->isPrint and $request->isPDF}{$source|pdfPath}{else}{$source|solutionPath}{/if}" alt="{$contactdata.name|escape:'html'}" /></a>
{/strip}{/function}

{function logoText style=false}{strip}
    <h1 style="{$css->h1}{if $style}{$style}{/if}"><a style="{$css->h1}" href="{$general.domain}" title="{$contactdata.name|escape:'html'}">{$contactdata.name}</a></h1>
{/strip}{/function}


{if isset($forceLogo)}
    {if $forceLogo == 'logo_source_negative' && !empty($template.settings.LOGO_SOURCE_NEGATIVE)}
        {logoImage source=$template.settings.LOGO_SOURCE_NEGATIVE style=$style}
    {elseif $forceLogo == 'logo_source' && !empty($template.settings.LOGO_SOURCE)}
        {logoImage source=$template.settings.LOGO_SOURCE style=$style}
    {else}
        {logoText style=$style}
    {/if}
{else}
    {* If the template is set to show a picture as logo *}
    {if $template.settings.LOGO_TYPE eq 'PICTURE' and (!empty($template.settings.LOGO_SOURCE_NEGATIVE) or !empty($template.settings.LOGO_SOURCE))}
        {* Figure out which logo to display *}
        {$sourceFile = $template.settings.LOGO_SOURCE_NEGATIVE}
        {if empty($template.settings.LOGO_SOURCE_NEGATIVE)}
            {$sourceFile = $template.settings.LOGO_SOURCE}
        {/if}

        {* Display logo *}
        {logoImage source=$sourceFile style=$style}
    {else}{* Else show the solution name as logo *}
        {logoText style=$style}
    {/if}
{/if}