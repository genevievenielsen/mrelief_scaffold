class ContactController < ApplicationController

  def index
    @message = Feedback.new
  end

  def create
    @message = Feedback.new(params[:message])

    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

end
