{*

# Description
Template for Product tags in a column box


## Date last modified
2014-08-01


## Primary variables
+ $tagController                                            - Instance of the productTagController
+ $pagelink                                            		- Link to the product page


## Partials (templates)
No extra templates required for this template

*}

{controller assign=tagController type=productTag}
{$pagelink = {page id=$page.productPageId print=Link}}
{$productTags = $tagController->getTagsGrouped(5)}

<div class="panel panel-border column-box b-product-tags">
	<div class="panel-heading b-product-tags-header b-header">
		<span class="h5">{$text.PRODUCT_CATALOG_SHOP_BY_TAGS}</span>
	</div>

	<div class="panel-body">
		{if $productTags|count gt 0}
			<ul class="nav nav-menu">
				{foreach $productTags as $tag}
					<li><a href="/{$pagelink}/?tag={$tag.title}"><span>{$tag.title} ({$tag.count})</span></a></li>
				{/foreach}
			</ul>
		{else}
			{$text.PRODUCT_TAGGING_NONE}
		{/if}
	</div>
</div>
