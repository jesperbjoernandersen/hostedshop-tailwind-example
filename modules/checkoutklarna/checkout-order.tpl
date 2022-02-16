{*

# Description
Checkout template partial, where customers input all the data (includes step 1, 2, 3, 4 and 5). Part of Checkout page type.


## Date last modified
2022-01-24


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
{addScript src='modules/checkoutklarna/includes/js/checkout.min.js'}
{addLink href='modules/checkoutklarna/includes/css/checkout.min.css'}

{if !isset($user)}
	{include file="modules/widgets/modal/modal.tpl" dataId="1" dataType="widget" dataClose="true" dataTarget="login" dataRequest="{$page.request}"}
{/if}

{* Fetch delivery countrys *}
{controller type="deliveryCountry" assign="deliveryCountryController"}
{if isset($paymentId)}
	{collection controller=$deliveryCountryController assign=deliveryCountries access=true payment_method_id=$paymentId}
{else}
	{collection controller=$deliveryCountryController assign=deliveryCountries access=true}
{/if}

{assign var=stepNum value=2}
{assign var=stepLoader value='<svg class="w-checkout-steps__icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 18.475 18.475"><path d="M19.037,9.8A9.237,9.237,0,1,1,9.8.563,9.237,9.237,0,0,1,19.037,9.8ZM8.731,14.691l6.853-6.853a.6.6,0,0,0,0-.843l-.843-.843a.6.6,0,0,0-.843,0L8.31,11.741,5.7,9.132a.6.6,0,0,0-.843,0l-.843.843a.6.6,0,0,0,0,.843l3.874,3.874a.6.6,0,0,0,.843,0Z" transform="translate(-0.563 -0.563)"/></svg><span class="stepNumber w-checkout-steps__stepNumber"></span> '}

<div class="checkoutLoading preloader text-center"><img alt="" src="{$template.cdn}/_design/common/img/preloader/preloader-black.gif"></div>


<div class="checkoutError is-hidden">
	{include file='modules/checkoutklarna/checkout-error.tpl'}
</div>

<div
	class="checkoutFrame m-checkout m-checkout--stacked"
	style="display:none;"
	data-hasKlarnaCheckout="{if $klarnaKCO}true{else}false{/if}"
	itemscope
	itemtype="http://schema.org/CheckoutPage">

	<div class="row">
		<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
			<div class="w-checkout-cart__headline-link text-right">
				<a class="trailing-db-mobile" href="/{$text.CART_LINK}/">{$text.CHECKOUT_EDIT_CART}</a>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-s-4 col-m-12 col col-l-5 col-l-push-7 col-xl-8 col-xl-push-16 w-checkout-cart__container">
			<div class="panel panel-border w-checkout-cart"> <div class="panel-body step5">
					<div class="stepColumnInnerWrapper">
						<div class="stepContainer box5">
							<div class="stepHeader box5">
								<div class="title m-cart-header">
									<div class="w-checkout-cart__headline-wrap">
										<div class="w-checkout-cart__headline-text">
											<span class="m-cart-headline w-checkout-steps__tabitem__title" itemprop="name">{$text.CART_HEADLINE}</span>
										</div>
									</div>
								</div>
							</div>
							<div class="stepBox">
								{include file='modules/checkout/partials/checkout-step5.tpl'}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<form action="/actions/checkout/checkAll" method="post" class="checkoutForm clearfix col-s-4 col-m-12 col-l-7 col-l-pull-5 col-xl-16 col-xl-pull-8" autocomplete="off">
			{csrf type="input"}
		    <input id="check_stage_all_loaded" type="hidden" name="check_stage_all_loaded" value="0" />

			<div class="stepColumn column0">
				<div class="step1 panel panel-border w-checkout-usertype w-checkout-steps__step {if !$user}w-checkout-steps__step--is-closed{else}w-checkout-steps__step--is-user{/if}" data-js-checkoutsteps="usertype" data-js-checkoutusertype="main" data-js-checkoutusertypes='{$availableTypes|jsonify}'>
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box2">
								<div class="stepHeader box2">
									<div class="title w-checkout-steps__tabitem w-checkout-steps__tabitem--is-active" data-js-checkoutsteps__tabitem="usertype">
										<div class="w-checkout-steps__tabitem__title">{$stepLoader}<span class="w-checkout-steps__title">{$Text.CHECKOUT_KLARNA_STEP_ONE}</span></div>
										{if $access.user && !$user}
											<div class="w-checkout-usertype__login-wrap text-right">
												<a href="#modal1" class="w-checkout-usertype__login-button fancybox-modal"><svg
														class="w-checkout-usertype__login-button-icon"
														xmlns="http://www.w3.org/2000/svg"
														width="20.986"
														height="20.986"
														viewBox="0 0 20.986 20.986"><path d="M10.493.563A10.493,10.493,0,1,0,20.986,11.056,10.491,10.491,0,0,0,10.493.563Zm0,4.062A3.723,3.723,0,1,1,6.77,8.348,3.723,3.723,0,0,1,10.493,4.624Zm0,14.555a8.108,8.108,0,0,1-6.2-2.886,4.717,4.717,0,0,1,4.168-2.53,1.035,1.035,0,0,1,.3.047,5.6,5.6,0,0,0,1.731.292,5.581,5.581,0,0,0,1.731-.292,1.035,1.035,0,0,1,.3-.047,4.717,4.717,0,0,1,4.168,2.53A8.108,8.108,0,0,1,10.493,19.179Z" transform="translate(0 -0.563)"/>
													</svg>&nbsp;<span class="w-checkout-usertype__login-button-text">{$Text.CHECKOUT_EXISTING_USER}</span></a>
											</div>
										{/if}
									</div>
								</div>

								{if !$user}
								<div class="w-checkout-usertype__list--wrap">
									<input type="hidden" name="customer-type" value="private">
								</div>
								{/if}

								<div class="stepBox w-checkout-steps__step__toggle">
									{if $user}
										{include file='modules/checkout/partials/checkout-step1-user.tpl'}
									{else}
										{include file='modules/checkoutklarna/partials/checkout-step1-data.tpl'}
										{if $settings.shop_delivery_hidden}
											<input type="hidden" name="zipcode" autocomplete="postal-code" id="zipcode" value="" />
											<input type="hidden" name="country" autocomplete="country-name" id="country" value="{$general.deliveryCountryIso}" />
										{/if}
									{/if}

									{if $settings.module_shop_packing}
									<div class="giftWrappingContainer">
										<div class="stepColumn column3">
											<div class="step3">
												<p class="title">{$Text.CHECKOUT_STEP_THREE}</p>
												<div class="stepBox clearfix">
													{include file='modules/checkout/partials/checkout-step3.tpl'}
												</div>
											</div>
										</div>
									</div>
									{/if}

									{if $settings.checkout_reference_number}
									<div class="referenceNumberContainer">
										<div class="stepColumn column3">
											<div class="step3">
												<p class="title">{$Text.MY_ORDERS_REFERENCE_NUMBER}{if $settings.checkout_reference_number_required} <span class="form-required">*</span>{/if}</p>
												<div class="stepBox">
													<div class="referenceNumber">
														<input type="text" name="referenceNumber" autocomplete="disabled" value="{$returnPostData.referenceNumber}" id="referenceNumber" class="form-input" placeholder="{$Text.MY_ORDERS_REFERENCE_NUMBER}" {if $settings.checkout_reference_number_required}required{/if}>
													</div>
												</div>
											</div>
										</div>
									</div>
									{/if}
								</div>
							</div>
						</div>
					</div>
				</div>

				{if !$settings.shop_delivery_hidden}
				<div class="step2 panel panel-border w-checkout-delivery w-checkout-steps__step w-checkout-steps__step--is-closed" data-js-checkoutsteps="delivery">
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box2">
								<div class="stepHeader box2">
									<div class="title w-checkout-steps__tabitem" data-js-checkoutsteps__tabitem="delivery">
										<div class="w-checkout-steps__tabitem__title">{$stepLoader}<span class="w-checkout-steps__title">{$Text.CHECKOUT_STEP_TWO}</span></div>
									</div>
								</div>
								<div class="stepBox w-checkout-steps__step__toggle">
                                    <div class="row">
										<div class="col-s-4 col-m-12 col-l-12 col-xl-24 w-checkout-delivery__inputs" data-js-checkoutdelivery="inputs">
											<div class="contactInfoContainer step1">
												<div class="country w-checkout-delivery__country-wrap">
													{if $deliveryCountries->getActualSize() gt 1}
														<fieldset class="form-group m-checkout-country">
															<label class="form-label" for="m-checkout-country">{$Text.COUNTRY} <span class="form-required">*</span></label>
															<select id="country" data-js-checkoutdelivery="country" class="country-select form-input form-select small" autocomplete="shipping country">
																{foreach $deliveryCountries->getData() as $country}
																	<option
																		data-has-states="{count($country->CountryStates)}"
																		value="{$country->Iso}"
																		{if $returnPostData.country}{if $country->Iso eq $returnPostData.country}selected{/if}{elseif $country->Iso eq $general.deliveryCountryIso}selected{/if}
																		{if $paymentId === 9}data-alpha3="{$deliveryCountryController->toFormat($country->Iso)}"{/if}
																	>{$country->Title}</option>
																{/foreach}
															</select>
														</fieldset>
													{else}
														{foreach $deliveryCountries->getData() as $country}
															<input
																id="country"
																data-js-checkoutdelivery="country"
																type="hidden"
																autocomplete="shipping country"
																value="{$general.deliveryCountryIso}"
																{if $paymentId === 9}data-alpha3="{$deliveryCountryController->toFormat($country->Iso)}"{/if}
																data-has-states="{count($country->CountryStates)}"
															>
														{/foreach}
													{/if}

													{foreach $deliveryCountries->getData() as $country}
														{if count($country->CountryStates) gt 0}
															<fieldset class="form-group country-state-group country-state-group-{$country->Iso} {if $general.deliveryCountryIso != $country->Iso}is-hidden{/if}">
																<label class="form-label" for="state{$country->Id}">{$Text.STATE} <span class="form-required">*</span></label>
																<select id="state{$country->Id}" data-js-checkoutdelivery-state="state{$country->Id}" data-js-checkoutdelivery="state" class="country-state-select form-input form-select small" autocomplete="address-level1" disabled required>
																	{foreach $country->CountryStates as $DeliveryStateAbbr => $DeliveryState}
																		<option value="{$DeliveryStateAbbr}" {if $DeliveryStateAbbr eq $returnPostData.state}selected{/if}>{$DeliveryState}</option>
																	{/foreach}
																</select>
															</fieldset>
														{/if}
													{/foreach}
												</div>

												<fieldset class="form-group m-checkout-zipcode w-checkout-delivery__zipcode-wrap">
													<label class="form-label" for="m-checkout-zipcode">{$Text.POSTCODE} <span class="form-required">*</span></label>
													<div class="w-checkout-delivery__input-wrap">
														{if $returnPostData.zipcode}
															{$zipcodeValue = $returnPostData.zipcode}
														{elseif $user}
															{$zipcodeValue = $user->Zipcode}
														{/if}
														<input id="zipcode" type="text" data-js-checkoutdelivery="zipcode" autocomplete="postal-code" value="{$zipcodeValue|default:""}" class="form-input" placeholder="{$Text.POSTCODE}" required>
														<input id="city" type="text" data-js-checkoutdelivery="city" disabled="disabled" value="" class="form-input">
													</div>
												</fieldset>
											</div>
										</div>

										<div class="col-s-4 col-m-12 col-l-12 col-xl-24 w-checkout-delivery__normal w-checkout-delivery__normal--is-closed" data-js-checkoutdelivery="normal">
											{include file='modules/checkout/partials/checkout-step2.tpl'}
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				{/if}

				{if isset($paymentData) && isset($paymentData['html_snippet'])}
				<div class="step4 panel panel-border w-checkout-payment w-checkout-steps__step w-checkout-steps__step--is-closed" data-js-checkoutsteps="payment">
					<div class="panel-body">
						<div class="stepColumnInnerWrapper">
							<div class="stepContainer box4">
								<div class="stepHeader box4">
									<div class="title w-checkout-steps__tabitem" data-js-checkoutsteps__tabitem="payment">
										<div class="w-checkout-steps__tabitem__title">{$stepLoader}<span class="w-checkout-steps__title">{$Text.CHECKOUT_STEP_FOUR}</span></div>
									</div>
								</div>

								<div class="w-checkout-steps__step__toggle">
									<div class="w-checkout-payment__paymenttype w-checkout-payment__paymenttype--klarnaKCO" data-js-checkoutpayment="klarna" id="klarnaCheckoutWrapper">
										{$paymentData['html_snippet']}
									</div>
								</div>
								<input type="radio" class="paymentMethodRadio is-hidden" value="{$paymentId}" checked="checked">
								<script id="paymentMethodTemplate" type="text/x-jsrender"></script>
								<script id="orderSummaryTemplate" type="text/x-jsrender"></script>
							</div>
						</div>
					</div>
				</div>
				{/if}
			</div>
		</form>
	</div>
</div>
