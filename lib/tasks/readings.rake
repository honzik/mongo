namespace :readings do 

  def timed_block 
    start_time = Time.now
    yield 
    (Time.now - start_time).seconds
  end

  # helper to truncate
  def truncate_db_table(table)
   config = ActiveRecord::Base.configurations[Rails.env]
   ActiveRecord::Base.establish_connection
   case config["adapter"]
    when "mysql2"
      ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
    when "sqlite", "sqlite3"
      ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
      ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
      ActiveRecord::Base.connection.execute("VACUUM")
   end
  end

  class ReadingCollector    
    def initialize(rds_name)
      @readings = []
      @rds_name = rds_name
    end

    def add_gauge(gauge)
      t = timed_block do
        gauge.send(@rds_name).each do |r|
          a = [r.id, r.when, r.state, true]
        end      
      end
      puts "Time elapsed on reading add=#{t}"
      # @readings.sort do |a,b| 
      #   a[1] <=> b[1]
      # end
      # # simulation only
      # @readings.each do |r|
      #   r[2] += 1
      # end
    end
  end

  def get_monthly_stats(gr, mongo)    
    first = gr.first
    last = gr.last
    date_start = first.when.to_date.change(:day => 1)
    date_end = last.when.to_date.change(:day => 1)
    curr_date = date_start
    while curr_date <= date_end
      if mongo
        s = gr.where(:when.lte => curr_date.to_time).desc(:when).first
        e = gr.where(:when.lte => curr_date.change(:day => -1).to_time).asc(:when).first
      else
      end
      curr_date += 1.month
      puts "#{curr_date}"
    end

  end

  HOWMANY = 100000

  task :try, [:type, :count, :destroy] => :environment  do |t, args|

    destroy = true
    unless args[:destroy].nil?
      if args[:destroy] == 'no'
        destroy = false
      end
    end
    
    # determine model
    if args[:type] == 'mongo'    
      MeterType = Gauge
      Readings = :readings      
    else
      MeterType = Meter
      Readings = :measures
      truncate_db_table('measures') if destroy
    end

    count = args[:count].to_i
    count = 1 if count < 1


    # insert
    MeterType.destroy_all if destroy
    (1..count).each do |n|
      g = MeterType.new(:name => 'testing gauge #{n}', :vzt => n % 2 == 1 ? true : false)
      g.save
      puts "Creating meter No. #{n}"
      if MeterType == Meter
        columns = [:meter_id, :state, :when, :pozn]
        measures = []
        (1..HOWMANY).each do |o|
          measures << [g.id, o*2, Time.now - (HOWMANY*2).days + o.days + n.hours, 'mass']    
        end
        t = timed_block do
          Measure.import columns, measures, :validate => false
        end
      else 
        (1..HOWMANY).each do |o|
          r = g.send(Readings).build
          r.assign_attributes(:state => o*2, :when => Time.now - (HOWMANY*2).days + o.days + n.hours, :pozn => 'aaa')
        end    
        t = timed_block do
          g.save!
        end
      end        
      puts "final readings count: #{g.send(Readings).count}, time saving=#{t}"
    end if destroy

    # read
    rc = ReadingCollector.new Readings
    (1..count).each do |n|
      g = MeterType.where(:name => 'testing gauge #{n}').first      
      puts "Reading meter No. #{n}"
      rc.add_gauge(g)      
    end

    # (1..count).each do |n|
    #   g = MeterType.where(:name => 'testing gauge #{n}').first      
    #   t = timed_block do 
    #     get_monthly_stats(g.send(Readings), args[:type] == 'mongo')
    #   end
    #   puts "Reading meter No. #{n}, monthly has = #{t}"
    # end


    # (1..HOWMANY).each do |n|
    #   r = g.send(Readings).build
    #   r.assign_attributes(:state => n*2, :when => Time.now - (HOWMANY*4).days + n.days, :pozn => 'aaa')
    # end    
    # t1 = Time.now
    # g.save!
    # t2 = Time.now    
    # puts "final count: #{g.send(Readings).count}, time saving=#{(t2-t1).seconds}"
  end

  
end