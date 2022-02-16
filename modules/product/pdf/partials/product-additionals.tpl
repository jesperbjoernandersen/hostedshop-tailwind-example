{*

# Description
collection of additional content that relates to the product

## Date last modified
2021-08-24

*}

{*** Additional information ***}
<div class="additionals">

    {*** Product type partials ***}
    {if $product->Type === "variant"}
        {include file="modules/product/pdf/partials/product-variantlist.tpl" product=$product}
    {elseif $product->Type === "packet"}
        {include file="modules/product/pdf/partials/product-packet.tpl" product=$product}
    {/if}

    {*** Description ***}        
    {$longDesc = $productController->getDescription($product->Id)}
    {if !empty($longDesc)}
        <h2>{$text.DESCRIPTION}</h2>
        <hr>
        <div class="additionals-description ck-content">{$longDesc}</div>
    {/if}

    {include file="modules/product/pdf/partials/additionals-custom-data.tpl"}

    {include file="modules/product/pdf/partials/additionals-extra-buy.tpl" product=$product}
</div>