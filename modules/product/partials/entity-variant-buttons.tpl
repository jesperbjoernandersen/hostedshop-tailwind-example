{*

# Description
Template partial for the variant type of a product with the displaymode of buttons. Part of the Product page type.


## Date last modified
2021-07-15


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $variantController                                                    - Instance of productVariantController
+ $hasAdditionals                                                       - Boolean telling if product has additional products
+ $variantTypes                                                         - Collection of the productVariantTypeController
+ $variantDatas                                                         - Collection of the productVariantDataController
+ $variantDataImage                                                     - Entity of fileController (first variant image)
+ $text                                                                 - Global scope variable containing translations
+ $settings                                                             - Global scope variable containing platform settings
+ $user                                                                 - Global scope variable containing user data


## Partials (templates)
+ "/modules/product/partials/entity-actions.tpl"                        - Partial template for product actions (amount and buy button)

*}

{* Preload related entities to optimize load times *}
{include file='modules/product/partials/entity-variant-buttons-preload.tpl' scope=parent}

{*** VariantType collection - all types associated with product ***}
{collection assign=variantTypes controller=productVariantType productId=$product->Id}

{* Seperator *}
<div class="m-product-variants m-buttons m-product-buttons">

    {*** Inputs required for  ***}
    <input type="hidden" data-variant="input" data-controller="input" name="product[{$product->Id}][variant]" value="">

    <div class="m-product-buttons-list type">
    {foreach $variantTypes->getData() as $variantType}
        <div id="m-product-buttons-type-{$variantType->Id}"class="row" data-variantType="{$product->VariantDisplayMode}" data-variantTypeId="{$variantType->Id}">
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                <span class="h6 m-product-buttons-type-title">{$variantType->Title}:</span>
            </div>
            {collection assign=variantDatas controller=productVariantData productId=$product->Id typeId=$variantType->Id}
            {foreach $variantDatas->getData() as $variantData}
                {*** Fetch the image for the variantData ***}
                {entity controller=files assign=variantDataImage type=variantdata id=$variantData->Id}
                <div id="m-product-buttons-data-{$variantData->Id}" data-mh="buttons-{$variantType->Id}" class="col-s-4 col-m-6 col-l-6 col-xl-12 m-product-buttons-list m-product-buttons-list-button data">
                    <fieldset class="form-group" data-variantData="{$product->VariantDisplayMode}" data-variantDataId="{$variantData->Id}">
                        <label class="input-group" for="variant_type_{$variantType@index}_{$variantData@index}">
                            {*** Save some data to show the image; a default image (transparent gif), height, width and background(-color) ***}
                            {$variantDataImgSrc = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"}
                            {$variantDataImgHeight = "34"}
                            {$variantDataImgWidth = "34"}
                            {$variantDataBck = ""}

                            {*** If variantData has a image use that ***}
                            {if $variantDataImage}
                                {$variantDataImgSrc = $variantDataImage->thumbnail($variantDataImgHeight,$variantDataImgWidth)|solutionPath}
                            {/if}

                            {*** If variantData has a color and not a image use the color ***}
                            {if !empty($variantData->Color) && !$variantDataImage}
                                {$variantDataBck = "background-color:#{$variantData->Color};"}
                            {/if}

                            {*** Setup the variant button ***}
                            <span class="input-group-image m-product-buttons-image variant-button-image">
                                {img src="{$variantDataImgSrc}" title="{$variantData->Title}" alt="{$variantData->Title}" style="width:{$variantDataImgWidth}px;height:{$variantDataImgHeight}px;{$variantDataBck};cursor:pointer"}
                                <input style="display:none;" type="checkbox" name="{$variantType->Title}" value="{$variantData->Id}" id="variant_type_{$variantType@index}_{$variantData@index}">
                            </span>
                            <div class="form-label input-group-main">{$variantData->Title}</div>
                        </label>
                    </fieldset>
                </div>
            {/foreach}
        </div>
    {/foreach}
    </div>


    <hr class="m-product-buttons-list-separator">

    <div class="variantInfoPanel m-product-buttons-variantInfoPanel" data-controller="infoPanel">
        <div class="panel panel-warning panel-rounded" data-variant="message">
            <div class="panel-body">
                <strong><span class="choseVariantWarning m-product-buttons-choseVariantWarning" data-variant="warning"><i class="fa fa-exclamation-circle"></i> {$text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT}</span></strong>
            </div>{* END: .panel-body *}
        </div>{* END: .panel.panel-warning.panel-rounded *}
    </div>


    {*** Include product actions; buy and amount ***}
    {if $product->Type!=='discontinued' and !$hasAdditionals}
        {include file="modules/product/partials/entity-actions.tpl" product=$product inputName="product[{$product->Id}][amount]" inputValue=$product->MinAmount data="data-variant='amount'"}
    {/if}
</div>{* END: .m-prduct-variants.m-dropdown *}

{include file="modules/product/partials/entity-js-infopanels.tpl"}
