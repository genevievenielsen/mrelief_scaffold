class ContactController < ApplicationController

  def index
    @message = {}
    @password = ENV['gmail_password']
  end

  def create
    hash = {
      :contact_first_name => params[:contact_first_name],
      :contact_last_name => params[:contact_last_name],
      :contact_email => params[:contact_email],
      :advertising_options => params[:advertising_options],
      :feedback => params[:feedback],
    }
    @message = Feedback.new(hash)



    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
      redirect_to( "/", :notice => "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

end
