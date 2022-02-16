{*

# Description
Template for a list of calendar events in the picked month.


## Date last modified
2021-11-30


## Primary variables
+ $controller 															- Instance of calendarController
+ $filesController														- Instance of filesController
+ $items																- Collection of calendar events
+ $year 																- Year in the current state (derived from url)
+ $month 																- Month in the current state (derived from url)
+ $day 																	- Day in the current state (derived from url)
+ $linkPrevYear															- Variable from parent scope with the link to prev year in current state
+ $linkPrevMonth														- Variable from parent scope with the link to prev month in current state
+ $linkNextYear															- Variable from parent scope with the link to next year in current state
+ $linkNextMonth														- Variable from parent scope with the link to next month in current state


## Partials (templates)
No extra templates required for this template

*}

{$isCompleteList = true}
{$previousMonth = false}
{if isset($page.paths.1)}
	{*** Link meta - Canonical to prevent dublicate content ***}
	{addLink rel=canonical href="/{$pageLink}/{date('Y')}-{date('n')}/" relative=true}
	{$isCompleteList = false}
{/if}

{$imageWidth = 320}
{$imageHeight = 240}

{include file="modules/widgets/image/placeholder-aspect.tpl"
	width=$imageWidth
	height=$imageHeight
	selector=":not(.ielt9) .m-calendar-list"}

<div class="modules m-calendar-list">
	<header class="m-calendar-header page-title">
        <h1 class="m-calendar-headline">{$page.headline}</h1>
	</header>
	<div class="panel panel-border">
		<div class="panel-heading">
			<div class="row m-blog-info">
			{if $isCompleteList}
				<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
					<span class="h2 m-blog-date-overview">{$text.CALENDAR_OVERVIEW}</span>
				</div>
			{else}
				<div class="col-s-4 col-m-8 col-l-8 col-xl-16 trailing-mobile">
					<span class="h2 m-blog-date-month">{$month|formatMonth} <span class="m-blog-date-month">{$year}</span></span>
				</div>
				<div class="col-s-4 col-m-4 col-l-4 col-xl-8 text-right">
					<a class="button small is-i-b width-auto anchor-overview" style="width:auto;" href="/{$pageLink}/">{$text.CALENDAR_BACK_TO_OVERVIEW}</a>
					<a class="button small is-i-b width-auto anchor-prev" style="width:auto;" href="/{$pageLink}/{$linkPrevYear}-{$linkPrevMonth}/"><i class="fa fa-chevron-left fa-fw"></i></a>
					<a class="button small is-i-b width-auto anchor-next" style="width:auto;" href="/{$pageLink}/{$linkNextYear}-{$linkNextMonth}/"><i class="fa fa-chevron-right fa-fw"></i></a>
				</div>
			{/if}
			</div>
		</div>
			{if $items->getActualSize() gt 0}
			<ul class="list-unstyled t-border-bottom m-calendar-container" itemscope itemtype="http://schema.org/ItemList">
				{foreach $items->getData() as $event}
					{$eventRelativeLink = "/{$pageLink}/{$event->Handle}/"}
					{entity controller=files type=event id=$event->Id assign=image}

					{if $isCompleteList}
						{$eventParts = explode("-", $event->DateStart)}
						{$eventYear = (int)$eventParts[0]}
						{$eventMonth = (int)$eventParts[1]}
						{$completeDate = "{$eventMonth} {$eventYear}"}

						{if $previousMonth != $completeDate}
							<li class="events m-calender-event m-calender-event__headline event-{$event->Id}__headline panel-border" style="padding:0;">
								<div class="panel-heading">
									<a href="/{$pageLink}/{$eventYear}-{$eventMonth}/" class="m-calender-month-link is-block"><span class="h4 m-blog-date-month">{$eventMonth|formatMonth} <span class="m-blog-date-month">{$eventYear}</span></span></a>
								</div>
							</li>
						{/if}
						{$previousMonth = $completeDate}
					{/if}

					<li class="events m-calender-event event-{$event->Id}" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
						<meta itemprop="position" content="{$event@iteration}">
						<meta itemprop="url" content="{$page.url}{$event->Handle}">

						<article class="day" itemscope itemtype="http://schema.org/Event">
							{*** No location data is available, so we cannot provide this property. ***}
							<div style="border-right: 6px solid {$event->LabelColor};">
								<div class="row">
									{if $image}
										{$imageURL = $image->thumbnail($imageWidth,$imageHeight)|solutionPath}
										<div class="col-s-1 col-m-3 col-l-3 col-xl-6">
											<figure class="m-calendar-list-imagewrap">
												<a href="{$eventRelativeLink}" class="placeholder-wrapper" title="{$event->Title}">
													{include file="modules/widgets/semantics/image-object.tpl" itemprops="image" imageURL=$imageURL width=$imageWidth height=$imageHeight}
													<span class="placeholder"></span>
													{img src="{$imageURL}" class="responsive" alt="{$event->Title}"}
												</a>
											</figure>
										</div>
									{/if}
									<div class="{if $image}col-s-3 col-m-9 col-l-9 col-xl-18{else}col-s-4 col-m-12 col-l-12 col-xl-24{/if}">
										<div class="row">
											<div class="col-s-4 col-m-6 col-l-12 col-xl-12">
												<a class="m-calendar-title-anchor" href="{$eventRelativeLink}" title="{$event->Title}">
													<h4 class="trailing" itemprop="name">{$event->Title}</h4>
												</a>

												{*** Start date & time ***}
												<p class="m-calendar-period from-text">
													<strong>{$text.CALENDAR_PERIOD_FROM}:</strong>
												</p>
												<p class="m-calendar-period from-date">
													<span class="startDate">{$text.DATE_THE_C} {$event->DateStart|date_format:$general.dateTimeFormat}</span>
													<meta itemprop="startDate" content="{$event->DateStart}">
												</p>
												<br>

												{*** End date & time ***}
												<p class="m-calendar-period until-text">
													<strong>{$text.CALENDAR_PERIOD_UNTIL}:</strong>
												</p>
												<p class="m-calendar-period until-date">
													<span class="endDate">{$text.DATE_THE_C} {$event->DateEnd|date_format:$general.dateTimeFormat}</span>
													<meta itemprop="endDate" content="{$event->DateEnd}">
												</p>
											</div>
											<div class="col-s-4 col-m-6 col-l-12 col-xl-12 is-hidden-s m-calendar-description">
												{if $controller->getDescription($event->Id)}
													<p class="m-calendar-description" itemprop="description">{$controller->getDescription($event->Id)|strip_tags|truncate:100}</p>
													<p><a href="/{$pageLink}/{$event->Handle}/" title="{$text.PRODUCT_CATALOG_READ_MORE}">{$text.PRODUCT_CATALOG_READ_MORE} <i class="fa fa-long-arrow-right"></i></a></p>
												{/if}
											</div>
										</div>
									</div>
								</div>
							</div>
						</article>
					</li>
				{/foreach}
			</ul>
		{else}
			<div class="panel-body">
				<span>{$text.CALENDAR_NO_EVENTS}</span>
			</div>
		{/if}
	</div>
</div>
