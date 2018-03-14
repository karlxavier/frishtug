class ContactUsMailer < ApplicationMailer
  default from: 'contact_us_notifications@frishtug.com'

  def send_message(options = {})
    @first_name = options[:first_name]
    @last_name  = options[:last_name]
    @email      = options[:email]
    @message    = options[:message]

    mail(to: 'james@maddington.net',
      subject: "[Contact Us Page]Message from #{@first_name} #{@last_name}")
  end
end
