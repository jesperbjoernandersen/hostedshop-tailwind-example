{*

# Description
Template partial for the variant type of a product with the displaymode of orderlist. Part of the Product page type.


## Date last modified
2020-10-05


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $variantController                                                    - Instance of productVariantController
+ $imageController                                                      - Instance of fileController
+ $hasAdditionals                                                       - Boolean telling if product has additional products
+ $variants                                                             - Entity of productVariantController (variant for the current product)
+ $variantTypes                                                         - Collection of productVariantTypeController
+ $price                                                                - Collection of productPriceController
+ $variantData                                                          - Collection of productVariantDataController
+ $variantImage                                                         - Entity of fileController with type variant
+ $variantTypes                                                         - Collection of the productVariantTypeController
+ $text                                                                 - Global scope variable containing translations
+ $settings                                                             - Global scope variable containing platform settings
+ $user                                                                 - Global scope variable containing user data


## Partials (templates)
+ "/modules/product/partials/entity-actions.tpl"                        - Partial template for product actions (amount and buy button)

*}


{*** Variant collection ***}
{collection assign=variants controller=productVariant productId=$product->Id}

{*** FIles controller ***}
{controller assign=imageController type=files}

{* Placeholder image *}
{placeholdImage assign=placeholder width=600 height=600 background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}


