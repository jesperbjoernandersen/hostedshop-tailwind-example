{*

# Description
Controller for the Blog page type, which manages entities and collections of the blog controller.


## Date last modified
2020-08-28


## Primary variables
+ $controller                                                           - Instance of blogController
+ $commentController                                                    - Instance of blogCommentController
+ $categoryController                                                   - Instance of blogCategoryController
+ $item                                                                 - Entity of blogController (a blog post)
+ $items                                                                - Collection of blogController (a list of blog posts)
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations
+ $user                                                                 - Global scope variable containing user data
+ $settings                                                             - Global scope variable containing platform settings


## Partials (templates)
+ "/modules/blog/blog-entity.tpl"                                       - Single blog post
+ "/modules/blog/blog-list.tpl"                                         - Categories (-list of blog posts)
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}


{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}


{* Check the request uri for any additional levels and show the entity template accordingly *}
{if !empty($page.paths.1)}
    {* Get blog item *}
    {controller type=blog assign=controller primary=true}
    {entity controller=$controller assign=item}

    {* Get Blog comments*}
    {controller type=blogComment assign=commentController}
    {collection assign=comments controller=$commentController blogId=$item->Id}

    {* Check if there is an item to show *}
    {if $item}
        {* Breadcrumb *}
        {addBreadCrumb title=$item->Title path=$item->Handle defaultPath=true}

        {*** Open Graph - Title ***}
        {title assign=opengraph_title}

        {*** Open Graph - Description ***}
        {$opengraph_description = $controller->getTranslation($item->Id, 'seo_description')|strip_tags}

        {if empty($opengraph_description)}
          {$opengraph_description = $controller->getDescription($item->Id)|strip_tags}
        {/if}

        {if empty($opengraph_description)}
           {$seo_description = {translation module=seo_page title=description id=$page.id}}
           {$opengraph_description = $seo_description|strip_tags}
        {/if}

        {$opengraph_description = $opengraph_description|truncate:160}

        {*** Open Graph - Image ***}
        {entity assign=opengraph_image controller=files type=blog id=$item->Id pageSize=1}
        {if $opengraph_image}
            {$opengraph_image = $opengraph_image->thumbnail(1200)|solutionPath}
        {/if}

        {* Push the view for a single blog item with data *}
        {include file='modules/blog/blog-entity.tpl' item=$item controller=$controller commentController=$commentController comments=$comments}
    {else}
        {notfound}
    {/if}

{* If no extra request uri was found, show the entire list of blog items for this page *}
{else}
    {*** Filter defaults ***}
    {$category = null}
    {$year = null}
    {$month = null}

    {* Set number of items to be shown per page *}
    {$pageSize = 6}

    {* Fetch a blogController and set it as primary *}
    {controller type=blog assign=controller primary=true}

    {* If category is set, show list filtered on category *}
    {if isset($smarty.get.category)}
        {* Get the category *}
        {entity controller=blogCategory assign=blogCategory}
        {* Change the title too reflect the category *}
        {title content="- "|cat:$blogCategory->Title append=true}
    {/if}

    {*** If year is set, show list filtered on year ***}
    {if isset($smarty.get.y)}
        {title content="- "|cat:$smarty.get.y|htmlspecialchars append=true}
    {/if}

    {* Get blog post list *}
    {collection assign=items controller=$controller pageSize=$pageSize}

    {*** Open Graph - Title ***}
    {title assign=opengraph_title}

    {* Push the view for a blog list with data *}
    {include file='modules/blog/blog-list.tpl' items=$items controller=$controller pageSize=$pageSize}

{* End of controller *}
{/if}


{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
