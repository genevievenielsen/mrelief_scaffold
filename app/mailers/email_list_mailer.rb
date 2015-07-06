class EmailListMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.email_list_mailer.opt_in.subject
  #
  def opt_in(recipient_address, generated_hash)
		
    @email = recipient_address
    @generated_hash = generated_hash

    mail to: @email, from: 'rose@mrelief.com', subject: 'Please Confirm!'
  end

  def confirmed_email(validated_recipient)
    @email = validated_recipient

    mail to: @email, from: 'rose@mrelief.com', subject: 'Confirmation Received!'

  end
end
