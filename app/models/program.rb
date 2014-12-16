class Program < ActiveRecord::Base
  include R18n::Translated

  translations :name
  translations :description
end
