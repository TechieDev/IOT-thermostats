require 'rails_helper'

RSpec.describe 'Reading API', type: :request do
  let(:thermostat) { create(:thermostat) }
  let!(:readings) { create_list(:reading, 10, thermostat_id: thermostat.id) }
  let(:reading_id) { readings.first.id }
  # set headers for authorization
  let(:headers) { { 'Authorization' => token_generator(thermostat.household_token) } }
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe 'GET /readings/:id' do
    before { allow(request).to receive(:headers).and_return(headers) }

    context "when auth token is passed" do
      before { get api_v1_reading_url(reading_id), params: {}, headers: headers }

      context 'when the record exists' do
        it 'returns the reading' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(reading_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not exist' do
        let(:reading_id) { 100 }
        it 'returns nil' do
          expect(response.body).to eq("null")
        end
      end

    end

    # raises exception
    context 'When auth token is invalid' do
      it 'raises MissingToken error' do
        get api_v1_reading_url(reading_id), params: {}, headers: invalid_headers
        expect{ raise ExceptionHandler::MissingToken, 'Missing token' }.to raise_error
      end
    end
  end


  describe 'POST /readings' do
    before { allow(request).to receive(:headers).and_return(headers) }
    let(:valid_attributes) do
      # send json payload
      { thermostat_id: thermostat.id, seq_number: 55, temperature: 6.4, humidity: 45, battery_charge: 33 }
    end
    context "when auth token is passed" do
      context 'when request is valid' do
        before { post api_v1_readings_url, params: valid_attributes , headers: headers }

        it 'creates a reading' do
          expect(json['seq_number']).to eq(55)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        let(:invalid_attributes) do
          # send json payload
          { thermostat_id: thermostat.id, seq_number: 55, temperature: 6.4, humidity: 150, battery_charge: 33 }
        end

        before { post api_v1_readings_url, params: invalid_attributes, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(json['message'])
            .to match('Validation failed: Humidity must be less than or equal to 100')
        end
      end


    end

    # raises exception
    context 'When auth token is invalid' do
      it 'raises MissingToken error' do
        get api_v1_reading_url(reading_id), params: {}, headers: invalid_headers
        expect{ raise ExceptionHandler::MissingToken, 'Missing token' }.to raise_error
      end
    end
  end


end