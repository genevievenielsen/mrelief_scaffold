# require 'roo'
class LafCentersController < ApplicationController
  before_action :set_laf_center, only: [:show, :edit, :update, :destroy]

    def index
     ex = Roo::Excel.new("public/early_learning_programs.xls")
     ex.default_sheet = ex.sheets[0]
     2.upto(22) do | line |
     agency = ex.cell(line,'A')
     funder = ex.cell(line,'B')
     site = ex.cell(line,'C')
     duration = ex.cell(line,'D')
     ages_served = ex.cell(line,'E')
     income_type = ex.cell(line,'F')
    
      @early_learning_program = EarlyLearningProgram.create(agency: agency, funder: funder, site: site, duration: duration, ages_served: ages_served, 
        income_type: income_type)
    end
  end

end

    e = EarlyLearningProgram.all

    e.each do |program|
      puts "EarlyLearningProgram.create(:agency => '#{program.agency}', :funder => '#{program.funder}', :site => '#{program.site}',
        :duration => '#{program.duration}', :ages_served => '#{program.ages_served}', :income_type => '#{program.income_type}')"
    end


    # l = LafCenter.all

    # l.each do |center|
    #   puts "LafCenter.create(:zipcode => '#{center.zipcode}', :city => '#{center.city}', :center => '#{center.center}',
    #     :address => '#{center.address}', :contact => '#{center.contact}', :telephone => '#{center.telephone}', :spanish => '#{center.spanish}')"
    # end

