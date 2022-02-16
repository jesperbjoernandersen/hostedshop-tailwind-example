{*

# Description
Controller for the Calendar page type, manages entities and collections of events.


## Date last modified
2020-08-28 


## Primary variables
+ $eventcontroller                                                      - Instance of eventController
+ $events                                                               - Collection of events (a list of events)
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/calendar/calendar-event.tpl"                                - Single event
+ "/modules/calendar/calendar-list.tpl"                                 - List of events
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}

{*** Global widgets defaults ***}
{$prev = null}
{$next = null}

{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{* Current date *}
{$year = date('Y')}
{$month = date('n')}
{$day = null}

{*** Event controller also controls the url ***}
{controller type=event assign=eventController primary=true}

{*** Collection of events ***}
{collection assign=events controller=$eventController year=$year month=$month}

{* Check the request uri for any additional levels and show the entity template accordingly *}
{if isset($page.paths.1)}
    {$dateStr = explode('-', $page.paths.1)}
    {$year = $dateStr[0]}
    {$month = $dateStr[1]}
    {$day = null}
    {if $dateStr|count gt 2}
        {$day = $dateStr[2]}
    {/if}
{/if}


{if isset($page.paths.2)}
    {if $events->getActualSize() gt 0}
        {$event = $events->getData()}
        {* Breadcrumb *}
        {addBreadCrumb title=$event[0]->Title defaultPath=true}
        {include file='modules/calendar/calendar-entity.tpl' controller=$eventController item=$event[0] year=(int)$year month=(int)$month day=(int)$day}
    {else}
        {notfound}
    {/if}
{else}
    {addBreadCrumb title="{$month|formatMonth} {$year}" defaultPath=true}

    {* Prev month link *}
    {$linkPrevMonth = $month-1}
    {$linkPrevYear = $year}

    {if $linkPrevMonth lt 1}
        {$linkPrevMonth = '12'}
        {$linkPrevYear = $linkPrevYear-1}
    {/if}

    {* Next month link *}
    {$linkNextMonth = $month+1}
    {$linkNextYear = $year}

    {if $linkNextMonth gt 12}
        {$linkNextMonth = '1'}
        {$linkNextYear = $linkNextYear+1}
    {/if}
    {$pageLink = {page id=$page.id print=Link}}

    {$prev = "{$general.domain}/{$pageLink}/{$linkPrevYear}-{$linkPrevMonth}/"}
    {$next = "{$general.domain}/{$pageLink}/{$linkNextYear}-{$linkNextMonth}/"}

    {include file='modules/calendar/calendar-list.tpl' controller=$eventController items=$events year=(int)$year month=(int)$month day=(int)$day}
{/if}

{*** Global widgets ***}
{pageInclude file="modules/widgets/meta/meta.tpl" prev=$prev next=$next}
{pageInclude file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
