{*

# Description
Template for a single post with replies


## Date last modified
2016-09-29


## Primary variables
+ $item                                                                 - Entity of forumController (single forum category)
+ $controller                                                           - Instance of forumThreadController
+ $item                                                                 - Entity of forumController (single forum category)
+ $pageSize                                                             - Items pr page (threads per page)
+ $categories                                                           - Collection of forumController (all form categories)
+ $answercontroller                                                     - Instance of forumAnswerController
+ $answers                                                              - Collection of forumAnswerController (list of post replies)
+ $imageController                                                      - Instance of filesController
+ $userController                                                       - Instance of userController
+ $user                                                                 - Entity of userController (author of a single post or reply)
+ $parentanswer                                                         - Entity of forumAnswerController (parent initialized with parentId)
+ $author                                                               - Entity of userController


## Partials (templates)
+ "/modules/widgets/gravatar/gravatar.tpl"                              - Gravatar image widget, for blog comment author picture
+ "/modules/widgets/recaptcha/recaptcha.tpl"                            - Recaptcha widget, for blog comments
+ "/modules/widgets/modal/modal.tpl"                                    - Modal widget, for opening a fancybox modal overlay

*}

{$pagelink = {page id=$page.id print=Link}}

{controller assign=answercontroller type=forumAnswer primary=true}

{*** Fetch the answerController and save it for later ***}
{collection assign=answers controller=$answercontroller paginate_max=$pageSize}

{*** Fetch the filesController and save it for later ***}
{controller type=files assign=imageController}

{*** Fetch the userController and save it for later ***}
{controller type=user assign=userController}

{*** Calculate the actual size of the answers collection ***}
{$answersCount = $answers->getActualSize()}

{*** Print Read count ***}
<span style="display:none;">{$controller->updateReadCount($item->Id)}</span>

{*

# Description
Helper functions for printing out answers and their children


## Resource
+ [Smarty functions](http://www.smarty.net/docs/en/language.function.function.tpl)

*}
{function children parent=null}
	{entity assign=user controller=$userController id=$answer->UserId security=false}
	<li class="media m-forum-answer" itemscope itemtype="http://schema.org/Comment">
		<div class="media">
            {$answerImageSettings = [
                "fallback"=>"identicon",
                "attrs"=> [
                    "class"=>"responsive media-image",
                    "alt"=> $answer->Author
                ]
            ]}
            {include file="modules/widgets/gravatar/gravatar.tpl" widgetSettings=$answerImageSettings email=$user->Email}
	        <div class="media-body">
	            {$AuthorHasWebsite = !empty($user->Website)}
	            {if $AuthorHasWebsite}
	            <a class="m-forum-author-anchor" href="{if strpos($user->Website, 'http') !== 0}http://{/if}{$user->Website}" title="{$answer->Author}">
	            {/if}
	                <span itemprop="author creator" itemscope itemtype="http://schema.org/Person" class="h6"><span itemprop="givenName">{$user->Firstname}</span> <span itemprop="familyName">{$user->Lastname}</span></span>
	            {if $AuthorHasWebsite}
	            </a>
	            {/if}
	            <p>
	                <a id="answer-{$answer->Id}"></a>
	                <small><time itemprop="dateCreated" datetime="{$answer->DateCreated}">{$answer->DateCreated|date_format:$general.dateTimeFormat}</time></small>
	                {if !empty($parent)}
	                {entity controller=$answerController assign=parentanswer id=$answer->ParentId}
	                <small>{$text.ANSWER_TO|lower} <a href="#answer-{$answer->ParentId}"><time itemprop="dateCreated" datetime="{$parentanswer->DateCreated}">{$parentanswer->DateCreated|date_format:$general.dateTimeFormat}</time> {$text.BY} {$parentanswer->Author}</a></small>
	                {/if}
	            </p>
				<span class="h6">{$answer->Headline}</span>
	            <div class="m-forum-answer-text" itemprop="description">{$answer->Description}</div>
	        </div>
		</div>
    </li>
{/function}

<div class="modules m-forum">
	<header class="m-forum-header page-title">
		<h1>{$item->Headline}</h1>
	</header>

	<div class="meta trailing-trip m-forum-meta-wrap">
		{entity assign=author controller=$userController id=$item->UserId security=false}
		<p class="m-forum-author-info">
            {$text.BY_C} <span rel="author">{$author->Firstname} {$author->Lastname}</span>
            <small>
                <time datetime="{$item->DateCreated}">{$item->DateCreated}</time>
            </small>
        </p>
    </div>

	<div class="content m-forum-description">
		<p>{$item->Description}</p>
	</div>
	<hr>
	<div class="row">
        <div class="modules m-forum-answer">
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                <span class="h6">
                    {$text.FORUM_THREAD_ANSWERS}
                    {if $answersCount gt 0}
                    	<span class="badge badge-info">{$answersCount}</span>
                    {/if}
                </span>
                <br><br>
            </div>
            {if $answersCount gt 0}
	            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-hr-line">
	                <hr/>
	            </div>
	            <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
	                <ul class="list-unstyled t-border-bottom m-forum-answer-list">
	                    {foreach $answers->getData() as $answer}
	                        {children answer=$answer}
	                    {/foreach}
	                </ul>
	            </div>
            {/if}


            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-forum-add-answer">
                <span class="h6">
                    <a id="add-answer"></a>
                    {$text.FORUM_THREAD_REPLY_HEADLINE}
                </span>
                <br><br>
            </div>
            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 form-wrap">
				{if isset($user)}
                    <form id="m-forum-add-answer-form" method="post" action="/actions/forum/comment" data-forum="form">
                        {csrf type="input"}
						<input type="hidden" name="thread_id" value="{$item->Id}">
                        <div class="row">
                            <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-forum-username-row">
								<fieldset class="form-group m-forum-username">
					                <label class="form-label" for="m-login-username">{$text.FORUM_THREAD_ADD_HEADLINE} <span class="form-required">*</span></label>
					                <input id="ctHeadline" name="headline" type="text" placeholder="{$text.FORUM_THREAD_ADD_HEADLINE}" class="form-input input-group-main" required>
					            </fieldset>
					        </div>
					        <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-forum-reply-text-row">
								<fieldset class="form-group m-forum-text">
					                <label class="form-label" for="m-login-username">{$text.FORUM_THREAD_REPLY_DESCRIPTION} <span class="form-required">*</span></label>
								    <textarea class="form-input" name="description" placeholder="{$text.FORUM_THREAD_REPLY_DESCRIPTION}" style="min-height: 180px;" required></textarea>
								</fieldset>
					        </div>
                        </div>
                    	<button type="submit" class="button button-icon button-primary m-forum-add-answer-button" data-parentId="0"><i class="fa fa-comment"></i>{$text.FORUM_THREAD_REPLY}</button>
                    </form>
				{else}
					<a href="#modal1" class="button-primary button-icon fancybox-modal m-forum-add-answer-button" title="{$text.FORUM_THREADS_NOT_LOGGED_IN}"><i class="fa fa-comment"></i>{$text.FORUM_THREADS_NOT_LOGGED_IN}</a>
				{/if}
            </div>
        </div>
    </div>
</div>

{if !isset($user)}
	{pageInclude file="modules/widgets/modal/modal.tpl" dataId="1" dataType="widget" dataClose="true" dataTarget="login" dataRequest="{$page.request}"}
{/if}
