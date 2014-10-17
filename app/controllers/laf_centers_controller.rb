require 'roo'
class LafCentersController < ApplicationController
  before_action :set_laf_center, only: [:show, :edit, :update, :destroy]

    def index
     ex = Roo::Excel.new("public/LAF_Spreadsheet.xls")
     ex.default_sheet = ex.sheets[0]
     2.upto(67) do | line |
     zipcode = ex.cell(line,'A')
     city = ex.cell(line,'B')
     center = ex.cell(line,'C')
     address = ex.cell(line,'D')
     contact = ex.cell(line,'E')
     telephone = ex.cell(line,'F')
     spanish = ex.cell(line,'G')

      @laf_center = LafCenter.create(:zipcode => zipcode, :city => city, :center => center, :address => address, :contact => contact,
      :telephone => telephone, :spanish => spanish)
    end
  end


end




    # l = LafCenter.all

    # l.each do |center|
    #   puts "LafCenter.create(:zipcode => '#{center.zipcode}', :city => '#{center.city}', :center => '#{center.center}',
    #     :address => '#{center.address}', :contact => '#{center.contact}', :telephone => '#{center.telephone}', :spanish => '#{center.spanish}')"
    # end

