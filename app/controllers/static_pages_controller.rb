require 'json'
require 'open-uri'
class StaticPagesController < ApplicationController
  def home
    @attendees = User.all.sorted_by_status
    @count = User.all.num_of_checkins
  end
  def refresh_db
    EventbriteAPI::Configuration.access_token="54X654CD2AJ3XPAPM45B"
    #EventbriteAPI::Configuration.access_token="***REMOVED***"
    @eb = EventbriteAPI.new
    #@event = @eb.events(id:***REMOVED***)
    @event = @eb.events(id:***REMOVED***)

    page_count = @event.attendees(status:"attending",changed_since:"2014-11-12T7:23:03Z").get.body["pagination"]["page_count"]
    for i in 1..page_count
      @attendees = @event.attendees(status:"attending",page:i,changed_since:"2014-11-12T7:23:03Z").get.body["attendees"]
      @attendees.each do |test| 
        unless User.find_by(name: test["profile"]["name"].to_s)
          user = User.new
          user.name = test["profile"]["name"]
          user.email = test["profile"]["email"]
          user.status = test["barcodes"].first["status"]
          user.save
        end
      end
    end
  end
  def update_db
    EventbriteAPI::Configuration.access_token="54X654CD2AJ3XPAPM45B"
    #EventbriteAPI::Configuration.access_token="***REMOVED***"
    @eb = EventbriteAPI.new
    #@event = @eb.events(id:***REMOVED***)
    @event = @eb.events(id:***REMOVED***)
    @time = User.db_last_updated.updated_at.utc
    @time = @time.strftime("%Y-%m-%dT%H:%M:%SZ")
    page_count = @event.attendees(status:"attending",changed_since:@time).get.body["pagination"]["page_count"]
    for i in 1..page_count
      @attendees = @event.attendees(status:"attending",changed_since:@time).get.body["attendees"]
      @attendees.each do |test| 
        unless user = User.find_by(name: test["profile"]["name"])
          user = User.new
          user.name = test["profile"]["name"]
          user.email = test["profile"]["email"]
          user.status = test["barcodes"].first["status"]
          user.save
        else
          user.update_attributes(status: test["barcodes"].first["status"])
        end
      end
    end
    redirect_to root_url
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