{*

# Description
Controller for the Forum page type


## Date last modified
2020-08-28


## Primary variables
+ $categorycontroller                                                   - Instance of forumController
+ $threadcontroller                                                     - Instance of forumThreadController
+ $category                                                             - Entity of forumController (single forum category)
+ $thread                                                               - Entity of forumThreadController (single thread)
+ $threads                                                              - Collection of forumThreadController (multiple threads for a category)
+ $categories                                                           - Collection of forumController (all form categories)
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/forum/forum-post.tpl"                                       - Template for a single post with replies
+ "/modules/forum/forum-list.tpl"                                       - Template for a list of posts in a forum category
+ "/modules/forum/forum-categories.tpl"                                 - Template for a list of forum categories
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}


{*** Set number of items to be shown per page ***}
{$pageSize = 30}

{controller assign=categorycontroller type=forum primary=true}

{* Check the request uri for any additional levels and show the entity template accordingly *}

{if isset($page.paths.1)}
    {controller assign=threadcontroller type=forumThread primary=true}
    {entity assign=category controller=$categorycontroller}

    {* Breadcrumb *}
    {addBreadCrumb title=$category->Title path=$category->Handle defaultPath=true}

    {if isset($page.paths.2)}
        {entity assign=thread controller=$threadcontroller}

        {if $thread}
            {$opengraph_title = $thread->Headline}
            {$opengraph_description = $thread->Description|strip_tags|truncate:160}

            {*** Add thread title to breadcrumb ***}
            {addBreadCrumb title=$thread->Headline}
            {include file='modules/forum/forum-entity.tpl' item=$category controller=$threadcontroller item=$thread pageSize=$pageSize}
        {else}
            {notfound}
        {/if}
    {else}
        {if $category}
            {$opengraph_title = $category->Title}
            {$opengraph_description = $categorycontroller->getDescription($category->Id)|strip_tags|truncate:160}

            {collection assign=threads controller=$threadcontroller}
            {include file='modules/forum/forum-list.tpl' controller=$categorycontroller category=$category items=$threads pageSize=$pageSize}
        {else}
            {notfound}
        {/if}
    {/if}

{* If no extra request uri was found, show the entire list of forum items for this page *}
{else}
    {collection assign=categories controller=$categorycontroller}

    {*** Calculate the actual size of the collection ***}
    {$collectionSize = $categories->getActualSize()}

    {if $collectionSize gt 0}
        {include file='modules/forum/forum-categories.tpl' controller=$categorycontroller items=$categories}
    {else}
        <div class="panel panel-warning">
            <div class="panel-body">
               <span>{$text.FORUM_TOPICS_NONE}</span>
            </div>
        </div>
    {/if}
{* End of controller *}
{/if}

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}