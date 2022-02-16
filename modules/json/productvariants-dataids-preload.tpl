{*** Preload translations ***}
{$controller->preloadTranslations($variantData->pluck('Id'), ['variant'], ['text_description', 'text_long'])}
{$controller->preloadTranslations($variantData->pluck('UnitId'), ['unit'], ['title'])}

{*** Preload variant data ***}
{controller assign=variantDataController type=productVariantData}
{$variantDataController->preload($variantData->pluck('Id'))}

{*** Preload images ***}
{controller type=files assign=imageController}
{$imageController->preload([$product->Id])}
{$imageController->preloadVariantPictures($variantData->pluck('Id'))}
{$imageController->preloadVariantDataPictures($variantDataController->getPreloadFieldValues('Id'))}