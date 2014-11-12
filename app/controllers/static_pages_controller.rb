require 'json'
require 'open-uri'
class StaticPagesController < ApplicationController
  def home
    @attendees = User.all.sorted_by_status
    @count = User.all.num_of_checkins
  end
  def refresh_db
      #EventbriteAPI::Configuration.access_token="54X654CD2AJ3XPAPM45B"
    EventbriteAPI::Configuration.access_token="***REMOVED***"
    @eb = EventbriteAPI.new
    @event = @eb.events(id:***REMOVED***)
    page_count = @event.attendees.get.body["pagination"]["page_count"]
    for i in 1..page_count
      @attendees = @event.attendees(page:i).get.body["attendees"]
      @attendees.each do |test| 
        unless User.find_by(name: test["profile"]["name"].to_s)
          print 'WTFFFFFFFFFFFFFFFFFFFFFFFFFFF'
          print test["profile"]["name"].to_s
          user = User.new
          user.name = test["profile"]["name"]
          user.email = test["profile"]["email"]
          user.status = test["barcodes"].first["status"]
          user.save
        end
      end
    end
  end
end

  	# @object = JSON.load(open("https://www.eventbriteapi.com/v3/events/***REMOVED***/attendees/?token=54X654CD2AJ3XPAPM45B"))
  	# @attend = @object["attendees"];
  	# @attend.each do |test| 
  	#	user = User.new
  	#	user.name = test["profile"]["name"]
  	#	user.email = test["profile"]["email"]
		# user.save 
	  # end 