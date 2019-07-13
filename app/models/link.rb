class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI.regexp(%w[http https]) }

  def gist_files
    GetGistFiles.call(gist_url: url).gist_files
  end

  def gist?
    URI.split(url)[2].eql?('gist.github.com')
  end
end
