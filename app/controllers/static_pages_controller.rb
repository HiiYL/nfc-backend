require 'json'
require 'open-uri'
class StaticPagesController < ApplicationController
  if Rails.env == "production"
    http_basic_authenticate_with name: ENV['USER'], password: ENV['PASS']
  end
  def home
    if session[:sort].nil?
      @users = User.all
    else
      @users =User.all.send(session[:sort])
    end
    @count = User.all.num_of_checkins
  end
  def sort_by_changed_date
    session[:sort] = "last_updated"
    @users = User.all.send(session[:sort])
    respond_to do |format|
      format.html {render'home'}
      format.js {}
    end
  end
  def sort_by_status
    session[:sort] = "sorted_by_status"
    @users = User.all.send(session[:sort])
    respond_to do |format|
      format.html {render'home'}
      format.js {}
    end
  end
  def ajax
    User.update_db
    @users = User.all.send(session[:sort])
    respond_to do |format|
      format.js {}
    end
  end
  def checkin
    #@users = User.all
    #render text: "WTF"
    @user = User.find_by(uid: params[:id])
    print "DEBUG"
    print params[:id]
    #render @user
        if @user
          if @user.status == "unused"
            @user.update_attribute(:status, "used")
            hash = {status: 200, content: @user.name}
          else
            hash = {status: 409}
          end
        else
          hash = {status: 404}
        end
        render json:hash
  end
end