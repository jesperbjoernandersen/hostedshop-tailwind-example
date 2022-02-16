{*

# Description
Controller and template for Text page type.


## Date last modified
2020-08-28


## Primary variables
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}

{if $page and $page.id}
    {*** Global widgets defaults ***}
    {$prev = null}
    {$next = null}

    {$opengraph_image = null}
    {$opengraph_title = $page.headline}
    {$opengraph_description = null}

    {controller type=page assign=controller primary=true}
    {$pageText = $controller->getText($page.id)}

    {$opengraph_description = {translation module=seo_page title=description id=$page.id}}

    {if empty($opengraph_description)}
      {$opengraph_description = $pageText|strip_tags}
    {/if}

    {$opengraph_description = $opengraph_description|truncate:160}

    {entity assign=pageImage controller=files type=page id=$page.id pageSize=1}
    {if $pageImage}
        {$opengraph_image = $pageImage->thumbnail(1200)|solutionPath}
    {/if}

    {if $settings.cookies_link === $page.id}
        {$detailsReplacement = '<div data-inject="cookiedetails"></div>'}
        {$removeReplacement = '<div data-inject="cookieremove"></div>'}
        {$pageText = $pageText|strtr:[
            '<p>#COOKIEDETAILS#</p>' => $detailsReplacement,
            '#COOKIEDETAILS#' => $detailsReplacement,
            '<p>#COOKIEREMOVE#</p>' => $removeReplacement,
            '#COOKIEREMOVE#' => $removeReplacement
        ]}
    {/if}

    <div class="modules m-text">
        <article class="m-text-article">
            {$pageHeadline = trim($page.headline)}
            {if !empty($pageHeadline)}
            <header class="m-text-header page-title {if $page.isFrontPage}page-title-frontpage{/if}">
                <h1 class="m-text-headline">{$page.headline}</h1>
            </header>
            {/if}

            {*** Page content ***}
            <div class="m-text-content content ck-content clearfix">{$pageText}</div>
        </article>
    </div>

    {$hasParent = isset($page.parentId) and $page.parentId neq 0}
    {if $hasParent}
        {$pageIds = $controller->getCompletePath($page.id)}

        {foreach $pageIds as $pageId}
            {entity assign=item controller=page id=$pageId}
            {addBreadCrumb path=$item->Handle title=$item->Title}
        {/foreach}
    {else}
        {addBreadCrumb path=$page.handle title=$page.title}
    {/if}

    {*** Global widgets ***}
    {include file="modules/widgets/meta/opengraph.tpl"
        og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
    }
{else}
    {notfound}
{/if}
