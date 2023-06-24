function initializeForms() {
	initializeFileInputs();
	initializeAutoSubmit();
	initializeDirectUpload();
	initializeCommentFileAttachment();
}

var isAdvancedUpload = function() {
	var div = document.createElement('div');
	return (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div)) && 'FormData' in window && 'FileReader' in window;
}();

function initializeFileInputs() {
	$('input[type="file"]').each(function() {
		let $input = $(this);
		let $form = $(this).parents('form:first');
		let $label = $input.next('label');
		let $chooseFileButton = $label.find('.secondary-button')[0];
		let $updateText = $label.find('.update-text');
		let labelVal = $label.html();

		if (isAdvancedUpload) {
			$form.addClass('has-advanced-upload')

			let droppedFiles = false;

			$($chooseFileButton).on('drag dragstart dragend dragover dragenter dragleave drop', function(e) {
				e.preventDefault();
				e.stopPropagation();
			})
			.on('dragover dragenter', function() {
				$form.addClass('is-dragover');
				$chooseFileButton.innerText = 'drop to upload';
			})
			.on('dragleave dragend drop', function() {
				$form.removeClass('is-dragover');
				$chooseFileButton.innerText = 'choose file'
			})
			.on('drop', function(e) {
				droppedFiles = e.originalEvent.dataTransfer.files;
				$input[0].files = droppedFiles
			});
		}

		if (!$input.hasClass('js-instant-upload')) {
			$input.on('change', function(e) {
				let fileName = '';

				if (this.files && this.files.length > 1) {
					fileName = (this.getAttribute('data-multiple-caption') || '').replace('{count}', this.files.length);
				} else if( e.target.value ) {
					fileName = e.target.value.split('\\').pop();
				}

				if (fileName) {
					$updateText.html(fileName);
				} else {
					$updateText.html("no file chosen");
				}
			});
		}
	});
}

function initializeDirectUpload() {
	addEventListener("direct-upload:initialize", event => {
		const { target, detail } = event
		const { id, file } = detail
		const $label = $("label[for='" + $(target).attr('id') + "']");
	});

	addEventListener("direct-upload:start", event => {
		const { id } = event.detail;
		const element = document.getElementById(`direct-upload-${id}`);
		element.classList.remove("direct-upload--pending");
	});

	addEventListener("direct-upload:progress", event => {
		const { id, progress } = event.detail;
		const progressElement = document.getElementById(`direct-upload-progress-${id}`);
		progressElement.style.width = `${progress}%`;
	});

	addEventListener("direct-upload:error", event => {
		event.preventDefault();
		const { id, error } = event.detail;
		const element = document.getElementById(`direct-upload-${id}`);
		element.classList.add("direct-upload--error");
		element.setAttribute("title", error);
	});

	addEventListener("direct-upload:end", event => {
		const { id } = event.detail;
		const element = document.getElementById(`direct-upload-${id}`);
		element.classList.add("direct-upload--complete");
	});
}

function initializeAutoSubmit() {
	$('.js-auto-submit input').change(function() {
		if ($(this).attr('type') === 'checkbox') {
			if ($(this).hasClass('js-status-checkbox')) {
				$(".js-status-checkbox").prop('checked', false);
				$(this).prop('checked', true);
			}
			if ($(this).hasClass('js-project-status-checkbox')) {
				$(".js-project-status-checkbox").prop('checked', false);
				$(this).prop('checked', true);
			}
			if ($(this).hasClass('js-filetype-checkbox')) {
				$(".js-filetype-checkbox").prop('checked', false);
				$(this).prop('checked', true);
			}
		} else if ($(this).attr('type') === 'radio') {
			$(this).prop('checked', true);
		}

		$(this).closest('form').find('input[type=submit]').click();
	});
}

function initializeCommentFileAttachment() {
	$('.js-toggle-scroll-box').click(function() {
		$('.js-comment-scroll-box').toggleClass('dn');

		if ($('.js-comment-scroll-box').hasClass('dn')) {
			$(this).text("add files you've already uploaded");
		} else {
			$(this).text("collapse existing uploads");
		}
	});
}

// function initializeJSAutoSubmit() {
// 	// make following action fire when radio button changes
// 	$('.js-auto-submit input[type=radio]').change(function(){
// 		// find the submit button and click it on the previous action
// 		$('input[type=submit]').click();
// 	});
// 	$('.file-auto-submit').change(function(){
// 		$('#js-auto-submit').click();
// 	});
// 	$('.js-material-auto-submit input').change(function() {
// 		$('#material_search').submit();
// 	});
//
// 	var timeout = null;
// 	$('.js-dashboard-auto-submit input').on('keyup input', function() {
// 		if (timeout) {
// 			clearTimeout(timeout);
// 		}
//
// 		$form = $(this).closest('form');
//
// 		if ($(this).attr('type') === 'checkbox') {
// 			if ($(this).hasClass('js-status-checkbox')) {
// 				$(".js-status-checkbox").prop('checked', false);
// 				$(this).prop('checked', true);
// 			}
// 			if ($(this).hasClass('js-project-status-checkbox')) {
// 				$(".js-project-status-checkbox").prop('checked', false);
// 				$(this).prop('checked', true);
// 			}
// 			if ($(this).hasClass('js-filetype-checkbox')) {
// 				$(".js-filetype-checkbox").prop('checked', false);
// 				$(this).prop('checked', true);
// 			}
// 			$form.submit();
// 		} else {
// 			timeout = setTimeout(function() {
// 				$form.submit();
// 			}, 1000);
// 		}
// 	});
// }
