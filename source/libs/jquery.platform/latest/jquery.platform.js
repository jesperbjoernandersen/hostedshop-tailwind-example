/* Plugins for this template platform */
;(function($) {
	'use strict';

    $.fn.checked = function(value) {
        if(value === true || value === false) {
            // Set the value of the checkbox
            $(this).each(function(){ this.checked = value; });
        }
        else if(value === undefined || value === 'toggle') {
            // Toggle the checkbox
            $(this).each(function(){ this.checked = !this.checked; });
        }
        return this;
    };

	$.SmartRequest = function(page, action, data) {

		data = $.extend((data || {}), {
			page: page,
			action: action
		});

        return $.getJSON("/actions/handler/ajax", data);
    };

	$.fn.SmartForm = function (type, options) {

		if (type == 'county') {
			var settings = $.extend({
				event: 'blur',
				minLength: 4,
				target: null
			}, options );

			return this.each(function () {
				if (settings.target && $(settings.target).length > 0) {
					$(this).on(settings.event, function () {
						
						var country = options.hasOwnProperty('country') ? $(options.country) : false;

						if (country && country.length && country.val() != 'DK') {
							return;
						}

						var target = $(settings.target);
						var value_zip = $(this).val();
						if (value_zip.length >= settings.minLength) {
							$.SmartRequest('helper', 'find_county', {
								zip: value_zip,
								country: 'dk'
							}).then(function(data) {
	                            if (data.result) {
	                                target.val(data.result).blur();
	                            }
	                        });
						}
					});
				}
			});
		}

		else if (type == 'countrycode') {

			var settings = $.extend({
				event: 'change',
				target: function(){}
			}, options );

			return this.each(function () {
				$(this).on(settings.event, function() {
		        	$.SmartRequest('checkout', 'country_code', {
		        		'delivery_country': $(this).val()
		        	}).then(function(data) {
		                if (data.result) {
		                	settings.target.call(this, data.result.code);
						}
					});
		        });
			});
		}

		return this;
	}

	// Execute on ready
	$(function () {

		// data-showOnActive + data-showActiveGroup
		$(document).on('change click showactive', '[data-show-on-active]', function (e) {

			var $el = $(this),
				group = $el.data('showActiveGroup') || null;

			// Hide the whole group
			if (group) {
				$('[data-show-active-group="' + group + '"]').each( function() {
					$($(this).data('showOnActive')).find('input, select').attr('disabled', true).end().hide();
				});
			}

			// Show the target
			$($el.data('showOnActive')).find('input, select').attr('disabled', false).end().slideDown();
		});
	});
})(jQuery);