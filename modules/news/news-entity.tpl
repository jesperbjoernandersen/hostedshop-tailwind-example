{*

# Description
Template for a single news article with microdata markup.


## Date last modified
2021-05-28


## Primary variables
+ $controller                                                           - Instance of NewsController
+ $item                                                                 - Entity of NewsController (single news article)
+ $sliderSettings                                                       - Array with settings for the slider widget


## Partials (templates)
+ "/modules/widgets/slider/slider.tpl"                                  - Slider widget to create a image slider

*}

{* Start of module *}
<div class="modules m-news" itemscope itemtype="http://schema.org/NewsArticle">
    {* Article content *}
    <article class="m-news-article">
        {* Include publisher information as required by Google's Rich Data specification *}
        {include file="modules/widgets/semantics/organization.tpl" itemprops="author publisher"}

        {* Header for the news article *}
        <header class="m-news-header page-title">
            {* Title of this news article *}
            <h1 class="m-news-headline" itemprop="headline">{$item->Title}</h1>
        </header>

        <div class="meta trailing-trip">
            {* Time of creation *}
            <p class="m-news-date">
                <small><span class="m-news-date-added">{$text.BLOG_DATE_ADD}</span> <time class="m-news-date-time" itemprop="datePublished" content="{$item->DateCreated}" datetime="{$item->DateCreated}">{$item->DateCreated|date_format:$general.dateFormat}</time></small>
            </p>
        </div>

        {* Slider settings to show the images of this article *}
        {$crop = "fill"}
        {if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
            {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
        {/if}
    	{$sliderSettings = [
            "slider"    => "single",
            "theme"     => "m-news-slider-theme",
            "pagination"=> "true",
            "width"     => 1600,
            "height"    => 600,
            "crop"      => $crop,
            "watermark" => true
        ]}

        {* Include the slider template and send along the settings and information to fetch from the filesController *}
        {include file="modules/widgets/slider/slider.tpl" widgetSettings=$sliderSettings alt=$item->Title type=news id=$item->Id microdata=true}

        {* The description of this news article needs to be loaded from the controller *}
        <div class="m-news-description description trailing" itemprop="articleBody">{$controller->getDescription($item->Id)}</div>

        {* Include social media *}
        {if $settings.social_facebook or $settings.social_twitter}
        <div class="m-news-social">
            <div class="row">
                <ul class="m-widgets w-social list-inline">
                {foreach ["twitter","facebook"] as $social}
                    <li class="w-social-item w-social-{$social}">
                        {include file="modules/widgets/social/{$social}.tpl"}
                    </li>
                {/foreach}
                </ul>
            </div>
        </div>
        {/if}

    {* End of article content *}
    </article>
{* End of module *}
</div>
