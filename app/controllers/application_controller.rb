class ApplicationController < Sinatra::Base
  # set :session_secret, "my_application_secret"
  # set :views, Proc.new { File.join(root, "../views/") }
  # set :public_folder, Proc.new { File.join(root, "static") }

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

  get '/contact' do
    erb :contact
  end

  # HELPERS
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
