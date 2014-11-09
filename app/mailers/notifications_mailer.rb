class NotificationsMailer < ActionMailer::Base

   def send_simple_message(contact_first_name, contact_last_name, contact_email,
        advertising_options, request, feedback)

    RestClient.post "https://api:"+ ENV['mailgun_key'] +
    "@api.mailgun.net/v2/mrelief.com/messages",
    :from => "#{contact_email}",
    :to => ENV['mailgun_email'],
    :subject => "Feedback from #{contact_first_name} #{contact_last_name}",
    :text => "How did you hear about us - #{advertising_options}.  Request related to - #{request }.  Feedback - #{feedback}"


  end

  def send_simple_message_to_rose(contact_first_name, contact_last_name, contact_email,
        advertising_options, request, feedback)
      RestClient.post "https://api:"+ ENV['mailgun_key'] +
       "@api.mailgun.net/v2/mrelief.com/messages",
       :from => "#{contact_email}",
       :to => ENV['rose_email'],
       :subject => "Feedback from #{contact_first_name} #{contact_last_name}",
       :text => "How did you hear about us - #{advertising_options}.  Request related to - #{request }.  Feedback - #{feedback}"

  end
end


