{*** Preload custom data ***}
{controller assign=productCustomDataController type=productCustomData}
{$productCustomDataController->preload([$product->Id])}