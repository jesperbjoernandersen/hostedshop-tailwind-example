{* Breadcrumb module *}
<div class="m-breadcrumb">
	<ul class="nav nav-breadcrumbs small" itemscope itemtype="http://schema.org/BreadcrumbList">
		{foreach $page.breadcrumbs as $key => $breadcrumb}
			<li class="page level-{$key}{if $breadcrumb@last} active is-unclickable{/if}" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
				<a href="{$breadcrumb->path}" itemtype="http://schema.org/Thing" itemprop="item"><span itemprop="name">{$breadcrumb->title}</span></a>
				<meta itemprop="position" content="{$breadcrumb@iteration}">
			</li>
			{if !$breadcrumb@last}
				<li class="seperator">/</li>
			{/if}
		{/foreach}
	</ul>
</div>