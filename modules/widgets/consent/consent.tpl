{*

# Description
Privacy Policy checkbox widget. Used in multiple forms throughout the template. A widget is a small helper template, with some functionality.


## Date last modified
2018-05-09


## Primary variables
+ $text                                                                 - Global scope variable containing translations
+ $privacyPolicyLink                                                    - Privacy Policy page id, used to create the overlay content

 *}
 
{$box = isset($box)} 
{$widget = isset($widget)} 

{controller assign=pageController type=page}
{* Privacy policy link *}
{$privacyPolicyLink = $settings.link_privacy_policy}
{if $user and $user->IsB2B and $settings.link_privacy_policy_b2b}
    {$privacyPolicyLink = $settings.link_privacy_policy_b2b}
{/if}

<div class="privacyPolicyContainer">
    <fieldset class="form-group">
        <div class="input-group">
            <span class="input-group-addon">
                <input type="checkbox" name="consent" id="acceptPrivacyPolicy{if $box}-box{/if}{if $widget}-widget{/if}" value="1" {if $user->Consent}disabled checked{else}required{/if}/>
            </span>
            <label for="acceptPrivacyPolicy{if $box}-box{/if}{if $widget}-widget{/if}" class="form-label input-group-main">  
                {if $privacyPolicyLink}
                    {$text.ACCEPT_PRIVACY_POLICY_LINK}
                {else}
                    {$text.ACCEPT_PRIVACY_POLICY}
                {/if}
            </label>
        </div>
    </fieldset>
</div>

{if $privacyPolicyLink}
    {include file='modules/widgets/overlay/overlay.tpl' dataId=privacyPolicy dataItemId=$privacyPolicyLink}
{/if}