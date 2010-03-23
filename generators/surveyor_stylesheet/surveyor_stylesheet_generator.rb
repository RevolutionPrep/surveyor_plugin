class SurveyorStylesheetGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "stylesheet.css", "public/stylesheets/surveyor.css"
    end
  end
end