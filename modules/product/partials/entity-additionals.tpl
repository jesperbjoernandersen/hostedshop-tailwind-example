{*

# Description
Template partial for the additional products. Part of the Product page type.


## Date last modified
2020-04-07


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $productAdditionalType                                                - Collection of productAdditionalTypeController
+ $addditionalDatas                                                     - Collection of productAdditionalController
+ $additionalController                                                 - Instance of productAdditionalController
+ $User                                                                 - Global scope variable containing user data
+ $settings                                                             - Global scope variable containing platform settings
+ $justBuy                                                              - Tells to hide or show amount (amount for the buy button)

## Partials (templates)
+ "/modules/product/partials/entity-actions.tpl"                        - Partial template for product actions (amount and buy button)

*}

{* Additional data controller *}
{controller assign=additionalController type=productAdditional}

{$justBuy = $justBuy || false}

{*** Only build additionls if the product contains any ***}
{if $additionals->getActualSize() gt 0}
<div class="m-options m-product-additionals m-additionals">
{* Seperator *}
<hr class="m-product-additionals-separator">

    {* We wrap the hole thing in a UI panel to look sharp *}
    <div class="panel panel-border m-product-additionals-wrap">
        <div class="panel-heading">
            {* Options title *}
            <span class="h4 additionalsHeadline m-product-additionals-title">{$text.PRODUCT_CATALOG_ADDITIONAL}</span>
        </div>{* END: .panel-heading *}

        <ul class="list-unstyled t-striped m-product-additionals-list">
            {* Loop accesories *}
            {foreach $additionals->getData() as $additional}
            {*** Generate a collection of the Additional types ***}
            {collection assign=addditionalDatas controller=$additionalController typeId=$additional->Id vatGroupId=$product->VatGroupId}
            <li class="m-product-additionals-list-item {$additional->Type}" id="m-product-additionals-{$additional->Id}">
                <div class="row" itemprop="isAccessoryOrSparePartFor" itemscope itemtype="http://schema.org/Product">
                    <div class="col-s-4 col-m-5 col-l-5 col-xl-12 m-product-additionals-text">
                         {* Productname *}
                        <p class="h6">
                            <span class="m-product-additionals-item-title" itemprop="name">{$additional->Title}</span>
                            {* Add a help if there is any *}
                            {$helpText = $additionalController->getDescription($additional->Id)}
                            {if !empty($helpText)}
                                <div class="m-product-additionals-helpText"><span class="additionalHelp">{$helpText}</span></div>
                            {/if}
                        </p>
                    </div>
                    <div class="col-s-4 col-m-7 col-l-7 col-xl-12">

                    {*** Type radio and type checkbox are relative simple, so we can build them like that ***}
                    {if $additional->Type==="checkbox"}
                        {foreach $addditionalDatas->getData() as $addditionalData}
                        <fieldset class="row">
                            {* Show a label for the input *}
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 m-product-additionals-type">
                                <label class="h6 m-product-additionals-label">
                                    <input class="m-product-additionals-input checkbox" type="{$additional->Type}" name="product[{$product->Id}][additional][{$additional->Id}][]" value="{$addditionalData->Id}">
                                    {$addditionalData->Title}
                                </label>
                            </div>
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 m-product-additionals-price">
                                {* Remember to hide the price if B2B *}
                                {if $user or !$settings.shop_b2b_hidden_prices or $settings.shop_b2b_hidden_prices==="partly"}
                                    <span class="m-product-additionals-price">( <strong>+</strong> {$addditionalData->Price|formatPrice} )</span>
                                {else} {* Print a empty space, so the column doesn't collapse *}
                                    &nbsp;
                                {/if}
                            </div>
                        </fieldset>
                        {/foreach}
                    {/if}

                    {*** Type radio and type checkbox are relative simple, so we can build them like that ***}
                    {if $additional->Type==="radio"}
                        {foreach $addditionalDatas->getData() as $addditionalData}
                        <fieldset class="row">
                            {* Show a label for the input *}
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 m-product-additionals-type">
                                <label class="h6 additionalTitle">
                                    <input {if $addditionalData@first}checked="checked"{/if} class="m-product-additionals-input radio" type="{$additional->Type}" name="product[{$product->Id}][additional][{$additional->Id}][]" value="{$addditionalData->Id}">
                                    {$addditionalData->Title}
                                </label>
                            </div>
                            <div class="col-s-2 col-m-6 col-l-6 col-xl-12 m-product-additionals-price">
                                {* Remember to hide the price if B2B *}
                                {if $user or !$settings.shop_b2b_hidden_prices or $settings.shop_b2b_hidden_prices==="partly"}
                                    <span class="additionalPrice">( <strong>+</strong> {$addditionalData->Price|formatPrice} )</span>
                                {else} {* Print a empty space, so the column doesn't collapse *}
                                    &nbsp;
                                {/if}
                            </div>
                        </fieldset>
                        {/foreach}
                    {/if}

                    {*** If the type is select, build a select input ***}
                    {if $additional->Type==="select"}
                        <fieldset class="form-group m-product-additionals-type">
                            <select class="form-input form-select m-product-additionals-input select" name="product[{$product->Id}][additional][{$additional->Id}][]">
                            {* Build options into select with data for each type *}
                            {foreach $addditionalDatas->getData() as $addditionalData}
                                <option value="{$addditionalData->Id}" id="m-product-additionals-data-{$addditionalData@index}">
                                    {* Remember to hide the price if its B2B *}
                                    {$addditionalData->Title} {if $user or !$settings.shop_b2b_hidden_prices or $settings.shop_b2b_hidden_prices==="partly"}( + {$addditionalData->Price|formatPrice} ){/if}
                                </option>
                            {/foreach}
                            </select>
                        </fieldset>
                    {/if}

                    {*** if type is text, build a simple input with the type text ***}
                    {if $additional->Type==="text"}
                        <fieldset class="form-group m-product-additionals-type">
                            <input class="form-input m-product-additionals-input text" placeholder="{$helpText}" type="text" name="product[{$product->Id}][additional][{$additional->Id}][]" value="">
                        </fieldset>
                    {/if}
                    </div>
                </div>
            </li>
            {/foreach}
        </ul>
    </div>{* END: .panel.panel-border *}

    <div class="row">
        <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-product-additionals-transaction">
            {*** Include product actions; buy, amount and add to wishlist ***}
            {if $product->Type!=='discontinued' and $hasAdditionals}
                {include file="modules/product/partials/entity-actions.tpl" product=$product justBuy=$justBuy inputName="product[{$product->Id}][amount]" inputValue=$product->MinAmount data=""}
            {/if}
        </div>
    </div>

</div>{* END: .m-product-additionals *}
{/if}

