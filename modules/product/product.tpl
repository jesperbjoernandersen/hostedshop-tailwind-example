{*

# Description
Controller for the Product page type, which manages entities and collections
of the product and category controllers.

The controller uses $page.paths to decided which type of collection to show.


## Date last modified
2020-08-28


## Primary variables
+ $productController                                                    - Instance of productController
+ $categoryController                                                   - Instance of categoryController
+ $pageCtrl                                                             - Instance of pageController
+ $categories                                                           - Collection of categories entities
+ $product                                                              - Entity of productController (a single shop product)
+ $category                                                             - Entity of categoryController (a single shop product category)
+ $opengraph_image                                                           - Entity of filesController with type product (a product image)
+ $settings                                                             - Global scope variable containing platform settings
+ $boxes                                                                - Global scope variable containing column boxes


## Partials (templates)
+ "/modules/blog/blog-entity.tpl"                                       - Single blog post
+ "/modules/product/product-entity.tpl"                                 - Partial template for a single product
+ "/modules/product/product-list.tpl"                                   - Partial template for a product category (list of products)
+ "/modules/product/product-categories.tpl"                             - Partial template for product categories (list of categories)
+ "/modules/widgets/meta/meta.tpl"                                      - SEO meta and link data
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}

{*** Global widgets defaults ***}
{$prev = null}
{$next = null}

{$opengraph_type = null}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}


{if isset($page.paths.1) or isset($smarty.get.brand) or isset($smarty.get.new) or isset($smarty.get.sale) or isset($smarty.get.search) or isset($smarty.get.tag)}

    {$category = null}

    {if isset($page.paths.1)}
        {controller assign=categoryController type=productCategory}

        {*** Preload related category entities to optimize load times ***}
        {include file='modules/product/product-category-preload.tpl' scope=parent}

        {entity assign=category controller=$categoryController id=(int)$page.paths.1}

        {* Check if there is a category, redirect if not *}
        {if $category}

            {*** Preload related translation entities to optimize load times ***}
            {include file='modules/product/product-category-translation-preload.tpl' scope=parent}

            {$opengraph_type = "product.group"}

            {*** Category description  ***}
            {$catDescription = $categoryController->getDescription($category->Id)}

            {*** Open Graph - Title ***}
            {$opengraph_title = $category->Title}

            {*** Open Graph - Description ***}
            {$seoDescription = $categoryController->getTranslation($category->Id, 'seo_description')}
            {if $seoDescription}
                {$opengraph_description = $seoDescription}
            {else}
                {$opengraph_description = $catDescription|strip_tags|truncate:160}
            {/if}

            {*** Open Graph - Image ***}
            {entity assign=opengraph_image controller=files type=category id=$category->Id}
            {if $opengraph_image}
                {$opengraph_image = $opengraph_image->thumbnail(1200)|solutionPath}
            {/if}

            {*** Recursive categories ***}
            {$categoryPath = $categoryController->categoryPath($category->Id)}
            {foreach $categoryPath|array_reverse as $pathId}
                {if $pathId@last}
                    {$pathCategory = $category}
                {else}
                    {entity assign=pathCategory controller=$categoryController id=$pathId}
                {/if}
                {if $pathCategory}
                    {addBreadCrumb path=$pathCategory->Handle title=$pathCategory->Title defaultPath=true}
                {/if}
            {/foreach}
        {else}
            {notfound}
        {/if}
    {/if}

    {if isset($page.paths.2)}

        {controller type=product assign=productController primary=true}
        {entity assign=product controller=$productController}

        {* Check if there is a product, redirect if not *}
        {if $product}

            {$opengraph_type = "product.item"}

            {*** Product description ***}
            {$descriptionShort = $productController->getDescriptionShort($product->Id)}
            {if empty($descriptionShort)}
                {$productDescription = $productController->getDescription($product->Id)}
                {$descriptionShort = $productDescription|strip_tags|truncate:160}
            {/if}

            {*** SEO rel links (prev and next) ***}
            {$links = $productController->getPrevNextProduct($product->Id)}

            {*** Preload related entities to optimize load times ***}
            {include file='modules/product/product-prev-next-preload.tpl' scope=parent}

            {if isset($links['next']) and !empty($links['next'])}
                {$next = $productController->link($links.next)}
            {/if}
            {if isset($links['prev']) and !empty($links['prev'])}
                {$prev = $productController->link($links.prev)}
            {/if}

            {*** Open Graph - title ***}
            {$opengraph_title = $product->Title}

            {*** Open Graph description ***}
            {$seoDescription = $productController->getTranslation($product->Id, 'seo_description')}
            {if $seoDescription}
                {$opengraph_description = $seoDescription}
            {else}
                {$opengraph_description = $descriptionShort}
            {/if}


            {*** Meta image ***}
            {entity assign=opengraph_image controller=files type=product productId=$product->Id}
            {if $opengraph_image}
                {$opengraph_image = $opengraph_image->thumbnail(1200)|solutionPath}
            {/if}

            {include file='modules/product/product-entity.tpl' controller=$productController item=$product}

            {registerPath key='product' global=true}
            {addBreadCrumb title=$opengraph_title}
        {else}
            {notfound}
        {/if}
    {else}
        {include file='modules/product/product-list.tpl' item=$category}
        {registerPath key='productlist' global=true}
    {/if}

{else}
    {*** Open Graph - title ***}
    {title assign=opengraph_title}

    {controller assign=pageController type=page}
    {$opengraph_description = {translation module=seo_page title=description id=$page.id}}

    {*** Meta image ***}
    {entity assign=opengraph_image controller=files type=page id=$page.id}
    {if $opengraph_image}
        {$opengraph_image = $opengraph_image->thumbnail(1200)|solutionPath}
    {/if}

    {collection assign=categories controller=productCategory}
    {include file='modules/product/product-categories.tpl' items=$categories}
{/if}

{if empty($opengraph_description)}
    {$opengraph_description = {translation module=seo_page title=description id=$page.id}}
{/if}

{*** Global widgets ***}
{include file="modules/widgets/meta/meta.tpl" prev=$prev next=$next}

{if !isset($smarty.get.brand)}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image, "type" => $opengraph_type]
}
{/if}
