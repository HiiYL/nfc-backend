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
  end
  def sort_by_name
    session[:sort]="sort_by_name"
    @users = User.all.send(session[:sort])
    respond_to do |format|
      format.html {render 'home'}
      format.js {}
    end
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
  def refresh
    #User.update_db
    if session[:sort].nil?
      @users = User.all
    else
      @users = User.all.send(session[:sort])
    end
    respond_to do |format|
      format.js {}
    end
  end
  def checkin
    #@users = User.all
    #render text: "WTF"
    @user = User.find_by(card_no: params[:id])
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
  def live_update
    @users = User.all
  end
  def nfc
      @@nfc_context ||= NFC::Context.new
      @@nfc_device ||= @@nfc_context.open nil
      @card_content = @@nfc_device.poll
      if @card_content.class == NFC::ISO14443A
        # Get the card serial no
        @uid = @card_content.uid.collect! { |x| x.to_s(16) }.reverse!.join.to_i(16).to_s.rjust(10, "0")
        # If the card is still on the reader we skip the loop
      end
      unless @uid.nil?
        @user = User.find_by(card_no: @uid)
        if @user
          if @user.status == "unused"
            @user.update_attribute(:status, "used")
            @status = 200
          else
            @status = 409
          end
        else
            @status = 404
        end
      else
        render :status => 500
      end
      respond_to do |format|
        format.js{}
      end
  end
  def taptapfront
    @@nfc_context ||= NFC::Context.new
    @@nfc_device ||= @@nfc_context.open nil
  end
end