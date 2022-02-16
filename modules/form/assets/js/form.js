;(function($) {
    'use strict';

    function init () {
        var $wrapper = $("#m-form");

        if ($wrapper.length > 0) {
            $wrapper.find('[data-form="validate"]').on('change', 'input[type="checkbox"]', function (e) {
                var $this = $(this),
                    $parent = $this.parents('[data-form="validate"]'),
                    $inputs = $parent.find('input[type="checkbox"]').not(this);

                $this.prop('required', $inputs.filter(":checked").length ? false : true);
                $inputs.not(":checked").prop('required', $inputs.filter(":checked").length ? false : !$this.prop('checked'));
            });
        }
    }


    $(function() {
        init();
    });

})(jQuery, window);
