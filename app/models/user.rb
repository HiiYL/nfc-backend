class User < ActiveRecord::Base
	scope :sorted_by_status, -> {order(:status)}
	scope :num_of_checkins, ->{where(status: "used").count}
end
