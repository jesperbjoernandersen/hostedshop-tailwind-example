{*** Preload variant data ***}
{controller assign=variantDataController type=productVariantData}
{$variantDataController->preload($variants->pluck('Id'))}

{$variantDataIds = $variantDataController->getPreloadFieldValues('Id')}
{$variantTypeIds = $variantDataController->getPreloadFieldValues('TypeId')}

{*** Preload variant type ***}
{controller assign=variantTypeController type=productVariantType}
{$variantTypeController->preload($variantTypeIds)}

{*** Preload images ***}
{$imageController->preloadVariantPictures($variants->pluck('Id'))}

{$imageController->preloadVariantDataPictures($variantDataIds)}

{*** Preload translations ***}
{$productController->preloadTranslations($variants->pluck('UnitId'), ['unit'], ['title'])}