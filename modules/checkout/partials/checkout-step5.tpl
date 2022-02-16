{*

# Description
Template partial for Checkout step 5 of the checkout process. Part of Checkout page type.
Consisting mostly of a [jsRender Template](http://www.jsviews.com/#jsrender).


## Date last modified
2020-10-05


## Resource
+ [jsRender Template](http://www.jsviews.com/#jsrender)


## Primary variables


## Partials (templates)
No extra templates required for this template

*}
{literal}
<script id="orderSummaryTemplate" type="text/x-jsrender">
	<div id="orderLines">
		<div class="modules m-cart">
			<div class="panel panel-border">
				<ul class="list-unstyled t-striped">
					{{for orderLines.lines tmpl="#orderLineTemplate"/}}

					{{if orderLineLimit && orderLines.lines.length > orderLineLimit}}
					<li class="orderLine l-orderline-hidden-info">
						<header class="header text-center b-checkout-header show-all-products">
		                    <button class="button is-block orderline-hidden-button">{{:~text('CART_SHOW_ALL_PRODUCTS')}} ({{:orderLines.lines.length}})</button>
		                </header>
					</li>
					{{/if}}

					{{if salesDiscount}}
					<li class="orderLine">
						<article>
							<div class="row">
								<div class="col-s-1 col-m-4 col-l-2 col-xl-4">
									<strong class="h6">1 {{:~text('PEACES')}}</strong>
								</div>
	                            <div class="col-s-3 col-m-8 col-l-10 col-xl-20">
		                            <div class="row">
										<div class="col-s-4 col-m-12 col-l-6 col-xl-15 trailing-mobile">
											<span class="is-block" {/literal}style="color: {$template.settings.FONT_COLOR_LINK};"{literal}>{{:salesDiscount.title}}</span>
											{{if salesDiscount.itemNumber}}
												<strong><small>{{:~text('PRODUCT_CATALOG_PRODUCT_NUMBER')}}  {{:salesDiscount.itemNumber}}</small></strong>
											{{/if}}
										</div>
										<div class="col-s-4 col-m-12 col-l-6 col-xl-9">
											<span class="cart-total-value pull-right">
												<strong class="h6">
													{{:salesDiscount.priceFormatted}}
												</strong><br class="is-hidden-s">
												<span class="h6 reset">{{:~vatText}}</span>
											</span>
										</div>
									</div>
								</div>
							</div>
						</article>
					</li>
					{{/if}}

					{{if coupon}}
					<li class="orderLine">
						<article>
							<div class="row">
								<div class="col-s-1 col-m-4 col-l-2 col-xl-4">
									<strong class="h6">1 {{:~text('PEACES')}}</strong>
								</div>
	                            <div class="col-s-3 col-m-8 col-l-10 col-xl-20">
		                            <div class="row">
										<div class="col-s-4 col-m-12 col-l-6 col-xl-15 trailing-mobile">
											<span class="is-block">{{:coupon.title}}</span>
										</div>
										<div class="col-s-4 col-m-12 col-l-6 col-xl-9">
											<span class="cart-total-value pull-right">
												<strong class="h6">
													{{:coupon.priceFormatted}}
												</strong><br class="is-hidden-s">
												<span class="h6 reset">{{:~vatText}}</span>
											</span>
										</div>
									</div>
								</div>
							</div>
						</article>
					</li>
					{{/if}}
				</ul>
			</div>
		</div>
	</div>

	<table class="table">
		<tbody>
			<tr class="orderLineDelivery">
				<td>
					<span>{{:~text('CHECKOUT_STEP_FOUR_DELIVERY')}} {{:delivery.title}}</span>
				</td>
				<td class="text-right">
					<span>{{:delivery.priceFormatted}}</span>
				</td>
			</tr>


			<tr class="orderLineSubTotal">
				<td>
					<span>{{:~text('CART_PRICE_SUM')}}</span>
				</td>
				<td class="text-right">
					<span>{{:subTotalFormatted}}</span>
				</td>
			</tr>


			<tr class="orderLineVat">
				<td>
					<span>
						{{if ~hasVat}}
							{{:~text('CART_VAT_INCLUSIVE')}}
						{{else}}
							{{:~text('CART_VAT_EXCLUSIVE')}}
						{{/if}}
					</span>
				</td>
				<td class="text-right">
					<span>{{:totalvatFormatted}}</span>
				</td>
			</tr>


			{{if payment.price != "0"}}
			<tr class="orderLinePayment">
				<td>
					<span>{{:~text('MY_ORDERS_FEE')}}</span>
				</td>
				<td class="text-right">
					<span>{{:payment.priceFormatted}}</span>
				</td>
			</tr>
			{{/if}}


		</tbody>
		<tfoot>
			<tr class="orderLineSum">
				<td>
					<strong>{{:~text('CART_TOTAL')}}</strong>
				</td>
				<td class="text-right">
					<strong>{{:totalFormatted}}</strong>
				</td>
			</tr>
		</tfoot>
	</table>
</script>

<script id="orderLineTemplate" type="text/x-jsrender">
	<li class="orderLine {{if ~root.orderLineLimit && #index >= ~root.orderLineLimit}}is-hidden{{/if}}">
		<article>
			<header>
				{{if dead}}
					<span class="h6">{{:~text('CART_PRODUCT_DEAD_TITLE')}} - {{:~text('CART_PRODUCT_DEAD_NOTE')}}</span>
					<a href="/_source/modules/shop_cart/cart.actions.php?action=del&amp;id={{:i+1}}" title="{{:~text('DELETE')}} {{:~text('CART_PRODUCT_DEAD_TITLE')}} {{:~text('CART_FROM')}}"><img src="/_design/common/img/icons/cross-icon.png" border="0"></a>

				{{else}}
					<div class="orderLineTitle">
						<div class="row">
							<div class="col-s-1 col-m-12 col-l-2 col-xl-4">
								<strong class="h6">
									{{:amount}}{{if unit}} <span class="orderLineAmountText">{{:unit}}</span>{{/if}}
								</strong>
							</div>
                            <div class="col-s-3 col-m-12 col-l-10 col-xl-20">
	                            <div class="row">
									<div class="col-s-4 col-m-12 col-l-6 col-xl-15 trailing-mobile">
										{{if link}}<a href="{{:link}}"> {{/if}}<span class="title">{{:title}}</span>{{if link}}</a>{{/if}}

										{{if hasAdditional}}
											<div>{{:titleAdditional}} {{:titleForm}}</div>
										{{/if}}

										{{if titlePacketProducts}}
											<div>{{:titlePacketProducts}}</div>
										{{/if}}

										{{if giftcard}}
											<div>{{:~text('GIFT_CARD_NAME')}}: {{:giftcard.name}}</div>
										{{/if}}
									</div>
									<div class="col-s-4 col-m-12 col-l-6 col-xl-9 clearfix">
										<span class="cart-total-value pull-right">
											<strong class="h6">{{:priceTotal}}</strong><br class="is-hidden-s">
											<span class="h6 reset">
												{{if ~productVatText}}
													{{:~productVatText(priceVatCalc,  priceNoVatCalc)}}
												{{else}}
													{{:~vatText}}
												{{/if}}
											</span>
										</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				{{/if}}
			</header>
		</article>
	</li>
</script>
<div class="orderSummary"></div>
{/literal}
