jQuery(function() {
	initPopup();
	// $('#example').tooltip(options)
	$('[data-toggle="tooltip"]').tooltip();
});


function initPopup() {
	$('.popup-trigger').on('click', function(e) {
		// console.log(e.target);
		let currentElement = $(e.target);
		if (!(currentElement.attr('data-target')) || (currentElement.attr('data-target') == '') || (currentElement.attr('data-target') == '#')) {
			return;
		} else {
			// currentElement.addClass('popup-active');
			$(this).tooltip('hide');
			let content = currentElement.attr('data-target');
			if (!currentElement.hasClass('popup-active')) {
				// console.log('has popup');
				$.get(content, function(result) {
					$('body').append('<div class="popup-wrap" style="opacity: 0;"><button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>' + result + '</div>');
				});
				currentElement.addClass('popup-active');
			}
			

			setTimeout(function() {
				let popup = $('.popup-wrap');
				let verticalPos = currentElement.offset().top + currentElement.outerHeight();
				let horizontalPos = currentElement.position().left;
				popup.addClass('active').css({
					"top": verticalPos,
					"left": horizontalPos,
					"opacity": 1,
				});

				if ($(window).width() < (horizontalPos + popup.outerWidth())) {
					popup.addClass('flip-horz').css({
						"left": "auto",
						"right": $(window).width() - horizontalPos - currentElement.outerWidth()
					});
				}

				if ($(window).height() < (verticalPos + popup.outerHeight())) {
					popup.addClass('flip-vert').css({
						"top": "auto",
						"bottom": $(window).height() - currentElement.offset().top
					});
				}

			}, 200);
		}

		$(document).click(function(event) {
			$target = $(event.target);
			$closeBtn = $(event.currentTarget.activeElement);

			if(!$target.closest('.popup-wrap').length && $('.popup-wrap').is(":visible") || $target.closest('.close').length) {
				currentElement.removeClass('popup-active');
				$('.popup-wrap').removeClass('active');
				setTimeout(function() {
					$('.popup-wrap').remove();
				}, 200);
			}
		});

	});
}
