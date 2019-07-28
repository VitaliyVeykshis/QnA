function commentsChannel() {
  App.cable.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id}, {
    received: function(data) {
      if(gon.user_id != data.comment.user_id)
        $('.comments').append(JST['templates/comment'](data));
    }
  });
};

$(document).on('turbolinks:load', commentsChannel);