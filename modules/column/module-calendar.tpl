{*

# Description
Template for Calendar in a column box, the template is build with [AngularJS](https://angularjs.org/).


## Date last modified
2020-08-28


## Resource
+ [AngularJS](https://angularjs.org/)


## Primary variables
+ $text                                                     			- Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{* Dates to look between *}
{$currentDate = date('Y-m-d')}
{$endDate = date('Y-m-d', strtotime('last day of +3 months'))}

{*** Collection of events ***}
{collection assign=events controller=event pageId=$box->PageId dateFrom=$currentDate}

{$calendarLink = PageController::link($box->PageId)}

{$months = [
	$text.DATE_MONTH_JANUARY,
	$text.DATE_MONTH_FEBRUARY,
	$text.DATE_MONTH_MARCH,
	$text.DATE_MONTH_APRIL,
	$text.DATE_MONTH_MAY,
	$text.DATE_MONTH_JUNE,
	$text.DATE_MONTH_JULY,
	$text.DATE_MONTH_AUGUST,
	$text.DATE_MONTH_SEPTEMBER,
	$text.DATE_MONTH_OCTOBER,
	$text.DATE_MONTH_NOVEMBER,
	$text.DATE_MONTH_DECEMBER
]}

{$days = [
	$text.DATE_DAY_MONDAY,
	$text.DATE_DAY_TUESDAY,
	$text.DATE_DAY_WEDNESDAY,
	$text.DATE_DAY_THURSDAY,
	$text.DATE_DAY_FRIDAY,
	$text.DATE_DAY_SATURDAY,
	$text.DATE_DAY_SUNDAY
]}

<div class="panel panel-border column-box b-calendar">
	<div class="panel-heading b-calendar-header b-header">
		<span class="h5">{$text.CALENDAR_BOX_TITLE}</span>
	</div>

	{if $events->getActualSize() gt 0}
		<ul class="list-unstyled t-border-bottom b-calendar-list" itemscope itemtype="http://schema.org/ItemList">
			
			{$mHeader = null}
			{$eventsAhead = []}
			{$eventsAheadCounted = 0}
			{$data = $events->getData()}

			{* Find events ahead *}
			{foreach $data as $event}
				{$startOfNextMonth = date('Y-m-d', strtotime('first day of +1 months'))}
				{if $startOfNextMonth <= $event->DateStart && $endDate >= $event->DateEnd}
					{$eventsAhead[] = $event->Id}
				{/if}
			{/foreach}

			{foreach $data as $event}

				{if $event->DateStart > $endDate}
					{continue}
				{/if}

				{$m = (int)$event->DateStart|date_format:"%m"}

				{* Month header *}
				{if $m != $mHeader && $eventsAhead|@count}
					{$mHeader = $m}
					<li class="panel-border month-header trailing">{$months[$mHeader-1]}</li>
				{/if}

				{$eventRelativeLink = $calendarLink|cat:$event->Handle|cat:"/"}
				
				<li class="event m-calender-event event-{$event->Id} trailing" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
					<article {literal}data-ng-style="{'border-left':'solid {/literal}{$event->LabelColor}{literal}'}"{/literal}>
						<a class="m-calendar-title-anchor is-block" href="{$eventRelativeLink}" title="{$event->Title}">
							<div class="date-col">
								<strong class="date is-block">{substr($months[$m-1], 0, 3)} {$event->DateStart|date_format:"%d"}</strong>
								{$d = date('N', strtotime($event->DateStart))}
								{$d = $days[$d-1]}
								{$chars = 3}
								{* Count HTML entities *}
								{$match = ""}
								{if preg_match("/\&(.*);/", $d, $match)}
									{$chars = $chars + $match[0]|count_characters - 1}
								{/if}
								<small class="day">{substr($d, 0, $chars)}</small>
							</div>
							<div class="description-col">
								{$event->Title}
								<br>
								{$from = $event->DateStart|date_format:"%H:%M"}
								{$to = $event->DateEnd|date_format:"%H:%M"}
								
								{* If not within 24 hours *}
								{if ((strtotime($event->DateEnd)/60/60) - (strtotime($event->DateStart)/60/60)) >= 24}
									{$endMonth = (int)$event->DateEnd|date_format:"%m"}
									{$from = $event->DateStart|date_format:"{substr($months[$m-1], 0, 3)} %d %H:%M"}
									{$to = $event->DateEnd|date_format:"{substr($months[$endMonth-1], 0, 3)} %d %H:%M"}
								{/if}
								{* Start date & time *}
								<small class="from-and-to">{$from} - {$to}</small>
								<meta itemprop="startDate" content="{$event->DateStart}">
								<meta itemprop="endDate" content="{$event->DateEnd}">
							</div>
						</a>
					</article>
				</li>

				{if $event->Id|in_array:$eventsAhead}
					{$eventsAheadCounted = $eventsAheadCounted + 1}
				{/if}

				{* Events ahead limit *}
				{if $eventsAheadCounted == 10}
					<li class="panel-border text-center month-header">
						<a href="{$calendarLink}">{$text.RATING_RATINGS_SEE_ALL}</a>
					</li>
					{break}
				{/if}

			{/foreach}
		</ul>
	{else}
	<div class="panel-body panel-border">
		<p>{$text.CALENDAR_NO_EVENTS}</p>
	</div>
	{/if}
</div>
