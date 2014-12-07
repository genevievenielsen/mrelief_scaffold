class SetLanguageController < ApplicationController
  def english
    I18n.locale = 'en'
  end

  def spanish
    I18n.locale = 'es'
  end

  def polish
    I18n.locale = 'pl'
  end

  # private

  # def set_session_and_redirect
  #   session[:locale] = I18n.locale
  #   rediret_to :back
  # rescue ActionController::RedirectBackError
  #   redirect_to :root
  # end

end
