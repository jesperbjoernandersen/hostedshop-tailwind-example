{*

# Description
Template partial for the variant type of a product with the displaymode of dropdown. Part of the Product page type.
The template uses [Select2](http://ivaynberg.github.io/select2/) to generate the dropdowns.


## Date last modified
2019-09-26


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

{*** VariantType collection - all types associated with product ***}
{collection assign=variantTypes controller=productVariantType productId=$product->Id}

{* Seperator *}
<div class="m-product-variants m-dropdown m-product-dropdown">

    {*** Inputs required for product / cartadd ***}
    <input type="hidden" name="product[{$product->Id}][variant]" data-controller="input" value="">

    <div class="m-product-dropdown-list">
    {foreach $variantTypes->getData() as $variantType}
        <fieldset class="form-group m-product-dropdown-select m-product-dropdown-{$variantType->Id}">
            <input type="hidden" style="width:100%; margin-top: 3px;" data-variantType="{$product->VariantDisplayMode}" data-variantTypeId="{$variantType->Id}">
        </fieldset>
    {/foreach}
    </div>

    {* Seperator *}
    <hr class="m-product-dropdown-list-separator">

    <div class="variantInfoPanel m-product-dropdown-variantInfoPanel" data-controller="infoPanel">
        <div class="panel panel-warning panel-rounded">
            <div class="panel-body">
                <strong><span class="choseVariantWarning m-product-dropdown-choseVariantWarning"><i class="fa fa-exclamation-circle"></i> {$text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT}</span></strong>
            </div>{* END: .panel-body *}
        </div>{* END: .panel.panel-warning.panel-rounded *}
    </div>

    {*** Include product actions; buy and amount ***}
    {if $product->Type!=='discontinued' and !$hasAdditionals}
        {include file="modules/product/partials/entity-actions.tpl" product=$product inputName="product[{$product->Id}][amount]" inputValue=$product->MinAmount}
    {/if}

</div>{* END: .m-prduct-variants.m-dropdown *}

{include file="modules/product/partials/entity-js-infopanels.tpl"}
