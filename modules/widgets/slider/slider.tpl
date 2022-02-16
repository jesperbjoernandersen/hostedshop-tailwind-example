{*

# Description
Template for a slider element with configurations.


## Date last modified
2020-10-26


## Supplied variables
+ $widgetSettings       - A Array() of widgetSettings for the slider
+ $type                 - A page type definition (page, product, ...)
+ $id                   - A id for the give page type
+ $alt                  - Alt text for images
+ $microdata            - A Boolean telling to apply microdata or not
+ $placeholderSelector  - A string with selector specificity for the placeholder styling

## Generated variables
+ $controller           - Instance of FileController
+ $item                 - An entity of a collection of FileController



# Slider
The slider is build on [Owl Carousel][1]. It's a touch enabled jQuery plugin that
lets you create beautiful responsive carousel slider.


## Platform
The slider has a Javascript wrapper for the platform, which allows easy setup thru
Smarty. Read the discription below:


## Initialize the slider
To initialize the slider, the only thing you have to do is to add the data-attribute
data-slider. It has to have one of two paramaters:

+   single, or
+   multiple

Single starts a slider which only has one single element in the viewport.
Multiple starts a slider with the chance of having multiple elements in the viewport
To know more about the data-attributes, read more below.


## Options
for some of the [options][2] to be applied thru data-attributes on the
slider. The data-attributes available are listed below. The defaults are shown:
```
slider="single"                        // start a slider with a single item (default)
slider="multiple"                      // start a slider with multiple items
theme="hero-slider"                    // set CSS class to be used for theme
nav="true"                             // show a navigation for the slider
nav-text="næste,forrige"               // set the navigation text
merge="1"                              // set merge option
pagination="false"                     // show pagination for the slider [true, false, "numbers"]
speed="2000"                           // set the time between slides
s-items="2"                            // set items count at smallest breakpoint
m-items="6"                            // set items count at medium breakpoint
l-items="8"                            // set items count at large breakpoint
xl-items="8"                           // set items count at xlarge breakpoint
next=".hero-slider-next"               // set selector for navigation next button
prev=".hero-slider-prev"               // set selector for navigation previous button
autoplay="true"                        // set the slider to autoplay or slider speed with number
random="false"                         // set the slider to randomise items
```

#### Note
Owl Carousel has a [itemsCustom attribute][3] which can be use to define items on different
breakpoints. The wrapper opens up for this attribute aswell but abstracts some of the
complexety:
```
s-items
m-items
l-items
xl-items
```
The size and items data-attributes above relate to the UI kit and the breakpoints defined
as seen below:
```
Breakpoints:
s:  "min-width: 480px"
m:  "min-width: 768px"
l:  "min-width: 960px"
xl: "min-width: 1280px"
```


## Owl data methods
The slider also supports Own Carousels data methods which are also in the section
about [Owl Options][2]. This can be done by doing the following:
 Imagine a slider initialized with the data-slider="single" with class="top-slider"
 ```
<div class="top-slider" data-slider="single" data-nav="false">...</div>
<div id="top-slider-nav-next"></div>
<div id="top-slider-nav-prev"></div>
<script>
    jQuery(function() {
        var my_slider = jQuery(".top-slider");
        jQuery("#top-slider-nav-prev").on("click", function (e) {
            my_slider.slider("prev");
        });
        jQuery("#top-slider-nav-next").on("click", function (e) {
            my_slider.slider("next");
        })
    });
</script>
 ```


## Controll everything your self.
If you do not wan't to use the wrapper, it is also possible to use the [Owl Carousel][1]
directly without using the framework wrapper, just omit the data-slider attribute;
 ```
<div class="top-slider">...</div>
<script>
    jQuery(function() {
        $("#top-slider").owlCarousel();
    });
</script>
 ```


[1]: http://owlgraphic.com/owlcarousel/
[2]: http://owlgraphic.com/owlcarousel/#customizing
[3]: http://owlgraphic.com/owlcarousel/demos/itemsCustom.html
*}

{* Shorthand for whether or not use microdata *}
{$useMicrodata = $microdata|default:false}

{* Make sure we have some widgetSettings to work with *}
{if !isset($widgetSettings)}
    {$widgetSettings = ['theme' => "hero-slider"]}
{/if}

{* Map speed to autoPlay *}
{if isset($widgetSettings['speed'])}
    {$widgetSettings['autoplay'] = $widgetSettings['speed']}
    {$widgetSettings['speed'] = null}
{/if}

{* If $type and $id are undefined, we assume a collection is delivered *}
{if isset($type) && isset($id)}

    {* Setup controller to get images based on page and type id *}
    {controller type=files assign=controller}

    {*
        $type - Defined with include (page, product, ...)
        $id   - Id of type element (page_id, product_id)
    *}
    {if $type eq "product"}
        {collection assign=items controller=$controller type=$type productId=$id}
    {else}
        {collection assign=items controller=$controller type=$type id=$id}
    {/if}
{/if}


{*** Define width and height used in thumbnail ***}
{$itemWidth=null}
{$itemHeight=null}
{$crop = false}

