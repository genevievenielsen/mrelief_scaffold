class SetLanguageController < ApplicationController
  def english
    R18n.set('en')
  end

  def spanish
    R18n.set('es')
  end

  def polish
    R18n.set('pl')
  end
end
