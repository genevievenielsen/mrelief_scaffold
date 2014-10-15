class NotificationsMailer < ActionMailer::Base

  default :from => params[:email]
  default :to => "mrelief.form@gmail.com"

  def new_message(message)
    @message = message
    mail(:subject => "[mrelief.tld] #{message.subject}")
  end

end
