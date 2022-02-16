{*

# Description
Controller for the Media Gallery page type.


## Date last modified
2020-08-28


## Primary variables
+ $category																- Entity of mediaArchiveController (category data)
+ $subCategories														- Collection of mediaArchiveController (list of categories)
+ $mediaArchiveController												- Instance of mediaArchiveController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $boxes                                                    			- Global scope variable containing column boxes
+ $columns                                                  			- Global scope variable containing columns


## Partials (templates)
+ "/modules/gallery/gallery-list.tpl"  									- Partial used to generate a list of media items
+ "/modules/widgets/meta/meta.tpl"                          			- SEO meta and link data
+ "/modules/widgets/meta/opengraph.tpl"                     			- Social meta data

*}


{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{* Define standard class for image items *}
{$mediaImageClass = "col-s-2 col-m-3 col-l-3 col-xl-6"}

{* Define standard class for video items *}
{$mediaVideoClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}

{* Define standard class for pdf and files items *}
{$mediaFileClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}

{* Calculate number of columns media items *}
{if $columns eq 2}
	{* Define standard class for image items *}
	{$mediaImageClass = "col-s-2 col-m-4 col-l-6 col-xl-8"}

	{* Define standard class for video items *}
	{$mediaVideoClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}

	{* Define standard class for pdf and files items *}
	{$mediaFileClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}
{elseif $columns eq 1}
	{* Define standard class for image items *}
	{$mediaImageClass = "col-s-2 col-m-4 col-l-4 col-xl-8"}

	{* Define standard class for video items *}
	{$mediaVideoClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}

	{* Define standard class for pdf and files items *}
	{$mediaFileClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}
{/if}

{* Check the request uri for any additional levels and show the entity template accordingly *}

{if isset($page.paths.1)}
	{entity assign=category controller=mediaArchive primary=true}
	{if $category}
		{collection assign=subCategories controller=mediaArchive parentId=$category->Id}
	    {addBreadCrumb title=$category->Title path=$category->Handle defaultPath=true}
	{else}
		{notfound}
	{/if}
{* If no extra request uri was found, show the entire list of forum items for this page *}
{else}
	{$category = null}
	{collection assign=subCategories controller=mediaArchive parentId=0}
{* End of controller *}
{/if}

{include file='modules/gallery/gallery-list.tpl' category=$category subCategories=$subCategories mediaVideoClass=$mediaVideoClass mediaImageClass=$mediaImageClass mediaFileClass=$mediaFileClass}

{*** Open Graph ***}
{if isset($category)}
	{$opengraph_title = $category->Title}
	{controller assign=mediaArchiveController type=mediaArchive}
	{$opengraph_description = $mediaArchiveController->getDescription($category->Id)}
{/if}

{if empty($opengraph_description)}
	{$opengraph_description = {translation module=seo_page title=description id=$page.id}}
{/if}

{if empty($opengraph_description)}
	{$opengraph_description = $text.MEDIA_ARCHIVE_CATEGORY_TEXT}
{/if}

{if empty($opengraph_title)}
	{$opengraph_title = {translation module=seo_page title=title id=$page.id}}
{/if}

{if empty($opengraph_title)}
	{$opengraph_title = $page.headline}
{/if}

{$opengraph_description = $opengraph_description|truncate:160}

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
