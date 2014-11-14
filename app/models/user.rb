class User < ActiveRecord::Base
	scope :sorted_by_status, -> {order(:status)}
	scope :num_of_checkins, ->{where(status: "used").count}
	scope :last_updated, ->{order(:updated_at)}
end
<<<<<<< HEAD
public
def update_db
    EventbriteAPI::Configuration.access_token=ENV['ACCESS_KEY']
    @eb = EventbriteAPI.new
    @event = @eb.events(id:ENV['EVENT'])
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
=======
>>>>>>> d9c78844e02b966b3acae441271cfa2c433b2539
