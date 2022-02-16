{*** Preload variant data ***}
{controller assign=variantDataController type=productVariantData}
{collection assign=variantDatas controller=$variantDataController productId=$product->Id}
{$variantDataController->preload($variantDatas->pluck('Id'))}

{*** Preload images ***}
{controller type=files assign=imageController}
{$imageController->preloadVariantDataPictures($variantDatas->pluck('Id'))}