jQuery(function() {
	initPopup();
	$('[data-toggle="tooltip"]').tooltip();
});


function initPopup() {
	$('#resultDataModal').on('show.bs.modal', function (event) {
		var button = $(event.relatedTarget);
		var recipient = button.data('content')
		var modal = $(this);
		$.ajax({
			url: recipient,
			type: 'GET',
			beforeSend: function(e) {
				modal.find('.content').html('<span class="d-block text-center">Loading...</span>');
			},
			success: function(response) {
				modal.find('.content').html(response);
			}
		});
	});
}
