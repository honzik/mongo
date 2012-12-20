class Reading
  include Mongoid::Document
  field :gauge_id, type: Integer
  field :state, type: Float
  field :when, type: Time
  field :pozn, type: String

  embedded_in :gauge

  default_scope asc(:when)
  # index({:gauge_id => 1})
  # index({:state => 1})
  index({:when => 1})

  # validates :state, :presence => true, :numericality => true  
  # validate :proper_orders

  # protected

  #   def proper_orders 
  #     before  = Reading.where(:gauge_id => self.gauge_id, :when.lt => self.when).last     
  #     after   = Reading.where(:gauge_id => self.gauge_id, :when.gt => self.when).first
  #     unless before.nil?
  #       if before.state > self.state
  #         errors.add(:state, "Bad order, previous is higher")
  #       end 
  #     end
  #     unless after.nil?
  #       if after.state < self.state
  #         errors.add(:state, "Bad order, next is lower")
  #       end
  #     end
  #   end

end
