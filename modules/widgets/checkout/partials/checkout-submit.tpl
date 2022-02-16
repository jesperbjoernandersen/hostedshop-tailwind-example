{*

# Description
Template partial for Checkout order summary of the checkout process. Part of Checkout widget.
Consisting mostly of a [jsRender Template](http://www.jsviews.com/#jsrender).


## Date last modified
2021-07-19


## Primary variables
$termsLink                                                    - link for terms and conditions

## Partials (templates)
No extra templates required for this template

*}

{$brandName = 'Checkout'}
{if strpos($title, 'MobilePay') !== false}
    {$brandName = 'MobilePay'}
{/if}

{$termsText = $text.CHECKOUT_WIDGET_ACCEPT_TERMS}
{if $termsLink}
    {$termsText = "{$termsText} <a class=\"termsAndConditionsLink w-checkout-link\" target=\"_blank\">({$text.CHECKOUT_STEP_FOUR_ACCEPT_TERMS_LINK})</a>"}
{/if}

<div class="w-checkout-submit">
    <div class="terms">
        <div class="material-checkbox">
            <input type="checkbox" name="acceptTerms" class="radiobtn" id="accept-terms" value="1" {if $returnPostData.acceptTerms}checked{/if} required>
            <div class="material-marker"></div>
        </div>
        <label for="accept-terms">{$termsText}</label>
    </div>
    <div class="submit">
        <button type="submit" name="bestilling" class="submit-button button-text button-disabled" title="{$title}">
            <img src="{$button.small}" alt="{$title}">
            <img src="{$button.disabled.small}" class="w-checkout-disabled" alt="{$title}">
        </button>
    </div>
    {$policyLink = 'https://www.mobilepay.dk/mobilepaymedia/mobilepay-dk/documents/persondata/behandling-af-personoplysninger.pdf'}
    {if $general.languageIso639 !== 'da'}
        {$policyLink = "{$policyLink}?la=en"}
    {/if}
    <p class="terms-mpc">
        {$text.CHECKOUT_WIDGET_MOBILEPAY_POLICY|cat:" <a target='_blank' class='w-checkout-link' rel='nofollow noopener' href={$policyLink}>{$text.CHECKOUT_WIDGET_POLICY_READ_HERE}</a>"}
    </p>
</div>
