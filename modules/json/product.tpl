{*************************** DEPRECATED ****************************}
{*** THIS FILE IS DEPRECATED, REFER TO json/products.tpl INSTEAD ***}
{*******************************************************************}


{if isset($id)}
	{$productids = $id}
{elseif !empty($request.args.0)}
	{$productids = $request.args.0}
{else}
	{$productids = $request.verb}
{/if}

{if !empty($productids)}
	{controller assign=controller type=product}
	{controller assign=categoryController type=productCategory}
	{controller assign=reviewController type=productReview}

	{collection assign=products controller=$controller productId=$productids}
	{$products = $products->getData()}

	{$imageWidth = 293}
	{if $request.input.imageWidth}
		{$imageWidth = $request.input.imageWidth}
	{/if}

	{$imageHeight = 293}
	{if $request.input.imageHeight}
		{$imageHeight = $request.input.imageHeight}
	{/if}

	{$imageCrop = 'fill'}
	{if $request.input.imageCrop}
		{$imageCrop = $request.input.imageCrop}
	{elseif !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
		{$imageCrop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
	{/if}

	{$pageLink = PageController::link($page.productPageId)}

	{$output = []}

	{foreach $products as $k => $product}

		{* Legacy *}
		{$product['PaymentOptions'] = []}

		{$product['BuyingPrice'] = false}

		{if $access.reviews}
			{$product['AverageRating'] = $reviewController->getAverageRating($product.Id)}
		{else}
			{$product['AverageRating'] = false}
		{/if}

		{$brandTitle = null}
		{$brandLink = null}
		{if !empty($product.ProducerId)}
			{entity assign=brand controller=brand id=$product.ProducerId}
			{if $brand}
				{$brandTitle = $brand->Title}

				{$catalogLink = PageController::link($page.productPageId)}
				{$brandTitleLink = $brandTitle|formatLink}
				{$brandLink = $catalogLink|cat:'?brand='|cat:$brand->Id|cat:'-'|cat:$brandTitleLink}
			{/if}
		{/if}
		{$product['ProducerTitle'] = $brandTitle}
		{$product['ProducerHandle'] = $brandLink}

		{$product['Images'] = []}
		{collection assign=images controller=files type=product productId=$product.Id}
		{if $images->getActualSize() gt 0}
			{foreach $images->getData() as $image}
				{$product['Images'][] = $image->thumbnail($imageWidth, $imageHeight, $imageCrop)}
			{/foreach}
		{else}
			{placeholdImage assign=placeholder width=$imageWidth height=$imageHeight background=$template.settings.DESIGN_IMAGE_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}
			{$product['Images'][] = $placeholder->getRelativeFile()}
		{/if}

		{$product['UnitTitle'] = $controller->getUnitTitle($product.UnitId)}

		{$product['Handle'] = ProductController::link($product.Id, false, $product)}

		{$product['DescriptionList'] = $controller->getDescriptionList($product.Id)}

		{$stocktext = null}
		{$stocktextSoldout = null}
		{if $product.DeliveryTimeId gt 0}
			{$stocktextSoldout = $controller->getDeliveryTime($product.DeliveryTimeId, false)}
			{$stocktext = $controller->getDeliveryTime($product.DeliveryTimeId)}
		{else}
			{$stocktextSoldout = $text.PRODUCT_CATALOG_STOCK_NOT_HOME}
			{$stocktext = $text.PRODUCT_CATALOG_STOCK_HOME}
		{/if}
		{$product['DeliveryTimeTexts'] = [
			'inStock' => $stocktext,
			'notInStock' => $stocktextSoldout
		]}

		{if $product.Soldout}
			{$product['DeliveryTimeText'] = $stocktextSoldout}
		{else}
			{$product['DeliveryTimeText'] = $stocktext}
		{/if}

		{collection assign=variantTypes controller=productVariantType productId=$product.Id}
		{$product['VariantTypes'] = $variantTypes->getData()}

		{collection assign=additionals controller=productAdditionalType productId=$product.Id}
		{$product['AdditionalTypes'] = $additionals->getData()}

		{* Visible price *}
		{setting assign=priceSetting key=shop_b2b_hidden_prices}

		{$showPrices = true}
		{if $product.CallForPrice or in_array($product.Type, ["giftcard","codegiftcard","discontinued"]) or ($priceSetting === true and empty($user))}
			{$showPrices = false}
		{/if}

		{$product['ShowPrices'] = $showPrices}

		{* Buyable *}
		{$buyable = $product.ShowPrices}

		{if $buyable}
			{if $product.Type != 'normal' and $product.Type != 'variant'}
				{$buyable = false}

			{elseif !empty($product.AdditionalTypes)}
				{$buyable = false}

			{elseif !$product.AllowOutOfStockPurchase and $product.Soldout}
				{$buyable = false}

			{elseif $priceSetting === 'partly' and empty($user)}
				{$buyable = false}

			{elseif $product.CallForPrice}
				{$buyable = false}

			{elseif $product.Type eq 'variant' and $product.VariantDisplayMode == 'orderlist'}
				{$buyable = false}
			{/if}
		{/if}

		{$product['Buyable'] = $buyable}

		{$output[] = $product}
	{/foreach}

	{$output|jsonify}
{else}
	[]
{/if}
