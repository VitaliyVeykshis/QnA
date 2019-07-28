function questionsChannel() {
  App.cable.subscriptions.create('QuestionsChannel', {
      received: function(data) {
          $('.questions').append(JST['templates/question'](data));
      }
  });
}

$(document).on('turbolinks:load', questionsChannel);