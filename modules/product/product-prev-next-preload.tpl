{$productPreloadIds = [$product->Id]}
{if isset($links['next']) and !empty($links['next'])}
    {$productPreloadIds[] = $links['next']}
{/if}
{if isset($links['prev']) and !empty($links['prev'])}
    {$productPreloadIds[] = $links['prev']}
{/if}

{*** Preload current, previous and next product ***}
{$productController->preload($productPreloadIds)}

{*** Preload translations for current, previous and next product ***}
{$productController->preloadTranslations($productPreloadIds, ['product'], ['title', 'link', 'text_description', 'seo_description', 'seo_keywords', 'canonical'])}