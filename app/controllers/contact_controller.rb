class ContactController < ApplicationController

  def index
    @message = Feedback.new
  end

  def create
    @message = Feedback.new(params[:message])
    @message.contact_first_name = params[:contact_first_name]
    @message.contact_last_name = params[:contact_last_name]
    @message.contact_email = params[:contact_email]
    @message.advertising_options = params[:advertising_options]
    @message.feedback = params[:feedback]



    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

end