{*** Check if there are any variants else abort ***}
{if $variants->getActualSize() gt 0}

    {* Preload related entities to optimize load times *}
    {include file='modules/product/partials/entity-variant-orderlist-preload.tpl' scope=parent}

    {* Visible price *}
    {setting assign=priceSetting key=shop_b2b_hidden_prices}

    {$showPrices = true}
    {if $priceSetting === true and empty($user)}
        {$showPrices = false}
    {/if}

    {* Product buyable - Assume that buyable is the same as show prices at first *}
    {$buyableProduct = $showPrices}

    {* Perform checks against the product to verify *}
    {if $buyableProduct}

        {* User check (we only need check for "partly" while the FALSE check is performed for $showPrices) *}
        {if $priceSetting === "partly" and empty($user)}
            {$buyableProduct = false}

        {* Call for price check *}
        {elseif $product->CallForPrice}
            {$buyableProduct = false}

        {/if}
    {/if}

    <div class="m-product-variants m-orderform m-product-orderform">
        <div class="panel panel-border">
            <div class="m-order-form m-product-orderform-wrap">
                <div class="panel-heading">
                    <span class="h4 orderformTitle m-product-orderform-title">{$product->Title}</span>
                </div>{* END: .panel-heading *}
                <div class="panel-heading m-product-orderform-heading">
                    <div class="row">
                        <div class="col-s-4 col-m-2 col-l-2 col-xl-3 m-product-orderform-heading-all m-product-orderform-heading-product">
                            <span class="h6">{$text.CART_PRODUCTS}</span>
                        </div>
                        <div class="col-s-3 col-m-10 col-l-10 col-xl-21 is-hidden-s  m-product-orderform-heading-large">
                            <div class="row">
                                <div class="col-s-4 col-m-3 col-l-3 col-xl-6 m-product-orderform-heading-spacer">
                                    &nbsp;
                                </div>
                                <div class="col-s-4 col-m-3 col-l-3 col-xl-7 m-product-orderform-heading-price">
                                    <span class="h6">{$text.CART_PRICE}</span>
                                </div>
                                <div class="col-s-4 col-m-3 col-l-3 col-xl-5  m-product-orderform-heading-note">
                                    <span class="h6">{$text.CART_NOTE}</span>
                                </div>
                                <div class="col-s-4 col-m-3 col-l-3 col-xl-6 m-product-orderform-heading-count">
                                    <span class="h6">{$text.CART_COUNT}</span>
                                </div>
                            </div>{* END: .row *}
                        </div>{* END: .col-10 *}
                    </div>{* END: .row *}
                </div>{* END: .panel-heading *}

                <ul class="list-unstyled t-striped m-product-orderform-list">
                {foreach $variants->getData() as $variant}

                    {*** VariantType collection - all types associated with product ***}
                    {collection assign=variantTypes controller=productVariantType productId=$product->Id variantId=$variant->Id}
                    {*** Get prices for variant ***}
                    {collection assign=price controller=productPrice productId=$product->Id variantId=$variant->Id productDiscountGroupId=$product->DiscountGroupId}

                    {*** Pull first priceinterval ***}
                    {$priceData = $price->getData()}

                    {*** Variant title array, used to concat together all variations (variants types titles) of the product variant ***}
                    {$variantTitle = []}
                    {$variantTitleRaw = []}

                    {*** Variant soldout calculation ***}
                    {$variantInStock = $variant->Stock >= $variant->MinAmount}
                    {$variantSoldout = !$product->AllowOutOfStockPurchase and !$variantInStock}

                    {*** Iterate over the types to get all their data ***}
                    {foreach $variantTypes->getData() as $variantType}
                        {*** Get the data for the varianttype ***}
                        {entity assign=variantData controller=productVariantData productId=$product->Id variantId=$variant->Id typeId=$variantType->Id}

                        {*** Put up a small color swatch or image ***}
                        {$variantDecoration = ""}

                        {*** Display variant data image if present ***}
                        {entity assign=variantDataImage controller=files type=variantdata id=$variantData->Id}
                        {if $variantDataImage}
                            {$variantDecoration = "<img src='{$variantDataImage->thumbnail(30,30)|solutionPath}' class='reset'>"}
                        {*** Otherwise display variant data color if present ***}
                        {elseif !empty($variantData->Color)}
                            {$variantDecoration = "<span class='variantColor fa fa-square' style='color: #{$variantData->Color};'></span>"}

                        {/if}

                        {*** Build the title ***}
                        {$variantTitle[] = "<span class='is-block variantInfo'><strong class='variantType'>{$variantType->Title}</strong>: {$variantDecoration} <span class='variantDataTitle'>{$variantData->Title}</span></span>"}

                        {*** Build the raw title ***}
                        {$variantTitleRaw[] = "{$variantData->Title}"}
                    {/foreach}

                    {* Build the variant *}
                    <li class="m-product-orderform-list-item">
                        <div class="row">
                            <div class="col-s-1 col-m-2 col-l-2 col-xl-3 m-product-orderform-figure-wrap">
                                <figure class="variantImage image m-product-orderform-figure">
                                    {* Get the item image *}
                                    {entity assign=variantImage controller=files type=variant productId=$product->Id variantId=$variant->Id}

                                    {if !$variantImage}
                                        {entity assign=variantImage controller=files type=product productId=$product->Id}
                                    {/if}

                                    {if $variantImage}
                                        {$variantImageSrc = $variantImage->thumbnail(100)|solutionPath}
                                    {else}
                                        {$variantImageSrc = $placeholder->getRelativeFile()|solutionPath}
                                    {/if}

                                    <a href="{$page.request}?variantId={$variant->Id}" class="m-product-orderform-link is-block" title="{implode($variantTitleRaw, ',')}">
                                        <img src="{$variantImageSrc}" class="responsive m-product-orderform-image" style="margin-bottom:0;" alt="{implode($variantTitleRaw, ',')}">
                                        </a>
                                </figure>
                            </div>
                            <div class="col-s-3 col-m-10 col-l-10 col-xl-21 m-product-orderform-data">
                                <div class="row">
                                    <div class="col-s-4 col-m-3 col-l-3 col-xl-6">
                                        <p class="variantTitle m-product-orderform-title">
                                            <a href="{$page.request}?variantId={$variant->Id}" class="m-product-orderform-link is-block" title="{implode($variantTitleRaw, ',')}">
                                            {* write the title *}
                                            {implode($variantTitle)}
                                            </a>
                                        </p>

                                        {* if the product number / model number is defined print it *}
                                        {if !empty($variant->ItemNumber) and {$settings.shop_product_number}}
                                        <p class="variantItemNumber m-product-orderform-itemNumber"><span class="m-product-orderform-itemNumber-text">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</span> <span class="m-product-orderform-itemNumber-value">{$variant->ItemNumber}</span></p>
                                        {/if}


                                        {* Variant number / unit id *}
                                        {if $variant->MinAmount gt 1}
                                        <p class="variantMinAmount m-product-orderform-variantMinAmount">
                                            <small><span class="m-product-orderform-minAmount-text">{$text.MINIMUM_BUY}:</span> <span class="m-product-orderform-minAmount-count">{$variant->MinAmount}</span> <span class="m-product-orderform-minAmount-unitTitle">{$productController->getUnitTitle($variant->UnitId)}</span></small>
                                        </p>
                                        {/if}
                                    </div>
                                    <div class="col-s-4 col-m-3 col-l-3 col-xl-7 m-product-orderform-offer">
                                    {if $showPrices}
                                        {if $product->CallForPrice}
                                            <p class="m-product-orderform-callForPrice"><span class="m-product-orderform-text">{$text.PRODUCT_CATALOG_CALL_FOR_PRICE}</span></p>
                                        {else}
                                            {* Price calculation of Product *}
                                            <div class="m-product-orderform-priceline">

                                                {*** Setting up and printing out price and pricelines ***}
                                                {foreach $priceData as $priceDataInterval}
                                                    {if $priceDataInterval@iteration === 1}<p>{if $price->getActualSize() gt 1}<strong>{/if}{/if}
                                                    {if $priceDataInterval@iteration === 2 and $price->getActualSize() gt 1}<p>{/if}
                                                        <span class="is-block m-product-orderform-priceline">
                                                            {if  $priceDataInterval->Amount gt 1}
                                                                <span class="m-product-orderform-price-for">{$text.PRODUCT_CATALOG_PRICE_FOR} {$priceDataInterval->Amount} {$productController->getUnitTitle($item->UnitId)}</span>
                                                            {/if}

                                                            {if $priceDataInterval->PriceMin !== $priceDataInterval->PriceMax}
                                                                <span class="m-product-orderform-price-from">{$text.PRODUCT_CATALOG_PRICE_FROM}</span>
                                                            {/if}

                                                            <span class="m-product-orderform-price">{$priceDataInterval->PriceMin|formatPrice}</span>

                                                            {if $priceDataInterval->PriceMin lt $priceDataInterval->FullPriceMin}
                                                                {* Price before discount *}
                                                                <small><s class="m-product-orderform-before-discount">{$priceDataInterval->FullPriceMin|formatPrice}</s></small>
                                                            {/if}
                                                        </span>
                                                    {if $priceDataInterval@iteration === 1}</p>{if $price->getActualSize() gt 1}</strong>{/if}{/if}
                                                    {if $priceDataInterval@last and $price->getActualSize() gt 1}</p>{/if}
                                                {/foreach}

                                                {* VAT *}
                                                {if $settings.shop_product_tax_after_price}
                                                    <div class="m-product-orderform-price-vat">
                                                        {if $currency.hasVat and ($settings.vat_label_advanced eq false or $priceDataInterval->PriceMinWithVat gt $priceDataInterval->PriceMinWithoutVat)}
                                                            <span class="m-product-price-vat-text has-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</span>
                                                        {else}
                                                            <span class="m-product-price-vat-text has-novat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</span>
                                                        {/if}
                                                    </div>
                                                {/if}
                                            </div>
                                        {/if}
                                    {else}
                                    &nbsp;
                                    {/if}
                                    </div>

                                    <div class="col-s-4 col-m-3 col-l-3 col-xl-5 m-product-orderform-info">
                                        {if $variantSoldout}
                                            <p class="panel-danger m-product-orderform-soldout m-product-stock m-product-orderform-stock" style="background-color:transparent;">{$text.SOLD_OUT}</p>
                                        {/if}
                                        {if $settings.shop_product_delivery_time}
                                            <p class="{if $variantInStock}panel-success m-product-orderform-instock{else}panel-danger m-product-orderform-soldout{/if} m-product-stock m-product-orderform-stock" style="background-color:transparent;">
                                            {if $variantInStock}
                                                {if $settings.shop_product_delivery_time==="texticon"}
                                                    <i class="fa fa-fw fa-check"></i>
                                                {/if}
                                                {if $variant->DeliveryTimeId===0}
                                                    <span class="m-product-orderform-instock-count m-product-stock-count">{$variant->Stock - $variant->StockReservation}</span>
                                                    <span class="m-product-orderform-instock-unit m-product-stock-unit">{$productController->getUnitTitle($variant->UnitId)}</span>
                                                    <span class="m-product-orderform-instock-message m-product-stock-message is-withcount">{{$text.PRODUCT_CATALOG_STOCK_HOME}|lower}</span>
                                                {else if $variant->DeliveryTimeId===-1}
                                                    <span class="m-product-orderform-instock-message m-product-stock-message has-nocount">{{$text.PRODUCT_CATALOG_STOCK_HOME}}</span>
                                                {else}
                                                    <span class="m-product-orderform-instock-message m-product-stock-message is-custom">{$productController->getDeliveryTime($variant->DeliveryTimeId, true)}</span>
                                                {/if}
                                            {else}
                                                {if {$settings.shop_product_delivery_time}==="texticon"}
                                                    <i class="fa fa-fw fa-clock-o"></i>
                                                {/if}
                                                {if $variant->DeliveryTimeId <= 0}
                                                    <span class="m-product-orderform-soldout-message m-product-stock-message has-nocount">{$text.PRODUCT_CATALOG_STOCK_NOT_HOME}</span>
                                                {else}
                                                    <span class="m-product-orderform-soldout-message m-product-stock-message is-custom">{$productController->getDeliveryTime($variant->DeliveryTimeId, false)}</span>
                                                {/if}
                                            {/if}
                                            </p>
                                        {else}
                                            &nbsp;
                                        {/if}

                                        {* Show weight *}
                                        {if {$settings.shop_product_weight} and !empty($variant->Weight) and $variant->Weight!==0}
                                        <p class="m-product-orderform-weight variantWeight">
                                            <span class="m-product-orderform-weight-text">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT}:</span>
                                            <span class="m-product-orderform-weight-value">{$variant->Weight|formatNumber}</span>
                                            <span class="m-product-orderform-weight-unitTitle">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT}</span>
                                        </p>
                                        {/if}
                                    </div>

                                    <div class="col-s-4 col-m-3 col-l-3 col-xl-6 is-block-s m-product-orderform-transaction m-product-transaction product-transaction">

                                        {* Assume that buyable is the same as the $buyableProduct at first *}
                                        {$buyableVariant = $buyableProduct}

                                        {* Perform stock status check against the specific variant to verify buyable status *}
                                        {if $buyableVariant and $variantSoldout}
                                            {$buyableVariant = false}
                                        {/if}
                                    {if $buyableVariant}
                                        <fieldset class="form-group m-product-orderform-transaction-amount">
                                            <input type="hidden" name="product[{$product->Id}][variant][]" value="{$variant->Id}">
                                            <div class="input-group xsmall">
                                                <input class="form-input input-group-main m-product-transaction m-product-orderform-transaction-input" data-product-minAmount="{$variant->MinAmount}" name="variant[{$variant->Id}][amount]" data-product="count" type="text" pattern="[0-9]*" value="0">
                                                <span class="input-group-button"><button data-product="subtract" class="button m-product-orderform-transaction-add" type="button"><span class="fa fa-minus"></span></button></span>
                                                <span class="input-group-button"><button data-product="add" class="button m-product-orderform-transaction-subtract" type="button"><i class="fa fa-plus"></i></button></span>
                                            </div>
                                        </fieldset>
                                    {/if}
                                    </div>{* END: .col-10 *}
                                </div>{* END: .row *}
                            </div>{* END: .col-10 *}
                        </div>{* END: .row *}
                    </li>
                {/foreach}
                </ul>{* END: .list-unstyled.t-striped *}


                {* remove button if hasAdditionals or buy is disabled *}
                {if !$product->CallForPrice and !$hasAdditionals and ($user or !$settings.shop_b2b_hidden_prices) and $product->Type!=='discontinued'}
                <div class="panel-footer clearfix m-product-orderform-transaction-button">
                    {* Call-to-action button *}
                    {include file="modules/product/partials/entity-actions.tpl" justBuy=true product=$product inputName="product[{$product->Id}][amount]" inputValue=$product->MinAmount}
                </div>
                {/if}
            </div>{* END: .m-order-form *}
        </div>{* END: .panel.panel-border *}
    </div>{* END: .m-product-variants *}
    {/if}
