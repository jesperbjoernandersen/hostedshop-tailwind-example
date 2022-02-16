{*

# Description
Smarty template for product lists. Part of the Product page type. This list is ment for crawlers


## Date last modified
2021-10-13


## Primary variables
+ $items 													- Collection of products from either productListController, productRelatedController or productAlsoBoughtController
+ $related  												- Boolean telling if list consists
+ $title 													- (Optional) Title for the product list
+ $pager 													- Boolean telling to show or hide the pagination widget
+ $pageSize 												- Number of products in list


## Partials (templates)
+ "/modules/product/product-list-entity-item.tpl"			- Partial template for a product in the list of a category
+ "/modules/widgets/pagination/pagination.tpl"              - Pagination widget, for pagination generation

*}

{$data = null}

{if $items and $items->getActualSize() gt 0}
	{$size = $items->getActualSize()}
	{collection assign=products controller=product productId=$items->pluck('Id')}
{else}
	{if $products}
		{$size = $products->getActualSize()}
	{/if}
{/if}


<div class="modules m-productlist">

    {controller assign=categoryController type=productCategory}
    {entity assign=category controller=$categoryController id=(int)$page.paths.1}

    {$title = $category->Title}
		{$descriptionTop = $categoryController->getDescription($category->Id)}
		{$descriptionBottom = $categoryController->getDescriptionBottom($category->Id)}

    <div class="row">
    	<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
        	{*** Category title ***}
        	<header class="category-headline page-title">
    			<h1 class="category-headline">{if !$title}{$page.headline}{else}{$title}{/if}</h1>
    		</header>

        	{*** Category description ***}
        	{if $descriptionTop}
    			<div class="category-description ck-content trailing clearfix">{$descriptionTop}</div>
    		{/if}
    	</div>
    </div>

	{if $products and $size gt 0}
		<div class="row">
			{foreach $products->getData() as $product}
	    		{include file='modules/product/product-list-entity-item.tpl'}
			{/foreach}
		</div>

		{if !empty($pager)}
			{include file='modules/widgets/pagination/pagination.tpl' pageSize=$pageSize size=$size}
		{/if}
	{else}
		<div class="col-s-4 col-m-12 col-l-12 col-xl-24 text-center emptyCategory">
			<div class="panel panel-warning">
				<div class="panel-body">
					{$text.PRODUCT_CATALOG_CATEGORY_EMPTY}
				</div>
			</div>
		</div>
	{/if}

	<div class="row">
    	<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
        	{*** Category description bottom ***}
        	{if $descriptionBottom}
    			<div class="category-description-bottom ck-content trailing clearfix">{$descriptionBottom}</div>
    		{/if}
    	</div>
    </div>
</div>
