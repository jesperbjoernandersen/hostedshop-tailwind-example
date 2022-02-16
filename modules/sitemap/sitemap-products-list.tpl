{*

# Description
Template partial for the sitemap products list. Part of the Sitemap page type.


# Date last modified
2017-05-19


## Primary variables
+ $pager 																- Boolean telling to show or hide pagination
+ $perPage 																- Number of items pr. page
+ $productList 															- Collection of productListController


## Partials (templates)
+ "/modules/widgets/pagination/pagination.tpl"                          - Pagination widget, for pagination generation

*}


{$pager = true}

{$perPage = 100}

{collection controller=productList assign=productList pageSize=$perPage orderBy="Sorting,Title" primary=true}

<div class="modules m-sitemap-prod">
	<article class="m-sitemap-prod-article">
		<header class="m-sitemap-prod-header page-title">
			<h1 class="m-sitemap-prod-headline">{$text.SITEMAP_HEADLINE}</h1>
		</header>

		<div class="m-sitemap-prod-content content">
			{$productListCount = $productList->getActualSize()}
			{if $productListCount gt 0}
				<ul class="m-sitemap-prod m-links list-unstyled">
					{foreach $productList->getData() as $product}

						<li class="m-sitemap-prod-item m-links-prod"><a href="{ProductController::link($product->Id)}" title="{$product->Title|utf8_decode}">{$product->Title|utf8_decode}</a></li>
					{/foreach}
				</ul>

				{if isset($pager) and $pager}
					<div class="m-sitemap-prod-pagination">
						{include file='modules/widgets/pagination/pagination.tpl' pageSize=$perPage size=$productListCount}
					</div>
				{/if}
			{/if}
		</div>
	</article>
</div>