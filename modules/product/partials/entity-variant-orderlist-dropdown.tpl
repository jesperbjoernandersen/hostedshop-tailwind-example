{*

# Description
Template partial for the variant type of a product with the displaymode of dropdown orderlist. Part of the Product page type.
The template uses [Select2](http://ivaynberg.github.io/select2/) to generate the dropdowns.


## Date last modified
2014-10-21


## Resource
+ [Select2](http://ivaynberg.github.io/select2/)

## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $variantController                                                    - Instance of productVariantController
+ $hasAdditionals                                                       - Boolean telling if product has additional products
+ $variantTypes                                                         - Collection of the productVariantTypeController
+ $text                                                                 - Global scope variable containing translations
+ $settings                                                             - Global scope variable containing platform settings
+ $user                                                                 - Global scope variable containing user data


## Partials (templates)
+ "/modules/product/partials/entity-actions.tpl"                        - Partial template for product actions (amount and buy button)

*}

<div class="m-product-variants m-orderform m-orderform-dropdown m-product-orderform-dropdown">
    <div class="panel panel-border">
        <div class="m-order-form m-product-orderform-dropdown-wrap">
            <div class="panel-heading">
                <span class="h4 orderformTitle m-product-orderform-dropdown-title">{$product->Title}</span>
            </div>{* END: .panel-heading *}
            <div class="panel-heading m-product-orderform-dropdown-heading">
                <div class="row">
                    <div class="col-s-4 col-m-2 col-l-2 col-xl-3 m-product-orderform-dropdown-heading-product">
                        <span class="h6">{$text.CART_PRODUCTS}</span>
                    </div>
                    <div class="col-m-10 col-l-10 col-xl-21 is-hidden-s">
                    {if $user or !$settings.shop_b2b_hidden_prices}
                        <div class="row">
                            <div class="col-s-4 col-m-3 col-l-3 col-xl-6 pull-right m-product-orderform-dropdown-heading-count">
                                <span class="h6">{$text.CART_COUNT}</span>
                            </div>
                        </div>{* END: .row *}
                    {else}
                        &nbsp;
                    {/if}
                    </div>{* END: .col-10 *}
                </div>{* END: .row *}
            </div>{* END: .panel-heading *}

            <ul class="list-unstyled t-striped m-product-orderform-dropdown-list">
                <li class="m-product-orderform-dropdown-list-item">
                    <div class="row">
                    {* Hide order if b2b is set *}
                    {if ($user or !$settings.shop_b2b_hidden_prices) and $product->Type!=='discontinued'}
                        <div class="col-s-4 col-m-8 col-l-8 col-xl-16">
                    {else}
                        <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                    {/if}
                            <fieldset class="form-group m-product-orderform-select2">
                                <input type="hidden" name="product[{$product->Id}][variant]" style="width:100%; margin-top: 3px;" data-controller="input" data-variantType="{$product->VariantDisplayMode}">
                            </fieldset>
                        </div>{* END: .col-10 *}

                        {* Hide order if b2b is set *}
                        {if ($user or !$settings.shop_b2b_hidden_prices) and $product->Type!=='discontinued'}
                        <div class="col-s-4 col-m-4 col-l-4 col-xl-8 is-block-s  m-product-orderform-transaction">
                            <div class="input-group small m-product-orderform-transaction-amount">
                                <input type="text" pattern="[0-9]*" class="form-input input-group-main m-product-orderform-transaction-input" disabled="disabled" name="product[{$product->Id}][amount]" data-controller="amount" data-product="count" data-product-minAmount="1" value="0">
                                <span class="input-group-button"><button type="button" data-product="subtract" class="button m-product-orderform-transaction-add"><span class="fa fa-minus"></span></button></span>
                                <span class="input-group-button"><button type="button" data-product="add" class="button m-product-orderform-subtract"><i class="fa fa-plus"></i></button></span>
                            </div>
                        </div>{* END: .col-6 *}
                        {/if}
                    </div>{* END: .row *}
                </li>
                <li style="padding:0;">
                    <div class="variantInfoPanel m-product-orderform-variantInfoPanel" data-controller="infoPanel">
                </li>
            </ul>
            {if !$product->CallForPrice and !$hasAdditionals  and ($user or !$settings.shop_b2b_hidden_prices) and $product->Type!=='discontinued'}
            <div class="panel-footer clearfix m-product-orderform-transaction">
                {*** Include product actions; buy and amount ***}
                {if $product->Type!=='discontinued' and !$hasAdditionals}
                    {include file="modules/product/partials/entity-actions.tpl" justBuy=true product=$product inputName="product[{$product->Id}][amount]" inputValue=$product->MinAmount}
                {/if}
            </div>
            {/if}
        </div>{* END: .m-order-form *}
    </div>{* END: .panel.panel-border *}
</div>{* END: .m-product-variants *}

{include file="modules/product/partials/entity-js-infopanels.tpl"}
