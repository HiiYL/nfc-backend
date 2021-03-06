class User < ActiveRecord::Base
	scope :sorted_by_status, -> {order(:status)}
	scope :last_updated, ->{order(updated_at: :desc)}
	scope :sort_by_name, ->{order(:name)}
end
public
def update_db
    EventbriteAPI::Configuration.access_token=ENV['ACCESS_KEY']
    @eb = EventbriteAPI.new
    @event = @eb.events(id:ENV['EVENT'])
    if Update.count < 1
      print "YOOOOOOOOOOOOOHOOOOOOOOOOOOOOOOOOO"
      @time = "2010-11-12T7:23:03Z"
      update = Update.new
      update.time = Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")
      update.save
    else
      @time = Update.first.time
      Update.first.update_attribute(:time, Time.now.strftime("%Y-%m-%dT%H:%M:%SZ"))
    end
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
          user.card_no = test["answers"].find{ |h| h["question_id"]=="8754207" }["answer"]
          user.student_id = test["answers"].find{ |h| h["question_id"]=="8693425" }["answer"]
          user.save
        else
          #if test["barcodes"].first["status"] == 'used' && user.status == 'unused'
          unless user.status == test["barcodes"].first["status"]
            user.update_attribute(:status, test["barcodes"].first["status"])
          end
          user.update_attributes(card_no: test["answers"].find{ |h| h["question_id"]=="8754207" }["answer"],
                                 student_id: test["answers"].find{ |h| h["question_id"]=="8693425" }["answer"])
        end
      end
    end 
  end
