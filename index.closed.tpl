<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		
		<title>{$contactdata.name}</title>

		{*** Charset ***}
		<meta charset="windows-1252">

		{*** Viewport setting for responsive websites ***}
		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		{*** Generator tag ***}
		<meta name="generator" content="{$general.generator}">

		{*** Favicon ***}
		{if isset($template.settings.IMAGE_FAVICON) and !empty($template.settings.IMAGE_FAVICON)}
			<link rel="shortcut icon" href="{$template.settings.IMAGE_FAVICON}" type="image/x-icon" />
		{/if}

		{*** Stylesheets ***}
		<link href="{$template.cdn}{locateFile file='assets/css/template.closed.css'}" type="text/css" rel="stylesheet">
		<link href="{$template.cdn}{locateFile file='assets/css/theme.css'}" type="text/css" rel="stylesheet">
	</head>
	<body>
		<div class="site text-center">
			<header class="site-brand">
				{include file='modules/widgets/logo/logo.tpl'}
			</header>

			<div class="site-content">
				<p>{setting key=frontend_closed_message format=false}</p>
			</div>
		</div>
	</body>
</html>
