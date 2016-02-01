class ExampleMailer < ApplicationMailer

	require 'mailgun'

	def sample_email
    mg_client = Mailgun::Client.new ENV['api_key']
    message_params = {:from    => ENV['gmail_username'],
                      :to      => 'j1nye0jun@gmail.com',
                      :subject => 'Wish-List 새로운 아이템 등록 알람',
                      :text    => 'This mail is sent using Mailgun API via mailgun-ruby'}
    mg_client.send_message ENV['domain'], message_params
  end

end
