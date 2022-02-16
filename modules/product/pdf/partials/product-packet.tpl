{*

# Description
Creates all additional data for packet-product

## Date last modified
2021-08-24

*}

{*** Function: Variant-list ***}
{function variantOptions packetProduct=false packetVariants=false}
    <strong>{$text.PRODUCT_CATALOG_PRODUCT_VARIANTS}:</strong>
    <ul>
        {foreach $packetVariants->getData() as $packetVariant}
            {* Get the data for the variant *}
            {collection assign=variantData controller=productVariantData productId=$packetProduct->Id variantId=$packetVariant->Id}

            <li>
                {foreach $variantData->getData() as $variant}
                    {if $variant->Color}
                        <i class="square" style="background: #{$variant->Color}"></i>
                    {/if}
                    {$variant->Title}{if !$variant@last} / {/if}
                {/foreach}
            </li>
        {/foreach}
    </ul>
{/function}

{*** Function: Single variant ***}
{function singleVariantItem}
    {* Get the variant data *}
    {$packetVariantItems = $packetVariants->getData()}
    {collection assign=variantData controller=productVariantData productId=$packetProduct->Id variantId=$packetVariantItems[0]->Id}

    {foreach $variantData->getData() as $variant}
        {if $variant->Color}
            <i class="square" style="background: #{$variant->Color};"></span>
        {/if}
        {$variant->Title}
        {if !$variant@last} / {/if}
    {/foreach}
{/function}

{*** Collection of packet group ***}
{collection assign=productPacketGroups controller=productPacketGroup productId=$product->Id}

{if $productPacketGroups}
    <h2>{$text.PRODUCT_CATALOG_PRODUCT_PACKET}</h2>
    <hr>

    {* Define table list: use 2 rows *}
    {$list = []}

    {foreach $productPacketGroups->getData() as $productPacketGroup}

        {* Get the products for each group *}
        {collection assign=packetProducts controller=productPacket productId=$product->Id packetGroupId=$productPacketGroup->Id}

        {* Check if we have any products *}
        {if !$packetProducts->getActualSize() > 0}
            {break}
        {/if}

        {* Display a title if the group has one *}
        {$isNamedGroup = false}
        {if !empty($productPacketGroup->Title)}
            {$isNamedGroup = true}
            {$list[] = [
                isHead => true,
                cells => [
                    "{$productPacketGroup->Title}:",
                    "&nbsp;"
                ]
            ]}
        {/if}

        {foreach $packetProducts->getData() as $packetProduct}

            {* New table Row*}
            {$listRow = [ cells => [] ]}

            {* If packet product is a variant, check for more than 1 variant type *}
            {$itemVariantsAmount = 0}
            {if $packetProduct->Type === "variant"}
                {collection assign=packetVariants controller=productVariantPacket packetId=$packetProduct->PacketId}
                {$itemVariantsAmount = $packetVariants->getActualSize()}
            {/if}

            {$listRow.cells[] = "{$packetProduct->PacketAmount} x {$packetProduct->Title}"}

            {if $itemVariantsAmount > 1}
                {$listRow.cells[] = {variantOptions 
                    packetProduct=$packetProduct 
                    packetVariants=$packetVariants}
                }
            {elseif $itemVariantsAmount === 1}
                {$listRow.cells[] = {singleVariantItem 
                    packetProduct=$packetProduct 
                    packetVariants=$packetVariants}
                }
            {else}
                {$listRow.cells[] = '&nbsp;'}
            {/if}
            {$list[] = $listRow}
        {/foreach}
    {/foreach}

    {*** Make table ***}
    {include 
        file="modules/product/pdf/partials/table-list.tpl" 
        name="packet-table"
        list=$list}
{/if}
