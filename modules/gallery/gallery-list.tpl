{*

# Description
Template partial for the media gallery list.


## Date last modified
2021-06-18


## Primary variables
+ $category																- Entity of mediaArchiveController (category data)
+ $subCategories														- Collection of mediaArchiveController (list of categories)
+ $mediaArchiveController												- Instance of mediaArchiveController
+ $mediaVideoClass														- String with the CSS class to define width depending on column boxes
+ $mediaImageClass														- String with the CSS class to define width depending on column boxes
+ $mediaFileClass														- String with the CSS class to define width depending on column boxes


## Partials (templates)
No extra templates required for this template

*}

{* Image size *}
{$imageWidth = 385}
{$imageHeight = 385}
{$crop = "fill"}
{if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
	{$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
{/if}

{* Pagination settings *}
{$pager = true}
{$pageSize = 100}
{$pageGetParam = "filesPage"}

{$hasSubcategories = !empty($subCategories) and $subCategories->getActualSize() gt 0}

{*

# Descrition
Helper functions for printing out sub categories and its children


## Resource
+ [Smarty functions](http://www.smarty.net/docs/en/language.function.function.tpl)

*}
{placeholdImage assign=placeholder width=$imageWidth height=$imageHeight background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}
{placeholdImage assign=placeholderFiles width=$imageWidth height=$imageHeight background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.FILES}

{function subCategory parent=null categoryId=null controller=null}
	{if $categoryId eq $parent or $parent eq 0}
		<div class="{$mediaImageClass} m-gallery-item trailing-trip" data-mh="gallery-item" itemscope itemtype="http://schema.org/CollectionPage">
			{controller assign=subCategoryController type=mediaArchive}
			{entity assign=image controller=files id=$subCategory->Id type=media strictly=image}
			{collection assign=subFiles controller=files id=$subCategory->Id type=media}
			{$categoryLink = "/{$page.paths[0]}/{$subCategory->Handle}/"}
			<div class="m-gallery-item-image">
				<a href="{$categoryLink}" title="{$subCategory->Title}" class="placeholder-wrapper" data-placeholder-max-width="{$imageWidth}px">
					<span class="placeholder"></span>
					{if $image}
						{$imageUrl = $image->thumbnail($imageWidth, $imageHeight, $crop, $template.watermark)}
						{if $image->isSecure()}
							{$imageUrl = $image->getSecureFile($page.id, $imageUrl)}
						{else}
							{$imageUrl = {$template.cdn|cat:$imageUrl}}
						{/if}
						{img alt="{$subCategory->Title}" src="{$imageUrl}" class="responsive"}
					{elseif $subFiles->getActualSize() gt 0}
						<img alt="{$subCategory->Title}" src="{$placeholderFiles->thumbnail(null, null, false, $template.watermark)|solutionPath}" class="responsive">
					{else}
						<img alt="{$subCategory->Title}" src="{$placeholder->thumbnail(null, null, false, $template.watermark)|solutionPath}" class="responsive">
					{/if}
				</a>
			</div>
			<div class="m-gallery-item-title">
				<a href="{$categoryLink}" title="{$subCategory->Title}" itemprop="url"><span itemprop="headline">{$subCategory->Title}</span></a>
			</div>
			<div class="m-gallery-item-description" itemprop="description">
				{$subCategoryController->getDescription($subCategory->Id)|strip_tags|truncate:60}
			</div>
			<div class="m-gallery-item-files">
				<span class="m-gallery-item-files-count">{$subFiles->getActualSize()}</span> <span class="m-gallery-item-files-text">{$text.MEDIA_ARCHIVE_PICTURES}</span>
			</div>
		</div>
	{/if}
{/function}

<div class="modules m-gallery" itemscope itemtype="http://schema.org/CollectionPage">
	<article class="m-gallery-article">
		<header class="m-gallery-header page-title">
			<h1 class="m-gallery-headline" itemprop="headline">{if isset($category)}{$category->Title}{else}{$page.headline}{/if}</h1>
		</header>

		{if isset($category)}
			<div class="m-gallery-category">
				{controller assign=mediaArchiveController type=mediaArchive}
				<div class="m-gallery-description description trailing-db" itemprop="description">
					{$mediaArchiveController->getDescription($category->Id)}
				</div>

		        {* Include social media *}
		        {if $settings.social_facebook or $settings.social_twitter}
			        <div class="m-gallery-social">
			            <div class="row">
			                <ul class="m-widgets w-social list-inline">
							{foreach ["twitter","facebook"] as $social}
			                    <li class="w-social-item w-social-{$social}">
			                        {include file="modules/widgets/social/{$social}.tpl"}
			                    </li>
			                {/foreach}
			                </ul>
			            </div>
			        </div>
		        {/if}
			</div>
			<hr>
		{/if}
		{if $hasSubcategories}
			<p class="m-gallery-sub-category-text">{$text.MEDIA_ARCHIVE_CATEGORY_TEXT}</p>

			<hr>
			{if isset($category->Id)}
				{$catId = $category->Id}
			{else}
				{$catId = null}
			{/if}
			<div class="row">
				{foreach $subCategories->getData() as $subCategory}
					{if $subCategory->Status eq true}
						{subCategory subCategory=$subCategory parent=$subCategory->ParentId categoryId=$catId controller=$category}
					{/if}
				{/foreach}
			</div>
			<hr>
			<div class="triling-db">&nbsp;</div>
		{elseif !isset($category)}
			<p class="m-gallery-category-none">{$text.GALLERY_CATEGORY_NONE}</p>
		{/if}
		{if isset($category)}

			{if isset($smarty.get[$pageGetParam])}
				{collection assign=files controller=files id=$category->Id type=media pageSize=$pageSize page=$smarty.get[$pageGetParam]}
			{else}
				{collection assign=files controller=files id=$category->Id type=media pageSize=$pageSize}
			{/if}

			{$collectionSize = $files->getActualSize()}

			{if $collectionSize gt 0}
				{$groups = $files->groupBy(
					'FileType',
					[
						'sound' => 'video',
						'pdf' => 'document'
					])}
				{if isset($groups["youtube"])}
					<p class="m-gallery-header-youtube"><span class="h6">{$text.MEDIA_ARCHIVE_YOUTUBE_HEADER}</span></p>
					<div class="row">
						{foreach $groups['youtube'] as $youtube key=i}
							<div class="{$mediaImageClass}">
								<div class="m-gallery-content-youtube" data-mh="gallery-youtube">
									<a href="https://www.youtube.com/watch?v={$youtube->getRelativeFile()}" data-fancybox data-fancybox-group="m-gallery" data-fancybox-title="<strong>{$mediaArchiveController->getItemTitle($youtube->Id)}</strong> <p>{$mediaArchiveController->getItemDescription($youtube->Id)|strip_tags}</p>" title="{$mediaArchiveController->getItemTitle($youtube->Id)} - {$mediaArchiveController->getItemDescription($youtube->Id)|strip_tags}">
										{img src="https://img.youtube.com/vi/{$youtube->getRelativeFile()}/0.jpg" class="responsive" alt="{$mediaArchiveController->getItemTitle($youtube->Id)}"}
									</a>
									<a href="https://www.youtube.com/watch?v={$youtube->getRelativeFile()}" data-fancybox><span class="is-block">{$mediaArchiveController->getItemTitle($youtube->Id)}</span></a>
									<p>{$mediaArchiveController->getItemDescription($youtube->Id)}</p>
								</div>
							</div>
						{/foreach}
					</div>
					<hr>
					<div class="triling-db">&nbsp;</div>
				{/if}
				{if isset($groups["image"])}
					<p class="m-gallery-header-image"><span class="h6">{$text.MEDIA_ARCHIVE_IMAGE_HEADER}</span></p>
					<div class="row">
						{foreach $groups.image as $image}
							{$imageUrl = $image->thumbnail(null, null, false, $template.watermark)}
							{$thumbnail = $image->thumbnail($imageWidth, $imageHeight, $crop, $template.watermark)}
							{if $image->isSecure()}
								{$imageUrl = $image->getSecureFile($page.id, $imageUrl)}
								{$thumbnail = $image->getSecureFile($page.id, $thumbnail)}
							{else}
								{$imageUrl = {$template.cdn|cat:$imageUrl}}
								{$thumbnail = {$template.cdn|cat:$thumbnail}}
							{/if}
							<div class="{$mediaImageClass}">
								<div class="m-gallery-content-image" data-mh="gallery-image">
									<a href="{$imageUrl}" class="placeholder-wrapper" data-placeholder-max-width="{$imageWidth}px" data-fancybox data-fancybox-group="m-gallery" data-fancybox-title="<strong>{$mediaArchiveController->getItemTitle($image->Id)}</strong> <p>{$mediaArchiveController->getItemDescription($image->Id)|strip_tags}</p>" title="{$mediaArchiveController->getItemTitle($image->Id)} - {$mediaArchiveController->getItemDescription($image->Id)|strip_tags}">
										<span class="placeholder"></span>
										{img src="{$thumbnail}" class="responsive" alt="{$mediaArchiveController->getItemTitle($image->Id)}"}
									</a>
									<span class="is-block">{$mediaArchiveController->getItemTitle($image->Id)}</span>
									<p>{$mediaArchiveController->getItemDescription($image->Id)}</p>
								</div>
							</div>
						{/foreach}
					</div>
					<hr>
					<div class="triling-db">&nbsp;</div>
				{/if}
				{if isset($groups["video"])}
					<p class="m-gallery-header-video"><span class="h6">{$text.MEDIA_ARCHIVE_AUDIOVIDEO_HEADER}</span></p>
					<div class="row">
						<div class="{$mediaVideoClass}">
							<div class="m-gallery-content-video responsive-table-wrap">
								<table class="table-h-striped">
									<thead>
										<tr>
											<th>{$text.MEDIA_ARCHIVE_DOCUMENT_TITLE}</th>
											<th>{$text.MEDIA_ARCHIVE_DOCUMENT_TYPE}</th>
											<th>{$text.MEDIA_ARCHIVE_DOCUMENT_SIZE}</th>
											<th>{$text.DOWNLOAD}</th>
										</tr>
									</thead>
									<tbody>
									{foreach $groups['video'] as $video}
										{if $video->isSecure()}
											{$videoUrl = $video->getSecureFile($page.id)}
										{else}
											{$videoUrl = $video->getRelativeFile()}
										{/if}
										<tr>
											<td>
												<span>
													{if $mediaArchiveController->getItemTitle($video->Id)}
														{$mediaArchiveController->getItemTitle($video->Id)}
													{else}
														{$video->Filename}
													{/if}
												</span>
												<p>{$mediaArchiveController->getItemDescription($video->Id)}</p>
											</td>
											<td>{$video->FileType}</td>
											<td>
												{$video->getSize()|filesize}
											</td>
											<td><a href="{$videoUrl}" title="{$text.DOWNLOAD}" target="_blank">{$text.DOWNLOAD}</a></td>
										</tr>
									{/foreach}
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<hr>
					<div class="triling-db">&nbsp;</div>
				{/if}
				{if isset($groups["document"])}
					<p class="m-gallery-header-document"><span class="h6">{$text.MEDIA_ARCHIVE_DOCUMENT_HEADER}</span></p>
					<div class="row">
						<div class="{$mediaFileClass}">
							<div class="m-gallery-content-document responsive-table-wrap">
								<table class="table-h-striped">
									<thead>
										<tr>
											<th>{$text.MEDIA_ARCHIVE_DOCUMENT_TITLE}</th>
											<th>{$text.MEDIA_ARCHIVE_DOCUMENT_TYPE}</th>
											<th>{$text.MEDIA_ARCHIVE_DOCUMENT_SIZE}</th>
											<th>{$text.DOWNLOAD}</th>
										</tr>
									</thead>
									<tbody>
									{foreach $groups['document'] as $document}
										{if $document->isSecure()}
											{$documentUrl = $document->getSecureFile($page.id)}
										{else}
											{$documentUrl = $document->getRelativeFile()}
										{/if}
										<tr>
											<td>
												<span>
													{if $mediaArchiveController->getItemTitle($document->Id)}
														{$mediaArchiveController->getItemTitle($document->Id)}
													{else}
														{$document->Filename}
													{/if}
												</span>
												<p>{$mediaArchiveController->getItemDescription($document->Id)}</p>
											</td>
											<td>{$document->FileType}</td>
											<td>
												{$document->getSize()|filesize}
											</td>
											<td><a href="{$documentUrl}" title="{$text.DOWNLOAD}" target="_blank">{$text.DOWNLOAD}</a></td>
										</tr>
									{/foreach}
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<hr>
					<div class="triling-db">&nbsp;</div>
				{/if}

			    {*** Pagination for the list if enabled ***}
			    {if (!isset($pager) or !!$pager)}
			        <div class="m-blog-list-pagination">
			            {include file='modules/widgets/pagination/pagination.tpl' pageSize=$pageSize size=$collectionSize pageParam=$pageGetParam}
			        </div>
			    {/if}

			{elseif !$hasSubcategories}
		        <div class="panel panel-warning">
		            <div class="panel-body">
		               <span>{$text.MEDIA_ARCHIVE_CATEGORY_NONE}</span>
		            </div>
		        </div>
			{/if}
		{/if}
	</article>
</div>
