{*

# Description
Template for a single Product. Part of the Product page type.
The template uses microdata to enhance the markup.


# Date last modified
2021-12-01


## Primary variables
+ $controller                                                           - Instance of productController
+ $variantController                                                    - Instance of variantController
+ $item                                                                 - Entity of productController
+ $category                                                             - Entity of productCategoryController (main category of selected product (inherited from product.tpl))
+ $prices                                                               - Entity of productPriceController (price lines for selected product)
+ $additionals                                                          - Collection of productAdditionalTypeController
+ $brand                                                                - Entity of brandController
+ $text                                                                 - Global scope variable containing translations
+ $user                                                                 - Global scope variable containing user data
+ $settings                                                             - Global scope variable containing platform settings
+ $columns                                                              - Global scope variable containing columns


## Partials (templates)
+ "/modules/product/partials/entity-navigation.tpl"                     - Partial template for product navigation (next, previous, pdf, send to friend)
+ "/modules/product/partials/product-badges.tpl"                        - Partial template for product badges
+ "/modules/product/partials/entity-image.tpl"                          - Partial template for product image
+ "/modules/product/partials/entity-reviews-stars.tpl"                  - Partial template for product views as stars
+ "/modules/product/partials/entity-giftcard.tpl"                       - Partial template for product gift cards
+ "/modules/product/partials/entity-actions.tpl"                        - Partial template for product actions (amount and buy button)
+ "/modules/product/partials/entity-packet-product.tpl"                 - Partial template for packet products
+ "/modules/product/partials/entity-variant-dropdown.tpl"               - Partial template for the product variant type dropdown
+ "/modules/product/partials/entity-variant-buttons.tpl"                - Partial template for the product variant type buttons
+ "/modules/product/partials/entity-variant-orderlist.tpl"              - Partial template for the product variant type orderlist
+ "/modules/product/partials/entity-variant-orderlist-dropdown.tpl"     - Partial template for the product variant type orderlist dropdown
+ "/modules/product/partials/entity-additionals.tpl"                    - Partial template for additional products
+ "/modules/product/partials/entity-additional-info.tpl"                - Partial template for additional product info (social media, tags ...)
+ "/modules/widgets/login/login.tpl"                                    - Login widget, for log in
+ "/modules/widgets/slider/slider.tpl"                                  - Image slider widget, for blog post picture

*}

{* Preload related entities to optimize load times *}
{include file='modules/product/product-entity-preload.tpl' scope=parent}

{*** Setup some collections and controllers we need later ***}

{* Variant controller *}
{controller assign=variantController type=productVariant}

{* Master title *}
{$title = $item->Title}

{* Has preselected variant *}
{$hasVariant = false}

{if isset($smarty.get.variantId)}

    {* Get the variant based on GET param *}
    {entity assign=variant controller=productVariant productId=$item->Id variantId=(int)$smarty.get.variantId}

    {* Get the variant price *}
    {collection assign=prices controller=productPrice productId=$item->Id variantId=(int)$smarty.get.variantId}

    {if $variant}
        {$hasVariant = true}

        {collection assign=variantTypes controller=productVariantType productId=$item->Id}

        {foreach $variantTypes->getData() as $variantType}
            {entity assign=variantData controller=productVariantData productId=$item->Id variantId=$variant->Id typeId=$variantType->Id}
            {$title = "$title `$variantData->Title`"}
        {/foreach}
    {/if}
{else}
    {* Product price data *}
    {collection assign=prices controller=productPrice productId=$item->Id}
{/if}

{* Priceintervals *}
{$priceData = $prices->getData()}
{$priceInterval = $priceData[0]}

{addMeta property="product:product_link" content=$page.url}

{* Product additionals *}
{collection assign=additionals controller=productAdditionalType productId=$item->Id}

{* Has additionals *}
{$hasAdditionals = false}
{if $additionals->getActualSize() > 0}
    {$hasAdditionals = true}
{/if}

