{*

# Description
Widget for the general picture element slider.


## Parameters
No parameters other than template settings (XX = 01 -> 04)
- USP_SETTINGS_XX_ACTIVE
- USP_SETTINGS_XX_LINK
- USP_SETTINGS_XX_ICON


## Date last modified
2021-02-15

*}

{if $template.settings.USP_SETTINGS_01_ACTIVE eq "true" or $template.settings.USP_SETTINGS_02_ACTIVE eq "true" or $template.settings.USP_SETTINGS_03_ACTIVE eq "true" or $template.settings.USP_SETTINGS_04_ACTIVE eq "true"}

    {* Slick assets *}
    {addLink href="modules/widgets/slick/assets/css/slick.min.css" rel="preload" as="style" onload="this.onload=null;this.rel='stylesheet'"}
    {addScript src="modules/widgets/slick/assets/js/slick.min.js"}

    {* USP assets *}
    {addScript src="modules/widgets/usp/assets/usp.js" defer=""}

    <div class="w-usp">
        <div class="container">
            <div class="w-usp-items">

                {if $template.settings.USP_SETTINGS_01_ACTIVE eq "true"}
                    <div>
                    <a {if $text.USP_SETTINGS_01_LINK}href="{$text.USP_SETTINGS_01_LINK}"{/if} class="w-usp-item">
                        <div class="w-usp-icon">
                            {include file="modules/widgets/icon/icon.tpl" icon=$template.settings.USP_SETTINGS_01_ICON}
                        </div>
                        <div class="w-usp-content">
                            <strong>
                                {if $text.USP_SETTINGS_01_TEXT|count gt 1}
                                    {' '|implode:$text.USP_SETTINGS_01_TEXT}
                                {else}
                                    {$text.USP_SETTINGS_01_TEXT}
                                {/if}
                            </strong>
                            {if $text.USP_SETTINGS_01_SUBTEXT}
                                <small>
                                    {if $text.USP_SETTINGS_01_SUBTEXT|count gt 1}
                                        {' '|implode:$text.USP_SETTINGS_01_SUBTEXT}
                                    {else}
                                        {$text.USP_SETTINGS_01_SUBTEXT}
                                    {/if}
                                </small>
                            {/if}
                        </div>
                    </a>
                    </div>
                {/if}

                {if $template.settings.USP_SETTINGS_02_ACTIVE eq "true"}
                    <div>
                    <a {if $text.USP_SETTINGS_02_LINK}href="{$text.USP_SETTINGS_02_LINK}"{/if} class="w-usp-item">
                        <div class="w-usp-icon">
                            {include file="modules/widgets/icon/icon.tpl" icon=$template.settings.USP_SETTINGS_02_ICON}
                        </div>
                        <div class="w-usp-content">
                            <strong>
                                {if $text.USP_SETTINGS_02_TEXT|count gt 1}
                                    {' '|implode:$text.USP_SETTINGS_02_TEXT}
                                {else}
                                    {$text.USP_SETTINGS_02_TEXT}
                                {/if}
                            </strong>
                            {if $text.USP_SETTINGS_02_SUBTEXT}
                                <small>
                                    {if $text.USP_SETTINGS_02_SUBTEXT|count gt 1}
                                        {' '|implode:$text.USP_SETTINGS_02_SUBTEXT}
                                    {else}
                                        {$text.USP_SETTINGS_02_SUBTEXT}
                                    {/if}
                                </small>
                            {/if}
                        </div>
                    </a>
                    </div>
                {/if}

                {if $template.settings.USP_SETTINGS_03_ACTIVE eq "true"}
                    <div>
                    <a {if $text.USP_SETTINGS_03_LINK}href="{$text.USP_SETTINGS_03_LINK}"{/if} class="w-usp-item">
                        <div class="w-usp-icon">
                            {include file="modules/widgets/icon/icon.tpl" icon=$template.settings.USP_SETTINGS_03_ICON}
                        </div>
                        <div class="w-usp-content">
                            <strong>
                                {if $text.USP_SETTINGS_03_TEXT|count gt 1}
                                    {' '|implode:$text.USP_SETTINGS_03_TEXT}
                                {else}
                                    {$text.USP_SETTINGS_03_TEXT}
                                {/if}
                            </strong>
                            {if $text.USP_SETTINGS_03_SUBTEXT}
                                <small>
                                    {if $text.USP_SETTINGS_03_SUBTEXT|count gt 1}
                                        {' '|implode:$text.USP_SETTINGS_03_SUBTEXT}
                                    {else}
                                        {$text.USP_SETTINGS_03_SUBTEXT}
                                    {/if}
                                </small>
                            {/if}
                        </div>
                    </a>
                    </div>
                {/if}

                {if $template.settings.USP_SETTINGS_04_ACTIVE eq "true"}
                    <div>
                    <a {if $text.USP_SETTINGS_04_LINK}href="{$text.USP_SETTINGS_04_LINK}"{/if} class="w-usp-item">
                        <div class="w-usp-icon">
                            {include file="modules/widgets/icon/icon.tpl" icon=$template.settings.USP_SETTINGS_04_ICON}
                        </div>
                        <div class="w-usp-content">
                            <strong>
                                {if $text.USP_SETTINGS_04_TEXT|count gt 1}
                                    {' '|implode:$text.USP_SETTINGS_04_TEXT}
                                {else}
                                    {$text.USP_SETTINGS_04_TEXT}
                                {/if}
                            </strong>
                            {if $text.USP_SETTINGS_04_SUBTEXT}
                                <small>
                                    {if $text.USP_SETTINGS_04_SUBTEXT|count gt 1}
                                        {' '|implode:$text.USP_SETTINGS_04_SUBTEXT}
                                    {else}
                                        {$text.USP_SETTINGS_04_SUBTEXT}
                                    {/if}
                                </small>
                            {/if}
                        </div>
                    </a>
                    </div>
                {/if}

            </div>
        </div>
    </div>
{/if}
