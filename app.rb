require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "barbershop.db" }

class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }
  validates :phone, presence: true
  validates :datestamp, presence: true
  validates :color, presence: true
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
  validates :email, presence: true
  validates :comment, presence: true
end

before do
  @list_barbers = Barber.all
end

get '/' do
  @barbers = Barber.order "created_at DESC"
  erb :index
end

get '/visit' do
  @new_client = Client.new
  erb :visit
end

post '/visit' do
  @new_client = Client.new params[:client]
  if @new_client.save
    erb "<h2>Спасибо Вы записались!</h2>"
  else
    @error = @new_client.errors.full_messages.first
    erb :visit
  end

=begin
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  new_client = Client.new({
    :name => @username,
    :phone => @phone,
    :datestamp => @datetime,
    :barber => @barber,
    :color => @color
  })
  new_client.save
  erb "#{@username} Вы были успешно записаны на время #{@datetime}"
=end
end

get '/contacts' do
  @contact = Contact.new
  erb :contacts
end

post '/contacts' do
  @contact = Contact.new params[:contact]
  if @contact.save
    erb "<h2>Ваше сообщение было принято!</h2>"
  else
    @error = @contact.errors.full_messages.first
    erb :contacts
  end

=begin
  @email = params[:email]
  @comments = params[:comments]
  new_comment = Contact.new({
    :email => @email,
    :comment => @comments
  })
  new_comment.save
  erb "Ваш запрос был успешно обработан #{@email}"
=end
end

get "/barber/:id" do
  @barber = Barber.find(params[:id])
  erb :barber
end

get '/bookings' do
  @clients = Client.order('created_at DESC')
  erb :bookings
end

get "/client/:id" do
  @client = Client.find(params[:id])
  erb :client
end
