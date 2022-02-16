{*

# Description
Template for Product categories in a column box


## Date last modified
2017-11-20


## Primary variables
+ $controller                                               - Instance of productCategoryController
+ $categories                                               - Collection of productCategoryController (a list of product categories)
+ $brands                                                   - Collection of brandController
+ $categories1                                              - Collection of productCategoryController (a list of product categories)
+ $categories2                                              - Collection of productCategoryController (a list of product categories)
+ $categories3                                              - Collection of productCategoryController (a list of product categories)


## Partials (templates)
No extra templates required for this template

*}

{* Settings *}
{$catLevels = $template.settings.MODULEBOX_PRODUCT_CATEGORIES_LEVELS}
{$brandsShown = $template.settings.MODULEBOX_PRODUCT_CATEGORIES_SHOW_BRAND}

{* Fetch product categories *}
{controller type=productCategory assign=controller primary=true}
{collection controller=productCategory assign=categories}

{* Fetch products link *}
{$productLink = {page id=$page.productPageId print=Link}}

<div class="panel panel-border column-box b-productcategories">
	<div class="panel-heading b-productcategories-header b-header">
		<span class="h5">{$Text.CATEGORYS}</span>
	</div>

    {if $categories->getActualSize() gt 0}
        <div class="panel-body">
        	<ul class="nav nav-menu b-productcategories-list b-productcategories-level-0">
        		{foreach $categories->getData() as $category}
                	<li class="b-productcategory b-category-li-0 b-category-{$category->Id}{if $category->IsActive} active{/if}">
                		<a class="b-productcategory-anchor b-anchor" href="/{$productLink}/{$category->Handle}/">{$category->Title}</a>

                        {if $catLevels gt 0 or $category->IsActive}
                            {* Fetch product categories level 1 *}
                            {collection controller=productCategory assign=categories1 parentId=$category->Id}
                            {if $categories1->getActualSize() gt 0}
                                <ul class="b-productcategories-list b-productcategories-level-1">
                                    {foreach $categories1->getData() as $category1}
                                        <li class="b-productcategory b-category-li-1 b-category-{$category1->Id}{if $category1->IsActive} active{/if}">
                                            <a href="/{$productLink}/{$category1->Handle}/">{$category1->Title}</a>

                                            {if $catLevels gt 1 or $category1->IsActive}
                                                {* Fetch product categories level 2 *}
                                                {collection controller=productCategory assign=categories2 parentId=$category1->Id}
                                                {if $categories2->getActualSize() gt 0}
                                                    <ul class="b-productcategories-list b-productcategories-level-2">
                                                        {foreach $categories2->getData() as $category2}
                                                            <li class="b-productcategory b-category-li-2 b-category-{$category2->Id}{if $category2->IsActive} active{/if}">
                                                                <a href="/{$productLink}/{$category2->Handle}/">{$category2->Title}</a>

                                                                {if $catLevels gt 2 or $category2->IsActive}
                                                                    {* Fetch product categories level 3 *}
                                                                    {collection controller=productCategory assign=categories3 parentId=$category2->Id}
                                                                    {if $categories3->getActualSize() gt 0}
                                                                        <ul class="b-productcategories-list b-productcategories-level-3">
                                                                            {foreach $categories3->getData() as $category3}
                                                                                <li class="b-productcategory b-category-li-3 b-category-{$category3->Id}{if $category3->IsActive} active{/if}">
                                                                                    <a href="/{$productLink}/{$category3->Handle}/">{$category3->Title}</a>
                                                                                </li>
                                                                            {/foreach}
                                                                        </ul>
                                                                    {/if}
                                                                {/if}
                                                            </li>
                                                        {/foreach}
                                                    </ul>
                                                {/if}
                                            {/if}
                                        </li>
                                    {/foreach}
                                </ul>
                            {/if}
                        {/if}
                    </li>
                {/foreach}
            </ul>
        </div>
    {/if}

    {if $brandsShown}

        {* Fetch brands *}
        {collection controller=brand assign=brands}

        {if $brands->getActualSize() gt 0}
            <div class="panel-footer">
                <select class="form-input form-select small" onchange="window.location = '/{$productLink}/?brand=' + this.value;">
                    <option>{$Text.PRODUCT_CATALOG_BRAND_SELECT}</option>
                    {foreach $brands->getData() as $brand}
                        <option value="{$brand->Id}-{$brand->Title|formatLink}">{$brand->Title}</option>
                    {/foreach}
                </select>
            </div>
        {/if}
    {/if}
</div>
