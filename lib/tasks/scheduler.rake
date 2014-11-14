desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Syncing Database with Eventbrite"
  User.update_db
  puts "Done."
end