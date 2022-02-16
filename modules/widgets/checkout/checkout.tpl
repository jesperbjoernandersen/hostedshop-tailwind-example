{*

# Description
this widget is made for third-party checkouts

## Date last modified
2021-07-19


## Primary variables
+ $checkoutWidgets                                                    - all third-party checkouts
+ $displayOnly                                                        - includes either modals, brand buttons or the whole checkout

## Partials (templates)
+ modules/widgets/overlay/overlay.tpl
+ modules/widgets/checkout/partials/checkout-delivery.tpl
+ modules/widgets/checkout/partials/checkout-order.tpl'

*}

{collection controller=checkoutPaymentMethod assign=checkoutOptions type=quick}

{$hasPrice = false}
{if ($page.isProduct && isset($product) && ($product->BuyingPrice > 0 || $product->Prices.0->FullPriceMax > 0))
    || ($page.isCart && isset($cartList) && $cartList.CartTotalLine.0->Price > 0)}
    {$hasPrice = true}
{/if}

{if $checkoutOptions->getActualSize() > 0 && $hasPrice}

    {$checkoutOptionsData = $checkoutOptions->getData()}

    {$termsLink = $settings.link_terms_and_conditions}
    {if $user and $user->IsB2B and $settings.link_terms_and_conditions_b2b}
        {$termsLink = $settings.link_terms_and_conditions_b2b}
    {/if}

    {$loader = '<div class="loader"><div></div><div></div><div></div></div>'}

    {* Button *}
    {if !isset($displayOnly) || $displayOnly === 'buttons'}
        <div class="w-checkout-buttons {if isset($cartblock) && $cartblock}w-checkout-buttons--block{/if}">
            <p class="w-checkout-buttons-headline">{$text.CHECKOUT_WIDGET_BUTTONS_HEADLINE}</p>
            {foreach $checkoutOptionsData as $option}
                {if !is_array($option)}
                    {break}
                {/if}
                <div class="w-checkout-option w-checkout-option--{$option.type}" data-w-checkout-type="{$option.type}">
                    <button type="button" class="button-text w-checkout-button" title="{$option.title}" data-w-checkout="modal-open">
                        {$loader}
                        <img src="{$option.button.small}" alt="{$option.title}">
                        <img src="{$option.button.disabled.small}" class="disabled" alt="{$option.title}">
                    </button>
                </div>
            {/foreach}
            {if $page.type != 'cart'}
                <div class="cart-dead panel-danger">
                    <i class="fa fa-exclamation-triangle"></i>
                    <small>{$text.CART_DEAD}.&nbsp;<b><a href="/{$text.CART_LINK}/">{$text.CART_GO_TO}</a></b></small>
                </div>
            {/if}
        </div>
    {/if}

    {if !isset($displayOnly) || $displayOnly === 'modal'}
        <div class="w-checkout">
            {foreach $checkoutOptionsData as $option}
                {if !is_array($option)}
                    {break}
                {/if}
                <div class="is-block w-checkout w-checkout--{$option.type}" data-w-checkout="modal" {if isset($variant)}data-variant-stock="{$variant->Stock}"{/if}>

                    {* Modal *}
                    <div class="w-checkout-modal">
                        <div class="modal-blur" data-w-checkout="modal-close"></div>
                        <div class="modal-container text-left">
                            {$loader}
                            <div class="modal-header">
                                {if $page.type != 'cart'}
                                    <span class="w-checkout-notification" data-w-checkout="cart-response"></span>
                                {/if}
                                <i class="fa fa-times" data-w-checkout="modal-close"></i>
                            </div>
                            <div class="modal-content">

                                <form action="/actions/checkout/checkAll" method="post" class="w-checkout-form" autocomplete="off">
                                    {$pbsId = null}
                                    {foreach $option.inputs as $input}
                                        {if $input.name == 'pbs_type'}
                                            {$pbsId = $input.value}
                                        {/if}
                                        <input type="hidden" name="{$input.name}" value="{$input.value}">
                                    {/foreach}

                                    {csrf type="input"}

                                    {if $user}
                                        <input type="hidden" name="user" id="user" value="1">
                                        <input type="hidden" name="userId" id="userId" value="{$user->Id}">
                                        <input type="hidden" name="bruger" value="0">
                                        <input type="hidden" name="mobile" value="{$user->Mobile}">
                                        <input type="hidden" name="phone" value="{$user->Phone}">
                                    {/if}

                                    {include file='modules/widgets/checkout/partials/checkout-delivery.tpl' pbsId=$pbsId loader=$loader}

                                    <div class="w-checkout-order">
                                        <div class="order"></div>
                                    </div>

                                    {include file='modules/widgets/checkout/partials/checkout-submit.tpl' button=$option.button title=$option.title termsLink=$termsLink}
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            {/foreach}

            {addScript src='modules/widgets/checkout/includes/js/templates.js'}
            {addScript src='modules/widgets/checkout/includes/js/checkout.js'}
        </div>
    {/if}
{/if}
