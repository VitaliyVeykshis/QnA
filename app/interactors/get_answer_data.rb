class GetAnswerData
  include Interactor
  include Rails.application.routes.url_helpers

  def call
    context.data = data(context.answer)
  end

  private

  def data(answer)
    {
      id: answer.id,
      body: answer.body,
      user_id: answer.user_id,
      question: question(answer),
      links: links(answer),
      files: files(answer)
    }
  end

  def question(answer)
    {
      id: answer.question_id,
      user_id: answer.question.user_id
    }
  end

  def links(answer)
    answer.links.map do |link|
      {
        id: link.id,
        name: link.name,
        url: link.url,
        gist_files: link.gist_files
      }
    end
  end

  def files(answer)
    answer.files.map do |file|
      {
        id: file.id,
        filename: file.filename.to_s,
        url: url_for(file)
      }
    end
  end
end