{* Placeholder image *}
{placeholdImage assign=placeholder width=400 height=400 background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}

{* Single product entity with microdata markup *}
<div class="modules m-product trailing-trip" itemscope itemtype="http://schema.org/Product" data-controller="{$item->Id}">
    {*** PRODUCT PAGE NAVIGATION (NEXT, PREV, PRINT, PDF, SEND LINK) ***}
    {include file="modules/product/partials/entity-navigation.tpl" product=$item productController=$controller}
    {*** end: PRODUCT PAGE NAVIGATION (NEXT, PREV, PRINT, PDF, SEND LINK) ***}

    {if $hasVariant && !empty($variant->Ean)}
        {addMeta property="product:ean" content=$variant->Ean}
        <meta itemtype="http://schema.org/gtin" itemprop="gtin" content="{$variant->Ean}">
    {elseif !empty($item->Ean)}
        {addMeta property="product:ean" content=$item->Ean}
        <meta itemtype="http://schema.org/gtin" itemprop="gtin" content="{$item->Ean}">
    {/if}

    {if $category && $category->Title}
        <meta itemprop="category" content="{$category->Title}">
    {/if}

    {if $googleCategoryId = $controller->googleCategory($product->Id)}
        {addMeta property="product:category" content=$googleCategoryId}
    {/if}

    {*** If both columns are present, we want the pictures to jump below the content, to get more space ***}
    {if $columns === 2}
        {$productEntityClass = "col-s-4 col-m-12 col-l-12 col-xl-12"}
    {else}
        {$productEntityClass = "col-s-4 col-m-6 col-l-6 col-xl-12"}
    {/if}

    {* Product *}
    <form action="/actions/cart/add" method="post" name="cartadd">
        <div class="row">
            {* Product first column, contains social media and images *}
            <div class="{$productEntityClass}">
                <figure class="image m-product-image">

                    {* Product splashes, news, discount and sold out *}
                    {include file="modules/product/partials/product-badges.tpl" product=$item priceInterval=$priceInterval}

                    {*** Define the picture rotation ***}
                    {if $settings.shop_product_image_structure === "rotation"}
                        {*** Slider settings to show the images of this article ***}
                        {*** Based on Slider widget ***}
                        {$crop = "fill"}
                        {if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
                            {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
                        {/if}
                        {$imageSettings = [
                            "theme"                 => "product-slider-theme",
                            "slider"                => "single",
                            "pagination"            => "false",
                            "nav"                   => "true",
                            "stopOnHover"           => "true",
                            "crop"                  => $crop,
                            "width"                 => 790,
                            "height"                => 790,
                            "thumbHeight"           => 75,
                            "thumbWidth"            => 75,
                            "thumbHeightResolution" => 250,
                            "thumbWidthResolution"  => 250

                        ]}

                        {*** Include the slider template and send along the settings and information to fetch from the filesController ***}
                        {include file="modules/product/partials/entity-image-rotation.tpl" partialSettings=$imageSettings type=product id=$item->Id defaultImage="{$placeholder->thumbnail(null, null, false, $template.watermark)|solutionPath}" alt=$title}
                    {else}
                        {*** imageElement settings to show the images of this product ***}
                        {*** Based on Cloudzoom script ***}
                        {$imageSettings = [
                            "autoInside"            => 959,
                            "zoomPosition"          => "inside",
                            "disableOnScreenWidth"  => 959,
                            "maxMagnification"      => 8,
                            "minMagnification"      => 1,
                            "startMagnification"    => 2,
                            "width"                 => 790,
                            "height"                => 790,
                            "thumbHeight"           => 75,
                            "thumbWidth"            => 75,
                            "thumbHeightResolution" => 250,
                            "thumbWidthResolution"  => 250

                        ]}

                        {*** Include product image for zoom setting ***}
                        {include file="modules/product/partials/entity-image-zoom.tpl" partialSettings=$imageSettings id=$item->Id defaultImage="{$placeholder->thumbnail(null, null, false, $template.watermark)|solutionPath}" alt=$title}

                        {*** Add in assets ***}
                        {addLink href="{$template.cdn}/_design/common/libs/cloudzoom/latest/cloudzoom.css" relative=true}
                        {addScript src="{$template.cdn}/_design/common/libs/cloudzoom/latest/cloudzoom.js" relative=true}
                    {/if}
                </figure>
            </div>{* END: col-6 *}
            <div class="{$productEntityClass}">
                {* Product content *}
                <div class="m-product-information product-information" id="zoomHook">
                    {* Headline for the product *}
                    <header class="m-product-title page-title"><h1 class="m-product-title product-title" itemprop="name">{$title}</h1></header>

                    <div itemscope itemprop="offers" itemtype="http://schema.org/Offer" class="m-product-offer">
                        {*** General check if "Sold out" text should be shown ***}
                        {$showSoldOut = ($item->Soldout and !$item->AllowOutOfStockPurchase)}

                        {*** SEO Microdata ( has to be inside http://schema.org/Offer ) ***}
                        <link itemprop="url" href="{$page.url}" />
                        <meta itemprop="itemCondition" content="new">
                        <meta itemprop="name" content="{$title}">

                        {*** Check that the general setting of delivery_time is honored for microdata ***}
                        {if $settings.shop_product_delivery_time}
                            {if in_array($item->Type, ["giftcard","codegiftcard","filesale"])}
                                <link itemprop="availability" href="http://schema.org/OnlineOnly" />
                            {elseif $item->Type === "discontinued"}
                                <link itemprop="availability" href="http://schema.org/Discontinued" />
                            {elseif $showSoldOut}
                                <link itemprop="availability" href="http://schema.org/OutOfStock" />
                            {else}
                                <link itemprop="availability" href="http://schema.org/InStock" />
                            {/if}
                        {/if}

                        {if in_array($item->Type, ["giftcard","codegiftcard"]) && (((!$settings.shop_b2b_hidden_prices or $user) or $settings.shop_b2b_hidden_prices === "partly") and $item->Type !== 'discontinued')}
                            <div class="m-product-offers">
                                <meta itemprop="priceCurrency" content="{$general.currencyIso}">
                                {addMeta property="product:price:currency" content=$general.currencyIso}

                                <meta itemprop="price" content="100">
                                {addMeta property="product:price:amount" content='100'}
                            </div>
                        {/if}

                        {*** Product is discontinued ***}
                        {if $item->Type === "discontinued" or $showSoldOut}
                            <div class="panel panel-danger panel-rounded m-product-discontinued">
                                <div class="panel-body">
                                    {if $item->Type === "discontinued"}<div><span>{$text.CART_PRODUCT_DEAD_NOTE}</span></div>{/if}
                                    {if $showSoldOut}<div><span>{$text.PRODUCT_CATALOG_PRODUCT_SOLDOUT}</span></div>{/if}
                                </div>
                            </div>
                        {/if}

                        {* Display 'log in to order' if B2B login is not required for Product price display but required for purchace and a B2B user is not logged in *}
                        {if $item->Type !== 'discontinued' and (($settings.shop_b2b_hidden_prices === 'partly' and !$user) or ($settings.shop_b2b_hidden_prices and !$user) or $item->CallForPrice)}
                            <div class="panel panel-warning panel-rounded m-product-warnings">
                                <div class="panel-body">
                                    {if !$user}
                                        {if $settings.shop_b2b_hidden_prices === 'partly'}
                                        <span class="m-product-b2b m-product-b2b-hidden-order is-block"><i class="fa fa-exclamation"></i> {$text.PRODUCT_CATALOG_PRODUCT_PRICE_B2B_PARTLY}</span>
                                        {/if}

                                        {if $settings.shop_b2b_hidden_prices === true}
                                        <span class="m-product-b2b m-product-b2b-hidden-prices is-block"><i class="fa fa-exclamation"></i> {$text.PRODUCT_CATALOG_PRODUCT_PRICE_B2B_PARTLY}</span>
                                        {/if}
                                    {/if}

                                    {if $item->CallForPrice}
                                    <span class="m-product-callForPrice is-block"><i class="fa fa-phone"></i> <span class="m-product-callForPrice-text">{$text.PRODUCT_CATALOG_CALL_FOR_PRICE}</span></span>
                                    {/if}
                                </div>
                            </div>
                        {/if}

                        {* Display price for product except for types giftcard and codegiftcard, taking into account user settings for b2b *}
                        {if !in_array($item->Type, ["giftcard", "codegiftcard"]) and (((!$settings.shop_b2b_hidden_prices or $user) or $settings.shop_b2b_hidden_prices === "partly") and $item->Type !== 'discontinued')}
                            <div class="m-product-offers">
                                <meta itemprop="priceCurrency" content="{$general.currencyIso}">
                                {addMeta property="product:price:currency" content=$general.currencyIso}
                                {*** Hide price, if item is a call for price item ***}
                                {if !$item->CallForPrice}

                                    {$hasVatIncludedLabel = false}

                                    {*** SEO Microdata ***}

                                    {*** Setting up and printing out price and pricelines ***}
                                    {foreach $priceData as $priceDataInterval}
                                        {if $priceDataInterval@iteration === 1}
                                            {$hasVatIncludedLabel = $currency.hasVat and ($settings.vat_label_advanced eq false or $priceDataInterval->PriceMinWithVat gt $priceDataInterval->PriceMinWithoutVat)}
                                            <meta itemprop="price" content="{$priceDataInterval->PriceMin|formatPriceMeta}">
                                            {addMeta property="product:price:amount" content=$priceDataInterval->PriceMin|formatPriceMeta}
                                            <p>
                                        {/if}
                                        {if $priceDataInterval@iteration === 2 and $prices->getActualSize() gt 1}<p>{/if}
                                        <span class="is-block m-product-priceline">
                                            {if $prices->getActualSize() gt 1 or $priceDataInterval->Amount gt 1}
                                                <span class="m-product-price-for">{$text.PRODUCT_CATALOG_PRICE_FOR} {$priceDataInterval->Amount} {$controller->getUnitTitle($item->UnitId)}</span>
                                            {/if}

                                            {if $priceDataInterval->PriceMin !== $priceDataInterval->PriceMax}
                                                <span class="m-product-price-from">{$text.PRODUCT_CATALOG_PRICE_FROM}</span>
                                            {/if}

                                            <span class="h4 m-product-price" >{$priceDataInterval->PriceMin|formatPrice}</span>

                                            {if $priceDataInterval->PriceMin lt $priceDataInterval->FullPriceMin}
                                                {* Price before discount *}
                                                <span class="h5"><s class="m-product-price-before-discount">{$priceDataInterval->FullPriceMin|formatPrice}</s></span>
                                            {/if}
                                        </span>
                                        {if $priceDataInterval@iteration === 1}</p>{/if}
                                        {if $priceDataInterval@last and $prices->getActualSize() gt 1}</p>{/if}
                                    {/foreach}

                                    {* VAT *}
                                    {if $settings.shop_product_tax_after_price}
                                    <span class="is-block m-product-price-vat">
                                        {if $hasVatIncludedLabel}
                                            <span class="m-product-price-vat-text has-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</span>
                                        {else}
                                            <span class="m-product-price-vat-text has-novat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</span>
                                        {/if}
                                    </span>
                                    {/if}

                                    {* Viabill price tag *}
                                    {include file="modules/widgets/integrations/viabill_pricetag.tpl" type="product" price=$priceDataInterval->PriceMin}

                                    {* Suggested retail price *}
                                    {if $item->GuidelinePrice gt 0}
                                    <p>
                                        <span class="m-product-price-suggested">{$text.PRODUCT_CATALOG_PRICE_LIST} {$item->GuidelinePrice|formatPrice}</span>
                                        {if $settings.shop_product_tax_after_price or (!$currency.hasVat and $settings.shop_product_lineprice_vat)}
                                            {if $hasVatIncludedLabel or $settings.shop_product_lineprice_vat}
                                                <span class="m-product-price-vat-text has-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</span>
                                            {else}
                                                <span class="m-product-price-vat-text has-novat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</span>
                                            {/if}
                                        {/if}
                                    </p>
                                    {/if}

                                    <div class="m-product-extra trailing">
                                        {*** Fees ***}
                                        {if $shop.priceTerms}
                                            <span class="is-block m-product-price-terms"><a data-fancybox="" href="#overlaypriceTerms">{$text.PRODUCT_CATALOG_SHOW_DELIVERY_LINK}</a></span>
                                        {/if}

                                        {*** Payment options ***}
                                        <span class="m-product-paymentoptions">
                                            {include file="modules/product/partials/entity-paymentoptions.tpl" controller=$controller price=$priceData.0->PriceMin}
                                        </span>
                                    </div>
                                {/if}
                            </div>
                        {/if}
                    </div>

                    {* Brand for the product *}
                    {if $item->ProducerId}

                        {entity assign=brand controller=brand id=$item->ProducerId}
                        {if !empty($brand)}

                            {addMeta property="product:brand" content=$brand->Title}

                            {entity assign=brandImage controller=files type=brand id=$brand->Id}

                            {$brandLink = "/{$page.paths.0}/?brand={$brand->Id}-{$brand->Title|formatLink}"}
                            <p class="m-product-brand" itemprop="brand" itemscope itemtype="http://schema.org/Brand">
                                <a class="m-product-brand-link {if $brandImage} placeholder-wrapper {/if}" data-placeholder-max-width="100px" itemprop="url" href="{$brandLink}" title="{$text.PRODUCT_CATALOG_BRAND}: {$brand->Title}">
                                    {if $brandImage}
                                      <span class="placeholder"></span>
                                      {img class="m-product-brand-icon m-product-brand-logo" style="vertical-align:middle;margin:0;" itemprop="logo" src="{$brandImage->thumbnail(100,100)|solutionPath}" alt="{$brand->Title}"}
                                      <meta itemprop="name" content="{$brand->Title}" />
                                    {else}
                                        <span class="m-product-brand-text" itemprop="name">{$brand->Title}</span>
                                    {/if}
                                </a>
                            </p>
                        {/if}
                    {/if}

                    {*** Include quick-rating as part of the reviews module ***}
                    {if $settings.module_shop_review_products_type !== "comment" and $settings.module_shop_review_products and $access.reviews}
                        {*** Reviews stars ***}
                        {include file="modules/product/partials/entity-reviews-stars.tpl" type="quick-rating" product=$item}
                    {/if}

                    {* Product short description *}
                    {*** Get description data ***}
                    {$descriptionShort = $controller->getDescriptionShort($item->Id)}
                    <div class="m-description-short-wrap{if empty($descriptionShort)} is-hidden" data-controller="description--wrap-short{/if}">
                        <div itemprop="description" class="m-product-short-description clearfix" data-controller="description--short">
                            {$descriptionShort}
                        </div>
                    </div>


                    {*** PRODUCT GIFTCARD ***}
                    {if in_array($item->Type, ["giftcard","codegiftcard"])}
                        {* Seperator *}
                        {include file="modules/product/partials/entity-giftcard.tpl" productController=$controller variantController=$variantController product=$item hasAdditionals=$hasAdditionals}
                    {/if}
                    {*** end: PRODUCT GIFTCARD ***}

                    {if $settings.shop_product_number}
                        {$sku = $item->ItemNumber}
                        {if $hasVariant && !empty($variant->ItemNumber)}
                            {$sku = $variant->ItemNumber}
                        {/if}
                        {if !empty($sku)}
                            <meta itemprop="sku" content="{$sku}">
                        {/if}
                    {/if}

                    {*** PRODUCT INFOMATION ***}
                    {if !in_array($item->Type, ['variant','discontinued'])}

                        {if $settings.shop_product_weight and !empty($item->Weight) and $item->Weight !== 0}
                            {addMeta property="product:weight:value" content=$item->Weight}
                            {addMeta property="product:weight:units" content="kg"}
                        {/if}

                        {* Seperator *}
                        {if ($settings.shop_product_weight and !empty($item->Weight) and $item->Weight !== 0) or (!empty($item->ItemNumber) and $settings.shop_product_number)}

                        <div class="panel panel-warning panel-rounded m-product-info">
                            <div class="panel-body">
                                {* if the product number / model number is defined print it *}
                                {if !empty($item->ItemNumber) and $settings.shop_product_number}
                                <div class="m-product-itemNumber">
                                    <strong class="m-product-itemNumber-text">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</strong>
                                    <span class="m-product-itemNumber-value">{$item->ItemNumber}</span>
                                </div>
                                {/if}

                                {*** Product weight ***}
                                {if $settings.shop_product_weight and !empty($item->Weight) and $item->Weight !== 0}
                                <div class="m-product-weight">
                                    <strong class="m-product-weight-text">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT}:</strong>
                                    <span class="m-product-weight-value">{$item->Weight|formatNumber}</span>
                                    <span class="m-product-weight-unitTitle">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT}</span>
                                </div>
                                {/if}
                            </div>
                        </div>
                        {/if}

                        {*** Include product stock information ***}
                        {if $item->Type !== "packet"}
                            {include file="modules/product/partials/entity-stock.tpl"}
                        {/if}
                    {/if}

                    {*** Include product actions; buy and amount ***}
                    {if !$showSoldOut and !in_array($item->Type, ['variant','packet','discontinued']) and !$hasAdditionals}
                        {include file="modules/product/partials/entity-actions.tpl" product=$item inputName="product[{$item->Id}][amount]" inputValue=$item->MinAmount data=""}
                    {/if}

                    {*** PRODUCT PRODUCT PACKET ***}
                    {if $item->Type === "packet"}
                        {* Seperator *}
                        {include file="modules/product/partials/entity-packet-product.tpl" productController=$controller variantController=$variantController product=$item hasAdditionals=$hasAdditionals}
                    {*** end: PRODUCT PACKET ***}

                    {*** PRODUCT VARIANTS OF THE TYPE PRESELECT ***}
                    {elseif $hasVariant}
                        {include file="modules/product/partials/entity-variant-preselect.tpl" hasAdditionals=$hasAdditionals}
                    {else}
                        {*** PRODUCT VARIANTS OF THE TYPE DROPDOWN ***}
                        {if $item->VariantDisplayMode === "dropdown"}
                            {include file="modules/product/partials/entity-variant-dropdown.tpl" productController=$controller variantController=$variantController product=$item hasAdditionals=$hasAdditionals}
                        {*** end: PRODUCT VARIANTS OF THE TYPE DROPDOWN ***}

                        {*** PRODUCT VARIANTS OF THE TYPE BUTTONS ***}
                        {elseif $item->VariantDisplayMode === "buttons"}
                            {include file="modules/product/partials/entity-variant-buttons.tpl" productController=$controller variantController=$variantController product=$item  hasAdditionals=$hasAdditionals}
                        {/if}
                        {*** end: PRODUCT VARIANTS OF THE TYPE BUTTONS ***}
                    {/if}
                </div>
                {* Product content end *}
            </div>
        </div>

        {if !$hasVariant}
            <div class="row">
                <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                    {*** PRODUCT VARIANTS OF THE TYPE ORDERLIST ***}
                    {if $item->VariantDisplayMode === "orderlist"}
                        {include file="modules/product/partials/entity-variant-orderlist.tpl" productController=$controller variantController=$variantController product=$item hasAdditionals=$hasAdditionals}
                    {/if}
                    {*** end: PRODUCT VARIANTS OF THE TYPE ORDERLIST ***}


                    {*** PRODUCT VARIANTS OF THE TYPE ORDERLIST DROPDOWN ***}
                    {if $item->VariantDisplayMode === "orderlist-dropdown"}
                        {include file="modules/product/partials/entity-variant-orderlist-dropdown.tpl" productController=$controller variantController=$variantController product=$item hasAdditionals=$hasAdditionals}
                    {/if}
                    {*** end: PRODUCT VARIANTS OF THE TYPE ORDERLIST ***}
                </div>{* END: .col-24 *}
            </div>{* END: .row *}
        {/if}

        {*** PRODUCT ADDITION BUY ***}
        {if $hasAdditionals}
        <div class="row">
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
            {include file="modules/product/partials/entity-additionals.tpl"
                product=$item
                productController=$controller
                additionals=$additionals
                justBuy=in_array($item->VariantDisplayMode, ['orderlist', 'orderlist-dropdown'])}
            </div>{* END: .col-24 *}
        </div>{* END: .row *}
        {/if}
        {*** end: PRODUCT ADDITION BUY ***}
    </form>

    {*** ADDITIONAL INFORMATION FOR PRODUCT ***}
    {include file="modules/product/partials/entity-additional-info.tpl" productController=$controller product=$item}
    {*** end: ADDITIONAL INFORMATION FOR PRODUCT ***}

    {*** Checkout widget: Modal ***}
    {include file='modules/widgets/checkout/checkout.tpl' displayOnly=modal}

</div>{* end: Product container *}

{if $settings.product_related !== false and $access.relatedProducts}
{* Productlist:Related Products *}
    {collection assign=relatedProducts controller=productRelated productId=$item->Id orderBy='Sorting,-Sold,Title'}
    {if $settings.product_related !== "chosen" and $relatedProducts->getActualSize() === 0}
        {collection assign=relatedProducts controller=productList categoryId=$item->CategoryId ignoreProductId=$item->Id orderBy='Sorting,-Sold,Title' pageSize=4}
    {/if}
    {if $relatedProducts->getActualSize() gt 0}
    <div class="products-related">
        <div class="page-title products-related">
            <p class="h1 products-related-headline">{$text.PRODUCT_CATALOG_RELATED_HEADLINE}</p>
        </div>
        <div class="products-related-list">
            {include file='modules/product/product-list-combined.tpl' onlyProducts=true productlist=$relatedProducts->filter('Sorting,-Sold,Title')}
        </div>
    </div>
    {/if}
{* end: Productlist:Related Products *}
{/if}

{if $settings.product_also_bought}
{* Productlist: Alsobought Products *}
    {collection assign=alsoboughtProducts controller=productAlsoBought productId=$item->Id pageSize=4}
    {if $alsoboughtProducts->getActualSize() gt 0}
    <div class="products-also-bought">
        <div class="page-title products-also-bought">
            <p class="h1 products-also-bought-headline">{$text.PRODUCT_CATALOG_ALSO_BOUGHT_HEADLINE}</p>
        </div>
        <div class="products-also-bought-list">
            {include file='modules/product/product-list-combined.tpl' onlyProducts=true productlist=$alsoboughtProducts->filter('Sorting,-Sold,Title')}
        </div>
    </div>
    {/if}
{* end: Productlist: Alsobought Products *}
{/if}

{if !isset($user)}
<div id="modal" class="container" style="display: none;">
    {include file="modules/widgets/login/login.tpl" modalBtnClose="true" modalGoto="{$page.request}"}
</div>
{/if}
