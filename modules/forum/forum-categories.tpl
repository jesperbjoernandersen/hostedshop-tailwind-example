{*

# Description
Template for forum categories


## Date last modified
2017-05-19


## Primary variables
+ $controller                     										- Instance of forumController
+ $items           														- Collection of forumController (all form categories)
+ $threads                                                  			- Collection of forumThreadController (multiple threads for a category)


## Partials (templates)
No extra templates required for this template

*}

<div class="modules m-forum">
	<div class="row">
		<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
			<header class="m-forum-page-header">
				<h1 class="m-forum-page-headline page-title">{$page.headline}</h1>
			</header>
		</div>
		<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
			<hr>
			<div class="row">
				<div class="col-s-4 col-m-6 col-l-6 col-xl-12 m-forum-text-topics">
					<p><strong>{$text.FORUM_TOPICS}</strong></p>
				</div>
				<div class="col-s-4 col-m-6 col-l-6 col-xl-12 is-hidden-s m-forum-text-latest-threads">
					<p><strong>{$text.FORUM_THREADS_LATEST}</strong></p>
				</div>
			</div>
			<ul class="list-unstyled t-border-bottom m-forum-list-container" itemscope itemtype="http://schema.org/ItemList">
				{foreach $items->getData() as $category}
					{$pagelink = {page id=$category->PageId print=Link}}
					{collection assign=threads controller=forumThread categoryId=$category->Id}
					<li class="m-forum-item item-category-{$category->Id}">
						<article itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
							<meta itemprop="position" content="{$category@iteration}">

							<div class="row">
								<div class="col-s-4 col-m-6 col-l-6 col-xl-12 m-forum-topics-container">
									<div class="media">
										<a href="/{$pagelink}/{$category->Handle}/" class="media-image">
											<i class="fa fa-folder-open fa-3x fa-fw"></i>
										</a>
										<div class="media-body">
											<a href="/{$pagelink}/{$category->Handle}/" title="{$category->Title}" itemprop="url">
												<h4 class="h6"><span>{$category->Title}</span> <span class="badge badge-info">{$threads->getActualSize()}</span></h4>
											</a>
											<p>{$controller->getDescription($category->Id)}</p>
										</div>
									</div>
								</div>
								<div class="col-s-4 col-m-6 col-l-6 col-xl-12 is-hidden-s m-forum-latest-threads-container">
									{if $threads->getActualSize() gt 0}
										{$lastthread = $threads->getData()}
										{entity controller=user assign=item id=$answer->UserId security=false}

										<p>
											<a href="/{$pagelink}/{$category->Handle}/{$lastthread[0]->Handle}/" class="is-block" title="{$lastthread[0]->Headline}">{$lastthread[0]->Headline}</a>
											<span>{$text.BY_C} {$user->Firstname}</span>
											<small>
                                                <time datetime="{$lastthread[0]->DateCreated}">{$lastthread[0]->DateCreated|date_format:$general.dateTimeFormat}</time>
                                            </small>
										</p>
									{else}
										<p>{$text.FORUM_THREADS_NONE}</p>
									{/if}
								</div>
							</div>
						</article>
					</li>
				{/foreach}
			</ul>
		</div>
	</div>
</div>
