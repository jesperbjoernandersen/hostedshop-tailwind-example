{$output = []}

	{collection controller=cart assign=cart}
	{$cartProductList = $cart->groupByClass('CartProductLine')}
	{$cartList = $cart->groupByClass()}

	{*** Eager loading ***}
	{include file='modules/cart/cart-preload.tpl' scope=parent}

	{placeholdImage assign=placeholder width=71 height=71 background=$template.settings.DESIGN_BOX_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}

	{if isset($cartProductList['CartProductLine'])}

		{$cartblock = false}
		{foreach $cartList.CartProductLine as $cartProduct}
			{if ($cartProduct->Soldout && $cartProduct->AllowOutOfStockPurchase eq false) or !$cartProduct->Available}
				{$cartblock = true}
			{/if}
		{/foreach}

		{$pageLink = PageController::link($page.productPageId)}

	    {foreach $cartList.CartProductLine as $k => $cartProduct}

			{$cartProduct = (array)$cartProduct}

	        {entity assign=product controller=product type=product id=$cartProduct.ProductId}
	        {entity assign=productImage controller=files type=product productId=$cartProduct.ProductId}

	        {$cartProduct['Title'] = $product->Title}

			{$categoryTitle = null}
			{if !empty($product->CategoryId)}
				{entity assign=category controller=productCategory id=$product->CategoryId}
				{if $category}
					{$categoryTitle = $category->Title}
				{/if}
			{/if}
			{$cartProduct['CategoryTitle'] = $categoryTitle}

			{$brandTitle = null}
			{$brandLink = null}
			{if !empty($product->ProducerId)}
				{entity assign=brand controller=brand id=$product->ProducerId}
				{if $brand}
					{$brandTitle = $brand->Title}

					{$brandTitleLink = $brandTitle|formatLink}
					{$brandLink = $pageLink|cat:'?brand='|cat:$brand->Id|cat:'-'|cat:$brandTitleLink}
				{/if}
			{/if}
			{$cartProduct['ProducerTitle'] = $brandTitle}
			{$cartProduct['ProducerHandle'] = $brandLink}


	        {$cartProduct['UserDiscount'] = $cartProduct['UserDiscount']}

			{$cartProduct['VariantTitle'] = ''}
	        {if $cartProduct.VariantId}
	        	{collection assign=variantDatas controller=productVariantData productId=$cartProduct.ProductId variantId=$cartProduct.VariantId}

	        	{foreach $variantDatas->getData() as $variantData}
	        		{$cartProduct['VariantTitle'] = $cartProduct['VariantTitle']|cat:" "|cat:$variantData->Title}
				{/foreach}

	        	{entity assign=variantImage controller=files type=variant variantId=$cartProduct.VariantId}
	        {/if}

	        {if $cartProduct.VariantId && $variantImage}
	        	{$cartProduct['CartImage'] = $variantImage->thumbnail(71, 71)|solutionPath}
	        {elseif $productImage}
	        	{$cartProduct['CartImage'] = $productImage->thumbnail(71, 71)|solutionPath}
	        {else}
	            {$cartProduct['CartImage'] = $placeholder->getRelativeFile()|solutionPath}
	        {/if}

			{if $cartProduct['Available']}

				{if $cartProduct.Additionals}
					{foreach $cartProduct.Additionals as $key => $additionalType}
						{entity assign=additionalTypeData controller=productAdditionalType id=$key}

						{$cartProduct['AdditionalTypeTitle'] = $additionalTypeData->Title}

							{foreach $additionalType as $additional}
								{$cartProduct['AdditionalsTitle'] = $additional->Title}
								{if $additional->Price}
									{$cartProduct['AdditionalsPrice'] = $additional->Price}
								{/if}
							{/foreach}
					{/foreach}

				{/if}

				{if $cartProduct.Giftcard}
					{$cartProduct['GiftcardName'] = $cartProduct.Giftcard->Name}
				{/if}

				{if $settings.shop_product_number eq true && $cartProduct.ItemNumber}
					{$cartProduct['ItemNumber'] = $cartProduct.ItemNumber}
				{/if}
			{else}
				{$cartProduct['AvailabilityText'] = $text.CART_PRODUCT_DEAD_TITLE}
			{/if}


			{if $settings.shop_product_delivery_time eq true}
				{$cartProduct['DeliveryTimeTitle'] = $cartProduct.DeliveryTimeTitle}
			{/if}

			{if $settings.shop_product_weight eq true && $cartProduct.Weight}
				{$cartProduct['ProductWeight'] = $cartProduct.Weight|formatNumber}
			{/if}

			{if $cartProduct['Available']}
				{$cartProduct['Key'] = $cartProduct['Key']}
				{$cartProduct['Amount'] = $cartProduct['Amount']}
				{$cartProduct['UnitTitle'] = $cartProduct['UnitTitle']}
			{/if}

			{$cartProduct['CartBlocker'] = false}
			{if ($cartProduct['Soldout'] && $cartProduct['AllowOutOfStockPurchase'] eq false) or $cartProduct['Available'] eq false}
					{$cartProduct['CartBlocker'] = true}
				{if $cartProduct['Available']}
					{$cartProduct['StockText'] = $text.PRODUCT_CATALOG_NO_OEDER}
				{else}
					{$cartProduct['StockText'] = $text.CART_PRODUCT_DEAD_NOTE}
				{/if}
			{/if}

			{$output[] = $cartProduct}

		{/foreach}

		{if isset($cartList.CartSalesLine)}
			{$cartSalesLine['Title'] = $cartList.CartSalesLine.0->Title}

			{if $cartList.CartSalesLine.0->DiscountType == 'percentage'}
				{$cartSalesLine['DiscountType'] = $cartList.CartSalesLine.0->AmountRaw}
			{elseif $cartList.CartSalesLine.0->DiscountType == 'fixed'}
				{$cartSalesLine['DiscountType'] = $cartList.CartSalesLine.0->Price}
			{/if}

			{if $settings.shop_product_number eq true && $cartList.CartSalesLine.0->ItemNumber}
				{$cartSalesLine['ItemNumber'] = $cartList.CartSalesLine.0->ItemNumber}
			{/if}

			{if $cartList.CartSalesLine.0->DiscountMode == 'sale-discount'}
				{$cartSalesLine['DiscountMode'] = $text.DISCOUNT}
			{elseif $cartList.CartSalesLine.0->DiscountMode == 'sale-fee'}
				{$cartSalesLine['DiscountMode'] = $text.FEE}
			{/if}

			{$cartSalesLine['Price'] = $cartList.CartSalesLine.0->Price}

			{if $settings.shop_product_tax_after_price eq true}
				{if $currency.hasVat}
					{$cartSalesLine['PriceVAT'] = $text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
				{else}
					{$cartSalesLine['PriceVAT'] = $text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
				{/if}
			{/if}
        {/if}

        {if isset($cartList.CartCouponLine)}
            {$cartCouponLine['Title'] = $cartList.CartCouponLine.0->Title}

			{if $cartList.CartCouponLine.0->Type == 'procent'}
				{$cartCouponLine['Type'] = $cartList.CartCouponLine.0->Amount}
			{elseif $cartList.CartCouponLine.0->Type == 'amount'}
				{$cartCouponLine['Type'] = $cartList.CartCouponLine.0->Amount}
			{/if}

			{$cartCouponLine['Price'] = $cartList.CartCouponLine.0->Price}

			{if $settings.shop_product_tax_after_price eq true}
				{if $currency.hasVat}
					{$cartCouponLine['PriceVAT'] = $text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
				{else}
					{$cartCouponLine['PriceVAT'] = $text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
				{/if}
			{/if}
		{/if}

			{$wishlist = null}
			{if $settings.module_shop_wishlist eq true and $access.wishlist}
				{$wishlist = true}
			{/if}

			{$cartSubTotalPrice = null}
			{if isset($cartList.CartSubTotalLine)}
				{$cartSubTotalPrice = $cartList.CartSubTotalLine.0->Price}
			{/if}

			{$cartVatTotal = null}
			{if isset($cartList.CartVatTotalLine)}
				{if $currency.hasVat}
					{$cartVatTotal = $text.CART_VAT_INCLUSIVE}
				{else}
					{$cartVatTotal = $text.CART_VAT_EXCLUSIVE}
				{/if}

				{$cartVatPrice = $cartList.CartVatTotalLine.0->Price}

			{/if}

			{$cartTotalLinePrice = null}
			{if isset($cartList.CartTotalLine)}
				{$cartTotalLinePrice = $cartList.CartTotalLine.0->Price}
		    {/if}

		{$discountCode = null}
		{if ($access.discountCode or $access.giftCard) and $settings.module_shop_discount_codes and !isset($cartList.CartCouponLine)}
			{$discountCode = true}
		{/if}
	{/if}

{$output = [
	'CartProduct' => $output,
	'CartSalesLine' => $cartSalesLine,
	'CartProductCount' => $cart->getActualSize(),
	'CartCouponLine' => $cartCouponLine,
	'Wishlist' => $wishlist,
	'CartSubTotalPrice' => $cartSubTotalPrice,
	'CartVatTotal' => $cartVatTotal,
	'CartVatPrice' => $cartVatPrice,
	'CartTotalLinePrice' => $cartTotalLinePrice,
	'DiscountCode' => $discountCode,
	'CartBlock' => $cartblock
]}

{$output|jsonify}
