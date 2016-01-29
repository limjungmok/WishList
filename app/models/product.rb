class Product < ActiveRecord::Base
	belongs_to :user
	validates :url, presence: true

	attr_reader :avatar_remote_url

	def avatar_remote_url=(url_value)
		#self.avatar = URI.parse(url_value)
		self.avatar = open(url_value,
			"User-Agent" => "Chrome/12.0.742.105",
			"From" => "foo@bar.invalid",
			"Referer" => "http://www.ruby-lang.org/")
		@avatar_remote_url = url_value
	end


	has_attached_file :avatar, :styles => {
		#Width given, height automagically selected to preserve aspect ratio.
		:width => "291x", 
    	#Height given, width automagically selected to preserve aspect ratio.
    	:height => "x436"
    }
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
