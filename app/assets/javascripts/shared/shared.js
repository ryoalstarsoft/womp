function initializeModals() {
	$('.js-image-modal-link').click(function(e) {
		e.preventDefault();
		this.blur();
		let html = `<img src='${this.href}' class='w-100'/>`;
		$(html).appendTo('body').modal();
	});
}

function initializeTrix() {
	document.addEventListener('trix-file-accept', function(e) {
		e.preventDefault(); // prevents ability to upload files to trix
	});
}

function disableFormsOnSubmit() {
	$('form').submit(function(){
		$(this).find(':input[type=submit]').prop('disabled', true);
	});
}

function initializeToasts() {
	if (window.location.pathname.indexOf("style-guide") == 1) {
		$('.js-show-positive-toast').click(function() {
			$('.positive-toast').animate({bottom: 20}, 500).delay(3000).animate({bottom: -1000}, 500);
		});
		$('.js-show-negative-toast').click(function() {
			$('.negative-toast').animate({bottom: 20}, 500).delay(3000).animate({bottom: -1000}, 500);
		});
	} else {
		if ($('.toast').length > 0) {
			$('.toast').animate({bottom: 20}, 500).delay(3000).animate({bottom: -1000}, 500);
		}
	}
}

function initializeTooltips() {
	tippy('.tooltip', {
		arrow: true
	});
}

function initializeTabs() {
	$('.js-tabs').each(function() {
		// For each set of tabs, we want to keep track of
		// which tab is active and its associated content
		var $active, $content, $links = $(this).find('a');

		// If the location.hash matches one of the links, use that as the active tab.
		// If no match is found, use the first link as the initial active tab.
		$active = $($links.filter('[href="'+location.hash+'"]')[0] || $links[0]);
		$active.addClass('active');

		if ($active.parent().is("li")) {
			$active.parent().addClass('b--blue blue bg-near-white');
		}

		$content = $($active[0].hash);

		// Hide the remaining content
		$links.not($active).each(function () {
			$(this.hash).hide();
		});

		// Bind the click event handler
		$(this).on('click', 'a', function(e){
			// Make the old tab inactive.
			$active.removeClass('active');
			$content.hide();
			if ($active.parent().is("li")) {
				$active.parent().removeClass('b--blue blue bg-near-white')
			}

			// Update the variables with the new link and content
			$active = $(this);
			$content = $(this.hash);

			// Make the tab active.
			$active.addClass('active');
			$content.show();

			if ($active.parent().is("li")) {
				$active.parent().addClass('b--blue blue bg-near-white')
			}

			// Prevent the anchor's default click action
			e.preventDefault();
		});
	});

	$('.js-class-tabs').each(function() {
		// For each set of tabs, we want to keep track of
		// which tab is active and its associated content
		var $active, $content, $links = $(this).find('a');

		// If there is already an active filter, use that as the active tab.
		// If the location.hash matches one of the links, use that as the active tab.
		// If no match is found, use the first link as the initial active tab.
		if ($links.filter('.active').length > 0) {
			$active = $($links.filter('.active')[0]);
		} else {
			$active = $($links.filter('[href="'+location.hash+'"]')[0] || $links[0]);
		}
		$active.addClass('active');

		if ($active.parent().is("li")) {
			$active.parent().addClass('active')
		}

		$content = $($active[0].hash.replace('#', '.'));

		// Hide the remaining content
		$links.each(function () {
			$(this.hash.replace('#', '.')).hide();
		});

		$content.show(); // this is needed for the dual search on the dashboard

		// Bind the click event handler
		$(this).on('click', 'a', function(e){
			// Make the old tab inactive.
			$active.removeClass('active');
			$content.hide();

			if ($active.parent().is("li")) {
				$active.parent().removeClass('active')
			}

			// Update the variables with the new link and content
			$active = $(this);
			$content = $(this.hash.replace('#', '.'));

			// Make the tab active.
			$active.addClass('active');
			$content.show();

			if ($active.parent().is("li")) {
				$active.parent().addClass('active')
			}

			// Prevent the anchor's default click action
			e.preventDefault();
		});
	});

	$('.js-info-tabs').each(function() {
		// For each set of tabs, we want to keep track of
		// which tab is active and its associated content
		var $active, $content, $links = $(this).find('a');

		// If the location.hash matches one of the links, use that as the active tab.
		// If no match is found, use the first link as the initial active tab.
		$active = $($links.filter('[href="'+location.hash+'"]')[0] || $links[0]);
		$active.addClass('active');

		$content = $($active[0].hash);

		// Hide the remaining content
		$links.not($active).each(function () {
			$(this.hash).hide();
		});

		// Bind the click event handler
		$(this).on('click', 'a', function(e){
			// Make the old tab inactive.
			$active.removeClass('active');
			$content.hide();

			// Update the variables with the new link and content
			$active = $(this);
			$content = $(this.hash);

			// Swap the icons that are visible
			// var addElement = $active.children().not('.dn');
			// var removeElement = $active.children('.dn');
			//
			// addElement.addClass('dn');
			// removeElement.removeClass('dn');

			// Make the tab active.
			$active.addClass('active');
			$content.show();

			// Prevent the anchor's default click action
			e.preventDefault();
		});
	});
}
