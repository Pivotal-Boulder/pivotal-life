require 'spec_helper'
require 'webmock'
include WebMock::API

describe ForecastFetcher do
  let(:api_key) { 'FAKE-API-KEY' }

  let(:forecast_fetcher) { ForecastFetcher.new api_key }

  let(:boulder_forecast_url) do
    'https://api.forecast.io/forecast/FAKE-API-KEY/40.01499,-105.27055?units=us'
  end

  before do
    stub_request(:get, boulder_forecast_url).to_return(:body => File.read('spec/fixtures/forecast/boulder.json'))
  end

  it 'collects forecast data for each location' do
    expect(forecast_fetcher.data[:boulder]).to eq({
      :current_temp=> '13°F',
      :current_icon=> 'partly-cloudy-day',
      :current_desc=> 'Mostly Cloudy',
      :apparent_temp=> '13°F',
      :later_desc=> 'Partly cloudy later this evening.',
      :later_icon=> 'partly-cloudy-day',
      :next_desc=> 'Mostly cloudy for the hour.',
      :next_icon=> 'partly-cloudy-day'
    })
  end
end
