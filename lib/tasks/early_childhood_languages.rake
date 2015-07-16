task :early_childhood_languages => :environment do

	require 'open-uri'
	require 'json'

	url = "https://data.cityofchicago.org/resource/ck29-hb9r.json"
	raw_data = open(url).read
	parsed_data = JSON.parse(raw_data)

	complete_languages_array = []

	parsed_data.each do |location|
		languages = location["languages_other_than_english"]
		if languages.present?
			if languages.include?(',')
				languages_array = languages.split(',')
				languages_array.each do |language|
					complete_languages_array.push(language.strip)
				end
			else
				complete_languages_array.push(languages.strip)
			end
		end
	end

	unique_languages_array = complete_languages_array.uniq
	unique_languages_array.sort.each do |language|
		puts "#{language}"
	end

end

