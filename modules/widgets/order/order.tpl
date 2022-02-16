{*

# Description
Order widget. A widget is a small helper template, with some functionality.


## Date last modified
2020-10-05


## Primary variables
+ $checkout 															- Toggle for "checkout mode" (ignore user check)
+ $repay 																- Toggle for "repay mode" (ignore transaction lines)
+ $order																- Entity of orderController
+ $orderCustomer														- Entity of orderCustomerController
+ $orderLine															- Collection of orderLineController
+ $productController													- Instance of productController
+ $tracking																- Entity of trackingMethodController
+ $trackingLine															- Entity of trackingMethodController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{if !isset($checkout)}
	{$checkout = false}
{/if}

{* Order entity *}
{if !empty($checkout)}
	{entity controller=order assign=order id=$orderId userId=false statusId=false}
{else}
	{entity controller=order assign=order id=$orderId userId=$user->Id}
{/if}

{if !$order}
	{notfound}
{/if}

{if !isset($repay)}
	{$repay = false}
{/if}

{* Order Customer entity *}
{entity controller=orderCustomer assign=orderCustomer orderId=$orderId}

{* Order Lines collection *}
{collection controller=orderLine assign=orderLine orderId=$orderId repay=$repay}
{controller assign=productController type=product}

{* Group order collection by class *}
{$orderList = $orderLine->groupByClass()}

{if $order->ServiceType}
	{* Service type entity *}
	{entity controller=trackingMethod id=$order->ServiceType assign=tracking}
{/if}

{$columnProductInfoClass = "col-s-4 col-m-3 col-l-3 col-xl-6"}
{$columnProductDataClass = "col-s-4 col-m-9 col-l-9 col-xl-18"}
{$columnProductDataColumnClass = "col-s-4 col-m-3 col-l-3 col-xl-6"}
{$columnProductImageClass = "col-s-1 col-m-1 col-l-1 col-xl-2"}

{* Calculate number of columns needed *}
{if $columns eq 2}
    {$columnProductInfoClass = "col-s-4 col-m-3 col-l-12 col-xl-6"}
	{$columnProductDataClass = "col-s-3 col-m-9 col-l-12 col-xl-18"}
	{$columnProductDataColumnClass = "col-s-4 col-m-3 col-l-12 col-xl-6"}
{elseif $columns eq 1}
    {$columnProductInfoClass = "col-s-4 col-m-3 col-l-3 col-xl-6"}
	{$columnProductDataClass = "col-s-3 col-m-9 col-l-9 col-xl-18"}
{/if}

{$imageWidth = 220}
{$imageHeight = 220}
{placeholdImage assign=placeholder width=$imageWidth height=$imageHeight background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}

<div class="row w-order">
	<div class="col-s-4 col-m-6 col-l-6 col-xl-12 w-order-wrap w-userinformation-wrap">
		<div class="panel panel-border">
			<div class="panel-body">
				<label class="form-label w-checkout-reciept">{$text.CHECKOUT_RECIEPT}</label>

				<p class="w-order-p-wrap w-userinformation">
					{if $orderCustomer->Company}
						<span class="is-block w-order-company w-company">{$orderCustomer->Company}</span>
					{/if}
					<span class="is-block w-order-name w-name">{$orderCustomer->Firstname} <span>{$orderCustomer->Lastname}</span></span>
					<span class="is-block w-order-address w-adress">{$orderCustomer->Address}</span>
					{if $orderCustomer->Address2}
						<span class="is-block w-order-address2 w-address2">{$orderCustomer->Address2}</span>
					{/if}
					<span class="is-block w-order-state-wrap w-state-wrap">
						{if $orderCustomer->State}
							<span class="w-order-city w-city">{$orderCustomer->City} <span class="w-order-state">{$orderCustomer->State}</span> <span class="w-order-zipcode">{$orderCustomer->Zip}</span></span>,
						{else}
							<span class="w-order-zipcode w-zipcode">{$orderCustomer->Zip} <span>{$orderCustomer->City}</span></span>,
						{/if}
						<span class="w-order-country w-country">{$orderCustomer->Country}</span>
					</span>

					{if $orderCustomer->Cvr}
						<span class="is-block w-order-vat w-vat"><span class="w-text">{$text.VAT_NR}</span><span class="w-colon">:</span> {$orderCustomer->Cvr}</span>
					{/if}
					{if $orderCustomer->Ean}
						<span class="is-block w-order-ean w-ean"><span class="w-text">{$text.EAN}</span><span class="w-colon">:</span> {$orderCustomer->Ean}</span>
					{/if}
					{if $orderCustomer->Phone}
						<span class="is-block w-order-telephone w-telephone"><span class="w-text">{$text.TELEPHONE}</span><span class="w-colon">:</span> {if $orderCustomer->CountryCode}+{$orderCustomer->CountryCode}{/if} {$orderCustomer->Phone}</span>
					{/if}
					{if $orderCustomer->Mobile}
						<span class="is-block w-order-mobile w-mobile"><span class="w-text">{$text.MOBILE}</span><span class="w-colon">:</span> {if $orderCustomer->CountryCode}+{$orderCustomer->CountryCode}{/if} {$orderCustomer->Mobile}</span>
					{/if}
					{if $orderCustomer->Email}
						<span class="is-block w-order-email w-email"><span class="w-text">{$text.MAIL}</span><span class="w-colon">:</span> {$orderCustomer->Email}</span>
					{/if}
					{if $orderCustomer->ExtendedDataExternal}
						<span class="is-block w-order-email w-extended-data">{$orderCustomer->ExtendedDataExternal}</span>
					{/if}
				</p>


				{if $orderCustomer->ShippingFirstname}
					<hr>
					<label class="form-label">{$text.CHECKOUT_DELIVERY_ADRESS}</label>
					<p class="w-order-p-wrap w-other-delivery-address">
						{if $orderCustomer->ShippingCompany}
							<span class="is-block w-order-other-company w-company">{{$orderCustomer->ShippingCompany}}</span>
						{/if}
						<span class="is-block w-order-other-name w-name">{{$orderCustomer->ShippingFirstname}} <span>{{$orderCustomer->ShippingLastname}}</span></span>
						<span class="is-block w-other-address w-adress">{{$orderCustomer->ShippingAddress}}</span>
						{if $orderCustomer->ShippingAddress2}
							<span class="is-block w-order-other-address2 w-address2">{{$orderCustomer->ShippingAddress2}}</span>
						{/if}
						<span class="is-block w-order-other-state-wrap w-state-wrap">
							{if $orderCustomer->ShippingState}
								<span class="w-order-other-city w-city">{{$orderCustomer->ShippingCity}} <span class="w-order-state">{{$orderCustomer->ShippingState}}</span> <span class="w-order-zipcode">{{$orderCustomer->ShippingZip}}</span></span>
							{else}
								<span class="w-order-other-zipcode w-zipcode">{{$orderCustomer->ShippingZip}} <span>{{$orderCustomer->ShippingCity}}</span></span>
							{/if}
							<span class="w-order-other-country w-country">{$orderCustomer->ShippingCountry}</span>
						</span>

						{if $orderCustomer->ShippingPhone}
							<span class="is-block w-order-other-telephone w-telephone">
								{if $orderCustomer->ShippingCountryCode}
									+{$orderCustomer->ShippingCountryCode}
								{/if}
								<span class="w-text">{$text.TELEPHONE}</span><span class="w-colon">:</span> {$orderCustomer->ShippingPhone}
							</span>
						{/if}
						{if $orderCustomer->ShippingMobile}
							<span class="is-block w-order-other-mobile w-mobile">
								{if $orderCustomer->ShippingCountryCode}
									+{$orderCustomer->ShippingCountryCode}
								{/if}
								<span class="w-text">{$text.MOBILE}</span><span class="w-colon">:</span> {$orderCustomer->ShippingMobile}
							</span>
						{/if}
						{if $orderCustomer->ShippingEmail}
							<span class="is-block w-order-other-email w-email">{$text.MAIL}: {$orderCustomer->ShippingEmail}</span>
						{/if}
					</p>
				{/if}
			</div>
		</div>
	</div>
	<div class="col-s-4 col-m-6 col-l-6 col-xl-12 w-order-wrap w-order-invoice-wrap">
		<div class="panel panel-border">
			<div class="panel-body">
				<label class="form-label w-invoice-label">
					{if isset($invoiceId)}
						{$text.MY_ORDERS_INVOICE}
					{else}
						{$text.MY_ORDERS_LINES}
					{/if}
				</label>

				<p class="w-order-p-wrap w-invoice">
					{if isset($invoiceId)}
						<div class="w-invoice-number">
							<span class="w-invoice-text">{$text.MY_ORDERS_INVOICE_NUMBER}</span><span class="w-colon">:</span> <strong>{$order->Invoice->Id}</strong>
						</div>
						<div class="w-invoice-date">
							<span class="w-invoice-text">{$text.MY_ORDERS_INVOICE_DATE}</span><span class="w-colon">:</span> <strong>{$order->Invoice->Date|date_format:$text.DATE_FORMAT}</strong>
						</div>
						<div class="w-invoice-due-date">
							<span class="w-invoice-text">{$text.MY_ORDERS_INVOICE_DUE_DATE}</span><span class="w-colon">:</span> <strong>{$order->Invoice->DueDate|date_format:$text.DATE_FORMAT}{if $order->Invoice->Paid} {$text.PAID}{/if}</strong>
						</div>
						<hr>
					{/if}

					<div class="w-invoice-order-number">
						<span class="w-invoice-text">
							{$text.CHECKOUT_STEP_FIVE_ORDER_NUMBER}
						</span><span class="w-colon">:</span> <strong>{$order->Id}</strong>
					</div>
					<div class="w-invoice-order-date">
						<span class="w-invoice-text">{$text.CHECKOUT_STEP_FIVE_ORDER_DATE}</span><span class="w-colon">:</span> <strong>{$order->Date|date_format:$text.DATE_FORMAT}</strong>
					</div>
					<div class="w-order-payment-method">
						<span class="w-invoice-text">{$text.CHECKOUT_STEP_FIVE_ORDER_PAYMENT_METHOD}</span><span class="w-colon">:</span> <strong>{$order->PaymentTitle}</strong>
					</div>
					{if $order->CardType}
					<div class="w-order-payment-cardtype">
						<span class="w-invoice-text">{$text.CHECKOUT_PAYMENT_FORM_CARD_TYPE}</span><span class="w-colon">:</span> <strong>{$order->CardType}</strong></span>
					</div>
					{/if}
					{if !$checkout}
						<div class="w-order-status">
							<span class="w-invoice-text">{$text.MY_ORDERS_STATUS}</span><span class="w-colon">:</span> <strong>{translation id=$order->Status module='order_status_code' title='title'}</strong>
						</div>
					{/if}

					{if !empty($order->DeliveryTime) and $order->DeliveryTime != '0000-00-00 00:00:00'}
					<div class="w-order-delivery-time">
						<span class="w-order-delivery-time-text">{$text.CHECKOUT_STEP_TWO_TIME_OF_DELIVERY}</span>
						<span class="w-colon">:</span>
						<strong>{$order->DeliveryTime|date_format:$text.DATE_FORMAT_SMARTY}</strong>
					</div>
					{/if}

					{if $order->TrackingCode}
					<div class="w-order-tracking-number">
						<span class="w-order-tracking-text">{$text.MY_ORDERS_TRACKING}{if $order->ServiceType} <span>({$tracking->Title})</span>{/if}</span><span class="w-colon">:</span>
						<strong>
							{if $order->ServiceType}
								<a class="w-tracking-anchor" href="{$tracking->getTrackingUrl($order->TrackingCode)}" target="_blank" rel="noopener"><img src="/_design/common/img/icons/delivery/{$tracking->Icon->Filename}" alt="{$tracking->Title}" class="is-inline-block icon-img-16x16">
								<span>{$order->TrackingCode}</span></a>
							{else}
								<span class="w-order-tracking">{$order->TrackingCode}</span>
							{/if}
						</strong>
					</div>
					{/if}

					{if $order->ReferenceNumber}
						<div class="w-order-reference-number">
							<span>{$text.MY_ORDERS_REFERENCE_NUMBER}</span><span class="w-colon">:</span> <strong>{$order->ReferenceNumber}</strong>
						</div>
					{/if}
				</p>
			</div>
		</div>
	</div>
</div>

{if $order->ExternalComment or $order->CustomerComment or $order->DeliveryComment}
	<ul class="nav nav-tabs w-user-comment-list">
		{if $order->ExternalComment}
	    	<li class="w-my-order-shop-comment active"><a data-toggle="content" href="#tabs-pane-externalComment">{$text.MY_ORDERS_SHOP_COMMENT}</a></li>
	    {/if}
	    {if $order->CustomerComment}
	    	<li class="w-my-order-user-comment"><a data-toggle="content" href="#tabs-pane-customerComment">{$text.MY_ORDERS_CUSTOMER_COMMENT}</a></li>
	    {/if}
	    {if $order->DeliveryComment}
	    	<li class="w-my-order-user-comment"><a data-toggle="content" href="#tabs-pane-deliverycomment">{$text.CHECKOUT_STEP_TWO_COMMENT_DELIVERY}</a></li>
	    {/if}
	</ul>
	<div class="toggle-content t-panel-clean">
		{if $order->ExternalComment}
		<div class="pane w-pane-external-comment active" id="tabs-pane-externalComment">
			{$order->ExternalComment}
		</div>
		{/if}
		{if $order->CustomerComment}
		<div class="pane w-pane-customer-comment" id="tabs-pane-customerComment">
			{$order->CustomerComment}
		</div>
		{/if}
		{if $order->DeliveryComment}
		<div class="pane w-pane-customer-comment" id="tabs-pane-deliverycomment">
			{$order->DeliveryComment}
		</div>
		{/if}
	</div>
{/if}

<div class="modules m-my-orders w-order-details">
	<div class="panel panel-border">
		<div class="panel-heading">
			<div class="row">
				<div class="{$columnProductImageClass} is-hidden-s">
				</div>
				<div class="col-s-4 col-m-11 col-l-11 col-xl-22 w-order-headline-wrap">
					<div class="row">
						<div class="{$columnProductInfoClass}">
							<span class="h6">{$text.CART_PRODUCTS}</span>
						</div>
						<div class="{$columnProductDataClass} {if $columns eq 2}is-hidden-l{/if} is-hidden-s">
							<div class="row w-order-details-header">
								<div class="col-s-4 col-m-3 col-l-3 col-xl-6 w-order-cart-note">
									<span class="h6">{$text.CART_NOTE}</span>
								</div>
								<div class="col-s-4 col-m-3 col-l-3 col-xl-6 w-order-cart-price">
									<span class="h6">{$text.CART_PRICE}</span>
								</div>
								<div class="col-s-4 col-m-3 col-l-3 col-xl-6 w-order-cart-count">
									<span class="h6">{$text.CART_COUNT}</span>
								</div>
								<div class="col-s-4 col-m-3 col-l-3 col-xl-6 cart-total-value w-order-cart-total-value">
									<span class="h6">{$text.CART_PRICE_ALL}</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<ul class="list-unstyled t-striped w-order-product-list">
			{if $orderLine->getActualSize() gt 0}
				{if isset($orderList['CollectionOrderLine'])}
					{foreach $orderList.CollectionOrderLine as $line}
						{$hasVatIncludedLabel = $currency.hasVat and ($settings.vat_label_advanced eq false or $line->Vat gt 0)}
						{$link = null}
						{if $line->Type != 'wrapping' and $line->Type != 'sale'}
							{$link = $productController->link($line->ProductId)}
						{/if}
						{*** Product image ***}
						{$productImage = null}
						{$variantImage = null}
						{if $line->ProductId && is_numeric($line->ProductId)}
							{if $line->ProductId}
								{entity assign=productImage controller=files type=product productId=$line->ProductId}
							{/if}
							{if $line->VariantId}
								{entity assign=variantImage controller=files type=variant variantId=$line->VariantId}
							{/if}

							{if $variantImage}
								{$productImage = $variantImage->thumbnail($imageWidth, $imageHeight, true)|solutionPath}
							{elseif $productImage}
								{$productImage = $productImage->thumbnail($imageWidth, $imageHeight, true)|solutionPath}
							{else}
								{$productImage = $placeholder->getRelativeFile()|solutionPath}
							{/if}
						{/if}
						<li class="w-product-item item-{$line->ProductId}">
			            	<article class="row">
								<div class="{$columnProductImageClass} w-order-product-title-container">
									{if $productImage}
										<figure>
											<a href="{$link}" title="{$line->ProductTitle}">
												<img src="{$productImage}" class="responsive" alt="{$line->ProductTitle}" itemprop="image"/>
											</a>
										</figure>
									{/if}
								</div>

								<div class="col-s-3 col-m-11 col-l-11 col-xl-22 w-order-product-container reset">
									<div class="{$columnProductInfoClass}">
										<header class="w-product-item-header">
											{if $link}
												<a href="{$link}" class="w-product-item-anchor" itemprop="url">
											{/if}
												<h6 itemprop="name">
													{$line->ProductTitle}

													{if $line->VariantTitle}
														{$line->VariantTitle}
													{/if}

													{if $line->CouponId}
														({$text.MY_ORDERS_NUMBER} {$line->CouponId})
													{/if}
												</h6>
											{if $link}
												</a>
											{/if}
										</header>
										{if $line->AdditionalTitle}
											<p class="w-product-additional-title">{$line->AdditionalTitle}</p>
										{/if}
										{if $line->PacketTitle}
											<p class="w-product-packet-title">{$line->PacketTitle}</p>
										{/if}
										{if isset($line->CouponTo)}
											<p class="w-product-coupon-line">
												<span class="w-gift-card-name">{$text.GIFT_CARD_NAME}</span><span class="w-colon">:</span> {$line->CouponTo}
												{if isset($line->CouponCode)}
													<br><span class="w-gift-card-code">{$text.GIFT_CARD_CODE}</span><span class="w-colon">:</span> {$line->CouponCode}
												{/if}
											</p>
										{/if}
										{if isset($line->FileDownloadLink)}
											<p class="w-product-file-sale-anchor"><a href="/{$text.FILE_SALE_LINK}/{$line->FileDownloadLink}" target="_blank" rel="noopener">{$text.FILE_SALE_MENU}</a></p>
										{/if}

										{if $line->ItemNumber && $settings.shop_product_number eq true}
											<p class="w-product-item-number"><span>{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</span> {$line->ItemNumber}</p>
										{/if}
									</div>
									<div class="w-product-detail-line col-s-4 col-m-9 col-l-9 col-xl-18">
										<div class="row">
											<div class="{$columnProductDataColumnClass}">
												{if $line->DeliveryTime && $settings.shop_product_delivery_time eq true}
													<div class="w-product-deliverytime">{$line->DeliveryTime}</div>
												{/if}
												{if $line->Weight && $settings.shop_product_weight eq true}
													<div class="w-product-weight">
														<span>{$line->Weight|formatNumber}</span> {$text.PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT}
													</div>
												{/if}
												{if $line->Status}
													<div class="w-product-status">
														<span class="w-orders-status-text">{$text.MY_ORDERS_STATUS}</span><span class="w-colon">:</span> {translation id=$line->Status module='order_status_code' title='title'}
													</div>
												{/if}
												{if $line->TrackingCode}
													<div class="w-product-trackingcode">
													{if $line->ServiceType}
														{entity controller=trackingMethod id=$line->ServiceType assign=trackingLine}

														<a href="{$trackingLine->getTrackingUrl($line->TrackingCode)}" target="_blank" rel="noopener"><img src="/_design/common/img/icons/delivery/{$trackingLine->Icon->Filename}" alt="{$trackingLine->Title}" class="is-inline-block icon-img-16x16">
														<span class="w-service-type">{$line->ServiceType}</span></a>
													{else}
														<span class="w-trackingcode-line">{$line->TrackingCode}</span>
													{/if}
													</div>
												{/if}
												{if $line->ExtendedDataExternal}
													<div class="w-product-extended-data">
														{foreach $line->ExtendedDataExternal as $extendedDataType}
															<div class="w-product-extended-data-line">
																<span class="w-product-extended-data-line__type">{$extendedDataType->Name}</span>: <span class="w-product-extended-data-line__data">{$extendedDataType->Data}</span>
															</div>
														{/foreach}
													</div>
												{/if}
											</div>
											<div class="w-product-full-price {$columnProductDataColumnClass}">
												<strong class="is-block">
													{if $line->FullPrice == $line->Price}
														{$line->Price|formatPriceOrder:$orderId}
													{else}
														<del class="is-block">{$line->FullPrice|formatPriceOrder:$orderId}</del>
														{$line->Price|formatPriceOrder:$orderId}
													{/if}
												</strong>
												{if $settings.shop_product_tax_after_price}
													<span class="is-block w-product-price-vat">
														{if $hasVatIncludedLabel}
															<span class="w-vat-text has-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</span>
														{else}
															<span class="w-vat-text has-novat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</span>
														{/if}
													</span>
												{/if}
											</div>
											<div class="w-product-unit-title {$columnProductDataColumnClass} trailing-mobile">
												<span>{$line->Amount} {$line->UnitTitle}</span>
											</div>
											<div class="w-product-total-value {$columnProductDataColumnClass} cart-total-value">
												<strong class="is-block">
													{if $line->FullPrice == $line->Price}
														{($line->Price * $line->Amount)|formatPriceOrder:$orderId}
													{else}
														<s>{($line->FullPrice * $line->Amount)|formatPriceOrder:$orderId}</s><br>
														{($line->Price * $line->Amount)|formatPriceOrder:$orderId}
													{/if}
												</strong>
												{if $settings.shop_product_tax_after_price}
													<span class="is-block w-product-price-vat">
														{if $hasVatIncludedLabel}
															<span class="w-vat-text has-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</span>
														{else}
															<span class="w-vat-text has-novat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</span>
														{/if}
													</span>
												{/if}
											</div>
										</div>
									</div>
								</div>
							</article>

							{* Secondary delivery line *}
							{if $line->Address}
								<div class="panel panel-warning w-second-delivery-line" style="margin-bottom: 0; margin-top: 1em;">
									<div class="panel-body">
										<strong>{$text.CHECKOUT_DELIVERY_TO}</strong>
										<span>
											{if $line->Address->Company}
												<span class="ww-name">{$line->Address->Company}</span><span class="w-comma">,</span>
											{/if}
											{if $line->Address->Firstname}
												<span class="ww-address">{$line->Address->Firstname} <span>{$line->Address->Lastname}</span></span><span class="w-comma">,</span>
											{/if}
											{if $line->Address->Address}
												<span class="ww-address">{$line->Address->Address}</span><span class="w-comma">,</span>
											{/if}
											{if $line->Address->Zip}
												<span class="ww-zipcode">{$line->Address->Zip} <span>{$line->Address->City}</span></span><span class="w-comma">,</span>
											{/if}
											{$line->Address->CountryIso}
											<span class="w-parentheses">(</span><span class="ww-unit-title">{$line->Address->Amount} {$line->UnitTitle}</span><span class="w-parentheses">)</span>
										</span>
										{if $line->Address->Zip}
											<br><span>{$text.CHECKOUT_STEP_TWO_COMMENT}</span><span class="w-colon">:</span> {$line->Address->Comment}
										{/if}
										{if $line->Address->DeliveryDate}
											<br><span class="ww-delivery-step-two-text">{$text.CHECKOUT_STEP_TWO_TIME_OF_DELIVERY}</span><span class="w-colon">:</span> <span class="ww-delivery-date">{$line->Address->DeliveryDate|date_format:$text.DATE_FORMAT} {$line->Address->DeliveryTime}
										{/if}
									</div>
								</div>
							{/if}

							{* Gift wrapping *}
							{if isset($line->WrappingText)}
								<div class="panel panel-warning w-product-geftwraping" style="margin-bottom: 0; margin-top: 1em;">
									<div class="panel-body">
										<strong>{$text.CHECKOUT_STEP_THREE_NOTE}</strong>
										<span>
											{if isset($line->WrappingText)}
												{$line->WrappingText}
												{if isset($line->WrappingText)}
													<br><span class="ww-delivery-step-three-text">{$text.CHECKOUT_STEP_THREE_NOTE_FROM}</span><span class="w-colon">:</span> {$line->WrappingFrom}
												{/if}
											{/if}
										</span>
									</div>
								</div>
							{/if}
			            </li>
					{/foreach}
				{/if}
			{/if}
		</ul>
	</div>
</div>
<div class="row w-order-summary">
	<div class="col-s-4 col-m-5 col-m-offset-7 col-l-5 col-l-offset-7 col-xl-10 col-xl-offset-14 w-alignment-right">
		<div class="row">
			<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
				<table class="table">
					<tbody>
						{if isset($orderList['CollectionOrderDeliveryLine'])}
							<tr class="w-order-summary-delivery w-tr">
								<td class="text-left"><span class="w-order-summarydelivery-text"><span>{$text.DELIVERY}</span><span class="w-colon">:</span> {$orderList.CollectionOrderDeliveryLine.0->Title}</span></td>
								<td class="text-right">
									<span>{$orderList.CollectionOrderDeliveryLine.0->Price|formatPriceOrder:$orderId}</span>
								</td>
							</tr>
						{/if}

						{if isset($orderList['CollectionOrderSubTotalLine'])}
							<tr class="w-order-summary-sub-total w-tr">
								<td class="text-left"><span>{$text.CART_PRICE_SUM}</span></td>
								<td class="text-right">
									<span itemprop="total">{$orderList.CollectionOrderSubTotalLine.0->Price|formatPriceOrder:$orderId}</span>
								</td>
							</tr>
						{/if}

						{if isset($orderList['CollectionOrderVatTotalLine'])}
							<tr class="w-order-summary-vat-total w-tr">
								<td class="text-left">
	               				{if $currency.hasVat}
									<span>{$text.CART_VAT_INCLUSIVE}</span>
								{else}
									<span>{$text.CART_VAT_EXCLUSIVE}</span>
								{/if}
		                		</td>
								<td class="text-right">
		                			<span itemprop="tax">{$orderList.CollectionOrderVatTotalLine.0->Price|formatPriceOrder:$orderId}</span>
								</td>
							</tr>
						{/if}

						{if isset($orderList['CollectionOrderPaymentLine']) && $orderList.CollectionOrderPaymentLine.0->Price != 0}
							<tr class="w-order-summary-payment w-tr">
								<td class="text-left"><span>{$text.MY_ORDERS_FEE}</span></td>

								<td class="text-right">
									<span>{$orderList.CollectionOrderPaymentLine.0->Price|formatPriceOrder:$orderId}</span>
								</td>
							</tr>
						{/if}
					</tbody>

					<tfoot>
						<tr class="w-order-summary-cart-total w-tr">
							<td class="text-left"><span><strong>{$text.CART_TOTAL}</strong></span></td>
							<td class="text-right">
								<span>
									<strong>{$orderList.CollectionOrderTotalLine.0->Price|formatPriceOrder:$orderId}</strong>
								</span>
							</td>
						</tr>
					</tfoot>
				</table>
			</div>
		</div>
	</div>
</div>