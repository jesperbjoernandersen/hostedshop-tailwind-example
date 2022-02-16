{*

# Description
Template for single product in the product lists. Part of the Product page type.


## Date last modified
2020-10-05


## Primary variables
+ $item 													- The instance of the product to be shown
+ $related  												- (Optional) Boolean telling if list consists
+ $controller 												- Instance of productController
+ $product 													- Entity of productController (a single shop product)
+ $priceInterval 											- Entity of productPriceController (price lines for selected product)
+ $reviewcontroller 										- Instance of productReviewController
+ $image 													- Entity of filesController with type product (the first image for a product)
+ $brand 													- Entity of brandController


## Partials (templates)
No extra templates required for this template

*}

{if !isset($related)}
	{$related = false}
{/if}

{controller type=product assign=controller}
{entity assign=priceInterval controller=productPrice productId=$product->Id}
{controller assign=reviewcontroller type=productReview primary=true}

{$pagelink = {page id=$product->PageId print=Link}}
{$handle = ProductController::link($product->Id, false, $product)}
{$unitTitle = $controller->getUnitTitle($product->UnitId)}
{$showPrices = !in_array($product->Type, ["giftcard","codegiftcard","discontinued"]) and (!empty($user) or $settings.shop_b2b_hidden_prices === false)}

{if !isset($itemClass)}
	{$itemClass = "col-s-4 col-m-12 col-l-12 col-xl-24"}
{/if}

