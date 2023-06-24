function initializeHeader() {
	$(document).click(function(e) {
		var clickover = $(e.target);

		$('.js-dropdown-content:not(.dn)').addClass('dn');

		if (clickover.hasClass('js-toggle-header-dropdown')) {
			clickover.next().toggle();
		} else if (clickover.parent().hasClass('js-toggle-header-dropdown')) {
			clickover.parent().next().toggle();
		}
	});

	$('.js-toggle-hamburger-menu').click(function(e) {
		e.preventDefault();

		$(this).toggleClass('x');
		$('.header-on-mobile').toggleClass('open');
	});
}
