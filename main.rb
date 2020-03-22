require 'sinatra'
#require_relative 'gambling'

configure do
  enable :sessions
  set :username, "Sophie" 
  set :password, "2020!"
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/gambling.db")
  DataMapper.auto_migrate!
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_migrate!
end

get '/' do
  erb :login
end

get '/login' do
  erb :login
end

post '/login' do
  if params[:username] == Gambling.first.username &&
     params[:password] == Gambling.first.password
     session[:admin] = true
     puts 15
     redirect to ('/bet')
  else
     erb :login
  end
end

post '/bet' do
  stake = params[:stake].to_i
  number = params[:number].to_i
  roll = rand(6)+1
  if number == roll
    if(!session[:lost])
      save_session(:lost, 0)
    end
    save_session(:win, 10*stake)
  else
    if(!session[:win])
      save_session(:win, 0)
    end
    save_session(:lost, stake)
  end
  @win = session[:win]
  @lost = session[:lost]
  @profit = session[:win] - session[:lost]
  erb :bet
end

get '/bet' do
  erb :bet
end


def save_session(win_lost, money)
  count = (session[win_lost] || 0).to_i
  count += money
  session[win_lost] = count
end

get '/logout' do
  model = Gambling.first
  if model
    model.update(win: model.win + session[:win])
    model.update(loss: model.loss + session[:lost])
    model.update(profit: model.profit + session[:win] - session[:lost])
  else
    model = Model.create(win: 0)
    model = Model.create(loss: 0)
    model = Model.create(profit: 0)
  end
  session.clear
  redirect to ('/login')
end

not_found do
  erb :notfound
end
