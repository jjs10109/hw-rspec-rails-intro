require 'rails_helper'
require 'spec_helper'

describe Movie do
  describe '.find_in_tmdb' do
    it 'calls TMDb' do
    fake_response = double(
      'response',
      body: '{"results":[]}'
    )

    expect(Faraday).to receive(:get).and_return(fake_response)

    Movie.find_in_tmdb({
      title: 'hacker',
      language: 'en'
    })
    end
    it 'calls TMDb with valid API key' do
      Movie.find_in_tmdb({ title: 'hacker', language: 'en' })
    end
  end
end