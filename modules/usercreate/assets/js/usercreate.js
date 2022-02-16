;(function($) {
	'use strict';

	function init () {
		var $wrapper = $("#m-usercreate");

		if ($wrapper.length > 0) {

			var stateLogic = function(e){

				$('.state-group', $wrapper).addClass('is-hidden');
				$('.state-select', $wrapper).each(function() {
					$(this).prop('disabled', true);
				});

				var $country = $('#m-usercreate-country'),
				    el = $country.is('[type="hidden"]') ? $country : $country.find(':selected');
				if (el.data('hasStates') > 0) {
					$('.state-group-' + el.val(), $wrapper).removeClass('is-hidden').find('select').prop('disabled', false);
				}
			};

			// Execute form action on select change
			$('#m-usercreate-country', $wrapper).on('change input', stateLogic);
			stateLogic();

			// City/county locator
			$('#m-usercreate-zipcode', $wrapper).SmartForm('county', {target:'#m-usercreate-city', country:'#m-usercreate-country'});

			// Country code locator
			$('#m-usercreate-country', $wrapper).SmartForm('countrycode', {
				target: function(code) {
					$('input.countryCode', $wrapper).val(code);
					$('span.countryCode', $wrapper).html('+' + code);
				}
			});

			// Interest group selector
			$('#m-usercreate-newsletter', $wrapper).on('change', function(e) {
				$('#m-usercreate-newsletterfields', $wrapper).toggleClass('is-hidden');
			});
		}
	}


	$(function() {
		init();
	});

})(jQuery, window);
