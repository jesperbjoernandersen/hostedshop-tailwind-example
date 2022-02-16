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
+ $first                                                                - Entity of fileController (first product image)


## Partials (templates)
No extra templates required for this template

*}


{*** Fetch the filesController and save it for later ***}
{controller type=files assign=imageController}


{if isset($smarty.get.variantId)}
    {collection assign=variantImages controller=$imageController type=variant variantId=(int)$smarty.get.variantId}
{/if}

{*** Get instance of the imageController ***}
{if isset($variantImages) and $variantImages->getActualSize() gt 0}
    {$items = $variantImages}
{else}
    {collection assign=items controller=$imageController type=product productId=$item->Id}
{/if}

{if $items->getActualSize() gt 0}

    {* Preload related entities to optimize load times *}
    {include file='modules/product/partials/entity-image-zoom-preload.tpl' scope=parent}

    {*** Setup height and width ***}
    {$itemWidth=null}
    {$itemHeight=null}

    {*** Adjust image, lens, zoom and thumb size***}
    {if isset($partialSettings) && isset($partialSettings.width)}
        {$itemWidth=$partialSettings.width}
        {$partialSettings.lensWidth = "auto"}
        {$partialSettings.zoomWidth = "auto"}
    {/if}

    {if isset($partialSettings) && isset($partialSettings.height)}
        {$itemHeight=$partialSettings.height}
        {$partialSettings.lensHeight = $partialSettings.height|cat:"px"}
        {$partialSettings.zoomHeight = $partialSettings.height|cat:"px"}
    {/if}

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

    {$zoomImageWidth = null}
    {$zoomImageHeight = null}
    {if isset($partialSettings) && isset($partialSettings.height) && isset($partialSettings.width) && isset($partialSettings.startMagnification)}
        {$zoomImageWidth = $partialSettings.width * 2}
        {$zoomImageHeight = $partialSettings.height * 2}
    {else}
        {$zoomImageWidth = 1220}
        {$zoomImageHeight = 1220}
    {/if}

    {$crop = "fill"}
    {if isset($partialSettings) && isset($partialSettings.crop)}
        {$crop = $partialSettings.crop}
    {elseif !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
        {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
    {/if}


    {***  Use Id to associate the element (thru 'useZoom') to specific Cloud Zoom instance. ***}
    {if isset($partialSettings) && isset($partialSettings.id)}
        {$partialSettings.useZoom = $partialSettings.id}
        {$zoomId = $partialSettings.id}
        {$sliderId = $partialSettings.id}
    {else}
        {$partialSettings.useZoom = "#cloud-{$product->Id}"}
        {$zoomId = "cloud-{$product->Id}"}
        {$sliderId = $product->Id}
    {/if}


    {*** Build the ZoomSlider thingy ***}
    <div id="template-myCloudZoom-{$sliderId}" class="product-image">
        {*** Get information for the first image ***}
        {$first = $items->getData()}
        {$first = $first[0]}

        {$partialSettings.zoomImage = $first->thumbnail($zoomImageWidth, $zoomImageHeight, $crop, $template.watermark)|solutionPath}
        {$fancyImage = $first->thumbnail(null, null, false, $template.watermark)|solutionPath}

        {$alt = $alt|escape:'html'}

        <div>
            <img class="responsive cloudzoom"
                 itemprop="image"
                 data-cloudzoom='{json_encode($partialSettings)}'
                 data-index="0"
                 src="{$first->thumbnail($itemWidth, $itemHeight, $crop, $template.watermark)|solutionPath}"
                 alt="{$alt}"
                 id="{$zoomId}">

            {$fancyArray = [
                'href' => $fancyImage,
                'title'=> "{$alt|utf8_encode}",
                'type' => 'image'
            ]}
        </div>

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

            <div id="slider-{$sliderId}" class="thumbelina-wrapper {$buttonClasses|implode:' '}" style="opacity:0;position:relative;height: {$thumbHeight+2|cat:"px"};">
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

                    {$fancyArray = []}

                    {*** Run thru all images and list for zoomslider to use ***}
                    {foreach $items->getData() as $item}
                        {*** Define width and height used in thumbnail ***}
                        {$itemSrc = $item->thumbnail($itemWidth, $itemHeight, $crop, $template.watermark)|solutionPath}
                        {$fancyImage = $item->thumbnail(null, null, false, $template.watermark)|solutionPath}
                        {$thumbSrc = $item->thumbnail($thumbWidthResolution, $thumbHeightResolution, $crop)|solutionPath}

                        {$itemData = [
                            "image"                 =>  $itemSrc,
                            "useZoom"               =>  $partialSettings.useZoom,
                            "zoomImage"             =>  $item->thumbnail($zoomImageWidth, $zoomImageHeight, $crop, $template.watermark)|solutionPath
                        ]}

                        {*** Slider item image ***}
                        <li style="width: {$thumbWidth+2}px;" class="item">
                            <img class="cloudzoom-gallery"
                                 style="width: 100%"
                                 itemprop="image"
                                 data-cloudzoom='{json_encode($itemData)}'
                                 data-fileid="{$item->Id}"
                                 data-index="{$item@index}"
                                 src="{$thumbSrc}"
                                 alt="{$alt}"
                            >
                        </li>

                        {$fancyArray[] = [
                            'href' => $fancyImage,
                            'title'=> "{$alt|utf8_encode}",
                            'type' => 'image'
                        ]}
                    {/foreach}
                </ul>
            </div>
        {/if}
    </div>

    {strip}
    <script>
    ;(function (){
        var images = {$fancyArray|json_encode};
        var _load{$sliderId} = function(){
            CloudZoom.quickStart();

            {*** Only activate image changer, if there is actually more then one picture ***}
            {if $items->getActualSize() gt 1}
            $('#slider-{$sliderId}').fadeTo(300, 1);
            {/if}

            $("#template-myCloudZoom-{$sliderId} .right").click(function(){
                $("#template-myCloudZoom-{$sliderId} .owl-carousel").trigger('owl.next');
            });

            $("#template-myCloudZoom-{$sliderId} .left").click(function(){
                $("#template-myCloudZoom-{$sliderId} .owl-carousel").trigger('owl.prev');
            });

            {***  Bind a click event to a Cloud Zoom instance. ***}
            $('#{$zoomId}').on('click', function(){
                var cloudZoom = $(this).data('CloudZoom'),
                    idx = $(".cloudzoom-gallery").index( $(".cloudzoom-gallery-active") );

                idx = idx === -1 ? 0 : idx;

                cloudZoom.closeZoom();
                {literal}$.fancybox.open(images, $.extend({index: idx}, window.platform.fancybox.settingsDefault));{/literal}
                return false;
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
{elseif isset($defaultImage)}
    <div class="product-image">
        <img class="responsive" src="{$defaultImage}" alt="">
    </div>
{/if}
