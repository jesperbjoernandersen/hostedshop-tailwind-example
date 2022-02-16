;(function ($, eksport, undefined) {
    'use strict';

    var VARIANT_TYPE = "buttons",
        VARIANT_TYPE_SELECTOR = "[data-variantType='"+ VARIANT_TYPE +"']",
        VARIANT_DATA_SELECTOR = "[data-variantData='"+ VARIANT_TYPE +"']";




    // ==========================================================================
    // Variant Prototype
    // ==========================================================================

    var Variant = function(product) {
        var self = this;

        this.API = {
            // product variantTypes
            types       : "/json/productvariants/types/{productId}",

            // product variantTypes with data
            typesData   : "/json/productvariants/types/{productId}?fields=data",

           // product variantDatas
            datas       : "/json/productvariants/data/{productId}",

            // product variantTypes with data
            typeData    : "/json/productvariants/data/{productId}?typeId={typeId}",

            // product variantTypes with data
            //typeDatas   : "/json/productvariants/data/{productId}?typeId={typeId}&dataIds={dataIds}",
            typeDatas   : "/json/productvariants/data/{productId}",

            // product variant from datas
            variant     : "/json/productvariants/{productId}"
        };

        this.variantTypes = [];
        this.hasVariant = false;
        this.product = product;
        this.tries = 0;
    };




    Variant.prototype = {

        //
        // Init function
        //

        init : function () {
            var self = this,
                $variants = $(VARIANT_TYPE_SELECTOR);

            $variants.each(function (idx) {
                var $this = $(this),
                    settings = {
                        $this       : $this,
                        productId   : self.product.Id,
                        id          : $this.data("varianttypeid")
                    };

                var variantType = new VariantType(settings);
                variantType.init();
                self.variantTypes.push(variantType);
            });

            self.handleVariantDataUpdate = $.proxy(self.handleVariantDataUpdate, self);

            window.platform.subscribe("/variant/variantData/selected", self.handleVariantDataUpdate);
            window.platform.subscribe("/variant/variantData/unselected", self.handleVariantDataUpdate);

            if($("html").hasClass("ielt9")) {
                self.addListener();
            }

            return self;
        },




        addListener : function () {
            var self = this;

            $(".m-product-variants.m-buttons").find("label").on("click", function(e) {
                var $this = $(this),
                    $for = $this.prop("for");

                if ($for !== "") {
                    $this.parents(".input-group").find("#" + $for).trigger("click");
                }

                e.preventDefault();
                e.stopPropagation();
            });
        },




        handleVariantDataUpdate : function (event, args) {
            var self = this,
                selectedVariantDatas = self.getSelectedVariantDatas();
            /**
             * args:
             *  0 : variantTypeId,
             *  1 : variantDataId,
             */

            var allVariantOptionsSelected = selectedVariantDatas.count === self.variantTypes.length;

            if (allVariantOptionsSelected) {
                self.getVariant(selectedVariantDatas, function (variant) {
                    if (variant && variant.Id) {
                        self.hasVariant = true;
                        self.variant = variant;
                        window.platform.publish("/product/variant/selected", [self.variant]);
                    } else {
                        self.hasVariant = false;
                        self.variant = undefined;
                        window.platform.publish("/product/variant/unselected");
                    }
                });
            } else {
                self.updateVariantTypes(selectedVariantDatas);
                self.hasVariant = false;
                self.variant = undefined;
                window.platform.publish("/product/variant/unselected");
            }
        },




        getSelectedVariantDatas : function () {
            var self = this,
                selected = {},
                count = 0;

            for (var i = self.variantTypes.length - 1; i >= 0; i--) {
                if (self.variantTypes[i].hasVariantData()) {
                    selected[self.variantTypes[i].id] = {dataId : self.variantTypes[i].getDataId()};
                    count++;
                }
            };

            selected.count = count;

            return selected;
        },




        updateVariantTypes : function (selected) {
            var self = this;

            for (var i = self.variantTypes.length - 1; i >= 0; i--) {
                self.variantTypes[i].updateVariantDatas(selected);
            };
        },




        getVariant : function (selectedVariantDatas, cb) {
            var self = this;

            if (typeof cb !== "function") return;

            self.tries = self.tries + 1;
            $.get(this.API.variant.replace("{productId}", self.product.Id), {dataIds: self.getDataIds(selectedVariantDatas)})
                .done(function( data ) {
                    self.item = (data.count) ? data.data[0] : undefined;
                    $.extend(self, self.item);
                    cb( self.item );
                })
                .fail(function () {
                    if (self.tries < 3) {
                        self.getVariant(selectedVariantDatas, cb);
                    } else {
                        self.item = undefined;
                        cb( self.item );
                    }
                });
        },




        getDataIds : function (selected) {
            var self = this;
            return _.map(_.filter(selected, 'dataId'), 'dataId').join(",");
        },



        canDoActions : function () {
            var self = this;
            return self.hasVariant && self.variant && (self.variant.Stock >= self.variant.MinAmount || (self.variant.Stock < self.variant.MinAmount && self.variant.AllowOutOfStockPurchase));
        }
    };








    // ==========================================================================
    // VariantType Prototype
    // ==========================================================================

    var VariantType = function (args) {
        var self = this;

        this.API = {
            // product variantTypes with data
            //typeDatas   : "/json/productvariants/data/{productId}?typeId={typeId}&dataIds={dataIds}",
            typeDatas   : "/json/productvariants/data/{productId}?typeId={typeId}"
        };

        this.variantDatas = [];
        this.tries = 0;

        $.extend(this, args);
    };



    VariantType.prototype = {

        //
        // Init function
        //

        init : function () {
            var self = this,
                $variantDatas = self.$this.find(VARIANT_DATA_SELECTOR);

            $variantDatas.each(function (idx) {
                var $this = $(this),
                    settings = {
                        $this           : $this,
                        productId       : self.productId,
                        id              : $this.data("variantdataid"),
                        variantTypeId   : self.id
                    };

                var variantData = new VariantData(settings);
                variantData.init();
                self.variantDatas.push(variantData);
            });
        },




        hasVariantData : function () {
            var self = this,
                hasVariantData = false;

            for (var i = self.variantDatas.length - 1; i >= 0; i--) {
                if ( self.variantDatas[i].isSelected() ) {
                    self.dataId = self.variantDatas[i].id;
                    hasVariantData = true;
                    break;
                }
            };

            if (hasVariantData === false) {
                delete self.dataId;
            }

            return hasVariantData;
        },




        getDataId : function () {
            var self = this;
            return self.dataId;
        },




       updateVariantDatas : function (selected) {
            var self = this;


            for (var i = self.variantDatas.length - 1; i >= 0; i--) {
                self.variantDatas[i].disable(selected);
                self.variantDatas[i].hide(selected);
            };

            self.getVariantDataIds(selected, function (datas) {
                for (var i = self.variantDatas.length - 1; i >= 0; i--) {
                    self.variantDatas[i].enable(datas);
                };
            });

        },





        getVariantDataIds : function (selected, cb) {
            var self = this;

            if (typeof cb !== "function") return;

            self.tries = self.tries + 1;
            $.get(this.API.typeDatas.replace("{productId}", self.productId).replace("{typeId}", self.id), {dataIds: self.getDataIds(selected)})
                .done(function( data ) {
                    cb( data );
                })
                .fail(function () {
                    if (self.tries < 3) {
                        self.getVariantDataIds(selected, cb);
                    } else {
                        cb( undefined );
                    }
                });
        },




        getDataIds : function(selected) {
            var self = this;
            return _.map(_.filter(selected, 'dataId'), 'dataId').join(",");
        }
    };








    // ==========================================================================
    // VariantData Prototype
    // ==========================================================================

    var VariantData = function (args) {
        var self = this;

        this.hasVariantData = false;

        $.extend(this, args);
    };



    VariantData.prototype = {

        //
        // Init function
        //

        init : function () {
            var self = this;

            self.$checkbox = self.$this.find("input[type='checkbox']");
            self.$inputGroup = self.$this.find(".input-group");

            self.$checkbox.on("change", function (e) {
                //e.preventDefault();
                //e.stopPropagation();
                if(self.$checkbox.is(":disabled")) return;

                if(self.$checkbox.is(":checked")) {
                    window.platform.publish("/variant/variantData/unselect", [self.variantTypeId, self.id]);
                    window.platform.publish("/variant/variantData/selected", [self.variantTypeId, self.id]);
                    self.show();
                } else {
                    window.platform.publish("/variant/variantData/unselected", [self.variantTypeId, self.id]);
                }

            });

            self.unselect = $.proxy(self.unselect, self);

            window.platform.subscribe("/variant/variantData/unselect", self.unselect);
        },



        unselect : function (event, args) {
            var self = this;

            /**
             * args:
             *  0 : variantTypeId,
             *  1 : variantDataId,
             */

            if ( self.variantTypeId == args[0] && self.id !== args[1] ) {
                self.$checkbox.prop("checked", false);
                self.hide(null, true);
            }
        },



        hide: function (/* array */ selected, force) {
            var self = this;
            if (selected && selected[self.variantTypeId] && selected[self.variantTypeId].dataId === self.id && !force) {

            } else {
                self.$checkbox.hide();
            }
        },




        show : function () {
            var self = this;
            self.$checkbox.show();
        },




        disable : function () {
            var self = this;

            self.$inputGroup
                .addClass("is-disabled");

            self.$checkbox
                .addClass("is-disabled")
                .prop("disabled", true);
        },




        enable : function (/* array */ selected) {
            var self = this;

            if ( !_.isEmpty(_.filter(selected, {"Id": self.id})) || _.isEmpty(selected) ) {
                self.$inputGroup
                    .removeClass("is-disabled");

                self.$checkbox
                    .removeClass("is-disabled")
                    .prop("disabled", false);
            }
        },




        isSelected : function () {
            var self = this;

            return self.$checkbox.is(":checked");
        }
    };






    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.variant = eksport.platform.classes.variant || {};
    eksport.platform.classes.variant.Buttons = Variant;
})(jQuery, window);
