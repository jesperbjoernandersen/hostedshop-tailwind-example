;(function ($, eksport) {
    'use strict';


    // ==========================================================================
    // Review stars
    // ==========================================================================
    var RatingStars = function ($element) {

        this.$element = $element;
        this.data = $.extend({}, $element.data());
        this.type = $element.data("reviewsType");

        this.endpoint = "/actions/review/product";

        this.data.hints = this.data.hints.replace(/'/gi,"").split(",")
        this[this.type] && this[this.type]();
    };


    RatingStars.prototype.quickrating = function() {
        var readonly = this.data.readonly,
            noratedmsg = this.data.noratedmsg;

        this.raty = this.data;

        delete this.raty.readonly;
        delete this.raty.noratedmsg;

        this.raty.readOnly = readonly;
        this.raty.noRatedMsg = noratedmsg;

        if (!this.raty.readOnly) this.raty.click = $.proxy(this.handleClick, this);
        this.$element.raty(this.raty);
    };


    RatingStars.prototype.handleClick = function(score, e) {

        this.$element.raty('readOnly', true);

        $.post(this.endpoint, {
            score           : score,
            product_id      : this.data.productid,
            user_id         : this.data.userId ? this.data.userId : 0,
            name            : this.data.name,
            type            : "ajax"
        });
    };


    RatingStars.prototype.commentshow = function() {
        var raty = this.data,
            readonly = raty.readonly,
            noratedmsg = raty.noratedmsg;

        delete raty.readonly;
        delete raty.noratedmsg;

        raty.readOnly = readonly;
        raty.noRatedMsg = noratedmsg;

        this.$element.raty(raty);
    };



    RatingStars.prototype.commentrate = function() {
        var raty = this.data,
            readonly = raty.readonly,
            noratedmsg = raty.noratedmsg;

        delete raty.readonly;
        delete raty.noratedmsg;

        raty.readOnly = readonly;
        raty.noRatedMsg = noratedmsg;

        this.$element.raty(raty);
    };

    var ScrollLink = function (el) {

        var id = el.href.replace(el.baseURI, "");
        var $target = $("[data-target='"+id+"']");

        if (!$target.length) {return;}

        $(el).on('click', function() {
            $('body, html').animate({
                scrollTop: $target.offset().top
            }, 400);
        })
    }

    // ==========================================================================
    // Init
    // ==========================================================================

    $(function() {
        // if raty isn't existent return
        if ( typeof $.fn.raty !== "function" ) return;

        var links = $("a[href*='#tabs-pane']");

        if (links.length) {
            links.each(function () {
                new ScrollLink(this);
            });
        }

        // get stars
        var $stars = $("[data-reviews='stars']");

        // if stars exist create
        if ( $stars.length ) {
            $stars.each(function () {
                new RatingStars($(this));
            });
        }
    });

})(jQuery, window);
