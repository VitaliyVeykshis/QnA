$(document).on('turbolinks:load', function(){
  $('.vote-cell').bind('ajax:success', function(e) {
    var rating_data = e.detail[0];
    resource = ("#" + rating_data.resource_class + "-" + rating_data.resource_id).toLowerCase();

    function setActive(id) {
      $(resource).find(id).removeClass('passive').addClass('active');
    }

    $(resource).find('.active').removeClass('active').addClass('passive');
    if (rating_data.voted_up_on) { setActive('#like') };
    if (rating_data.voted_down_on) { setActive('#dislike') };
    $(resource).find('.rating').find('span').html(rating_data.rating);
  });
});
