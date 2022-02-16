{*

# Description
Controller for the News page type


## Date last modified
2020-08-28


## Primary variables
+ $controller															- Instance of newsController
+ $item																	- Entity of newsController (single news article)
+ $items																- Collection of newsController (list of news articles)
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/news/news-entity.tpl"                     					- Template for a single newsarticle
+ "/modules/news/news-list.tpl"                     					- Template for a list of news articles
+ "/modules/widgets/meta/opengraph.tpl"                     			- Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{* Fetch a newsController and set it as primary *}
{controller type=news assign=controller primary=true}

{* Check the request uri for any additional levels and show the entity template accordingly *}
{if !empty($page.paths.1)}

	{* Get news item *}
	{entity controller=$controller assign=item}

	{* Check if there is an item to show *}
	{if $item}
		{* Breadcrumb *}
		{addBreadCrumb title=$item->Title path=$item->Handle defaultPath=true}

		{*** Meta title ***}
		{$opengraph_title = $item->Title}

		{*** Meta image ***}
		{entity assign=image controller=files type=news id=$item->Id pageSize=1}
		{if $image}
			{$opengraph_image = $image->thumbnail(1200)|solutionPath}
		{/if}

		{*** Meta description ***}
		{$opengraph_description = {$controller->getDescription($item->Id)|strip_tags|truncate:160}}

		{* Push the view for a single news item with data *}
		{include file='modules/news/news-entity.tpl' item=$item controller=$controller}
	{else}
		{notfound}
	{/if}

{* If no extra request uri was found, show the entire list of news items for this page *}
{else}

	{* Set number of items to be shown per page *}
	{$pageSize = 6}
	{* Fetch collection based on the primary controller *}
	{collection assign=items controller=$controller pageSize=$pageSize}
	{* Push the view for a news list with data *}
	{include file='modules/news/news-list.tpl' items=$items controller=$controller pageSize=$pageSize}

{/if}{* End of controller *}

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
