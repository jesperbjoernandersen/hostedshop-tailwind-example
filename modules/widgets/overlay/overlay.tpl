{*

# Description
Overlay widget. A widget is a small helper template, with some functionality.
The widget is based on Fancybox


## Date last modified
2014-10-22


## Primary variables
+ $dataId  																- No default value, $dataId is required
+ $dataItemId															- No default value, $dataItemId is required
+ $dataType  															- Default: page

*}

{if !isset($dataType)}
	{$dataType = 'page'}
{/if}

<div id="overlay{$dataId}" class="container w-overlay" style="display: none;">

	{if !isset($dataType) or !isset($dataItemId)}
		<label>One or more attributes were not set</label>
		<p>$dataType &amp; $dataId, must be set.</p>
	{else}
		{if $dataType == 'page'}
			{controller assign=pageController type=page}
			<span class="h3">{$pageController->getHeadline($dataItemId)}</span>
			<div>{$pageController->getText($dataItemId)}</div>
		{else}
			<label>Incorrect $data-type</label>
			<span>Correct data types</span>
			<ul class="w-overlay-list-container">
				<li class="w-overlay-list"><span>'page'</span></li>
			</ul>
		{/if}

	{/if}

</div>
