case RAILS_ENV
when "development"
	Surveyor::site = "http://localhost:3001"
	Surveyor::version = "1.1"
	Surveyor::user = "root"
	Surveyor::password = "root"
when "production"
	Surveyor::site = "http://www.example.com"
	Surveyor::version = "1.1"
	Surveyor::user = "root"
	Surveyor::password = "root"
end