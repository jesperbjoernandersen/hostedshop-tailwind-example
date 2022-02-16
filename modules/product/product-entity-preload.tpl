{*** Preload images ***}
{controller type=files assign=imageController}
{$imageController->preload([$item->Id])}