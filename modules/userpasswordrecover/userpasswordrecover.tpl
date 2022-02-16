{*

# Description
Controller and template for the User password recovery page type.


## Date last modified
2017-09-15


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/recaptcha/recaptcha.tpl"                			- Recaptcha widget

*}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}


<div class="modules m-userpasswordrecover">
	<article class="m-userpasswordrecover-article">
		<header class="m-userpasswordrecover-header page-title">
			<h1 class="m-userpasswordrecover-headline">{$text.SEND_PASSWORD_HEADLINE}</h1>
		</header>

		<div class="m-userpasswordrecover-description description trailing">
			<p class="m-userpasswordrecover-description">{$text.SEND_PASSWORD_TEXT}</p>
		</div>
		<form id="cuForm" method="post" action="/actions/user/passwordsend">
			{csrf type="input"}
		    <div class="panel panel-border">
		        <div class="panel-body">
		        	<fieldset class="form-group m-userpasswordrecover-username">
		                <label class="form-label" for="m-userpasswordrecover-email">{$text.LOGIN_USER} <span class="form-required">*</span></label>
					    <div class="input-group small">
					        <span class="input-group-addon"><i class="fa fa-user"></i></span>
					        <input id="m-userpasswordrecover-email" name="email" type="email" class="form-input small input-group-main" placeholder="{$text.LOGIN_USER}" required>
					    </div>
					</fieldset>
					{if $settings.spam_check}
					<div class="m-userpasswordrecover-spam-check">
						<hr>
						{include file="modules/widgets/recaptcha/recaptcha.tpl"}
					</div>
    				{/if}
		        </div>
		        <div class="panel-footer">
		            <button class="form-submit {if !empty($modalCallToActionStyle) AND $modalCallToActionStyle eq "primary"}button-primary{else}button{/if} small" type="submit">{$text.SEND}</button>
		        </div>
		    </div>
		</form>
	</article>
</div>
