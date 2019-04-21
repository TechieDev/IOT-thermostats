module Api
	module V1
		class ReadingsController < ApplicationController
			include RedLock::LockManager
			before_action :reading_buiilder, only: :create

			def show
        reading = Reading::ReadingObj.new(id: params[:id]).find_obj
        if reading.blank? || reading['thermostat_id'] != @current_thermostat.id
        	raise(ExceptionHandler::NotAllowed, Message.forbidden)
        else 
        	json_response(reading)
        end
      end

			def create

				lock(action: 'create_reading', object: @current_thermostat, ttl: 200000) do
					if @reading.save_obj
						@reading_obj = @reading.reading 
			    	json_response(@reading_obj, :created)
			    else
			    	json_response({ errors: @reading.reading.reading_obj.errors.messages }, :unprocessable_entity)
			    end
        end
		  end

			private

			def reading_params
        params.permit(:thermostat_id, :seq_number, :temperature, :humidity, :battery_charge )
      end

      def reading_buiilder
        @reading = Reading::ReadingService.new(
          thermostat_id: @current_thermostat.id,
          temperature: params[:temperature],
          humidity: params[:humidity],
          battery_charge: params[:battery_charge]
        )
      end
		end
	end
end