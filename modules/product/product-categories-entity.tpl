{*

# Description
Template for a category. Part of the Product page type.


## Date last modified
2021-02-09


## Primary variables
+ $item 													- Entity of productCategoryController (a single shop product category)
+ $pagelink 												- Link / URL to the product page


## Partials (templates)
No extra templates required for this template

*}

{* Placeholder image *}
{placeholdImage assign=placeholder width=380 height=380 background=$template.settings.DESIGN_IMAGE_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}

{$crop = "fill"}
{if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
    {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
{/if}
{$pagelink = {page id=$page.productPageId print=Link}}
<div class="col-s-2 col-m-3 col-l-4 col-xl-6 category-item" data-mh="category-item">

	{* Category *}
	<article class="category-item-content">
		{* Category picture *}
		<figure class="category-item-image">
			{entity assign=image controller=files type=category id=$item->Id}
			{if $image}
				{$imgpath = $image->thumbnail(380, 380, $crop)|solutionPath}
			{else}
				{$imgpath = $placeholder->getRelativeFile()|solutionPath}
			{/if}
      <a class="placeholder-wrapper trailing-db" href="/{$pagelink}/{$item->Handle}/" title="{$item->Title}" data-placeholder-max-width="380px">
	      <span class="placeholder"></span>
        {img class="responsive" alt="{$item->Title}" src="{$imgpath}"}
      </a>
		</figure>

		{* Category title *}
		<header class="category-item-title">
			<a href="/{$pagelink}/{$item->Handle}/" title="{$item->Title}"><h4 class="h5">{$item->Title}</h4></a>
		</header>
	</article>
</div>
