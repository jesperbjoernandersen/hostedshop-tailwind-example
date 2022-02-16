{*

# Description
Checkout error page


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

<div class="panel panel-border panel-warning">
	<div class="panel-body text-center">
		{$text.KLARNAKCO_SESSION_ERROR_TEXT}
	</div>
</div>