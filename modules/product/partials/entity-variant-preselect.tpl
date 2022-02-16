{*

# Description
Template to display the preselected variant on the product page

# Date last modified
2017-11-20


## Primary variables
+ $controller                                                           - Instance of productController
+ $variantController                                                    - Instance of variantController
+ $product                                                              - Entity of productController
+ $item                                                                 - Entity of productVariantController
+ $category                                                             - Entity of productCategoryController (main category of selected product (inherited from product.tpl))
+ $prices                                                               - Entity of productPriceController (price lines for selected product)
+ $additionals                                                          - Collection of productAdditionalTypeController
+ $justBuy                                                              - Tells to hide or show amount
+ $brand                                                                - Entity of brandController
+ $text                                                                 - Global scope variable containing translations
+ $user                                                                 - Global scope variable containing user data
+ $settings                                                             - Global scope variable containing platform settings
+ $columns                                                              - Global scope variable containing columns


*}

{*** VariantType collection - all types associated with product ***}
{if !isset($variantTypes)}
    {collection assign=variantTypes controller=productVariantType productId=$product->Id variantId=$variant->Id}
{/if}

{* Seperator *}
<div class="m-product-variants m-preselect m-product-preselect" data-controller="preselect" data-variantType="preselect" data-variant-id="{$variant->Id}">
    {*** Inputs required for product / cartadd ***}
    <input type="hidden" name="product[{$product->Id}][variant]" value="{$variant->Id}">

    <div class="m-variant-preselect-header">
        <div class="h5 m-variant-preselect-header-text">{$text.PRODUCT_CATALOG_PRODUCT_PRESELECT_TEXT}</div>
    </div>

    {if $variantTypes->getActualSize() gt 0}
    <div class="m-variant-preselect-combination">
        <table class="m-product-variant-combination-list table table-h-striped">
        {foreach $variantTypes->getData() as $variantType}
            {entity assign=variantData controller=productVariantData productId=$product->Id variantId=$variant->Id typeId=$variantType->Id}
            <tr class="m-product-variant-combination-item combination-type-{$variantType->Id} combination-data-{$variantData->Id} trailing">
                <td class="m-product-variant-combination-type l-combination-type-text"><span class="m-product-variant-combination-type-text"><strong>{$variantType->Title}:</strong></span></td>
                <td class="m-product-variant-combination-data l-combination-data-text">
                    {if !empty($variantData->Color)}
                        <span class='m-product-variant-combination-data-color variantColor fa fa-square' style="color: #{$variantData->Color};"></span>
                    {/if}
                    <span class="m-product-variant-combination-data-text">{$variantData->Title}</span>
                </td>
            </tr>
        {/foreach}
        </table>
    </div>
    {/if}

    <div class="text-right"><a class="button" href="{$page.request}">{$text.PRODUCT_CATALOG_PRODUCT_PRESELECT_RESET_BUTTON}</a></div>

    {* Seperator *}
    <hr class="m-product-preselect-list-separator">

    <div class="variantInfoPanel m-product-preselect-variantInfoPanel" data-controller="infoPanel">
        <div class="panel panel-warning panel-rounded">
            <div class="panel-body">
                <strong><span class="choseVariantWarning m-product-preselect-choseVariantWarning"><i class="fa fa-exclamation-circle"></i> {$text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT}</span></strong>
            </div>{* END: .panel-body *}
        </div>{* END: .panel.panel-warning.panel-rounded *}
    </div>

    {*** Include product actions; buy and amount ***}
    {if $product->Type!=='discontinued'}

        {* Transaction for the product *}
        {if !$hasAdditionals}
            {include
                file='modules/product/partials/entity-actions.tpl'
                inputName="product[{$product->Id}][amount]"
                inputValue=$variant->MinAmount
                justBuy=$justBuy
            }
        {/if}
    {/if}
</div>

{include file="modules/product/partials/entity-js-infopanels.tpl"}
