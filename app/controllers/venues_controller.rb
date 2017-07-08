class VenuesController < ApplicationController
  # enable :sessions
  # use Rack::Flash

  get '/venues' do
    @venues = Venue.order("lower(name)")
    erb :'/venues/venues_index'
  end

  # CREATE
  get '/venues/new' do
    # binding.pry
    if logged_in?
      erb :'/venues/create_venue'
    else
      redirect to '/venues'
    end
  end

  post '/venues/new' do
    if logged_in?
      if Venue.find_by(name: params[:name])
        flash[:message] = "Venue already exists."
        redirect to "venues/new"
      else
        @venue = Venue.create(name: params[:name])
        flash[:message] = "Successfully created venue!"
        redirect to "venues/#{@venue.id}"
      end
    else
      redirect to '/venues'
    end
  end

  # READ
  get '/venues/:id' do
    @venue = Venue.find_by(id: params[:id])
    erb :'/venues/show_venue'
  end

  # EDIT
  get '/venues/:id/edit' do
    if logged_in?
      @venue = Venue.find_by(id: params[:id])
      erb :'/venues/edit_venue'
    else
      redirect to '/venues'
    end
  end

  patch '/venues/:id' do
    if logged_in?
      @venue = Venue.find_by(id: params[:id])
      @venue.name = params[:name] if params[:name] != @venue.name  && !params[:name].empty?
      @venue.save
      flash[:message] = "Successfully updated venue!"
      redirect to "/venues/#{@venue.id}"
    else
      redirect to '/venues'
    end
  end

  # DELETE
  delete '/venues/:id/delete' do
    @user = current_user
    @venue = Venue.find_by(id: params[:id])
    if logged_in? && @user.authenticate(params[:password])
      @venue.destroy
      flash[:message] = "BALEETED!"
      redirect to '/venues'
    else
      flash[:message] = "Incorrect password. Could not delete artist."
      redirect to "/venues/#{@venue.id}/edit"
    end
  end

end
