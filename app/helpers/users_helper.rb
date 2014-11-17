module UsersHelper
	def hightlight_status(user)
		if user.status == 'unused'
			"danger"
		else
			"success"
		end
	end
end
