{*

# Description
Controller and template for the User Password Change page type.


## Date last modified
2017-05-19


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


<div class="modules m-userpasswordupdate">
	<article class="m-userpasswordupdate-article">
		<header class="m-userpasswordupdate-header page-title">
			<h1 class="m-userpasswordupdate-headline">{$text.USER_UPDATE_PASSWORD_HEADLINE}</h1>
		</header>

		<div class="m-userpasswordupdate-description description trailing">
			<p class="m-userpasswordupdate-description">{$text.USER_UPDATE_PASSWORD_TEXT}. {$text.USER_ADD_REQUIRED_FIELDS}.</p>
		</div>

		<form id="cuForm" method="post" action="/actions/user/editpassword">
            {csrf type="input"}
			<div class="panel panel-border">
    			<div class="panel-body">
    				<div class="row">
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

    						<fieldset class="form-group m-userpasswordupdate-passwordold">
					        	<label class="form-label" for="m-userpasswordupdate-passwordold">{$text.USER_UPDATE_PASSWORD_PRESENT} <span class="form-required">*</span></label>
								<input id="m-userpasswordupdate-passwordold" name="passwordOld" type="password" class="form-input small" placeholder="{$text.USER_UPDATE_PASSWORD_PRESENT}" required>
							</fieldset>

    					</div>
    					<div class="col-s-4 col-m-6 col-l-6 col-xl-12">

							<fieldset class="form-group m-userpasswordupdate-passwordnew">
					        	<label class="form-label" for="m-userpasswordupdate-passwordnew">{$text.USER_UPDATE_PASSWORD_NEW} <span class="form-required">*</span></label>
								<input id="m-userpasswordupdate-passwordnew" name="passwordNew" type="password" class="form-input small" placeholder="{$text.USER_UPDATE_PASSWORD_NEW}" required>
							</fieldset>
							<fieldset class="form-group m-userpasswordupdate-passwordnewconf">
					        	<label class="form-label" for="m-userpasswordupdate-passwordnewconf">{$text.USER_UPDATE_PASSWORD_NEW_CONFIRM} <span class="form-required">*</span></label>
								<input id="m-userpasswordupdate-passwordnewconf" name="passwordNewConfirm" type="password" class="form-input small" placeholder="{$text.USER_UPDATE_PASSWORD_NEW_CONFIRM}" required>
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
