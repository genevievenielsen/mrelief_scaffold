json.programs @programs do |program|
	json.name program.name_en
	json.description program.description_en
	json.category program.category
	json.link "https://www.mrelief.com/#{program.url}"
	json.chicago true
end