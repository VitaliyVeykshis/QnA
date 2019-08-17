class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswer.call(answer: answer)
  end
end
