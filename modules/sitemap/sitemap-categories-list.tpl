{*

# Description
Template partial for the sitemap categories list. Part of the Sitemap page type.


# Date last modified
2017-05-19


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $categoryController 													- Instance of productCategoryController
+ $productCategories													- Collection of productCategoryController


## Partials (templates)
No extra templates required for this template

*}

{* Start product category controller *}
{controller assign=categoryController type=productCategory}

{* Category collection *}
{collection assign=productCategories controller=$categoryController parentId=false}

{$pagelink = {page id=$page.productPageId print=Link}}

<div class="modules m-sitemap-cat">
	<article class="m-sitemap-cat-article">
		<header class="m-sitemap-cat-header page-title">
			<h1 class="m-sitemap-cat-headline">{$text.SITEMAP_HEADLINE}</h1>
		</header>

		<div class="m-sitemap-cat-content content">
			<ul class="m-sitemap-cat m-links list-unstyled">
				{foreach $productCategories->getData() as $productCategory}
					<li class="m-sitemap-cat-item m-links-cat"><a href="/{$pagelink}/{$productCategory->Handle}/" title="{$productCategory->Title}">{$productCategory->Title}</a></li>
				{/foreach}
			</ul>
		</div>
	</article>
</div>