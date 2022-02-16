{*

# Description
Controller for product lists. Part of the Product page type.

The controller distinguishes between crawlers and client requests and generates different lists for each type of request:
* For normal clients it generates a Javascript and [AngularJS](https://angularjs.org/) list.
* For crawlers (like Google and Bing) it generates a Smarty based liss.

The distinguishment is done to give both types of visitors the best experience possible:
* Normal clients get a faster and AJAX based list.
* Crawlers get a list without Javascript for better indexing.


## Date last modified
2021-02-09


## Primary variables
+ $type 													- Type of product list to display
+ $id 														- (Optional) Id of the type to display
+ $title 													- (Optional) Title for the product list
+ $orderBy 													- (Optional) Comma separated list of attributes to sort (only if type is applicable)
+ $productlist 												- Collection of products from either productListController, productRelatedController or productAlsoBoughtController
+ $columns 													- Global scope variable containing columns
+ $client 													- Global scope variable containing info about the visiting client



## Partials (templates)
+ "/modules/product/product-list-entity.tpl"				- Smarty partial template for product list of a category (for crawlers)
+ "/modules/product/product-list-js-entity.tpl" 			- AngularJS partial template for product list of a category (for normal clients)

*}

{if !isset($related)}
	{$related = false}
{/if}

{setting assign=orderBySetting key=shop_productlist_sorting_standard}

{if $client.isCrawler}
	{$pager = false}
	{$products = null}
	{if empty($productlist)}

		{if empty($pageSize)}
			{$pageSize = 48}
		{/if}

		{if !empty($orderBy)}
			{$orderByProp = $orderBy}
		{elseif isset($type) and $type eq 'orderBy'}
			{$orderByProp = $id}
		{else}

			{$orderByProp = null}
			{$useOwnSorting = false}
			{$useOwnSortingForce = false}

			{if $orderBySetting eq 'recommended'}
				{setting assign=orderBySetting key=shop_productlist_sorting_recommended_sorting}
				{$useOwnSortingForce = true}
			{/if}

			{if $orderBySetting eq 'title'}
				{$orderByProp = 'Title'}
				{setting assign=useOwnSorting key=shop_productlist_sorting_title_overwrite}
			{elseif $orderBySetting eq 'price'}
				{$orderByProp = 'SortPrice'}
				{setting assign=useOwnSorting key=shop_productlist_sorting_price_overwrite}
			{elseif $orderBySetting eq 'price_high'}
				{$orderByProp = '-SortPrice'}
				{setting assign=useOwnSorting key=shop_productlist_sorting_price_high_overwrite}
			{elseif $orderBySetting eq 'date'}
				{$orderByProp = 'Age'}
				{setting assign=useOwnSorting key=shop_productlist_sorting_date_overwrite}
			{elseif $orderBySetting eq 'bestseller'}
				{$orderByProp = '-Sold'}
				{setting assign=useOwnSorting key=shop_productlist_sorting_bestseller_overwrite}
			{elseif $orderBySetting eq 'number'}
				{$orderByProp = 'ItemNumber'}
				{setting assign=useOwnSorting key=shop_productlist_sorting_number_overwrite}
			{/if}

			{if !$orderByProp}
				{$orderByProp = '-Sold'}
			{/if}

			{if $useOwnSortingForce or $useOwnSorting}
				{$orderByProp = "Sorting,$orderByProp"}
			{/if}
		{/if}

		{$productlist = null}
		{if $type eq 'orderBy'}
			{collection controller=productList assign=productlist pageSize=$pageSize orderBy=$orderByProp}
		{elseif !empty($productId)}
			{collection controller=product assign=products productId=explode(',', $productId)}
		{else}
			{$pager = true}
			{collection controller=productList assign=productlist pageSize=$pageSize primary=true orderBy=$orderByProp}
		{/if}
	{/if}
	{include file='modules/product/product-list-entity.tpl' items=$productlist products=$products pager=$pager related=$related pageSize=$pageSize}
{else}

	{if !isset($order)}
		{$order = $orderBySetting}
	{/if}

	{if !isset($orderBy)}
		{$orderBy = null}
	{/if}

	{if !isset($viewmode)}
		{$viewmode = 2}
		{if isset($settings.module_shop_productlist)}
			{$viewmode = $settings.module_shop_productlist}
		{/if}
	{/if}

	{if !isset($showEmpty)}
		{$showEmpty = false}
	{/if}

	{$filter = true}
	{$sortbar = true}
	{$pager = true}
	{$session = true}

	{* Special cases *}
	{if !empty($productId) or !empty($productlist)}
		{$filter = false}
		{$sortbar = false}
		{$pager = false}
		{$session = false}
		{if !empty($productlist)}
			{$productId = implode(',', $productlist->pluck('Id'))}
		{/if}
	{elseif $type eq 'categoryId'}
		{$filter = $id}
    {/if}

	{include file='modules/product/product-list-js-entity.tpl' itemId=$id field=$type onlyProducts=$onlyProducts}
{/if}
