;(function($) {
	'use strict';

	function init () {
		var $wrapper = $("#m-userrequest");

		if ($wrapper.length > 0) {

			var stateLogic = function(e){

				$('.state-group', $wrapper).addClass('is-hidden');
				$('.state-select', $wrapper).each(function() {
					$(this).prop('disabled', true);
				});

				var $country = $('#m-userrequest-country'),
				    el = $country.is('[type="hidden"]') ? $country : $country.find(':selected');
				if (el.data('hasStates') > 0) {
					$('.state-group-' + el.val(), $wrapper).removeClass('is-hidden').find('select').prop('disabled', false);
				}
			};

			// Execute form action on select change
			$('#m-userrequest-country', $wrapper).on('change input', stateLogic);
			stateLogic();

			// City/county locator
			$('#m-userrequest-zipcode', $wrapper).SmartForm('county', {target:'#m-userrequest-city'});

			// Country code locator
			$('#m-userrequest-country', $wrapper).SmartForm('countrycode', {
				target: function(code) {
					$('input.countryCode', $wrapper).val(code);
					$('span.countryCode', $wrapper).html('+' + code);
				}
			});

			// Interest group selector
			$('#m-userrequest-newsletter', $wrapper).on('change', function(e) {
				$('#m-userrequest-newsletterfields', $wrapper).toggleClass('is-hidden');
			});
		}
	}


	$(function() {
		init();
	});

})(jQuery, window);
