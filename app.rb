require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'pry'

require_relative 'models/contact'
also_reload 'models/contact'

set :bind, '0.0.0.0'  # bind to all interfaces

get '/' do
  @contacts = Contact.limit(5)
  if params[:page].nil?
    @next_page = 1
    @last_page = 0
  end
  erb :index
end

get '/contacts' do
  current_offset = (params[:page].to_i) * 5
  @contacts = Contact.limit(5).offset(current_offset)
  @next_page = params[:page].to_i + 1
  if @next_page == 1
    @last_page = 0
  else
    @last_page = (params[:page].to_i) - 1
  end
  erb :index
end

get '/contacts/:id' do
  @contact = Contact.find(params[:id])
  erb :show
end

get '/search' do
  @first_name = params[:first_name]
  @last_name = params[:last_name]
  @contact = Contact.where(first_name: @first_name, last_name: @last_name)
  erb :search
end

get '/submit' do
  erb :submit
end

post '/submit' do
  @first_name = params[:first_name]
  @last_name = params[:last_name]
  @phone_number = params[:phone_number]
  Contact.create(first_name: @first_name, last_name: @last_name, phone_number: @phone_number)
  @contacts = Contact.all
  erb :submit
end
