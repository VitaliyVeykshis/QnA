document.addEventListener('turbolinks:load', function() {
  $('.new-comment').on('click', '.new-comment-link', function(e) {
    var resourceClass = $(this).data('resourceClass');
    var resourceId = $(this).data('resourceId');

    e.preventDefault();
    $(this).hide();
    $('form#new-comment-' + resourceClass + '-' + resourceId).removeClass('d-none');
  })

  $('.new-comment form').bind('ajax:success', function(e) {
    e.preventDefault();
    $(this).addClass('d-none');
    $('.new-comment-link').show();
  });
});