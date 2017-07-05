class ShowsController < ApplicationController

  get '/shows' do
    @shows = Show.all
    erb :'/shows/shows_index'
  end

  # CREATE
  get '/shows/new' do
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
end