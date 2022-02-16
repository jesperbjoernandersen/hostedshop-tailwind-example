{*

# Description
Template for a list forum posts


## Date last modified
2014-08-01


## Primary variables
+ $controller                                                           - Instance of forumController
+ $category                                                             - Entity of forumController (single forum category)
+ $items                                                                - Collection of forumThreadController (list of threads for a category)
+ $pageSize                                                             - Items pr page (threads per page)
+ $threads                                                              - Collection of forumThreadController (list of threads for a category)
+ $answers                                                              - Collection of forumAnswerController (list of replies to a post)


## Partials (templates)
+ "/modules/widgets/recaptcha/recaptcha.tpl"                            - Recaptcha widget, for blog comments
+ "/modules/widgets/modal/modal.tpl"                                    - Modal widget, for opening a fancybox modal overlay

*}

{$pagelink = {page id=$page.id print=Link}}

<div class="modules m-forum-list">
    <article>
    	<div class="row">
    		<div class="col-s-4 col-m-12 col-l-12 col-xl-24 header-row">
    			<header class="m-forum-page-header">
    				<h1 class="m-forum-page-headline page-title">{$category->Title}</h1>
    			</header>
    		</div>
    		<div class="col-s-4 col-m-12 col-l-12 col-xl-24 list-row">
    			{if $items->getActualSize() gt 0}
        			<ul class="list-unstyled m-forum-list-container">
        				{foreach $items->getData() as $thread}
        					{collection assign=answers controller=forumAnswer threadId=$thread->Id}
                            {entity controller=user assign=item id=$answer->UserId security=false}

        					<li class="trailing-trip m-forum-list-item">
        						<article class="media">
        							<a href="/{$pagelink}/{$category->Handle}/{$thread->Handle}/" class="media-image">
        								<i class="fa fa-comment fa-3x fa-fw"></i>
        							</a>
        							<div class="media-body">
        								<a href="/{$pagelink}/{$category->Handle}/{$thread->Handle}/" title="{$thread->Headline}">
        									<h4 class="h6"><span>{$thread->Headline}</span> <span class="badge badge-info">{$answers->getActualSize()}</span></h4>
        								</a>
                                        <span>{$text.BY_C} {$user->Firstname}</span>
                                        <small>
                                            <time datetime="{$thread->DateCreated}">{$thread->DateCreated|date_format:$general.dateTimeFormat}</time>
                                        </small><br>
        								<span>{$text.FORUM_THREADS_SEES}: {$thread->ReadCount}</span>
        							</div>
        						</article>
        						<hr>
        					</li>
        				{/foreach}
        			</ul>
    			{else}
    				<div class="panel panel-warning">
    					<div class="panel-body">
    						<span>{$text.FORUM_TOPIC_THREADS_NONE}</span>
    					</div>
    				</div>
    			{/if}
    		</div>
    	</div>
    	{if $items->getActualSize() lt 1}
    		<hr>
    	{/if}
    	<div class="row m-forum-thread-container">
            <div class="modules m-forum-answer" itemscope itemtype="http://schema.org/Usercomments">
                <div class="col-s-4 col-m-12 col-l-12 col-xl-24 header-row">
                    <a id="add-answer"></a>
                    <span class="h6">{$text.FORUM_THREAD_ADD}</span>
                    <br><br>
                </div>
                <div class="col-s-4 col-m-12 col-l-12 col-xl-24 form-wrap">
    				{if isset($user)}
                        <form class="m-forum-add-thread-form" method="post" action="/actions/forum/add" data-forum="form">
                            {csrf type="input"}
    						<input type="hidden" name="topic_id" value="{$category->Id}">
    						<input type="hidden" name="goto" value="/{$page.paths[0]}/{$page.paths[1]}/{$item->Handle}/">
                            <div class="row">
                                <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-forum-header-row">
    								<fieldset class="form-group m-forum-add-thread-headline">
    					                <label class="form-label" for="m-login-username">{$text.FORUM_THREAD_ADD_HEADLINE} <span class="form-required">*</span></label>
    					                <input id="ctHeadline" name="headline" placeholder="{$text.FORUM_THREAD_ADD_HEADLINE}" type="text" class="form-input input-group-main" required>
    					            </fieldset>
    					        </div>
    					        <div class="col-s-4 col-m-12 col-l-12 col-xl-24 m-forum-user-info-row">
    								<fieldset class="form-group m-forum-username">
    					                <label class="form-label" for="m-login-username">{$text.FORUM_THREAD_REPLY_DESCRIPTION} <span class="form-required">*</span></label>
    								    <textarea class="form-input" name="description" placeholder="{$text.FORUM_THREAD_REPLY_DESCRIPTION}" style="min-height: 180px;" required></textarea>
    								</fieldset>
    					        </div>
                            </div>
                            <button type="submit" class="button button-icon button-primary m-forum-add-thread-button-hidden" data-parentId="0"><i class="fa fa-comment"></i>{$text.FORUM_THREAD_ADD}</button>
                        </form>
    				{else}
    					<a href="#modal1" class="button-primary button-icon fancybox-modal m-forum-add-thread-button-not-loggedin"><i class="fa fa-comment"></i>{$text.FORUM_THREADS_NOT_LOGGED_IN}</a>
    				{/if}
                </div>
            </div>
        </div>
    </article>
</div>

{if !isset($user)}
	{include file="modules/widgets/modal/modal.tpl" dataId="1" dataType="widget" dataClose="true" dataTarget="login" dataRequest="{$page.request}"}
{/if}
