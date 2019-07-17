$(document).on('turbolinks:load', function(){
  $('.vote-cell').bind('ajax:success', function(e) {
    var rating_data = e.detail[0];
    resource = ("#" + rating_data.resource_class + "-" + rating_data.resource_id).toLowerCase();

    $(resource).find('.rating').find('span').html(rating_data.rating);
  });
});
