class SurveyorGenerator < Rails::Generator::NamedBase

	def manifest
		record do |m|
			m.template "controller.rb", "app/controllers/#{plural_name}_controller.rb"
			m.template "model.rb", "app/models/#{singular_name}.rb"
			m.directory "app/views/#{plural_name}"
			m.template "new_view.rb", "app/views/#{plural_name}/new.html.erb"
			m.directory "db/migrate"
			m.template "migration.rb", "db/migrate/#{Time.now.utc.strftime('%Y%m%d%H%M%S_create_') + plural_name}.rb"
			m.file "initializer.rb", "config/initializers/surveyor.rb"
		end
	end

end