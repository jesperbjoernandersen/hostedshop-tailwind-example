{* Instantiate controllers *}
{controller assign=brandController type=brand}
{controller assign=filesController type=files}
{controller assign=productAdditionalTypeController type=productAdditionalType}
{controller assign=variantTypeController type=productVariantType}

{* Get the unique product ids in the list *}
{$preloadProductIds = $products->pluck('Id')}

{* Preload product translations *}
{$controller->preloadTranslations($preloadProductIds, ['product'], ['text_short'])}
{$controller->preloadTranslations($products->pluck('UnitId'), ['unit'], ['title'])}
{$controller->preloadTranslations($products->pluck('DeliveryTimeId'), ['delivery_time'], ['title_on_stock', 'title_no_stock'])}

{* Preload images *}
{$filesController->preload($preloadProductIds)}

{* Preload categories *}
{$categoryController->preload($products->pluck('CategoryId'))}

{* Preload brands *}
{$brandController->preload($products->pluck('ProducerId'))}

{* Preload variant types *}
{$variantTypeController->preload($controller->variantTypeIds($preloadProductIds))}

{* Preload product additional types *}
{$productAdditionalTypeController->preload($preloadProductIds)}

{* Preload product reviews *}
{$reviewController->preloadRatings($preloadProductIds)}