{*

# Description
Template partial for the extrabuy products. Part of the Product page type.


## Date last modified
2020-10-05


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $extraBuyCategories                                                   - Collection of productExtraBuyCategoryController
+ $extraBuys                                                            - Collection of productExtraBuyController
+ $category                                                             - Entity of productCategoryController
+ $prices                                                               - Collection of productPriceController
+ $extraBuyImage                                                        - Entity of fileController with type product
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{if !isset($productController)}
    {controller assign=productController type=product}
{/if}

{* Controller for additionals *}
{controller assign=additionalsController type=productAdditionalType}


{* Additional sales module *}
{* Additional sales for the product *}
<div class="m-options m-extrabuy m-product-extrabuy">
    {foreach $extraBuyCategories->getData() as $ebc}
        <div class="panel panel-border" id="m-product-extrabuy-{$ebc->Id}">
            {* Additional sales title *}
            <div class="panel-heading m-product-extrabuy-heading-all">
                <p class="h5 m-product-extrabuy-title"><span class="m-product-extrabuy-category">{$text.EXTRABUY_CATEGORY}:</span> <span class="m-product-extrabuy-text">{$ebc->Title}</span></p>
            </div>{* END: .panel-heading *}

            <div class="panel-heading is-hidden-s m-product-extrabuy-heading-large">
                <div class="row">
                    <div class="col-s-4 col-m-5 col-l-3 col-xl-10 m-product-extrabuy-heading-product">
                        <span class="h6">{$text.CART_PRODUCTS}</span>
                    </div>
                    <div class="col-s-3 col-m-7 col-l-9 col-xl-14">
                        <div class="row">
                            <div class="col-s-4 col-m-4 col-l-4 col-xl-8 m-product-extrabuy-heading-price">
                                {if (!$settings.shop_b2b_hidden_prices or $settings.shop_b2b_hidden_prices === "partly")}
                                <span class="h6">{$text.CART_PRICE}</span>
                                {else}
                                    &nbsp;
                                {/if}
                            </div>
                            <div class="col-s-4 col-m-4 col-l-4 col-xl-4 m-product-extrabuy-heading-note {if ($user or !$settings.shop_b2b_hidden_prices)}{else}pull-right{/if}">
                                <span class="h6">{$text.CART_NOTE}</span>
                            </div>
                            {if $user or !$settings.shop_b2b_hidden_prices}
                            <div class="col-s-4 col-m-4 col-l-4 col-xl-12 text-right m-product-extrabuy-heading-count">
                                <span class="h6">{$text.CART_COUNT}</span>
                            </div>
                            {/if}
                        </div>{* END: .row *}
                    </div>{* END: .col-10 *}
                </div>{* END: .row *}
            </div>{* END: .panel-heading *}

            <ul class="list-unstyled t-striped m-product-extrabuy-list">

                {* Collection of extrabuys based on extrabuy category *}
                {collection assign=extraBuys controller=productExtraBuy productId=$product->Id categoryId=$ebc->Id}
                {* Placeholder image *}
                {placeholdImage assign=placeholder width=600 height=600 background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}
                {* Loop accesories *}
                {foreach $extraBuys->getData() as $extraBuy}

                    {* Category entity *}
                    {entity assign=category controller=productCategory type=category id=$extraBuy->CategoryId}

                    {* Price collection *}
                    {collection assign=prices controller=productPrice productId=$extraBuy->Id}
                    {$priceData = $prices->getData()}
                    {$priceInterval = array_pop($priceData)}
                    <li class="m-product-extrabuy-list-item">
                        <form action="/actions/cart/add" method="post" name="prodadd">
                            <div class="row" itemprop="isAccessoryOrSparePartFor" itemscope itemtype="http://schema.org/Product">
                                <div class="col-s-4 col-m-3 col-l-12 col-xl-6 col-m-push-2 col-xl-push-4 m-product-extrabuy-heading">
                                    {* Title *}
                                    <div class="h6">
                                        {* Link *}
                                        <a href="{$productController->link($extraBuy->Id)}" itemprop="url" class="m-product-extrabuy-link">
                                            {* Productname *}
                                            <span class="m-product-extrabuy-title" itemprop="name">{$extraBuy->Title}</span>
                                        </a>
                                    </div>


                                    {* Product number / unit id *}
                                    {if $extraBuy->MinAmount gt 1}
                                    <small class="is-block variantMinAmount">
                                        <span>{$text.MINIMUM_BUY}: {$extraBuy->MinAmount} {$productController->getUnitTitle($extraBuy->UnitId)}</span>
                                    </small>
                                    {/if}
                                </div>

                                <div class="col-s-2 col-m-2 col-l-2 col-xl-4 col-m-pull-3 col-xl-pull-6 m-product-extrabuy-figure-wrap">
                                    <figure class="variantImage image trailing m-product-extrabuy-figure">
                                    {* Get the item image *}
                                    {entity assign=extraBuyImage controller=files type=product productId=$extraBuy->Id}
                                    {if !$extraBuyImage}
                                        {entity assign=extraBuyImage controller=files type=product productId=$product->Id}
                                    {/if}

                                    {if $extraBuyImage}
                                        <a href="{$extraBuyImage->thumbnail()|solutionPath}" class="m-product-extrabuy-link placeholder-wrapper" data-placeholder-max-width="100%" data-fancybox="" data-fancybox-group="extrabuy" title="{$extraBuy->Title}">
                                            <span class="placeholder"></span>
                                            {img src="{$extraBuyImage->thumbnail(100, 100, 'fill')|solutionPath}" class="responsive m-product-extrabuy-image" alt="{$extraBuy->Title}"}
                                        </a>
                                    {else}
                                        <a href="{$placeholder->getRelativeFile()|solutionPath}" class="m-product-extrabuy-link" data-fancybox="" data-fancybox-group="extrabuy" title="{$extraBuy->Title}">
                                            {img placeholder="{$placeholder->getRelativeFile()|solutionPath}" class="responsive m-product-extrabuy-image" alt="{$extraBuy->Title}"}
                                        </a>
                                    {/if}
                                    </figure>
                                </div>


                                <div class="col-s-2 col-m-2 col-l-4 col-xl-5 m-product-extrabuy-data">
                                    {* Price information *}
                                    {if !in_array($extraBuy->Type, ["giftcard","codegiftcard","discontinued"]) and ((!$settings.shop_b2b_hidden_prices or $user) or $settings.shop_b2b_hidden_prices === "partly")}
                                        {if $extraBuy->CallForPrice}
                                            <p class="m-product-extrabuy-callForPrice"><span class="m-product-extrabuy-callForPrice-text">{$text.PRODUCT_CATALOG_CALL_FOR_PRICE}</span></p>
                                        {else}
                                            {* Price calculation of Product *}
                                            <div class="m-product-extrabuy-offers">
                                                {$priceData = $prices->getData()}

                                                {*** Only show price from ***}
                                                {if count($priceData) > 1}
                                                    {$priceData = [$priceData.0]}
                                                {/if}

                                                {foreach $priceData as $priceDataInterval}
                                                    {if $priceDataInterval@iteration===1}<p>{/if}
                                                    {if $priceDataInterval@iteration===2 and $prices->getActualSize() gt 1}<p>{/if}
                                                    <span class="is-block m-product-extrabuy-priceLine">
                                                        {*if $prices->getActualSize() gt 1 or $priceDataInterval->Amount gt 1}
                                                            <span class="m-product-extrabuy-price-for">{$text.PRODUCT_CATALOG_PRICE_FOR} {$priceDataInterval->Amount} {$controller->getUnitTitle($product->UnitId)}</span>
                                                        {/if*}

                                                        {if $priceDataInterval->PriceMin!==$priceDataInterval->PriceMax}
                                                            <span class="m-product-extrabuy-price-from">{$text.PRODUCT_CATALOG_PRICE_FROM}</span>
                                                        {/if}

                                                        <span class="m-product-extrabuy-price">{$priceDataInterval->PriceMin|formatPrice}</span>

                                                        {if $priceDataInterval->PriceMin lt $priceDataInterval->FullPriceMin}
                                                            {* Price before discount *}
                                                            - <s class="m-product-extrabuy-price-before-discount">{$priceDataInterval->FullPriceMin|formatPrice}</s>
                                                        {/if}
                                                    </span>
                                                    {if $priceDataInterval@iteration===1}</p>{/if}
                                                    {if $priceDataInterval@last and $prices->getActualSize() gt 1}</p>{/if}
                                                {/foreach}

                                                {* VAT *}
                                                {if $settings.shop_product_tax_after_price}
                                                <p class="m-product-extrabuy-vat">
                                                    {if $currency.hasVat and ($settings.vat_label_advanced eq false or $priceDataInterval->PriceMinWithVat gt $priceDataInterval->PriceMinWithoutVat)}
                                                        <span class="is-block m-product-extrabuy-price-vat-text has-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</span>
                                                    {else}
                                                        <span class="is-block m-product-extrabuy-price-vat-text has-novat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</span>
                                                    {/if}
                                                </p>
                                                {/if}
                                            </div>
                                        {/if}
                                    {else}
                                        &nbsp;
                                    {/if}
                                </div>

                                <div class="col-s-2 col-m-2 col-l-2 col-xl-3 m-product-extrabuy-info {if ($user or !$settings.shop_b2b_hidden_prices)}{else}pull-right{/if}">
                                    <div class="row">
                                        {* Stock information *}
                                        {if $settings.shop_product_delivery_time}
                                            <p class="{if $extraBuy->Soldout}m-product-extrabuy-instock{else}m-product-extrabuy-soldout{/if} m-product-extrabuy-stock m-product-stock">
                                            {if $extraBuy->Soldout}
                                                {*** Check if we should show a icon ***}
                                                {if $settings.shop_product_delivery_time==="texticon"}
                                                    <i class="fa fa-fw fa-clock-o"></i>
                                                {/if}

                                                {*** CHeck if we should use the default or a custom oder text ***}
                                                {if $extraBuy->DeliveryTimeId <= 0}
                                                    <span class="m-product-extrabuy-instock-message m-product-stock-message has-nocount">{$text.PRODUCT_CATALOG_STOCK_NOT_HOME}</span>
                                                {else}
                                                    <span class="m-product-extrabuy-instock-message m-product-stock-message is-custom">{$productController->getDeliveryTime($extraBuy->DeliveryTimeId, false)}</span>
                                                {/if}
                                            {else}
                                                {if $settings.shop_product_delivery_time==="texticon"}
                                                    <i class="fa fa-fw fa-check"></i>
                                                {/if}

                                                {*** Check if we should use the default or a custom oder text ***}
                                                {if $extraBuy->DeliveryTimeId===0 and !in_array($extraBuy->Type, ['packet','variant'])}
                                                    <span class="m-product-extrabuy-instock-count m-product-stock-count">{$extraBuy->Stock - $extraBuy->StockReservation}</span>
                                                    <span class="m-product-extrabuy-instock-unit m-product-stock-unit">{$productController->getUnitTitle($extraBuy->UnitId)}</span>
                                                    <span class="m-product-extrabuy-instock-message m-product-stock-message is-withcount">{$text.PRODUCT_CATALOG_STOCK_HOME|lower}</span>
                                                {else if $extraBuy->DeliveryTimeId===-1 or $extraBuy->Type==='packet'}
                                                    <span class="m-product-extrabuy-instock-message m-product-stock-message has-nocount">{$text.PRODUCT_CATALOG_STOCK_HOME}</span>
                                                {else}
                                                    <span class="m-product-extrabuy-instock-message m-product-stock-message is-custom">{$productController->getDeliveryTime($extraBuy->DeliveryTimeId, true)}</span>
                                                {/if}
                                            {/if}
                                            </p>
                                        {else}
                                            &nbsp;
                                        {/if}

                                        {* Show weight *}
                                        {if $settings.shop_product_weight and !empty($extraBuy->weight) and $extraBuy->weight!==0}
                                        <p class="m-product-extrabuy-weight extraBuyWeight">
                                            <span class="m-product-extrabuy-weight-text">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT}:</span>
                                            <span class="m-product-extrabuy-weight-value">{$extraBuy->Weight|formatNumber}</span>
                                            <span class="m-product-extrabuy-weight-unitTitle">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT}</span>
                                        </p>
                                        {/if}
                                    </div>
                                </div>

                                {if !$extraBuy->CallForPrice and ($user or !$settings.shop_b2b_hidden_prices)  and !$extraBuy->Type!=="discontinued"}
                                <div class="col-s-4 col-m-3 col-l-4 col-xl-6 m-product-extrabuy-transaction m-product-transaction">
                                        {$isDisabled = ""}
                                        {if $extraBuy->Stock < $extraBuy->MinAmount and $extraBuy->DisableOnEmpty}
                                            {$isDisabled = " is-disabled"}
                                        {/if}

                                        {* Product additionals *}
                                        {collection assign=additionals controller=$additionalsController productId=$extraBuy->Id}
                                        {* Has additionals *}
                                        {$hasAdditionals = false}
                                        {if $additionals->getActualSize() > 0}
                                           {$hasAdditionals = true}
                                        {/if}

                                        {* If the extraBuy product contains variants or additionals, or if the product is sold out, link to the extraBuy instead of sell it directly, because the product page will inform of delivery times and the cart will reject it anyway *}
                                        {$buyable = true}

                                        {if $extraBuy->Type !== "normal" and $extraBuy->Type !== "filesale"}
                                            {$buyable = false}

                                        {elseif $hasAdditionals}
                                            {$buyable = false}

                                        {elseif !$extraBuy->AllowOutOfStockPurchase and $extraBuy->Soldout}
                                            {$buyable = false}
                                        {/if}

                                        {if $buyable}
                                            <fieldset class="form-group m-product-extrabuy-amount">
                                                <div class="input-group xsmall {$isDisabled}">
                                                    <input name="product[{$extraBuy->Id}][amount]" title="{$text.INSERT_AMOUNT}" class="form-input input-group-main m-product-extrabuy-input" type="text" pattern="[0-9]*" value="{$extraBuy->ExtraBuyAmount}">
                                                    <span class="input-group-addon m-product-extrabuy-unitTitle">{translation id=$extraBuy->UnitId module='unit' title='title'}</span>
                                                </div>
                                            </fieldset>

                                            {* Call-to-action *}
                                            <button role="button" type="submit" class="is-block button-primary button-icon xsmall pull-right m-product-extrabuy-button"><i class="fa fa-shopping-cart"></i>{$text.PRODUCT_CATALOG_PRODUCT_BUY}</button>
                                        {else}
                                            <a class="button-primary is-block button-icon xsmall pull-right m-product-extrabuy-link" role="button" href="{$productController->link($extraBuy->Id, false, $extraBuy)}"><i class="fa fa-share"></i>{$text.PRODUCT_CATALOG_PRODUCT_SHOW}</a>
                                        {/if}
                                </div>
                                {/if}
                            </div>{* END: .row *}
                        </form>
                    </li>
                {/foreach}
            </ul>{* END: .list-unstyled *}
        </div>
    {/foreach}
</div>{* END: .m-options *}

{* Additional sales end *}
