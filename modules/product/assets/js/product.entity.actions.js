;(function ($, eksport) {
    'use strict';

    var selectors = {
        input       : "[data-product='count']",
        btn_add     : "[data-product='add']",
        btn_sub     : "[data-product='subtract']"
    }

    var Actions = function(input) {
        var self        = this;

        this.$input      = $(input);
        this.$parent     = $(input).parent();
        this.$btn_add    = this.$parent.find(selectors.btn_add);
        this.$btn_sub    = this.$parent.find(selectors.btn_sub);

        this.$btn_add.on("click", {event: "add"}, $.proxy(this.changeAmount, this));
        this.$btn_sub.on("click", {event: "subtract"}, $.proxy(this.changeAmount, this));
    }




    Actions.prototype = {
        changeAmount : function (e) {
            var value = parseInt(this.$input.val(), 10),
                data = {
                    event       : e.data.event,
                    product     : this
                };


            if (this.$input.is(":disabled")) {
                return;
            }

            if (isNaN(value)) {
                // eventHandler.trigger("invalidInput", data);
                return;
            }

            this.minAmount = parseInt(this.$input.data("productMinamount"),10);

            if (e.data.event === "add") {
                this.handleAdd(data, value);
                // eventHandler.trigger(e.data.event+"Product", data);
            }

            if (e.data.event === "subtract" && value !== 0) {
                this.handleSub(data, value);
                // eventHandler.trigger(e.data.event+"Product", data);
            }
        },




        handleAdd : function (data, value) {
            data.oldValue = value;
            data.value = (value === 0 && this.minAmount > 1) ? value + this.minAmount : value + 1;
            this.$input.val(data.value);
        },




        handleSub : function(data, value) {
            data.oldValue = value;
            data.value = (value === 0 || value === this.minAmount) ? 0 : value - 1;
            this.$input.val(data.value);
        }
    };


    // ==========================================================================
    // Init
    // ==========================================================================

    $(function() {
        $(selectors.input).each(function () {
            $(this).data("product", new Actions(this));
        });
    });

})(jQuery, window);
