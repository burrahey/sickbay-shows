class UsersController < ApplicationController

  # CREATE
  get '/signup' do
    erb :'/users/create_user'
  end

  post '/signup' do
    if !params[:username].empty? && !params[:email].empty? && !params[:password].empty? && params[:password] === params[:confirm_password] && !User.find_by(username: params[:username])
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      if @user.save
        session[:user_id] = @user.id
        flash[:message] = "Successfully created account!"
        erb :dashboard
      else
        flash[:message] = "Could not save user."
        erb :'/users/create_user'
      end
    else
      flash[:message] = "Something went wrong. Try again."
      erb :'/users/create_user'
    end
  end

  # READ?
  get '/login' do
    if !logged_in?
      erb :login
    else
      erb :dashboard
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:message] = "Successfully logged in!"
      erb :dashboard
    else
      flash[:message] = "Something went wrong. Try again."
      erb :login
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:message] = "Successfully logged out."
      erb :backdoor
    else
      redirect to '/'
    end
  end

  # UPDATE
  get '/settings' do
    if logged_in?
      @user = current_user
      erb :'/users/edit_user'
    else
      redirect to '/'
    end
  end

  patch '/settings' do
    @user = current_user
    if logged_in? && @user.authenticate(params[:password])
      if @user.username != params[:username] && !params[:username].empty?
        @user.username = params[:username]
      end
      if @user.email != params[:email] && !params[:email].empty?
        @user.email = params[:email]
      end
      @user.save
      flash[:message] = "Successfully updated user!"
      erb :'/users/edit_user'
    else
      flash[:message] = "Could not update user."
      erb :'/users/edit_user'
    end
  end

  patch '/password' do
    @user = current_user
    if logged_in? && @user.authenticate(params[:old_password]) && params[:password] === params[:confirm_password]
      @user.password = params[:password]
      @user.save
      flash[:message] = "Successfully updated password!"
      erb :dashboard
    else
      flash[:message] = "Could not update password."
      erb :'/users/edit_user'
    end
  end

  # DELETE
  delete '/users/:id/delete' do
    @user = current_user
    if logged_in? && @user.authenticate(params[:password])
      @user.destroy
      session.clear
      flash[:message] = "BALEETED!"
      erb :backdoor
    else
      flash[:message] = "Could not delete account."
      erb :'/users/edit_user'
    end
  end

end
