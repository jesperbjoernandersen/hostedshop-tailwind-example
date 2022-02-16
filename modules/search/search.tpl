{*

# Description
Controller and template for the Search page type.


# Date last modified
2020-08-28


## Primary variables
+ $pageSize                                                             - Number of search items pr page
+ $searchResults                                                        - Collection of pageController (list of search results)
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations
+ $user                                                                 - Global scope variable containing user data
+ $columns                                                              - Global scope variable containing columns
+ $boxes                                                                - Global scope variable containing column boxes


## Partials (templates)
+ "/modules/widgets/pagination/pagination.tpl"                          - Pagination widget, for pagination generation
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}

{* Set number of items to be shown per page *}
{$pageSize = 10}

{* Set pager *}
{$pager = true}

{if isset($smarty.get.search)}
    {collection assign=searchResults controller=page pageSize=$perPage primary=true}
    {*** Calculate the actual size of the collection ***}
    {$collectionSize = $searchResults->getActualSize()}
{else}
    {$searchResults = null}
    {*** Set size to 0 as there is no results to be found ***}
    {$collectionSize = 0}
{/if}

<div class="modules m-search">
    <article class="m-search-article">
        <header class="m-search-header page-title">
            <h1 class="m-search-headline">{$page.title}</h1>
        </header>

        <div class="m-search-search">
            <form id="m-search" method="get" action="/{$Text.SEARCH_LINK}/">
                <fieldset class="form-group m-search-text">
                    <div class="input-group large">
                        <input name="search" type="text" class="form-input input-group-main" placeholder="{$Text.SEARCH_TEXT}">
                        <span class="input-group-button"><button class="button" type="submit">{$Text.SEARCH}</button></span>
                    </div>
                </fieldset>
            </form>
        </div>
        <div class="m-search-results">
            {if isset($smarty.get.search)}
                <p class="m-search-results-x"><small>{$searchResults->getActualSize()} {$text.WISHLIST_SEARCH_ON_RESULTS}</small></p>
            {else}
                <p class="m-search-results-none"><small>0 {$Text.WISHLIST_SEARCH_ON_RESULTS}</small></p>
            {/if}
        </div>
        <hr>

        {if isset($smarty.get.search) && $collectionSize gt 0}
            <ul class="list-unstyled m-search-container">
                {foreach $searchResults->getData() as $result}

                    {* Get correct collection based on result type *}
                    {entity assign=resultImage controller=files id=$result->Id type=page strictly=image}

                    {*** Page result collection ***}
                    {controller assign=searchPageDataController type=page}

                    {*** Set link destination ***}
                    {if $result->Type == 'link'}

                        {* Set link *}
                        {$link = $result->Link}
                    {else}

                        {* cat link with domain, add protocol and handle *}
                        {$link = {$general.domain}|cat:"/"|cat:$result->Handle|cat:"/"}
                    {/if}
                    <li class="row m-search-item">
                        {* Image *}
                        {if $resultImage}
                            <div class="col-s-1 col-m-2 col-l-2 col-xl-4">
                                {$imageSrc = $resultImage->thumbnail(100, 100, true)|solutionPath}
                                <div class="placeholder-wrapper" data-placeholder-max-width="100px">
                                  <span class="placeholder"></span>
                                  {img src="{$imageSrc}" class="responsive" alt="{$searchPageDataController->getHeadline($result->Id)}"}
                                </div>
                            </div>
                            <div class="col-s-3 col-m-10 col-l-10 col-xl-20">
                        {else}
                            <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                        {/if}
                            <div class="headline">
                                <a href="{$link}" title="{$searchPageDataController->getHeadline($result->Id)}"><span class="h6">{$searchPageDataController->getHeadline($result->Id)}</span></a>
                            </div>
                            <div class="content">
                                {$searchPageDataController->getText($result->Id)|strip_tags|truncate:160}
                            </div>
                            <div class="link">
                                <p><a href="{$link}" title="{$searchPageDataController->getHeadline($result->Id)}" {if $result->Target}target="{$result->Target}"{/if}><small>{$link}</small></a></p>
                            </div>
                        </div>
                    </li>
                {/foreach}
            </ul>

            {* Pagination for the search list if enabled *}
            {if (!isset($pager) or !!$pager)}
                <div class="m-search-pagination">
                    {include file='modules/widgets/pagination/pagination.tpl' pageSize=$pageSize size=$collectionSize}
                </div>
            {/if}
        {else}
            <div class="panel panel-warning">
                <div class="panel-body">
                    <span>{$text.WISHLIST_SEARCH_EMPTY}</span>
                </div>
            </div>
        {/if}
    </article>
</div>


{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
