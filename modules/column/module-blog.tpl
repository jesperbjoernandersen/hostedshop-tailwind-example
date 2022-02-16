{*

# Description
Template for Blog items in a column box


## Date last modified
2015-03-18


## Primary variables
+ $controller                                               - Instance of blogController
+ $blogitems 												- Collection of blogController (a list of blog posts)
+ $categories												- Collection of blogCategoryController (a list of blog categories)
+ $catBlogs													- Collection of blogCategoryController (a list of blog categories for a single blog post)


## Partials (templates)
No extra templates required for this template

*}


{* Fetch Blog *}
{controller type=blog assign=controller primary=false}

{if $page.isBlog}
	{$showFrom = $page.id}
{else}
	{$showFrom = null}
{/if}
{collection assign=blogitems controller=$controller pageId=$showFrom pageSize=$template.settings.MODULEBOX_BLOG_AMOUNT}

{if $page.isBlog}
	{collection controller=blogCategory assign=categories}
{/if}

<div class="panel panel-border column-box b-blog">
	<div class="panel-heading b-blog-header b-header">
		<span class="h5">{$text.BLOG}</span>
	</div>

	{if $blogitems->getActualSize() gt 0}
		<div class="panel-body b-blog-newest">
			<label class="form-label">{$text.BLOG_ARCHIVE_NEW}</label>

	    	<ul class="nav nav-menu b-blog-container">
	    		{foreach $blogitems->getData() as $blog}
	    			<li class="b-blog-entry entry-{$blog->Id}{if $blog@first} first{/if}{if $blog@last and !$blog@first} last{/if}">
	    				<a href="/{page id=$blog->PageId print=Link}/{$blog->Handle}/">
	    					<span>{$blog->Title}</span>
	    					<small>{$blog->DateCreated|date_format:$general.dateFormat}</small>
	    				</a>
	    			</li>
	    		{/foreach}
	    	</ul>
    	</div>
	{/if}

	{if $page.isBlog}
		{$pageLink = {page id=$page.id print=Link}}

		{$hasBlogCategories = false}

	    {capture name="blogCategories"}

		{if $categories->getActualSize() gt 0}

		    	<ul class="nav nav-menu">
		    		{foreach $categories->getData() as $category}
		    			{collection assign=catBlogs controller=$controller categoryId=$category->Id}

		    			{if $catBlogs->getActualSize() > 0}
		    				{$hasBlogCategories = true}
			    			<li class="b-blog-category category-{$category->Id}{if $category@first} first{/if}{if $category@last and !$category@first} last{/if}">
			    				<a href="/{$pageLink}/?cat={$category->Id}">{$category->Title} ({$catBlogs->getActualSize()})</a>
			    			</li>
			    		{/if}
		    		{/foreach}
		    	</ul>
	    {/if}
	    {/capture}

	    {* Only display the blog categories and the blog categories header if there are actually any categories to display *}
	    {if $hasBlogCategories}
			<div class="panel-body b-blog-categories">
	    		<label class="form-label">{$text.CATEGORYS}</label>
	    		{$smarty.capture.blogCategories}
	    	</div>
	    {/if}

    	{$activeDates = $controller->getActiveDates($page.id)}
    	{if $activeDates}
    		<div class="panel-body b-blog-month">
	    		<label class="form-label">{$text.BLOG_MONTH_ARCHIVE}</label>

		    	<ul class="nav nav-menu">
		    		{foreach $activeDates as $pageId => $years}
		    			{foreach $years as $year => $months}
		    			<li class="b-blog-year year-{$year}">
		    				<a href="/{$pageLink}/?y={$year}">{$year}</a>
		    				<ul>
		    					{foreach $months as $month => $amount}
		    						<li class="b-blog-month month-{$month}"><a href="/{$pageLink}/?y={$year}&amp;m={$month}">{$month|formatMonth} ({$amount})</a></li>
		    					{/foreach}
		    				</ul>
		    			</li>
		    			{/foreach}
		    		{/foreach}
		    	</ul>
	    	</div>
    	{/if}

	    {$pageLink = {page id=$page.id print=Link}}
	    <form id="b-blog-search" method="get" action="/{$pageLink}/">
		    <div class="panel-body b-blog b-blog-search">
		    	<label class="form-label" for="blogSearch">{$text.SEARCH_LONG}</label>
		    	<fieldset class="form-group">
					<input id="blogSearch" type="text" class="form-input small" placeholder="{$Text.SEARCH_TEXT}" name="search" required>
				</fieldset>
		    </div>
		    <div class="panel-footer">
		    	<button class="form-submit button small" type="submit">{$Text.SEARCH}</button>
		    </div>
		</form>
	{/if}

</div>
