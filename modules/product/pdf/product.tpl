{*

# Description
Creates alle information related to the product

## Date last modified
2021-08-24

*}

{controller type=product assign=productController primary=true}
{entity assign=product controller=$productController}

{* Product additionals *}
{collection assign=additionals controller=productAdditionalType productId=$product->Id}

{* Has additionals *}
{$hasAdditionals = false}
{if $additionals->getActualSize() > 0}
    {$hasAdditionals = true}
{/if}

{if isset($smarty.get.variantId)}
    {* Get the variant based on GET param *}
    {entity assign=variant controller=productVariant productId=$product->Id variantId=(int)$smarty.get.variantId}

    {if $variant}
        {collection assign=variantTypes controller=productVariantType productId=$product->Id}

        {foreach $variantTypes->getData() as $variantType}
            {entity assign=variantData controller=productVariantData productId=$product->Id variantId=$variant->Id typeId=$variantType->Id}
            {$title = "$title `$variantData->Title`"}
        {/foreach}
    {/if}
{/if}
<main class="product">
    <style>
        .product {
            display: grid;
            grid-template-columns: 1fr 1fr;
            flex: 1;
        }
        .product-info {
            grid-area: auto / span 2;
        }
        .product-short-info {
            padding-right: 5px;
        }
        .square {
            width: 10px;
            height: 10px;
            border-radius: 3px;
            display: inline-block;
            border: 1px solid #777;
        }
    </style>

    <div class="product-short-info">

        <h1>{$product->Title}</h1>
        <hr>

        {include file="modules/product/pdf/partials/product-price.tpl" product=$product}

        {if !empty($product->ProducerId)}
            {entity assign=brand controller=brand id=$product->ProducerId}
            {entity assign=brandImage controller=files type=brand id=$brand->Id}
            {if $brandImage}
                <img class="brand-logo" src="{$brandImage->thumbnail(100, 100)|solutionPath}" alt="{$brand->Title}">
            {else}
                <p class="brand-text">{$brand->Title}</p>
            {/if}
        {/if}

        {*** Product number  ***}
        {if !empty($item->ItemNumber) and $settings.shop_product_number}
            <h3>
                <strong>{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</strong>
                {$item->ItemNumber}
            </h3>
        {/if}

        <div class="short-description ck-content">
            {$productController->getDescriptionShort($product->Id)}
        </div>
    </div>

    {include file="modules/product/pdf/partials/product-images.tpl" product=$product}

    <div class="product-info">
        {include file="modules/product/pdf/partials/product-additionals.tpl" product=$product}
    </div>
</main>

