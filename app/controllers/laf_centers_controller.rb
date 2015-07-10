# require 'roo'
class LafCentersController < ApplicationController
  before_action :set_laf_center, only: [:show, :edit, :update, :destroy]

    def index
     ex = Roo::Excel.new("public/wic_locations.xls")
     ex.default_sheet = ex.sheets[0]
     2.upto(17) do | line |
     address = ex.cell(line,'A')
     city = ex.cell(line,'B')
     state = ex.cell(line,'C')
     zipcode = ex.cell(line,'D')
     phone_number = ex.cell(line,'E')
    
      @wic_location = WicLocation.create(address: address, city: city, state: state, zipcode: zipcode, phone_number: phone_number)
    end
  end

end

    # w = WicLocation.all
    # w.each do |location|
    #     puts "WicLocation.create(address: '#{location.address}', city: '#{location.city}', state: '#{location.state}', zipcode: '#{location.zipcode}', phone_number: '#{location.phone_number}')"
    # end

    # e = EarlyLearningProgram.all

    # e.each do |program|
    #   puts "EarlyLearningProgram.create(:agency => '#{program.agency}', :funder => '#{program.funder}', :site => '#{program.site}',
    #     :duration => '#{program.duration}', :ages_served => '#{program.ages_served}', :income_type => '#{program.income_type}',
    #     :additional_criteria => '#{program.additional_criteria}', :description => '#{program.description}')"
    # end


    # l = LafCenter.all

    # l.each do |center|
    #   puts "LafCenter.create(:zipcode => '#{center.zipcode}', :city => '#{center.city}', :center => '#{center.center}',
    #     :address => '#{center.address}', :contact => '#{center.contact}', :telephone => '#{center.telephone}', :spanish => '#{center.spanish}')"
    # end

