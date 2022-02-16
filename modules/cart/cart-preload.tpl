{* Entity ids *}
{$preloadProductIds = $cart->pluck('ProductId')}

{if !empty($preloadProductIds)}

    {* Preload images *}
    {controller assign=filesController type=files}
    {$filesController->preload($preloadProductIds)}
{/if}