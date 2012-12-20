class AddVztToMeters < ActiveRecord::Migration
  def change
    add_column :meters, :vzt, :boolean
  end
end
