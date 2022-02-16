{*

# Description
Template for News items in a column box


## Date last modified
2015-03-18


## Primary variables
+ $controller                                               - Instance of newsController
+ $newsitems                                                - Collection of blogController (a list of blog posts)


## Partials (templates)
No extra templates required for this template

*}

{* Fetch News *}
{controller type=news assign=controller primary=false}

{if $page.isNews}
	{$showFrom = $page.id}
{else}
	{$showFrom = '0'}
{/if}
{collection assign=newsitems controller=$controller pageId=$showFrom pageSize=$template.settings.MODULEBOX_NEWS_AMOUNT}

<div class="panel panel-border column-box b-news">
	<div class="panel-heading b-news-header b-header">
		<span class="h5">{$text.NEWS_NEWS}</span>
	</div>

	{if $newsitems->getActualSize() gt 0}
		<div class="panel-body b-news-list b-news-list-newest">
			<label class="column-list-label column-list-news-label form-label">{$text.NEWS_BY_LATEST}</label>

	        <ul class="list-unstyled">
	        	{foreach $newsitems->getData() as $news}
		        	<li class="column-list-item news-item-{$news->Id}">
	    				<a class="is-block" href="/{page id=$news->PageId print=Link}/{$news->Handle}/">
	    					<span class="column-list-title column-list-news-title">{$news->Title}</span>
	    					<small class="column-list-date column-list-news-date">{$news->DateCreated|date_format:$general.dateFormat}</small>
	    				</a>
	    			</li>
    			{/foreach}
	        </ul>
	    </div>
    {/if}

    {if $page.isNews}
		{$activeDates = $controller->getActiveDates($page.id)}
		{if $activeDates}
	    	<div class="panel-body b-news-list b-news-sorted">
	    		<label class="column-list-label column-list-news-label form-label">{$text.NEWS_BY_DATE}</label>

	    		<ul class="list-unstyled b-news-by-year">
		    		{foreach $activeDates as $pageId => $years}
		    			{$pageLink = {page id=$pageId print=Link}}
		    			{foreach $years as $year => $months}
		    				<li class="column-list-item b-news-by-year-{$year}">
			    				<a href="/{$pageLink}/?y={$year}" class="column-list-title column-list-news-title b-anchor-year">{$year}</a>
			    				<ul class="list-unstyled news-list-by-month">
			    					{foreach $months as $month => $amount}
			    						<li class="column-list-item b-news-by-month-{$month}">
			    							<a href="/{$pageLink}/?y={$year}&amp;m={$month}" class="column-list-title column-list-news-title b-anchor-month">{$month|formatMonth} ({$amount})</a>
			    						</li>
			    					{/foreach}
			    				</ul>
		    				</li>
		    			{/foreach}
		    		{/foreach}
	    		</ul>
			</div>
		{/if}
	{/if}
</div>
