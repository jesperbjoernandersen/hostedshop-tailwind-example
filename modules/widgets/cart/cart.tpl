{*

# Description
Cart widget. A widget is a small helper template, with some functionality.


## Date last modified
2021-02-25


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController
+ $productImage                                                         - Entity of filesContoller
+ $variantData                                                          - Collection of productVariantDataController
+ $variantImage                                                         - Entity of filesController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/icon/icon.tpl"                                      - Widget for icons
+ "/modules/widgets/paymenticons/paymenticons.tpl"                      - Payment icons widget
+ "/modules/widgets/integrations/viabill_pricetag.tpl"                  - Viabill pricetag

*}

<div class="basket">

    {* Max cart lines *}
    {$pageSize = 3}

    {*** Cart controller ***}
    {collection controller=cart assign=cart primary=true}
    {$cartProductList = $cart->groupByClass('CartProductLine')}
    {$cartList = $cart->groupByClass()}
    
    {*** Eager loading ***}
    {include file='modules/cart/cart-preload.tpl' scope=parent}
    
    {*** Picture size ***}
    {$imageWidth  = 220}
    {$imageHeight = 220}
    
    {placeholdImage assign=placeholder width=$imageWidth height=$imageHeight background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}

    <a href="/{$text.CART_LINK}/" title="{$text.CART_MENU}">{include file='modules/widgets/icon/icon.tpl' icon=shoppingCart}</a>
    {if isset($cartList.CartProductLine)}
        <i class="count-bubble">{$cart->getActualSize()}</i>
    {/if}

    {* MINIBASKET *}
    {if isset($cartList.CartProductLine)}
        <div class="miniBasket">
            <ul class="list-unstyled t-striped m-cart-list">
                {foreach $cartList.CartProductLine as $cartProduct}

                    {$hasVatIncludedLabel = $currency.hasVat and ($settings.vat_label_advanced eq false or $cartProduct->Vat gt 0)}

                    {*** Product ***}
                    {entity assign=product controller=product type=product id=$cartProduct->ProductId}
                    {entity assign=productImage controller=files type=product productId=$cartProduct->ProductId}

                    {*** Variant ***}
                    {$cartVariantTitle = ''}
                    {if $cartProduct->VariantId}

                        {collection assign=variantDatas controller=productVariantData productId=$cartProduct->ProductId variantId=$cartProduct->VariantId}

                        {foreach $variantDatas->getData() as $variantData}
                            {$cartVariantTitle = $cartVariantTitle|cat:" "|cat:$variantData->Title}
                        {/foreach}

                        {entity assign=variantImage controller=files type=variant variantId=$cartProduct->VariantId}
                    {/if}

                    {*** Picture ***}
                    {$imageAspect = "{($imageHeight / $imageWidth) * 100}%"}
                    {if $cartProduct->VariantId && $variantImage}
                        {$cartImage = $variantImage->thumbnail($imageWidth, $imageHeight, "fill")|solutionPath}
                    {elseif $productImage}
                        {$cartImage = $productImage->thumbnail($imageWidth, $imageHeight, "fill")|solutionPath}
                    {else}
                        {$cartImage = $placeholder->getRelativeFile()|solutionPath}
                    {/if}

                    <li class="m-cart-row" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                        <meta itemprop="position" content="{$cartProduct@iteration}">
                        <article class="row">
                            <div class="col-s-1 m-cart-product-title-container">
                                <figure>
                                    <a href="{$cartProduct->Url}" title="{$cartProduct->Title} {$cartVariantTitle}" class="placeholder-wrapper" data-placeholder-max-width="180px">
                                        <span class="placeholder" data-placeholder-aspect="{$imageAspect}"></span>
                                        {img src="{$cartImage}" class="responsive" alt="{$cartProduct->Title} {$cartVariantTitle}" itemprop="image"}
                                    </a>
                                </figure>
                            </div>
                            <div class="col-s-3 m-cart-product-container">
                                <div class="row">
                                    <div class="col-s-2">
                                        <header>
                                            {if $cartProduct->Available}
                                                {* Product / Variant *}
                                                <a href="{$cartProduct->Url}" title="{$cartProduct->Title} {$cartVariantTitle}" itemprop="url">
                                                    <p class="m-cart-product-title" itemprop="name">
                                                        <span class="m-cart-product-title">{$cartProduct->Title}</span> <span class="m-cart-variant-title">{if !$cartProduct->UserTitle}{$cartVariantTitle}{/if}</span>
                                                    </p>
                                                </a>

                                                {* Additionals *}
                                                {if $cartProduct->Additionals}
                                                    {foreach $cartProduct->Additionals as $key => $additionalType}
                                                        {entity assign=additionalTypeData controller=productAdditionalType id=$key}

                                                        <p class="m-cart-product-additional-content">
                                                            <span class="m-cart-product-additional-title">{$additionalTypeData->Title}</span><span class="m-colon">:</span><br>

                                                            {foreach $additionalType as $additional}
                                                                <span class="m-hyphen">-</span> <span class="m-cart-product-additional-data-title">{$additional->Title}</span>
                                                                {if $additional->Price}
                                                                    <span class="m-cart-product-additional-data-price">({$additional->Price|formatPrice})</span>
                                                                {/if}
                                                                <br>
                                                            {/foreach}
                                                        </p>
                                                    {/foreach}
                                                {/if}

                                                {* Packet product *}
                                                {if $cartProduct->PacketProducts}
                                                    <p class="m-cart-product-packet-text">{$text.PRODUCT_CATALOG_PRODUCT_PACKET}</p>
                                                    {foreach $cartProduct->PacketProducts as $packetProduct}
                                                        {*** Product ***}
                                                        {entity assign=packetProductData controller=product type=product id=$packetProduct->ProductId}

                                                        {*** Variant ***}
                                                        {$packetVariantTitle = ''}
                                                        {if $packetProduct->VariantId}
                                                            {collection assign=packetVariantDatas controller=productVariantData variantId=$packetProduct->VariantId}

                                                            {foreach $packetVariantDatas->getData() as $packetVariantData}

                                                                {$packetVariantTitle = $packetVariantTitle|cat:" "|cat:$packetVariantData->Title}
                                                            {/foreach}
                                                        {/if}

                                                        <p class="m-cart-product-packet-content">
                                                            <span class="m-cart-product-packet-data-amount">{$packetProduct->Amount}</span> <span class="m-x">x</span>
                                                            {if $packetProductData}
                                                                <span class="m-cart-product-packet-data-title">{$packetProductData->Title} {$packetVariantTitle}</span>
                                                            {else}
                                                                <span class="m-cart-product-packet-data-title dead">{$text.CART_PRODUCT_DEAD_TITLE}</span>
                                                            {/if}
                                                        </p>
                                                    {/foreach}
                                                {/if}

                                                {* Gift Card *}
                                                {if $cartProduct->Giftcard}
                                                    <p class="m-cart-product-giftcard-content">
                                                        <span class="m-cart-product-giftcard-name-text">{$text.GIFT_CARD_NAME}</span><span class="m-colon">:</span>
                                                        <span class="m-cart-product-giftcard-name">{$cartProduct->Giftcard->Name}</span>
                                                    </p>
                                                {/if}

                                                {if $settings.shop_product_number eq true && $cartProduct->ItemNumber}
                                                    <p class="m-cart-product-number">
                                                        <span class="m-cart-product-number-text">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</span> <span class="m-cart-product-number">{$cartProduct->ItemNumber}</span>
                                                    </p>
                                                {/if}
                                            {else}
                                                <p class="m-cart-product-dead">{$text.CART_PRODUCT_DEAD_TITLE}</p>
                                            {/if}
                                        </header>
                                    </div>
                                    <div class="col-s-2 cart-total-value text-right">
                                        <strong class="is-block">
                                            {if $cartProduct->FullPrice != $cartProduct->Price}
                                                <s class="is-block m-cart-product-priceBeforeDiscount">{($cartProduct->Amount * $cartProduct->FullPrice)|formatPrice}</s>
                                            {/if}
                                            <span class="m-cart-product-price">{($cartProduct->Amount * $cartProduct->Price)|formatPrice}</span>
                                        </strong>
                                        {if $settings.shop_product_tax_after_price eq true}
                                            {if $hasVatIncludedLabel}
                                                <p class="m-cart-product-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                            {else}
                                                <p class="m-cart-product-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                            {/if}
                                        {/if}

                                        <a class="button-text" href="/actions/cart/remove?id={$cartProduct->Key}&{csrf type='get'}" title="{$text.DELETE}">{$text.DELETE}</a>
                                    </div>
                                </div>
                            </div>
                        </article>

                        {if ($cartProduct->Soldout && $cartProduct->AllowOutOfStockPurchase eq false) or !$cartProduct->Available}
                            <div class="panel panel-danger" style="margin-bottom: 0;">
                                <div class="panel-body">
                                    <i class="fa fa-exclamation-triangle"></i>
                                    <strong>
                                        {if $cartProduct->Available}
                                            <span class="m-cart-product-stock-limit">{$text.PRODUCT_CATALOG_NO_OEDER}</span>
                                        {else}
                                            <span class="m-cart-product-dead">{$text.CART_PRODUCT_DEAD_NOTE}</span>
                                        {/if}
                                    </strong>
                                </div>
                            </div>
                        {/if}

                        <div itemscope itemtype="http://schema.org/Offer">

                        </div>
                    </li>
                {/foreach}

                {if isset($cartList.CartSalesLine)}
                    <li>
                        <article class="row">
                            <div class="col-s-1 col-m-1 col-l-1 col-xl-2 text-center"></div>
                            <div class="col-s-3 col-m-11 col-l-11 col-xl-22">
                                <div class="row">
                                    <div class="col-s-4 col-m-3 col-l-3 col-xl-6">
                                        <p class="m-cart-salesline-title h6">
                                            <span class="m-cart-salesline-title">{$cartList.CartSalesLine.0->Title}</span>
                                            <span class="m-cart-salesline-title-type">
                                                {if $cartList.CartSalesLine.0->DiscountType == 'percentage'}
                                                    ({$cartList.CartSalesLine.0->AmountRaw} %)
                                                {elseif $cartList.CartSalesLine.0->DiscountType == 'fixed'}
                                                    ({$cartList.CartSalesLine.0->Price|formatPrice})
                                                {/if}
                                            </span>
                                        </p>

                                        {if $settings.shop_product_number eq true && $cartList.CartSalesLine.0->ItemNumber}
                                            <p class="m-cart-salesline-number">
                                                <span class="m-cart-salesline-number-text">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</span> <span class="m-cart-salesline-number">{$cartList.CartSalesLine.0->ItemNumber}</span>
                                            </p>
                                        {/if}
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-4">
                                        <span class="m-cart-salesline-type">
                                            {if $cartList.CartSalesLine.0->DiscountMode == 'sale-discount'}
                                                {$text.DISCOUNT}
                                            {elseif $cartList.CartSalesLine.0->DiscountMode == 'sale-fee'}
                                                {$text.FEE}
                                            {/if}
                                        </span>
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-4">
                                        <span class="m-cart-salesline-price">{$cartList.CartSalesLine.0->Price|formatPrice}</span>
                                        {if $settings.shop_product_tax_after_price eq true}
                                            {if $currency.hasVat}
                                                <p class="m-cart-salesline-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                            {else}
                                                <p class="m-cart-salesline-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                            {/if}
                                        {/if}
                                    </div>
                                    <div class="col-s-4 col-m-3 col-l-3 col-xl-4">
                                        <p class="m-cart-salesline-amount">1 {$text.PEACES}</p>
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-6 cart-total-value">
                                        <strong class="is-block"><span class="m-cart-salesline-price">{$cartList.CartSalesLine.0->Price|formatPrice}</span></strong>
                                        {if $settings.shop_product_tax_after_price eq true}
                                            {if $currency.hasVat}
                                                <p class="m-cart-salesline-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                            {else}
                                                <p class="m-cart-salesline-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                            {/if}
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        </article>
                    </li>
                {/if}

                {if isset($cartList.CartCouponLine)}
                    <li>
                        <article class="row">
                            <div class="col-s-1 col-m-1 col-l-1 col-xl-2 text-center"></div>
                            <div class="col-s-3 col-m-11 col-l-11 col-xl-22">
                                <div class="row">
                                    <div class="col-s-4 col-m-3 col-l-3 col-xl-6">
                                        <p class="m-cart-coupon-title h6">
                                            <span class="m-cart-coupon-title">{$cartList.CartCouponLine.0->Title}</span>
                                            <span class="m-cart-coupon-title-type">
                                                {if $cartList.CartCouponLine.0->Type == 'procent'}
                                                    ({$cartList.CartCouponLine.0->Amount} <span class="m-percent">%</span>)
                                                {elseif $cartList.CartCouponLine.0->Type == 'amount'}
                                                    ({$cartList.CartCouponLine.0->Amount|formatPrice})
                                                {/if}
                                            </span>
                                        </p>
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-4">
                                        <span class="m-cart-coupon-type">{$text.SHOP_DISCOUNT_CODE}</span>
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-4">
                                        <span class="m-cart-coupon-price">{$cartList.CartCouponLine.0->Price|formatPrice}</span>
                                        {if $settings.shop_product_tax_after_price eq true}
                                            {if $currency.hasVat}
                                                <p class="m-cart-coupon-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                            {else}
                                                <p class="m-cart-coupon-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                            {/if}
                                        {/if}
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-4">
                                        <p>1 {$text.PEACES}</p>
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-6 cart-total-value">
                                        <strong class="is-block"><span class="m-cart-coupon-price">{$cartList.CartCouponLine.0->Price|formatPrice}</span></strong>
                                        {if $settings.shop_product_tax_after_price eq true}
                                            {if $currency.hasVat}
                                                <p class="m-cart-coupon-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                            {else}
                                                <p class="m-cart-coupon-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                            {/if}
                                        {/if}

                                        <a class="button-text" href="/actions/cart/couponRemove?{csrf type='get'}" title="{$text.DELETE}">{$text.DELETE}</a>
                                    </div>
                                </div>
                            </div>
                        </article>
                    </li>
                {/if}
            </ul>

            <table class="table minibasket-footer">
                <tbody>
                    {if isset($cartList.CartDeliveryEstimateLine)}
                        <tr class="m-cart-delivery-estimate-line m-tr">
                            <td class="text-left"><span class="m-cart-delivery-title">{$text.CART_DELIVERY_FROM}</span></td>
                            <td class="text-right">
                                <span class="m-cart-delivery-price">{$cartList.CartDeliveryEstimateLine.0->Price|formatPrice}</span>
                            </td>
                        </tr>
                    {/if}
                    {if isset($cartList.CartSubTotalLine)}
                        <tr class="m-cart-sub-total-line m-tr">
                            <td class="text-left"><span class="m-cart-subtotal-title">{$text.CART_PRICE_SUM}</span></td>
                            <td class="text-right">
                                <span class="m-cart-subtotal-price">{$cartList.CartSubTotalLine.0->Price|formatPrice}</span>
                            </td>
                        </tr>
                    {/if}
                    {if isset($cartList.CartVatTotalLine)}
                        <tr class="m-cart-vat-total-line m-tr">
                            <td class="text-left">
                                <span class="m-cart-vat-title">
                                    {if $currency.hasVat}
                                        {$text.CART_VAT_INCLUSIVE}
                                    {else}
                                        {$text.CART_VAT_EXCLUSIVE}
                                    {/if}
                                </span>
                            </td>
                            <td class="text-right">
                                <span class="m-cart-vat-price" itemprop="tax">{$cartList.CartVatTotalLine.0->Price|formatPrice}</span>
                            </td>
                        </tr>
                    {/if}
                </tbody>
                <tfoot>
                    {if isset($cartList.CartTotalLine)}
                        <tr class="m-cart-total-line m-tr">
                            <td class="text-left">
                                <span class="m-cart-total-title"><strong>{$text.CART_TOTAL}</strong></span>
                            </td>
                            <td class="text-right">
                                <span class="m-cart-total-price" itemprop="total"><strong>{$cartList.CartTotalLine.0->Price|formatPrice}</strong></span>
                                {* Viabill price tag *}
                                {include file="modules/widgets/integrations/viabill_pricetag.tpl" type="basket" price=$cartList.CartTotalLine.0->Price}
                            </td>
                        </tr>
                    {/if}

                    <tr>
                        <td colspan="2">
                            {include file='modules/widgets/paymenticons/paymenticons.tpl'}
                        </td>
                    </tr>
                </tfoot>
            </table>

            <a href="/{$text.CART_LINK}/" class="button button-primary">{$text.CART_GO_TO}</a>

        </div>
    {/if}

</div>
