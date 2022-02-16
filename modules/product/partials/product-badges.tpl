{*

# Description
Template partial for product badges. Part of the Product page type.


## Date last modified
2019-01-14


## Primary variables
+ $product                                                              - Entity of productController (the current product)
+ $variant                                                              - Entity of variantController (the current variant)
+ $priceInterval                                                        - Entity of productPriceController (price lines for selected product)
+ $text                                                                 - Global scope variable containing translations
+ $settings                                                             - Global scope variable containing platform settings


## Partials (templates)
No extra templates required for this template

*}


{* Product splashes, news, discount and sold out *}

{if $settings.show_product_icons && $product->Type ne 'discontinued'}
<div class="splash m-product-splash">
    {*** NEW icon if newer than 30 days ***}
    {if $product->Age lt 2592000}
        <span class="badge badge-succes m-product-splash-new">{$text.NEWS}</span>
    {/if}

    {*** DISCOUNT icon if discount it active ***}
    {if !$product->CallForPrice and $priceInterval->PriceMin < $priceInterval->FullPriceMin}
        <span class="badge badge-warning m-product-splash-sale">{$text.SALE}</span>
    {/if}

    {*** SOLD OUT icon if not in stock ***}
    {if ($product->Soldout || $variant && $variant->Soldout) and !$product->AllowOutOfStockPurchase}
        <span class="badge badge-danger m-product-splash-soldout">{$text.SOLD_OUT}</span>
    {/if}
</div>
{/if}
