{*

# Description
Template for Search in a column box


## Date last modified
2014-08-01


## Primary variables
+ $page 																- Global scope variable containing all information about the page type

## Partials (templates)
No extra templates required for this template

*}

{$productLink = {page id=$page.productPageId print=Link}}

<div class="panel panel-border column-box b-search">
	<form method="get" action="/{if {$general.isShop} == '1'}{$productLink}{else}{$text.SEARCH_LINK}{/if}/">

		<div class="panel-heading b-search-header b-header">
			<span class="h5">{$text.SEARCH_LONG}</span>
		</div>
	    <div class="panel-body">
	    	<div class="input-group xsmall">
	    		<input type="text" class="form-input small" placeholder="{$text.SEARCH_TEXT}" name="search" required>
				<span class="input-group-button"><button class="button" type="submit">{$text.SEARCH}</button></span>
	    	</div>
	    </div>
	</form>
</div>
