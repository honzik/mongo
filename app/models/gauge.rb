class Gauge
  include Mongoid::Document
  field :name
  field :vzt, :type => Boolean

  embeds_many :readings

  validate :check_readings_order

  protected

    def check_readings_order
      was_reading = nil
      self.readings.each do |r|
        unless was_reading.nil?
          if r.state < was_reading.state
            r.errors.add(:state, 'state lower than previous')
            errors[:base] << 'detected reading errors in state continutity'
            break
          end        
        end
        was_reading = r
      end
    end

  # def readings
  #   Reading.where(:gauge_id => self.id).asc(:when)
  # end

  # def store_reading(state, w=Time.now, pozn='')
  #   raise "No gauge ID defined yet" if id.nil?
  #   @stored = [] if @stored.nil?
  #   @stored << Reading.new(:state => state, :gauge_id => id, :when => w, :pozn => pozn)    
  # end

  # def save_stored
  #   return false if @stored.nil?
  #   # order by when
  #   @stored.sort! { |x,y| x.when <=> y.when }  
  #   was_value = nil
  #   @stored.each do |s|
  #     unless was_value.nil?
  #       if s.state < was_value
  #         raise "Bad order on stored group state / dates"
  #       end  
  #       was_value = s.state
  #     end
  #   end
  #   n=0
  #   @stored.each do |s|
  #     # TODO find last before / after...      
  #     s.save!
  #     puts "Saved #{n}" if n % 100 == 0
  #     n += 1
  #   end
  # end
end
