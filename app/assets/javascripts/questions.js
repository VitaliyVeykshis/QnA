$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.question').find('.form').removeClass('d-none');
  })
});