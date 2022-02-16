{*

# Description
Template for Newsletter signup consent


## Date last modified
2018-04-30


## Primary variables
+ $text                                                     - Global scope variable containing translations
+ $description                                              - Variable for storing whether we should display newsletter consent description. Possible values: true, false


## Partials (templates)
No extra templates required for this template

*}

{$box = isset($box)}
{$widget = isset($widget)}
{$showDescription = isset($description)}

{$input = "name='type' value='1'"}
{if $page.isUserEdit || $page.isUserCreate || $page.isUserRequest}
	{$input = "name='newsletter'"}
{/if}

{$checked = "{if isset($returnPostData.newsletter) and $returnPostData.newsletter}checked='true'{/if}"}
{if $page.isUserEdit}
	{$checked = "{if $user->Newsletter}checked='checked'{/if}"}
{/if}

{if $page.isNewsletter && !$widget}
	<input type="hidden" name="type" value='1'>		
{else}
	<input type="hidden" name="type" value='0'>	
	<div class="w-newsletter-type">
		{if $showDescription}
		<div class="w-newsletter-type-description description trailing">		
			<label class="form-label">{$text.NEWSLETTER_TYPE_HEADLINE} <i class="fa fa-question-circle tooltip"><span class="tooltiptext">{if $general.isShop}{$text.NEWSLETTER_TYPE_DESCRIPTION_SHOP}{else}{$text.NEWSLETTER_TYPE_DESCRIPTION_CMS}{/if}</span></i></label>
			<p class="w-newsletter-type-text">{if $general.isShop}{$text.NEWSLETTER_TYPE_TEXT_SHOP}{else}{$text.NEWSLETTER_TYPE_TEXT_CMS}{/if}</p>	
		</div>
		{/if}
		<fieldset class="form-group m-newsletter-signup">
		    <div class="input-group">
		        <span class="input-group-addon">
		        	<input id="m-newsletter-signup{if $box}-box{/if}{if $widget}-widget{/if}" type="checkbox" {$input} {$checked}> 
		        </span>
		        <label for="m-newsletter-signup{if $box}-box{/if}{if $widget}-widget{/if}" class="form-label input-group-main">{$text.NEWSLETTER_TYPE_LABEL} {if $box || $widget}<i class="fa fa-question-circle tooltip"><span class="tooltiptext">{if $general.isShop}{$text.NEWSLETTER_TYPE_DESCRIPTION_SHOP}{else}{$text.NEWSLETTER_TYPE_DESCRIPTION_CMS}{/if}</span></i>{/if}</label>
		    </div>
		</fieldset>
	</div>	
{/if}