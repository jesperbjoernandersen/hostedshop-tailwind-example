{*

# Description
Widget for a slick slider.


## Supplied variables
+ $crop       - Possible values: false, true, "fill", "white", default: "fill"

## Date last modified
2021-11-15

*}

{controller type=page assign=pageController}
{controller type=files assign=controller}
{collection assign=items controller=$controller type=page id=$page.id}

{$peSettings = $pageController->pictureElementSettings($page.id)}

{* Default width (from highest to lowest size) *}
{$imageSizes = [
    ['width' => 2560],
    ['width' => 1920],
    ['width' => 1600],
    ['width' => 1024],
    ['width' => 768],
    ['width' => 480],
    ['width' => 320]
]}

{* Default height *}
{$maxHeight = 704}
{if !empty($peSettings["height"])}
    {$maxHeight = $peSettings["height"]}
{/if}

{* Aspect ratio *}
{$maxWidth = $imageSizes[0].width}
{$aspectHeight = 100 / ($maxWidth / $maxHeight)}

{* Define heights *}
{foreach $imageSizes as $size}
    {$imageSizes[$size@index].height = $size.width / 100 * $aspectHeight}
{/foreach}

{* Default time between slides *}
{$cycleSpeed = 5000}
{if !empty($peSettings["cycleSpeed"])}
    {$cycleSpeed = $peSettings["cycleSpeed"]}
{/if}

{* Default setting for cropping *}
{if !isset($crop)}
    {if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
        {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
    {else}
        {$crop = "fill"}
    {/if}
{/if}

{* Watermark settings *}
{$watermark = null}
{if !empty($widgetSettings['watermark']) and !empty($template.watermark)}
    {$watermark = $template.watermark}
{/if}

{$itemsAmount = $items->getActualSize()}

{* Slick Slider Assets *}
{if $itemsAmount gt 1}
    {addLink href="modules/widgets/slick/assets/css/slick.min.css"}
    {addScript src="modules/widgets/slick/assets/js/slick.min.js"}
    {addScript src="modules/widgets/slick/assets/js/slick.init.js"}
{/if}

{if $itemsAmount gt 0}
    <div class="w-slick" data-cyclespeed="{$cycleSpeed}">
        <div class="w-slick-container">
            <div class="w-slick-items">
                {foreach $items->getData() as $item}

                    {$itemTitle = $controller->getTranslation($item->Id, "title")|strip}
                    {$itemText = $controller->getTranslation($item->Id, "text")|strip}
                    {$itemLink = $item->Link}
                    {$itemLinkText = $controller->getTranslation($item->Id, "linktext")|strip}
                    {$itemAlt = $itemTitle}

                    {$hasCaptionButton = !empty($itemLink) and !empty($itemLinkText)}

                    <figure class="w-slick-figure">
                        {if !empty($itemLink)}
                        <a href="{$itemLink}">
                        {/if}
                        <div class="w-slick-figure-placeholder" style="padding-top: {$aspectHeight}%">

                            {* builds srcset (the $imageSizes array is from highest to lowest size) *}
                            <picture>
                                {$img = ""}
                                {foreach $imageSizes as $size}
                                    {$nextSize = $imageSizes[$size@index+1]}
                                    {$src = $item->thumbnail($size.width, $size.height,  $crop, $watermark)|solutionPath}
                                    {if $size@first}
                                        {$img = "<img class=\"w-slick-img responsive\" src=\"{$src}\" alt=\"{$itemAlt}\" />"}
                                    {/if}
                                    {if $size@last}
                                        <source media="(max-width: {$size.width}px)" srcset="{$src}">
                                    {else}
                                        <source media="(min-width: {$nextSize.width+1}px)" srcset="{$src}">
                                    {/if}
                                {/foreach}
                                {$img}
                            </picture>
                        </div>
                        {if !empty($itemTitle) or !empty($itemText) or $hasCaptionButton}
                            <figcaption class="w-slick-caption container">
                                <div>
                                    {if !empty($itemTitle)}
                                        <h3 class="h1">{$itemTitle}</h3>
                                    {/if}
                                    {if !empty($itemText)}
                                        <p>{$itemText}</p>
                                    {/if}
                                    {if $hasCaptionButton}
                                        <br>
                                        <span class="button button-primary">{$itemLinkText}</span>
                                    {/if}
                                </div>
                            </figcaption>
                        {/if}
                        {if !empty($itemLink)}
                        </a>
                        {/if}
                    </figure>
                {/foreach}
            </div>
        </div>
    </div>
{/if}
