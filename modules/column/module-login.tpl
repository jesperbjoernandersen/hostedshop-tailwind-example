{*

# Description
Template for User login in a column box


## Date last modified
2021-07-12


## Primary variables
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}
{if $settings.shop_b2b_customer_approval || $settings.user_add}    
    <div class="panel panel-border column-box b-userlogin">
        {if !$user}
            <form id="b-login-form" method="post" action="/actions/user/recaptchalogin" autocomplete="off">
                {csrf type="input"}
                <div class="panel-heading b-userlogin-header b-header">
                    <span class="h5">{$text.LOGIN_HEADLINE}</span>
                </div>
                <div class="panel-body b-userlogin-content">
                    <fieldset class="form-group b-userlogin-username">
                        <div class="input-group small">
                            <span class="input-group-addon"><i class="fa fa-fw fa-user"></i></span>
                            <input id="c-login-username" name="username" type="text" class="form-input small input-group-main" placeholder="{$text.LOGIN_USER}" required>
                        </div>
                    </fieldset>
                    <fieldset class="form-group b-userlogin-password">
                        <div class="input-group small">
                            <span class="input-group-addon"><i class="fa fa-fw fa-key"></i></span>
                            <input id="c-login-password" name="password" type="password" class="form-input small input-group-main" placeholder="{$text.LOGIN_PASSWORD}" required>
                        </div>
                    </fieldset>
                    <fieldset class="form-group b-userlogin-checkbox">
                        <div class="input-group small">
                            <span class="input-group-addon"><input id="c-login-remember" name="auto_login" type="checkbox"></span>
                            <label for="c-login-remember" class="form-label input-group-main">{$text.USER_REMEMBER_LOGIN}</label>
                        </div>
                    </fieldset>
                    <ul class="list-unstyled b-userlogin-links b-links">
                        {if $settings.user_password_resend}
                            <li class="b-userlogin-item b-links-userpasswordrecover"><a href="/{$text.SEND_PASSWORD_LINK}/" title="{$text.SEND_PASSWORD_QUESTION}">{$text.SEND_PASSWORD_QUESTION}</a></li>
                        {/if}
                        {if $access.user && $settings.user_add}
                            <li class="b-userlogin-item b-links-usercreate"><a href="/{$text.USER_ADD_LINK}/" title="{$text.USER_ADD_MENU}">{$text.USER_ADD_MENU}</a></li>
                        {/if}
                        {if $settings.shop_b2b_customer_approval}
                            <li class="m-userlogin-item m-links-userrequest"><a href="/{$text.USER_ADD_B2B_LINK}/" title="{$text.USER_ADD_B2B_MENU}">{$text.USER_ADD_B2B_MENU}</a></li>
                        {/if}
                    </ul>
                    {if $settings.spam_check}
                    <div class="m-userlogin-spam-check">
                        <hr role="separator">
                        {include file="modules/widgets/recaptcha/recaptcha.tpl" lazyload=true}
                    </div>
                    {/if}
                </div>
                <div class="panel-footer">
                    <button class="form-submit button small" type="submit">{$text.LOGIN_MENU}</button>
                </div>
            </form>

        {else}

            <div class="panel-heading b-userlogin-header b-header">
                <span class="h5">{$text.YOUR_ACCOUNT}</span>
            </div>
            <div class="panel-body b-userlogin-content">
                <ul class="list-unstyled b-userlogin-links b-links">
                    {if $general.isShop}
                    <li class="b-userlogin-item b-links-userorders"><a href="/{$text.MY_ORDERS_LINK}/" title="{$text.MY_ORDERS_MENU}">{$text.MY_ORDERS_MENU}</a></li>
                    {/if}
                    {if $settings.module_shop_wishlist and $access.wishlist}
                    <li class="b-userlogin-item b-links-userwishlist"><a href="/{$text.WISHLIST_LINK}/" title="{$text.WISHLIST_MENU}">{$text.WISHLIST_MENU}</a></li>
                    {/if}
                    <li class="m-userlogin-item m-links-useredit"><a href="/{$text.USER_UPDATE_LINK}/" title="{$text.USER_UPDATE_MENU}">{$text.USER_UPDATE_MENU}</a></li>
                    <li class="m-userlogin-item m-links-userlogout"><a href="/actions/user/logout?{csrf type='get'}" title="{$text.LOGOUT_HEADLINE}">{$text.LOGOUT_HEADLINE}</a></li>
                </ul>
            </div>
        {/if}
    </div>
{/if}
