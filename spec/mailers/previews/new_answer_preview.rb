# Preview all emails at http://localhost:3000/rails/mailers/new_answer
class NewAnswerPreview < ActionMailer::Preview
  def notify
    NewAnswerMailer.notify
  end
end
