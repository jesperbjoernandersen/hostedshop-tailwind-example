{*

# Description
Template partial for the sitemap sitemap overview. Part of the Sitemap page type.


# Date last modified
2017-05-19


## Primary variables
+ $sitemapMenu                                                          - Output of the menu function
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{function name=printSitemapMenu nested=false}
<ul class="m-sitemap-page m-links fa-ul{if isset($classes)} {$classes}{/if}">
	{foreach $items as $item}
		{$hasChildren = !empty($item["children"])}
		<li class="m-sitemap-page-item m-links-page">
			<i class="fa-li fa {if $nested or !$hasChildren}fa-file-o{else}fa-folder-open-o{/if}"></i>
			<a href="{$item.handle|formatUrl}" title="{$item.title}"{if !empty($item.target)} target="{$item.target}"{/if}><span>{$item.title}</span></a>

			{if $hasChildren}
				{call name=printSitemapMenu items=$item.children classes="m-links-sub" nested=true}
			{/if}
		</li>
	{/foreach}
</ul>
{/function}

<div class="modules m-sitemap-page">
	<article class="m-sitemap-page-article">
		<header class="m-sitemap-page-header page-title">
			<h1 class="m-sitemap-page-headline">{$text.SITEMAP_HEADLINE}</h1>
		</header>

		<div class="m-sitemap-page-content content">
			{$static = false}
			{if $template.settings.SETTINGS_SHOW_MY_ACCOUNT}
				{$static = true}
			{/if}
			{menu assign=sitemapMenu static=$static}
			{call name=printSitemapMenu items=$sitemapMenu}
		</div>
	</article>
</div>
