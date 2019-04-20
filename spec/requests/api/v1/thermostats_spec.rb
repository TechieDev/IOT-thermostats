require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::ThermostatsController, :type => :request do
  describe 'GET generate_auth_token' do
    let(:thermostat) { create(:thermostat) }
    # returns auth token when request is valid
    context 'When request is valid ' do
      it 'renders the thermostat based on household token and returns auth token' do
        allow(Thermostat).to receive(:find).and_return(thermostat)
        get generate_auth_token_api_v1_thermostats_url, params: { household_token: thermostat.household_token }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['thermostat']['household_token']).to eq(thermostat.household_token)
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    # raises exceptions
    context 'When request is invalid' do
      it 'raises MissingHouseholdToken error' do
        get generate_auth_token_api_v1_thermostats_url, params: { household_token: '' }
        expect{ controller.generate_auth_token }.
          to raise_error(ExceptionHandler::MissingHouseholdToken, 'Missing household token')
      end

      it 'raises InvalidHouseholdToken error' do
        get generate_auth_token_api_v1_thermostats_url, params: { household_token: 'lorem-ipsum' }
        expect{ controller.generate_auth_token }.
          to raise_error(ExceptionHandler::InvalidHouseholdToken, 'Invalid household token')
      end
    end
  end

  describe 'GET stats' do
    let(:thermostat) { create(:thermostat) }
    let!(:readings) { create_list(:reading, 10, thermostat_id: thermostat.id) }
    # set headers for authorization
    let(:headers) { { 'Authorization' => token_generator(thermostat.household_token) } }
    let(:invalid_headers) { { 'Authorization' => nil } }

    before(:each) do
      5.times.each do
        Reading::ReadingService.new(
          thermostat_id: thermostat.id,
          temperature: Faker::Number.decimal(2),
          humidity: Faker::Number.between(0, 100),
          battery_charge: Faker::Number.between(0, 100)
        ).save_obj
      end
    end

    context 'When request is valid' do
      before { allow(request).to receive(:headers).and_return(headers) }
      
      it 'returns the avg, min, max stats' do
        get stats_api_v1_thermostats_url, headers: headers

        expect(response).to have_http_status(:ok)
        hash_body = JSON.parse(response.body)
        expect(hash_body.keys).to match_array(reading_keys)
        expect(hash_body["temperature"].keys).to match_array(stats_keys)
      end
    end

  end
end

def reading_keys
  %w[temperature humidity battery_charge]
end

def stats_keys
  %w[avg min max]
end