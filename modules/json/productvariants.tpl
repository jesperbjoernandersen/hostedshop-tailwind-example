{$output = []}

{if $request.method eq 'GET'}

	{$productId = $request.args.0}

	{entity assign=product controller=product productId=$productId}

	{if $product}

		{controller assign=controller type=productVariant}

		{if $request.verb eq 'types'}

			{* List all the types of the requested product *}
			{collection assign=types controller=productVariantType productId=$product->Id}
			{$output = $types->getData()}

		{elseif $request.verb eq 'data'}

			{$options['productId'] = $product->Id}

			{if !empty($request.input.typeId)}
				{$options['typeId'] = $request.input.typeId}
			{/if}

			{if !empty($request.input.dataIds)}
				{$options['dataIds'] = explode(',', $request.input.dataIds)}
			{/if}

			{collection assign=datas controller=productVariantData options=$options}

			{* Preload related entities to optimize load times *}
			{include file='modules/json/productvariants-data-preload.tpl' scope=parent}

			{foreach $datas->getData() as $data}

				{$soldout = false}

				{* If the product itself does not allow out of stock purchase, then we need to check up on all possible variant combinations *}
				{if !$product->AllowOutOfStockPurchase}

					{$dataIds = []}

					{if isset($options['dataIds'])}
						{$dataIds = $options['dataIds']}
					{/if}

					{$dataIds[] = $data->Id}

					{* Find all possible variant combinations by providing product ID and data IDS *}
					{collection assign=variants controller=$controller productId=$product->Id dataIds=$dataIds}

					{$soldout = true}

					{foreach $variants->getData() as $variant}
						{if $variant->Stock >= $variant->MinAmount}
							{$soldout = false}
							{break}
						{/if}
					{/foreach}

				{/if}

				{$data['Soldout'] = $soldout}
				{$data['disabled'] = $soldout}

				{* Primary icon image of data attribute *}
				{entity assign=file controller=files type=variantdata id=$data.Id}
				{$icon = null}
				{if $file}
					{$icon = $file->getRelativeFile()}
				{/if}
				{$data['Icon'] = $icon}

				{* The data attribute itself does not contain any stock information, but follows the requested product true and through *}
				{$data['AllowOutOfStockPurchase'] = $product->AllowOutOfStockPurchase}

				{$output[] = $data}
			{/foreach}

		{else}

			{$variants = []}

			{$options['productId'] = $product->Id}

			{if !empty($request.input.dataIds)}
				{$options['dataIds'] = explode(',', $request.input.dataIds)}
			{/if}

			{collection assign=variantData controller=$controller options=$options}

			{collection assign=types controller=productVariantType productId=$product->Id}

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

			{* Preload related entities to optimize load times *}
			{include file='modules/json/productvariants-dataids-preload.tpl' scope=parent}

			{foreach $variantData->getData() as $variant}

				{$variant = (array)$variant}

				{* Stock reservation calculation *}
				{$variant['StockWithoutReservation'] = $variant['Stock']}
				{$variant['Stock'] = $variant['Stock'] - $variant['StockReservation']}

				{* Allow out of stock purchase *}
				{$variant['AllowOutOfStockPurchase'] = $product->AllowOutOfStockPurchase}

				{* Find the main picture *}
				{$picture = null}

				{entity assign=picture controller=files type=variant productId=$product->Id variantId=$variant.Id}
				{if $picture}
					{$picture = $picture->thumbnail($imageWidth, $imageHeight, $imageCrop)}
				{/if}

				{$variant['Picture'] = $picture}

				{* We need to iterate all the types and their data in order to generate a combination of titles *}
				{$titleCombination = []}
				{$dataTitleCombination = []}

				{* Iterate the types *}
				{foreach $types->getData() as $type}

					{* Get the data associated with the specific type on the specific variant *}
					{collection assign=datas controller=productVariantData productId=$product->Id variantId=$variant.Id typeId=$type->Id}

					{* Iterate the data to establish the title combination *}
					{foreach $datas->getData() as $data}

						{entity assign=file controller=files type=variantdata id=$data->Id}
						{$icon = null}
						{if $file}
							{$icon = $file->getRelativeFile()}
						{/if}
						{$data['Icon'] = $icon}

						{$title = $data.Title}
						{$titleCombination[] = [$type->Title, $title, $data.Color, $data.Icon]}
						{$dataTitleCombination[] = $title}

						{$type['Data'][] = $data}

					{/foreach}

					{$variant['Types'][] = $type}

				{/foreach}

				{* Assign the title combination type => data to the variant *}
				{$variant['TitleCombination'] = $titleCombination}

				{* Assert the final title of the variant by concatenating the data titles *}
				{$variant['Title'] = implode(' / ', $dataTitleCombination)}

				{* Assign descriptions *}
				{$variant['Description'] = $controller->getDescription($variant['Id'])}
				{$variant['DescriptionShort'] = $controller->getDescriptionShort($variant['Id'])}

				{* Establish if the variant is soldout, thus rendering it disabled *}
				{$soldout = false}
				{if $variant.Stock <= 0 or $variant.Stock lt $variant.MinAmount}
					{$soldout = true}
				{/if}
				{$variant['Soldout'] = $soldout}

				{* Price calculation *}
				{collection assign=prices controller=productPrice productId=$product->Id variantId=$variant.Id productDiscountGroupId=$product->DiscountGroupId}
				{$variant['Prices'] = $prices->getData()}
				{$price = null}
				{if !empty($variant.Prices[0])}
					{$price = $variant.Prices[0]}
				{/if}
				{$variant['Price'] = $price}

				{* Legacy *}
				{$variant['PaymentOptions'] = []}

				{* Delivery text *}
				{$stocktext = null}
				{if $variant.DeliveryTimeId gt 0}
					{if $variant.Soldout}
						{$stocktext = $controller->getDeliveryTime($variant.DeliveryTimeId, false)}
					{else}
						{$stocktext = $controller->getDeliveryTime($variant.DeliveryTimeId)}
					{/if}
				{else}
					{if $variant.Soldout}
						{$stocktext = $text.PRODUCT_CATALOG_STOCK_NOT_HOME}
					{else}
						{$stocktext = $text.PRODUCT_CATALOG_STOCK_HOME}
					{/if}
				{/if}
				{$variant['DeliveryTimeText'] = $stocktext}

				{* Unit title *}
				{$variant['UnitTitle'] = $controller->getUnitTitle($variant.UnitId)}


				{* Buyable *}
				{$buyable = true}

				{if !$variant.AllowOutOfStockPurchase and $variant.Soldout}
					{$buyable = false}
				{/if}

				{$variant['Buyable'] = $buyable}
				{$variant['disabled'] = !$buyable}
				{$variant['Disabled'] = !$buyable}


				{$variants[] = $variant}

			{/foreach}

			{$output['data'] = $variants}
			{$output['count'] = $variants|count}

		{/if}
	{/if}
{/if}

{$output|jsonify}
