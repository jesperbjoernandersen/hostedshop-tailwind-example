{*

# Description
Controller and template for the Cart page type. Uses elements like


## Date last modified
2022-01-24


## Primary variables
+ $cart 																- Collection of cartController (contains all products in cart)
+ $cartProductList														- List of all cart products
+ $cartList 															- List of all cart products
+ $product 																- Entity of a product (item in cart)
+ $productImage 														- Entity of filesController with type product (a product image)
+ $variantData 															- Collection of productVariantDataController (data for variantTypes)
+ $variantImage 														- Entity of filesController with type variant (a variant product image)
+ $additionalTypeData 													- Entity of productAdditionalTypeController (types for additional products)
+ $packetProductData   													- Entity of productController (a packetproduct for a product)
+ $packetVariantData													- Collection of productVariantDataController, but for packetproduct (data for variantTypes)
+ $icons  																- Shop payment icons


## Partials (templates)
+ "/modules/product/product-list-combined.tpl"							- List of related / focus products
+ "/modules/widgets/paymenticons/paymenticons.tpl" 						- Payment icons widget
+ "/modules/widgets/meta/opengraph.tpl"                     			- Social meta data

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}

{*** Cart controller ***}
{collection controller=cart assign=cart primary=true}
{$cartProductList = $cart->groupByClass('CartProductLine')}
{$cartList = $cart->groupByClass()}

{*** Eager loading ***}
{include file='modules/cart/cart-preload.tpl' scope=parent}

{*** Picture size ***}
{$imageWidth  = 220}
{$imageHeight = 220}

{placeholdImage assign=placeholder width=$imageWidth height=$imageHeight background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}

