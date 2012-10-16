#Updates all the children of the "entertainment" theme to their parent "entertainment"
task :consolidate_et_themes => :environment do
  et = Publisher.where(:theme => "entertainment").first
  if et
    publishers = Publisher.where(:parent_id => et)
    puts "Found #{publishers.count} children themes from parent '#{et.name}'"
    puts "Updating themes to '#{et.theme}'"
    publishers.each{|pub| pub.theme = et.theme; pub.save!}
    puts "Done!"
  end
end
