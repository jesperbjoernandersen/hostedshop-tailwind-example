;(function ($, eksport, undefined) {
    'use strict';

    var controller = {
        init : function (el) {
            var self = this;
            this.initVariantType = $.proxy(this.initVariantType, this);
            this.el = el;

            if (!$.templates && typeof $.templates !== "function") {
                noTemplateEngine();
                return;
            }

            //
            self.$buyBtns               = $("[data-controller='buy'][name='cartadd'][type='submit']");
            self.$wishlistBtn           = $("[data-controller='wishlist']");
            self.$preselect             = $("[data-controller='preselect']");
            self.$paymentOptions        = this.el.find(".option");

            // setup event handlers
            self.handleSelect           = $.proxy(self.handleSelect, self);
            self.handleUnselect         = $.proxy(self.handleUnselect, self);
            self.handlePacketSelect     = $.proxy(self.handlePacketSelect, self);
            self.handlePacketUnselect   = $.proxy(self.handlePacketUnselect, self);
            self.handleBuy              = $.proxy(self.handleBuy, self);
            self.handleWishlist         = $.proxy(self.handleWishlist, self);

            // setup event bindings
            window.platform.subscribe("/product/variant/selected", self.handleSelect);
            window.platform.subscribe("/product/variant/unselected", self.handleUnselect);
            window.platform.subscribe("/product/packet/selected", self.handlePacketSelect);
            window.platform.subscribe("/product/packet/unselected", self.handlePacketUnselect);

            this.initProductType();
            this.initPaymentOptions();
        },




        initPaymentOptions : function () {
            var self = this;

            if (!self.$paymentOptions.length) { return; }

            var $klarnakp = self.$paymentOptions.find('klarna-placement');

            if ($klarnakp.length) {
                window.platform.subscribe("/product/selected", function (event, data) {
                    var product = data[0],
                        item = data[1] || null,
                        prices = (item && item.Id) ? item.Prices[0] : product.Prices[0];

                    $klarnakp
                        .data("purchase_amount", prices.PriceMin)
                        .attr("data-purchase_amount", prices.PriceMin);

                    window.KlarnaOnsiteService = window.KlarnaOnsiteService || [];  // Making sure that data layer exists in case JavaScript Library is loaded later for any reason
                    window.KlarnaOnsiteService.push({ eventName: 'refresh-placements' }); // Push the event to the data layer
                });
            }
        },




        initProductType : function () {
            var self = this;

            if (window.platform.classes && window.platform.classes.Product && typeof window.platform.classes.Product === "function") {
                self.product = new window.platform.classes.Product(self.el.data("controller"));
                self.product.get(function (product) {
                    if (product && product.Id) {
                        window.platform.product = self.product;
                        window.platform.publish("/product/ready", self.product);

                        if (self.$preselect.length) {
                            window.platform.product.VariantDisplayMode = "preselect";
                            product.VariantDisplayMode = "preselect";
                        }

                        if (product.Type === "variant") {
                            self.initVariantType(product.VariantDisplayMode);
                            self.initImageType(window.platform.settings.shop_product_image_structure);
                        }

                        if (product.Type === "packet") {
                            self.initPacketType();
                        }

                        if (product.Type === "packet" || product.Type === "variant") {
                            // setup dom event bindings
                            self.$buyBtns.on("click", self.handleBuy);
                            self.$wishlistBtn.on("click", self.handleWishlist);
                        }

                        window.platform.publish("/product/selected", [self.product]);
                    } else {
                        productError();
                    }
                });
            } else {
                productError();
            }
        },




        initVariantType : function (displayMode) {
            var self = this;
            if (!displayMode) {
                typeError("Variant: No type defined / unknown type.");
                return;
            }

            if (typeof $.fn.select2 !== "function") {
                noSelect2Error();
                return;
            }

            var variantName = formatVariantName(displayMode);
            if (window.platform.classes && window.platform.classes.variant && typeof window.platform.classes.variant[variantName] === "function") {
                self.productType = new window.platform.classes.variant[variantName](self.product);
                self.productType.init();
            } else {
                typeError("Variant: "+variantName);
            }
        },




        initImageType : function (displayMode) {
            var self = this;
            displayMode = (displayMode !== 'zoom') ? 'rotation' : 'zoom';

            if (window.platform.classes && window.platform.classes.image && typeof window.platform.classes.image[displayMode] === "function") {
                self.image = new window.platform.classes.image[displayMode](self.product);
            }
        },



        initPacketType : function () {
            var self = this;

            if (window.platform.classes && window.platform.classes.Packet && typeof window.platform.classes.Packet === "function") {
                self.productType = new window.platform.classes.Packet(self.product);
                self.productType.init();
            } else {
                typeError("Product:Packet");
            }
        },




        handleUnselect : function(event) {
            var self = this;

            self.product.updateUnitTitle(null, true);
            self.product.updatePanel(null, true);
            self.product.updateInputs(null, true);
            self.product.updateDescriptions(null, true);
            self.image.unselect();
        },




        handleSelect : function(event, data) {
            var self = this,
                item = data[0];

            if (item) {
                self.product.updateUnitTitle(item);
                self.product.updatePanel(item);
                self.product.updateInputs(item);
                self.product.updateDescriptions(item);
                self.image.select(item);
                window.platform.publish("/product/selected", [self.product, item]);
            } else {
                noTypeError("Variant:"+ formatVariantName(self.product.VariantDisplayMode));
            }
        },




        handlePacketUnselect : function(event) {
            var self = this;

            self.product.updatePanel(null, true);
            self.product.updateInputs(null, true);
        },




        handlePacketSelect : function(event, data) {
            var self = this;
            if (data[0]) {
                var item = data[0];
                self.product.updatePacketPanel(item, false);
                self.product.updateInputs(item);
                window.platform.publish("/product/selected", [self.product, item]);
            } else {
                noTypeError("Product:Packet");
            }
        },




        handleBuy : function(e) {
            var self = this;

            window.platform.publish("/product/buy", self.product);

            if (self.productType.canDoActions()) {
                window.platform.publish("/product/buy/add", self.product);
            } else {
                e.preventDefault();
                window.platform.publish("/product/buy/warning", self.product);
                self.product.showWarning();
            }
        },




        handleWishlist : function (e) {
            var self = this;

            window.platform.publish("/product/wishlist", self.product);

            if (self.productType.canDoActions()) {
                window.platform.publish("/product/wishlist/add", self.product);
            } else {
                e.preventDefault();
                window.platform.publish("/product/wishlist/warning", self.product);
                self.product.showWarning();
            }
        }
    }




    // ==========================================================================
    // Init
    // ==========================================================================

    $(function() {
        var el = $("[data-controller]");
        if ( el.length && el.data("controller") && $.isNumeric(el.data("controller")) ) {
            controller.init(el);
        } else {
            return;
        }
    });




    // ==========================================================================
    // Helpers
    // ==========================================================================
    var addPubSub = function (q) {
        var topics = {}, subUid = -1;
        q.subscribe = function(topic, func) {
            if (!topics[topic]) {
                topics[topic] = [];
            }
            var token = (++subUid).toString();
            topics[topic].push({
                token: token,
                func: func
            });
            return token;
        };

        q.publish = function(topic, args) {
            if (!topics[topic]) {
                return false;
            }
            setTimeout(function() {
                var subscribers = topics[topic],
                    len = subscribers ? subscribers.length : 0;

                while (len--) {
                    subscribers[len].func(topic, args);
                }
            }, 0);
            return true;

        };

        q.unsubscribe = function(token) {
            for (var m in topics) {
                if (topics[m]) {
                    for (var i = 0, j = topics[m].length; i < j; i++) {
                        if (topics[m][i].token === token) {
                            topics[m].splice(i, 1);
                            return token;
                        }
                    }
                }
            }
            return false;
        };
    };

    /* add if doesnt exist */
    (function () {
        if ( !window.platform.publish ) {
            addPubSub(window.platform);
        }
    })();

    var formatVariantName = function (name) {
        name = name.toLowerCase();
        name = name.replace(" ", "");
        name = $.camelCase(name);
        return name.charAt(0).toUpperCase() + name.slice(1);
    },

    noTemplateEngine = function () {
        throw new Error("\n----------------- \nInitialization aborted: \n\tMissing Javascript template engine (jsRender Template). \n\tType and product initialization terminated. \n-----------------");
    },

    productError = function () {
        console.warn("----------------- \nInitialization aborted: \n\tMissing controller (data-controller='{$product->Id}'). \n\tType and product initialization skipped. \n-----------------");
    },

    typeError = function (type) {
        throw new Error('\n----------------- \nInitialization aborted: \n\tMissing product type: "'+ type +'". \n\tType initialization skipped. \n-----------------');
    },

    noTypeError = function () {
        throw new Error('\n----------------- \nRuntime error: \n\tNo item was found. \n\tRuntime terminated. \n-----------------');
    },

    noSelect2Error = function () {
        throw new Error('\n----------------- \nInitialization aborted: \n\tMissing jQuery Select2 plugin.". \n\tType initialization terminated. \n-----------------');
    };

    eksport.platform = eksport.platform || {};
    eksport.platform.productController = eksport.platform.productController || controller;

})(jQuery, window);
