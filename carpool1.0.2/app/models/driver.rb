class Driver < ActiveRecord::Base
	before_save { email.downcase! }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},
	format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}

end
