class ContactUsMailer < ApplicationMailer
  default from: 'contact_us_notifications@frishtug.com'

  def send_message(contact_us_message_id)
    @contact = ContactUsMessage.find(contact_us_message_id)
    mail(to: @contact.email,
      subject: "Thank you for contacting us")
  end
end
