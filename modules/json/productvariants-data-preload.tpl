{*** Preload images ***}
{controller type=files assign=imageController}
{$imageController->preloadVariantDataPictures($datas->pluck('Id'))}