{*

# Description
Template partial for the imageelement of the Product. Part of the Product page type.


## Date last modified
2022-01-12


## Resource
+ [CloudZoom][http://www.starplugins.com/cloudzoom/quickstart]
+ [Thumbelina][http://www.starplugins.com/thumbelina]
+ [Fancybox][http://fancyapps.com/fancybox/#docs]


## Primary variables
+ $partialSettings                                                      - Variable with settings for the product image
+ $id                                                                   - Id of the current product
+ $defaultImage                                                         - Image to be shown if none are available
+ $alt                                                                  - Alt-text for images
+ $settings                                                             - Global scope variable containing platform settings
+ $imageController                                                      - Instance of fileController of type product
+ $items                                                                - Collection of fileController (all product images)


## Partials (templates)
No extra templates required for this template

*}


{*** Fetch the filesController and save it for later ***}
{controller type=files assign=imageController}

{if isset($smarty.get.variantId)}
    {collection assign=variantImages controller=$imageController type=variant variantId=(int)$smarty.get.variantId}
{/if}

{if isset($variantImages) and $variantImages->getActualSize() gt 0}
    {$items = $variantImages}
{else}
    {collection assign=items controller=$imageController type=product productId=$item->Id}
{/if}

{if $items->getActualSize() gt 0}

    {* Preload related entities to optimize load times *}
    {include file='modules/product/partials/entity-image-rotation-preload.tpl' scope=parent}

    {*** Setup height and width ***}
    {$itemWidth=null}
    {$itemHeight=null}

    {if isset($partialSettings) && isset($partialSettings.thumbWidth)}
        {$thumbWidth = $partialSettings.thumbWidth}
    {else}
        {$thumbWidth = 80}
    {/if}

    {if isset($partialSettings) && isset($partialSettings.thumbHeight)}
        {$thumbHeight = $partialSettings.thumbHeight}
    {else}
        {$thumbHeight = 80}
    {/if}

    {if isset($partialSettings) && isset($partialSettings.thumbWidthResolution)}
        {$thumbWidthResolution = $partialSettings.thumbWidthResolution}
    {else}
        {$thumbWidthResolution = 250}
    {/if}

    {if isset($partialSettings) && isset($partialSettings.thumbHeightResolution)}
        {$thumbHeightResolution = $partialSettings.thumbHeightResolution}
    {else}
        {$thumbHeightResolution = 250}
    {/if}

    {if isset($partialSettings) && isset($partialSettings.id)}
        {$sliderId = $partialSettings.id}
    {else}
        {$sliderId = $product->Id}
    {/if}

    {$partialSettings["watermark"] = true}

    {$alt = $alt|escape:'html'}

    {*** Build the ZoomSlider thingy ***}
    <div id="template-myRotation-{$sliderId}" class="product-image">
        {include file="modules/widgets/slider/slider.tpl"
            placeholderSelector="#template-myRotation-{$sliderId}"
            widgetSettings=$partialSettings
            type='product'
            id=null
            items=$items
            useFancyBox=true
            defaultImage=$defaultImage
            microdata=true
            alt=$alt}

        {*** Only show image changer, if there is actually more then one picture ***}
        {if $items->getActualSize() gt 1}

            {*** Setup for number of thumbnail images on different breakpoints ***}
            {$thumbCount = [
                'no-buttons' => [ 's' => 4, 'm' => 5, 'l' => 7, 'xl' => 9 ],
                'buttons' => [ 's' => 3, 'm' => 4, 'l' => 5, 'xl' => 8 ]
            ]}

            {*** With one column box ***}
            {if $columns == 1}
                {$thumbCount = [
                    'no-buttons' => [ 's' => 4, 'm' => 5, 'l' => 5, 'xl' => 7 ],
                    'buttons' => [ 's' => 3, 'm' => 4, 'l' => 4, 'xl' => 6 ]
                ]}
            {/if}

            {*** With two column box ***}
            {if $columns == 2}
                {$thumbCount = [
                    'no-buttons' => [ 's' => 4, 'm' => 11, 'l' => 7, 'xl' => 5 ],
                    'buttons' => [ 's' => 3, 'm' => 9, 'l' => 5, 'xl' => 4 ]
                ]}
            {/if}

            {$buttonClasses = []}
            {$thumbs = []}
            {$totalCount = $items->getActualSize()}
            {foreach $thumbCount['no-buttons'] as $bp => $count}
                {if $totalCount > $count}
                    {$thumbs[$bp] = $thumbCount['buttons'][$bp]}
                {else}
                    {$thumbs[$bp] = $count}
                    {$buttonClasses[] = 'thumbelina-wrapper--pagination-is-hidden-'|cat:$bp}
                {/if}
            {/foreach}

            <div id="slider-{$sliderId}" class="thumbelina-wrapper {$buttonClasses|implode:' '}" style="opacity:0;position:relative;height: {$thumbHeight+2|cat:"px"};margin-top:1em;">
                <div class="thumbelina-but horiz left"><i class="fa fa-fw fa-caret-left"></i></div>
                <div class="thumbelina-but horiz right"><i class="fa fa-fw fa-caret-right"></i></div>
                <ul class="thumbelina owl-carousel"
                    data-slider="multiple"
                    data-autoplay="false"
                    data-s-items="{$thumbs['s']}"
                    data-m-items="{$thumbs['m']}"
                    data-l-items="{$thumbs['l']}"
                    data-xl-items="{$thumbs['xl']}"
                    data-pagination="false"
                    data-nav="false">

                    {*** Run thru all images and list for zoomslider to use ***}
                    {foreach $items->getData() as $item}
                        {*** Define width and height used in thumbnail ***}
                        {$thumbSrc = $item->thumbnail($thumbWidthResolution, $thumbHeightResolution, $crop)|solutionPath}

                        {*** Slider item image ***}
                        <li style="width: {$thumbWidth+2}px;" class="item">
                            {img class="rotation-gallery"
                                 style="width: 100%"
                                 itemprop="image"
                                 data-fileid="{$item->Id}"
                                 src="{$thumbSrc}"
                                 alt="{$alt}"
                            }
                        </li>
                    {/foreach}
                </ul>
            </div>
        {/if}
    </div>

    {if $items->getActualSize() gt 1}
    {strip}
        {*** Only activate image changer, if there is actually more then one picture ***}
        <script>
        ;(function (){
            var _load{$sliderId} = function(){
                var $slider = $('#slider-{$sliderId}'),
                    $images = $slider.find('img[data-fileid]');

                {*** Only activate image changer, if there is actually more then one picture ***}
                {if $items->getActualSize() gt 1}
                $slider.fadeTo(300, 1);
                {/if}

                $("#template-myRotation-{$sliderId} .right").click(function(){
                    $("#template-myRotation-{$sliderId} .owl-carousel").trigger('owl.next');
                });

                $("#template-myRotation-{$sliderId} .left").click(function(){
                    $("#template-myRotation-{$sliderId} .owl-carousel").trigger('owl.prev');
                });

                $images.on("click", function (e) {
                    var $this = $(this),
                        idx = $images.filter(":visible").index($this),
                        $owl = $("#template-myRotation-{$sliderId} .owl-carousel").data("owlCarousel");

                    $owl.goTo(idx);
                });
            };

            if(window.addEventListener){
                window.addEventListener('load', _load{$sliderId});
            } else{
                window.attachEvent('onload', _load{$sliderId});
            }
        })();
        </script>
    {/strip}
    {/if}
{elseif isset($defaultImage)}
    <div class="product-image">
        <img class="responsive" src="{$defaultImage}" alt="">
    </div>
{/if}
