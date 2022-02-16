{*

# Description
Checkout template partial, that is included when the payment has been declined. Part of Checkout page type.


## Date last modified
2017-05-19


## Primary variables
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

<div class="checkoutFrame" itemscope itemtype="http://schema.org/CheckoutPage">
    <div class="modules m-checkout-declined">
        <header class="m-checkout-declined-header page-title">
            <h1 class="m-checkout-declined-headline">{$text.CHECKOUT_PAYMENT_ERROR_HEADLINE}</h1>
        </header>

        <div class="panel panel-warning">
            <div class="panel-body">
    	       <span>{$text.CHECKOUT_PAYMENT_ERROR_TEXT}</span>
            </div>
        </div>
    </div>
</div>