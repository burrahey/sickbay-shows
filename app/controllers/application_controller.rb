class ApplicationController < Sinatra::Base

  # CONFIGURE
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  # ROUTES
  get '/' do
    erb :index
  end

  get '/shows' do
    @shows = Show.all
    erb :'/shows/shows_index'
  end

  # CREATE
  get '/shows/new' do
    @style = polyfill_css
    erb :'/shows/create'
  end

  post '/shows/new' do
    binding.pry
    @venue = Venue.find_or_create_by(name: params[:venue])
    @show = Show.new(date: params[:date], venue: @venue)
    @show.url = params[:url] if !params[:url].empty?

    # add all artists if not empty
    params[:artists].each do |artist|
      if !artist.empty?
        artist_object = Artist.find_or_create_by(name: artist)
        @show.artists << artist_object
      end
    end

    @show.save
    redirect to "/shows/#{@show.id}"
  end

  # READ
  get '/shows/:id' do
    @show = Show.find_by(id: params[:id])
    if @show.nil?
      erb :'/shows/not_found'
    else
      erb :'/shows/show_show'
    end
  end

  get '/shows/archive' do
    erb :'/shows/archive'
  end

  # EDIT
  get '/shows/:id/edit' do
    @show = Show.find_by(id: params[:id])
    erb :'/shows/edit_show'
  end

  patch '/shows/:id' do
    @show = Show.find_by(id: params[:id])
    # binding.pry

    @show.date = params[:date] if params[:date] != @show.date
    @show.venue = Venue.find_or_create_by(name: params[:venue]) if params[:venue] != @show.venue.name
    @show.url = params[:url] if params[:url] != @show.url && !params[:url].empty?

    @show.artists.clear
    params[:artists].each do |artist|
      if !artist.empty?
        artist_object = Artist.find_or_create_by(name: artist)
        @show.artists << artist_object
      end
    end

    @show.save
    redirect to "/shows/#{@show.id}"
  end

  # DELETE
  delete '/shows/:id/delete' do
    @show = Show.find_by(id: params[:id])
    @show.destroy
    redirect to '/'
  end

  # HELPERS
  helpers do
    def polyfill_css
      <<~HTML
      <style>
            .datalist-polyfill {
            	list-style: none;
            	display: none;
            	background: white;
            	box-shadow: 0 2px 2px #999;
            	position: absolute;
            	left: 0;
            	top: 0;
            	margin: 0;
            	padding: 0;
            	max-height: 300px;
            	overflow-y: auto;
            }

            .datalist-polyfill:empty {
            	display: none !important;
            }

            .datalist-polyfill > li {
                padding: 3px;
                font: 13px "Lucida Grande", Sans-Serif;
            }

            .datalist-polyfill__active {
                background: #3875d7;
                color: white;
            }
          </style>
      HTML
    end # END polyfill_css

  end # END helpers

end
