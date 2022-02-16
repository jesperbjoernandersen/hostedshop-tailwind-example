{*

# Description
Controller for columns


## Date last modified
2021-09-28


## Primary variables
+ $boxes                                                    			- Global scope variable containing column boxes
+ $columns                                                  			- Global scope variable containing columns
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/column/module-cart.tpl" 									- Template for cart in column box
+ "/modules/column/module-blog.tpl" 									- Template for blog in column box
+ "/modules/column/module-productcategories.tpl" 						- Template for product categories in column box
+ "/modules/column/module-search.tpl" 									- Template for search in column box
+ "/modules/column/module-login.tpl" 									- Template for user login in column box
+ "/modules/column/module-newsletter.tpl" 								- Template for newsletter in column box
+ "/modules/column/module-topproducts.tpl" 								- Template for top products in column box
+ "/modules/column/module-tags.tpl" 									- Template for product tags in column box
+ "/modules/column/module-paymenticons.tpl" 							- Template for payment icons in column box
+ "/modules/column/module-text.tpl" 									- Template for page text in column box
+ "/modules/column/module-news.tpl" 									- Template for news in column box
+ "/modules/column/module-calendar.tpl" 								- Template for calendar in column box
+ "/modules/column/module-vat.tpl" 										- Template for product vat in column box
+ "/modules/column/module-social.tpl" 									- Template for social media in column box

*}

{* Assume all columns has same Position (since index.tpl groups by Position) *}
{if $boxes && isset($boxes[0])}
	{$isLeft = $boxes[0]->Position == 'left'}
{/if}

{$isProductListPage = 
	$page.type == 'product'
	&& (count($page.paths) == 2 || isset($smarty.get['search']))
}

{$colClasses = ''}
{if !$isProductListPage || ($isProductListPage && !$isLeft)}
	{$colClasses = 'col-l-3 col-xl-5'}
{/if}

<aside class="column is-hidden-s is-hidden-m {$colClasses}">
	{foreach $boxes as $box}

		{* Shopping cart *}
		{if $box->TypeId eq 1}
			{include file='modules/column/module-cart.tpl' box=$box}

		{* Blog menu *}
		{elseif $box->TypeId eq 2}
			{include file='modules/column/module-blog.tpl' box=$box}

		{* Product category menu *}
		{elseif $box->TypeId eq 3}
			{include file='modules/column/module-productcategories.tpl' box=$box}

		{* Search box *}
		{elseif $box->TypeId eq 4}
			{include file='modules/column/module-search.tpl' box=$box}

		{* Login box *}
		{elseif $box->TypeId eq 5}
			{include file='modules/column/module-login.tpl' box=$box}

		{* Newsletter signup *}
		{elseif $box->TypeId eq 6}
			{include file='modules/column/module-newsletter.tpl' box=$box}

		{* Top products *}
		{elseif $box->TypeId eq 7}
			{include file='modules/column/module-topproducts.tpl' box=$box}

		{* Product tags *}
		{elseif $box->TypeId eq 8}
			{include file='modules/column/module-tags.tpl' box=$box}

		{* Payment icons *}
		{elseif $box->TypeId eq 9}
			{include file='modules/column/module-paymenticons.tpl' box=$box}

		{* Page content box *}
		{elseif $box->TypeId eq 11}
			{include file='modules/column/module-text.tpl' box=$box}

		{* News module *}
		{elseif $box->TypeId eq 12}
			{include file='modules/column/module-news.tpl' box=$box}

		{* Calendar *}
		{elseif $box->TypeId eq 13}
			{include file='modules/column/module-calendar.tpl' box=$box}

		{* Vat selector *}
		{elseif $box->TypeId eq 15}
			{include file='modules/column/module-vat.tpl' box=$box}

		{* Social media - type 16 facebook, 17 twitter, 18 google+ *}
		{elseif $box->TypeId eq 16 or $box->TypeId eq 17 or $box->TypeId eq 18}
			{include file='modules/column/module-social.tpl' box=$box}
		{/if}
	{/foreach}
</aside>