{if isset($widgetSettings['width'])} {$itemWidth=$widgetSettings['width']} {/if}
{if isset($widgetSettings['height'])} {$itemHeight=$widgetSettings['height']} {/if}
{if isset($widgetSettings['crop'])} {$crop = $widgetSettings['crop']} {/if}

{if $items->getActualSize() == 1}
    {include file="modules/widgets/image/placeholder-aspect.tpl"
        width=$itemWidth
        height=$itemHeight
        selector=":not(.ielt9) {$placeholderSelector} .w-slider"}
{/if}

{* Only generate slider if we have actual elements to work with *}
<div class="slider-wrap w-slider widget">
{if $items->getActualSize() gt 0}

    {* Image settings *}

    {*** Watermark settings ***}
    {$watermark = null}
    {if !empty($widgetSettings['watermark']) and !empty($template.watermark)}
        {$watermark = $template.watermark}
    {/if}

    {* If there is only 1 item, only apply the theming class and don't start up the hole slider *}
    {if $items->getActualSize() == 1}
        {$sliderHasOwl = false}
        <div class="w-slider-container w-single-item {$widgetSettings['theme']}">
    {* else apply all the supplied widgetSettings and start up the hole slider *}
    {else}
        {$sliderHasOwl = true}
        {$widgetSettings['lazy-load'] = 'true'}
        {$widgetSettings['lazy-follow'] = 'true'}
        <div class="w-slider-container" style="opacity:0;" {foreach $widgetSettings as $k => $v}data-{$k}="{$v}" {/foreach}>
    {/if}

    {* Fetch collection of files *}
    {$files = $items->getData()}

    {* Check if collection should be randomised *}
    {if !empty($widgetSettings['random'])}
        {$sr = shuffle($files)}
    {/if}

    {* Iterate over all the elements *}
    {foreach $files as $item}
        {if isset($useFancyBox) && $useFancyBox}
            <a data-fancybox="" data-fancybox-group="{$type}" href="{$item->thumbnail(null, null, false, $watermark)|solutionPath}" class="w-slider-anchor item-{$item->Id}">
        {elseif $item->Link}
            <a href="{$item->Link}" class="w-slider-anchor item-{$item->Id}">
        {/if}
            <figure class="item" data-fileid="{$item->Id}">

                {*** Use wdith and height to generate a thumbnail ***}
                {$itemSrc = $item->thumbnail($itemWidth, $itemHeight, $crop, $watermark)|solutionPath}

                {*** Setup rest of items properties (only valid for type=page) ***}
                {if $type eq 'page'}
                    {$itemTitle = $controller->getTranslation($item->Id, "title")|strip}
                    {$itemText = $controller->getTranslation($item->Id, "text")|strip}
                    {$itemLink = $item->Link}
                    {$itemLinkText = $controller->getTranslation($item->Id, "linktext")|strip}
                    {$itemAlt = $itemTitle}
                {/if}

                {if !isset($itemTitle) or $itemTitle === "" and isset($alt)}
                    {$itemAlt = $alt}
                {/if}

                {*** Slider item image ***}
                {if $sliderHasOwl}
                    {if $item@index == 0}
                        <img class="w-slider-img responsive" src="{$itemSrc}" alt="{$itemAlt}">
                    {else}
                        {img class="w-slider-img responsive" src="{$itemSrc}" alt="{$itemAlt}" slider=true fancyThumb=true}
                    {/if}
                {else}
                    {if is_numeric($itemHeight) && is_numeric($itemWidth)}
                        <span class="placeholder-wrapper">
                            <span class="placeholder"></span>
                            <img class="w-slider-img responsive" src="{$itemSrc}" alt="{$itemAlt}">
                        </span>
                    {else}
                        <img class="w-slider-img responsive" src="{$itemSrc}" alt="{$itemAlt}">
                    {/if}
                {/if}

                {if $useMicrodata}
                    {include file="modules/widgets/semantics/image-object.tpl" itemprops="image" imageURL=$itemSrc height=$itemHeight width=$itemWidth}
                {/if}


                {*** Show image caption if item text and item title are defined ***}
                {if !empty($itemText) || !empty($itemTitle) || !empty($itemLinkText)}
                    <figcaption class="w-slider-caption item-caption">
                        {if $itemTitle != ""}
                            <div class="item-title">
                                <p class="h2" {if isset($microdata) and $microdata}itemprop="headline"{/if}>{$itemTitle}</p>
                            </div>
                        {/if}
                        {if $itemText != ""}
                        <div class="item-text">
                            <p class="h4">{$itemText}</p>
                        </div>
                        {/if}
                        {if $itemLinkText != ""}
                            <div class="item-link">
                                <span class="button-text large">
                                    <span>{$itemLinkText}</span>
                                    <i class="fa fa-fw fa-arrow-circle-o-right"></i>
                                </span>
                            </div>
                        {/if}
                    </figcaption>
                {/if}
            </figure>{* end: .item *}
        {* Fancybox posibility *}
        {if isset($useFancyBox) && $useFancyBox}
            </a>
        {elseif $item->Link}
            </a>
        {/if}
    {/foreach}
    </div>{* end: .slider *}

{elseif isset($defaultImage)}
    {img class="w-slider-img w-img-default responsive" src="{$defaultImage}" alt="" slider=true}
{/if}

</div>{* end: .slider-wrap *}
