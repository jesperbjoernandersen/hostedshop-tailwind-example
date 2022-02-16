{*

# Description
Twitter widget. A widget is a small helper template, with some functionality.
A widget for Twitter social media links and Tweets.


## Date last modified
2014-08-01


## Primary variables
+ $widgetSettings                                                       - A Array() of widgetSettings for the widget


## Partials (templates)
No extra templates required for this template

*}

{* Settings check *}
{if $settings.social_twitter}

    {* Twitter handle *}
    {$pageurl = false}

    {* Create a follow link ? *}
    {$follow = false}

    {* Button size much? *}
    {$largeBtn = false}

    {* Language for button *}
    {$lang = $general.languageIso639}

    {* Show handle in follow *}
    {$showhandle = false}

    {* Show count *}
    {$showcount = true}


    {*** If settings are provided overwrite defaults ***}
    {if isset($widgetSettings)}
        {*** Profile link ***}
        {if isset($settings['social_twitter_pageurl']) and $settings['social_twitter_pageurl']}
            {$pageurl = $settings['social_twitter_pageurl']}
        {elseif isset($widgetSettings['pageurl'])}
            {$pageurl = $widgetSettings['pageurl']}
        {/if}


        {*** Create profile / follow link ***}
        {if isset($widgetSettings['follow'])}
            {$follow = $widgetSettings['follow']}
        {/if}


        {*** Big or small button? ***}
        {if isset($widgetSettings['largebutton']) and $widgetSettings['largebutton']}
            {$largeBtn = true}
        {/if}


        {*** Force different language ***}
        {if isset($widgetSettings['lang'])}
            {$lang = $widgetSettings['lang']}
        {/if}


        {*** Show the handle in the follow ***}
        {if isset($widgetSettings['showpage']) and $widgetSettings['showpage']}
            {$showhandle = true}
        {/if}


        {*** Show count ***}
        {if isset($widgetSettings['showcount']) and $widgetSettings['showcount']}
           {$showcount = true}
        {/if}
    {/if}


    {*** Create a follow link or a Tweet link ***}
    {if $follow and $pageurl}
        <a href="{$pageurl}" class="twitter-follow-button"
            {if $largeBtn}data-size="large"{/if}
            data-show-count="{if $showcount}true{else}false{/if}"
            data-lang="{if strtolower($lang) eq "en"}en_GB{else}{$lang}{/if}"
            data-show-screen-name="{if $showhandle}true{else}false{/if}"
        >Follow {if $pageurl and $showhandle}{$pageurl}{/if}</a>
    {else}
        <a href="https://twitter.com/share" class="twitter-share-button"
            {if $largeBtn}data-size="large"{/if}
            {if !$showcount}data-count="none"{/if}
            {if $pageurl}data-via="{$pageurl}"{/if}
            data-lang="{if strtolower($lang) eq "en"}en_GB{else}{$lang}{/if}"
        >Tweet</a>
    {/if}

{/if}
