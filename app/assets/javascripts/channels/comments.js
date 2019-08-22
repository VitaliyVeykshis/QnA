function commentsChannel() {
  App.cable.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id}, {
    received: function(data) {
      if(gon.user_id != data.comment.user_id) {
        comments_id = '#comments-' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id
        $('.comments' + comments_id).append(JST['templates/comment'](data));
        $('.comments' + comments_id).removeClass('d-none');
      };
    }
  });
};

$(document).on('turbolinks:load', commentsChannel);