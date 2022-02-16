{*

# Description
Template for the category list. Part of the Product page type.


## Date last modified
2014-08-01


## Primary variables
+ $items                                                    - Collection of categoryController (a list of shop product categories)
+ $columns                                                  - Global scope variable containing columns
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/slider/slider.tpl"                      - Image slider widget, for blog post picture
+ "/modules/product/product-categories-entity.tpl"          - Partial template for displaying a single category in the list

*}


{* Product categories *}
<div class="modules m-products-category" itemscope itemtype="http://schema.org/Enumeration">
    {* Page title *}
	<header class="m-products-category-header page-title">
		<h1 class="m-products-category-headline" itemprop="name">{$page.headline}</h1>
	</header>

	<div class="row">
		{foreach $items->getData() as $item}
			{include file='modules/product/product-categories-entity.tpl' item=$item}
		{/foreach}
	</div>
</div>
{* Product categories end *}
