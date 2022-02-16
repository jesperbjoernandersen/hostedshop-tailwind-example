//
// Blog Javascript File
// -----------------------------------------------------------------------------

(function($, document, undefined) {
    'use strict';

    var form        = "[data-blog=form]",
        reply       = "[data-blog=reply]",
        reply_post  = "[data-blog=reply-post]",
        $form       = null,
        $form_wrap  = null,
        $reply_post = null,
        $parentInput= null;

    function moveForm (e) {
        if (e.data.blog == "reply") {
            $reply_post.removeClass("is-hidden");
        } else {
            $reply_post.addClass("is-hidden");
        }

        $parentInput.val(e.data.parentid);
        $form.detach().appendTo(e.data.parent);

        e.preventDefault();
    }


    // ==========================================================================
    // Listener
    // ==========================================================================

    $(function () {
        //
        // set form
        //
        $form = $(form);
        $parentInput = $form.find("[name='comment_parent']");
        $form_wrap = $form.parent(".form-wrap");

        //
        // Add event listener
        //
        $(reply).each( function () {
            var $this = $(this),
                data  = $this.data(),
                $wrap = $this.parents(".media-body");

            $this.on("click", $.extend({parent: $wrap}, data), moveForm);
        });

        $reply_post = $(reply_post);
        $reply_post.on("click", $.extend({parent: $form_wrap}, $reply_post.data()), moveForm);
    })

})(jQuery, document);
