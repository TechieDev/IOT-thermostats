require 'rails_helper'

RSpec.describe Reading, type: :model do
	let(:thermostat) { create(:thermostat) }
	subject { described_class.new(thermostat_id: thermostat.id, seq_number: 100, temperature: 34.90, humidity: 10, battery_charge: 40)}
	# validate presence
  it { should validate_presence_of(:thermostat) }
  it { should validate_presence_of(:seq_number) }
  it { should validate_presence_of(:temperature) }
  it { should validate_presence_of(:humidity) }
  it { should validate_presence_of(:battery_charge) }

  # validate numericality
  it { should validate_numericality_of(:temperature) }
  it { should validate_numericality_of(:humidity) }
  it { should validate_numericality_of(:battery_charge) }

  # validate uniqueness
  it { should validate_uniqueness_of(:seq_number) }


  describe '#Validations' do
  	context 'when validation fails with invalid attributes' do

  	 context 'when validation fails if sequence number is less than or equal to 0' do
	  	 it 'fails if sequence number is  0' do
	  	  subject.seq_number = 0
	  	  expect(subject).to_not be_valid
	  	 end

	  	 it 'fails if sequence number is  less than 0' do
	  	  subject.seq_number = -2
	  	  expect(subject).to_not be_valid
	  	 end
  	 end

  	 context 'when validation fails if humidity is less than 0 or greater than 100' do
	  	 it 'fails if humidity is  less than 0' do
	  	  subject.humidity = -1
	  	  expect(subject).to_not be_valid
	  	 end

	  	 it 'fails if humidity is  greater than 100' do
	  	  subject.humidity = 101
	  	  expect(subject).to_not be_valid
	  	 end
  	 end

  	 context 'when validation fails if battery charge is less than 0 or greater than 100' do
	  	 it 'fails if battery charge is  less than 0' do
	  	  subject.battery_charge = -1
	  	  expect(subject).to_not be_valid
	  	 end

	  	 it 'fails if battery charge is  greater than 100' do
	  	  subject.battery_charge = 101
	  	  expect(subject).to_not be_valid
	  	 end
  	 end


    end
  end

  it "saves reading" do
    thermostat = create(:thermostat)
    reading = Reading.new(thermostat: thermostat, seq_number: 1, temperature: 12.5, humidity: 23.6, battery_charge: 85.4 )
    reading.save
    expect(Reading.first).to eq(reading)
  end


  it "belongs to thermostat" do
  	thermostat = create(:thermostat) 
  	reading = create(:reading, thermostat_id: thermostat.id) 
  	expect(thermostat.readings.first).to eq(reading)
  end

end
