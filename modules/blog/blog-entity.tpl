{*

# Description
Template for a single blog post with comments, slider, captcha and gravatar elements.


## Date last modified
2021-05-28


## Primary variables
+ $controller                                                           - Instance of blogController
+ $commentController                                                    - Instance of blogCommentController
+ $categoryController                                                   - Instance of blogCategoryController
+ $imageController                                                      - Instance of filesController
+ $item                                                                 - Entity of blog (a single blog post)


## Partials (templates)
+ "/modules/widgets/slider/slider.tpl"                                  - Image slider widget, for blog post picture
+ "/modules/widgets/gravatar/gravatar.tpl"                              - Gravatar image widget, for blog comment author picture
+ "/modules/widgets/recaptcha/recaptcha.tpl"                            - Recaptcha widget, for blog comments

*}

{*** Calculate the actual size of the comment collection ***}
{$commentCount = $comments->getActualSize()}

{*** Fetch the categoryController and save it for later ***}
{controller type=blogCategory assign=categoryController}

{*** Fetch the filesController and save it for later ***}
{controller type=files assign=imageController}

{*

# Description
Helper functions for printing out comments and their children


## Resource
+ [Smarty functions](http://www.smarty.net/docs/en/language.function.function.tpl)

*}
{function children parent=null}
    <li class="media m-blog-comment comment-{$comment->Id}" itemprop="comment" itemscope itemtype="http://schema.org/Comment">
        {*** Settings for Gravatar image that will be loaded ***}
        {$commentImageSettings = [
            "fallback"=>"identicon",
            "attrs"=> [
                "class"         =>"media-image",
                "alt"           => $comment->Author
            ]
        ]}

        {*** Fetch the image for the user ***}
        {entity assign=image controller=$imageController type=user id=$comment->UserId}
        <span class="placeholder-wrapper media-image" data-placeholder-max-width="50px">
          <span class="placeholder"></span>
          {*** If no userId is defined or it's set to zero, asume the comment author has not user image and try gravatar ***}
          {if $comment->UserId == 0 or !$image}
              {include file="modules/widgets/gravatar/gravatar.tpl" widgetSettings=$commentImageSettings email=$comment->AuthorEmail}
          {*** Else get the image and (maybe their user) ***}
          {else}
            {img class="responsive" alt="{$comment->Author}" src="{$image->thumbnail(50,50)|solutionPath}"}
          {/if}
        </span>

        <div class="media-body">
            {*** Comment author and author website ***}
            <span itemprop="author creator" itemscope itemtype="http://schema.org/Person" class="h6 comment-author">
                <span itemprop="name">{$comment->Author}</span>
            </span>

            {if !empty($comment->AuthorWeb)} &mdash; <a class="comment-link" rel="nofollow" href="{$comment->AuthorWeb}" title="{$comment->Author}">{$comment->AuthorWeb}</a>{/if}
            {if $comment->TypeId eq 1}<small class="comment-admin"> &mdash; ({$text.BLOG_ADMIN})</small>{/if}

            <p>
                {*** A-tag for hash tag reference ***}
                <a id="comment-{$comment->Id}"></a>

                {*** Time of creation ***}
                <small><time itemprop="dateCreated" datetime="{$comment->DateCreated}">{$comment->DateCreated|date_format:$general.dateTimeFormat}</time></small>

                {*** IF comment is a reply to another comment parent ***}
                {if !empty($parent)}
                {entity controller=$commentController assign=parentComment id=$comment->ParentId}
                <small>{$text.COMMENT_TO|lower} <a href="#comment-{$comment->ParentId}"><time datetime="{$parentComment->DateCreated}">{$parentComment->DateCreated|date_format:$general.dateTimeFormat}</time> {$text.BY} {$parentComment->Author}</a></small>
                {/if}
            </p>

            <div class="platform-content" itemprop="description">{$comment->Description}</div>
            <p><small><a data-blog="reply" data-parentId="{$comment->Id}" href="#add-comment">{$text.FORUM_THREAD_REPLY}</a></small></p>
        </div>

    {*** If not a root comment close li to only nest one level ***}
    {if !empty($parent)}</li>{/if}

    {*** If children and root comment, nest one level ***}
    {if $comment->Children|@count > 0 && empty($parent)}<ul>{/if}
    {foreach $comment->Children as $child}
        {*** call function recursively this time with parents not being null ***}
        {children comment=$child parent=$comment}
    {/foreach}
    {*** If children and root comment, close nest one level ***}
    {if $comment->Children|@count > 0 && empty($parent)}</ul>{/if}

    {*** If a root comment close li after recursive to nest one level ***}
    {if empty($parent)}</li>{/if}
{/function}

{*** Start of module ***}
<div class="modules m-blog" itemscope itemtype="http://schema.org/BlogPosting">
    {** Include organization and (if necessary) author metadata **}
    {include file="modules/widgets/semantics/organization.tpl" itemprops="publisher{if empty($item->Author)} author{/if}"}
    <meta itemprop="mainEntityOfPage" content="{$page.url}">

    <div class="modules m-blog-post">
        {*** Article content ***}
        <article>
            {*** Header for the blog article ***}
            <header class="m-blog-header page-title">
                {*** Title of this blog article ***}
                <h1 class="m-blog-headline" itemprop="name headline">{$item->Title}</h1>

                {*** End of header ***}
            </header>

            <div class="meta trailing-trip m-blog-meta-wrap">
                <p>
                    {if !empty($item->Author)}
                        {*** Author markup ***}
                        <span class="h6 m-blog-author" itemprop="author" itemscope itemtype="http://schema.org/Person">{$text.BY_C} <span itemprop="name">{$item->Author}</span></span>
                    {/if}

                    {*** Time of creation ***}
                    <span class="m-blog-date-created">
                        {if !empty($item->Author)}
                            {$text.BLOG_DATE_ADD2}
                        {else}
                            {$text.BLOG_DATE_ADD}
                        {/if}
                        <time itemprop="dateCreated datePublished" datetime="{$item->DateCreated}">{$item->DateCreated|date_format:$general.dateFormat}</time>
                    </span>

                    {*** Only show category text if blog post has a category (or more) ***}
                    {if $item->CategoryIds|@count > 0}
                        <span>{$text.UNDER}</span>
                        {*** Fetch category so we can use title and id for link ***}
                        {foreach $item->CategoryIds as $catId}
                            {*** Fetch the link of the page for this specific item ***}
                            {$pageLink = {page id=$item->PageId print=Link}}

                            {entity controller=$categoryController assign=blogCategory id=$catId}
                            <a href="/{$pageLink}/?cat={$catId}" title="{$blogCategory->Title}">{$blogCategory->Title}</a>{if !$catId@last}, {/if}
                        {/foreach}
                    {/if}
                </p>
            </div>

            {*** Slider settings to show the images of this article ***}
            {$crop = "fill"}
            {if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
                {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
            {/if}
        	{$sliderSettings = [
                "slider"    => "single",
                "theme"     => "blog-slider-theme",
                "pagination"=> "true",
                "width"     => 1600,
                "height"    => 600,
                "crop"      => $crop,
                "watermark" => true
            ]}

            {*** Include the slider template and send along the settings and information to fetch from the filesController ***}
            {include file="modules/widgets/slider/slider.tpl" widgetSettings=$sliderSettings alt=$item->Title type=blog id=$item->Id microdata=true}

            {*** The description of this blog article needs to be loaded from the controller ***}
            <div class="m-blog-content trailing-trip platform-content ck-content" itemprop="articleBody">{$controller->getDescription($item->Id)}</div>

            {* Include social media *}
            {if $settings.social_facebook or $settings.social_twitter}
                <div class="row m-blog-social-widgets">
                    <ul class="m-widgets w-social list-inline">
                    {foreach ["twitter","facebook"] as $social}
                        <li class="w-social-item">
                            {include file="modules/widgets/social/{$social}.tpl"}
                        </li>
                    {/foreach}
                    </ul>
                </div>
            {/if}

        {*** End of article content ***}
        </article>
    </div>{*** end: .modules .m-blog ***}

    <hr />

    <div class="row m-blog-commets-container">
        <div class="modules m-blog-comments">
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-blog-add-comment">
                <a name="add-comment" id="add-comment"></a>
                <span class="h6">
                {if $commentCount gt 0}
                    {$text.BLOG_COMMENTS2|ucfirst} <span class="badge badge-info">{$commentCount}</span>
                {else}
                    {$text.BLOG_NO_COMMENT|ucfirst}
                {/if}
                </span>
            </div>{*** end: col-12 ***}

            {*** If there are any comments show them ***}
            {if $commentCount gt 0}
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 hr">
                <hr/>
            </div>
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-blog-user-comments">
                <ul class="list-unstyled t-border-bottom trailing-db">
                {*** Get all comments, with the true paramter for a tree structure instead of a flat structure ***}
                {foreach $comments->getData(true) as $comment}
                    {children comment=$comment}
                {/foreach}
                </ul>{*** end: .l-list-border ***}
            </div>{*** end: .col-12 ***}
            {/if} {*** end: if comments ***}

            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-blog-comment-text">
                <span class="h6">{$text.BLOG_COMMENT_WRITE}</span>
            </div>
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 hr">
                <hr/>
            </div>
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 form-wrap">

                {*** Form used to add a comment ***}
                <form class="comment-form m-calendar-form" action="/actions/blog/comment" data-blog="form" method="post">
                    {csrf type="input"}
                    <input type="hidden" name="action" value="add_comment" />
                    <input type="hidden" name="blog_id" value="{$item->Id}" />
                    <input type="hidden" name="comment_parent" value="0" />
                    <input type="hidden" name="check" />

                    <div class="row m-blog-userinfo">
                        <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                            <fieldset class="form-group m-blog-name">
                                <label for="name" class="form-label">{$text.NAME} <span class="form-required">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="user"}</span>
                                    <input type="text" id="name" name="name" class="form-input input-group-main" placeholder="{$text.NAME}" required>
                                </div>
                            </fieldset>
                        </div>
                    </div>

                    <div class="row m-blog-userdetails">
                       <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                            <fieldset class="form-group m-blog-email">
                                <label class="form-label" for="email">{$text.MAIL} <span class="form-required">*</span> <small>{$text.BLOG_MAIL_NO_OFFENTLIG}</small></label>
                                <div class="input-group">
                                    <span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="mail"}</span>
                                    <input type="email" id="email" name="email" class="form-input input-group-main" placeholder="{$text.MAIL}" required>
                                </div>
                            </fieldset>
                        </div>

                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                            <fieldset class="form-group m-blog-website">
                                <label class="form-label" for="web">{$text.BLOG_WEBSITE}</label>
                                <div class="input-group">
                                    <span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="globe"}</span>
                                    <input type="text" id="web" name="website" value="" class="form-input input-group-main" placeholder="{$text.BLOG_WEBSITE}">
                                </div>
                            </fieldset>
                        </div>
                    </div>

                    <div class="row m-blog-comment">
                        <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                            <fieldset class="form-group m-blog-comment">
                                <label class="form-label" for="comment">{$text.BLOG_COMMENT} <span class="form-required">*</span></label>
                                <textarea id="comment" name="comment" class="form-input" style="height: 150px;" required placeholder="{$text.BLOG_COMMENT}"></textarea>
                            </fieldset>
                        </div>
                    </div>

                    {*** If we should show a spam check include the recaptcha ***}
                    {if $settings.spam_check}
                    <div class="row m-blog-recaptcha">
                        <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                            {include file="modules/widgets/recaptcha/recaptcha.tpl"}
                        </div>
                    </div>
                    {/if}

                    {if $settings.privacy_policy_blog}
                    <div class="row m-blog-consent">
                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                            {include file="modules/widgets/consent/consent.tpl"}
                        </div>
                    </div>
                    {/if}

                    <button type="submit" class="button">{$text.BLOG_COMMENT_ADD}</button>
                </form>{*** end: form ***}

                <button type="submit" class="button button-icon button-primary is-block is-hidden" data-blog="reply-post" data-parentId="0">
                    {include file="modules/widgets/icon/icon.tpl" icon="messageCircle"}
                    {$text.BLOG_COMMENT_WRITE_TO_POST}
                </button>

            </div>{*** end: col-12 ***}

            <div class=" col-s-4 col-m-12 col-l-12 col-xl-24 m-blog-description-bottom description trailing">
                <p class="m-blog-description-bottom consent-description">{if $general.isShop}{$text.BLOG_CONSENT_DESCRIPTION_SHOP}{else}{$text.BLOG_CONSENT_DESCRIPTION_CMS}{/if}</p>
            </div>

        </div>{*** end: .m-blog-comments ***}
    </div>{*** end: .row ***}
</div>{*** End of module ***}
