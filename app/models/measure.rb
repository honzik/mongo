class Measure < ActiveRecord::Base
  attr_accessible :meter_id, :pozn, :state, :when

  belongs_to :meter

  default_scope order('`when` ASC')
  

end
