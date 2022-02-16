{*

# Description
AngularJS template for product row display mode. Part of the Product page type.
The template uses [Select2](http://ivaynberg.github.io/select2/) to generate the dropdowns.


## Date last modified
2021-06-18


## Resource
+ [AngularJS](https://angularjs.org/)
+ [Select2](http://ivaynberg.github.io/select2/)


## Primary variables
+ product                                            		- Single product entity
+ text                                                      - Javascript version of Smarty $text with an array of translations


## Partials (templates)
No extra templates required for this template

*}

{literal}
<article class="productContent list-js-row m-productlist-item">

	<form method="post" action="/actions/cart/add">

		<input type="hidden" name="returnUrl" data-ng-value="returnUrl">

		<div class="row">

			<div class="col-s-4 col-m-4 col-l-4 col-xl-8">

				<figure class="image m-productlist-figure">

					<!-- Product splashes, news, discount and sold out -->
					<div class="splash m-productlist-splash" data-ng-show="::settings.show_product_icons">

						<!-- NEW icon if newer than 30 days (2.592.000 seconds) -->
						<span class="badge badge-succes m-productlist-splash-new" data-ng-if="::isNew" data-ng-bind-html="::text.NEWS"></span>

						<!-- DISCOUNT icon if discount it active -->
						<span class="badge badge-warning m-productlist-splash-sale" data-ng-if="onSale" data-ng-bind-html="::text.SALE"></span>

						<!-- SOLD OUT icon if not in stock -->
						<span class="badge badge-danger m-productlist-splash-soldout" data-ng-if="soldout" data-ng-bind-html="::text.SOLD_OUT"></span>
					</div>

					<!-- Product image -->
					<a data-ng-href="{{product.Handle}}" class="m-productlist-link trailing-db text-center">
						<span data-ng-if="::general.hasLazyload()" ng-style="{'max-width': imageWidth + 'px' }" class="placeholder-wrapper">
							<span class="placeholder"></span>
							<img class="responsive m-productlist-image lazyload"
							data-ng-src="{{image}}"
							data-src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
							alt="{{product.Title}}">
						</span>
						<img data-ng-if="::general.hasLazyload() == false"
							class="responsive m-productlist-image"
							data-ng-src="{{image}}"
							src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
							alt="{{product.Title}}">
					</a>
				</figure>

			</div>

			<div class="col-s-4 col-m-4 col-l-4 col-xl-8">

				<!-- Product title and brand -->
				<header class="title m-productlist-heading">
					<a data-ng-href="{{product.Handle}}" class="is-block m-productlist-link">
						<h4 class="h5 m-productlist-title" data-ng-bind-html="::product.Title"></h4>
					</a>
					<a data-ng-href="{{::product.ProducerHandle}}" class="m-productlist-brand-link">
						<span class="is-block m-productlist-brand" data-ng-bind-html="::product.ProducerTitle"></span>
					</a>

					<!-- Item number -->
					<p data-ng-if="::settings.shop_product_number" class="m-productlist-itemNumber" data-ng-bind-html="itemNumber"></p>
				</header>

				<!-- Short description -->
				<div class="description m-productlist-description" data-ng-if="::product.DescriptionList">
					<hr class="m-productlist-description-separator">
					<div class="short-description m-productlist-short-description" data-ng-bind-html="::product.DescriptionList"></div>
				</div>


				<div class="product-delivery m-productlist-stock" data-ng-if="::settings.shop_product_delivery_time && settings.shop_product_delivery_time_list">
					<hr class="m-productlist-delivery-separator">
					<!-- Stock status -->
					<p data-ng-if="!showVariants || hasChosenVariant" data-delivery-text></p>
				</div>

				<div class="product-rating m-productlist-rating" data-ng-if="::settings.module_shop_review_products">
					<hr>
					<!-- Rating visually made with FontAwesome -->
					<div class="m-reviews-stars trailing-db" data-raty="::product.AverageRating" data-readonly="true"></div>
				</div>
			</div>

			<div class="col-s-4 col-m-4 col-l-4 col-xl-8 m-productlist-offer l-default-height">
				<div class="product-transaction m-productlist-transaction">

					<!-- Variant dropdown of Product -->
					<div class="variants m-productlist-variants" data-ng-if="::showVariants" data-ng-class="{'flash': flashVariant}">
						<input type="hidden" name="product[{{product.Id}}][variant]" class="variantContainer m-productlist-variantContainer" style="width:100%;" data-variant-ajax="product.Id" data-variant-default="variantDefault" data-hide-price="showPrices" data-image-width="imageWidth" data-image-height="imageHeight" data-required>
					</div>
					<!-- Price calculation of Product -->
					<div class="prices trailing-db" data-ng-if="::showPrices">

						<!-- Discount price -->
						<p class="m-productlist-discount" data-ng-if="discount">

							<!-- Price -->
							<s class="is-block m-productlist-price-before-discount" data-ng-bind-html="discount | currency_format"></s>
						</p>

						<!-- Price -->
						<span class="is-block h5 m-productlist-price" data-ng-bind-html="price"></span>

						<!-- Various price info -->
						<div class="product-various-price-info m-productlist-data">

				    		<!-- VAT -->
				    		<span data-ng-if="::settings.shop_product_tax_after_price" class="is-block m-productlist-vat" data-ng-bind-html="::vatText"></span>

				    		<!-- Cheapest combo -->
				    		<span data-ng-if="combo" class="is-block" data-ng-bind-html="combo"></span>

				    		<!-- VAT -->
				    		<span data-ng-if="::settings.shop_product_tax_after_price && combo" class="is-block m-productlist-vat" data-ng-bind-html="::vatText"></span>

		                    <!-- Price terms -->
		                    <div data-ng-if="::shop.priceTerms" class="product-price-terms m-productlist-price-terms">
		                    	<a href="#overlaypriceTerms" data-fancybox="" class="m-productlist-price-terms-link"><span class="m-productlist-price-terms-link" data-ng-bind-html="::text.PRODUCT_CATALOG_SHOW_DELIVERY_LINK"></span></a>
		                    </div>
				    	</div>

					</div>

					<!-- Transaction -->
					<div class="product-action m-productlist-transactions" data-ng-if="showButtons">
						<div class="transactions-amount">

							<!-- Amount -->
							<fieldset class="form-group m-productlist-transactions-amount">
								<input type="text" pattern="[0-9]*" class="form-input text-center m-productlist-transactions-input" name="product[{{product.Id}}][amount]" value="{{minAmount}}" placeholder="{{::text.CART_COUNT}}" title="{{::text.CART_ADD_ERROR_EMPTY}}" required data-ng-disabled="buttonMode != 1">
							</fieldset>
						</div>
						<div class="m-productlist-transactions-button">
							<!-- Call-to-action -->
							<fieldset class="form-group" data-ng-switch data-on="buttonMode">
								<a data-ng-switch-default data-ng-href="{{product.Handle}}" class="button-primary is-block m-productlist-link" data-ng-bind-html="::text.PRODUCT_CATALOG_PRODUCT_SHOW"></a>
								<button data-ng-switch-when="1" type="submit" name="cartadd" class="button-primary is-block normal" data-ng-click="processProductSubmit()">
									<span data-ng-bind-html="::text.PRODUCT_CATALOG_PRODUCT_BUY"></span>
								</button>
								<button data-ng-switch-when="2" type="button" class="button-primary is-block variant" data-ng-click="toggleFlashVariant()" data-ng-bind-html="::text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT"></button>
							</fieldset>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</article>
{/literal}
