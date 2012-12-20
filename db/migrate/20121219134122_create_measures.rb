class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.integer :meter_id
      t.float :state
      t.datetime :when
      t.string :pozn

      t.timestamps
    end
  end
end
