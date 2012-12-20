class AddIndexesToMeasures < ActiveRecord::Migration
  def change
    add_index :measures, :meter_id
  end
end
