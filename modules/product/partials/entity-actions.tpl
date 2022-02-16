{*

# Description
Template partial for product actions (buy amount and buy button). Part of the Product page type.


## Date last modified
2021-03-17


## Primary variables
+ $product                                      - Entity of productController (single shop product)
+ $inputName                                    - Name of amount inputfield (its varies for different views)
+ $inputValue                                   - Value of amount inputfield (its varies for different views)
+ $justBuy                                      - Tells to hide or show amount
+ $data                                         - String with data-attributes for amount inputfield
+ $User                                         - Global scope variable containing user data
+ $settings                                     - Global scope variable containing platform settings

*}

{$showBuy = true}
{*** IF product is out of stock, and we are not allowed to buy it, disable buttons ***}
{if !in_array($product->Type, ["variant","packet"]) and ($product->Soldout and !$product->AllowOutOfStockPurchase)}
    {$showBuy = false}
{elseif in_array($product->Type, ["variant","packet"])}
{*** Variant should always show buy, since the single variant decides if the product can be bought, not the main product ***}
    {$showBuy = true}
{/if}


{* Transaction for the product *}
<div class="m-product-transaction product-transaction">
    {if !$product->CallForPrice and ($user or !$settings.shop_b2b_hidden_prices) and $showBuy}
        {if !$justBuy}
            <div class="m-product-transaction-amount">
            {* Amount *}
            {$unittitle = {translation id=$product->UnitId module='unit' title='title'}}
            {if !empty($unittitle)}
                <div class="input-group">
                    <input type="text" pattern="[0-9]*" name="{$inputName}" data-controller="amount" class="form-input input-group-main m-transaction-input large" value="{$inputValue}" {$data} title="{$text.INSERT_AMOUNT}">
                    <span class="input-group-addon m-product-transaction-unittitle" data-controller="unittitle">{$unittitle}</span>
                </div>
            {else}
                <input type="text" pattern="[0-9]*" name="{$inputName}" data-controller="amount" class="form-input input-group-main m-transaction-input" value="{$inputValue}" {$data} title="{$text.INSERT_AMOUNT}">
            {/if}

            </div>

            <div class="m-product-transaction-button">
                {* Buy button *}
                <button type="submit" name="cartadd" data-product="buyButton" data-controller="buy" role="button" class="button-primary large">
                    {$text.PRODUCT_CATALOG_PRODUCT_BUY}
                </button>
            </div>
        {else}
            <div class="m-product-transaction-button">
                {* Buy button *}
                <button type="submit" name="cartadd" data-product="buyButton" data-controller="buy" role="button" class="button-primary pull-right">{$text.PRODUCT_CATALOG_PRODUCT_BUY}</button>
            </div>
        {/if}

    {elseif $product->CallForPrice}
        <input type="hidden" name="{$inputName}" value="{$inputValue}">
    {/if}
</div>

{* Checkout widget: Buttons *}
{include file='modules/widgets/checkout/checkout.tpl' displayOnly=buttons}

{*** Wishlist module ***}
{if $settings.module_shop_wishlist and $access.wishlist}
    <div class="modules m-wishlist m-product-wishlist" style="margin-top:0.5em;">
        {if $user}
            <button type="submit" data-controller="wishlist" role="button" name="wishlistadd" class="m-product-wishlist-button wishlist-button button-text{if $justBuy} pull-right{/if}" title="{$text.WISHLIST_ADD}">{$text.WISHLIST_ADD}</button>
        {else}
            <a href="#modal" class="m-product-wishlist-button login wishlist-button{if $justBuy} pull-right{/if}" data-fancybox="" title="{$text.WISHLIST_ADD}">{$text.WISHLIST_ADD}</a>
        {/if}
    </div>
{/if}
