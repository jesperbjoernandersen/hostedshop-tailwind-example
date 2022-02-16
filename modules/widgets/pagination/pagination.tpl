{*

# Description
Pagination widget, for pagination of blog, products, news and what not. A widget is a small helper template, with some functionality.


## Date last modified
2020-08-28


## Primary variables
+ $pageSize                                               	- How many items pr. page
+ $size 													- How many items totally in collection


## Partials (templates)
+ "/modules/widgets/meta/meta.tpl"                          - SEO meta and link data

*}


{* Check if $pageSize is set, default to 10 *}
{if !isset($pageSize)}
	{$pageSize = 10}
{/if}

{* Check if there are enough articles to generate a pagination *}
{if $size gt $pageSize}

	{if !isset($pageParam)}
		{$pageParam = "page"}
	{/if}

	{* Calculate the current page start based on $smarty.get[$pageParam] *}
	{$currentPage = 1}
	{if isset($smarty.get[$pageParam])}
		{$currentPage = (int)$smarty.get[$pageParam]}
	{/if}

	{if $currentPage > 1}
		{removeMeta name="description"}
		{removeMeta name="keywords"}
	{/if}

	{* Calculate the start page *}
	{$minPage = 1}
	{if $currentPage gt 5}
		{$minPage = $currentPage - 5}
	{/if}


	{* Calculate the max amount of pages *}
	{math assign=maxPage equation="ceil(size / pageSize)" size=$size pageSize=$pageSize}

	{if $maxPage gt ($currentPage + 5)}
		{$maxPage = $currentPage + 5}
	{/if}


	{*** Create a base url ***}
	{$url = "/"}
	{if !empty($page.paths)}
		{$url = "/"|cat:implode($page.paths, "/")|cat:"/"}
	{/if}

	{$get = $smarty.get}
	{$get_bare = $smarty.get}
	{$get_bare[$pageParam] = null}
	{$get_bare = $get_bare|http_build_query:'':"&amp;"}
	{if !empty($get_bare)}
		{$get_bare = "?$get_bare"}
	{/if}

	{*** Check if ?page=1 is set, redirect 301 ***}
	{if isset($smarty.get[$pageParam]) and ($smarty.get[$pageParam] eq 1 or $smarty.get[$pageParam] gt $maxPage)}
		{redirect uri=$url|cat:$get_bare}
	{/if}

	{if $currentPage gt 1}
		{title content={$text.PAGINATION_PAGE|lower|cat:' '|cat:$currentPage|cat:'/'|cat:$maxPage} append=true}
	{/if}

	<div class="w-pagination widget text-center">
		{* The actual pagination module *}
    	<ul class="w-pagination-list-container pagination">
    		{* List the pages needed *}
    		{$get[$pageParam] = $currentPage - 1}
    		{if $currentPage gt 1}
			<li class="w-pagination-list"><a {if $currentPage > 1}rel="prev"{/if} href="{if $currentPage eq 1 or $get[$pageParam] eq 1}{$url}{$get_bare}{else}?{$get|http_build_query:'':'&amp;'}{/if}"><i class="fa fa-angle-left"></i></a></li>
			{/if}
			{for $pageNumber=$minPage to $maxPage}
				{if $pageNumber eq 1}
					<li class="w-pagination-list{if $currentPage eq $pageNumber} current{/if}"><a href="{$url}{$get_bare|htmlspecialchars}">{$pageNumber}</a></li>
				{else}
					{$get[$pageParam] = $pageNumber}
					<li class="w-pagination-list{if $currentPage eq $pageNumber} current{/if}"><a href="?{$get|http_build_query:'':'&amp;'}">{$pageNumber}</a></li>
				{/if}
			{/for}
			{$get[$pageParam] = $currentPage + 1}
			{if $currentPage lt $maxPage}
			<li class="w-pagination-list"><a {if $currentPage < $maxPage}rel="next"{/if} href="?{$get|http_build_query:'':'&amp;'}"><i class="fa fa-angle-right"></i></a></li>
			{/if}
		</ul>{* end: .pagination *}
	</div>{*** end. widget ***}


	{*** Global widget data (rel prev) ***}
	{$get[$pageParam] = $currentPage - 1}
	{$prev = null}
	{if $currentPage neq 1}
		{if $get[$pageParam] eq 1}
			{$prev = "{$general.domain}{$url}{$get_bare|htmlspecialchars}"}
		{else}
			{$prev = "{$general.domain}{$url}?{$get|http_build_query:'':'&'}"}
		{/if}
	{/if}

	{*** Global widget data (rel next) ***}
	{$get[$pageParam] = $currentPage + 1}
	{$next = null}
	{if $currentPage neq $maxPage}
		{$next = "{$general.domain}{$url}?{$get|http_build_query:'':'&'}"}
	{/if}

	{*** Global widget meta ***}
	{include file="modules/widgets/meta/meta.tpl" prev=$prev next=$next}
{/if}
