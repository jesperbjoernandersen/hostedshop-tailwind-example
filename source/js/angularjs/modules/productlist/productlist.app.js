;(function($, platform, exports) {

    "use strict";

    var app_version = 20191004;


    // Fix for BUG-6 - Where tpl is custom, added needed data attributes for newer js of rzslider.
    $('rzslider').each(function () {
        var $this = $(this);
        $this.attr('rz-slider-options', ($this.attr('rz-slider-high') === 'filterSelected.maxPrice' ? 'filterMap.prices.sliderOptions' : '{translate:rzTranslate, groupUnit: dataGroup.data.unit, floor:dataGroup.data.low, precision: dataGroup.data.precision, step: dataGroup.data.step }'));
    });

    // Fix for BUG-6 - Where css is custom, added a link to new rzslider css (new and old css work together);
    var css_libs = $("link[href*='/libs.css']");
    if ( css_libs.length && css_libs.attr('href').indexOf('/_design/smartytemplates/store/') == -1 ) {
        $('head').append('<link rel="stylesheet" type="text/css" href="'+ platform.template.cdn +'/_design/smartytemplates/store/template001/source/js/angularjs/libs/rzslider.v643.css">');
    }


    var app = angular.module('productlistApp', ['ngEqualizer', 'checklist-model', 'rzModule', 'productlistServices', 'productlistDirectives']);

    app.controller('productlist-ctrl', ['$scope', '$q', '$rootScope', '$attrs', '$filter', '$location', 'ProductApi', '$timeout', 'LinkService', 'FilterService',
        function ($scope, $q, $rootScope, $attrs, $filter, $location, $api, $timeout, LinkService, FilterService) {

            // Version
            $scope.version = app_version;

            // Text
            $scope.text = window.text;

            // Language
            $scope.language = platform.language;

            // Settings
            $scope.settings = platform.settings;

            // Template
            $scope.template = platform.template;

            // Shop
            $scope.shop = platform.shop;

            // User
            $scope.user = platform.user;

            // General
            $scope.general = platform.general;

            $scope.currency_format = $filter('currency_format');
            $scope.currency_format_decode = $filter('currency_format_decode');
            $scope.filters = {};
            $scope.productlist = $scope.items = [];
            $scope.itemId = $attrs.itemId;
            $scope.filter = $attrs.filter;
            $scope.loaded = false;
            $scope.empty = false;
            $scope.showEmpty = typeof $attrs.showEmpty !== 'undefined' && $attrs.showEmpty == '1' ? true : false;
            $scope.maxPage = 1;
            $scope.filterMap = null;
            $scope.showFilter = false;
            $scope.filterChanged = false;

            // Pictures
            $scope.imageWidth = $attrs.imageWidth;
            $scope.imageHeight = $attrs.imageHeight;

            // updating and setting service link
            $scope.linkservice = LinkService;

            // Limit options
            $scope.limitOptions = [
                {amount: 48, title: $scope.text.PRODUCT_CATALOG_ORDER_BY_LIMIT_PER_PAGE.replace("%AMOUNT%", 48)},
                {amount: 96, title: $scope.text.PRODUCT_CATALOG_ORDER_BY_LIMIT_PER_PAGE.replace("%AMOUNT%", 96)},
                {amount: 0, title: $filter('decode')($scope.text.SHOW_ALL)}
            ];

            //Filter
            var sliderChanged = false;

            // Does the list already have SEO canonical defined by user?
            $scope.hasMeta = (function hasMetaLinks () {
                return !!angular.element('head link[rel="canonical"]').length;
            })();

            // price slider recalculate
            $scope.reCalcSlider = function () {
                $timeout(function () {
                    $scope.$broadcast('reCalcViewDimensions');
                }, 25);
            }

            $scope.hasAmountDropdown = function () {

                var amountValues = [];

                _.forEach($scope.limitOptions, function (value, key) {
                    if (value && value.amount) {
                        amountValues.push(value.amount);
                    }
                });

                return $scope.amount >= Math.min.apply(Math, amountValues);
            }

            // translate text for showing amount and limit
            $scope.amountText = function () {

                var limit =       $scope.limitProp,
                    amount =      $scope.amount,
                    page =        $scope.page,
                    text =        $scope.text.PRODUCT_CATALOG_ORDER_BY_LIMIT_DISPLAY,
                    from =        (page * limit) - limit,
                    to;

                if ( limit > amount || limit === 0 ) {
                    text = $scope.text.PRODUCT_CATALOG_ORDER_BY_LIMIT_ON_PAGE;
                    return text.replace("%AMOUNT%", amount);
                }

                switch ( page ) {

                    //first page
                    case 1:
                        from = null;
                        to = limit
                        break;

                    //end page
                    case Math.ceil(amount / limit):
                        to = from + amount - ((page - 1) * limit);
                        break;

                    //pages between
                    default:
                        to = (page * limit);
                }

                if ( from ){
                    return text.replace("%CURRENT%", from + "-" + to).replace("%AMOUNT%", amount);
                } else {
                    return text.replace("%CURRENT%", to).replace("%AMOUNT%", amount);
                }
            }

            // Order options
            $scope.orderOptions = [];
            var pushOrderOption = function (id, title, overwrite) {
                $scope.orderOptions.push({
                    id: id,
                    title: $filter('decode')(title),
                    overwrite: overwrite
                });
            }

            var orderPropFormat = function(key) {

                var stdProp = 'Sold';

                if (!key) {
                    return stdProp;
                }

                key = key.toLowerCase();
                if (key == 'title') {
                    return 'Title';
                }
                else if (key == 'price') {
                    return 'SortPrice';
                }
                else if (key == 'price_high') {
                    return '-SortPrice';
                }
                else if (key == 'date') {
                    return 'Age';
                }
                else if (key == 'bestseller') {
                    return '-Sold';
                }
                else if (key == 'number') {
                    return 'ItemNumber';
                }
                else if (key == 'relevance') {
                    return '-Weight';
                }
                else if (key == 'recommended') {
                    return 'Recommended';
                }
                else {
                    return stdProp;
                }

                return key;
            }

            // Recommended sorting
            if (platform.getSetting('shop_productlist_sorting_recommended')) {
                pushOrderOption('Recommended', text.PRODUCT_CATALOG_ORDER_BY_RECOMMENDED, true);
            }

            // Title sorting
            if (platform.getSetting('shop_productlist_sorting_title')) {
                pushOrderOption('Title', text.PRODUCT_CATALOG_ORDER_BY_TITLE, platform.getSetting('shop_productlist_sorting_title_overwrite'));
            }

            // Price low
            if (platform.getSetting('shop_productlist_sorting_price')) {
                pushOrderOption('SortPrice', text.PRODUCT_CATALOG_ORDER_BY_PRICE, platform.getSetting('shop_productlist_sorting_price_overwrite'));
            }

            // Price high
            if (platform.getSetting('shop_productlist_sorting_price_high')) {
                pushOrderOption('-SortPrice', text.PRODUCT_CATALOG_ORDER_BY_PRICE_HIGH, platform.getSetting('shop_productlist_sorting_price_high_overwrite'));
            }

            // Date
            if (platform.getSetting('shop_productlist_sorting_date')) {
                pushOrderOption('Age', text.PRODUCT_CATALOG_ORDER_BY_DATE, platform.getSetting('shop_productlist_sorting_date_overwrite'));
            }

            // Sold
            if (platform.getSetting('shop_productlist_sorting_bestseller')) {
                pushOrderOption('-Sold', text.PRODUCT_CATALOG_ORDER_BY_BESTSELLER, platform.getSetting('shop_productlist_sorting_bestseller_overwrite'));
            }

            // Product number
            if (platform.getSetting('shop_productlist_sorting_number')) {
                pushOrderOption('ItemNumber', text.PRODUCT_CATALOG_ORDER_BY_NUMBER, platform.getSetting('shop_productlist_sorting_number_overwrite'));
            }

            _.each(platform.general.searchOptions, function (v, k) {
                pushOrderOption(orderPropFormat(v.title), text.PRODUCT_CATALOG_ORDER_BY_WEIGHT, false);
            });

            var searchProperties = ['typeId', 'limitProp', 'orderProp', 'page'];

            var defaultValues = {
                typeId: ($attrs['viewmode'] ? $attrs['viewmode'] : 2),
                limitProp: $scope.limitOptions[0].amount,
                orderProp: orderPropFormat($attrs['sorting'] != '' ? $attrs['sorting'] : 'bestseller'),
                page: 1
            };

            function saveSession (key, value) {
                if (typeof Storage !== 'undefined') {
                    var c = typeof sessionStorage.productlist !== 'undefined' ? JSON.parse(sessionStorage.productlist) : {};
                    c[key] = value;
                    sessionStorage.productlist = JSON.stringify(c);
                    return true;
                }
                return false;
            }

            function loadSession (key) {
                if (typeof Storage !== 'undefined' && typeof sessionStorage.productlist !== 'undefined') {
                    var productlist = JSON.parse(sessionStorage.productlist);
                    if (key && productlist[key]) {
                        return JSON.parse(productlist[key]);
                    }
                }
                return false;
            }

            // Update defaultValues from SessionStorage
            if (typeof Storage !== 'undefined' && typeof sessionStorage.productlist !== 'undefined') {
                var sessionState = JSON.parse(sessionStorage.productlist);
                _.forEach(sessionState, function(value, key) {
                    if (typeof defaultValues[key] !== 'undefined' && value != null) {
                        defaultValues[key] = value;
                    }
                });
            }

            // get url state
            var savedState = $location.search();
            console.info('Received a state: %o', savedState);

            if ( _.keys(_.omit(savedState, ['page'])).length ) {
                $scope.canonicalChanged = true;
            }

            // loop this controllers search properties to find changes
            _.forEach(searchProperties, function (k) {

                var value = null;

                if (typeof savedState[k] !== 'undefined' && savedState[k] != 'null') {
                    value = savedState[k];
                }

                // fall back to default value
                else {
                    value = defaultValues[k];
                }
                if (value !== null) {
                    if (k == 'page' || k == 'limitProp') {
                        value = parseInt(value);
                    }

                    $scope[k] = value;
                }
            });

            var searchFilterSelected = angular.fromJson(savedState['filter']) || null;
            if (searchFilterSelected) {
                $scope.canonicalChanged = true;
            }

            function updateProductlist(searchFilterSelected) {
                // default field
                var field = $attrs['field'] ? $attrs['field'] : null;
                if (!field) {
                    field = 'categoryId';
                }

                // take care of the sorting order
                var sortOptions = null;
                if ($scope.orderProp !== '' && $scope.orderProp != null) {

                    var useOwnSorting = true;
                    _.forEach($scope.orderOptions, function(value, key) {
                        if (value.id == $scope.orderProp) {
                            useOwnSorting = value.overwrite;
                            return false;
                        }
                    });

                    var sortToUse = $scope.orderProp;
                    if (sortToUse == 'Recommended') {
                        sortToUse = orderPropFormat(platform.getSetting('shop_productlist_sorting_recommended_sorting'));
                    }

                    sortOptions = useOwnSorting ? 'Sorting,' + sortToUse : sortToUse;
                }

                // attributes
                var attributes = {
                    field: field,
                    id: $scope.itemId,
                    orderBy: sortOptions,
                    page: $scope.page,
                    limit: $scope.limitProp,
                    filterGenerate: true,
                    currencyIso: platform.general.currencyIso
                };

                if (searchFilterSelected) {
                    attributes.filter = searchFilterSelected;

                    if (typeof searchFilterSelected.lastUpdated !== 'undefined') {
                        attributes.lastUpdated = searchFilterSelected.lastUpdated;
                        delete searchFilterSelected.lastUpdated;
                    }
                }

                var maxPage = 1;
                $scope.loadingProducts = $scope.loaded || true;

                return $api.productlist.query(attributes, function(data) {
                    $scope.maxPage = 1;

                    if (data.amount && data.products) {

                        // calculate max pages based on actual amount
                        maxPage = $scope.limitProp ? Math.ceil( data.amount / $scope.limitProp ) : 1;

                        $scope.maxPage = maxPage;
                        $scope.productlist = $scope.items = data.products;
                        $scope.empty = false;
                        $scope.amount = data.amount;

                    } else {
                        $scope.productlist = $scope.items = [];
                        $scope.empty = true;
                    }

                    // check if page is out of bounds
                    if ($scope.page > $scope.maxPage) {
                        redirectWithPage($scope.maxPage);
                    }

                    if ($attrs.filter && data.filterMap) {

                        $scope.filterMap = data.filterMap;

                        $scope.filterMap.prices.sliderOptions = {
                            floor: $scope.filterMap.prices.data.low,
                            ceil: $scope.filterMap.prices.data.high,
                            translate: $scope.version >= 20170711 ? $filter('currency_format_decode') : $filter('currency_format')
                        };

                        // Validate if filter should be shown
                        $scope.showFilter = false;
                        _.forEach($scope.filterMap, function (filterGroup, filterKey) {
                            if (filterKey != 'data' && filterGroup.show && (typeof filterGroup.data === 'undefined' || filterGroup.data.length)) {
                                $scope.showFilter = true;
                                return false;
                            }
                        });

                        if (!$scope.showFilter && typeof $scope.filterMap.data !== 'undefined') {
                            _.forEach($scope.filterMap.data, function (dataGroup, dataKey) {
                                if (dataGroup.show && dataGroup.data.length) {
                                    $scope.showFilter = true;
                                    return false;
                                }
                            });
                        }

                        // Fix to make sure rzSlider is calculating properly
                        $timeout(function() {
                            $scope.$broadcast('reCalcViewDimensions');
                        }, 100);
                    } else {
                        $scope.filterMap = null;
                        $scope.showFilter = false;
                    }

                    if ($scope.empty && $scope.showFilter) {
                        $scope.showEmpty = true;
                    }

                    $scope.loaded = true;
                    $scope.loadingProducts = false;
                    $scope.$broadcast( 'productlist.fetch' );

                    $(window.platform).trigger('fetch.productlist', data);

                    // inform framework of current list to be used in prev/next choice
                    if ($attrs.session && platform.getSetting('product_browse')) {
                        var sessionData = data.productIds ? data.productIds : ($scope.productlist.length ? _.map($scope.productlist, 'Id') : null);

                        $api.session( sessionData );
                    }

                });
            }

            function setLinkValues () {
                var links = [];

                // if category is empty OR has user defined canonicals, dont tamper with em
                if ($scope.empty || $scope.hasMeta) { return; }

                if ( $scope.getNextPage && $scope.getPrevPage ) {
                    links = [
                        { 'name': 'prev', 'value': $scope.getPrevPage() },
                        { 'name': 'next', 'value': $scope.getNextPage() }
                    ];
                }

                $scope.linkservice.set(links, $scope.canonicalChanged, $scope.page);
            }

            function updateProductlistWithFilter (setPage) {

                setPage = setPage === false ? false : true;

                if (setPage) {
                    $location.search('page', null);
                    $scope.page = 1;
                }

                var filterOptions = $scope.filterSelected || searchFilterSelected || {};
                var filterForApi = filterNullValuesRange(filterOptions);

                return updateProductlist(filterForApi).$promise.then(function () {
                    $scope.filterSelected = filterOptions;

                    if (!$scope.filterMap) { return; }

                    var data = loadSession('filter');
                    var data = data ? data : filterOptions;

                    $scope.filterChanged = FilterService.hasChanges(data, $scope.filterMap);
                });
            }

            // initial fetch of product data
            // bootstrap productlist with pre-determined ids
            if ($attrs['productId'] != '') {
                var list = $attrs['productId'].split(',');
                var data = [];
                _.forEach(list, function (v, k) {
                    data.push({Id: v});
                });
                $scope.orderProp = null;
                $scope.limitProp = null;
                $scope.canonicalChanged = false;
                $scope.page = 1;
                $scope.maxPage = 1;

                $api.product.query({field: 'id', id: $attrs['productId']}, function (productlist) {
                    $scope.productlist = $scope.items = productlist.products;
                    $scope.empty = !productlist.products.length;
                    $scope.loaded = true;
                });

            } else {

                // small view limit
                var isSmall = window.template.bp.current();
                if (isSmall == 's' || isSmall == undefined) {
                    console.info('Redefining selection of limitProp');
                    $scope.limitOptions.unshift({
                        amount: 24,
                        title: $scope.text.PRODUCT_CATALOG_ORDER_BY_LIMIT_PER_PAGE.replace("%AMOUNT%", 24)
                    });
                    $scope.limitProp = $scope.limitOptions[0].amount;
                }

                updateProductlistWithFilter(!$scope.page || $scope.page == 1).then(function () {

                    // validate limit options based on total amount
                    if ($scope.amount >= 200) {
                        for (var key in $scope.limitOptions) {
                            if ($scope.limitOptions[key].amount == 0) {
                                $scope.limitOptions.splice(key, 1);
                            }
                        }
                        if ($scope.limitProp == 0) {
                            $scope.limitProp = $scope.limitOptions[0].amount;
                        }
                    }

                    // make sure default filter values are set
                    filterDefaultValues();
                    setLinkValues();
                });
            }

            // set url state
            $scope.saveState = function(k, v) {
                $location.search(k, v);
            }

            // Type
            $scope.changeType = function(typeId) {
                $scope.typeId = typeId;
                $scope.saveState('typeId', $scope.typeId);
                $scope.canonicalChanged = true;

                // cache
                saveSession('typeId', $scope.typeId);
            }

            // Limit
            $scope.changeLimit = function() {
                $scope.saveState('limitProp', $scope.limitProp);
                updateProductlistWithFilter().then(function () {
                    $scope.canonicalChanged = true;
                    setLinkValues();
                });

                // cache
                saveSession('limitProp', $scope.limitProp);
            }

            // Order
            $scope.changeOrder = function() {
                $scope.saveState('orderProp', $scope.orderProp);
                updateProductlistWithFilter().then(function () {
                    $scope.canonicalChanged = true;
                    setLinkValues();
                });

                // cache
                saveSession('orderProp', $scope.orderProp);
            }

            // Generic event emitter
            $scope.triggerEvent = function (event, data) {
                $(window.platform).trigger(event + '.productlist', (data || true));
            }

            // Pager
            $scope.range = function () {

                var page = parseInt($scope.page);

                var start = page - 5;
                if (start < 1) start = 1;

                var end = page + 5;
                if (end > $scope.maxPage) end = $scope.maxPage;

                return _.range(start, end+1);
            }

            $scope.setPage = function (page, scroll) {
                $scope.page = !page ? this.n : page;
                $scope.saveState('page', $scope.page > 1 ? $scope.page : null);
                scroll = scroll || false;

                updateProductlistWithFilter(false).then(function() {
                    if (scroll) {
                        scrollTop();
                    }

                    $scope.canonicalChanged = $scope.canonicalChanged ? true : false;
                    setLinkValues();
                });
            }

            $scope.prevPage = function () {
                if ($scope.page > 1) {
                    $scope.setPage($scope.page - 1, true);
                }
            }
            $scope.getPrevPage = function () {
                if ($scope.page > 1) {
                    return ($scope.page - 1);
                }
                return false;
            }

            $scope.nextPage = function () {
                if ($scope.page < $scope.maxPage) {
                    $scope.setPage($scope.page + 1, true);
                }
            }
            $scope.getNextPage = function () {
                if ( $scope.maxPage == 1 ) {
                    return false;
                }

                if ($scope.page <= $scope.maxPage-1) {
                    return ($scope.page + 1);
                }

                return false;
            }

            $scope.link = function (item) {
                if ( typeof item == 'string' ) {
                    item = 'next' == item ? $scope.getNextPage() : $scope.getPrevPage();

                    if ( !item ) {
                        return "";
                    }
                }

                return $scope.linkservice.buildComplete(item);
            }

            $scope.nav = function (e, page) {
                e.preventDefault();

                if ( typeof page == 'string' ) {
                    if ( page == 'next' ) {
                        $scope.nextPage();
                    } else {
                        $scope.prevPage();
                }
                } else {
                    $scope.setPage(parseInt(page,10), true);
                }
            }

            // Filters
            $scope.searchText = $filter('decode')($scope.text.SEARCH);

            // State for sliders
            $scope.$on('slideEnded', function() {
                $scope.state('slider');
            });

            // State for text search
            $scope.searchChanged = false;
            $scope.$watch('filterSelected.search', _.debounce(function() {
                if ($scope.searchChanged) {
                    $scope.state('search');
                    $scope.searchChanged = false;
                }
            }, 500));

            $scope.multipleSelectTitle = function (data, activeIds) {

                if (!data || !activeIds || !activeIds.length) { return false; }

                var title = "",
                    limit = 42,
                    i;

                // find option
                var getOptionById = function (arr, id) {
                    var obj = {}
                    _.forEach(arr, function (item) {
                        if (item.id === id) {
                            return obj = item;
                        }
                    });
                    return obj;
                }

                for (i = 0; i < activeIds.length; i++) {

                    var id = activeIds[i];

                    var option = getOptionById(data, id);

                    title += option.title;

                    if (i < activeIds.length - 1 && title.length < limit-1){
                        title += ", ";
                    }

                    if (title.length > limit) {
                        title = title.substring(0, limit) + "...";
                        break;
                    }

                }
                return title;
            }

            $scope.clearSelect = function(option) {
                searchFilterSelected = FilterService.resetSelect(searchFilterSelected, option);
                $scope.filterSelected = FilterService.resetSelect($scope.filterSelected, option);
                $scope.state(option, false);
                $scope.filterChanged = true;
            }

            $scope.clearFilter = function () {

                if (!$scope.filterMap) { return; }

                updateProductlistWithFilter().then( function () {
                    setLinkValues();
                    clearAll();
                });

                function clearAll() {
                    $scope.filterChanged = false;
                    $scope.canonicalChanged = false;

                    var filterDefault = FilterService.getDefaults($scope.filterMap);
                    $location.search('filter', JSON.stringify(filterDefault));

                    filterDefaultValues();

                    var options = FilterService.setDefaults($scope.filterMap, $scope.filterSelected.lastUpdated);
                    searchFilterSelected = options;
                    $scope.filterSelected = options;
                    $scope.state('clear');
                }
            }

            $scope.rzTranslate = function (val) {
                var unit = null;

                $scope.canonicalChanged = true;

                if ( this.attributes ) {
                    unit = this.attributes.groupUnit || this.attributes['groupUnit'] || this.attributes['data-group-unit'];
                }

                if ( this.options.groupUnit ) {
                    unit = this.options.groupUnit;
                }

                val = val || this.minValue || 0;
                val = String(val).replace(".",",");
                return val + (unit ? ' ' + unit : '');
            }

            $scope.state = function (lastUpdated) {
                $scope.filterSelected.lastUpdated = lastUpdated;

                console.info('State changed by %s with %o', lastUpdated, $scope.filterSelected);

                var filterForState = angular.toJson(filterNullValuesRange($scope.filterSelected));
                $scope.saveState('filter', filterForState);

                saveSession('filter', filterForState);

                $scope.canonicalChanged = true;

                $scope.setPage(1, false);
            }

            function filterDefaultValues () {

                // Iterate new filter map to make sure values are set properly for prices and ranges
                if ($attrs.filter && $scope.filterMap) {

                    // Prices
                    if (typeof $scope.filterMap.prices !== 'undefined' && $scope.filterMap.prices.show) {
                        if (typeof $scope.filterSelected.minPrice === 'undefined') {
                            $scope.filterSelected.minPrice = $scope.filterMap.prices.data.low;
                        }
                        if (typeof $scope.filterSelected.maxPrice === 'undefined') {
                            $scope.filterSelected.maxPrice = $scope.filterMap.prices.data.high;
                        }
                    }

                    // Data
                    if (typeof $scope.filterMap.data !== 'undefined' && $scope.filterMap.data.length) {
                        var dataSelected = $scope.filterSelected.data || {};
                        _.forEach($scope.filterMap.data, function (dataGroup) {
                            if (typeof dataSelected[dataGroup.id] === 'undefined' && dataGroup.show && dataGroup.show == 'range') {
                                dataSelected[dataGroup.id] = dataGroup.data;
                                dataSelected[dataGroup.id]['from'] = dataGroup.data.low;
                                dataSelected[dataGroup.id]['to'] = dataGroup.data.high;
                            }
                        });

                        $scope.filterSelected.data = dataSelected;
                    }
                }
            }

            function filterNullValuesRange (filterSelected) {

                var filter = _.cloneDeep(filterSelected);

                if (!filter || !$scope.filterMap) return filter;

                if (filter.data && $scope.filterMap.data) {
                    _.each($scope.filterMap.data, function (value) {
                        var key = value.id;
                        var selected = filter.data[key];

                        if (selected) {
                            var hasNoSliderChanges = false;

                            if (value.show === "range") {
                                hasNoSliderChanges = (
                                    (Number.isNaN(selected.from) || selected.from === null || selected.from == value.data.low) 
                                    || (Number.isNaN(selected.to) || selected.to === null || selected.to == value.data.high)
                                );
                            }
                            
                            if (hasNoSliderChanges || value.show === false) {
                                delete filter.data[key];
                            }
                        }
                    });
                }

                if (filter.maxPrice && filter.minPrice && $scope.filterMap.prices) {
                    sliderChanged = true;
                    if ( filter.maxPrice == $scope.filterMap.prices.data.high && filter.minPrice == $scope.filterMap.prices.data.low ) {
                        sliderChanged = false;
                    }
                }

                return filter;
            }

            function scrollTop () {
                $.scrollTo('.product-scroll-target', 100);
            }

            function redirectWithPage(page) {
                window.location.href = $scope.link(page);
                if (page !== 1) {
                    window.location.reload();
                }
            }
        }
    ]);

    app.controller('product-ctrl', ['$scope', '$element', '$rootScope', '$attrs', '$filter', '$location', '$sce',
        function ($scope, $element, $rootScope, $attrs, $filter, $location, $sce) {

            // Description (html trust)
            $scope.product.DescriptionList = $sce.trustAsHtml($scope.product.DescriptionList);

            // Image
            var defaultImage = platform.template.cdn + $scope.product.Images[0];
            $scope.image = defaultImage;

            // Handle
            var productHandle = $scope.product.Handle;

            // Item number
            $scope.itemNumber = $scope.product.ItemNumber;

            // NEW if younger than 30 days (2.592.000 seconds)
            $scope.isNew = $scope.product.Age <= 2592000;

            // Variants
            $scope.hasVariants = $scope.product.Type == 'variant';
            if ($scope.hasVariants) {
                $scope.hasChosenVariant = false;
            } else {
                $scope.hasChosenVariant = true;
            }
            $scope.showButtons = platform.getSetting('product_list_show_buttons');
            $scope.showVariants = $scope.hasVariants && $scope.showButtons;
            if ($scope.showVariants) {
                $scope.variantDefault = ($scope.product.VariantTypes.length == 1 ? window.text.CHOOSE_VARIANT + ' ' + $scope.product.VariantTypes[0].Title : window.text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT);
                $scope.variantDefault = $filter('decode')($scope.variantDefault);
            }

            // MinAmount
            $scope.minAmount = $scope.product.MinAmount;

            // Stock
            $scope.stock = parseInt($scope.product.Stock);
            $scope.stockIsNaN = isNaN($scope.stock);

            // Soldout
            $scope.isSoldout = $scope.product.Soldout;
            $scope.soldout = $scope.isSoldout && !$scope.product.AllowOutOfStockPurchase;

            // Delivery text
            $scope.deliveryId = $scope.product.DeliveryTimeId;
            $scope.deliveryText = $scope.product.DeliveryTimeText;

            // Unit title
            $scope.unitTitle = $scope.product.UnitTitle;

            // Legacy
            $scope.paymentOptions = [];

            // VAT text
            $scope.vatText = text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO;

            // Prices
            if ($scope.product.CallForPrice) {

                // Call for price
                $scope.price = window.text.PRODUCT_CATALOG_CALL_FOR_PRICE;

                // Hide discount
                $scope.onSale = false;

            } else {

                // Main price
                var mainPrice = $scope.product.Prices[0];
                $scope.price = "";

                // Check if minAmount is more than 1, append price info text
                if (mainPrice.Amount > 1) {
                    $scope.price += window.text.PRODUCT_CATALOG_PRICE_FOR + " " + mainPrice.Amount + " " + $scope.product.UnitTitle + " ";
                }

                // Check for price range, prepend text if a difference is detected or if product is a type of giftcard
                if (mainPrice.PriceMin != mainPrice.PriceMax || $scope.product.Type == 'giftcard' || $scope.product.Type == 'codegiftcard') {
                    $scope.price += window.text.PRODUCT_CATALOG_PRICE_FROM + " ";
                }

                // Check for vat on product
                if (platform.currency.hasVat && (platform.settings.vat_label_advanced == false || mainPrice.PriceMinWithVat > mainPrice.PriceMinWithoutVat)) {
                    $scope.vatText = text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX;
                }

                $scope.price += $filter('currency_format')(mainPrice.PriceMin);

                // Discount
                if (mainPrice.PriceMin < mainPrice.FullPriceMin) {
                    $scope.discount = mainPrice.FullPriceMin;
                    $scope.onSale = true;
                }

                // Combination
                var combo = null;
                _.each($scope.product.Prices, function (v, k) {
                    if ((v.PriceMin < mainPrice.PriceMin && (!combo || v.PriceMin < combo.PriceMin))) {
                        combo = v;
                    }
                });

                if (combo) {
                    $scope.combo = window.text.PRODUCT_CATALOG_PRICE_FOR + ' ' + combo.Amount + ' ' + $scope.product.UnitTitle + ' ' + $filter('currency_format')(combo.PriceMin);
                }
            }

            // Transaction
            $scope.showPrices = $scope.product.ShowPrices;

            $scope.setButtonMode = function (buyable, variant) {
                var v = 0; // Show product

                if ($scope.showPrices && buyable) {
                    v = 1; // Buy product

                    if ($scope.showVariants && !variant) {
                        v = 2; // Choose variant
                    }
                }

                $scope.buttonMode = v;
            }

            // Init
            $scope.setButtonMode($scope.product.Buyable, false);


            // Submit
            $scope.processProductSubmit = function () {
                $scope.returnUrl = $location.absUrl();
                return true;
            }


            // Variant update
            $scope.$on('update.product' + $scope.product.Id, function(e, o) {
                $scope.$apply(function() {

                    if (o.Price) {
                        var mainPrice = o.Price;
                        $scope.price = "";

                        // Check if minAmount is more than 1, append price info text
                        if (mainPrice.Amount > 1) {
                            $scope.price += window.text.PRODUCT_CATALOG_PRICE_FOR + " " + mainPrice.Amount + " " + $scope.product.UnitTitle + " ";
                        }

                        $scope.price += $filter('currency_format')(mainPrice.PriceMin);

                        // Discount
                        if (mainPrice.PriceMin < mainPrice.FullPriceMin) {
                            $scope.discount = mainPrice.FullPriceMin;
                            $scope.onSale = true;
                        } else {
                            $scope.discount = 0;
                            $scope.onSale = false;
                        }

                        // Combination
                        var combo = null;
                        _.each(o.Prices, function (v, k) {
                            if ((v.PriceMin < mainPrice.PriceMin && (!combo || v.PriceMin < combo.PriceMin))) {
                                combo = v;
                            }
                        });

                        if (combo) {
                            $scope.combo = window.text.PRODUCT_CATALOG_PRICE_FOR + ' ' + combo.Amount + ' ' + $scope.product.UnitTitle + ' ' + $filter('currency_format')(combo.PriceMin);
                        } else {
                            $scope.combo = null;
                        }
                    }

                    $scope.unitTitle = o.UnitTitle;

                    $scope.stock = parseInt(o.Stock);
                    $scope.stockIsNaN = isNaN($scope.stock);

                    $scope.minAmount = o.MinAmount;

                    if (o.Picture) {
                        $scope.image = platform.template.cdn + o.Picture;
                    } else {
                        $scope.image = defaultImage;
                    }

                    $scope.lazyloadImage();

                    $scope.itemNumber = o.ItemNumber ? o.ItemNumber : $scope.product.ItemNumber;

                    $scope.isSoldout = o.Soldout;
                    $scope.soldout = $scope.isSoldout && !o.AllowOutOfStockPurchase;

                    $scope.deliveryId = o.DeliveryTimeId;
                    $scope.deliveryText = o.DeliveryTimeText;

                    $scope.variantDefault = $filter('decode')(o.Title);

                    $scope.product.Handle = productHandle + "?variantId=" + o.Id;

                    // Refresh button mode, make sure main product is buyable
                    $scope.setButtonMode(($scope.product.Buyable ? o.Buyable : false), true);

                    $scope.hasChosenVariant = true;

                    $rootScope.$broadcast('equalizer.rerun');
                });
            });

            $scope.lazyloadImage = function () {
                $element.find('img.m-productlist-image').addClass('lazyload');
            }

            $scope.toggleFlashVariant = function () {
                $scope.flashVariant = true;
                setTimeout(function () {
                    $scope.$apply(function () {
                        $scope.flashVariant = false;
                    });
                }, 1000);
            }

        }
    ]);

    // Legacy
    app.controller('filter-ctrl', [function () {}]);

})(jQuery, window.platform, window);
