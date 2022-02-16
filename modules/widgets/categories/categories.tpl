{*

# Description
Category widget. A widget is a small helper template, with some functionality.


## Date last modified
2021-02-15


## Primary variables
+ $productCategory                                                    - Instance of productCategoryController

## Partials (templates)
+ "modules/product/product-categories-entity.tpl"                     - Product categories template

*}

{controller assign=controller type=productCategory}
{$categoryIds = $template.settings.SETTINGS_FRONTPAGE_CATEGORIES|replace:' ':''}
{assign var=categories value=","|explode:$categoryIds}
{collection assign=items controller=$controller id=$categories}

{if $categoryIds neq "null" AND $categoryIds neq ""}
    <section class="section w-categories">
        
        <header class="page-title">
            <h3>{$text.SHOP_BY} {$text.CATEGORY}</h3>
        </header>

        <div class="w-categories-items row">
            {foreach $categories as $category}
                {entity assign=cat controller=$controller id=$category}
                {include file='modules/product/product-categories-entity.tpl' item=$cat}
            {/foreach}
        </div>
    </section>
{/if}