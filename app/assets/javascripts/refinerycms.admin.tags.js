RefineryCMS = window.RefineryCMS || {};
RefineryCMS.Admin = window.RefineryCMS.Admin || {};

RefineryCMS.Admin.Tags = function() {
	var _textarea_id;

	function _init(textarea_id) {
		_textarea_id = textarea_id;

		$('a.tag-item').click(function(e) {
			e.preventDefault();

			// get services already in the textarea
			var current_service_string = $('#' + _textarea_id).val();

			// convert string to array, splitting on commas
			var current_service_array = current_service_string.split(',');

			// strip whitespace and downcase for easier checking
			for (var i = 0; i < current_service_array.length; i++) {
				current_service_array[i] = $.trim(current_service_array[i]).toLowerCase();
			}

			if ($.inArray($(this).text().toLowerCase(), current_service_array) == -1) {
				$('#' + _textarea_id).val(((current_service_string.length > 0) ? current_service_string + ', ' : '') + $(this).text());
				$(this).addClass('active');
			} else {
				$(this).removeClass('active');
				$('#' + _textarea_id).val($('#' + _textarea_id).val().replace($(this).text(),''));
			}
	
			// clean up spare commas
			$('#' + _textarea_id).val($('#' + _textarea_id).val().replace(/, ,/,',').replace(/^, /,''));

		});
	}

	return {
		init: function(textarea_id) {
			_init(textarea_id);
		}
	}
}();