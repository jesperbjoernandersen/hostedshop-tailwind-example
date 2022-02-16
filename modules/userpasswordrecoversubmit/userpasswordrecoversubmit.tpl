{*

# Description
Controller and template for the User Password Recover Submit page type.


## Date last modified
2017-05-19


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


<div class="modules m-userpasswordrecoversubmit">
	<article class="m-userpasswordrecoversubmit-article">
		<header class="m-userpasswordrecoversubmit-header page-title">
			<h1 class="m-userpasswordrecoversubmit-headline">{$text.USER_UPDATE_PASSWORD_HEADLINE}</h1>
		</header>

		<div class="m-userpasswordrecoversubmit-description description trailing">
			<p class="m-userpasswordrecoversubmit-description">{$text.USER_UPDATE_PASSWORD_TEXT}. {$text.USER_ADD_REQUIRED_FIELDS}.</p>
		</div>

		<form class="m-userpasswordrecoversubmit-form" method="post" action="/actions/user/passwordrecoversubmit">
			{csrf type="input"}
			<input type="hidden" name="code" value="{$smarty.get.code|htmlspecialchars}">
			<div class="panel panel-border">
				<div class="panel-body">
					<div class="row">
						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
							<fieldset class="form-group m-userpasswordrecoversubmit-passwordnew">
								<label class="form-label" for="m-userpasswordrecoversubmit-passwordnew">{$text.USER_UPDATE_PASSWORD_NEW} <span class="form-required">*</span></label>
								<input id="m-userpasswordrecoversubmit-passwordnew" name="password" type="password" class="form-input small" placeholder="{$text.USER_UPDATE_PASSWORD_NEW}" required>
							</fieldset>
						</div>
						<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
							<fieldset class="form-group m-userpasswordrecoversubmit-passwordnewconf">
								<label class="form-label" for="m-userpasswordrecoversubmit-passwordnewconf">{$text.USER_UPDATE_PASSWORD_NEW_CONFIRM} <span class="form-required">*</span></label>
								<input id="m-userpasswordrecoversubmit-passwordnewconf" name="passwordConfirmation" type="password" class="form-input small" placeholder="{$text.USER_UPDATE_PASSWORD_NEW_CONFIRM}" required>
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
