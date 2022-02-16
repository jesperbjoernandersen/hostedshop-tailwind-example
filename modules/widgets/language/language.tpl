{*

# Description
Language widget. A widget is a small helper template, with some functionality.


## Date last modified
2020-10-12


## Primary variables
+ $collection                                                           - Collection of languages
+ $type                                                                 - View type (dropdown, select or list)


## Partials (templates)
No extra templates required for this template

*}
{$imageWidth = 16}
{$imageHeight = 10}

{if !isset($showFlag)}
    {$showFlag = true}
{/if}

{if !isset($showText)}
    {$showText = true}
{/if}

{include file="modules/widgets/image/placeholder-aspect.tpl" 
    width=$imageWidth 
    height=$imageHeight
    selector=":not(.ielt9) .w-language"}

<div class="w-language">

    {*** Type: Dropdown ***}
    {if $type eq 'dropdown'}

        <div class="dropdown w-language-dropdown">
            <button class="button xsmall" data-toggle="dropdown">
                {if isset($showFlag) and $showFlag}
                <span class="placeholder-wrapper" style="width: {$imageWidth}px;">
                    <span class="placeholder"></span>
                    {img src="{$template.cdn}/_design/common/img/icons/flag/{$general.languageIso|substr:0:2|lower}.png"
                         class="w-language-flag w-language-flag--{$general.languageIso} reset is-i-b"
                         alt="{$general.languageIso}"}
                </span>
                {/if}
                {if isset($showText) and $showText}
                    {$general.languageTitle}
                {/if}
            </button>
            <div class="dropdown-menu" {if isset($showText) and !$showText}style='min-width:35px;'{/if}>
                <div class="dropdown-container">
                    <ul>
                    {foreach $collection->getData() as $language}
                        <li class="w-language-item item-{$language->Id} iso-{$language->LanguageISO}">
                            <a href="/?lang={$language->LanguageISO}">
                                {if isset($showFlag) and $showFlag}
                                <span class="placeholder-wrapper">
                                    <span class="placeholder"></span>
                                    {img src="{$template['cdn']}/_design/common/img/icons/flag/{$language->LanguageISO|substr:0:2|lower}.png"
                                         alt="{$language->LanguageISO}"
                                         class="w-language-flag w-language-flag--{$language->LanguageISO} reset is-i-b"}
                                </span>
                                {/if}
                                {if isset($showText) and $showText}
                                    {$language->Title}
                                {/if}
                            </a>
                        </li>
                    {/foreach}
                    </ul>
                </div>
            </div>
        </div>

    {*** Type: Select ***}
    {elseif $type eq 'select'}

        <div class="w-language-form">
            <select class="form-input form-select xsmall" name="country" onchange="window.location='/?lang='+ this.value">
            {foreach $collection->getData() as $language}
                <option {if $general.languageIso eq $language->LanguageISO}selected{/if} value="{$language->LanguageISO}">
                    {$language->Title}
                </option>
            {/foreach}
            </select>
        </div>

    {*** Type: List (else) ***}
    {else}
        <ul class="list-inline">
            {foreach $collection->getData() as $language}
                <li class="w-language-item item-{$language->Id} iso-{$language->LanguageISO}">
                    <a href="/?lang={$language->LanguageISO}" {if $general.languageIso eq $language->LanguageISO}class="active"{/if}>
                        {if isset($showFlag) and $showFlag}
                        <span class="placeholder-wrapper" style="width: {$imageWidth}px">
                            <span class="placeholder"></span>
                            {img src="{$template.cdn}/_design/common/img/icons/flag/{$language->LanguageISO|substr:0:2|lower}.png"
                                 class="w-language-flag w-language-flag--{$language->LanguageISO} reset is-i-b"
                                 alt="{$language->LanguageISO}"}
                        </span>
                        {/if}
                        {if isset($showText) and $showText}
                            {$language->Title}
                        {/if}
                    </a>
                </li>
            {/foreach}
        </ul>

    {/if}
</div>
