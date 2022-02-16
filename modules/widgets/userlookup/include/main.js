;(function($, platform, exports) {
    'use strict';

    exports.platform = exports.platform || {};

    var AJAX_URL            = '/actions/handler/ajax',
        COUNTRY_ACTION      = "lookup_service_country",
        CUSTOMER_ACTION     = "lookup_service_customer",

        CONTROLLER          = '[data-lookup="controller"]',
        CHOICES             = '[data-lookup="choice"]',
        FIELD               = '[data-lookup="field"]',
        INPUT               = '[data-lookup="input"]',
        BUTTON              = '[data-lookup="button"]',

        TEMPLATES           = {
            "code"      : '<span class="input-group-addon w-userlookup__code">+{{code}}</span>',
            "loading"   : '<span class="input-group-addon panel-warning w-userlookup__button w-userlookup__button--loading"><i class="fa fa-spinner fa-pulse fa-fw" aria-hidden="true"></i></span>',
            "success"   : '<span class="input-group-addon panel-success w-userlookup__button w-userlookup__button--success"><i class="fa fa-check fa-fw" aria-hidden="true"></i></span>',
            "fail"      : '<span class="input-group-addon panel-danger w-userlookup__button w-userlookup__button--fail"><i class="fa fa-exclamation fa-fw" aria-hidden="true"></i></span>',
            "default"   : '<span class="input-group-addon w-userlookup__button w-userlookup__button--default" data-lookup="button"><i class="fa fa-search fa-fw" aria-hidden="true"></i></span>'
        };

    var UserLookupService = function (inputs) {
        var vm = this;

        vm.moduleAccess = false;
        vm.countryAccess = false;
        vm.country = false;
        vm.countriesSupported = false;
        vm.countriesSupportedCache = {};
        vm.currentCountry;
        vm.currentLookupType;
        vm.currentLookupQuery;
        vm.state = 'hidden';
        vm.inputs = inputs;

        vm.initalize();
    };

    UserLookupService.prototype = {

        initalize : function () {
            var vm = this;

            // inputs for update specified ?
            if ( !vm.inputs ) { return; }

            vm.$el = $(CONTROLLER);

            // markup container existent ?
            if ( !vm.$el.length ) { return; }

            vm.$choices = vm.$el.find(CHOICES);
            vm.$field = vm.$el.find(FIELD);
            vm.$input = vm.$el.find(INPUT);

            // markup inputs existent ?
            if ( !vm.$choices.length || !vm.$field.length || !vm.$input.length ) { return; }

            vm.moduleAccess = true;

            // bind inputs to handlers
            vm.$choices.on('change input', $.proxy(vm.handleChoiceChange, vm));
            var getHandler = $.proxy(vm.handleGet, vm);
            vm.$field.on('click', BUTTON, getHandler);
            vm.$input.keydown(function (event) {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    getHandler();
                }
            });

            // trigger change to trigger flow
            vm.handleChoiceChange();
        },





        accessController : function () {
            var vm = this;

            vm.checkAccess();

            if ( !vm.moduleAccess ) {
                vm.hide();
                return;
            }

            vm.show();

            // enable / disabled based on country access
            if ( !vm.countryAccess ) { vm.disable(); }
            if ( vm.countryAccess ) { vm.enable(); }

            // handle country picked
            if ( vm.currentCountry ) {
                vm.$field.find('.w-userlookup__code').remove();

                if ( vm.currentLookupType == 'phonenumber'
                 && vm.currentCountry.country != platform.general.deliveryCountryIso
                 && _.indexOf(vm.countriesSupported, vm.currentCountry.country) >= 0 ) {

                    vm.$field.prepend(TEMPLATES.code.replace("{{code}}", vm.currentCountry.code));
                }
            }
        },

        lookupController : function () {
            var vm = this;

            // encode function for json data
            function fixedEncodeURIComponent (str) {
              return encodeURIComponent(str).replace(/[!'()*]/g, function(c) {
                return '%' + c.charCodeAt(0).toString(16);
              });
            }

            vm.currentLookupQuery = vm.$input.val();

            if ( vm.state === 'loading' ) { return; }
            if ( !vm.currentLookupQuery || vm.currentLookupQuery.replace(" ", "") == "" ) { return; }

            vm.currentLookupQuery = fixedEncodeURIComponent(vm.currentLookupQuery);
            vm.$input.val("");
            vm.$input.attr("placeholder", window.text.USERLOOKUP_HEADLINE);

            vm.getCustomerData();
        },





        checkAccess : function () {
            var vm = this;

            vm.getAccessData();

            if ( vm.currentCountry && vm.countriesSupported && _.indexOf(vm.countriesSupported, vm.currentCountry.country) >= 0 ) {
                vm.countryAccess = true;
            } else {
                vm.countryAccess = false;
            }
        },





        getAccessData : function () {
            var vm = this;


            if ( vm.countriesSupportedCache.hasOwnProperty(vm.currentLookupType) ) {
                vm.countriesSupported = vm.countriesSupportedCache[vm.currentLookupType];
                return;
            }

            if ( vm.state === 'loading' ) { return; }

            vm.getAsync(COUNTRY_ACTION, {}, function(data) {
                vm.setState('default');
                vm.countryAccess = false;
                vm.countriesSupported = false;

                if ( data && data.code && data.result && data.code === '0' && data.result.length > 0 ) {
                    vm.countriesSupportedCache[vm.currentLookupType] = data.result;
                    vm.countriesSupported = data.result;
                    vm.moduleAccess = true;
                }

                if ( data && data.code && data.code === "1" ) {
                    vm.moduleAccess = false;
                }

                // accessController call again because if async call
                vm.accessController();
            });
        },
        getCustomerData : function () {
            var vm = this;

            vm.lookupResult = false;

            var data = vm.currentCountry;
            data.query = vm.currentLookupQuery;

            vm.getAsync(CUSTOMER_ACTION, data, function(data) {
                vm.setState('default');

                if ( data && data.code && data.result && data.code === '0' && data.result.length > 0 ) {
                    vm.lookupResult = data.result[0];
                }

                if ( data && data.code && data.code == '1' || data.code === "0" && !data.result.length ) {
                    vm.lookupResult = false;
                }

                vm.updateInputs();
            });

        },
        getAsync : function (action, customData, cb) {
            var vm = this,
                defaultData = {
                    page: 'checkout',
                    action: action,
                    type: vm.currentLookupType
                };

            var data = $.extend({}, defaultData, customData);

            vm.setState("loading");

            $.getJSON(AJAX_URL, data).then(cb);
        },







        show : function () {
            var vm = this;

            vm.$el.removeClass("is-hidden");
            vm.setState('default');
        },
        hide : function () {
            var vm = this;

            vm.$el.addClass("is-hidden");
            vm.setState('hidden');
        },
        disable : function () {
            var vm = this;

            vm.$field.addClass("is-disabled");
            vm.setState('fail');
        },
        enable : function () {
            var vm = this;

            vm.$field.removeClass("is-disabled");
            vm.setState('default');
        },






        setState : function (state) {
            var vm = this;

            if ( state ) {
                vm.state = state;

                if ( TEMPLATES.hasOwnProperty(state) ) {
                    vm.$field
                        .find(".w-userlookup__button").remove()
                        .end()
                        .append(TEMPLATES[state]);
                }
            }
        },







        handleChoiceChange : function (e) {
            var vm = this;

            if ( vm.$field.length && vm.$choices.length ) {
                vm.currentLookupType = vm.$choices.filter(":checked").val();
            }

            vm.accessController();
        },
        handleGet : function (e) {
            var vm = this;
            vm.lookupController();
        },
        updateInputs : function () {
            var vm = this;

            function clearAlert() {
                window.clearTimeout(vm.timeoutID);
                vm.setState("default");
                vm.$input.attr("placeholder", window.text.USERLOOKUP_HEADLINE);
            }


            if ( vm.lookupResult ) {
                vm.setState("success");

                _.forEach(vm.lookupResult, function(value, key) {
                    if ( vm.inputs.hasOwnProperty(key) ) {
                        var $input = $(vm.inputs[key]);
                        if ( $input.length && value != '' ) {
                            $input
                                .val(value)
                                .trigger('change');
                        }
                    }
                });

                vm.timeoutID = window.setTimeout(clearAlert, 5000);
            } else {
                vm.setState("fail");
                vm.$input.attr("placeholder", window.text.USERLOOKUP_NO_RESULT);
                vm.timeoutID = window.setTimeout(clearAlert, 5000);
            }

        },






        setCountry : function (countryObject) {
            var vm = this;
            vm.currentCountry = countryObject;
            vm.accessController();
        }


    };

    exports.platform.UserLookupService = UserLookupService;

})(jQuery, window.platform, window);
