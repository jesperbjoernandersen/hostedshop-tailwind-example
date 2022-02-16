{*

# Description
Template for a list of news articles with microdata markup.


## Date last modified
2021-02-09


## Primary variables
+ $controller 															- Instance of NewsController
+ $items 																- Collection of NewsController
+ $pager 																- Toggle for pagination, accepts true/false. Defaults to true.
+ $perPage 																- Amount of news articles to show per page. Defaults to 10.
+ $imageController														- Instance of filesController
+ $image																- Entity of filesController with type news (first image for news article)


## Partials (templates)
+ "/modules/widgets/pagination/pagination.tpl"							- Pagination widget to handle pagination of the news list

*}

{* Fetch the filesController and save it for later *}
{controller type=files assign=imageController}

{* Calculate the actual size of the collection *}
{$collectionSize = $items->getActualSize()}

{$imageWidth = 320}
{$imageHeight = 240}
{include file="modules/widgets/image/placeholder-aspect.tpl"

	width=$imageWidth
	height=$imageHeight
	selector=":not(.ielt9) .m-news-list"}

{* Start of module *}
<div class="modules m-news-list">
	{* Header of the news page *}
	<header class="m-news-page-header"><h1 class="m-news-page-headline page-title">{$page.headline}</h1></header>

	{* Check if there are any news articles to show from the collection *}
	{if $collectionSize gt 0}

	{* Start an unstyled list with borders *}
	<ol class="list-unstyled t-border-bottom m-news-list-container" itemscope itemtype="http://schema.org/ItemList">

		{* Loop through news articles *}
		{foreach $items->getData() as $item}

			{* Fetch the link of the page for this specific item *}
			{$pageLink = {page id=$item->PageId print=Link}}
			<li class="trailing-trip m-news-list-item" id="m-news-{$item->Id}" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
				<meta itemprop="position" content="{$item@iteration}">
				<meta itemprop="url" content="{$page.url}/{$item->Handle}/">

				{* Article content for specific news article *}
				<article class="row trailing-trip" itemscope itemtype="http://schema.org/NewsArticle">
					{* Include publisher information as required by Google's Rich Data specification *}
					{include file="modules/widgets/semantics/organization.tpl" itemprops="author publisher"}

					{* Fetch the first image of this news article *}
					{entity assign=image controller=$imageController type=news id=$item->Id}

					{* Check if the article contain any images *}
					{if $image}
						{$imageWidth = 412}
						{$imageHeight = 240}
						{$imageURL = $image->thumbnail($imageWidth, $imageHeight, true, $template.watermark)|solutionPath}
						<figure class="col-s-4 col-m-4 col-l-4 col-xl-8 m-news-list-imagewrap">
							<a href="/{$pageLink}/{$item->Handle}/" class="m-news-list-anchor m-news-list-image placeholder-wrapper" title="{$item->Title}">
								<span class="placeholder"></span>
								{img class="responsive" alt="{$item->Title}" src="{$imageURL}"}
							</a>
						</figure>
						{include file="modules/widgets/semantics/image-object.tpl" itemprops="image" imageURL=$imageURL height=$imageHeight width=$imageWidth}
					{/if}

					{if $image}
						<div class="content col-s-4 col-m-8 col-l-8 col-xl-16 m-news-list-textwrap">
					{else}
						<div class="content col-s-4 col-m-12 col-l-12 col-xl-24 m-news-list-textwrap">
					{/if}

						{* Headline of this specific news article *}
						<header class="m-news-list-headline">
							<a href="/{$pageLink}/{$item->Handle}/" class="m-news-list-anchor" title="{$item->Title}"><h4 class="h2" itemprop="headline">{$item->Title}</h4></a>

				            {* Time of creation *}
							<p class="m-news-list-date">
					            <small><span class="m-news-list-date-added">{$text.BLOG_DATE_ADD}</span> <time class="m-news-list-date-time" datetime="{$item->DateCreated}" itemprop="datePublished">{$item->DateCreated|date_format:$general.dateFormat}</time></small>
					        </p>
						</header>

						{* The description of this news article, stripped for html tags, truncated to 250 characters *}
						<div class="m-news-list-description description" itemprop="description">{$controller->getDescription($item->Id)|strip_tags|truncate:250}</div>

                        {* Generate a link to this article *}
                        <br />
						<a href="/{$pageLink}/{$item->Handle}/" class="m-news-list-anchor m-news-list-readmore button" itemprop="url" title="{$text.PRODUCT_CATALOG_READ_MORE}"><span class="m-news-list-anchor-text">{$text.PRODUCT_CATALOG_READ_MORE}</span> <i class="fa fa-long-arrow-right"></i></a>
					</div>
				{* End of article content *}
				</article>
			</li>
		{/foreach}
	</ol>

	{* Pagination for the list if enabled *}
	{if (!isset($pager) or !!$pager)}
		<div class="m-news-list-pagination">
			{include file='modules/widgets/pagination/pagination.tpl' pageSize=$pageSize size=$collectionSize}
		</div>
	{/if}

	{* If no news articles were found in the collection *}
	{else}
        <div class="panel panel-warning">
            <div class="panel-body">
               <span>{$text.NO_DATA}</span>
            </div>
        </div>
	{/if}

{* End of module *}
</div>
