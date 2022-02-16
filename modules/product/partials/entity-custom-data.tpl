{*

# Description
Template partial for Custom data for products. Part of the Product page type.


## Date last modified
2014-09-11


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $productCustomDataTypes                                               - Collection of productCustomDataTypeController
+ $productCustomDatas                                                   - Collection of productCustomDataController


## Partials (templates)
No extra templates required for this template

*}


<div class="responsive-table-wrap m-product-customdata">
    <table class="table-h-striped">
        <tbody>
        {*** Loop all customdatatypes **}
        {foreach $productCustomDataTypes->getData() as $productCustomDataType}
            {*** Get the custom data for the the product and the customdata type ***}
            {collection assign=productCustomDatas controller=productCustomData productId=$product->Id typeId=$productCustomDataType->Id}

            {*** If there are any datas show them ***}
            {if $productCustomDatas->getActualSize() gt 0 and $productCustomDataType->Display == "1"}
            <tr id="m-product-customdata-type-{$productCustomDataType->Id}">
                {*** Show the title ***}
                <td class="m-product-customdata-title">{$productCustomDataType->Title}</td>
                {*** Iterate data to display, if a data is the last don't set a ","" ***}
                <td class="m-product-customdata-data">
                {foreach $productCustomDatas->getData() as $productCustomData}
                    <span id="m-product-customdata-data-{$productCustomData->DataId}" class="m-product-customdata-data-title">{$productCustomData->Title}{if !$productCustomData@last}, {else} {/if}</span>
                {/foreach}
                </td>
            </tr>
            {/if}
        {/foreach}
        </tbody>
    </table>
</div>
