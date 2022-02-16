{*

# Description
Template for FormElement entities for the Formbuilder page type


## Date last modified
2015-02-25


## Generated variables
+ $formElementController												- The controller
+ $formElement         													- The collection, var_dump for details


## Partials (templates)
No extra templates required for this template

*}

{*** Set metas array ***}
{$metas = $formElementController->getMeta($formElement->Id)}

{*** Meta name variable for attribute 'name' ***}
{$metaName = $formElement->HtmlId}

{*** View: Radio/Checkbox ***}
{if $formElement->Type eq "radio" or $formElement->Type eq "checkbox"}
	{if isset($metas.choices)}
		<fieldset class="form-group m-form-{$formElement->HtmlId}" {if $formElement->Type eq "checkbox" && count($metas.choices) > 1 && $formElement->Required}data-form='validate'{/if}>
			<label class="form-label">{$metas.label} {if $formElement->Required}<span class="form-required">*</span>{/if}</label>
				{* Send along as empty, of backend validation in case its not overwritten *}
				<input type="hidden" name="{$metaName}">

			{foreach $metas.choices as $metaTitle}
				{* Set propper initial required, handle changes in js *}
				{$shouldRequire = $formElement->Required}
				{if $formElement->Required && $formElement->Type eq "checkbox" && !empty($metas.value.0) && !$metaTitle|in_array:$metas.value}
					{$shouldRequire = false}
				{/if}
			    <label class="input-group trailing">
			        <span class="input-group-addon">
			        	<input class="m-form-input m-form-input-{$metaTitle@index}" {if $shouldRequire}required{/if} name="{$metaName}{if $formElement->Type eq "checkbox"}[]{/if}" type="{$formElement->Type}" value="{$metaTitle|escape:'htmlall'}" {if $metaTitle|in_array:$metas.value}checked{/if}>
			        </span>
			        <div class="form-label input-group-main" >{$metaTitle}</div>
			    </label>
			{/foreach}
		</fieldset>
	{/if}

{*** View: Text, password, mail, input, upload, date ***}
{elseif $formElement->Type eq "input" or $formElement->Type eq "password" or $formElement->Type eq "mail" or $formElement->Type eq "upload" or $formElement->Type eq "date"}
	<fieldset class="form-group m-form-{$formElement->HtmlId}">
	    <label class="form-label" for="m-form-{$formElement->HtmlId}">{$metas.label} {if $formElement->Required eq true}<span class="form-required">*</span>{/if}</label>

		{if $formElement->Type == 'date'}
			<div class="input-group default">
	    	<span class="input-group-addon"><i class="fa fa-fw fa-calendar"></i></span>
	    {/if}
	    <input id="m-form-{$formElement->HtmlId}" type="{if $formElement->Type == 'upload'}file{elseif $formElement->Type == 'input'}text{elseif $formElement->Type == 'mail'}email{else}{$formElement->Type}{/if}" class="form-input default" name="{$formElement->HtmlId}" {if $formElement->Required eq true}required{/if} {if isset($metas.value) && $formElement->Type neq "date"}placeholder="{$metas.value[0]}"{/if} {if $formElement->Type eq "date"}value="{$now|date_format:"Y-m-d"}"{/if}>
		{if $formElement->Type == 'date'}
			</div>
		{/if}
	</fieldset>
{*** View: Time ***}
{elseif $formElement->Type eq "time"}
	<fieldset class="form-group m-form-{$formElement->HtmlId}">
	    <label class="form-label" for="m-form-hours-{$formElement->HtmlId}">{$metas.label} {if $formElement->Required eq true}<span class="form-required">*</span>{/if}</label>

	    <div class="row">
			<div class="col-s-2 col-m-2 col-l-2 col-xl-2">
			    <select id="m-form-hours-{$formElement->HtmlId}" name="{$formElement->HtmlId}[hours]" class="form-input form-select default">
				    {for $hours=0 to 23}
				    	{$hours_show = $hours}
				    	{if $hours|count_characters == 1}
				    		{$hours_show = "0$hours"}
				    	{/if}
				    	<option value="{$hours_show}">{$hours_show}</option>
				    {/for}
				</select>
			</div>
			<div class="col-s-2 col-m-2 col-l-2 col-xl-2">
			    <select id="m-form-minutes-{$formElement->HtmlId}" name="{$formElement->HtmlId}[minutes]" class="form-input form-select default">
				    {for $minutes=0 to 59}
				    	{$minutes_show = $minutes}
				    	{if $minutes|count_characters == 1}
				    		{$minutes_show = "0$minutes"}
				    	{/if}
				    	<option value="{$minutes_show}">{$minutes_show}</option>
				    {/for}
				</select>
			</div>
		</div>
	</fieldset>

{*** View: Textarea ***}
{elseif $formElement->Type eq "textarea"}
	<fieldset class="form-group m-form-{$formElement->HtmlId}">
	    <label class="form-label" for="m-form-{$formElement->HtmlId}">{$metas.label} {if $formElement->Required eq true}<span class="form-required">*</span>{/if}</label>

	    <textarea id="m-form-{$formElement->HtmlId}" name="{$formElement->HtmlId}" class="form-input default" style="min-height: {$formElement->Height}px;" {if $formElement->Required eq true}required{/if}  {if isset($metas.value)}placeholder="{$metas.value[0]}"{/if}></textarea>
	</fieldset>

{*** View: Select ***}
{elseif $formElement->Type eq "combo"}
	<fieldset class="form-group m-form-{$formElement->HtmlId}">
	    <label class="form-label" for="m-form-{$formElement->HtmlId}">{$metas.label} {if $formElement->Required eq true}<span class="form-required">*</span>{/if}</label>

	    <select id="m-form-{$formElement->HtmlId}" name="{$formElement->HtmlId}" class="form-input form-select default" {if $formElement->Required eq true}required{/if}>
			{if isset($metas.choices)}
				{foreach $metas.choices as $metaTitle}
					<option {if $metaTitle|in_array:$metas.value}selected{/if}>{$metaTitle}</option>
				{/foreach}
			{/if}
	    </select>
	</fieldset>

{*** View: Text ***}
{elseif $formElement->Type eq "free"}
	<p class="m-form-{$formElement->Id}">{$formElementController->getTranslation($formElement->Id, "value")}</p>

{*** View: Label + text ***}
{elseif $formElement->Type eq "freelabel"}
	<label class="form-label" for="m-form-{$formElement->Id}">{$metas.label}</label>

	<p class="m-form-{$formElement->Id}">{$formElementController->getTranslation($formElement->Id, "value")}</p>
{/if}
