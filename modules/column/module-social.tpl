{*

# Description
Template for Social Media in a column box


## Date last modified
2014-08-01


## Primary variables
+ $box                                                    	- The box to be displayed
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/social/facebook.tpl"					- Facebook social widget, for displaying different Facebook elements
+ "/modules/widgets/social/twitter.tpl"						- Twitter social widget, for displaying different Twitter elements
+ "/modules/widgets/social/google.tpl"						- Google social  widget, for displaying different Google+ elements

*}

<div class="panel panel-border column-box b-social">
	<div class="panel-heading b-social-header b-header">
		<span class="h5">
			{if $box->TypeId == 16}
				{$text.SOCIAL_BOX_FACEBOOK}
			{elseif $box->TypeId == 17}
				{$text.SOCIAL_BOX_TWITTER}
			{elseif $box->TypeId == 18}
				{$text.SOCIAL_BOX_GOOGLE}
			{/if}
		</span>
	</div>
	<div class="panel-body">
		{if $box->TypeId == 16}
			{if $settings.social_plugin_likebox_pageurl}
       			{include file="modules/widgets/social/facebook.tpl" widgetSettings=["follow"=>true, "page"=>{$settings.social_plugin_likebox_pageurl}]}
       		{else}
       			{include file="modules/widgets/social/facebook.tpl"}
       		{/if}
		{elseif $box->TypeId == 17}
			{include file="modules/widgets/social/twitter.tpl" widgetSettings=["follow"=>true, "page"=>{$settings.social_twitter_pageurl}]}
		{elseif $box->TypeId == 18}
			{include file="modules/widgets/social/google.tpl" widgetSettings=["follow"=>true, "page"=>{$settings.social_google_pageurl}]}
		{/if}
	</div>
</div>
