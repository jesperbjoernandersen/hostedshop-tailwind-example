{*

# Description
Checkout template partial, where customers input all the data (includes step 1, 2, 3, 4 and 5). Part of Checkout page type.


## Date last modified
2021-02-09


## Primary variables
+ $boxes                                                    			- Global scope variable containing column boxes
+ $columns                                                  			- Global scope variable containing columns


## Partials (templates)
+ "/modules/widgets/order/order.tpl"                        			- Template widget for the User Order Details
+ "/modules/checkout/partials/checkout-step1.tpl"						- Template partial containing step 1 info
+ "/modules/checkout/partials/checkout-step2.tpl"						- Template partial containing step 2 info
+ "/modules/checkout/partials/checkout-step3.tpl"						- Template partial containing step 3 info
+ "/modules/checkout/partials/checkout-step4.tpl"						- Template partial containing step 4 info
+ "/modules/checkout/partials/checkout-step5.tpl"						- Template partial containing step 5 info

*}

{* Add required JS asset *}
{addScript src='modules/checkout/includes/js/checkout.js'}

{* Define standard class for columns *}
{$stepClass = "col-s-4 col-m-4 col-l-4 col-xl-8"}

{* Calculate number of columns needed *}
{if $columns gt 0}
	{$stepClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}
{/if}

{if !isset($user) && ($settings.shop_b2b_customer_approval || $settings.user_add)}
	{include file="modules/widgets/modal/modal.tpl" dataId="1" dataType="widget" dataClose="true" dataTarget="login" dataRequest="{$page.request}"}
{/if}

{assign var=stepNum value=1}

<div class="checkoutLoading preloader text-center"><img alt="" src="{$template.cdn}/_design/common/img/preloader/preloader-black.gif"></div>

<div class="checkoutFrame m-checkout" style="display:none;" itemscope itemtype="http://schema.org/CheckoutPage">
	<div class="row">
		<form action="/actions/checkout/checkAll" method="post" class="checkoutForm" autocomplete="off">
			{csrf type="input"}
		    <input id="check_stage_all_loaded" type="hidden" name="check_stage_all_loaded" value="0" />

            <header class="page-title">
                <h1>{$text.CHECKOUT_HEADLINE}</h1>
            </header>

			<div class="stepColumn column1 {$stepClass}">
				<div class="step1 panel">
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box1">
								<div class="stepHeader box1">
									<div class="title"><span class="h5"><span class="stepNumber"></span> {$Text.CHECKOUT_STEP_ONE}</span></div>
									<hr>
									{if !$user && $access.user && ($settings.shop_b2b_customer_approval || $settings.user_add)}
										<div class="stepHeaderLogin"><a href="#modal1" class="button button-default is-block fancybox-modal">{$Text.CHECKOUT_STEP_ONE_ALREADY_CREATED}</a></div>
										<hr>
										{if $access.userLookup}
											<div class="stepHeaderLookup">
												{include file='modules/widgets/userlookup/userlookup.tpl'}
											</div>
										{/if}
									{/if}
								</div>
								<div class="stepBox">
						    		{include file='modules/checkout/partials/checkout-step1.tpl'}
								</div>
							</div>
						</div>
					</div>
				</div>
				{if $settings.module_shop_packing}
				<div class="step3 panel">
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box3">
								<div class="stepHeader box3">
									<div class="title"><span class="h5"><span class="stepNumber"></span> {$Text.CHECKOUT_STEP_THREE}</span></div>
									<hr>
								</div>
								<div class="stepBox">
									{include file='modules/checkout/partials/checkout-step3.tpl'}
								</div>
							</div>
						</div>
					</div>
				</div>
				{/if}
			</div>
			<div class="stepColumn column2 {$stepClass}">
				{if !$settings.shop_delivery_hidden}
				<div class="step2 panel">
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box2">
								<div class="stepHeader box2">
									<div class="title"><span class="h5"><span class="stepNumber"></span> {$Text.CHECKOUT_STEP_TWO}</span></div>
									<hr>
								</div>
								<div class="stepBox">
									{include file='modules/checkout/partials/checkout-step2.tpl'}
								</div>
							</div>
						</div>
					</div>
				</div>
				{/if}
				<div class="step4 panel">
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box4">
								<div class="stepHeader box4">
									<div class="title"><span class="h5"><span class="stepNumber"></span> {$Text.CHECKOUT_STEP_FOUR}</span></div>
									<hr>
								</div>
								<div class="stepBox">
									{include file='modules/checkout/partials/checkout-step4.tpl'}
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="stepColumn column3 {$stepClass}">
				<div class="step5 panel">
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box5">
								<div class="stepHeader">
									<div class="title"><span class="h5">{$Text.CHECKOUT_SUMMARY}</span></div>
									<hr>
								</div>
								<div class="stepBox">
									{include file='modules/checkout/partials/checkout-step5.tpl'}
								</div>

								<div class="stepBox">
									{include file="modules/checkout/partials/checkout-step5-conditions.tpl"}
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
