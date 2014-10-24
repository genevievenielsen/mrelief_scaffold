class PagesController < ApplicationController
  def homepage
    redirect_to 'http://mreliefv2.herokuapp.com/'
  end

  def about_us
  end

  def contact_us
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    advertising = params[:advertising]
    feedback = params[:feedback]

  end

  def how_mrelief_works

  end

end
