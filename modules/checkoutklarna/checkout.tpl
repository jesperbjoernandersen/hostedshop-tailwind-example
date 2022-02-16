{*

# Description
Controller for checkout page type, that handles all the checkout.


## Date last modified
2022-01-24


## Primary variables
+ $user                                                                 - Global scope variable containing the user
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/widgets/modal/modal.tpl"                                    - Widget for modal window thru Fancybox
+ "/modules/checkout/partials/checkout-approved.tpl"                    - Checkout partial for when payment has been approved
+ "/modules/checkout/partials/checkout-declined.tpl"                    - Checkout partial for when payment has been declined
+ "/modules/checkout/partials/checkout-order.tpl"                       - Checkout partial for inputting customer data (also includes step 1 - 4)

*}
{$paymentId = 9}

{* Get Klarna session *}
{controller type=checkoutPaymentMethod assign=checkoutPaymentMethodController}
{$paymentSession = $checkoutPaymentMethodController->getPaymentSession($paymentId)}

{if empty($paymentSession)}
	<div class="modules m-checkout m-checkout--stacked">
		{include file='modules/checkoutklarna/checkout-error.tpl'}
	</div>
{elseif isset($smarty.get.approved)}
	{include file='modules/checkoutklarna/checkout-approved.tpl' paymentId=$paymentId paymentData=$paymentSession|default:[]}
{elseif isset($smarty.get.declined)}
	{include file='modules/checkout/checkout-declined.tpl'}
{elseif isset($smarty.get.repay) and !empty($shop.checkout.repay.id)}
	{include file='modules/checkout/checkout-repay.tpl'}
{else}
	{collection controller=cart assign=cart}
	{if $cart->getActualSize() gt 0}
		{include file="modules/checkoutklarna/partials/checkout-switcher.tpl"}
		{include file='modules/checkoutklarna/checkout-order.tpl' paymentId=$paymentId paymentData=$paymentSession|default:[]}
	{else}
		<div class="modules m-checkout m-checkout--stacked">
			<header class="m-checkout-header page-title">
				<h1 class="m-contact-headline">{$text.CHECKOUT_HEADLINE}</h1>
			</header>

			<div class="panel panel-border panel-warning">
				<div class="panel-body text-center">
					{$text.CART_IS_EMPTY}
				</div>
			</div>
		</div>
	{/if}
{/if}
