{*

# Description
Google+ widget. A widget is a small helper template, with some functionality.
A widget for Google+ social media links and +1s.


## Date last modified
2014-08-01


## Primary variables
+ $widgetSettings                                                       - A Array() of widgetSettings for the widget


## Partials (templates)
No extra templates required for this template

*}

{* Settings check *}
{if $settings.social_google}

    {* Twitter page *}
    {$page = false}

    {* Create a follow link ? *}
    {$follow = false}

    {* Button size much? *}
    {$largeBtn = false}

    {* Language for button *}
    {$lang = $general.languageIso639}

    {* Show page in follow *}
    {$showpage = false}

    {* Show count *}
    {$showcount = true}


    {*** If settings are provided overwrite defaults ***}
    {if isset($widgetSettings)}
        {*** Profile link ***}
        {if isset($settings['social_google_page']) and $settings['social_google_page']}
            {$page = $settings['social_google_page']}
        {elseif isset($widgetSettings['page'])}
            {$page = $widgetSettings['page']}
        {/if}


        {*** Create profile / follow link ***}
        {if isset($widgetSettings['follow']) and $widgetSettings['follow']}
            {$follow = $widgetSettings['follow']}
        {/if}


        {*** Big or small button? ***}
        {if isset($widgetSettings['large-button']) and $widgetSettings['large-button']}
            {$largeBtn = true}
        {/if}


        {*** Force different language ***}
        {if isset($widgetSettings['lang'])}
            {$lang = $widgetSettings['lang']}
        {/if}


        {*** Show the page in the follow ***}
        {if isset($widgetSettings['showpage']) and $widgetSettings['showpage']}
            {$showpage = true}
        {/if}


        {*** Show count ***}
        {if isset($widgetSettings['showcount']) and $widgetSettings['showcount']}
           {$showcount = true}
        {/if}


       {if isset($widgetSettings['follow']) and $widgetSettings['follow']}
            {$follow = true}
        {/if}

    {/if}

    <script>
        window.___gcfg = {
            lang: "{if strtolower($lang) eq "en"}en_GB{else}{$lang}{/if}"
        };
    </script>

    {*** Create a follow link or a plusone link ***}
    {if $follow}
        <div class="g-follow"
            data-href="{$page}"
            data-rel="publisher"
            data-annotation="bubble"
            {if $largeBtn}data-height="24"{/if}
        ></div>
    {else}
        <div class="g-plusone"
            {if !$largeBtn}data-size="medium"{/if}
            {if !$showcount}data-annotation="none"{/if}
        ></div>
    {/if}
{/if}
