task :benefits_received => :environment do

	all_city_cleaned = []

	AllCityProgramDatum.where(:user_location => "king_community_service_center").each do |all_city|
		if all_city.created_at >= "January 14, 2015" && all_city.phone_number.present? && all_city.phone_number != "7777777" && all_city.snap_eligibility_status == "yes"
    	  all_city_cleaned.push(all_city)
    	end
	end

	puts "#{all_city_cleaned.count}"
end