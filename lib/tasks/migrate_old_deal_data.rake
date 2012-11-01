#Migrates all old data to new format
desc "Migrates old deal data to new format.  Requires publisher, filename, and theme parameters"
task :migrate_old_deal_data => :environment do
  publisher, filename, theme = ENV['publisher'], ENV['filename'], ENV['theme']
  if publisher.blank? || filename.blank? || theme.blank?
    puts "\nPublisher, theme and filename are required!"
    puts "Ex.  rake migrate_old_deal_data publisher='The Daily Planet' filename='script/data/daily_planet_export.txt' theme='entertainment'"
    exit
  end
  total_count = 0
  success_count = 0
  
  #Tries to find publisher in DB... if not, create new one
  pub = Publisher.find_or_create_by_name_and_theme(publisher, theme)
  File.readlines(filename).each_with_index do |line, index|
    next if index == 0 #Skip Header
    
    #Flexing the old RegEx muscles here since there is no CSV format and there sometimes
    #contains 1 up to multiple words with 1 or multiple spaces.  If export was guaranteed to
    #contain commas or pipes, it would be much easier and cleaner.    
    elements = line.scan(/(\D.*?)\s+(\d.*?)\s+(\d.*?\s+)*(\D.*?)\s+(\d+)\s+(\d+)/).flatten
    advertiser = Advertiser.find_or_create_by_name_and_publisher_id(elements[0].strip, pub)

    deal = Deal.new
    deal.advertiser = advertiser
    deal.start_at = Time.parse(elements[1].strip) unless elements[1].nil?
    deal.end_at = Time.parse(elements[2].strip) unless elements[2].nil?
    deal.description = elements[3].strip
    deal.price = elements[4].strip
    deal.value = elements[5].strip      
    
    if deal.save
      success_count +=1
      puts "Successfully inserted Deal: '#{deal.description}'"
    else
      puts "Failed inserted Deal: '#{deal.description}'"
    end
    total_count +=1
  end
  puts "\n#{success_count} out of #{total_count} deals were successfully inserted for #{publisher}"
end