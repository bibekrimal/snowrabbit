jQuery(function() {
	initPopup();
});


function initPopup() {
	$('.popup-trigger').on('mouseover', function(e) {
		// console.log(e.target);
		let currentElement = $(e.target);
		let content = currentElement.attr('data-target');
		

		// console.log(verticalPos);
		// console.log(currentElement.outerWidth());
		

		$.get(content, function(result) {
			$('body').append('<div class="popup-wrap" style="opacity: 0;">' + result + '</div>');
		});

		setTimeout(function() {
			let verticalPos = currentElement.offset().top + currentElement.outerHeight();
			let horizontalPos = currentElement.position().left + $('.popup-wrap').outerWidth();
			// console.log($('.popup-wrap').outerWidth());
			$('.popup-wrap').css({
				"top": verticalPos,
				"left": horizontalPos,
				"opacity": 1,
			});
		}, 200);

	});

	$('.popup-trigger').on('mouseout', function(e) {
		$('.popup-wrap').remove();
	});
}
