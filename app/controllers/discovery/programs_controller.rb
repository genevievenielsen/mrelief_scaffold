class Discovery::ProgramsController < ApplicationController

	def index
		location = ["chicago", "illinois"]
		@programs = Program.where(location: location)
		render json: @programs
	end

end