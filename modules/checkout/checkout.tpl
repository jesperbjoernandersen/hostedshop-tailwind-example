{*

# Description
Controller for checkout page type, that handles all the checkout.


## Date last modified
2021-03-25


## Primary variables
+ $user                                                                 - Global scope variable containing the user
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/widgets/modal/modal.tpl"                                    - Widget for modal window thru Fancybox
+ "/modules/checkout/partials/checkout-approved.tpl"                    - Checkout partial for when payment has been approved
+ "/modules/checkout/partials/checkout-declined.tpl"                    - Checkout partial for when payment has been declined
+ "/modules/checkout/partials/checkout-order.tpl"                       - Checkout partial for inputting customer data (also includes step 1 - 4)

*}

{collection controller=checkoutPaymentMethod assign=paymentMethods delivery_country=$general.deliveryCountryIso}
{foreach $paymentMethods->getData() as $data}

	{* Add KlarnaKP script if Klarna is a paymentmethod we offer *}
	{if $data->Id == 9 && $data->PaymentType == 'klarnaKP'}
		{addScript src='modules/checkout/includes/js/klarnaKP.js'}
	{/if}

	{* Add compatability check for ApplePay (32) and GooglePay (33) *}
	{if $data->PaymentMethodOnline}
		{foreach $data->PaymentMethodOnline as $card}
			{if in_array($card->Id, [32, 33])}
				{addScript relative=true src='https://onpay.io/sdk/v1.js'}
				{break}
			{/if}
		{/foreach}
	{/if}
{/foreach}

{if isset($smarty.get.approved)}
	{include file='modules/checkout/checkout-approved.tpl'}
{elseif isset($smarty.get.declined)}
	{include file='modules/checkout/checkout-declined.tpl'}
{elseif isset($smarty.get.repay) and !empty($shop.checkout.repay.id)}
	{include file='modules/checkout/checkout-repay.tpl'}
{else}
	{collection controller=cart assign=cart}
	{if $cart->getActualSize() gt 0}
		{include file='modules/checkout/checkout-order.tpl'}
	{else}
		<div class="modules m-checkout">
			<header class="m-checkout-header page-title">
				<h1 class="m-contact-headline">{$text.CHECKOUT_HEADLINE}</h1>
			</header>

			<div class="panel panel-warning">
				<div class="panel-body text-center">
					{$text.CART_IS_EMPTY}
				</div>
			</div>
		</div>
	{/if}
{/if}
