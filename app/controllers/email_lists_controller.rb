class EmailListsController < ApplicationController
require 'mailgun'

	def send_journalist_emails
		PressEmail.all.each do |press|
			if press.email.present?
				EmailListMailer.send_journalist_emails(press.publication_name, press.author_name, press.email).deliver
			end
		end
	end
  
	def opt_in
		email = params[:email]
		
		# First, instantiate the SDK with your API credentials, domain, and required parameters for example. 
		mg_client = Mailgun::Client.new(ENV["mailgun_secret_key"])
		mg_validate = Mailgun::Client.new(ENV["mailgun_public_key"])

		domain = 'mrelief.com'

		mailing_list = 'publictemplate_subscribers@mrelief.com'
		secret_app_id = ENV["SECRET_KEY_BASE"]
		recipient_address = email

		# Let's validate the customer's email address, using Mailgun's validation endpoint.
		# result = mg_validate.get('address/validate', {:address => recipient_address})

		# if result.present? || result[:body]["is_valid"] == true
		  # Next, generate a hash.
		  generated_hash = Mailgun::OptInHandler.generate_hash(mailing_list, secret_app_id, recipient_address)
		  # Finally, let's add the subscriber to a Mailing List, as unsubscribed, so we can track non-conversons.
		  EmailListMailer.opt_in(recipient_address, generated_hash).deliver

		  mg_client.post("lists/#{mailing_list}/members", {:address    => recipient_address, 
		                                                   :subscribed => 'no',
		                                                   :upsert     => 'yes'})
		  redirect_to( "/public-template", :notice => "Thank you for joining our email list. A confirmation email has been sent to you!")
		# else
		# 	redirect_to( "/landing_page#email-submit", :notice => "Please enter a valid email.")
		# end
	
	end

  def confirm_email
  	# First, instantiate the SDK with your API credentials and domain. 
  	mg_client = Mailgun::Client.new(ENV["mailgun_secret_key"])
  	domain = 'mrelief.com'

  	secret_app_id = ENV["SECRET_KEY_BASE"]
  	inbound_hash = params[:hash]
  	# Now, validate the captured hash.
  	hash_validation = Mailgun::OptInHandler.validate_hash(secret_app_id, inbound_hash)

  	# Lastly, check to see if we have results, parse, subscribe, and send confirmation.
  	if !hash_validation.nil?
  	    validated_list = hash_validation['mailing_list']
  	    validated_recipient = hash_validation['recipient_address']

  	    mg_client.put("lists/#{validated_list}/members/#{validated_recipient}", 
  	                            {:address    => validated_recipient, 
  	                             :subscribed => 'yes'})

  	    EmailListMailer.confirmed_email(validated_recipient).deliver
  	end
  	redirect_to( "/public-template", :notice => "Thank you for confirming your email and joining our mailing list!")

  end

end