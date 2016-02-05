class ExampleMailer < ApplicationMailer

	require 'mailgun'

	def sample_email
	@add_things = Product.where(name: '')
    mg_client = Mailgun::Client.new ENV['api_key']
    message_params = {:from    => ENV['gmail_username'],
                      :to      => 'oyr.wishlist@gmail.com',
                      :subject => 'Wish-List 새로운 아이템 등록 알람',
                      :text    => @add_things.count.to_s + "개 등록대기중"}
    mg_client.send_message ENV['domain'], message_params
  end

end
