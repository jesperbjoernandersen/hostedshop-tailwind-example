{*

# Description


## Date last modified
2021-08-24

*}

{*** FIles controller ***}
{controller assign=imageController type=files}

{if isset($smarty.get.variantId)}
    {collection assign=variantImages controller=$imageController type=variant variantId=(int)$smarty.get.variantId}
{/if}

{if isset($variantImages) && $variantImages->getActualSize() > 0}
    {$images = $variantImages}
{else}
    {collection assign=images controller=$imageController type=product productId=$product->Id}
{/if}

<style>
    .product-images {
        width: 100%;
    }
    .product-images img {
        width: 100%;
        height: auto;
    }
</style>

{$imageWidth = 610}
{$imageHeight = 610}
{$imageSrc = ''}

{if $images->getActualSize() > 0}
    {foreach $images->getData() as $image}
        {$imageSrc = $image->thumbnail($imageWidth, $imageHeight, "fill", $template.watermark)|solutionPath}
        {break}
    {/foreach}
{else}
    {placeholdImage 
        assign=placeholder 
        width=$imageWidth 
        height=$imageHeight 
        background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR 
        color=$template.settings.FONT_COLOR_PRIMARY 
        text=$text.IMAGE_PLACEHOLDER_TEXT
    }
    {$imageSrc = $placeholder->getRelativeFile()|solutionPath}
{/if}

<div class="product-images">
    <img src="{$imageSrc}" alt="Product picture">
</div>