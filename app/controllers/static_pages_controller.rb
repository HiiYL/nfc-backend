require 'json'
require 'open-uri'
class StaticPagesController < ApplicationController
  def home
    @users = User.all
    @count = User.all.num_of_checkins
  end
  def sort_by_changed_date
    @users = User.all.last_updated
    render 'home'
  end
  def sort_by_status
    @users = User.all.sorted_by_status
    render 'home'
  end
  def refresh_db
    EventbriteAPI::Configuration.access_token="54X654CD2AJ3XPAPM45B"
    #EventbriteAPI::Configuration.access_token="***REMOVED***"
    @eb = EventbriteAPI.new
    #@event = @eb.events(id:***REMOVED***)
    @event = @eb.events(id:***REMOVED***)
    page_count = @event.attendees(status:"attending",changed_since:"2010-11-12T7:23:03Z").get.body["pagination"]["page_count"]
    for i in 1..page_count
      @attendees = @event.attendees(status:"attending",page:i,changed_since:"2010-11-12T7:23:03Z").get.body["attendees"]
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
    EventbriteAPI::Configuration.access_token="***REMOVED***"
    #EventbriteAPI::Configuration.access_token="***REMOVED***"
    @eb = EventbriteAPI.new
    #@event = @eb.events(id:***REMOVED***)
    @event = @eb.events(id:***REMOVED***)
    if User.count > 0
      @time = User.last_updated.first.updated_at.utc
      @time = @time.strftime("%Y-%m-%dT%H:%M:%SZ")
    else
      @time = "2010-11-12T7:23:03Z"
    end
    print "HELOOOOOOOOOOOOOOOOOOOO" + @time
    page_count = @event.attendees(status:"attending",changed_since:@time).get.body["pagination"]["page_count"]
    for i in 1..page_count
      @attendees = @event.attendees(status:"attending",page:i,changed_since:@time).get.body["attendees"]
      @attendees.each do |test| 
        unless user = User.find_by(name: test["profile"]["name"])
          user = User.new
          user.name = test["profile"]["name"]
          user.email = test["profile"]["email"]
          user.status = test["barcodes"].first["status"]
          user.save
        else
          #if test["barcodes"].first["status"] == 'used' && user.status == 'unused'
          unless user.status == test["barcodes"].first["status"]
            user.update_attribute(:status, test["barcodes"].first["status"])
          end
        end
      end
    end 
  end
  def ajax_verify
    user = User.first
    respond_to do |format|
      format.js
    end
  end
  def ajax
    update_db
    @users = User.all
    respond_to do |format|
      format.js
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