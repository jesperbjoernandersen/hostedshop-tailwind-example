{*

# Description
Template for Cart in a column box, the template is build with [AngularJS](https://angularjs.org/).


## Date last modified
2015-03-18


## Resouce
+ [AngularJS](https://angularjs.org/).



## Primary variables
+ $cart                                                                 - Collection of cartController (contains all products in cart)
+ $productController                                                    - Controller of the type productController
+ $product                                                              - Entity of a product (item in cart)
+ $variantTypes                                                         - Collection of productVariantTypeController (types for variants)
+ $variantData                                                          - Collection of productVariantDataController (data for variantTypes)
+ $icons                                                                - Shop payment icons


## Partials (templates)
+ "/modules/widgets/paymenticons/paymenticons.tpl"                      - Payment icons widget

*}

{* Cart controller *}
{collection controller=cart assign=cart}
{$cartList = $cart->groupByClass()}

{* Initiate Product controller *}
{controller type=product assign=productController}

{* Max cart lines *}
{$pageSize = 3}

<div class="panel panel-border column-box b-cart">
    <div class="panel-heading b-cart-header b-header">
        <span class="h5">{$text.CART_HEADLINE}</span>
    </div>
    <div class="modules b-cart-list">
        {if isset($cartList.CartProductLine)}
            <ul class="list-unstyled t-striped">
                {if $cartList.CartProductLine|@count lte $pageSize}
                    {$cartListLoop = $cartList.CartProductLine|@count}
                {else}
                    {$cartListLoop = $pageSize}
                {/if}

                {section name=cartProductList start=0 loop=$cartListLoop step=1}
                    {$cartProduct = $cartList.CartProductLine[$smarty.section.cartProductList.index]}

                    {* Product *}
                    {entity assign=product controller=product type=product id=$cartProduct->ProductId}

                    {* Variant *}
                    {$cartVariantTitle = ''}
                    {if $cartProduct->VariantId}
                        {collection assign=variantTypes controller=productVariantType productId=$cartProduct->ProductId variantId=$cartProduct->VariantId}

                        {foreach $variantTypes->getData() as $variantType}
                            {entity assign=variantData controller=productVariantData productId=$cartProduct->ProductId variantId=$cartProduct->VariantId typeId=$variantType->Id}

                            {$cartVariantTitle = $cartVariantTitle|cat:" "|cat:$variantData->Title}
                        {/foreach}
                    {/if}

                    <li id="cartProduct-{$cartProduct->ProductId}" class="b-cart-product">
                        <span class="is-block b-product-title">
                            {if $cartProduct->Available}
                                <a href="{$cartProduct->Url}" alt="{$product->Title} {$cartVariantTitle}">
                                    {$product->Title}
                                    {if $cartProduct->VariantId}
                                        {$cartVariantTitle}
                                    {/if}
                                </a>
                            {else}
                                <span>{$text.CART_PRODUCT_DEAD_TITLE}</span>
                            {/if}
                        </span>
                        <span class="is-block b-cart-product-price">
                            <strong>
                                <span class="b-cart-product-amount">{$cartProduct->Amount}</span> <span class="b-cart-product-x">x</span>
                                {if $cartProduct->FullPrice != $cartProduct->Price}
                                    <s class="b-cart-product-price-before-discount">{$cartProduct->FullPrice|formatPrice}</s>
                                {/if}
                                <span class="b-cart-product-total-price">{$cartProduct->Price|formatPrice}</span>
                            </strong>
                        </span>
                    </li>
                {/section}

                {if isset($cartList.CartSalesLine)}
                    <li class="media b-salesline">
                        <a class="is-block"><span class="is-block b-cart-salesline sales-title">{$cartList.CartSalesLine.0->Title}</span></a>
                        <strong class="is-block b-cart-salesline sales-price">{$cartList.CartSalesLine.0->Price|formatPrice}</strong>
                    </li>
                {/if}

                {if isset($cartList.CartCouponLine)}
                    <li class="media b-couponline">
                        <a class="is-block"><span class="is-block b-cart-couponline coupon-title">{$cartList.CartCouponLine.0->Title}</span></a>
                        <strong class="is-block b-cart-couponline coupon-price">{$cartList.CartCouponLine.0->Price|formatPrice}</strong>
                    </li>
                {/if}

            </ul>
        {else}

            <div class="panel-body">
                <span>{$text.CART_IS_EMPTY}</span>
            </div>

        {/if}

        {if isset($cartList.CartProductLine)}
            {if $cartList.CartProductLine|@count gte $pageSize }
                <hr class="divider b-cart-hr">
                <header class="header text-center b-cart-header show-all-products">
                    <a href="/{$text.CART_LINK}/" class="button is-block small">{$text.CART_SHOW_ALL_PRODUCTS} ({$cartList.CartProductLine|@count})</a>
                </header>
            {/if}
        {/if}

        {if isset($cartList.CartProductLine)}
            {if $cartList.CartProductLine|@count gte 1 }
                <hr class="divider b-cart-hr">
                <header class="header b-cart-header aprox-prices">
                    {if isset($cartList.CartDeliveryEstimateLine)}
                        <div class="row b-cart-line b-cart-delivery-line">
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 b-cart-delivery-est-title">
                                <span>{$text.CART_DELIVERY_FROM}</span>
                            </div>
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 text-right b-cart-delivery-est-price">
                                <span>{$cartList.CartDeliveryEstimateLine.0->Price|formatPrice}</span>
                            </div>
                        </div>
                    {/if}
                    {if isset($cartList.CartSubTotalLine)}
                        <div class="row b-cart-line b-cart-price-sub-total">
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 b-cart-price-sub-total-title">
                                <span>{$text.CART_PRICE_SUM}</span>
                            </div>
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 text-right b-cart-price-sub-total-price">
                                <span>{$cartList.CartSubTotalLine.0->Price|formatPrice}</span>
                            </div>
                        </div>
                    {/if}
                    {if isset($cartList.CartVatTotalLine)}
                        <div class="row b-cart-line b-cart-vat-line">
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 b-cart-vat-title">
                                <span>
                                    {if $currency.hasVat}
                                        {$text.CART_VAT_INCLUSIVE}
                                    {else}
                                        {$text.CART_VAT_EXCLUSIVE}
                                    {/if}
                                </span>
                            </div>
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 text-right b-cart-vat-price">
                                <span>{$cartList.CartVatTotalLine.0->Price|formatPrice}</span>
                            </div>
                        </div>
                    {/if}
                    <hr>
                    {if isset($cartList.CartTotalLine)}
                        <div class="row b-cart-line b-cart-total-price-line">
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 b-cart-total-price-title">
                                <span><strong>{$text.CART_TOTAL}</strong></span>
                            </div>
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 text-right b-cart-total-price-final">
                                <span><strong>{$cartList.CartTotalLine.0->Price|formatPrice}</strong></span>
                            </div>
                        </div>
                    {/if}
                </header>
            {/if}
        {/if}

        <hr class="divider b-cart-hr">
        <div class="footer b-cart-payment-icons">
            <div class="trailing">
                {include file='modules/widgets/paymenticons/paymenticons.tpl'}
            </div>
        </div>

    {if $cartList.CartDeliveryEstimateLine.0->PriceUntilFreeDelivery}
        <hr class="divider b-cart-hr">
        <footer class="footer b-cart-free-delivery">
            <div class="trailing">
                {$text.CART_PRICE_UNTIL_FREE_DELIVERY|replace:'$1':($cartList.CartDeliveryEstimateLine.0->PriceUntilFreeDelivery|formatPrice)}
            </div>
        </footer>
    {/if}
    </div>
    <div class="panel-footer b-cart-goto-cart">
        <a href="/{$text.CART_LINK}/" class="button-primary button-icon is-block small"><i class="fa fa-shopping-cart"></i>{$text.CART_GO_TO}</a>
    </div>
</div>
