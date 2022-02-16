{*

# Description
Template partial for Checkout step 4 of the checkout process. Part of Checkout page type.
Consisting mostly of a [jsRender Template](http://www.jsviews.com/#jsrender).


## Date last modified
2022-01-24


## Resource
+ [jsRender Template](http://www.jsviews.com/#jsrender)


## Primary variables


## Partials (templates)
No extra templates required for this template

*}

<input type="hidden" name="post_paymentType" value="{$returnPostData.paymentType}">
<input type="hidden" name="post_onlinePaymentType" value="{$returnPostData.onlinePaymentType}">

{include file='modules/checkoutklarna/partials/checkout-switcher.tpl'}

{literal}
<script id="paymentMethodTemplate" type="text/x-jsrender">
<div class="paymentMethodContainer" id="paymentMethodContainer_{{:id}}{{if id == 9 && payment_type && payment_type === 'klarnaKP'}}_{{:klarna.group}}{{/if}}"{{if id == 9 && payment_type && payment_type === 'klarnaKP'}} style='display:none'{{/if}}>
	<div class="paymentMethodSelector radio">
		<fieldset class="form-group">
			{{if id == 9 && payment_type == 'klarnaKCO'}}
				<div class="form-label--klarnaKCO form-label input-group-main" style="display: block !important;">{{include tmpl="#CheckoutSwitcher"/}}</div>
			{{else}}
				<div class="input-group">
					<span class="input-group-addon">
						<input id="payment_type_{{:id}}{{if id == 9}}_klarna_{{:klarna.group}}{{/if}}" type="radio" name="paymentType" value="{{:id}}" class="paymentMethodRadio" data-show-on-active=".payment_details_{{:id}}{{if id == 9}}_{{:klarna.group}}{{/if}}" data-show-active-group="payment"
						{{if id == 9 && payment_type && payment_type === 'klarnaKP'}} data-klarna='{{:klarna.group}}'{{/if}}>
					</span>

					<div class="form-label input-group-main">

						<label for="payment_type_{{:id}}{{if id == 9}}_klarna_{{:klarna.group}}{{/if}}">

							<span class="paymentMethodTitle">
								{{if id == 9}}
									{{if payment_type == 'klarnaKP'}}
										<span class="l-payment-method-title-logo klarnaLogo is-block">
										{{if asset}}
											<img alt="Klarna" style="max-width: 100px;width: 100%;height:auto;" src="{{:asset.descriptive}}">
										{{else}}
											Klarna
										{{/if}}
										</span>
									{{else}}
										<span class="l-payment-method-title-logo klarnaLogo is-block">
											<img alt="Klarna" src="https://cdn.klarna.com/1.0/shared/image/generic/logo/{{:klarna.locale.toLowerCase()}}/basic/blue-black.png?width=100&eid={{:klarna.paymentCode}}">
										</span>
									{{/if}}
								{{/if}}
								<span class="l-payment-method-title-text">
									{{:title}}{{if subtitle}}: <small>{{:subtitle}}</small>{{/if}}
								</span>
							</span>

							{{if priceFixed}}
								<span class="paymentMethodFeeFixed is-block">{{:priceFixed}}</span>
							{{/if}}
							{{if pricePercentage}}
								<span class="paymentMethodFeePercentage is-block">{{:pricePercentage}} %</span>
							{{/if}}

							<span class="paymentMethodDescription is-block">{{:description}}</span>

							{{if id == 6}}
								<span class="paymentMethodPaypalIcons is-block">
									<img src="/_design/common/img/payment/card_mastercard.gif" alt="Mastercard">
									<img src="/_design/common/img/payment/card_visa.gif" alt="Visa">
									<img src="/_design/common/img/payment/card_americanexpress.gif" alt="American Express">
									<img src="/_design/common/img/payment/card_discover.gif" alt="Discover">
									<img src="/_design/common/img/payment/card_echeck.gif" alt="E-Check">
									<img src="/_design/common/img/payment/card_paypal.gif" alt="PayPal">
								</span>

							{{else id == 8}}
								<span class="paymentMethodPaypalIcons is-block">
									<img src="/_design/common/img/payment/card_paybybill.png" alt="PayByBill">
								</span>
							{{/if}}
						</label>

						{{if id == 8}}
							{{if paybybill.showValidation}}
								<div id="paybybillcontainer" class="payment_details_{{:id}}" style="display:none;">
									<fieldset class="form-group m-paybybill-label">
										<label class="form-label" for="cprPayBybill">
											{{:paybybill.info.fieldLabel}} <span class="form-required">*</span>
										</label>
										<input class="form-input" type="text" id="cprPayByBill" name="cprPayBybill" placeholder="{{:paybybill.info.fieldText}}" disabled required autocomplete="off">
									</fieldset>
								</div>
							{{/if}}

						{{else id == 9 && payment_type !== 'klarnaKP'}}
							<div class="m-klarna-container payment_details_{{:id}}_{{:klarna.group}}" style="display:none;">
							{{if klarna.paymentMethods}}
								{{if klarna.paymentMethods.length == 1}}
									<div class="m-klarna-payment-methods">
										<input type="hidden" name="klarna_pclass" value="{{:klarna.paymentMethods[0].pclass}}" disabled>
										{{if klarna.paymentMethods[0].details}}
										<table class="table-h-striped">
											<tbody>
												{{for klarna.paymentMethods[0].details}}
												<tr>
													<td>{{:label}}</td>
													<td>{{:value}} {{:symbol}}</td>
												</tr>
												{{/for}}
											</tbody>
										</table>
										{{/if}}

										{{if klarna.paymentMethods[0].exampleText || klarna.paymentMethods[0].terms}}
										<p class="klarna_example">
											<span class="m-klarna-exampletext is-block">{{:klarna.paymentMethods[0].exampleText}}</span>
											<a class="m-klarna-terms-button is-block fancybox fancybox.iframe" href="{{:klarna.paymentMethods[0].terms}}">{{:~text('PRODUCT_CATALOG_READ_MORE')}}</a>
										</p>
										{{/if}}
									</div>
								{{else}}
								<ul class="m-klarna-payment-methods list-unstyled">
									{{for klarna.paymentMethods}}
									<li>
										<fieldset class="form-group">
											<div class="input-group" style="width:100%;">
												<span class="input-group-addon">
													<input id="klarna_type_{{:group}}_{{:#index}}" class="m-klarna-payment-methods-choice" type="radio" name="klarna_pclass" value="{{:pclass}}" required disabled data-show-on-active="#klarna_details_{{:group}}_{{:#index}}" data-show-active-group="klarna">
												</span>
												<div class="form-label input-group-main">
													<label for="klarna_type_{{:group}}_{{:#index}}" class="paymentMethodTitle">{{:title}}</label>

													<div id="klarna_details_{{:group}}_{{:#index}}" class="klarnaShowOnClick" style="display:none;">
														{{if details}}
														<table class="table-h-striped">
															<tbody>
																{{for details}}
																<tr>
																	<td>{{:label}}</td>
																	<td>{{:value}} {{:symbol}}</td>
																</tr>
																{{/for}}
															</tbody>
														</table>
														{{/if}}

														{{if exampleText || terms}}
														<p class="klarna_example">
															<span class="m-klarna-exampletext is-block">{{:exampleText}}</span>
															<a class="m-klarna-terms-button is-block fancybox fancybox.iframe" href="{{:terms}}">{{:~text('PRODUCT_CATALOG_READ_MORE')}}</a>
														</p>
														{{/if}}
													</div>
												</div>
											</div>
										</fieldset>
									</li>
									{{/for}}
								</ul>
								{{/if}}
							{{/if}}

							{{if !~isKlarnaCompany}}
								{{if klarna.fields}}
								<ul class="m-klarna-payment-methods list-unstyled">
									{{for klarna.fields}}
									<li>
										<fieldset class="form-group m-klarna-label">
											<label class="form-label" for="{{:name}}_{{:group}}">
												{{:label}} <span class="form-required">*</span>
											</label>
											{{if values}}
												<select class="form-input form-select" id="{{:name}}_{{:group}}" name="{{:name}}" disabled required>
												{{for values}}
													<option value="{{:value}}">{{:label}}</option>
												{{/for}}
												</select>
											{{else}}
												<input class="form-input" type="text" id="{{:name}}_{{:group}}" name="{{:name}}" placeholder="{{:text}}" disabled required autocomplete="off">
											{{/if}}
										</fieldset>
									</li>
									{{/for}}
								</ul>
								{{else}}
								<fieldset class="form-group m-klarna-label">
									<label class="form-label" for="cpr_{{:group}}">
										{{:klarna.fieldLabel}} <span class="form-required">*</span>
									</label>
									<input class="form-input" type="text" id="cpr_{{:group}}" name="cpr" placeholder="{{:klarna.fieldText}}" disabled required autocomplete="off">
								</fieldset>
								{{/if}}
							{{/if}}
							{{if klarna.extraText}}
								<div class="m-klarna-extra-text">
									{{:klarna.extraText}}
								</div>
							{{/if}}
							</div>
						{{/if}}
					</div>
				</div>
			{{/if}}
		</fieldset>
		{{if id == 9 && payment_type == 'klarnaKP'}}
			<div class="m-klarna-container payment_details_{{:id}}_{{:klarna.group}}" style="display:none;margin-bottom: 0.5em;overflow: auto;">
				<input type="hidden" name="klarnakp_payment_method_category" value={{:klarna.group}} disabled>
				<input type="hidden" name="klarnakp_authorization_token" value="" disabled>
				<div data-klarna-id="{{:id}}"
					data-klarna-group="{{:klarna.group}}"
					class="m-klarna-iframe payment_iframe_{{:id}}_{{:klarna.group}}"></div>
			</div>
		{{/if}}
	</div>

	{{if onlineMethods}}
	<div class="paymentMethodOnlineContainerMain showOnClick">
		<ul class="list-unstyled" style="padding: 0 0 0 1.5em;">
		{{for onlineMethods}}
		<li>
			<fieldset class="form-group small">
				<div class="input-group">
					<span class="input-group-addon">
						<input type="radio" name="onlinePaymentType" id="pbs_type_{{:id}}" value="{{:id}}" class="paymentMethodOnlineRadio" disabled>
					</span>
					<label for="pbs_type_{{:id}}" class="form-label input-group-main">
						<span class="paymentMethodOnlineName is-block">{{:title}}</span>
						{{if priceFixed}}
							<span class="paymentMethodOnlineFeeFixed is-block">{{:priceFixed}}</span>
						{{/if}}
						{{if pricePercentage}}
							<span class="paymentMethodOnlineFeePercentage is-block">{{:pricePercentage}} %</span>
						{{/if}}
						<span class="paymentMethodOnlineIcons is-block">
							{{:~paymentGraphic(logo)}}
							{{if id == '19'}}
								{/literal}
								{$cartList = $cart->groupByClass()}
								{include file="modules/widgets/integrations/viabill_pricetag.tpl" type="payment" price=$cartList.CartTotalLine.0->Price}
								{literal}
							{{/if}}
						</span>
					</label>
				</div>
			</fieldset>
		</li>
		{{/for}}
		</ul>
	</div>
	{{/if}}
</div>
</script>
{/literal}

<div class="paymentMethodContainerMain"></div>
