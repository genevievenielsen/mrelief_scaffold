class EmailListMailer < ApplicationMailer

  def send_journalist_emails(publication, author, email)
    @publication = publication
    @author = author
    @email = email
    mail to: @email, from: ENV['genevieve_mrelief_email'], subject: 'City of Chicago and mRelief Launch Early Learning Finder!'
  end

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
