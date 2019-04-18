module Api
	module V1
		class ReadingsController < ApplicationController
			def show
				@reading = Reading.find_by(id: params[:id])
				json_response(@reading)
			end

			def create
				@reading = Reading.create!(reading_params)
		    json_response(@reading, :created)
		  end

			private

			def reading_params
        params.permit(:thermostat_id, :seq_number, :temperature, :humidity, :battery_charge )
      end
		end
	end
end