class CreateGauges < ActiveRecord::Migration
  def change
    create_table :gauges do |t|
      t.string :name
      t.boolean :vzt

      t.timestamps
    end
  end
end
