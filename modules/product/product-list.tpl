{*

# Description
Template for a category with the product list. Part of the Product page type.


## Date last modified
2021-02-09


## Primary variables
+ $item														- Entity of categoryController (a single shop product category)
+ $controller												- Instance of productCategoryController
+ $brandController											- Instance of BrandController
+ $brand                                                    - Entity of brandController
+ $categories												- Collection of subCategories to the selected category
+ $columns 													- Global scope variable containing columns
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
+ "/modules/product/partials/category-description.tpl"		- Partial template for category description
+ "/modules/product/product-list-combined.tpl" 				- Controller for the category / product list

*}


{$type = 'categoryId'}
{$id = null}
{$title = null}
{$description = null}
{$descriptionBottom = null}

{controller assign=controller type=productCategory}

<div class="modules productlist">

	{* Category description *}
	{$categories = false}
	{if isset($smarty.get.brand)}
		{$type = 'brand'}
		{$id = (int) $smarty.get.brand}
		{controller assign=brandController type=brand}
		{entity assign=brand controller=$brandController id=$id}
		{if $brand}
			{$title = $brand->Title}
			{$descriptionTop = $brandController->getDescription($brand->Id)}
			{$descriptionBottom = $brandController->getTranslation($brand->Id, "text_two")}
			{$seoTitle = $brandController->getTranslation($brand->Id, 'seo_title')}
			{$seoDescription = $brandController->getTranslation($brand->Id, 'seo_description')}

			{if !$seoTitle}
				{$seoTitle = $title}
			{/if}

			{if !$seoDescription}
				{$seoDescription = $descriptionTop|strip_tags|truncate:160}
			{/if}

			{include file="modules/widgets/meta/opengraph.tpl"
			    og=["title" => $seoTitle, "description" => $seoDescription]
			}
		{else}
			{notfound}
		{/if}
	{elseif isset($smarty.get.new)}
		{$type = 'new'}
		{$title = $text.NEWS}
	{elseif isset($smarty.get.sale)}
		{$type = 'sale'}
		{$title = $text.SALE}
	{elseif isset($smarty.get.search)}
		{$id = $smarty.get.search|htmlspecialchars}
		{$id = str_replace($smarty.ldelim, "", $id)}
		{$type = 'search'}
		{$title = $text.SEARCH_LONG}
	{elseif isset($smarty.get.tag)}
		{$id = $smarty.get.tag}
		{$id = str_replace($smarty.ldelim, "", $id)}
		{if isset($smarty.get.type)}
			{$id = {$id|cat:';'|cat:$smarty.get.type}}
		{/if}
		{$type = 'tag'}
		{$title = $text.TAGS}
	{else}
		{$id = $item->Id}
		{$title = $item->Title}
		{$descriptionTop = $controller->getDescription($item->Id)}
		{$descriptionBottom = $controller->getDescriptionBottom($item->Id)}
		{collection assign=categories controller=productCategory parentId=$id}
	{/if}

	{include file='modules/product/product-list-combined.tpl' type=$type showEmpty=$showEmpty id=$id}
</div>
