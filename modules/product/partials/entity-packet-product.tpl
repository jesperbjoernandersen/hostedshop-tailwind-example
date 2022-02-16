{*

# Description
Template partial for the Packet products. Part of the Product page type.


## Date last modified
2015-09-07


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $variantController                                                    - Instance of productVariantController
+ $hasAdditionals                                                       - Boolean telling if product has additional products
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/product/partials/entity-actions.tpl"                        - Partial template for product actions (amount and buy button)

*}


{*

# Description
Helper function to show variants as select options


## Resource
+ [Smarty functions](http://www.smarty.net/docs/en/language.function.function.tpl)


## Supplied variables to function
+ $packetProduct
+ $productPacketGroup
+ $title

*}



{*** Helper function for line stock status ***}
{function packetSoldout}
    <div class="m-product-entity-packet-soldout m-product-soldout panel-danger" style="background-color:transparent;">
        {*** Check if we should show a icon ***}
        {if "texticon" === $settings.shop_product_delivery_time}
            <i class="fa fa-fw fa-clock-o m-product-packet-line-soldout-icon"></i>
        {/if}
        <i class="m-product-packet-line-soldout-text">
            {$text.SOLD_OUT} -
            {if $product->DeliveryTimeId gt 0}
                {$controller->getDeliveryTime($product->DeliveryTimeId, false)}
            {else}
                {$text.PRODUCT_CATALOG_STOCK_NOT_HOME}
            {/if}
        </i>
    </div>
{/function}



{*** Helper function for list generation ***}
{function variantOptions title=false packetVariants=false}

    {*** If title is not defined we have a single packetproduct and not a packetproductgroup and can show the variants only ***}
    {if $title}
        {$title = "$title - "}
    {/if}

    {*** Iterate over the variants and build the select ***}
    {foreach $packetVariants->getData() as $packetVariant}

        {*** A place to store the variant information for select2 ***}
        {$variant = []}

        {*** Get the data for the variant ***}
        {collection assign=variantData controller=productVariantData productId=$packetProduct->Id variantId=$packetVariant->Id}

        {*** Build the raw title ***}
        {foreach $variantData->getData() as $variantItem}
            {$variant[] = ["Title" => $variantItem->Title|utf8_encode, "Color" => $variantItem->Color]}
        {/foreach}

        {$amount = $packetProduct->PacketAmount * $product->MinAmount}
        {$soldout = $packetVariant->Stock < $amount}
        {$disabled = (!$packetProduct->AllowOutOfStockPurchase or !$product->AllowOutOfStockPurchase) and $soldout}

        {*** Apply our info to the options so we can use it in Select2 ***}
        <option
            value="{$packetVariant->PacketId}"
            data-value="{$packetVariant->PacketId}"
            data-title="{$title}"
            data-type="variant"
            data-variant='{json_encode($variant)}'
            data-packetamount="{$amount}"
            data-stock="{$packetVariant->Stock}"
            data-disabled="{if $disabled}true{else}false{/if}"
            {if $disabled}disabled="disabled"{/if}
        ></option>
    {/foreach}
{/function}

{*** Helper function for list generation (single variant) ***}
{function singleVariantItem}

    {*** Get the variant data ***}
    {$packetVariantItems = $packetVariants->getData()}
    {collection assign=variantData controller=productVariantData productId=$packetProduct->Id variantId=$packetVariantItems[0]->Id}

    {$amount = $packetProduct->PacketAmount * $product->MinAmount}
    {$soldout = $packetVariantItems[0]->Stock < $amount}
    {$disabled = (!$packetProduct->AllowOutOfStockPurchase or !$product->AllowOutOfStockPurchase) and $soldout}

    <div class="packet-entity m-product-packet-entity"
        data-packet="normal"
        data-packetamount="{$amount}"
        data-stock="{$packetVariantItems[0]->Stock}"
        data-disabled="{if $disabled}true{else}false{/if}"
    >
        <span class="m-product-entity-packet-amount">{$packetProduct->PacketAmount} x</span>
        <span class="m-product-entity-packet-title">
            {$packetProduct->Title} -
            {foreach $variantData->getData() as $variant}
                {if $variant->Color}
                    <span class="fa fa-square" style="color:#{$variant->Color};"></span>
                {/if}
                {$variant->Title}{if !$variant@last} / {/if}
            {/foreach}
        </span>
        {if $disabled}{packetSoldout product=$packetVariantItems[0]}{/if}
    </div>
    <input type="hidden"name="product[{$product->Id}][packet_products][]"value="{$packetVariantItems[0]->PacketId}">
{/function}


{*** Helper function for list generation ***}
{function normalPacketItem disabled=false title=false color=false}
    <div class="packet-entity m-product-packet-entity"
        data-packet="normal"
        data-packetamount="{$packetProduct->PacketAmount * $product->MinAmount}"
        data-stock="{$packetProduct->Stock}"
        data-disabled="{if $disabled}true{else}false{/if}"
    >
        <span class="m-product-entity-packet-amount">{$packetProduct->PacketAmount} x</span>
        <span class="m-product-entity-packet-title">{$packetProduct->Title}</span>
        {if $disabled}{packetSoldout product=$packetProduct}{/if}
    </div>
    <input type="hidden"name="product[{$product->Id}][packet_products][]"value="{$packetProduct->PacketId}">
{/function}


{*** Use to show message panel ***}
{$hasVariant = false}

{*** Use to show message panel error message ***}
{$hasDisabled = false}

{*** Collection of packet group ***}
{collection assign=productPacketGroups controller=productPacketGroup productId=$product->Id}

{*** If there are any packetgroups show the them ***}
{if productPacketGroups}
{* Product packet *}
<div class="m-product-packet">
    <div class="panel panel-border panel-rounded">
        <div class="panel-heading">
            {* Titel of Product packet *}
            <span class="m-product-packet-headline"><span class="h4">{$text.PRODUCT_CATALOG_PRODUCT_PACKET}</span></span>
        </div>

        <ul class="list-unstyled t-striped m-product-packet-list">

            {*** Run thru all groups ***}
            {foreach $productPacketGroups->getData() as $productPacketGroup}
                {*** Get the products for each group ***}
                {collection assign=packetProducts controller=productPacket productId=$product->Id packetGroupId=$productPacketGroup->Id}

                {*** Check if we have any products ***}
                {if $packetProducts->getActualSize() gt 0}

                    {*** Display a title if the group has one ***}
                    {$isNamedGroup = false}
                    {if !empty($productPacketGroup->Title)}
                        {$isNamedGroup = true}
                        <li>
                        <p class="m-product-packet-group-headline"><span class="h6">{$productPacketGroup->Title}</span></p>
                    {/if}

                    {*** If this is a named group and has more than one product, build a merged list instead of showing each product ***}
                    {if $isNamedGroup and $packetProducts->getActualSize() gt 1}

                        <fieldset class="form-group m-product-packet-group">
                            <select data-packet="dropdown" style="width:100%;" name="product[{$product->Id}][packet_products][]" data-placeholder="{$text.CHOOSE_VARIANT} {$text.PRODUCT_CATALOG_PRODUCT}">
                                <option></option>
                                {*** Iterate over alle the packet products ***}
                                {foreach $packetProducts->getData() as $packetProduct}
                                    {*** If the packetproduct is a variant, handle all the variants ***}
                                    {if $packetProduct->Type==="variant"}
                                        {$hasVariant = true}
                                        {collection assign=packetVariants controller=productVariantPacket packetId=$packetProduct->PacketId}
                                        {*** Call helper function to display the variants as options ***}
                                        {variantOptions packetProduct=$packetProduct packetVariants=$packetVariants title="{$packetProduct->PacketAmount} x {$packetProduct->Title|escape:'htmlall':'ISO-8859-1'}"}
                                    {else} {*** Else just display the single product ***}
                                        {$amount = $packetProduct->PacketAmount * $product->MinAmount}
                                        {$soldout = $packetProduct->Soldout or $packetProduct->Stock < $amount}
                                        {$disabled = (!$packetProduct->AllowOutOfStockPurchase or !$product->AllowOutOfStockPurchase) and $soldout}
                                        <option value="{$packetProduct->PacketId}"
                                            data-title="{$packetProduct->PacketAmount} x {$packetProduct->Title|escape:"htmlall":"ISO-8859-1"}"
                                            data-type="normal"
                                            data-value="{$packetProduct->PacketId}"
                                            data-packetamount="{$packetProduct->PacketAmount}"
                                            data-stock="{$packetProduct->Stock}"
                                            data-disabled="{if $disabled}true{else}false{/if}"
                                            {if $disabled}disabled="disabled"{/if}
                                        ></option>
                                    {/if}
                                {/foreach}
                            </select>
                        </fieldset>

                    {*** Build an item per product ***}
                    {else}

                        {*** Run thru all packet products ***}
                        {foreach $packetProducts->getData() as $packetProduct}

                            {*** If this is not a named group, print an <li> for each product ***}
                            {if !$isNamedGroup}
                            <li>
                            {/if}

                            {*** If packet product is variant, check for more than 1 variant type ***}
                            {$itemHasVariants = 0}
                            {if $packetProduct->Type==="variant"}
                                {*** Fetch all variants of packet product ***}
                                {collection assign=packetVariants controller=productVariantPacket packetId=$packetProduct->PacketId}

                                {*** Get the count of variants ***}
                                {$itemHasVariants = $packetVariants->getActualSize()}
                            {/if}

                            {if $itemHasVariants gt 1}
                                {$hasVariant = true}
                                <div class="m-product-packet-variant-title">{$packetProduct->PacketAmount} x {$packetProduct->Title}</div>
                                <fieldset class="form-group">
                                    <select data-packet="dropdown" data-placeholder="{$text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT}" style="width:100%;" name="product[{$product->Id}][packet_products][]">
                                        <option></option>
                                        {*** Call helper function to display the variants as options ***}
                                        {variantOptions productPacketGroup=$productPacketGroup packetProduct=$packetProduct packetVariants=$packetVariants}
                                    </select>
                                </fieldset>

                            {elseif $itemHasVariants eq 1}
                                {*** Call helper function to display the single variant ***}
                                {singleVariantItem packetProduct=$packetProduct packetVariants=$packetVariants}

                            {else}
                                {$amount = $packetProduct->PacketAmount * $product->MinAmount}
                                {$soldout = $packetProduct->Soldout or $packetProduct->Stock < $amount}
                                {$disabled = (!$packetProduct->AllowOutOfStockPurchase or !$product->AllowOutOfStockPurchase) and $soldout}
                                {if $disabled}
                                    {$hasDisabled = true}
                                {/if}
                                {normalPacketItem packetProduct=$packetProduct disabled=$disabled}
                            {/if}

                            {*** If this is not a named group the open <li> has been printed inside the loop and needs to be closed ***}
                            {if !$isNamedGroup}
                            </li>
                            {/if}

                        {/foreach}

                    {/if}

                    {*** If this is a named group an open <li> has been printed outside the loop and needs to be closed ***}
                    {if $isNamedGroup}
                    </li>
                    {/if}
                {/if}
            {/foreach}
        </ul>{* END: .list-unstyled.t-striped *}
    </div>{* END: panel.panel-border.panel-rounded *}

    {*** If the packet has any variants and is not disabled, show the CHOOSE_PACKET infopanel ***}
    {if !$product->Soldout and $hasVariant and !$hasDisabled}
        {* Separator *}
        <hr class="m-product-packet-separator-variant">
        <div class="variantInfoPanel m-product-packet-variantInfoPanel" data-controller="infoPanel">
            <div class="panel panel-warning panel-rounded">
                <div class="panel-body">
                    <strong><span class="m-product-packet-chosePacketWarning"><i class="fa fa-exclamation-circle"></i> {$text.CHOOSE_PACKET}</span></strong>
                </div> {* END: .panel-body *}
            </div> {* END: .panel.panel-warning.panel-rounded *}
        </div> {* END: .variantInfoPanel *}

    {*** Standard stock information ***}
    {else}
        {* Seperator *}
        <hr class="m-product-packet-separator-stock">
        {*** Include product stock information ***}
        {include file="modules/product/partials/entity-stock.tpl" item=$product}
    {/if}

    {*** Include product actions; buy and amount ***}
    {if $product->Type !== 'discontinued' and ($product->AllowOutOfStockPurchase or !$product->Soldout) and !$hasAdditionals}
        <hr class="m-product-packet-separator">
        {include file="modules/product/partials/entity-actions.tpl" product=$product inputName="product[{$product->Id}][amount]" inputValue=$product->MinAmount data=""}
    {/if}

</div>{* END: .m-product-packet *}

{/if}

{include file="modules/product/partials/entity-js-infopanels.tpl"}
