{*

# Description
Template for a single event with slider element.


## Date last modified
2021-05-28


## Primary variables
+ $controller                                                           - Instance of calendarController
+ $filesController                                                      - Instance of filesController
+ $item                                                                 - Entity of calendar (a single event)
+ $year                                                                 - Year in the current state (derived from url)
+ $month                                                                - Month in the current state (derived from url)
+ $day                                                                  - Day in the current state (derived from url)


## Partials (templates)
+ "/modules/widgets/slider/slider.tpl"                                  - Image slider widget, for blog post picture

*}

<div class="modules m-calendar" itemscope itemtype="http://schema.org/Event">
	<article class="m-calendar-article">
		<header class="m-calendar-header page-title">
            <h1 class="m-calendar-headline" itemprop="name">{$item->Title}</h1>
		</header>
		{$crop = "fill"}
        {if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
            {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
        {/if}
		{$sliderSettings = [
            "slider"    => "single",
            "theme"     => "hero-slider-theme",
            "pagination"=> "true",
            "width"		=> 1240,
            "height"	=> 440,
        	"crop"      => $crop
        ]}
        {include file="modules/widgets/slider/slider.tpl" placeholderSelector=".m-calendar-article" widgetSettings=$sliderSettings alt=$item->Title type=event id=$item->Id microdata=true}

		<div class="row m-calendar entity-wrap">
			<div class="col-s-4 col-m-4 col-l-6 col-xl-16">
				{if $controller->getDescription($item->Id)}
					<div class="m-calendar-content description trailing platform-content ck-content" itemprop="description">{$controller->getDescription($item->Id)}</div>
				{/if}

		        {* Include social media *}
            	{if $settings.social_facebook or $settings.social_twitter}
		            <div class="row">
		                <ul class="m-widgets w-social list-inline">
                    	{foreach ["twitter","facebook"] as $social}
		                    <li class="w-social-item">
		                        {include file="modules/widgets/social/{$social}.tpl"}
		                    </li>
		                {/foreach}
		                </ul>
		            </div>
		        {/if}
			</div>
			<div class="col-s-4 col-m-4 col-l-6 col-xl-8">
				<div class="panel panel-border">
					<div class="panel-body">

						{*** Start date & time ***}
						<p class="m-calendar-period from-text">
							<strong>{$text.CALENDAR_PERIOD_FROM}:</strong>
						</p>
						<p class="m-calendar-period from-date">
							<span class="startDate">{$text.DATE_THE_C} {$item->DateStart|date_format:$general.dateTimeFormat}</span>
							<meta itemprop="startDate" content="{$item->DateStart}">
						</p>
						<br>

						{*** End date & time ***}
						<p class="m-calendar-period until-text">
							<strong>{$text.CALENDAR_PERIOD_UNTIL}:</strong>
						</p>
						<p class="m-calendar-period until-date">
							<span class="endDate">{$text.DATE_THE_C} {$item->DateEnd|date_format:$general.dateTimeFormat}</span>
							<meta itemprop="endDate" content="{$item->DateEnd}">
						</p>

					</div>
				</div>
				<a class="button m-calendar-anchor back-anchor" href="/{$page["paths"][0]}/">{$text.CALENDAR_BACK_TO_OVERVIEW}</a>
			</div>
		</div>
	</article>
</div>
