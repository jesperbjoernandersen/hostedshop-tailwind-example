{*

# Description
Template partial for category description bottom in the category / product list. Part of the Product page type.


# Date last modified
2014-08-01


## Primary variables
+ $title                                                                - Name of the category
+ $descriptionBottom 													- Short description of the category
+ $page 																- Global scope variable containing all information about the page type


## Partials (templates)
No extra templates required for this template

*}


<div class="row">
	<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
    	{*** Category short description ***}
		<div class="category-short-description ck-content">{$descriptionBottom}</div>
	</div>
</div>
