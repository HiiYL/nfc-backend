class User < ActiveRecord::Base
	scope :sorted_by_status, -> {order(:status)}
	scope :num_of_checkins, ->{where(status: "used").count}
	scope :db_last_updated, ->{order(:updated_at).limit(1).first}
end
