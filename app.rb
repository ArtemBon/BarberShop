#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS "Users"(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"username" TEXT,
		"phone" TEXT,
		"datestamp" TEXT,
		"barber" TEXT,
		"color" TEXT
	)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]

	errors = {
		:username => 'Введите имя',
		:phone => 'Введите телефон',
		:date_time => 'Введите дату и время'
	}

	errors.each do |key, value|

		if params[key] == ''
			@error = value
			return erb :visit
		end

	end


	users = File.open './public/users.txt', 'a'
	users.write "Name: #{@username}, Phone: #{@phone}, Date and time: #{@date_time}, Barber: #{@barber}, Color: #{@color}\n"
	users.close

	@message_visit = 'Спасибо, что записались. Мы Вас ждем!'

	erb :visit

end

post '/contacts' do

	@email = params[:email]
	@text = params[:textarea]

	errors = {
		email: 'Введите email',
		textarea: 'Введите сообщение'
	}

	errors.each do |key, value|

		if params[key] == ''
			@error = value
			return erb :contacts
		end

	end

	contacts = File.open './public/contacts.txt', 'a'
	contacts.write "Text: #{@text}; Email: #{@email}\n"
	contacts.close

	@message_contacts = 'Мы получили Ваше сообщение, обязательно Вам ответим'

	erb :contacts

end