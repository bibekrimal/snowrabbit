jQuery(function() {
	initPopup();
});


function initPopup() {
	$('.popup-trigger').on('mouseover', function(e) {
		// console.log(e.target);
		let currentElement = $(e.target);
		if (!(currentElement.attr('data-target')) || (currentElement.attr('data-target') == '') || (currentElement.attr('data-target') == '#')) {
			return;
		} else {
			let content = currentElement.attr('data-target');
			$.get(content, function(result) {
				$('body').append('<div class="popup-wrap" style="opacity: 0;">' + result + '</div>');
			});

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
	});

	$('.popup-trigger').on('mouseout', function(e) {
		$('.popup-wrap').remove();
	});
}