<div class="modules m-cart" itemscope itemtype="http://schema.org/OfferCatalog">
{if isset($cartProductList['CartProductLine'])}

	{* Check for Cart availability  *}
	{$cartblock = false}
	{foreach $cartList.CartProductLine as $cartProduct}
		{if ($cartProduct->Soldout && $cartProduct->AllowOutOfStockPurchase eq false) or !$cartProduct->Available}
			{$cartblock = true}
		{/if}
	{/foreach}

	{* Dynamic link for Checkout if Klarna Checkout is available *}
	{$cartLink = $text.CHECKOUT_LINK}

	{* Get Klarna session *}
	{controller type=checkoutPaymentMethod assign=checkoutPaymentMethodController}
	{$paymentSession = $checkoutPaymentMethodController->getPaymentSession(9, 'klarnaKCO')}

	{if !empty($paymentSession)}
			{$cartLink = $text.CHECKOUT_KLARNA_LINK}
		{/if}

	<form id="m-cart" method="post" action="/actions/cart/update">
        {csrf type="input"}
		<header class="m-cart-header page-title">
		    <div class="row">
				<div class="col-s-4 col-m-6 col-l-7 col-xl-12 text-left">
					<h1 class="m-cart-headline" itemprop="name">{$text.CART_HEADLINE}</h1>
				</div>
				<div class="col-s-4 col-m-6 col-l-5 col-xl-12 text-right">
					<a class="button-primary trailing-db-mobile" href="{if !$cartblock}/{$cartLink}/{else}#{/if}">{$text.CHECKOUT_MENU}</a>
					{if $cartblock}
						<div class="m-cart-order-warning">
                            {include file="modules/widgets/icon/icon.tpl" icon="alertTriangle"}
							<span><small>{$text.CART_DEAD}</small></span>
						</div>
					{/if}
				</div>
			</div>
		</header>

    {if $cartList.CartDeliveryEstimateLine.0->PriceUntilFreeDelivery}
        <div class="m-cart-free-delivery panel-body text-center">
            {$text.CART_PRICE_UNTIL_FREE_DELIVERY|replace:'$1':($cartList.CartDeliveryEstimateLine.0->PriceUntilFreeDelivery|formatPrice)}
        </div>
    {/if}

		<div class="modules m-cart-content">
			<div class="panel panel-border">
				<div class="panel-heading">
					<div class="row">
						<div class="col-s-4 col-m-1 col-l-1 col-xl-2 is-hidden-s">
						</div>
						<div class="col-s-3 col-m-11 col-l-11 col-xl-22 m-cart-headline-wrap">
							<div class="row">
								<div class="col-s-4 col-m-3 col-l-3 col-xl-6 m-cart-headline-product-container m-cart-headline-container">
									<span class="m-cart-headline-product h6">{$text.CART_PRODUCTS}</span>
								</div>
								<div class="col-s-4 col-m-2 col-l-2 col-xl-4 is-hidden-s m-cart-headline-note-container m-cart-headline-container">
									<span class="m-cart-headline-note h6">{$text.CART_NOTE}</span>
								</div>
								<div class="col-s-4 col-m-2 col-l-2 col-xl-4 is-hidden-s m-cart-headline-price-container m-cart-headline-container">
									<span class="m-cart-headline-price h6">{$text.CART_PRICE}</span>
								</div>
								<div class="col-s-4 col-m-3 col-l-3 col-xl-4 is-hidden-s m-cart-headline-amount-container m-cart-headline-container">
									<span class="m-cart-headline-amount h6">{$text.CART_COUNT}</span>
								</div>
								<div class="col-s-4 col-m-2 col-l-2 col-xl-6 cart-total-value is-hidden-s m-cart-headline-total-container m-cart-headline-container">
									<span class="m-cart-headline-total h6">{$text.CART_PRICE_ALL}</span>
								</div>
							</div>
						</div>
					</div>
				</div>
                <ul class="list-unstyled t-striped m-cart-list">
                    {foreach $cartList.CartProductLine as $cartProduct}

						{$hasVatIncludedLabel = $currency.hasVat and ($settings.vat_label_advanced eq false or $cartProduct->Vat gt 0)}

                        {*** Product ***}
                        {entity assign=product controller=product type=product id=$cartProduct->ProductId}
                        {entity assign=productImage controller=files type=product productId=$cartProduct->ProductId}

                        {*** Variant ***}
                        {$cartVariantTitle = ''}
                        {if $cartProduct->VariantId}

                            {collection assign=variantDatas controller=productVariantData productId=$cartProduct->ProductId variantId=$cartProduct->VariantId}

                            {foreach $variantDatas->getData() as $variantData}
                                {$cartVariantTitle = $cartVariantTitle|cat:" "|cat:$variantData->Title}
                            {/foreach}

                        	{entity assign=variantImage controller=files type=variant variantId=$cartProduct->VariantId}
                        {/if}

						{*** Picture ***}
						{$imageAspect = "{($imageHeight / $imageWidth) * 100}%"}
                        {if $cartProduct->VariantId && $variantImage}
                        	{$cartImage = $variantImage->thumbnail($imageWidth, $imageHeight, "fill")|solutionPath}
                        {elseif $productImage}
                        	{$cartImage = $productImage->thumbnail($imageWidth, $imageHeight, "fill")|solutionPath}
                        {else}
                            {$cartImage = $placeholder->getRelativeFile()|solutionPath}
                        {/if}

                        <li class="m-cart-row" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
                        	<meta itemprop="position" content="{$cartProduct@iteration}">
                        	<article class="row">
								<div class="col-s-1 col-m-1 col-l-1 col-xl-2 m-cart-product-title-container">
									<figure>
										<a href="{$cartProduct->Url}" title="{$cartProduct->Title} {$cartVariantTitle}" class="placeholder-wrapper" data-placeholder-max-width="180px">
											<span class="placeholder" data-placeholder-aspect="{$imageAspect}"></span>
											{img src="{$cartImage}" class="responsive" alt="{$cartProduct->Title} {$cartVariantTitle}" itemprop="image"}
										</a>
									</figure>
								</div>
								<div class="col-s-3 col-m-11 col-l-11 col-xl-22 m-cart-product-container">
									<div class="row">
										<div class="col-s-4 col-m-3 col-l-3 col-xl-6">
											<header>
												{if $cartProduct->Available}
													{* Product / Variant *}
													<a href="{$cartProduct->Url}" title="{$cartProduct->Title} {$cartVariantTitle}" itemprop="url">
														<p class="m-cart-product-title" itemprop="name">
															<span class="m-cart-product-title">{$cartProduct->Title}</span> <span class="m-cart-variant-title">{if !$cartProduct->UserTitle}{$cartVariantTitle}{/if}</span>
														</p>
													</a>

													{* Additionals *}
													{if $cartProduct->Additionals}
														{foreach $cartProduct->Additionals as $key => $additionalType}
															{entity assign=additionalTypeData controller=productAdditionalType id=$key}

															<p class="m-cart-product-additional-content">
																<span class="m-cart-product-additional-title">{$additionalTypeData->Title}</span><span class="m-colon">:</span><br>

																{foreach $additionalType as $additional}
																	<span class="m-hyphen">-</span> <span class="m-cart-product-additional-data-title">{$additional->Title}</span>
																	{if $additional->Price}
																		<span class="m-cart-product-additional-data-price">({$additional->Price|formatPrice})</span>
																	{/if}
																	<br>
																{/foreach}
															</p>
														{/foreach}
													{/if}

													{* Packet product *}
													{if $cartProduct->PacketProducts}
														<p class="m-cart-product-packet-text">{$text.PRODUCT_CATALOG_PRODUCT_PACKET}</p>
														{foreach $cartProduct->PacketProducts as $packetProduct}
															{*** Product ***}
															{entity assign=packetProductData controller=product type=product id=$packetProduct->ProductId}

															{*** Variant ***}
															{$packetVariantTitle = ''}
															{if $packetProduct->VariantId}
                                                                {collection assign=packetVariantDatas controller=productVariantData variantId=$packetProduct->VariantId}

                                                                {foreach $packetVariantDatas->getData() as $packetVariantData}

												                    {$packetVariantTitle = $packetVariantTitle|cat:" "|cat:$packetVariantData->Title}
																{/foreach}
															{/if}

															<p class="m-cart-product-packet-content">
																<span class="m-cart-product-packet-data-amount">{$packetProduct->Amount}</span> <span class="m-x">x</span>
																{if $packetProductData}
																	<span class="m-cart-product-packet-data-title">{$packetProductData->Title} {$packetVariantTitle}</span>
																{else}
																	<span class="m-cart-product-packet-data-title dead">{$text.CART_PRODUCT_DEAD_TITLE}</span>
																{/if}
															</p>
														{/foreach}
													{/if}

													{* Gift Card *}
													{if $cartProduct->Giftcard}
														<p class="m-cart-product-giftcard-content">
															<span class="m-cart-product-giftcard-name-text">{$text.GIFT_CARD_NAME}</span><span class="m-colon">:</span>
															<span class="m-cart-product-giftcard-name">{$cartProduct->Giftcard->Name}</span>
														</p>
													{/if}

													{if $settings.shop_product_number eq true && $cartProduct->ItemNumber}
														<p class="m-cart-product-number">
															<span class="m-cart-product-number-text">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</span> <span class="m-cart-product-number">{$cartProduct->ItemNumber}</span>
														</p>
													{/if}
												{else}
													<p class="m-cart-product-dead">{$text.CART_PRODUCT_DEAD_TITLE}</p>
												{/if}
											</header>
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-4">
											{* Stock *}
											{if $settings.shop_product_delivery_time eq true}
												<p class="m-cart-product-delivery-time">{$cartProduct->DeliveryTimeTitle}</p>
											{/if}

											{* Weight *}
											{if $settings.shop_product_weight eq true && $cartProduct->Weight}
												<p class="m-cart-product-weight">
													<span class="m-cart-product-weight-text">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT}</span><span class="m-colon">:</span> <span class="m-cart-product-weight">{$cartProduct->Weight|formatNumber}</span> <span class="m-cart-product-weight-unit">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT}</span>
												</p>
											{/if}
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-4">
                                			{if $cartProduct->FullPrice != $cartProduct->Price}
                                				<s class="is-block m-cart-product-priceBeforeDiscount">{$cartProduct->FullPrice|formatPrice}</s>
                                			{/if}
                                			<span class="m-cart-product-price">{$cartProduct->Price|formatPrice}</span>
                                			{if $settings.shop_product_tax_after_price eq true}
                                				{if $hasVatIncludedLabel}
                                					<p class="m-cart-product-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                				{else}
                                					<p class="m-cart-product-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                				{/if}
                                			{/if}
										</div>
										<div class="col-s-4 col-m-3 col-l-3 col-xl-4">
											{if $cartProduct->Available}
												<fieldset class="form-group">
													<div class="input-group small">
														<input class="form-input input-group-main" type="text" name="cart[{$cartProduct->Key}][amount]" pattern="[0-9]*" value="{$cartProduct->Amount}">
														<span class="input-group-addon">{$cartProduct->UnitTitle}</span>
													</div>
												</fieldset>
											{/if}

											<fieldset class="form-group">
												{if $cartProduct->Available}
													<ul class="button-group small">
														<li>
															<a class="button" href="/actions/cart/minus?id={$cartProduct->Key}&{csrf type='get'}">{include file="modules/widgets/icon/icon.tpl" icon="minus"}</span></a>
														</li>
														<li>
															<a class="button" href="/actions/cart/plus?id={$cartProduct->Key}&{csrf type='get'}">{include file="modules/widgets/icon/icon.tpl" icon="plus"}</a>
														</li>
													</ul>
												{/if}
											</fieldset>

										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-6 cart-total-value">
											<strong class="is-block">
                                    			{if $cartProduct->FullPrice != $cartProduct->Price}
                                    				<s class="is-block m-cart-product-priceBeforeDiscount">{($cartProduct->Amount * $cartProduct->FullPrice)|formatPrice}</s>
                                    			{/if}
                                    			<span class="m-cart-product-price">{($cartProduct->Amount * $cartProduct->Price)|formatPrice}</span>
                                			</strong>
                                			{if $settings.shop_product_tax_after_price eq true}
                                				{if $hasVatIncludedLabel}
                                					<p class="m-cart-product-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                				{else}
                                					<p class="m-cart-product-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                				{/if}
                                			{/if}

                                			<a class="button-text" href="/actions/cart/remove?id={$cartProduct->Key}&{csrf type='get'}" title="{$text.DELETE}">{$text.DELETE}</a>
										</div>
									</div>
								</div>
							</article>

							{if ($cartProduct->Soldout && $cartProduct->AllowOutOfStockPurchase eq false) or !$cartProduct->Available}
								<div class="panel panel-danger" style="margin-bottom: 0;">
									<div class="panel-body">
										<i class="fa fa-exclamation-triangle"></i>
										<strong>
											{if $cartProduct->Available}
												<span class="m-cart-product-stock-limit">{$text.PRODUCT_CATALOG_NO_OEDER}</span>
											{else}
												<span class="m-cart-product-dead">{$text.CART_PRODUCT_DEAD_NOTE}</span>
											{/if}
										</strong>
									</div>
								</div>
							{/if}

							<div itemscope itemtype="http://schema.org/Offer">

                        	</div>
                        </li>
                    {/foreach}

                    {if isset($cartList.CartSalesLine)}
                        <li>
                        	<article class="row">
								<div class="col-s-1 col-m-1 col-l-1 col-xl-2 text-center"></div>
								<div class="col-s-3 col-m-11 col-l-11 col-xl-22">
									<div class="row">
										<div class="col-s-4 col-m-3 col-l-3 col-xl-6">
											<p class="m-cart-salesline-title h6">
												<span class="m-cart-salesline-title">{$cartList.CartSalesLine.0->Title}</span>
												<span class="m-cart-salesline-title-type">
													{if $cartList.CartSalesLine.0->DiscountType == 'percentage'}
														({$cartList.CartSalesLine.0->AmountRaw} %)
													{elseif $cartList.CartSalesLine.0->DiscountType == 'fixed'}
														({$cartList.CartSalesLine.0->Price|formatPrice})
													{/if}
												</span>
											</p>

											{if $settings.shop_product_number eq true && $cartList.CartSalesLine.0->ItemNumber}
												<p class="m-cart-salesline-number">
													<span class="m-cart-salesline-number-text">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER}</span> <span class="m-cart-salesline-number">{$cartList.CartSalesLine.0->ItemNumber}</span>
												</p>
											{/if}
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-4">
											<span class="m-cart-salesline-type">
												{if $cartList.CartSalesLine.0->DiscountMode == 'sale-discount'}
													{$text.DISCOUNT}
												{elseif $cartList.CartSalesLine.0->DiscountMode == 'sale-fee'}
													{$text.FEE}
												{/if}
											</span>
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-4">
											<span class="m-cart-salesline-price">{$cartList.CartSalesLine.0->Price|formatPrice}</span>
                                			{if $settings.shop_product_tax_after_price eq true}
                                				{if $currency.hasVat}
                                					<p class="m-cart-salesline-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                				{else}
                                					<p class="m-cart-salesline-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                				{/if}
                                			{/if}
										</div>
										<div class="col-s-4 col-m-3 col-l-3 col-xl-4">
											<p class="m-cart-salesline-amount">1 {$text.PEACES}</p>
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-6 cart-total-value">
											<strong class="is-block"><span class="m-cart-salesline-price">{$cartList.CartSalesLine.0->Price|formatPrice}</span></strong>
                                			{if $settings.shop_product_tax_after_price eq true}
                                				{if $currency.hasVat}
                                					<p class="m-cart-salesline-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                				{else}
                                					<p class="m-cart-salesline-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                				{/if}
                                			{/if}
										</div>
									</div>
								</div>
							</article>
                        </li>
                    {/if}

                    {if isset($cartList.CartCouponLine)}
                        <li>
                        	<article class="row">
								<div class="col-s-1 col-m-1 col-l-1 col-xl-2 text-center"></div>
								<div class="col-s-3 col-m-11 col-l-11 col-xl-22">
									<div class="row">
										<div class="col-s-4 col-m-3 col-l-3 col-xl-6">
											<p class="m-cart-coupon-title h6">
												<span class="m-cart-coupon-title">{$cartList.CartCouponLine.0->Title}</span>
												<span class="m-cart-coupon-title-type">
													{if $cartList.CartCouponLine.0->Type == 'procent'}
														({$cartList.CartCouponLine.0->Amount} <span class="m-percent">%</span>)
													{elseif $cartList.CartCouponLine.0->Type == 'amount'}
														({$cartList.CartCouponLine.0->Amount|formatPrice})
													{/if}
												</span>
											</p>
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-4">
											<span class="m-cart-coupon-type">{$text.SHOP_DISCOUNT_CODE}</span>
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-4">
											<span class="m-cart-coupon-price">{$cartList.CartCouponLine.0->Price|formatPrice}</span>
                                			{if $settings.shop_product_tax_after_price eq true}
                                				{if $currency.hasVat}
                                					<p class="m-cart-coupon-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                				{else}
                                					<p class="m-cart-coupon-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                				{/if}
                                			{/if}
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-4">
											<p>1 {$text.PEACES}</p>
										</div>
										<div class="col-s-4 col-m-2 col-l-2 col-xl-6 cart-total-value">
											<strong class="is-block"><span class="m-cart-coupon-price">{$cartList.CartCouponLine.0->Price|formatPrice}</span></strong>
                                			{if $settings.shop_product_tax_after_price eq true}
                                				{if $currency.hasVat}
                                					<p class="m-cart-coupon-price-with-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}</p>
                                				{else}
                                					<p class="m-cart-coupon-price-without-vat">{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}</p>
                                				{/if}
                                			{/if}

                                			<a class="button-text" href="/actions/cart/couponRemove?{csrf type='get'}" title="{$text.DELETE}">{$text.DELETE}</a>
										</div>
									</div>
								</div>
							</article>
                        </li>
                    {/if}
                </ul>
			</div>
		</div>

		<div class="row">
			<div class="col-s-4 col-m-7 col-l-7 col-xl-12 cart-utilities-container">

				<div class="cart-utilities">

					<div class="cart-utility-actions">
						<button type="submit" class="button small trailing-db-mobile">{$text.CART_UPDATE}</button>
						<a class="button small trailing-db-mobile" href="/actions/cart/empty?{csrf type='get'}"></i> {$text.CART_EMPTY}</a>
                    </div>

					{if $settings.module_shop_wishlist eq true and $access.wishlist}
                        <a class="cart-link-addto-wishlist button-text trailing-db-mobile" href="/actions/wishlist/transferCart?{csrf type='get'}"><i class="fa fa-gift"></i> {$text.WISHLIST_TRANSFER_CART}</a>
					{/if}
				</div>
			</div>

			<div class="col-s-4 col-m-5 col-l-5 col-xl-10 col-xl-offset-2 m-cart-delivery-info-container">
				<div class="row">
					<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
						<table class="table">
							<tbody>
								{if isset($cartList.CartDeliveryEstimateLine)}
									<tr class="m-cart-delivery-estimate-line m-tr">
										<td class="text-left"><span class="m-cart-delivery-title">{$text.CART_DELIVERY_FROM}</span></td>
										<td class="text-right">
											<span class="m-cart-delivery-price">{$cartList.CartDeliveryEstimateLine.0->Price|formatPrice}</span>
										</td>
									</tr>
								{/if}
								{if isset($cartList.CartSubTotalLine)}
									<tr class="m-cart-sub-total-line m-tr">
										<td class="text-left"><span class="m-cart-subtotal-title">{$text.CART_PRICE_SUM}</span></td>
										<td class="text-right">
											<span class="m-cart-subtotal-price">{$cartList.CartSubTotalLine.0->Price|formatPrice}</span>
										</td>
									</tr>
								{/if}
								{if isset($cartList.CartVatTotalLine)}
									<tr class="m-cart-vat-total-line m-tr">
										<td class="text-left">
											<span class="m-cart-vat-title">
												{if $currency.hasVat}
													{$text.CART_VAT_INCLUSIVE}
												{else}
													{$text.CART_VAT_EXCLUSIVE}
												{/if}
											</span>
										</td>
										<td class="text-right">
											<span class="m-cart-vat-price" itemprop="tax">{$cartList.CartVatTotalLine.0->Price|formatPrice}</span>
										</td>
									</tr>
								{/if}
							</tbody>
							<tfoot>
								{if isset($cartList.CartTotalLine)}
									<tr class="m-cart-total-line m-tr">
										<td class="text-left">
											<span class="m-cart-total-title"><strong>{$text.CART_TOTAL}</strong></span>
										</td>
										<td class="text-right">
											<span class="m-cart-total-price" itemprop="total"><strong>{$cartList.CartTotalLine.0->Price|formatPrice}</strong></span>
		                                    {* Viabill price tag *}
		                                    {include file="modules/widgets/integrations/viabill_pricetag.tpl" type="basket" price=$cartList.CartTotalLine.0->Price}
										</td>
									</tr>
			                    {/if}

								<tr>
									<td colspan="2">
						                {include file='modules/widgets/paymenticons/paymenticons.tpl'}
									</td>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
		</div>
	</form>
	<div class="row trailing-trip m-cart-coupon-row">
		<div class="col-s-4 col-m-6 col-l-6 col-xl-8">
			{if ($access.discountCode or $access.giftCard) and $settings.module_shop_discount_codes and !isset($cartList.CartCouponLine)}
				<form method="post" action="/actions/cart/couponAdd">
                    {csrf type="input"}
					<p class="m-cart-coupon-input-text">
						{$text.SHOP_DISCOUNT_CODE_HEADLINE}<br/>
						<span>{$text.SHOP_DISCOUNT_CODE_TEXT}</span>
					</p>
					<fieldset class="form-group trailing-db-mobile">
					    <div class="input-group small">
					        <input type="text" name="coupon" class="form-input input-group-main" placeholder='{$text.SHOP_DISCOUNT_CODE_CONFIRM}'>
					        <span class="input-group-button"><button type="submit" class="button">{$text.UPDATE}</button></span>
					    </div>
					</fieldset>
				</form>
			{/if}
		</div>
		<div class="col-s-4 col-m-6 col-l-6 col-xl-12 col-xl-offset-4 text-right">
			<div class="form group trailing-db">
				<a class="button-primary large" href="{if !$cartblock}/{$cartLink}/{else}#{/if}">{$text.CHECKOUT_MENU}</a>
				{if $cartblock}
					<div class="m-cart-order-warning">
						<i class="fa fa-exclamation-triangle"></i>
						<span><small>{$text.CART_DEAD}</small></span>
					</div>
				{/if}
				{include file='modules/widgets/checkout/checkout.tpl'}
			</div>
			<div class="form group trailing-db">
				<a class="button small" href="{$page.lastPath}">{$text.CART_BUY_MORE}</a>
			</div>
		</div>
	</div>

{else}
    <header class="m-cart-header page-title">
        <h1 class="m-cart-headline" itemprop="name">{$text.CART_HEADLINE}</h1>
    </header>

    <div class="panel panel-warning">
        <div class="panel-body">
           <span>{$text.CART_IS_EMPTY}</span>
        </div>
    </div>
{/if}
</div>

{collection assign=focusProducts controller=productList focus=cart}
{if $focusProducts->getActualSize() gt 0}
    <div class="cart-content">
    	<div class="page-title">
            <p class="h1">{$text.PRODUCT_CATALOG_FOCUS_CART_HEADLINE}</p>
        </div>
        <div>
	        {include file='modules/product/product-list-combined.tpl' productlist=$focusProducts->filter('Sorting,Title') onlyProducts=true}
        </div>
    </div>
{/if}

{if isset($cartProductList['CartProductLine'])}
	{$opengraph_title = $text.CART_HEADLINE}
{else}
	{$opengraph_title = "{$text.CART_HEADLINE} - {$text.CART_HEADLINE}"}
{/if}

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
