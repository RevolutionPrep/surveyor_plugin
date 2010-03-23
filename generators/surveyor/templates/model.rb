class <%= singular_name.camelize %> < ActiveRecord::Base

  has_survey :api_key => "API_KEY"

end