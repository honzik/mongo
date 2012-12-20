class AddArticleToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :article_id, :string
  end
end
