{*

# Description
Login widget. A widget is a small helper template, with some functionality.


## Date last modified
2021-07-12


## Primary variables
+ $settings                                                             - Global scope variable containing platform settings
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


<form id="w-login-form" method="post" action="/actions/user/recaptchalogin" autocomplete="off">
    {csrf type="input"}
	{if isset($dataRequest)}
        <input type="hidden" name="goto" value="{$dataRequest}">
    {/if}
    <div class="panel panel-border w-login">
        <div class="panel-heading w-login-form-header w-header">
            <span class="h6 w-login-form-headline w-title">{$text.LOGIN_HEADLINE}</span>
        </div>
        <div class="panel-body">

            <fieldset class="form-group w-userlogin-username">
                <label class="form-label" for="m-login-username">{$text.LOGIN_USER} <span class="form-required">*</span></label>
                <div class="input-group small">
                    <span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="user"}</span>
                    <input id="m-login-username" name="username" type="text" class="form-input small input-group-main" placeholder="{$text.LOGIN_USER}" required>
                </div>
            </fieldset>
            <fieldset class="form-group w-userlogin-password">
                <label class="form-label" for="m-login-password">{$text.LOGIN_PASSWORD} <span class="form-required">*</span></label>
                <div class="input-group small">
                    <span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="lock"}</span>
                    <input id="m-login-password" name="password" type="password" class="form-input small input-group-main" placeholder="{$text.LOGIN_PASSWORD}" required>
                </div>
            </fieldset>
            <fieldset class="form-group w-userlogin-remember">
                <div class="input-group small">
                    <span class="input-group-addon"><input id="m-login-remember" name="auto_login" type="checkbox"></span>
                    <label for="m-login-remember" class="form-label input-group-main">{$text.USER_REMEMBER_LOGIN}</label>
                </div>
            </fieldset>
            <ul class="list-unstyled w-userlogin-links w-links">
                {if $settings.user_password_resend}
                    <li class="w-userlogin-item w-links-userpasswordrecover"><a href="/{$text.SEND_PASSWORD_LINK}/">{$text.SEND_PASSWORD_QUESTION}</a></li>
                {/if}
                {if $access.user && $settings.user_add}
                    <li class="w-userlogin-item w-links-usercreate"><a href="/{$text.USER_ADD_LINK}/">{$text.USER_ADD_MENU}</a></li>
                {/if}
                {if $settings.shop_b2b_customer_approval}
                    <li class="w-userlogin-item w-links-userrequest"><a href="/{$text.USER_ADD_B2B_LINK}/">{$text.USER_ADD_B2B_MENU}</a></li>
                {/if}
            </ul>
            {if $settings.spam_check}
            <div class="m-userlogin-spam-check">
                <hr>
                {include file="modules/widgets/recaptcha/recaptcha.tpl" lazyload=true}
            </div>
            {/if}
        </div>
        <div class="panel-footer">
            {if empty($dataClose) or (!empty($dataClose) and $dataClose)}
                <a href="#" class="form-submit button small" onclick="$.fancybox.close();">{$text.MODAL_CLOSE}</a>
            {/if}
            <button class="form-submit button-primary small" type="submit">{$text.LOGIN_MENU}</button>
        </div>
    </div>
</form>
