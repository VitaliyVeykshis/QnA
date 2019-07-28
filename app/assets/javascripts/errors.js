$(document).on('turbolinks:load', function(){
  $(document).bind('ajax:error', function(e) {
    var formId = e.target.id;

    $('#' + formId).find('.invalid-feedback.d-block').remove();
    $('#' + formId).find('.form-control').removeClass('is-invalid');

    function capitalizeFirst(string) {
      return string.substring(0,1).toUpperCase()+string.substring(1);
    };

    $.each(e.detail[0], function (key, value){
      var errorMessage = capitalizeFirst(key.replace('.', ' ') + ' '+ value.toString());
      var $newDiv = $('<div/>')
                      .addClass('invalid-feedback d-block')
                      .html(errorMessage);
      var targetClass = key.replace('.', '-')
      var target = '#' + formId + ' .form-group.' + targetClass;

      $(target).find('.form-control').addClass('is-invalid');
      $(target).append($newDiv);
    });
  });
});