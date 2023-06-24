import * as ActiveStorage from 'activestorage';
import { WompUploader } from './womp_uploader';

ActiveStorage.start();

$(document).on('turbolinks:load', function() {
  initializeDirectUpload();
});

function initializeDirectUpload() {
  // Handle change, e.g. User attaches a file
  const inputs = Array.from(document.querySelectorAll('.js-instant-upload'))
  inputs.forEach(input => {
    input.addEventListener('change', event => {
      Array.from(input.files).forEach( file => {
        const uploader = new WompUploader(input, file)
        uploader.start(file)
      })
      // clear the selected files from the input
      input.value = null
    })
  })

	addEventListener("direct-upload:initialize", event => {
		const { target, detail } = event
		const { id, file } = detail
		const $label = $("label[for='" + $(target).attr('id') + "']");
		$label.after(`
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
    $(progressElement).closest('form').find(':input[type=submit]').prop('disabled', true);
	});

	addEventListener("direct-upload:error", event => {
		event.preventDefault();
		const { id, error } = event.detail;
		const element = document.getElementById(`direct-upload-${id}`);
		element.classList.add("direct-upload--error");
		element.setAttribute("title", error);
	});

  addEventListener("direct-upload:end", event => {
    const { target, detail } = event;
		const { id, signed_id } = detail;
		const element = document.getElementById(`direct-upload-${id}`);
    const $label = $("label[for='" + $(target).attr('id') + "']");
		element.classList.add("direct-upload--complete");

    if ($('.js-instant-upload').length > 0) {
      $(element).append(`<a href='javascript:void(0)' class='js-remove-upload' data-signed-id='${signed_id}'><i class='fas fa-times'></i></a>`);

      reinitSignedIdRemoval($(element));

      $label.removeClass('dn');

      $(element).closest('form').find(':input[type=submit]').prop('disabled', false);
    }
	});
}

function reinitSignedIdRemoval(element) {
  element.click(function() {
    var removeEl = $(this).find('.js-remove-upload')[0];
    var signedId = $(removeEl).data('signed-id');

    if (window.confirm("are you sure you want to remove this file?")) {
      $(`input[value='${signedId}']`).remove();
      $(this).remove();
    }
  });
}
