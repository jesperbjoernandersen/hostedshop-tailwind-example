{*************************** DEPRECATED ****************************}
{*** THIS FILE IS DEPRECATED, REFER TO json/products.tpl INSTEAD ***}
{*******************************************************************}


{* This service only accepts GET requests *}
{if $request.method eq 'GET'}

	{$productList = null}

	{* URI segments *}
	{** Inspect verb parameter to find a field, e.g. /json/productlist/VERB **}
	{$field = 'categoryId'}
	{if $request.verb}
		{$field = $request.verb}
	{/if}

	{** Check if an argument is included, e.g. /json/productlist/VERB/ARGS[0] **}
	{$arg = true}
	{if isset($request.args[0])}
		{$arg = $request.args.0}
	{/if}

	{* Fetch product list *}
	{** For related products, fetch relevant product list from ProductRelatedController and ProductCategoryController **}
	{if $field eq 'related'}
		{setting assign=setting key=product_related}

		{if $setting !== false}
			{collection assign=productList controller=productRelated productId=$arg}
			{if $setting != 'chosen' and $productList->getActualSize() eq 0}
				{entity assign=product controller=product productId=$arg}
				{$orderBy = 'Sold'}
				{if $request.input.orderBy}
					{$orderBy = $request.input.orderBy}
				{/if}
				{$pageSize = 3}
				{if $request.input.limit}
					{$pageSize = $request.input.limit}
				{/if}
				{collection assign=productList controller=productList categoryId=$product->CategoryId ignoreProductId=$arg orderBy=$orderBy page=1 pageSize=$pageSize}
			{/if}
		{/if}

	{** For 'also bought' products, fetch relevant product list from ProductAlsoBoughtController **}
	{elseif $field eq 'alsobought'}
		{$pageSize = 3}
		{if $request.input.limit}
			{$pageSize = $request.input.limit}
		{/if}
		{collection assign=productList controller=productAlsoBought productId=$arg pageSize=$pageSize}

	{** If no field is recognised in the URI segment for VERB, assign the VERB value as a parameter to ProductListController **}
	{else}
		{$options = []}

		{*** Check for LIMIT parameter and assign to pageSize ***}
		{if isset($request.input["limit"])}
			{$options['pageSize'] = $request.input.limit}
		{/if}

		{*** Check for CATEGORYID parameter and assign to categoryId ***}
		{if $request.input["categoryId"]}
			{$options['categoryId'] = $request.input.categoryId}
		{/if}

		{*** If a 'tag' was included we need to prepare the value ***}
		{if $field eq 'tag'}
			{$argOptions = explode(';', $arg)}
			{if $argOptions|count gt 1}
				{$options['type'] = $argOptions[1]}
			{/if}
			{$arg = $argOptions[0]}
		{/if}

		{*** If a field was provided at all, assign it as a parameter with the argument as value ***}
		{if !empty($field)}

			{*** Special case for 'orderBy' field, which needs a second parameter if $arg is 'OnSale' ***}
			{if $field eq 'orderBy' and $arg eq 'OnSale'}

				{*** Set $arg to -Sold to order by most sold products ***}
				{$arg = 'Age'}

				{*** Set extra option to make sure only products on sale are displayed ***}
				{$options['sale'] = true}

			{/if}

			{$options[$field] = $arg}
		{/if}

		{*** For internal reference purpose, make sure the controller is using a static categoryMap to look up categories ***}
		{$options['categoryMap'] = true}

		{*** Fetch products from the controller with all the options included ***}
		{collection assign=productList controller=productList options=$options}
	{/if}

	{* Prepare product list *}
	{if $productList}

		{** Sometime a service will ask to generate the products right away in stead of making a secondary call to /json/product 
		so we include the product.tpl file and assign all the product ids **}
		{if isset($request.input["generate"])}
			{include file='modules/json/product.tpl' id=$productList->pluck('Id')}

		{** Normal mode: Get the data formatted as UTF8 in a JSON string **}
		{else}
			{$productList->getData(false,false,true)}

		{/if}

	{* If no product list was found, return an empty JSON array *}
	{else}
		[]

	{/if}
{/if}