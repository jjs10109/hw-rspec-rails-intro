require 'rails_helper'

describe MoviesController, type: :controller do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end

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

    describe 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)

        get :search_tmdb, params: {
          title: 'hardware',
          release_year: '',
          language: 'all'
        }
      end

      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('search_tmdb')
      end

      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
    end
    describe 'adding a movie' do
      let(:movie_params) do
        {
        title: 'Sydney 2000 Olympics Opening Ceremony',
        rating: 'R',
        release_date: '2000-09-15'
        }
      end

      it 'adds the movie to the database' do
        expect {
        post :add_movie, params: movie_params
        }.to change(Movie, :count).by(1)
      end

      it 'redirects to the search page' do
        post :add_movie, params: movie_params

        expect(response).to redirect_to(search_path)
      end

      it 'displays a success message' do
        post :add_movie, params: movie_params

        expect(flash[:notice]).to eq(
        'Sydney 2000 Olympics Opening Ceremony was successfully added to RottenPotatoes.'
        )
      end
    end
  end
end