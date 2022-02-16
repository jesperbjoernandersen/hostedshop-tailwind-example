{*************************** DEPRECATED ****************************}
{*** THIS FILE IS DEPRECATED, REFER TO json/products.tpl INSTEAD ***}
{*******************************************************************}

{$output = []}

{if $request.method eq 'GET'}


	{* Is the filter enabled for the requested category *}
	{setting assign=enabledSetting key=shop_product_filter_enabled}


	{* Default values *}
	{$output = [
		'enabled' => $enabledSetting,
		'data' => array(),
		'showPrice' => false,
		'showBrands' => false,
		'showCategories' => false,
		'showNews' => false,
		'showSale' => false,
		'showSearch' => false
	]}


	{* If filter is enabled then proceed with further checks *}
	{if $output.enabled}
	
		{$categoryId = 0}
		{if !empty($request.args.0)}
			{$categoryId = $request.args.0}
		{/if}

		{controller assign=controller type=productFilter}

		{* Data groups *}
		{$options = [
			'categoryId' => $categoryId,
			'languageIso' => $general.languageIso
		]}

		{* Settings *}
		{setting assign=priceSetting key=shop_product_filter_price}
		{setting assign=brandsSetting key=shop_product_filter_brands}
		{setting assign=categoriesSetting key=shop_product_filter_categories}
		{setting assign=newsSetting key=shop_product_filter_news}
		{setting assign=saleSetting key=shop_product_filter_sale}
		{setting assign=searchSetting key=shop_product_filter_search}


		{* Variant and custom data *}
		{$customGroups = $controller->filterCustomDataGroups($options)}
		{$variantGroups = $controller->filterVariantGroups($options)}
		{$output['data'] = array_merge($customGroups, $variantGroups)}

		{$output['brandsSetting'] = $brandsSetting}

		{* Special check for categoryId = 0 (search, brand) *}
		{if $categoryId === 0}

			{$output['showPrice'] = $priceSetting === true}
			{$output['showBrands'] = $brandsSetting === true or $brandsSetting === 'select'}
			{if $output.showBrands and $brandsSetting === 'select'}
				{$output['showBrands'] = 'select'}
			{/if}
			{$output['showCategories'] = $categoriesSetting === true or $categoriesSetting === 'select'}
			{if $output.showCategories and $categoriesSetting === 'select'}
				{$output['showCategories'] = 'select'}
			{/if}
			{$output['showNews'] = $newsSetting === true}
			{$output['showSale'] = $saleSetting === true}
			{$output['showSearch'] = $searchSetting === true}

		{else}

			{* Price *}
			{$output['showPrice'] = $priceSetting !== false and $controller->isVisibleInCategory($priceSetting, $categoryId)}

			{* Brands *}
			{$output['showBrands'] = $brandsSetting !== false and $controller->isVisibleInCategory($brandsSetting, $categoryId)}
			{if $output.showBrands and strpos($brandsSetting, 'select') !== false}
				{$output['showBrands'] = 'select'}
			{/if}

			{* Categories *}
			{$output['showCategories'] = $categoriesSetting !== false and $controller->isVisibleInCategory($categoriesSetting, $categoryId)}
			{if $output.showCategories and strpos($categoriesSetting, 'select') !== false}
				{$output['showCategories'] = 'select'}
			{/if}

			{* News *}
			{$output['showNews'] = $newsSetting !== false and $controller->isVisibleInCategory($newsSetting, $categoryId)}

			{* Sale *}
			{$output['showSale'] = $saleSetting !== false and $controller->isVisibleInCategory($saleSetting, $categoryId)}

			{* Search *}
			{$output['showSearch'] = $searchSetting !== false and $controller->isVisibleInCategory($searchSetting, $categoryId)}

		{/if}

	{/if}

{/if}

{$output|jsonify}