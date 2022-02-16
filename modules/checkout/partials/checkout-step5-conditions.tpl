{controller assign=pageController type=page}
{$termsLink = $settings.link_terms_and_conditions}
{if $user and $user->IsB2B and $settings.link_terms_and_conditions_b2b}
    {$termsLink = $settings.link_terms_and_conditions_b2b}
{/if}

{if !isset($repay)}
    {$repay = false}
{/if}

<div class="conditions">
    <div class="termsAndConditionsContainer">
        <fieldset class="form-group">
            <div class="input-group">
                <span class="input-group-addon">
                    <input type="checkbox" name="acceptTerms" class="radiobtn" id="acceptTerms" value="1" required />
                </span>
                <label for="acceptTerms" class="form-label input-group-main">
                    <span>{$Text.CHECKOUT_STEP_FOUR_ACCEPT_TERMS}</span>
                    {if $termsLink}
                        <a class="termsAndConditionsLink fancybox" href="#overlayterms">{$Text.CHECKOUT_STEP_FOUR_ACCEPT_TERMS_LINK}</a>.
                    {/if}
                </label>
            </div>
        </fieldset>
    </div>

    <div class="buttonContainer">
        {if !$repay}
            <a href="/{$Text.CART_LINK}/" title="{$Text.CHECKOUT_BACK_TO_CART}" class="button trailing-db-mobile">{$Text.BACK}</a>
        {/if}
        <button type="submit" name="bestilling" class="button-primary">{$Text.CHECKOUT_CONFIRM}</button>
    </div>
</div>

{if $termsLink}
    {include file='modules/widgets/overlay/overlay.tpl' dataId=terms dataItemId=$termsLink}
{/if}
