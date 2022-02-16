{*

# Description
Repay template, that is included when repay link is accesed. Part of Checkout page type.


## Date last modified
2017-05-19


## Primary variables
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/order/order.tpl"                                    - Template widget for the User Order Details
+ "/modules/checkout/partials/checkout-step5-conditions.tpl"			- Template for terms and conditions box

*}

{* Add required JS asset *}
{addScript src='modules/checkout/includes/js/repay.js'}

{* Fetch all payment methods *}
{collection assign=paymentMethods controller=checkoutPaymentMethod}

<div id="repay" itemscope itemtype="http://schema.org/CheckoutPage">
	<div class="modules m-repay">
		<header class="m-repay-header page-title">
			<h1 class="m-repay-headline">{$text.CHECKOUT_HEADLINE}</h1>
		</header>

		<form id="repayForm" method="post" action="/actions/checkout/checkFour" autocomplete="off">
			{csrf type="input"}
			<div class="paymentMethods">
				<ul class="list-unstyled">
					{foreach $paymentMethods->getData() as $method}
						<li class="paymentMethodContainer">
							<fieldset class="form-group small">
								<div class="input-group">
									<span class="input-group-addon">
										<input {if $method@iteration eq 1}checked{/if} type="radio" name="paymentType" id="payment_type_{$method->Id}{if $method->Klarna}_klarna_{$method->Klarna.group}{/if}" value="{$method->Id}" required>
									</span>
									<div class="form-label input-group-main">
										<label for="payment_type_{$method->Id}{if $method->Klarna}_klarna_{$method->Klarna.group}{/if}">
											<span class="paymentMethodTitle">
												{if $method->Klarna}
													<span class="l-payment-method-title-logo klarnaLogo is-block">
														<img alt="Klarna" src="https://cdn.klarna.com/1.0/shared/image/generic/logo/{$method->Klarna.locale|lower}/basic/blue-black.png?width=100&eid={$method->Klarna.paymentCode}">
													</span>
												{/if}
												<span class="l-payment-method-title-text">{$method->Title}</span>
											</span>
											{if $method->Description}
												<span class="paymentMethodDescription is-block">{$method->Description}</span>
											{/if}
											{if $method->PriceFixed}
												<span class="is-block">{$method->PriceFixed}</span>
											{/if}
											{if $method->PricePercentage}
												<span class="is-block">{$method->PricePercentage} <span class="m-percent">%</span></span>
											{/if}
										</label>

										{if $method->Id eq 6}
											<span class="paymentMethodPaypalIcons is-block">
												<img src="{$template.cdn}/_design/common/img/payment/card_mastercard.gif" alt="MasterCard">
												<img src="{$template.cdn}/_design/common/img/payment/card_visa.gif" alt="VISA">
												<img src="{$template.cdn}/_design/common/img/payment/card_americanexpress.gif" alt="American Express">
												<img src="{$template.cdn}/_design/common/img/payment/card_discover.gif" alt="Discover">
												<img src="{$template.cdn}/_design/common/img/payment/card_echeck.gif" alt="E-Check">
												<img src="{$template.cdn}/_design/common/img/payment/card_paypal.gif" alt="PayPal">
											</span>

										{elseif $method->PayByBill}
											<span class="paymentMethodPayByBillIcons is-block">
												<img src="{$template.cdn}/_design/common/img/payment/card_paybybill.png" alt="PayByBill">
											</span>
											{if $method->PayByBill.showValidation}
												<span id="paybybillcontainer" class="showOnClick is-block" style="display:none;">
												<label class="paybybillLabel">
													<span>{$method->PayByBill.info.fieldLabel}</span>
													<span class="error_text">*</span>
													<input type="text" id="cprPayByBill" name="cprPayBybill" placeholder="{$method->PayByBill.info.fieldText}" required title="{$text.USER_ADD_ERROR_INCORRECT_FIELD}" disabled>
												</label>
											</span>
											{/if}

										{elseif $method->Klarna}
											<div class="m-klarna-container showOnClick" style="display:none;">
												{if isset($method->Klarna["paymentMethods"])}
													<ul class="m-klarna-payment-methods list-unstyled">
														{foreach $method->Klarna["paymentMethods"] as $klarnaMethod}
															<li>
																<fieldset class="form-group">
																    <div class="input-group" style="width:100%;">
																        <span class="input-group-addon">
																        	<input id="klarna_type_{$klarnaMethod.group}_{$klarnaMethod@index}" class="m-klarna-payment-methods-choice" type="radio" name="klarna_pclass" value="{$klarnaMethod.pclass}" required disabled data-show-on-active="#klarna_details_{$klarnaMethod.group}_{$klarnaMethod@index}" data-show-active-group="klarna">
																        </span>
																        <div class="form-label input-group-main">
																        	<label for="klarna_type_{$klarnaMethod.group}_{$klarnaMethod@index}" class="paymentMethodTitle">{$klarnaMethod.title}</label>

																			<div id="klarna_details_{$klarnaMethod.group}_{$klarnaMethod@index}" class="klarnaShowOnClick" style="display:none;">
																				{if isset($klarnaMethod["details"])}
																				<table class="table-h-striped">
																					<tbody>
																						{foreach $klarnaMethod["details"] as $klarnaDetail}
																						<tr>
																							<td>{$klarnaDetail.label}</td>
																							<td>{$klarnaDetail.value} {$klarnaDetail.symbol}</td>
																						</tr>
																						{/foreach}
																					</tbody>
																				</table>
																				{/if}

																				{if isset($klarnaMethod["exampleText"]) || isset($klarnaMethod["terms"])}
																				<p class="klarna_example">
																					<span class="m-klarna-exampletext is-block">{$klarnaMethod.exampleText}</span>
																					<a class="m-klarna-terms-button is-block fancybox fancybox.iframe" href="{$klarnaMethod.terms}">{$text.PRODUCT_CATALOG_READ_MORE}</a>
																				</p>
																				{/if}
																			</div>
																        </div>
																    </div>
																</fieldset>
															</li>
														{/foreach}
													</ul>
												{/if}

												<fieldset class="form-group m-klarna-label">
													<label class="form-label" for="cpr_{$method->Klarna.group}">
														{$method->Klarna.fieldLabel} <span class="form-required">*</span>
													</label>
													<input class="form-input" type="text" id="cpr_{$method->Klarna.group}" name="cpr" placeholder="{$method->Klarna.fieldText}" disabled required autocomplete="off">
												</fieldset>

												{if $method->klarna.extraText}
													<div class="m-klarna-extra-text">
														{$method->Klarna.extraText}
													</div>
												{/if}
											</div>
										{/if}

									</div>
								</div>
							</fieldset>

							{if $method->PaymentMethodOnline}
								<div class="paymentMethodOnlineContainerMain showOnClick">
									<ul class="list-unstyled list-unstyled-nested" style="padding: 0 0 0 1.5em;">
										{foreach $method->PaymentMethodOnline as $onlineMethod}
											<li>
												<fieldset class="form-group small">
													<div class="input-group">
														<span class="input-group-addon">
															<input {if $onlineMethod@iteration eq 1}checked{/if} type="radio" name="onlinePaymentType" id="pbs_type_{$onlineMethod->Id}" value="{$onlineMethod->Id}" class="paymentMethodOnlineRadio" disabled="disabled">
														</span>
														<label for="pbs_type_{$onlineMethod->Id}" class="form-label input-group-main">
															<span class="is-block">{$onlineMethod->Title}</span>
															{if $onlineMethod->PriceFixed}
																<span class="is-block">{$onlineMethod->PriceFixed}</span>
															{/if}
															{if $onlineMethod->PricePercentage}
																<span class="is-block">{$onlineMethod->PricePercentage} %</span>
															{/if}
															{if $onlineMethod->Logo}
															<span class="is-block">
																{foreach explode('|', $onlineMethod->Logo) as $logo}
																	<img alt="" src="{$template.cdn}{$logo}">
																{/foreach}
															</span>
															{/if}
														</label>
													</div>
												</fieldset>
											</li>
										{/foreach}
									</ul>
								</div>
							{/if}

						</li>
					{/foreach}
				</ul>
			</div>
			<div class="repayButtonContainer">
				{include file='modules/checkout/partials/checkout-step5-conditions.tpl' repay=true}
			</div>
		</form>

		<hr>

		{if !empty($shop.checkout.repay.id)}
			{include file='modules/widgets/order/order.tpl' checkout=true repay=true orderId=$shop.checkout.repay.id}
		{/if}
	</div>
</div>
