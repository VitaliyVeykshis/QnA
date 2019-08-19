module ApplicationHelper
  def search_categories
    {
      all: 'All',
      answer: 'Answers',
      question: 'Questions',
      comment: 'Comments',
      user: 'Users'
    }
  end
end
