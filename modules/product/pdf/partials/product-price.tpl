{*

# Description
Prints out the main product's price/pricelines

## Date last modified
2021-08-24

*}

{collection assign=prices controller=productPrice productId=$product->Id}

{if $product->CallForPrice}
    <h3 class="call-for-price"><strong>{$text.PRODUCT_CATALOG_CALL_FOR_PRICE}</strong></h3>
{else}
    <style>
        .priceline {
            margin-bottom: 1em;
        }
        .priceline h3 {
            display: inline;
            font-weight: 600;
        }
        .priceline .price {
            font-weight: 500;
        }
        .priceline s {
            color: #777;
        }
    </style>
    {*** Setting up && printing out price && pricelines ***}
    {foreach $prices->getData() as $priceDataInterval}
        {if $priceDataInterval@iteration === 1}
            {$hasVatIncludedLabel = $currency.hasVat && ($settings.vat_label_advanced == false || $priceDataInterval->PriceMinWithVat > $priceDataInterval->PriceMinWithoutVat)}
        {/if}
        <div class="priceline">
            {if $prices->getActualSize() > 1 || $priceDataInterval->Amount > 1}
                <h3 class="price-for">{$text.PRODUCT_CATALOG_PRICE_FOR} {$priceDataInterval->Amount} {$productController->getUnitTitle($product->UnitId)}</h3>
            {/if}

            {if $priceDataInterval->PriceMin !== $priceDataInterval->PriceMax}
                <h3 class="price-from">{$text.PRODUCT_CATALOG_PRICE_FROM}: </h3>
            {/if}

            <h3 class="price">{$priceDataInterval->PriceMin|formatPrice}</h3>

            {if $priceDataInterval->PriceMin < $priceDataInterval->FullPriceMin}
                {* Price before discount *}
                <s class="price-discount">{$priceDataInterval->FullPriceMin|formatPrice}</s>
            {/if}
        </div>
    {/foreach}
{/if}

{* Suggested retail price *}
{if $product->GuidelinePrice > 0}
<p>
    {$text.PRODUCT_CATALOG_PRICE_LIST} {$product->GuidelinePrice|formatPrice} 
    {if $settings.shop_product_tax_after_price || (!$currency.hasVat && $settings.shop_product_lineprice_vat)}
        {if $hasVatIncludedLabel || $settings.shop_product_lineprice_vat}
            {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
        {else}
            {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
        {/if}
    {/if}
</p>
{/if}