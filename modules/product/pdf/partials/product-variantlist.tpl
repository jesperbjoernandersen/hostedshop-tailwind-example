{*

# Description
Constructs the product's variant list

## Date last modified
2021-08-24

*}

{*** Variant collection ***}
{collection assign=variants controller=productVariant productId=$product->Id}

{if $variants->getActualSize() gt 0}

    {controller assign=imageController type=files}

    {* Placeholder image *}
    {placeholdImage 
        assign=placeholder 
        width=100 
        height=100 
        background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR 
        color=$template.settings.FONT_COLOR_PRIMARY 
        text=$text.IMAGE_PLACEHOLDER_TEXT}

    {* Visible price *}
    {$priceSetting = $settings.shop_b2b_hidden_prices}

    {$showPrices = true}
    {if $priceSetting === true && empty($user)}
        {$showPrices = false}
    {/if}

    {* Product buyable - Assume that buyable is the same as show prices at first *}
    {$buyableProduct = $showPrices}

    {* Perform checks against the product to verify *}
    {if $buyableProduct}
        {* User check (we only need check for "partly" while the FALSE check is performed for $showPrices) *}
        {if $priceSetting === "partly" && empty($user)}
            {$buyableProduct = false}
        {* Call for price check *}
        {elseif $product->CallForPrice}
            {$buyableProduct = false}
        {/if}
    {/if}

    <h2>{$text.PRODUCT_CATALOG_PRODUCT_VARIANTS}</h2>
    <hr>

    {$list = []}

    {foreach $variants->getData() as $variant}

        {$variantRow = ['cells' => []]}

        {*** VariantType collection - all types associated with product ***}
        {collection assign=variantTypes controller=productVariantType productId=$product->Id variantId=$variant->Id}

        {*** Get prices for variant ***}
        {collection assign=price controller=productPrice productId=$product->Id variantId=$variant->Id productDiscountGroupId=$product->DiscountGroupId}

        {* Variant title array, used to concat together all variations (variants types titles) of the product variant *}
        {$variantTitle = []}
        {$variantTitleRaw = []}

        {* Construct variant titles *}
        {foreach $variantTypes->getData() as $variantType}
            {*** Get the data for the varianttype ***}
            {entity assign=variantData controller=productVariantData productId=$product->Id variantId=$variant->Id typeId=$variantType->Id}

            {*** Put up a small color swatch or image ***}
            {$variantDecoration = ""}

            {*** Display variant data image if present ***}
            {entity assign=variantDataImage controller=files type=variantdata id=$variantData->Id}
            {if $variantDataImage}
                {$variantDecoration = "<img src='{$variantDataImage->thumbnail(30,30)|solutionPath}'>"}
            {*** Otherwise display variant data color if present ***}
            {elseif !empty($variantData->Color)}
                {$variantDecoration = "<i class='square' style='background: #{$variantData->Color};'></i>"}
            {/if}

            {*** Build the title ***}
            {$variantTitle[] = "<p><strong class='variant-type'>{$variantType->Title}</strong>: {$variantDecoration} {$variantData->Title}</p>"}

            {*** Build the raw title ***}
            {$variantTitleRaw[] = $variantData->Title}
        {/foreach}

        {* Build the variant *}
        {entity assign=variantImage controller=files type=variant productId=$product->Id variantId=$variant->Id}

        {if !$variantImage}
            {entity assign=variantImage controller=files type=product productId=$product->Id}
        {/if}

        {if $variantImage}
            {$variantImageSrc = $variantImage->thumbnail(75, 75, 'fill')|solutionPath}
        {else}
            {$variantImageSrc = $placeholder->getRelativeFile()|solutionPath}
        {/if}
        {function productHTML}
            <div class="flex-row">
                <img src="{$variantImageSrc}" alt="{implode($variantTitleRaw, ',')}">
                <div class="title-cell">
                    <p>{implode($variantTitle)}</p>
                    {* Product number / model number *}
                    {if !empty($variant->ItemNumber) && {$settings.shop_product_number}}
                        <p class="variant-item-number">
                            <strong>{$text.PRODUCT_CATALOG_PRODUCT_NUMBER} </strong>
                            {$variant->ItemNumber}
                        </p>
                    {/if}
                </div>
            </div>
        {/function}
        {$variantRow.cells[] = {productHTML}}
        
        {*** Price Line ***}
        {function pricesHTML}
            {if $showPrices}
                {if $product->CallForPrice}
                    <p class="call-for-price">{$text.PRODUCT_CATALOG_CALL_FOR_PRICE}</p>
                {else}
                    {foreach $price->getData() as $priceDataInterval}
                        <p class="price">
                            {if $priceDataInterval->Amount > 1}
                                {$text.PRODUCT_CATALOG_PRICE_FOR}&nbsp;{$priceDataInterval->Amount}&nbsp;{$productController->getUnitTitle($item->UnitId)}
                            {/if}

                            {if $priceDataInterval->PriceMin !== $priceDataInterval->PriceMax}
                                {$text.PRODUCT_CATALOG_PRICE_FROM}&nbsp;
                            {/if}

                            {$priceDataInterval->PriceMin|formatPrice}

                            {if $priceDataInterval->PriceMin < $priceDataInterval->FullPriceMin}
                                {* Price before discount *}
                                &nbsp;<s>{$priceDataInterval->FullPriceMin|formatPrice}</s>
                            {/if}
                        </p>
                    {/foreach}

                    {* VAT *}
                    {if $settings.shop_product_tax_after_price}
                        <p class="price-vat">
                            {if $currency.hasVat && ($settings.vat_label_advanced == false || $priceDataInterval->PriceMinWithVat > $priceDataInterval->PriceMinWithoutVat)}
                                {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
                            {else}
                                {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
                            {/if}
                        </p>
                    {/if}
                {/if}
            {/if}
        {/function}
        {$variantRow.cells[] = {pricesHTML}}

        {$list[] = $variantRow}
    {/foreach}

    {*** Make table ***}
    {include 
        file="modules/product/pdf/partials/table-list.tpl" 
        name="variant-table"
        list=$list}
{/if}
