{*

# Description
Template partial for category description in the category / product list. Part of the Product page type.


# Date last modified
2015-04-20


## Primary variables
+ $title                                                                - Name of the category
+ $description 															- Description of the category
+ $page 																- Global scope variable containing all information about the page type


## Partials (templates)
No extra templates required for this template

*}



<div class="row">
	<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
    	{*** Category title ***}
    	<header class="category-headline page-title">
			<h1 class="category-headline">{if !$title}{$page.headline}{else}{$title}{/if}</h1>
		</header>

    	{*** Category description ***}
    	{if $description}
			<div class="category-description ck-content trailing clearfix">{$description}</div>
		{/if}
	</div>
</div>
