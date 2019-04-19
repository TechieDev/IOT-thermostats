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
end