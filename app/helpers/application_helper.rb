module ApplicationHelper
  FLASH_STYLES = {
    alert: 'danger',
    notice: 'success'
  }.freeze

  def search_categories
    {
      all: 'All',
      answer: 'Answers',
      question: 'Questions',
      comment: 'Comments',
      user: 'Users'
    }
  end

  def flash_style(type)
    "alert alert-#{FLASH_STYLES[type.to_sym]}"
  end
end
