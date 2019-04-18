require 'rails_helper'

describe 'Routes', :type => :routing do

  it 'routes /readings to Routes Controller' do
    expect(get: 'api/v1/readings/1').to route_to('api/v1/readings#show', id: '1')
    expect(post: 'api/v1/readings').to route_to('api/v1/readings#create')
  end

  it 'routes /thermostats to Routes Controller' do
    expect(get: 'api/v1/thermostats/generate_auth_token').to route_to('api/v1/thermostats#generate_auth_token')
    expect(get: 'api/v1/thermostats/stats').to route_to('api/v1/thermostats#stats')
  end
end