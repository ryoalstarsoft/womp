// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery-ui/widgets/datepicker
//= require turbolinks
//= require activestorage
//= require trix
//= require ./shared/three
//= require_tree ./shared
//= require_tree ./admin

$(document).on('turbolinks:load', function() {
	initializeGlobalFunctions(); // in global-functions.js
	initializeForms(); // in forms.js
	initializePolling();
	initializeModelViewer();

	initializeToasts(); // in shared/shared.js
	disableFormsOnSubmit(); // in shared/shared.js
	initializeTooltips(); // in shared/shared.js
	initializeTabs(); // in shared/shared.js
	initializeTrix(); // in shared/shared.js
	initializeModals(); // in shared/shared.js
});

function initializePolling() {
	if ($('#js-poll-to-refresh').length > 0) {
		setTimeout(pollIsComplete, 30000); // every 30 seconds

		function pollIsComplete() {
			var uploadId = $('#js-poll-to-refresh').data('upload-id');
			url = '/uploads/' + uploadId + '/upload_ready';
			$.get({
				url: url,
				success: function(data) {
					if (data.ready) {
						window.location.reload();
					}
				}
			});

			setTimeout(pollIsComplete, 30000); // every 30 seconds
		}
	}
}
