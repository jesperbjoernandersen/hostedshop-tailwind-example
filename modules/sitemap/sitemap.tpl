{*

# Description
Controller for the Sitemap page type.


# Date last modified
2020-08-28


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}


{if isset($page.paths.1)}

	{if $page.paths.1 == $text.SITEMAP_LINK_CATEGORIES}
		{addBreadCrumb title=$text.SITEMAP_VIEW_ALL_CATEGORIES defaultPath=true}
		{include file='modules/sitemap/sitemap-categories-list.tpl'}
	{elseif $page.paths.1 == $text.SITEMAP_LINK_PRODUCTS}
		{addBreadCrumb title=$text.SITEMAP_VIEW_ALL_PRODUCTS defaultPath=true}
		{include file='modules/sitemap/sitemap-products-list.tpl'}
	{elseif $page.paths.1 == $text.SITEMAP_LINK_PAGES}
		{addBreadCrumb title=$text.SITEMAP_VIEW_ALL_PAGES defaultPath=true}
		{include file='modules/sitemap/sitemap-pages-list.tpl'}
	{/if}

{else}

	{if $general.isShop}
		{include file='modules/sitemap/sitemap-overview.tpl'}
	{else}
		{include file='modules/sitemap/sitemap-pages-list.tpl'}
	{/if}

{/if}

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}