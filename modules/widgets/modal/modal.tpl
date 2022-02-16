{*

# Description
Modal widget. A widget is a small helper template, with some functionality.
The widget is based on Fancybox


## Date last modified
2020-08-28


## Primary variables
+ $dataId  																- No default value, $dataId is required and must be unique
+ $dataRequest															- Default: null
+ $dataClose															- Default: false
+ $dataType  															- No default value, $dataType is required
+ $dataTarget  															- No default value, $data-target is required


## Partials (templates)
+ "/modules/widgets/login/login.tpl"                                    - Login widget, for log in

*}

<div id="modal{$dataId}" class="container" style="display: none;">

	{if !isset($dataType) or !isset($dataId)}
		<label>One or more attributes were not set</label>
		<p>$dataType &amp; $dataId, must be set.</p>
	{else}
		{if $dataType == 'page'}
			{include file="modules/widgets/login/login.tpl" dataClose="true" dataRequest="{$page.request}"}
		{elseif $dataType == 'widget'}
			{include file="modules/widgets/{$dataTarget}/{$dataTarget}.tpl" dataRequest="{$dataRequest}" dataClose="{$dataClose}"}
		{else}
			<label>Incorrect $data-type</label>
			<span>Correct data types</span>
			<ul>
				<li><span>'page'</span></li>
				<li><span>'widget'</span></li>
			</ul>
		{/if}

	{/if}

</div>
