{*

# Description
Template partial for the sitemap overview. Part of the Sitemap page type.


# Date last modified
2017-05-19


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


<div class="modules m-sitemap">
	<article class="m-sitemap-article">
		<header class="m-sitemap-header page-title">
			<h1 class="m-sitemap-headline">{$text.SITEMAP_HEADLINE}</h1>
		</header>

		<div class="m-sitemap-description description trailing">
			<p class="m-sitemap-description">{$text.SITEMAP_TEXT_TOP}</p>
		</div>

		<div class="m-sitemap-content content">
			<ul class="m-sitemap m-links list-unstyled">
				<li class="m-sitemap-item m-links-category">
					<a href="/{$page.paths.0}/{$text.SITEMAP_LINK_CATEGORIES}/" title="{$text.SITEMAP_VIEW_ALL_CATEGORIES}">{$text.SITEMAP_VIEW_ALL_CATEGORIES}</a>
				</li>
				<li class="m-sitemap-item m-links-products">
					<a href="/{$page.paths.0}/{$text.SITEMAP_LINK_PRODUCTS}/" title="{$text.SITEMAP_VIEW_ALL_PRODUCTS}">{$text.SITEMAP_VIEW_ALL_PRODUCTS}</a>
				</li>
				<li class="m-sitemap-item m-links-pages">
					<a href="/{$page.paths.0}/{$text.SITEMAP_LINK_PAGES}/" title="{$text.SITEMAP_VIEW_ALL_PAGES}">{$text.SITEMAP_VIEW_ALL_PAGES}</a>
				</li>
			</ul>
		</div>
	</article>
</div>