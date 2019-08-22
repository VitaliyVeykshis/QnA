class GetSearchResults
  include Interactor

  def call
    context.results = search
  end

  private

  def search
    ThinkingSphinx.search ThinkingSphinx::Query.escape(context.query), classes: [context.category]
  end
end
