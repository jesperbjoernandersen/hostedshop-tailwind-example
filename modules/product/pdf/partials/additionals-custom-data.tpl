{*

# Description
Prints out list from the the specifications tab

## Date last modified
2021-08-24

*}

{*** Collection entity of the customdataType controller ***}
{collection assign=productCustomDatas controller=productCustomData productId=$product->Id}
{collection assign=productCustomDataTypes controller=productCustomDataType productId=$product->Id}

{*** Product custom data ***}
{$hasCustomData = false}

{foreach $productCustomDataTypes->getData() as $productCustomDataType}
    {* Get the custom data for the the product && the customdata type *}
    {collection assign=productCustomDatas controller=productCustomData productId=$product->Id typeId=$productCustomDataType->Id}

    {* If there are any data show them *}
    {if $productCustomDatas->getActualSize() > 0 && $productCustomDataType->Display == "1"}
        {foreach $productCustomDatas->getData() as $productCustomData}
            {$hasCustomData = true}
            {break}
        {/foreach}
    {/if}
{/foreach}

{if $hasCustomData && $access.customData}
    <h2>{$text.SPECIFICATIONS}</h2>
    <hr>

    {* Define table list: use 2 rows *}
    {$list = []}

    {foreach $productCustomDataTypes->getData() as $productCustomDataType}

        {* Get the custom data for the the product and the customdata type *}
        {collection assign=productCustomDatas controller=productCustomData productId=$product->Id typeId=$productCustomDataType->Id}

        {if $productCustomDatas->getActualSize() > 0 && $productCustomDataType->Display == "1"}

            {$listRow = [ 'cells' => [] ]}

            {$listRow.cells[] = $productCustomDataType->Title}

            {function customDataContent}
                {foreach $productCustomDatas->getData() as $productCustomData}
                    {strip}
                        <p>
                            {$productCustomData->Title}
                            {if !$productCustomData@last}, {/if}
                        </p>
                    {/strip}
                {/foreach}
            {/function}
            {$listRow.cells[] = {customDataContent}}
        {/if}

        {$list[] = $listRow}
    {/foreach}

    {*** Make table ***}
    {include 
        file="modules/product/pdf/partials/table-list.tpl" 
        name="custom-data-table"
        cellsPerRow=2
        list=$list}
{/if}