<div class="productItem {$itemClass} productItem{$product->Id} m-productlist-item m-productlist-item-{$product->Id}">
	<article class="productContent m-productlist-wrap type-row">
		<div class="row">
			<div class="col-s-4 col-m-12 col-l-4 col-xl-8">
				{* Product image wrapper *}
				<figure class="m-productlist-figure image">

					{* Product splashes, news, discount and sold out *}
					{if $settings.show_product_icons}
					<div class="splash m-productlist-splash m-product-splash">

						{* NEW icon if newer than 30 days (2.592.000 seconds) *}
						{if $product->Age lt 2592000}
							<span class="badge badge-succes m-productlist-splash-new m-product-splash-new">{$text.NEWS}</span>
						{/if}

						{* DISCOUNT icon if discount is active *}
						{if $showPrices and $priceInterval and $priceInterval->PriceMin lt $priceInterval->FullPriceMin}
							<span class="badge badge-warning m-productlist-splash-sale m-product-splash-sale">{$text.SALE}</span>
						{/if}

						{* SOLD OUT icon if not in stock *}
						{if $product->Type === "discontinued" or ($product->Soldout and !$product->AllowOutOfStockPurchase)}
							<span class="badge badge-danger m-productlist-splash-soldout m-product-splash-soldout">{$text.SOLD_OUT}</span>
						{/if}
					</div>
					{/if}

					{* Product image *}
					<a href="{$handle}" class="m-productlist-link trailing-db placeholder-wrapper" data-placeholder-max-width="{$imageWidth}px" title="{$product->Title}">
						{$imageWidth  = 293}
						{$imageHeight = 293}
						{entity assign=image controller=files type=shop productId=$product->Id}
						{controller type=files assign=imageController}
						{if $image}
							{$crop = "fill"}
                            {if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
                                {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
                            {/if}
							{$imgPath = $image->thumbnail($imageWidth, $imageHeight, $crop)}
						{else}
							{placeholdImage assign=placeholder width=$imageWidth height=$imageHeight background=$template.settings.DESIGN_IMAGE_BACKGROUND_COLOR color=$template.settings.FONT_COLOR_PRIMARY text=$text.IMAGE_PLACEHOLDER_TEXT}
							{$imgPath = $placeholder->getRelativeFile()}
						{/if}
						<span class="placeholder"></span>
						{$imageAlt = $imageController->getTranslation($image->Id, "title")}
						{img class="responsive m-productlist-image" src="{$imgPath|solutionPath}" alt="{if empty($imageAlt)}{$product->Title}{else}{$imageAlt}{/if}"}
					</a>
				</figure>
			</div>

			<div class="col-s-4 col-m-12 col-l-4 col-xl-8">
				{* Title of Product *}
				<header class="title m-productlist-heading">
					<a href="{$handle}" class="is-block m-productlist-link">
						<h4 class="h4 m-productlist-title">{$product->Title}</h4>
					</a>

					{* Brand of Product *}
					{entity assign=brand controller=brand id=$product->ProducerId}
					{if $brand and !empty($brand->Title)}
					<a href="/{$page.paths.0}/?brand={$brand->Id}-{$brand->Title|formatLink}" class="m-productlist-brand-link">
						<span class="is-block m-productlist-brand">{$brand->Title}</span>
					</a>
					{/if}

					{* Model *}
					{if $settings.shop_product_number and isset($product->ItemNumber)}
						<p class="m-productlist-itemNumber">{$product->ItemNumber}</p>
					{/if}
				</header>

				{* Short description *}
				{$description = $controller->getDescriptionList($product->Id)}
				{if $description}
					<div class="description m-productlist-description">
						<hr class="m-productlist-description-separator">
						<div class="short-description m-productlist-short-description">{$description}</div>
					</div>
				{/if}

				{* Stock status *}
				{if $settings.shop_product_delivery_time and $settings.shop_product_delivery_time_list}
					<div class="product-delivery m-productlist-stock">
						<hr class="m-productlist-delivery-separator">
						<p class="m-productlist-stock-text">

							{if $product->DeliveryTimeId <= 0}
								{if $product->Soldout}
									<i class="fa fa-fw fa-clock-o"></i>
									{$text.PRODUCT_CATALOG_STOCK_NOT_HOME}
								{else}
									<i class="fa fa-fw fa-check"></i>
									{$text.PRODUCT_CATALOG_STOCK_HOME}
									{if $product->DeliveryTimeId == 0 and $product->Stock and !in_array($product->Type, ["variant","packet"])}
										({$product->Stock} {$unitTitle})
									{/if}
								{/if}
							{else}
								{if $product->Soldout}
									<i class="fa fa-fw fa-clock-o"></i>
									{$controller->getDeliveryTime($product->DeliveryTimeId, false)}
								{else}
									<i class="fa fa-fw fa-check"></i>
									{$controller->getDeliveryTime($product->DeliveryTimeId, true)}
								{/if}
							{/if}
						</p>
					</div>
				{/if}

				{* Rating visually made with FontAwesome *}
				{if $settings.module_shop_review_products}
					{$avgRating = $reviewcontroller->getAverageRating($product->Id)}
					{collection assign=reviews controller=$reviewcontroller productId=$product->Id}
					<div class="product-rating m-productlist-rating">
						<hr>
						{* Rating loop *}
						<div class="m-reviews-stars trailing-db">
							{section name=rating loop=6 start=1}
								<i class="fa fa-fw fa-star{if $smarty.section.rating.index > $avgRating}-o{/if}"></i>
							{/section}
						</div>
					</div>
				{/if}
			</div>

			<div class="col-s-4 col-m-12 col-l-4 col-xl-8 m-productlist-offer l-default-height">
				<div class="product-transaction panel panel-border">
					<div class="panel-body">
						<div class="product-action m-productlist-transactions">
							{if $showPrices}
								{if $product->CallForPrice}
									<p><span class="h3">{$text.PRODUCT_CATALOG_CALL_FOR_PRICE}</span></p>
								{else}
									{* Price calculation of Product *}
									<div>

										{* Discount price *}
										{if $priceInterval->PriceMin lt $priceInterval->FullPriceMin}
								    	<p>
								    		{* Price before discount *}
								    		<s>
								    			{$priceInterval->FullPriceMin|formatPrice}
									    		{* Pieces *}
									    		{if $priceInterval->Amount gt 1}
									    			{$text.OF} {$priceInterval->Amount} {$unitTitle}
									    		{/if}
								    		</s>
								    	</p>
								    	{/if}

								    	{* Price *}
								    	<p>
								    		<span class="h3">
								    			{* Price from *}
								    			{if $priceInterval->PriceMin != $priceInterval->PriceMax}
								    				{$text.PRODUCT_CATALOG_PRICE_FROM}
								    			{/if}

								    			<span class="m-productlist-price">{$priceInterval->PriceMin|formatPrice}</span>

									    		{* Pieces *}
									    		{if $priceInterval->Amount gt 1}
									    			{$text.OF} {$priceInterval->Amount} {$unitTitle}
									    		{/if}
								    		</span>
								    	</p>

							    		{* VAT *}
							    		{if $settings.shop_product_tax_after_price}
							    			<span class="is-block">
							    				{if $currency.hasVat and ($settings.vat_label_advanced eq false or $priceDataInterval->PriceMinWithVat gt $priceDataInterval->PriceMinWithoutVat)}
							    					{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
							    				{else}
							    					{$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
							    				{/if}
							    			</span>
							    		{/if}
									</div>
								{/if}
							{/if}

							{* Call-to-action *}
							<fieldset class="form-group">
								<a href="{$handle}" class="button-primary is-block">{$text.PRODUCT_CATALOG_PRODUCT_SHOW}</a>
							</fieldset>
						</div>
					</div>
	        	</div>
			</div>
		</div>
	</article>
</div>
