{*

# Description
Meta widget. Can add seo meta data, link data and open graph meta. A widget is a small helper template, with some functionality.


## Date last modified
2014-10-22


## Primary variables
+ $description                                                          - SEO meta description
+ $keywords                                                             - SEO meta keywords
+ $next                                                                 - SEO rel link next
+ $prev                                                                 - SEO rel link prev
+ $canonical                                                            - SEO meta canonical
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
No extra templates required for this template

*}


{*** Page description ***}
{if isset($description)}
    {addMeta name="description" content=$description|strip_tags|escape:'htmlall'}
{/if}

{*** Page keywords ***}
{if isset($keywords)}
    {addMeta name="keywords" content=$keywords|strip_tags|escape:'htmlall'}
{/if}

{*** SEO canonical link ***}
{if isset($canonical)}
    {if strpos($canonical, "http") !== 0}
        {$canonical=$general.domain|cat:$canonical}
    {/if}
    {addLink rel=canonical href=$canonical|strip_tags|escape:'htmlall' relative=true}
{/if}

{*** SEO rel next ***}
{if isset($next) and !empty($next)}
    {if strpos($next, "http") === false}
        {$next=$general.domain|cat:$next}
    {/if}
    {addLink rel=next href=$next|strip_tags|escape:'htmlall' relative=true}
{/if}

{*** SEO rel next ***}
{if isset($prev) and !empty($prev)}
    {if strpos($prev, "http") === false}
        {$prev=$general.domain|cat:$prev}
    {/if}
    {addLink rel=prev href=$prev|strip_tags|escape:'htmlall' relative=true}
{/if}
