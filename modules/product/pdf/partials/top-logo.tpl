{*

# Description
Prints out the company logo

## Date last modified
2021-08-24

*}
<style>
	.logo {
		width: 100%
	}
	.logo img {
		max-height: 120px;
	}
</style>
<div class="logo">
	{if $template.settings.LOGO_TYPE eq 'PICTURE' and !empty($template.settings.LOGO_SOURCE_NEGATIVE)}
		<img class="logo-image" src="{$template.settings.LOGO_SOURCE_NEGATIVE|solutionPath}" alt="{$contactdata.name}">
	{else}
		<h1 class="logo-text">{$contactdata.name}</h1>
	{/if}
</div>
