function initializeForms() {
	initializeFileInputs();
	initializeDirectUpload();
	initializeDatepicker();
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

			$form.on('drag dragstart dragend dragover dragenter dragleave drop', function(e) {
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
	});
}

function initializeDirectUpload() {
	addEventListener("direct-upload:initialize", event => {
		const { target, detail } = event
		const { id, file } = detail
		const $label = $("label[for='" + $(target).attr('id') + "']");
		$(target).after(`
			<div id="direct-upload-${id}" class="relative direct-upload direct-upload--pending">
				<div id="direct-upload-progress-${id}" class="button direct-upload__progress" style="width: 0%"></div>
				<span class="direct-upload__filename">${file.name}</span>
			</div>
		`);
		$label.addClass('dn');
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

function initializeDatepicker() {
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd'
	});
	$('.datepicker').datepicker({
		minDate: 0
	});
}
