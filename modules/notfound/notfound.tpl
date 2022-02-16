{*

# Description
Controller for the 404 not found page type


## Date last modified
2020-08-28


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = $text.PAGE_NOT_FOUND}
{$opengraph_description = $text.PAGE_NOT_FOUND_TEXT}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}


<div class="modules m-notfound text-center">
    <article class="m-notfound-article">
        <header class="m-notfound-header page-title">
            <h1 class="m-notfound-headline"><i class="fa fa-fw fa-exclamation-circle"></i> {$text.PAGE_NOT_FOUND}</h1>
		</header>

        <div class="m-notfound-content content">
        	<p>{$text.PAGE_NOT_FOUND_TEXT}</p>

        	<a href="/" title="" class="button-primary default">{$text.GO_TO_FRONTPAGE}</a>
        </div>
    </article>
</div>


{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}