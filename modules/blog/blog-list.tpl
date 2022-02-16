{*

# Description
Template for a list of blog posts with slider element, part of the Blog page type.


## Date last modified
2021-02-09


## Primary variables
+ $controller                                                           - Instance of blogController
+ $commentController                                                    - Instance of blogCommentController
+ $categoryController                                                   - Instance of blogCategoryController
+ $imageController                                                      - Instance of filesController
+ $pageSize                                                             - Amount of blog posts to show per page. Defaults to 5.
+ $items                                                                - Collection of blog posts
+ $CategoryId (optional)                                                - Show a list based on categori id
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/pagination/pagination.tpl"                          - Pagination widget, for pagination generation
+ "/modules/column/column.tpl"                                          - Template for column boxes


*}



{*** Fetch the filesController and save it for later ***}
{controller type=files assign=imageController}

{*** Fetch the categoryController and save it for later ***}
{controller type=blogCategory assign=categoryController}

{*** Calculate the actual size of the collection ***}
{$collectionSize = $items->getActualSize()}

{*** Start of module ***}
<div class="modules m-blog-list" itemscope itemtype="http://schema.org/Blog">

    {*** Header of the blog page ***}
    <header class="m-blog-page-header"><h1 class="m-blog-page-headline page-title">{$page.headline}</h1></header>

    {*** Check if there are any blog articles to show from the collection ***}
    {if $collectionSize gt 0}
        {*** Start an unstyled list with borders ***}
        <ol class="list-unstyled t-border-bottom m-blog-list-container">
            {*** Loop through blog articles ***}
            {foreach $items->getData() as $item}
                {*** Fetch the link of the page for this specific item ***}
                {$pageLink = {page id=$item->PageId print=Link}}
                <li class="trailing-trip m-blog-list-item item-{$item->Id}">
                    {*** Article content for specific blog article ***}
                    <article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" class="trailing-trip">

                        {*** Fetch the first image of this blog article ***}
                        {entity assign=image controller=$imageController type=blog id=$item->Id}

                        {*** Check if the article contain any images ***}
                        {if $image}
                            {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR|default:"fill"}

                            {$imageWidth = 1600}
                            {$imageHeight = 600}
                            {$imageURL = $image->thumbnail($imageWidth, $imageHeight, $crop, $template.watermark)|solutionPath}

                            {include file="modules/widgets/semantics/image-object.tpl" itemprops="image" imageURL=$imageURL height=$imageHeight width=$imageWidth}

                            <figure class="m-blog-list-imagewrap">

                              <a href="/{$pageLink}/{$item->Handle}/" title="{$item->Title}" class="m-blog-list-anchor m-blog-list-image placeholder-wrapper" data-placeholder-max-width="{$imageWidth}px">
                                <span class="placeholder" data-placeholder-aspect="{($imageHeight / $imageWidth) * 100 }%"></span>
                                {img class="responsive" alt="{$item->Title}" src="{$imageURL}"}
                              </a>
                            </figure>
                        {/if}

                        {*** Headline of this specific blog article ***}
                        <header class="m-blog-list-headline">
                            {*** BlogPosting link and title ***}
                            <a href="/{$pageLink}/{$item->Handle}/" title="{$item->Title}" class="m-blog-list-anchor">
                                <h4 class="h2" itemprop="name headline">{$item->Title}</h4>
                            </a>

                            <p class="m-blog-list-data">
                                {*** Publisher information as required by Google's Rich Data standard ***}
                                {include file="modules/widgets/semantics/organization.tpl" itemprops="publisher {if empty($item->Author)}author{/if}"}

                                {*** Author markup ***}
                                {if !empty($item->Author)}
                                    <span class="h6" itemprop="author" itemscope itemtype="http://schema.org/Person" rel="author">{$text.BY_C} <span itemprop="name">{$item->Author}</span></span>
                                {/if}


                                {*** Time of creation ***}
                                <span class="m-blog-list-date">
                                    {if !empty($item->Author)}
                                        {$text.BLOG_DATE_ADD2}
                                    {else}
                                        {$text.BLOG_DATE_ADD}
                                    {/if}
                                    <time class="m-blog-list-date-time" itemprop="dateCreated datePublished" datetime="{$item->DateCreated}">{$item->DateCreated|date_format:$general.dateFormat}</time>
                                </span>

                                {*** Only show category text if blog post has a category (or more) ***}
                                {if $item->CategoryIds|@count > 0}
                                    <span>{$text.UNDER}</span>
                                    {*** Fetch category so we can use title and id for link ***}
                                    {foreach $item->CategoryIds as $catId}
                                        {entity controller=$categoryController assign=blogCategory id=$catId}
                                        <a href="/{$pageLink}/?cat={$catId}" title="{$blogCategory->Title}" class="m-blog-list-anchor m-blog-list-category">{$blogCategory->Title}</a>{if !$catId@last}, {/if}
                                    {/foreach}
                                {/if}

                                {*** Comment count ***}
                                {collection assign=comments controller=blogComment blogId=$item->Id}
                                {if $comments->getActualSize() gt 0}
                                    &#124; <span>
                                        <a href="/{$pageLink}/{$item->Handle}/#add-comment" title="{$text.BLOG_COMMENTS2}" class="m-blog-list-anchor m-blog-list-comment"><span class="badge badge-info">{$comments->getActualSize()}</span> {$text.BLOG_COMMENTS2}</a>
                                    </span>
                                {/if}
                            </p>
                        </header>

                        {*** The description of this blog article, stripped for html tags, truncated to 250 characters ***}
                        {$listDescription = $controller->getDescriptionList($item->Id)}
                        <p itemprop="description" class="m-blog-list-description description platform-content ck-content">
                            {if !empty($listDescription)}
                                {$listDescription}
                            {else}
                                {$controller->getDescription($item->Id)|strip_tags|truncate:250}
                            {/if}
                        </p>

                        {*** Generate a link to this article ***}
                        <p class="m-blog-list-anchorwrap">
                            <a href="/{$pageLink}/{$item->Handle}/" class="is-block m-blog-list-anchor m-blog-list-readmore" itemprop="url" title="{$text.PRODUCT_CATALOG_READ_MORE}"><span class="m-blog-list-anchor-text">{$text.PRODUCT_CATALOG_READ_MORE}</span> <i class="fa fa-long-arrow-right"></i></a>
                             <a href="/{$pageLink}/{$item->Handle}/#add-comment" class="is-block m-blog-list-anchor m-blog-list-comment" title="{$text.BLOG_COMMENT_WRITE_ONE}"><span class="m-blog-list-anchor-text">{$text.BLOG_COMMENT_WRITE_ONE}</span> <i class="fa fa-long-arrow-right"></i></a>
                        </p>

                    {*** End of article content ***}
                    </article>
                </li>
            {/foreach}
        </ol>

    {*** Pagination for the list if enabled ***}
    {if (!isset($pager) or !!$pager)}
        <div class="m-blog-list-pagination">
            {include file='modules/widgets/pagination/pagination.tpl' pageSize=$pageSize size=$collectionSize}
        </div>
    {/if}

    {*** If no blog articles were found in the collection ***}
    {else}
        <div class="panel panel-warning">
            <div class="panel-body">
               <span>{$text.NO_DATA}</span>
            </div>
        </div>
    {/if}
</div>{* end: module *}
