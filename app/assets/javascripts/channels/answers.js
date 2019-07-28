function answersChannel() {
  App.cable.subscriptions.create({channel: 'AnswersChannel', question_id: gon.question_id}, {
    received: function(data) {
      if(gon.user_id != data.answer.user_id)
        $('.answers').append(JST['templates/answer'](data));
    }
  });
};

$(document).on('turbolinks:load', answersChannel);