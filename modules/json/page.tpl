{if isset($request.input.id)}
    {$id = (int)$request.input.id}
    {controller assign=pageController type=page}
    {$output['Headline'] = $pageController->getHeadline($id)}
    {$output['Text'] = $pageController->getText($id)}
    {$output|jsonify}
{else}
    No page ID found
{/if}