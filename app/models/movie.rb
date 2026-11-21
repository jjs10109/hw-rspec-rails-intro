require 'cgi'
require 'json'

class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.find_in_tmdb(search_terms)
    title = search_terms[:title]
    language = search_terms[:language]
    release_year = search_terms[:release_year]

    url = "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{CGI.escape(title)}"

    if language.present? && language != 'all'
      url += "&language=#{language}"
    end

    if release_year.present?
      url += "&year=#{release_year}"
    end

    response = Faraday.get(url)
    results = JSON.parse(response.body)['results']

    results.map do |result|
      Movie.new(
        title: result['title'],
        rating: 'R',
        release_date: result['release_date']
      )
    end
  end
end