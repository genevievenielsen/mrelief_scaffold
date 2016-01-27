class ContactController < ApplicationController

  def index


  end

  def create

    @contact_first_name = params[:contact_first_name]
    @contact_last_name = params[:contact_last_name]
    @contact_email = params[:contact_email]
    @advertising_options = params[:advertising_options]
    @request = params[:request]
    @feedback = params[:feedback]


    if @feedback.present?
      NotificationsMailer.send_simple_message(@contact_first_name, @contact_last_name, @contact_email,
        @advertising_options, @request, @feedback).deliver
      NotificationsMailer.send_simple_message_to_rose(@contact_first_name, @contact_last_name, @contact_email,
        @advertising_options, @request, @feedback).deliver
      redirect_to :back, :notice => "Feedback was successfully sent. Thank you!"
    else
      flash.now.alert = "Please fill all fields."
      render :index
    end


  end



end
