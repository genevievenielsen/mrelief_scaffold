class Feedback

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :contact_first_name, :contact_last_name, :contact_email, :advertising_options, :feedback, :subject

  validates :contact_first_name, :contact_last_name, :contact_email, :advertising_options, :feedback, :presence => true
  validates :contact_email, :format => { :with => %r{.+@.+\..+} }, :allow_blank => true

  def initialize(hash)
    hash.each do |name, value|
      send("#{name}=", value)
    end
   end

  def persisted?
    false
  end

end
