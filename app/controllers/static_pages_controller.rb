require 'json'
require 'open-uri'
class StaticPagesController < ApplicationController
  if Rails.env == "production"
    http_basic_authenticate_with name: ENV['USER'], password: ['PASS']
  end
  def home
    if session[:test].nil?
      @users = User.all
    else
      @users =User.all.send(session[:test])
    end
    @count = User.all.num_of_checkins
  end
  def sort_by_changed_date
    session[:test] = "last_updated"
    @users = User.all.send(session[:test])
    respond_to do |format|
      format.html {render'home'}
      format.js {}
    end
  end
  def sort_by_status
    session[:test] = "sorted_by_status"
    @users = User.all.send(session[:test])
    respond_to do |format|
      format.html {render'home'}
      format.js {}
    end
  end
  def update_db
    #EventbriteAPI::Configuration.access_token="***REMOVED***"
    EventbriteAPI::Configuration.access_token="***REMOVED***"
    @eb = EventbriteAPI.new
    @event = @eb.events(id:***REMOVED***)
    #@event = @eb.events(id:***REMOVED***)
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
  def ajax
    update_db
    @users = User.all.send(session[:test])
    respond_to do |format|
      format.js {}
    end
  end
end