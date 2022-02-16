;(function ($, eksport) {
    'use strict';

    var PRODUCT_TYPE = "packet",
        PRODUCT_TYPE_SELECTOR = "[data-"+PRODUCT_TYPE+"]";


    // ==========================================================================
    // Packet product prototype
    // ==========================================================================

    var PacketProduct = function (product) {
        var self = this;

        this.packetItems = [];
        this.product = product;
    };



    PacketProduct.prototype = {

        //
        // Init function
        //
        init : function () {
            var self = this,
                $packetItems = $(PRODUCT_TYPE_SELECTOR);

            //
            // PacketItem for each item in packet
            //

            $packetItems.each(function () {
                var $this = $(this),
                    settings = {
                        $this       : $this,
                        product     : self.product,
                        type        : $this.data(PRODUCT_TYPE)
                    };

                var my_packetItem = new PacketItem(settings);
                my_packetItem.init();
                self.packetItems.push(my_packetItem);
            });

            self.hasPicked = $.proxy(self.hasPicked, self);

            window.platform.subscribe("/product/packetItem/selected", self.hasPicked);
        },



        //
        // On select
        //

        hasPicked : function(e) {

            if ( this.areAllPicked() ) {
                var item = this.getItem();
                window.platform.publish("/product/packet/selected", [item]);
            } else {
                window.platform.publish("/product/packet/unselected", []);
            }
        },

        areAllPicked : function () {
            return !_.find(this.packetItems, function (item) {
                return !item.isPicked();
            });
        },





        //
        // Stock
        //

        getItem : function () {
            var self = this,
                item = this.getLowestStockItem(),
                stock = item.getStock();

            var MinAmount = self.product.MinAmount,
                inStock = self.areAllInStock();

            return {
                isPacket        : true,
                Stock           : stock,
                MinAmount       : MinAmount,
                InStock         : inStock,
                DeliveryTimeId  : self.product.DeliveryTimeId,
                DeliveryTimeText : inStock ? self.product.DeliveryTimeTexts.inStock : self.product.DeliveryTimeTexts.notInStock
            };
        },

        areAllInStock : function () {
            return !_.find(this.packetItems, function (item) {
                return !item.isInStock();
            });
        },

        getLowestStockItem : function () {
            try {
                var lowestStockItem = null;
                this.packetItems.forEach(function(item) {
                    if (lowestStockItem === null) {
                        lowestStockItem = item;
                    } else if (item.getStock() < lowestStockItem.getStock()) {
                        lowestStockItem = item;
                    }
                });

                return lowestStockItem;
            } catch (error) {
                this.packetItems[0];
            }
        },






        //
        // Function required by controller
        //

        canDoActions : function () {
            return this.areAllPicked() && (this.product.AllowOutOfStockPurchase || this.areAllInStock());
        }
    };

















    // ==========================================================================
    // PacketItem Prototype
    // ==========================================================================

    var PacketItem = function (args) {
        var self = this;
        $.extend(this, args);
        $.extend(this, self.$this.data());

        self.item;
    };




    PacketItem.prototype = {

        //
        // Init function
        //

        init : function () {
            var self = this;

            if (self.type === "dropdown") {
                self.initDropdown();
            }
        },




        initDropdown : function () {
            var self = this;

            self.format = $.proxy(self.format, self);

            self.$this.show();
            self.$this.select2({
                formatResult: self.format,
                formatSelection: self.format,
                formatSearching : function() {
                    return '<img class="spinner" alt src="' + window.platform.template.cdn + '/_design/common/img/ajax-loader-bar.gif">';
                },
                minimumResultsForSearch: -1
            });

            self.$this.on("select2-selecting", function (e) {
                self.item = e.object;
                window.platform.publish("/product/packetItem/selected", [e.object]);
            });
        },





        //
        // Format a line of code
        //

        format : function (option) {
            var self = this,
                $option = $(option.element),
                title = "",
                data = $.extend({}, $option.data());

            if ( data.type == "normal" ) {
                title = data.title;
            }

            if ( data.type == "variant" ) {
                var html = [];
                // build the title tect
                for ( var i = 0; i < data.variant.length; i++) {
                    html.push(self.getGfx(data.variant[i]) + " " + data.variant[i].Title);
                }

                title = data.title + html.join(" / ");
            }

            if ( option.disabled ) {
                title += "<i class=\"panel-danger\" style=\"background-color:transparent;\"> - "+ window.text.SOLD_OUT +"</i>";
            }

            return title;
        },

        //
        // Display color for a item
        //

        getGfx : function (item) {
            var self = this,
                color,
                tmpl = "<span class='fa fa-square' style='{{color}}'></span> ";

            // if no color defined for variant set to blank
            if ( !item.Color ) {
                return "";
            }

            color = "color:#"+item.Color+";";

            if ( item.Color && item.Color.toLowerCase() === "ffffff" ) {
                color = color+";border-radius:3px;border:1px solid #888;";
            }

            return tmpl.replace("{{color}}", color);
        },




        //
        // is picked functions
        //

        isPicked : function () {
            var fn          = "IsPicked",
                pickedFn    = this.type + fn;

            return (typeof this[pickedFn] == "function") ? this[pickedFn]() : false;
        },

        normalIsPicked : function () {
            return true;
        },

        dropdownIsPicked : function () {
            return this.$this.val() !== "";
        },




        //
        // in stock functions
        //

        isInStock : function () {
            var fn = "IsInStock",
                stockFn = this.type + fn;

            return (typeof this[stockFn] == "function") ? this[stockFn]() : false;
        },

        normalIsInStock : function () {
            return !this.disabled && 0 < this.normalGetStock();
        },

        dropdownIsInStock : function () {
            var data = $(this.item.element).data();
            return !data.disabled && 0 < this.dropdownGetStock();
        },




        //
        // get stock functions
        //

        getStock : function () {
            var fn = "GetStock",
                stockFn = this.type + fn;

            return (typeof this[stockFn] == "function") ? this[stockFn]() : false;
        },

        normalGetStock : function () {
            return parseInt(parseInt(this.stock,10) / parseInt(this.packetamount, 10));
        },

        dropdownGetStock : function () {
            var data = $(this.item.element).data();
            return parseInt(parseInt(data.stock, 10) / parseInt(data.packetamount, 10));
        }
    };








    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.Packet = PacketProduct;

})(jQuery, window);
