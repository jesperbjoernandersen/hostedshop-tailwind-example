;(function () {

	"use strict";

	var app = angular.module('productlistServices', ['ngResource']);

	app.service('ProductApi', ['$resource', '$http',
        function ($resource, $http) {
            return {
                product: $resource('/json/products', {}, {
                    query: {method:'POST', isArray:false, cache:false}
                }),
                productlist: $resource('/json/products', {}, {
                    query: {method:'GET', isArray:false, cache:true}
                }),
                session: function (productlist) {
                    return $http.put('/json/session', {
                        key: 'lastProductlist',
                        value: productlist || null
                    });
                }
            }
        }
    ]);

    app.service('FilterService', [
        function () {
            return {
                hasChanges: function (data, filterMap) {
                    
                    if (!data) { return; }
                    
                    var defaults = this.getDefaults(filterMap),
                        filtersChanged = false;
                    
                    _.forEach(data, function (option, key) {
                        if (key === 'data') {
                            _.forEach(option, function (item) {
                                
                                if (!item) { return; }
                                
                                // variants
                                if (item.length) {
                                    filtersChanged = true;
                                }
                                
                                if (item.from && item.low && item.to && item.high) {
                                    if (item.from !== item.low || item.to !== item.high) {
                                        filtersChanged = true;
                                    }
                                }
                            });
                        }
                        if (key !== 'data' && key !== 'lastUpdated' && key !== 'maxPrice' && key !== 'minPrice' && !_.isEqual(defaults[key], option)) {
                            filtersChanged = true;
                        }
                    });

                    if (filterMap && filterMap.prices && data.maxPrice && data.minPrice) {   
                        if (defaults.maxPrice !== data.maxPrice || defaults.minPrice !== data.minPrice) {
                            filtersChanged = true;
                        }
                    }

                    return filtersChanged;
                },

                getDefaults: function (filterMap) {
                    var defaults = {
                        brand: [],
                        categories: [],
                        data: {},
                        search: '',
                        sale: false,
                        news: false
                    }
                    if (filterMap) {
                        var prices = filterMap.prices;
                        if (prices && prices.data.high && prices.data.low) {
                            defaults.maxPrice = prices.data.high;
                            defaults.minPrice = prices.data.low;
                        }
                        if (filterMap.data) {
                            _.forEach(filterMap.data, function (item) {
                                item.show === 'range' && item.data ?
                                    defaults.data[item.id] = {
                                        'high': item.data.high,
                                        'low': item.data.low,
                                        'to': item.data.high,
                                        'from': item.data.low
                                    } : {};
                            });
                        }
                    }

                    return defaults;
                },

                setDefaults: function (defaultValues, lastUpdated) {
                    var options = this.getDefaults(defaultValues);
                    if (lastUpdated) {
                        options['lastUpdated'] = lastUpdated;
                    }
                    return options;
                },

                resetSelect: function (filter, option) {
                    if (filter) {
                        if (filter[option]) {
                            filter[option] = [];
                        }
                        if (filter.data && filter.data[option]) {
                            delete filter.data[option];
                        }
                        return filter;
                    }
                }
            }
        }
    ]);

    app.service('LinkService', ['$location',
        function($location) {

            return {
                clear: function() {
                    angular.element('head link[rel="prev"]').remove();
                    angular.element('head link[rel="next"]').remove();
                    angular.element('head link[rel="canonical"]').remove();
                },

                set: function (links, hasFilterChanged, page) {
                    links = _.filter(links, 'value');

                    var next = _.find(links, { 'name': 'next' });

                    // we dont want canonical on page 1 unless filter has changed.
                    if ( hasFilterChanged ) {
                        links.push({'name':'canonical', 'value': page});
                    }

                    console.info('Links set with %o, filter has changed %s, page is %i', links, hasFilterChanged, page);

                    this.clear();
                    this.update(links);
                },

                update: function (links) {
					var self = this;

                    _.each(links, function (item) {
						var val = item['value'],
							key = item['name'],
                    	    el = angular.element('head > link[rel="'+ key +'"]');

                    	if ( !el.length ) {
                			el = angular.element('<link rel="'+ key +'">').appendTo('head');
                        }

                        el.attr('href', self.build(val));
                    });
                },

                build: function(page) {
                    var url = location.protocol +"//"+ location.hostname + location.pathname,
                        allowedSearch = ['brand','new','sale','search','tag'],
                        search = this.getQueryParameters(location.search);

                    var keys = _.intersection(allowedSearch, _.keys(search));

                    if ( keys.length ) {
                        url = url + '?';
                        url = url + keys[0] + (search[keys[0]] ? '=' + search[keys[0]] : '');
                        // we only take first index, since we dont support multiple filtering ie no ?new&sale
                    }

                    if ( page && page > 1 ) {
						url = url+"#!?page="+page;
                    }

					return url;
                },

				buildComplete: function(page) {
					var urlSearch = _.extend({}, $location.search()),
						url = $location.absUrl(),
						newUrl = url;

					if ( page == 1 ) {
						newUrl = url.replace(/(&|\?)page=\d/,'');

						if ( urlSearch.hasOwnProperty('page') ) {
							delete urlSearch.page;
						}

						if ( _.isEmpty(urlSearch) ) {
							newUrl = newUrl.replace(/#\!/,'');
						}

						return newUrl;
					}

					if ( urlSearch.hasOwnProperty('page') ) {
						newUrl = url.replace(/page=(\d+)$/, 'page='+page);
					} else {
						if ( _.isEmpty(urlSearch) ) {
							newUrl += '#!?page=';
						} else {
							newUrl += '&page=';
						}
						newUrl += page;
					}

					return newUrl;
                },

                getQueryParameters: function (str) {
                    return (str || document.location.search).replace(/(^\?)/, '').split("&").map(function (n) { return n = n.split("="), this[n[0]] = n[1], this }.bind({}))[0];
                }
            };
        }
    ]);
})();
