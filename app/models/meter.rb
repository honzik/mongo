class Meter < ActiveRecord::Base
  attr_accessible :name, :vzt

  has_many :measures, :order => "`when` ASC", :dependent => :destroy

  validate :check_measures_order

  protected

    def check_measures_order
      was_measure = nil
      self.measures.sort! do |a,b|
        a.when <=> b.when
      end      
      self.measures.each do |m|
        unless was_measure.nil?
          if m.state < was_measure.state
            m.errors.add(:state, 'state lower than previous')
            errors[:base] << 'detected reading errors in state continutity'
            break
          end        
        end
        was_measure = m
      end
    end

end
