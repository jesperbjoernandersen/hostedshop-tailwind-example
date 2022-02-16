{*

# Description
Facebook widget. A widget is a small helper template, with some functionality.
A widget for Facebook social media links and likes.


## Date last modified
2014-08-01


## Primary variables
+ $widgetSettings                                                       - A Array() of widgetSettings for the widget


## Partials (templates)
No extra templates required for this template

*}

{* Settings check *}
{if $settings.social_facebook && (isset($cookieConsent.consent) && $cookieConsent.consent['MARKETING'])}

    {* Twitter handle *}
    {$pageurl = false}

    {* Create a follow link ? *}
    {$follow = false}

    {* Button size much? *}
    {$largeBtn = false}

    {* Language for button *}
    {$lang = $general.languageIso639}

    {* Show/hide handle in follow *}
    {$showpage = false}

    {* Show/hide count *}
    {$showcount = true}

    {* Show/hide faces *}
    {$showfaces = true}

    {* Show/hide border *}
    {$showborder = false}

    {* Width of widget *}
    {$width = 180}



    {*** If settings are provided overwrite defaults ***}
    {if isset($widgetSettings)}
        {*** Profile link ***}
        {if isset($widgetSettings['page'])}
            {$pageurl = $widgetSettings['page']}
        {/if}



        {*** Big or small button? ***}
        {if isset($widgetSettings['largebutton']) and $widgetSettings['largebutton']}
            {$largeBtn = true}
        {elseif isset($widgetSettings['largebutton']) and !$widgetSettings['largebutton']}
            {$largeBtn = false}
        {/if}


        {*** Force different language ***}
        {if isset($widgetSettings['lang'])}
            {$lang = $widgetSettings['lang']}
        {/if}


        {*** Show the handle in the follow ***}
        {if isset($widgetSettings['showpage']) and $widgetSettings['showpage']}
            {$showpage = true}
        {elseif isset($widgetSettings['showpage']) and !$widgetSettings['showpage']}
            {$showpage = false}
        {/if}

        {*** Show count ***}
        {if isset($widgetSettings['showcount']) and $widgetSettings['showcount']}
            {$showcount = true}
        {elseif isset($widgetSettings['showcount']) and !$widgetSettings['showcount']}
            {$showcount = false}
        {/if}

        {*** Show faces ***}
        {if isset($widgetSettings['showfaces']) and $widgetSettings['showfaces']}
            {$showfaces = true}
        {elseif isset($widgetSettings['showfaces']) and !$widgetSettings['showfaces']}
            {$showfaces = false}
        {/if}

        {if isset($widgetSettings['showborder']) and $widgetSettings['showborder']}
            {$showborder = true}
        {elseif isset($widgetSettings['showborder']) and !$widgetSettings['showborder']}
            {$showborder = false}
        {/if}

        {if isset($widgetSettings['width'])}
            {$width = $widgetSettings['width']}
        {/if}

        {*** Create profile / follow link ***}
        {if isset($widgetSettings['follow']) and $widgetSettings['follow']}
            {$follow = $widgetSettings['follow']}
        {/if}
    {/if}


    {*** Create a follow link or a like link ***}
    {if $follow and $pageurl}
        <div style="display: block; text-align: center;" class="fb-like-box"
            data-href="{$pageurl}"
            data-width="{$width}"
            data-colorscheme="light"
            {if $showfaces}data-show-faces="true"{else}data-show-faces="false"{/if}
            data-header="false"
            data-stream="false"
            {if $showborder}data-show-border="true"{else}data-show-border="false"{/if}></div>
    {else}
        <div class="fb-like"
            {if $showcount}data-layout="button_count"{else}data-layout="button"{/if}
            data-action="like"
            data-show-faces="false"
            data-share="false"></div>
    {/if}

{/if}
