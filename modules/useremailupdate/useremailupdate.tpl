{*

# Description
Controller and template for the User Email Change page type


## Date last modified
2017-05-19


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


<div class="modules m-useremailupdate">
	<article class="m-useremailupdate-article">
		<header class="m-useremailupdate-header page-title">
			<h1 class="m-useremailupdate-headline">{$text.USER_UPDATE_EMAIL_HEADLINE}</h1>
		</header>

		<div class="m-useremailupdate-description description trailing">
			<p class="m-useremailupdate-description">{$text.USER_UPDATE_EMAIL_TEXT}. {$text.USER_ADD_REQUIRED_FIELDS}.</p>
		</div>

		<form id="m-useremailupdate" method="post" action="/actions/user/editemail">
            {csrf type="input"}
			<div class="panel panel-border">
    			<div class="panel-body">
    				<div class="row">
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

    						<fieldset class="form-group m-useremailupdate-email">
					        	<label class="form-label" for="m-useremailupdate-email">{$text.MAIL} <span class="form-required">*</span></label>
								<input id="m-useremailupdate-email" name="email" type="text" class="form-input small" placeholder="{$text.MAIL}" required>
							</fieldset>

    					</div>
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

							<fieldset class="form-group m-useremailupdate-password">
					        	<label class="form-label" for="m-useremailupdate-password">{$text.PASSWORD} <span class="form-required">*</span></label>
								<input id="m-useremailupdate-password" name="password" type="password" class="form-input small" placeholder="{$text.PASSWORD}" required>
							</fieldset>
							<fieldset class="form-group m-useremailupdate-passwordconf">
					        	<label class="form-label" for="m-useremailupdate-passwordconf">{$text.PASSWORD_CONFIRM} <span class="form-required">*</span></label>
								<input id="m-useremailupdate-passwordconf" name="passwordConfirm" type="password" class="form-input small" placeholder="{$text.PASSWORD_CONFIRM}" required>
							</fieldset>

						</div>
					</div>
    			</div>
    			<div class="panel-footer">
    				<button name="submit" type="submit" class="button small">{$text.SAVE}</button>
    			</div>
			</div>
		</form>
	</article>
</div>
