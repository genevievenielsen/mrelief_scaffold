$(document).ready(function() {

	(function($) {
	    var $window = $(window),
	        $html = $('#link_to_portal');

	    $window.resize(function resize(){
	        if ($window.width() < 1000) {
	            return $html.removeClass('button');
	        }

	        $html.addClass('button');
	    }).trigger('resize');
	})(jQuery);

});








