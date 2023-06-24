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
//= require jquery_ujs
//= require jquery.slick
//= require ./shared/three
//= require turbolinks
//= require trix
//= require_tree ./shared
//= require_tree ./application

$(document).on('turbolinks:load', function () {
	// initializeGlobalFunctions(); // in global-functions.js
	// initializeJSAutoSubmit();
	// initializeModals();
	initializePolling();
	initializeActionsToggle();
	initializeModelViewer(); // in model-viewers.js
	initializePricingQuiz(); // in pricing-quiz.js
	initializeForms(); // in forms.js
	initializeHeader(); // in header.js
	initializeZoom();
	initializeSchemeSwitching(); // in shared/shared.js

	initializeToasts(); // in shared/shared.js
	disableFormsOnSubmit(); // in shared/shared.js
	initializeTooltips(); // in shared/shared.js
	initializeTabs(); // in shared/shared.js
	initializeTrix(); // in shared/shared.js
	initializeModals(); // in shared/shared.js

	// direct upload is handled in the webpacker files

	$('.flexslider').slick({
		dots: true,
		centerMode: true,
		centerPadding: '60px',
		slidesToShow: 2,
		// variableWidth: true,
		// prevArrow: "<i class='prev-slide fas fa-chevron-left'></i>",
		// nextArrow: "<i class='next-slide fas fa-chevron-right'></i>",
		prevArrow: "<image src='assets/back.svg' class='prev-slide' />",
		nextArrow: "<image src='assets/right-arrow.svg' class='next-slide' />",
		responsive: [
			{
				breakpoint: 960,
				settings: {
					arrows: false,
					centerMode: true,
					centerPadding: '60px',
					slidesToShow: 1
				}
			},
			{
				breakpoint: 768,
				settings: {
					arrows: false,
					centerMode: true,
					centerPadding: '60px',
					slidesToShow: 1
				}
			},
			{
				breakpoint: 480,
				settings: {
					arrows: false,
					centerMode: true,
					centerPadding: '60px',
					slidesToShow: 1
				}
			}
		]
	});
});

function initializeActionsToggle() {
	$(document).click(function (e) {
		var clickover = $(e.target);

		$('.js-dropdown-content').hide();

		if (clickover.hasClass('js-toggle-actions')) {
			clickover.next().show();
		} else if (clickover.parent().hasClass('js-toggle-actions')) {
			clickover.parent().next().show();
		}
	});
}

function initializePolling() {
	if ($('#js-poll-to-refresh').length > 0) {
		setTimeout(pollIsComplete, 30000); // every 30 seconds

		function pollIsComplete() {
			var uploadId = $('#js-poll-to-refresh').data('upload-id');
			url = '/uploads/' + uploadId + '/upload_ready';
			$.get({
				url: url,
				success: function (data) {
					if (data.ready) {
						window.location.reload();
					}
				}
			});

			setTimeout(pollIsComplete, 30000); // every 30 seconds
		}
	}
}

function initializeZoom() {
	$('.zoom')
		.wrap('<span style="display:inline-block;"></span>')
		.css('display', 'block')
		.parent()
		.zoom({
			magnify: 1.5
		});
}

// function initializeModals() {
// 	$('.js-image-modal-link').click(function(e) {
// 		e.preventDefault();
// 		this.blur();
//
// 		let html = `<img src='${this.href}' class='w-100'/>`;
//
// 		$(html).appendTo('body').modal();
// 	});
// }
//
