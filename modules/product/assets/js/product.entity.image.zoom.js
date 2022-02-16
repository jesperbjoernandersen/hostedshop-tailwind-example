; (function ($, eksport, undefined) {
    'use strict';



    // ==========================================================================
    // Zoom Prototype
    // ==========================================================================

    var Zoom = function (product) {
        var self = this;

        self.product = product;

        self.selectors = {
            wrap: "#template-myCloudZoom-{id}".replace("{id}", product.Id),
            zoom: "#cloud-{id}".replace("{id}", product.Id),
            thumb: "#slider-{id}".replace("{id}", product.Id)
        };

        self.$wrap = $(self.selectors.wrap);
        self.$zoom = $(self.selectors.zoom);
        self.$thumb = $(self.selectors.thumb);
    };




    Zoom.prototype = {

        hasElement : function () {
            var self = this;
            return self.$wrap.length && self.$thumb.length;
        },




        select: function (variant) {
            var self = this,
                fileId = variant.FileId,
                fileIds = variant.FileIds;

            if ( !self.hasElement() ) { return; }

            self.$thumb.find('li').css("display","inline");

            if ( fileIds.length ) {
                // handle thumbelina
                var search = fileIds.map(function (n) { return "[data-fileid='"+n+"']"; }).join();
                self.$thumb.find('img').not(search).parents('li').css("display","none");
                self.$thumb.find('li:visible').first().find('img').trigger("click");
            } else if ( fileId > 0 ) {
                self.$wrap.find("img[data-fileid='"+fileId+"']").trigger("click");
            }

            self.$thumb.find('.owl-carousel').data("owlCarousel").goTo(0);
        },




        unselect: function () {
            var self = this;

            if ( !self.hasElement() ) { return; }

            self.$thumb.find('li')
                .css("display","inline")
                .first().find('img').trigger("click");
            self.$thumb.find('.owl-carousel').data("owlCarousel").goTo(0);
        }
    };





    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.image = eksport.platform.classes.image || {};
    eksport.platform.classes.image.zoom = Zoom;
})(jQuery, window);
