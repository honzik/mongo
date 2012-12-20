class Entry < ActiveRecord::Base
  attr_accessible :name, :article_id

  def article    
    Article.where(:id => article_id)[0]
  end

end
