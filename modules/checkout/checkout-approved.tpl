{*

# Description
Checkout template partial, that is included when the payment has been approved. Part of Checkout page type.


## Date last modified
2017-05-19


## Primary variables
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/order/order.tpl"                                    - Template widget for the User Order Details

*}

<div class="checkoutApproved" itemscope itemtype="http://schema.org/CheckoutPage">
    <div class="modules m-checkout-approved">
        <header class="m-checkout-approved-header page-title">
            <h1 class="m-checkout-approved-headline">{$text.CHECKOUT_STEP_FIVE_HEADLINE}</h1>
        </header>

        {if !empty($page.orderId)}
            <p class="m-checkout-approved text">{$text.CHECKOUT_STEP_FIVE_TEXT}</p>

            {include file='modules/widgets/order/order.tpl' orderId=$page.orderId checkout=true}
        {else}
            <div class="panel panel-warning">
                <div class="panel-body text-center">
                    {$text.CHECKOUT_STEP_FIVE_TIMEOUT}
                </div>
            </div>
        {/if}
    </div>
</div>




{* Register JavaScript Load to avoid double registrations in tracking tools *}
{if !empty($page.orderId)}
<script>
    (function(){
        var request = new XMLHttpRequest();
        request.open('POST', '/actions/handler/ajax?page=checkout&action=javascript_confirmation_loaded&order_id={$page.orderId}', true);
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        request.send();
    })();
</script>
{/if}