class Article
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  field :name, type: String
  field :content, type: String
  field :published_on, :type => Date

  validates :name, :presence => true
  embeds_many :comments
  belongs_to :author

  def entries
    Entry.where(:article_id => id.to_s)
  end
end
