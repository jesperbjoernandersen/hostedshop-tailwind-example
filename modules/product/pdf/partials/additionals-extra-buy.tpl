{*

# Description
Creates all lists from product extra buy section

## Date last modified
2021-08-24

*}

{*** Product extra buy ***}
{collection assign=extraBuyCategories controller=productExtraBuyCategory productId=$product->Id}

{*** test value for ExtraBuy ***}
{$hasExtraBuy = false}
{foreach $extraBuyCategories->getData() as $ebc}
    {collection assign=extraBuys controller=productExtraBuy productId=$product->Id categoryId=$ebc->Id}
    {if $extraBuys && $extraBuys->getActualSize() > 0}
        {$hasExtraBuy = true}
        {break}
    {/if}
{/foreach}

{if !isset($productController)}
    {controller assign=productController type=product}
{/if}

{*** Controller for additionals ***}
{controller assign=additionalsController type=productAdditionalType}

{*** Extra buy products for product ***}
{if $hasExtraBuy}
    <h2>{$text.PRODUCT_CATALOG_EXTRABUY}</h2>
    <hr>

    {* Additional sales module *}
    {foreach $extraBuyCategories->getData() as $ebc}
        {collection assign=extraBuys controller=productExtraBuy productId=$product->Id categoryId=$ebc->Id}
        {if $extraBuys->getActualSize()}
            
            {* Hide price *}
            {$cartPriceText = (!$settings.shop_b2b_hidden_prices || $settings.shop_b2b_hidden_prices === "partly")
                ? $text.CART_PRICE 
                : '&nbsp;'
            }

            {$list[] = [
                'isHead' => true,
                'cells' => ["{$text.EXTRABUY_CATEGORY}: {$ebc->Title}"]
            ]}

            {* Collection of extrabuys based on extrabuy category *}
            {* Placeholder image *}
            {placeholdImage 
                assign=placeholder 
                width=600 
                height=600 
                background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR 
                color=$template.settings.FONT_COLOR_PRIMARY 
                text=$text.IMAGE_PLACEHOLDER_TEXT
            }
            {* Loop accesories *}
            {foreach $extraBuys->getData() as $extraBuy}

                {$extraBuyRow = [ 'cells' => [] ]}

                {* Category entity *}
                {entity assign=category controller=productCategory type=category id=$extraBuy->CategoryId}

                {* Price collection *}
                {collection assign=prices controller=productPrice productId=$extraBuy->Id}
                {$priceData = $prices->getData()}
                {$priceInterval = array_pop($priceData)}

                {function productHTML}
                    {entity assign=extraBuyImage controller=files type=product productId=$extraBuy->Id}
                    {if !$extraBuyImage}
                        {entity assign=extraBuyImage controller=files type=product productId=$product->Id}
                    {/if}
                    <div class="flex-row">
                        {if $extraBuyImage}
                            <img src="{$extraBuyImage->thumbnail(75, 75, 'fill')|solutionPath}" alt="{$extraBuy->Title}">
                        {else}
                            <img src="{$placeholder->getRelativeFile()|solutionPath}" alt="{$extraBuy->Title}">
                        {/if}

                        <div class="title-cell">
                            {* Title *}
                            {$extraBuy->Title}

                            {* Product number / unit id *}
                            {if $extraBuy->MinAmount > 1}
                                <small>{$text.MINIMUM_BUY}: {$extraBuy->MinAmount} {$productController->getUnitTitle($extraBuy->UnitId)}</small>
                            {/if}
                        </div>
                    </div>
                {/function}
                {$extraBuyRow.cells[] = {productHTML}}

                {function priceHTML}
                    {if !in_array($extraBuy->Type, ["giftcard", "codegiftcard", "discontinued"]) && ((!$settings.shop_b2b_hidden_prices || $user) || $settings.shop_b2b_hidden_prices === "partly")}
                        {if $extraBuy->CallForPrice}
                            <p class="call-for-price">{$text.PRODUCT_CATALOG_CALL_FOR_PRICE}</p>
                        {else}
                            {* Price calculation of Product *}
                            {$priceData = $prices->getData()}

                            {*** Only show price from ***}
                            {if count($priceData) > 1}
                                {$priceData = [$priceData.0]}
                            {/if}

                            {foreach $priceData as $priceDataInterval}
                                <p>
                                    {if $prices->getActualSize() > 1 || $priceDataInterval->Amount > 1}
                                        {$text.PRODUCT_CATALOG_PRICE_FOR} {$priceDataInterval->Amount} {$controller->getUnitTitle($product->UnitId)}
                                    {/if}

                                    {if $priceDataInterval->PriceMin !== $priceDataInterval->PriceMax}
                                        {$text.PRODUCT_CATALOG_PRICE_FROM} 
                                    {/if}

                                    {$priceDataInterval->PriceMin|formatPrice} 

                                    {if $priceDataInterval->PriceMin < $priceDataInterval->FullPriceMin}
                                        {* Price before discount *}
                                        - <s>{$priceDataInterval->FullPriceMin|formatPrice}</s>
                                    {/if}
                                </p>
                            {/foreach}

                            {* VAT *}
                            {if $settings.shop_product_tax_after_price}
                                <p>
                                    {if $currency.hasVat && ($settings.vat_label_advanced eq false || $priceDataInterval->PriceMinWithVat > $priceDataInterval->PriceMinWithoutVat)}
                                        {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
                                    {else}
                                        {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
                                    {/if}
                                </p>
                            {/if}
                        {/if}
                    {else}
                        &nbsp;
                    {/if}
                {/function}
                {$extraBuyRow.cells[] = {priceHTML}}

                {$list[] = $extraBuyRow}
            {/foreach}
        {/if}
    {/foreach}

    {*** Make table ***}
    {include 
        file="modules/product/pdf/partials/table-list.tpl" 
        name="extra-buy-table"
        list=$list}
{/if}
    